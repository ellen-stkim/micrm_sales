package com.omnilab.micrm.service.impl

import com.monitorjbl.xlsx.StreamingReader
import com.omnilab.micrm.common.*
import com.omnilab.micrm.config.error.CouponException
import com.omnilab.micrm.model.Contents_lstDto
import com.omnilab.micrm.model.CouponIssueDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.model.table.mdm.CjMms_msgDto
import com.omnilab.micrm.model.table.mdm.LgMms_msgDto
import com.omnilab.micrm.repository.CampaignDao
import com.omnilab.micrm.repository.CouponDao
import com.omnilab.micrm.service.CouponIssueService
import org.apache.poi.hssf.usermodel.HSSFWorkbook
import org.apache.poi.ss.usermodel.Workbook
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.http.HttpStatus
import org.springframework.stereotype.Service
import org.springframework.web.multipart.MultipartFile
import java.time.LocalDateTime
import java.util.*
import kotlin.collections.ArrayList
import kotlin.collections.HashMap

@Service("CouponIssueServiceImpl")
class CouponIssueServiceImpl: CouponIssueService {

    val logger = LoggerFactory.getLogger(this::class.java)

    val couponDomainGrpId = "COUPON_DOMAIN"

    @Autowired
    private lateinit var couponDao: CouponDao

    @Autowired
    @Qualifier("CampaignDaoImpl")
    private lateinit var campaignDao: CampaignDao

    @Autowired
    private lateinit var naverShortUrl: NaverShortUrl

    override fun issueCoupon(couponIssueDto: CouponIssueDto) {
        if (couponIssueDto.msg_title.isNullOrBlank()) throw CouponException(HttpStatus.BAD_REQUEST, "메시지 제목을 입력해주세요.")

        val user = UsefulUtils.sessionUser()
        var sendCnt = 0

        // 쿠폰 seq 복호화 decode
        couponIssueDto.coupon_seq = decodingSeq(couponIssueDto.encodedCouponSeq.toString())

        // 쿠폰 메시지 내용 개행
        couponIssueDto.msg_content = couponIssueDto.msg_content!!.replace("&lt;br/&gt;", "\n")

        // 발신 번호 조회
        val searchDto = Tblmi_set_lstDto()
        searchDto.usr_grp_cd = user.usr_grp_cd
        searchDto.list_tp_id = "CH02"
        searchDto.list_dt_id = "DMTP02"
        couponIssueDto.send_phone = couponDao.selectDefaultSendNumber(searchDto)

        // 도메인 조회
        val couponDomain = couponDao.selectCouponDomain(Tblmi_comm_cdDto(couponDomainGrpId, user.usr_grp_cd!!))

        // Path
        val couponPath = "/mobileCoupon/"

        // coupon issue
        couponIssueDto.usr_grp_cd = user.usr_grp_cd
        couponIssueDto.reg_id = user.usr_id
        couponDao.insertCouponIssue(couponIssueDto)

        // 문자 메시지 DB 조회
        val mdmDBDto = couponDao.selectCommCd(Tblmi_comm_cdDto("MDM_DB", user.usr_grp_cd!!))

        // Naver API 정보 조회
        val naverApiId = couponDao.selectCommCd(Tblmi_comm_cdDto("NAVER_APP", user.usr_grp_cd!!, "ID"))
        val naverApiSecret = couponDao.selectCommCd(Tblmi_comm_cdDto("NAVER_APP", user.usr_grp_cd!!, "SECRET"))


        // 쿠폰 전송
        val refinePhoneNumberList = refinePhoneNumber(couponIssueDto)
        if (refinePhoneNumberList.isEmpty()) throw CouponException(HttpStatus.BAD_REQUEST, "쿠폰 발행 대상을 입력해주세요.")

        val issuedLogList: MutableList<Tblmicou_coupon_issued_logDto> = ArrayList()

        for (receiveNumber in refinePhoneNumberList) {
            val msgList = ArrayList<Any>()
            // uuid 생성
            val couponUuid = makeUuidUrl()

            // 암호화된 uuid
            val encodedUuid = makeEncodedUuidUrl(couponUuid)

            var sendUrl = "${couponDomain}${couponPath}${encodedUuid}"

            // Naver short Url 에러 또는 오류 시 원본 url 반환
            sendUrl = naverShortUrl.shorten(sendUrl, naverApiId.cd_val ?: "", naverApiSecret.cd_val ?: "")

            // {쿠폰링크} -> shortUrl 치환
            val msgContent = couponIssueDto.msg_content!!.replace("{쿠폰링크}", sendUrl)

            // mms 전송
            val msgtp = "DMCH203"
            var msgKey = ""
            if (mdmDBDto.cd_desc == "CJ") {
                val msgDto = CjMms_msgDto(couponIssueDto.msg_title, receiveNumber, couponIssueDto.send_phone, "1",
                    LocalDateTime.now().toString(), msgContent, "0",
                    "", "", "", // todo 추후 content로 관리하면 이부분 추가 요망
                    mdmDBDto.cd_val, user.usr_grp_cd)
                msgList.add(msgDto)
                couponDao.insertCouponIssueMsgCj(msgList)
                msgKey = msgDto.msgkey.toString()
            } else {
                val msgDto = LgMms_msgDto(couponIssueDto.msg_title, receiveNumber, couponIssueDto.send_phone, "0",
                    LocalDateTime.now().toString(), msgContent, "0",
                    "", "", "", // todo 추후 content로 관리하면 이부분 추가 요망
                    mdmDBDto.cd_val, "MICRM_SALES", user.usr_grp_cd)
                msgList.add(msgDto)
                couponDao.insertCouponIssueMsgLg(msgList)
                msgKey = msgDto.msgkey.toString()
            }

            // coupon issue log
            val dto = Tblmicou_coupon_issued_logDto(
                msgKey, // todo 추후 content로 관리하면 tblmicp_send_hst seq 저장 필요
                msgtp, // todo 제거 필요
                couponIssueDto.seq!!,
                couponUuid,
                sendUrl,
                receiveNumber,
                user.usr_id,
                user.usr_grp_cd
            )

            issuedLogList.add(dto)

            sendCnt++
        }
        couponDao.insertCouponIssuedLog(issuedLogList)

        // 쿠폰 발급 target Count 입력
        couponDao.updateCouponIssueTargetCount(couponIssueDto.seq!!, sendCnt)
    }

    override fun createCouponIssuedLogAtSales(dto: Tblmicp_campaignDto, contTpLst: MutableMap<String, Contents_lstDto>, couponSendUrl: String): Tblmicou_coupon_issued_logDto {
        // 1. 도메인
        val couponDomain = couponDao.selectCouponDomain(Tblmi_comm_cdDto(couponDomainGrpId, dto.usr_grp_cd!!))
        // 2. Path
        var couponPath = "/mobileCoupon/"
        //3. 쿠폰 발급 조회 tblmicp_cont_mst의 시퀀스로 조회
        val couponIssueDto = couponDao.selectCouponIssue(dto.cont_id.toString())
        // 4. uuid
        val couponUuid = makeUuidUrl()
        val encodedUuid = makeEncodedUuidUrl(couponUuid)
        var sendUrl = "${couponDomain}${couponPath}${encodedUuid}"

        // Naver API 정보 조회
        val naverApiId = couponDao.selectCommCd(Tblmi_comm_cdDto("NAVER_APP", dto.usr_grp_cd.toString(), "ID"))
        val naverApiSecret = couponDao.selectCommCd(Tblmi_comm_cdDto("NAVER_APP", dto.usr_grp_cd.toString(), "SECRET"))

        // 6. Naver Short URL
        sendUrl = naverShortUrl.shorten(sendUrl, naverApiId.cd_val ?: "", naverApiSecret.cd_val ?:"")

        val contDto = contTpLst["DMTP02"]!!
        contTpLst["DMTP02"]!!.cont_body = contDto.cont_body!!.replace("{쿠폰링크}", couponSendUrl)

        return Tblmicou_coupon_issued_logDto(
            couponIssueDto.seq!!,
            couponUuid,
            sendUrl,
            dto.reg_id,
            dto.usr_grp_cd.toString()
        )
    }

    override fun createCouponLink(map: MutableMap<String, Any>): Tblmicou_coupon_issued_logDto? {
        //컨텐츠 마스터 정보
        val avo_id = map["activityId"].toString()
        val inten_id = map["journeyId"].toString()
        val contMstDto = Tblmicp_cont_mstDto()
        contMstDto.avo_id = avo_id
        contMstDto.inten_id = inten_id
        val contMst = campaignDao.sel_camp_cont_mst(contMstDto)
        if (contMst == null) {
            return null
        }

        //캠페인 정보
        val cDto = Tblmicp_campaignDto()
        cDto.cont_id = contMst.seq
        val campLst = campaignDao.sel_tblmicp_campaign(cDto)
        if (campLst.isEmpty()) {
            return null
        }

        for (campaignDto in campLst) {
            //컨텐츠 리스트
            val contLst = campaignDao.sel_tblmicp_cont_lst(Tblmicp_cont_lstDto(campaignDto.cont_id, campaignDto.reg_id, campaignDto.usr_grp_cd))
            val contTpLst = HashMap<String, Contents_lstDto>()
            for (check in contLst) {
                contTpLst[check.cont_tp.toString()] = check
            }
            val isCouponSend = contTpLst["DMTP02"] != null && !contTpLst["DMTP02"]?.coupon_seq.isNullOrBlank()
            if (isCouponSend) {
                // 1. 도메인
                val couponDomain = couponDao.selectCouponDomain(Tblmi_comm_cdDto(couponDomainGrpId, campaignDto.usr_grp_cd!!))
                // 2. Path
                var couponPath = "/mobileCoupon/"
                // 3. 쿠폰 발급 조회 tblmicp_cont_mst의 시퀀스로 조회
                val couponIssueDto = couponDao.selectCouponIssue(campaignDto.cont_id.toString())
                // 4. uuid
                val couponUuid = makeUuidUrl()
                val encodedUuid = makeEncodedUuidUrl(couponUuid)
                var sendUrl = "${couponDomain}${couponPath}${encodedUuid}"

                // Naver API 정보 조회
                val naverApiId = couponDao.selectCommCd(Tblmi_comm_cdDto("NAVER_APP", campaignDto.usr_grp_cd.toString(), "ID"))
                val naverApiSecret = couponDao.selectCommCd(Tblmi_comm_cdDto("NAVER_APP", campaignDto.usr_grp_cd.toString(), "SECRET"))

                // 6. Naver Short URL
                sendUrl = naverShortUrl.shorten(sendUrl, naverApiId.cd_val ?: "", naverApiSecret.cd_val ?:"")
                return Tblmicou_coupon_issued_logDto(
                    couponIssueDto.seq!!,
                    couponUuid,
                    sendUrl,
                    campaignDto.reg_id,
                    campaignDto.usr_grp_cd.toString()
                )
            }
        }

        return null
    }

    override fun issueCouponAtSales(couponIssuedLogDto: Tblmicou_coupon_issued_logDto, hst_seq: String) {
        couponIssuedLogDto.msgkey = hst_seq
        couponIssuedLogDto.msgtp = "" // todo 제거 필요
        couponDao.insertCouponIssuedLog(listOf(couponIssuedLogDto))
    }

    override fun extractPhoneNumberToExcel(file: MultipartFile): MutableMap<String, Any> {

        if (file.isEmpty) {
            logger.error("CouponIssueServiceImpl.extractPhoneNumberToExcel={}", "엑셀 파일 없음")
            throw CouponException(HttpStatus.BAD_REQUEST, "엑셀 파일이 없습니다.")
        }

        // excel 파일 형식확인
        if (!isExcelFile(file)) {
            logger.error("CouponIssueServiceImpl.extractPhoneNumberToExcel={}", "사용자 첨부한 엑셀 형식 아님")
            throw CouponException(HttpStatus.BAD_REQUEST, "엑셀 형식이 맞지 않습니다.")
        }
        return extractExcel(file)
    }

    override fun deleteCouponIssuedLog(deleteCouponIssuedLogSeq: MutableList<String>) {
        var decodedSeqList : MutableList<Int> = ArrayList()

        deleteCouponIssuedLogSeq.forEach { decodedSeqList.add(decodingSeq(it)) }

        couponDao.deleteCouponIssuedLog(decodedSeqList, UsefulUtils.sessionUser().usr_id!!)
    }

    private fun refinePhoneNumber(couponIssueDto: CouponIssueDto): MutableList<String> {
        val receiveNumberList: MutableList<String> = ArrayList()

        couponIssueDto.phoneNumberList!!.forEach {
            it.split(",").forEach { num -> if (num.isNotEmpty()) receiveNumberList.add(num) }
        }

        return receiveNumberList
    }

    private fun makeUuidUrl(): String {
        val uuid = UUID.randomUUID()

        return CommonUtils.toUnsignedString(uuid.mostSignificantBits, 6) + CommonUtils.toUnsignedString(uuid.mostSignificantBits, 6)
    }

    private fun makeEncodedUuidUrl(uuidUrl: String) = AES256.AES_Encode(uuidUrl, GlobalValues.encKey)

    private fun decodingSeq(encodedSeq: String) = AES256.AES_Decode(encodedSeq, GlobalValues.encKey).toInt()

    private fun isExcelFile(file: MultipartFile): Boolean {
        // content-type 검사
        val xlsxContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        val xlsContentType = "application/vnd.ms-excel"

        // 확장자 검사
        val extPos = file.originalFilename!!.lastIndexOf(".")
        val ext = file.originalFilename!!.substring(extPos + 1)

        return ((xlsxContentType == file.contentType) || (xlsContentType == file.contentType)) &&
                ((ext == "xlsx") || (ext == "xls"))
    }

    private fun extractExcel(file: MultipartFile): MutableMap<String, Any> {
        val reMap: MutableMap<String, Any> = HashMap()

        var workbook: Workbook? = null

        var collectCnt = 0
        var duplicateCnt = 0
        var errorCnt = 0
        val reSet: MutableSet<String> = HashSet()

        try {
            // StreamingReader 사용 으로 OOM 방지
            if (file.contentType == "application/vnd.ms-excel") {
                workbook = HSSFWorkbook(file.inputStream)
            } else {
                workbook = StreamingReader.builder()
                    .rowCacheSize(100)
                .bufferSize(4096)
                    .open(file.inputStream) as Workbook
            }

            val sheet = workbook?.getSheetAt(0)
            for (row in sheet!!) {
                if (row != null) {

                    var extractedPhoneNumber = CommonUtils.Excel_cell_value(row.getCell(0))?.trim() ?: ""
                    extractedPhoneNumber = extractedPhoneNumber.replace(("[^\\d.]").toRegex(), "")
                    // 핸드폰 번호, null, empty 검사
                    if (extractedPhoneNumber.isEmpty() ||  !UsefulUtils.isCheckPhoneNumber(extractedPhoneNumber)) {
                        errorCnt ++
                        continue
                    }
                    // 중복 핸드폰 체크
                    if (reSet.contains(extractedPhoneNumber)) {
                        duplicateCnt ++
                        continue
                    }

                    collectCnt ++
                    reSet.add(extractedPhoneNumber)
                }
            }
        } catch (e: Exception) {
            logger.error("CouponIssueServiceImpl.extractExcel={}", "엑셀 추출 오류")
            throw CouponException(HttpStatus.BAD_REQUEST, "엑셀 내용의 형식이 맞지 않습니다.")
        } finally {
            workbook?.close()
        }

        reMap["phoneNumberList"] = reSet.toList()
        reMap["collectCnt"] = collectCnt
        reMap["duplicateCnt"] = duplicateCnt
        reMap["errorCnt"] = errorCnt

        return reMap
    }

}