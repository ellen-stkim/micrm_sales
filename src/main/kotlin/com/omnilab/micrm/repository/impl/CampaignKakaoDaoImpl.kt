package com.omnilab.micrm.repository.impl

import com.omnilab.micrm.common.AES256
import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.GlobalValues
import com.omnilab.micrm.model.Contents_lstDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.model.table.kakao.Kko_msgDto
import com.omnilab.micrm.repository.CampaignSendDao
import org.apache.ibatis.session.ResultContext
import org.apache.ibatis.session.ResultHandler
import org.apache.ibatis.session.SqlSession
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Repository
import java.util.*
import kotlin.collections.ArrayList


@Repository("CampaignKakaoDaoImpl")
class CampaignKakaoDaoImpl : CampaignSendDao {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    private lateinit var sqlSession: SqlSession

    override fun ins_send(dto: Tblmicp_campaignDto, contTpLst: MutableMap<String, Contents_lstDto>, map: MutableMap<String, Any>): Int {
        var cnt = 0

        val mdmCont = contTpLst["DMTP02"]
        val kakaoCont = contTpLst["DMTP03"]!!
        val rcsCont = contTpLst["DMTP04"]

        // 카카오 발송 서버 정보
        val kakaoDbDto = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("KAKAO_DB", dto.usr_grp_cd!!))
        val kakaoDb = kakaoDbDto.cd_val
        //val kakaoDbType = kakaoDbDto.cd_desc
        val kakaoSenderNo = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("KAKAO_KEY", dto.usr_grp_cd!!)).cd_desc
        //고객사 ID
        val kakaoClientId = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("KAKAO_ID", dto.usr_grp_cd!!)).cd_val

        if(kakaoClientId.isNullOrEmpty()){
            return cnt
        }

        // 문자 발송 서버 정보
        val mdmDbDto = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("MDM_DB", dto.usr_grp_cd!!))
        val mdmDb = mdmDbDto.cd_val
        val mdmDbType = mdmDbDto.cd_desc

        // RCS 발송 서버 정보
        val rcsDbDto = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("RCS_DB", dto.usr_grp_cd!!))
        val rcsDb = rcsDbDto.cd_val

        // 트래킹 URL 정보
        val trackURL = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("TRACKURL", dto.usr_grp_cd!!)).cd_val
        // 이미지 저장 경로
        val imgPath = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("IMG_PATH", dto.usr_grp_cd!!)).cd_val
        // RCS 브랜드 ID
        val rcsBrnID = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("RCS_BRND_ID", dto.usr_grp_cd!!)).cd_val

        // 카카오 콘텐츠 URL 리스트 정보
        val urlDto = Tblmicp_cont_url_lstDto()
        urlDto.cont_lst_cd = kakaoCont.seq
        val kakaoContUrlList = sqlSession.selectList<Tblmicp_cont_url_lstDto>("sel_tblmicp_cont_url_lst", urlDto)
        var kakaoBtnUrl: Tblmicp_cont_url_lstDto? = null
        var kakaoImgUrl: Tblmicp_cont_url_lstDto? = null

        for (urlLst in kakaoContUrlList) {
            urlLst.url = CommonUtils.EscapeTextToHtml(urlLst.url)
            if("btn" == urlLst.url_tag?.toLowerCase()){
                kakaoBtnUrl = urlLst
            }else if("img" == urlLst.url_tag?.toLowerCase()){
                kakaoImgUrl = urlLst
            }
        }

        // MDM 콘텐츠 URL 리스트 정보
        var mdmContUrlList: MutableList<Tblmicp_cont_url_lstDto>? = null
        if(mdmCont != null){
            urlDto.cont_lst_cd = mdmCont.seq
            mdmContUrlList = sqlSession.selectList("sel_tblmicp_cont_url_lst", urlDto)
            for (urlLst in mdmContUrlList) {
                urlLst.url = CommonUtils.EscapeTextToHtml(urlLst.url)
            }
        }
        
        // RCS 콘텐츠 URL 리트스 정보
        var rcsContUrlList: MutableList<Tblmicp_cont_url_lstDto>? = null
        if(rcsCont != null){
            urlDto.cont_lst_cd = rcsCont.seq
            rcsContUrlList = sqlSession.selectList("sel_tblmicp_cont_url_lst", urlDto)
            for (urlLst in rcsContUrlList) {
                urlLst.url = CommonUtils.EscapeTextToHtml(urlLst.url)
            }
        }

        // 발송 리스트
        val sendLst = ArrayList<Any>()
        // Callback 메세지 저장 리스트
        val callbackLst = ArrayList<Tblmicp_send_callback_msgDto>()

        try {
            var targetSubject = kakaoCont.cont_sub
            var targetBody = CommonUtils.EscapeTextToHtml(kakaoCont.cont_body)
            var mdmSubject: String? = null
            var mdmBody: String? = null
            if(mdmCont != null){
                mdmSubject = mdmCont.cont_sub
                mdmBody = CommonUtils.EscapeTextToHtml(mdmCont.cont_body)
            }
            var rcsSubject: String? = null
            var rcsBody: String? = null
            var rcs_btn_obj: String? = null
            var rcs_btn_cont_1: String? = null
            var rcs_btn_cont_2: String? = null
            var rcs_btn_cont_3: String? = null
            if(rcsCont != null){
                rcsSubject = rcsCont.cont_sub
                rcsBody = CommonUtils.EscapeTextToHtml(rcsCont.cont_body)
                rcs_btn_obj = rcsCont.rcs_btn_obj
                rcs_btn_cont_1 = rcsCont.rcs_btn_cont_1
                rcs_btn_cont_2 = rcsCont.rcs_btn_cont_2
                rcs_btn_cont_3 = rcsCont.rcs_btn_cont_3
            }

            val HstSeq = map["SEND_HST_SEQ"].toString()

            // 제목 , 내용 치환
            for (key in map.keys) {
                targetSubject = targetSubject?.replace("{{$key}}", CommonUtils.stringValueOf(map[key]))
                targetBody = targetBody?.replace("{{$key}}", CommonUtils.stringValueOf(map[key]))
                mdmSubject = mdmSubject?.replace("{{$key}}", CommonUtils.stringValueOf(map[key]))
                mdmBody = mdmBody?.replace("{{$key}}", CommonUtils.stringValueOf(map[key]))
                rcsSubject = rcsSubject?.replace("{{$key}}", CommonUtils.stringValueOf(map[key]))
                rcsBody = rcsBody?.replace("{{$key}}", CommonUtils.stringValueOf(map[key]))
            }

            // KAKAO URL to TrackURL
            if (!kakaoContUrlList.isNullOrEmpty()) {
                for (urlLst in kakaoContUrlList) {
                    val url = urlLst.url!!
                    if ("a" == urlLst.url_tag) {
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
                            , "$trackURL/s/k/${AES256.AES_Encode(HstSeq + "/" + urlLst.seq.toString(), GlobalValues.encKey)}")
                    }
                }
            }

            // MDM url to TrackURL
            if (!mdmContUrlList.isNullOrEmpty()) {
                for (urlLst in mdmContUrlList) {
                    val url = urlLst.url!!
                    mdmBody = mdmBody?.replaceFirst(("\\{\\{"
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

            // Rcs url to TrackURL
            if (!rcsContUrlList.isNullOrEmpty()) {
                for (urlLst in rcsContUrlList) {
                    val url = urlLst.url!!
                    if ("a" == urlLst.url_tag) {
                        rcsBody = rcsBody?.replaceFirst(("\\{\\{"
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
                            , "$trackURL/s/r/${AES256.AES_Encode(HstSeq + "/" + urlLst.seq.toString(), GlobalValues.encKey)}")

                    }else{
                        rcs_btn_obj = rcs_btn_obj?.replaceFirst(("\\{\\{"
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
                            , "$trackURL/s/r/${AES256.AES_Encode(HstSeq + "/" + urlLst.seq.toString(), GlobalValues.encKey)}")
                        rcs_btn_cont_1 = rcs_btn_cont_1?.replaceFirst(("\\{\\{"
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
                            , "$trackURL/s/r/${AES256.AES_Encode(HstSeq + "/" + urlLst.seq.toString(), GlobalValues.encKey)}")
                        rcs_btn_cont_2 = rcs_btn_cont_2?.replaceFirst(("\\{\\{"
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
                            , "$trackURL/s/r/${AES256.AES_Encode(HstSeq + "/" + urlLst.seq.toString(), GlobalValues.encKey)}")
                        rcs_btn_cont_3 = rcs_btn_cont_3?.replaceFirst(("\\{\\{"
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
                            , "$trackURL/s/r/${AES256.AES_Encode(HstSeq + "/" + urlLst.seq.toString(), GlobalValues.encKey)}")
                    }
                }
            }

            val kkoMsgdto = Kko_msgDto()
            kkoMsgdto.clientId = kakaoClientId
            kkoMsgdto.id = "MICRM_SALES"
            kkoMsgdto.serialnum = dto.usr_grp_cd!!.toInt()
            kkoMsgdto.status = "1"
            kkoMsgdto.reqdate = dto.start_dt
            kkoMsgdto.phone = map["SEND_TO"].toString()
            kkoMsgdto.callback = kakaoSenderNo
            kkoMsgdto.msg = targetBody
            kkoMsgdto.profile_key = kakaoCont.send_to
            kkoMsgdto.ad_flag = "N"

            if(kakaoBtnUrl != null){
                //kkoMsgdto.button_json = "{\"button\":[{\"name\":\"${kakaoCont.kko_btn_nm}\",\"type\":\"WL\",\"url_pc\":\"$trackURL/s/k/${AES256.AES_Encode(HstSeq + "/" + kakaoBtnUrl.seq.toString(), GlobalValues.encKey)}\",\"url_mobile\":\"$trackURL/s/k/${AES256.AES_Encode(HstSeq + "/" + kakaoBtnUrl.seq.toString(), GlobalValues.encKey)}\"}]}"
                kkoMsgdto.button_json = "[{\"name\":\"${kakaoCont.kko_btn_nm}\",\"type\":\"WL\",\"url_pc\":\"$trackURL/s/k/${AES256.AES_Encode(HstSeq + "/" + kakaoBtnUrl.seq.toString(), GlobalValues.encKey)}\",\"url_mobile\":\"$trackURL/s/k/${AES256.AES_Encode(HstSeq + "/" + kakaoBtnUrl.seq.toString(), GlobalValues.encKey)}\"}]"
            }
            if(kakaoCont.kko_server_image_url != null){
                kkoMsgdto.type = "FI"
                kkoMsgdto.img_url = "{'img_url': '${kakaoCont.kko_server_image_url}', 'img_link': '$trackURL/s/k/${AES256.AES_Encode(HstSeq + "/" + kakaoImgUrl?.seq.toString(), GlobalValues.encKey)}'}"
            }else{
                kkoMsgdto.type = "FT"
            }

            kkoMsgdto.failed_type = "NO"
            if(rcsCont != null || mdmCont != null){
                val callbackDto = Tblmicp_send_callback_msgDto()
                callbackDto.hst_seq = HstSeq.toInt()
                callbackDto.send_to = map["SEND_TO"].toString()
                if(rcsCont != null){
                    callbackDto.rcs_tp = rcsCont.msg_tp_val
                    callbackDto.rcs_from_to = rcsCont.send_to
                    callbackDto.rcs_sub = rcsSubject
                    callbackDto.rcs_body = rcsBody
                    callbackDto.rcs_brn_id = rcsBrnID
                    callbackDto.rcs_msg_id = rcsCont.key_id
                    callbackDto.rcs_msg_header = if (rcsCont.send_tp == "SENDTP01") "1" else "0" // 안내 0, 광고 1
                    callbackDto.rcs_btn_ins_tp = rcsCont.rcs_btn_ins_tp
                    callbackDto.rcs_btn_cnt = if(rcsCont.rcs_btn_cnt.isNullOrEmpty()) "0" else rcsCont.rcs_btn_cnt
                    callbackDto.rcs_btn_obj = rcs_btn_obj
                    callbackDto.rcs_btn_1 = rcsCont.rcs_btn_1
                    callbackDto.rcs_btn_tp_1 = rcsCont.rcs_btn_tp_1
                    callbackDto.rcs_btn_cont_1 = rcs_btn_cont_1
                    callbackDto.rcs_btn_2 = rcsCont.rcs_btn_2
                    callbackDto.rcs_btn_tp_2 = rcsCont.rcs_btn_tp_2
                    callbackDto.rcs_btn_cont_2 = rcs_btn_cont_2
                    callbackDto.rcs_btn_3 = rcsCont.rcs_btn_3
                    callbackDto.rcs_btn_tp_3 = rcsCont.rcs_btn_tp_3
                    callbackDto.rcs_btn_cont_3 = rcs_btn_cont_3
                    callbackDto.rcs_footer = rcsCont.rcs_footer
                    if (!rcsCont.img_nm_lst.isNullOrBlank()) {
                        val list = rcsCont.img_nm_lst!!.split(",")
                        callbackDto.rcs_img_cnt = list.size.toString()
                        for (i in list.indices) {
                            when (i) {
                                0 -> callbackDto.rcs_img_cd_1 = imgPath + list[i]
                                1 -> callbackDto.rcs_img_cd_2 = imgPath + list[i]
                                2 -> callbackDto.rcs_img_cd_3 = imgPath + list[i]
                                3 -> callbackDto.rcs_img_cd_4 = imgPath + list[i]
                                4 -> callbackDto.rcs_img_cd_5 = imgPath + list[i]
                                5 -> callbackDto.rcs_img_cd_6 = imgPath + list[i]
                            }
                        }
                    }
                    callbackDto.rcs_server =  rcsDb
                }

                if(mdmCont != null){
                    callbackDto.mdm_tp = mdmCont.msg_tp_val
                    callbackDto.mdm_from_to = mdmCont.send_to
                    callbackDto.mdm_sub = mdmSubject
                    callbackDto.mdm_body = mdmBody
                    if (!mdmCont.img_nm_lst.isNullOrBlank()) {
                        val list = mdmCont.img_nm_lst!!.split(",")
                        callbackDto.mdm_img_cnt = list.size.toString()
                        for (i in list.indices) {
                            when (i) {
                                0 -> callbackDto.mdm_img_cd_1 = imgPath + list[i]
                                1 -> callbackDto.mdm_img_cd_2 = imgPath + list[i]
                                2 -> callbackDto.mdm_img_cd_3 = imgPath + list[i]
                                3 -> callbackDto.mdm_img_cd_4 = imgPath + list[i]
                                4 -> callbackDto.mdm_img_cd_5 = imgPath + list[i]
                                5 -> callbackDto.mdm_img_cd_6 = imgPath + list[i]
                            }
                        }
                    }
                    callbackDto.mdm_server = mdmDb
                }

                callbackDto.usr_grp_cd = dto.usr_grp_cd
                callbackDto.reg_id = dto.reg_id
                callbackLst.add(callbackDto)
                sqlSession.insert("ins_tblmicp_send_callback_msg", callbackLst)
            }

            kkoMsgdto.etc1 = dto.pro_id
            kkoMsgdto.etc2 = dto.seq.toString()
            kkoMsgdto.etc3 = map["SEND_HST_SEQ"].toString()
            kkoMsgdto.etc4 = mdmDb
            kkoMsgdto.etc5 = rcsDb
            kkoMsgdto.m_server = kakaoDb

            sendLst.add(kkoMsgdto)
            sqlSession.insert("ins_camp_send_kko_enter", sendLst)
            cnt++
        } catch (e: Exception) {
            logger.error("ins_sendKKo", e)
            sendLst.clear()
            callbackLst.clear()
            throw Exception()
        }
        return cnt
    }

    override fun upd_send(map: MutableMap<String, Any>): Int {
        map["db"] = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("KAKAO_DB", map["usr_grp_cd"].toString())).cd_val!!
        return sqlSession.update("upd_kko_send_cj", map)
    }

    override fun del_send(map: MutableMap<String, Any>): Int {
        map["db"] = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("KAKAO_DB", map["usr_grp_cd"].toString())).cd_val!!
        return sqlSession.update("del_kko_send_cj", map)
    }
}