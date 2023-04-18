package com.omnilab.micrm.service.impl

import com.monitorjbl.xlsx.StreamingReader
import com.omnilab.micrm.common.*
import com.omnilab.micrm.config.error.CouponException
import com.omnilab.micrm.model.CouponIssueDto
import com.omnilab.micrm.model.table.Tblmi_comm_cdDto
import com.omnilab.micrm.model.table.Tblmi_set_lstDto
import com.omnilab.micrm.model.table.Tblmicou_coupon_issued_logDto
import com.omnilab.micrm.repository.CouponDao
import com.omnilab.micrm.service.CouponIssueService
import org.apache.poi.ss.usermodel.Workbook
import org.json.simple.JSONObject
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.stereotype.Service
import org.springframework.web.multipart.MultipartFile
import java.util.*
import kotlin.collections.ArrayList
import kotlin.collections.HashMap

@Service
class CouponIssueServiceImpl: CouponIssueService {

    val logger = LoggerFactory.getLogger(this::class.java)

    val grp_id = "COUPON_DOMAIN"

    @Autowired
    private lateinit var couponDao: CouponDao

    override fun issueCoupon(couponIssueDto: CouponIssueDto) {
        val user = UsefulUtils.sessionUser()
        var sendCnt = 0

        // 쿠폰 seq 복호화 decode
        couponIssueDto.coupon_seq = decodingSeq(couponIssueDto.encodedCouponSeq.toString())

        // 발신 번호 조회
        val searchDto = Tblmi_set_lstDto()
        searchDto.usr_grp_cd = user.usr_grp_cd
        searchDto.list_tp_id = "CH02"
        searchDto.list_dt_id = "DMTP02"
        couponIssueDto.send_phone = couponDao.selectDefaultSendNumber(searchDto)

        // 도메인 조회
        val couponDomain = couponDao.selectCouponDomain(Tblmi_comm_cdDto(grp_id, user.usr_grp_cd!!))

        // Path
        val couponPath = "/mobileCoupon/"

        // coupon issue
        couponIssueDto.reg_id = user.usr_id
        couponDao.insertCouponIssue(couponIssueDto)
        for (receiveNumber in extractPhoneNumber(couponIssueDto)) {
            // uuid 생성
            val couponUuid = makeUuidUrl()

            // 암호화된 uuid
            val encodedUuid = makeEncodedUuidUrl(couponUuid)

            val sendUrl = "${couponDomain}${couponPath}${encodedUuid}"

            val jsonObject = NaverShortUrl.shorten(sendUrl)
            if (jsonObject["code"] != "200") {
                logger.error("CouponIssueServiceImpl.issueCoupon={}", "네이버 URL 오류")
                throw CouponException(HttpStatus.INTERNAL_SERVER_ERROR, "서버에 문제가 생겼습니다. 관리자에게 문의 바랍니다.")
            }

            val resultJson: JSONObject = jsonObject["result"] as JSONObject
            val shortUrl = resultJson["url"].toString()

            // mms 전송
            // todo mms 전송 필요
            val msgkey = "1"

            // coupon issue log
            val dto = Tblmicou_coupon_issued_logDto(
                msgkey,
                couponIssueDto.seq!!,
                couponUuid,
                shortUrl,
                receiveNumber,
                user.usr_id
            )
            couponDao.insertCouponIssuedLog(dto)

            sendCnt++
        }

        // 쿠폰 발급 target Count 입력
        couponDao.updateCouponIssueTargetCount(couponIssueDto.seq!!, sendCnt)
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

    private fun extractPhoneNumber(couponIssueDto: CouponIssueDto): MutableList<String> {
        val receiveNumberList: MutableList<String> = ArrayList()

        couponIssueDto.phoneNumberList!!.forEach {
            val split = it.split(",")
            split.forEach { num -> if (num.isNotEmpty()) receiveNumberList.add(num) }
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

        val result = (xlsxContentType == file.contentType) || (xlsContentType == file.contentType) &&
                (ext == "xlsx") || (ext == "xls")

        return result
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
            workbook = StreamingReader.builder()
                .rowCacheSize(100)
                .bufferSize(4096)
                .open(file.inputStream)

            val sheet = workbook.getSheetAt(0)

            for (row in sheet!!) {
                if (row != null) {

                    var extractedPhoneNumber = CommonUtils.Excel_cell_value(row.getCell(0))?.trim() ?: ""
                    extractedPhoneNumber = extractedPhoneNumber.replace(("[^\\d.]").toRegex(), "")

                    if (extractedPhoneNumber.isEmpty() ||  !UsefulUtils.isCheckPhoneNumber(extractedPhoneNumber)) {
                        errorCnt ++
                        continue
                    }
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