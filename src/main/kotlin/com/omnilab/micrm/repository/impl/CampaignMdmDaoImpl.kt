package com.omnilab.micrm.repository.impl

import com.omnilab.micrm.common.AES256
import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.GlobalValues
import com.omnilab.micrm.common.NaverShortUrl
import com.omnilab.micrm.model.Contents_lstDto
import com.omnilab.micrm.model.CouponIssueDto
import com.omnilab.micrm.model.table.Tblmicp_campaignDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.model.table.mdm.CjMms_msgDto
import com.omnilab.micrm.model.table.mdm.LgMms_msgDto
import com.omnilab.micrm.model.table.mdm.LgSc_tranDto
import com.omnilab.micrm.repository.CampaignSendDao
import org.apache.ibatis.session.SqlSession
import org.json.simple.JSONObject
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Repository
import java.util.*
import kotlin.collections.ArrayList

@Repository("CampaignMdmDaoImpl")
class CampaignMdmDaoImpl : CampaignSendDao {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    private lateinit var sqlSession: SqlSession

    override fun ins_send(dto: Tblmicp_campaignDto, contTpLst: MutableMap<String, Contents_lstDto>, map: MutableMap<String, Any>): Int {
        var cnt = 0

        val contDto = contTpLst["DMTP02"]!!

        // 문자 발송 서버 정보
        val mdminfo = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("MDM_DB", dto.usr_grp_cd.toString()))

        val mdmDb = mdminfo.cd_val
        val mdmServerType = mdminfo.cd_desc

        // 트래킹 URL 정보
        val trackURL = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("TRACKURL", dto.usr_grp_cd.toString())).cd_val
        // 이미지 저장 경로
        val imgPath = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("IMG_PATH", dto.usr_grp_cd.toString())).cd_val

        // 콘텐츠 정보
        val searchCont = Tblmicp_cont_lstDto()
        searchCont.cont_cd = dto.cont_id
        val contentDto = sqlSession.selectOne<Contents_lstDto>("sel_tblmicp_cont_lst", searchCont)
        // 콘텐츠 URL 리스트 정보Quorum 개념
        val urlDto = Tblmicp_cont_url_lstDto()
        urlDto.cont_lst_cd = contentDto.seq
        val contentUrlLst = sqlSession.selectList<Tblmicp_cont_url_lstDto>("sel_tblmicp_cont_url_lst", urlDto)
        for (urlLst in contentUrlLst) {
            urlLst.url = CommonUtils.EscapeTextToHtml(urlLst.url)
        }
        // 메세지 타입
        val msgTp = contDto.msg_tp
        // 발송 리스트
        val sendLst = ArrayList<Any>()

        try {
            var targetSubject = contDto.cont_sub
            var targetBody = CommonUtils.EscapeTextToHtml(contDto.cont_body)

            val HstSeq = map["SEND_HST_SEQ"].toString()

            // 제목 , 내용 치환
            for (key in map.keys) {
                targetSubject = targetSubject?.replace("{{$key}}", CommonUtils.stringValueOf(map[key]))
                targetBody = targetBody?.replace("{{$key}}", CommonUtils.stringValueOf(map[key]))
            }
            /**
             * 쿠폰 로직
             * 1. 도메인
             * 2. Path
             * 3. 쿠폰 발급
             * 4. uuid
             * 5. encoded UUID
             * 6. Naver short URL
             * -------
             * 7. 문자 발송
             * -------
             * 8. 쿠폰 발급 내역
             * 9. 쿠폰 발급 타겟 수
             */
            var couponIssuedLogDto = Tblmicou_coupon_issued_logDto()
            if (!contTpLst["DMTP02"]!!.coupon_seq.isNullOrEmpty()) {
                // 1. 도메인
                var couponDomain: String = sqlSession.selectOne("select_coupon_domain", Tblmi_comm_cdDto("COUPON_DOMAIN", dto.usr_grp_cd.toString()))
                // 2. Path
                var couponPath = "/mobileCoupon/"
                // 3. 쿠폰 발급 조회
                var couponIssueDto: CouponIssueDto = sqlSession.selectOne("select_coupon_issue", dto.cont_id.toString())

                // 4. uuid
                val uuid = UUID.randomUUID()
                val couponUuid = CommonUtils.toUnsignedString(uuid.mostSignificantBits, 6) + CommonUtils.toUnsignedString(uuid.mostSignificantBits, 6)
                // 5. uuid 암호화
                val encodedUuid = AES256.AES_Encode(couponUuid, GlobalValues.encKey)
                var sendUrl = "${couponDomain}${couponPath}${encodedUuid}"

                // 6. Naver Short URL
                // Naver short Url
                val jsonObject = NaverShortUrl.shorten(sendUrl)
                if (jsonObject["code"] != null && jsonObject["code"] == "200") {
                    val resultJson: JSONObject = jsonObject["result"] as JSONObject
                    sendUrl = resultJson["url"].toString()
                }
//                else {
//                logger.error("CouponIssueServiceImpl.issueCoupon={}", "네이버 URL 오류")
//                throw CouponException(HttpStatus.INTERNAL_SERVER_ERROR, "서버에 문제가 생겼습니다. 관리자에게 문의 바랍니다.")
//                }

                targetBody = targetBody.replace("{쿠폰링크}", sendUrl)

                couponIssuedLogDto = Tblmicou_coupon_issued_logDto(
                    couponIssueDto!!.seq!!,
                    couponUuid,
                    sendUrl,
                    map["SEND_TO"].toString(),
                    dto.reg_id,
                    dto.usr_grp_cd.toString()
                )

            }


            // URL to TrackURL
            if (!contentUrlLst.isNullOrEmpty()) {
                for (urlLst in contentUrlLst) {
                    val url = urlLst.url!!
                    targetBody = targetBody.replaceFirst(("\\{\\{"
                                        + url.replace("(", "\\(")
                                            .replace(")", "\\)")
                                            .replace("{", "\\{")
                                            .replace("}", "\\}")
                                            .replace("[", "\\[")
                                            .replace("]", "\\]")
                                            .replace("*", "[*]")
                                            .replace("+", "[+]")
                                            .replace("$", "[&]")
                                            .replace("|", "[|]")
                                            .replace("?", "[?]")
                                            + "\\}\\}")
                                        .toRegex()
                            , "$trackURL/s/m/${AES256.AES_Encode(HstSeq + "/" + urlLst.seq.toString(), GlobalValues.encKey)}")

                }
            }
            if ("DMCH202" == msgTp) { // lms
                if(mdmServerType == "CJ"){
                    val mdmDto = CjMms_msgDto(targetSubject, map["SEND_TO"].toString(), contDto.send_to, "1", dto.start_dt, targetBody, "0", dto.pro_id, dto.seq.toString(), map["SEND_HST_SEQ"].toString(), mdmDb, dto.usr_grp_cd)
                    mdmDto.file_cnt = 1
                    sendLst.add(mdmDto)
                    sqlSession.insert("ins_camp_send_mms_cj", sendLst)
                }else{
                    sendLst.add(LgMms_msgDto(targetSubject, map["SEND_TO"].toString(), contDto.send_to, "0", dto.start_dt, targetBody, "0", dto.pro_id, dto.seq.toString(), map["SEND_HST_SEQ"].toString(), mdmDb, "MICRM_SALES", dto.usr_grp_cd))
                    sqlSession.insert("ins_camp_send_mms_lg", sendLst)
                }
            } else if ("DMCH203" == msgTp) { //mms
                val contentsLstDto = contDto
                if(mdmServerType == "CJ"){
                    val mdmDto = CjMms_msgDto(targetSubject, map["SEND_TO"].toString(), contDto.send_to, "1", dto.start_dt, targetBody, "0", dto.pro_id, dto.seq.toString(), map["SEND_HST_SEQ"].toString(), mdmDb, dto.usr_grp_cd)
                    if (contentsLstDto.img_nm_lst.isNullOrBlank()) {
                        mdmDto.file_cnt = 1
                    }else{
                        val list = contentsLstDto.img_nm_lst!!.split(",")
                        mdmDto.file_cnt = list.size + 1
                        for (i in list.indices) {
                            when (i) {
                                0 -> {
                                    mdmDto.file_type1 = "I"
                                    mdmDto.file_path1 = imgPath + list[i]
                                }
                                1 -> {
                                    mdmDto.file_type2 = "I"
                                    mdmDto.file_path2 = imgPath + list[i]
                                }
                                2 -> {
                                    mdmDto.file_type3 = "I"
                                    mdmDto.file_path3 = imgPath + list[i]
                                }
                                3 -> {
                                    mdmDto.file_type4 = "I"
                                    mdmDto.file_path4 = imgPath + list[i]
                                }
                                4 -> {
                                    mdmDto.file_type5 = "I"
                                    mdmDto.file_path5 = imgPath + list[i]
                                }
                            }
                        }
                    }
                    sendLst.add(mdmDto)
                    sqlSession.insert("ins_camp_send_mms_cj", sendLst)
                }else{
                    val mdmDto = LgMms_msgDto(targetSubject, map["SEND_TO"].toString(), contDto.send_to, "0", dto.start_dt, targetBody, "0", dto.pro_id, dto.seq.toString(), map["SEND_HST_SEQ"].toString(), mdmDb, "MICRM_SALES", dto.usr_grp_cd)
                    if (!contentsLstDto.img_nm_lst.isNullOrBlank()) {
                        val list = contentsLstDto.img_nm_lst!!.split(",")
                        mdmDto.file_cnt = list.size
                        for (i in list.indices) {
                            when (i) {
                                0 -> mdmDto.file_path1 = imgPath + list[i]
                                1 -> mdmDto.file_path2 = imgPath + list[i]
                                2 -> mdmDto.file_path3 = imgPath + list[i]
                                3 -> mdmDto.file_path4 = imgPath + list[i]
                                4 -> mdmDto.file_path5 = imgPath + list[i]
                            }
                        }
                    }
                    sendLst.add(mdmDto)
                    sqlSession.insert("ins_camp_send_mms_lg", sendLst)
                }
            } else {  // sms
                sendLst.add(LgSc_tranDto(dto.start_dt, "0", "0", map["SEND_TO"].toString(), contDto.send_to, targetBody, dto.pro_id, dto.seq.toString(), map["SEND_HST_SEQ"].toString(), mdmDb, "MICRM_SALES"))
                sqlSession.insert("ins_camp_send_sms_lg", sendLst)
            }

            // 8.쿠폰 발급 내역
            if (!contTpLst["DMTP02"]!!.coupon_seq.isNullOrEmpty()) {
                var msgkey = ""
                val map = mapOf("etc3" to HstSeq, "m_server" to mdmDb)

                if ("DMCH202" == msgTp || "DMCH203" == msgTp) { // lms, mms
                    msgkey = sqlSession.selectOne("sel_camp_send_mms_lg", map)
                } else {  // sms
                    msgkey = sqlSession.selectOne("sel_camp_send_sms_lg", map)
                }
                couponIssuedLogDto.msgkey = msgkey
                couponIssuedLogDto.msgtp = msgTp
                sqlSession.insert("insert_coupon_issued_log", couponIssuedLogDto)


//                // 9. 쿠폰 발급 타겟 수
//                val mapUpdateTarget = mapOf(
//                    "seq" to couponIssuedLogDto.coupon_issue_seq,
//                    "target_cnt" to 1
//                )
//                sqlSession.update("update_coupon_issue_target_count", mapUpdateTarget)
            }

            cnt++
        } catch (e: Exception) {
            logger.error("ins_sendMdm", e)
            sendLst.clear()
            throw Exception()
        }
        return cnt
    }

    override fun upd_send(map: MutableMap<String, Any>): Int {
        val cnt: Int

        val mdmInfo = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("MDM_DB", map["usr_grp_cd"].toString()))
        val mdmServerType = mdmInfo.cd_desc
        map["db"] = mdmInfo.cd_val!!
        if(map["msgTp"] == "DMCH202" || "DMCH203" == map["msgTp"]){
            if(mdmServerType == "CJ"){
                cnt = sqlSession.update("upd_mms_send_cj", map)
            }else{
                cnt = sqlSession.update("upd_mms_send_lg", map)
            }
        }else{
            if(mdmServerType == "CJ"){
                cnt = sqlSession.update("upd_sms_send_cj", map)
            }else{
                cnt = sqlSession.update("upd_sms_send_lg", map)
            }
        }
        return cnt
    }

    override fun del_send(map: MutableMap<String, Any>): Int {
        val cnt: Int

        map["db"] = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("MDM_DB", map["usr_grp_cd"].toString())).cd_val!!
        if(map["msgTp"] == "DMCH202" || "DMCH203" == map["msgTp"]){
            cnt = sqlSession.update("del_mms_send_lg", map)
        }else{
            cnt = sqlSession.update("del_sms_send_lg", map)
        }
        return cnt
    }
}