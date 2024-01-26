package com.omnilab.micrm.repository.impl

import com.omnilab.micrm.common.AES256
import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.GlobalValues
import com.omnilab.micrm.model.table.edm.Camp_send_edm_tableDto
import com.omnilab.micrm.model.Contents_lstDto
import com.omnilab.micrm.model.table.Tblmicp_campaignDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.model.table.rcs.LgRcs_imgDto
import com.omnilab.micrm.repository.CampaignSendDao
import org.apache.ibatis.session.ResultContext
import org.apache.ibatis.session.ResultHandler
import org.apache.ibatis.session.SqlSession
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Repository

@Repository("CampaignEdmDaoImpl")
class CampaignEdmDaoImpl : CampaignSendDao {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    private lateinit var sqlSession: SqlSession

    override fun ins_send(dto: Tblmicp_campaignDto, contTpLst: MutableMap<String, Contents_lstDto>, map: MutableMap<String, Any>): Int {
        var cnt = 0

        // 일반 메일 발송 서버 정보
        val nomalMailLst = sqlSession.selectList<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("COMMON", "MAIL_DB_NOMAL"))
        // 속도 제한 메일 발송 서버 정보
        val etcMailLst = sqlSession.selectList<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("COMMON", "MAIL_DB_ETC"))
        // 속도 제한 메일 리스트
        val sLst = sqlSession.selectList<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("SLOWMAILLIST"))
        val slowLst = ArrayList<String>()
        if (!sLst.isNullOrEmpty()) {
            for (sd in sLst) {
                slowLst.add(sd.cd_id!!)
            }
        }

        // 트래킹 URL 정보
        val trackURL = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("TRACKURL", dto.usr_grp_cd!!)).cd_val
        // 수신거부 링크 정보
        val supURL = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("SUPURL", dto.usr_grp_cd!!)).cd_val
        // 브라우저 링크 정보
        val brURL = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("BRURL", dto.usr_grp_cd!!)).cd_val
        // 리턴패스 정보
        val returnPath = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("RETURN_PATH", dto.usr_grp_cd!!)).cd_val

        // 콘텐츠 정보
        val searchCont = Tblmicp_cont_lstDto()
        searchCont.cont_cd = dto.cont_id
        val contentDto = sqlSession.selectOne<Contents_lstDto>("sel_tblmicp_cont_lst", searchCont)
        // 콘텐츠 URL 리스트 정보
        val urlDto = Tblmicp_cont_url_lstDto()
        urlDto.cont_lst_cd = contentDto.seq
        val contentUrlLst = sqlSession.selectList<Tblmicp_cont_url_lstDto>("sel_tblmicp_cont_url_lst", urlDto)
        for (urlLst in contentUrlLst) {
            urlLst.url = CommonUtils.EscapeTextToHtml(urlLst.url)
        }

        val sendNomalLst = ArrayList<Camp_send_edm_tableDto>()
        val sendEtcLst = ArrayList<Camp_send_edm_tableDto>()

        val listTbl: String?
        when (dto.send_tg_tp) {
            "TEST" -> listTbl = "tblmite_target_lst"
            "TG02" -> listTbl ="tblmi_target_lst"
            else -> listTbl= null
        }

        sqlSession.select("sel_tblmicp_send_hst", Tblmicp_send_hstDto(dto.pro_id, dto.seq, listTbl, "Y"), object : ResultHandler<Any> {
            var nomal = 0
            var etc = 0
            var nomal_per = 0
            var etc_per = 0
            var n_size: Int = nomalMailLst.size
            var e_size: Int = etcMailLst.size

            override fun handleResult(resultContext: ResultContext<*>) {
                try {
                    nomal = nomal_per % n_size
                    etc = etc_per % e_size

                    var targetSubject = contentDto.cont_sub
                    var targetBody = CommonUtils.EscapeTextToHtml(contentDto.cont_body)
                    var targetBodyTop = contentDto.cont_top_body

                    val map = resultContext.resultObject as HashMap<String, Any>
                    val HstSeq = map["SEND_HST_SEQ"].toString()

                    // 제목 , 내용 치환
                    for (key in map.keys) {
                        val reg = Regex("\\{\\{(?i)${key}}}")
                        targetSubject = targetSubject?.replace(reg, CommonUtils.stringValueOf(map[key]))
                        targetBody = targetBody?.replace(reg, CommonUtils.stringValueOf(map[key]))
                        targetBodyTop = targetBodyTop?.replace(reg, CommonUtils.stringValueOf(map[key]))
                    }

                    // URL to TrackURL
                    if (!contentUrlLst.isNullOrEmpty()) {
                        for (urlLst in contentUrlLst) {
                            val url = urlLst.url!!
                            targetBody = targetBody.replaceFirst(("(?i)href=('|\")"
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
                                    .replace("?", "[?]") + "('|\")")
                                    .toRegex(), "href='$trackURL/e/${AES256.AES_Encode(HstSeq + "/" + urlLst.seq.toString(), GlobalValues.encKey)}'")
                        }
                    }

                    // 브라우저 보기 추가
                    if (!contentDto.br_yn.isNullOrBlank() && contentDto.br_yn == "Y") {
                        targetBody = brURL?.replace("{{BRURL}}", "$trackURL/br/${AES256.AES_Encode(HstSeq + "/" + dto.cont_id, GlobalValues.encKey)}") + targetBody
                    }

                    // 오픈 트래킹 이미지
                    val sb = StringBuilder()
                    sb.append("<img border='0' width='1' height='1' src='$trackURL/op/${AES256.AES_Encode(HstSeq, GlobalValues.encKey)}' style='display:none'/>")

                    // 수신거부 추가
                    if (!contentDto.sup_yn.isNullOrBlank() && contentDto.sup_yn == "Y") {
                        sb.append(supURL?.replace("{{SUPURL}}", "$trackURL/sup/${AES256.AES_Encode(HstSeq, GlobalValues.encKey)}"))
                    }
                    sb.append("</div>")

                    targetBody = targetBody.replace("(?i)</body>".toRegex(), "</body>")
                    if (targetBody.contains("</body>")) {
                        sb.append("</body>")
                        targetBody = targetBody.replace("</body>", sb.toString())
                    } else {
                        targetBody += sb.toString()
                    }

                    // 메일 발송 저장
                    val sdto = Camp_send_edm_tableDto()
                    sdto.program_id = dto.pro_id
                    sdto.camp_id = dto.seq.toString()
                    sdto.contents_seq = dto.cont_id.toString()
                    sdto.send_target_seq = map["SEND_HST_SEQ"].toString()
                    sdto.send_year = dto.start_dt!!.split("-")[0]
                    sdto.send_month = sdto.send_year + dto.start_dt!!.split("-")[1]
                    sdto.mail_to = map["SEND_TO"].toString()
                    sdto.domain = sdto.mail_to!!.substring(sdto.mail_to!!.indexOf("@") + 1).toLowerCase()
                    sdto.send_reg_time = dto.start_dt

                    sdto.mail_title = targetSubject
                    sdto.mail_body = targetBody
                    sdto.from_name = contentDto.send_nm
                    sdto.from_to = contentDto.send_to
                    sdto.reply_to = null
                    sdto.usr_email = dto.reg_id
                    sdto.usr_grp_cd = dto.usr_grp_cd
                    sdto.return_path = "noreply${sdto.camp_id}${sdto.send_target_seq}@${returnPath}"
                    sdto.ab = dto.ab_gb
                    sdto.gubun = "99"
                    if (slowLst.contains(sdto.domain!!)) {
                        sdto.m_server = etcMailLst[etc].cd_val
                        sendEtcLst.add(sdto)
                    } else {
                        sdto.m_server = nomalMailLst[nomal].cd_val
                        sendNomalLst.add(sdto)
                    }

                    cnt++

                    if (sendEtcLst.isNotEmpty() && (sendEtcLst.size % 1000) == 0) {
                        sqlSession.insert("ins_camp_send_edm", sendEtcLst)
                        sendEtcLst.clear()
                        etc_per++
                    }

                    if (sendNomalLst.isNotEmpty() && (sendNomalLst.size % 1000) == 0) {
                        sqlSession.insert("ins_camp_send_edm", sendNomalLst)
                        sendNomalLst.clear()
                        nomal_per++
                    }
                } catch (e: Exception) {
                    logger.error("ins_sendEdm", e)
                    throw Exception()
                }
            }
        })
        if (sendNomalLst.isNotEmpty()) {
            sqlSession.insert("ins_camp_send_edm", sendNomalLst)
            sendNomalLst.clear()
        }
        if (sendEtcLst.isNotEmpty()) {
            sqlSession.insert("ins_camp_send_edm", sendEtcLst)
            sendEtcLst.clear()
        }
        return cnt
    }

    override fun upd_send(map: MutableMap<String, Any>): Int {
        var cnt = 0
        // 일반 메일 발송 서버 정보
        val nomalMailLst = sqlSession.selectList<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("COMMON", "MAIL_DB_NOMAL"))
        // 속도 제한 메일 발송 서버 정보
        val etcMailLst = sqlSession.selectList<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("COMMON", "MAIL_DB_ETC"))

        for (upDto in nomalMailLst) {
            map["db"] = upDto.cd_val!!
            cnt = sqlSession.update("upd_mail_send", map)
        }
        for (upDto in etcMailLst) {
            map["db"] = upDto.cd_val!!
            cnt = sqlSession.update("upd_mail_send", map)
        }
        return cnt
    }

    override fun del_send(map: MutableMap<String, Any>): Int {
        var cnt = 0
        // 일반 메일 발송 서버 정보
        val nomalMailLst = sqlSession.selectList<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("COMMON", "MAIL_DB_NOMAL"))
        // 속도 제한 메일 발송 서버 정보
        val etcMailLst = sqlSession.selectList<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("COMMON", "MAIL_DB_ETC"))

        for (upDto in nomalMailLst) {
            map["db"] = upDto.cd_val!!
            cnt = sqlSession.update("del_mail_send", map)
        }
        for (upDto in etcMailLst) {
            map["db"] = upDto.cd_val!!
            cnt = sqlSession.update("del_mail_send", map)
        }
        return cnt
    }

}