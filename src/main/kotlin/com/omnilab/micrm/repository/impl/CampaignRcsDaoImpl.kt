package com.omnilab.micrm.repository.impl

import com.omnilab.micrm.common.AES256
import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.GlobalValues
import com.omnilab.micrm.model.Contents_lstDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.model.table.kakao.Kko_msgDto
import com.omnilab.micrm.model.table.rcs.LgRcs_imgDto
import com.omnilab.micrm.model.table.rcs.LgRcs_msgDto
import com.omnilab.micrm.repository.CampaignSendDao
import org.apache.ibatis.session.ResultContext
import org.apache.ibatis.session.ResultHandler
import org.apache.ibatis.session.SqlSession
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Repository


@Repository("CampaignRcsDaoImpl")
class CampaignRcsDaoImpl : CampaignSendDao {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    private lateinit var sqlSession: SqlSession

    override fun ins_send(dto: Tblmicp_campaignDto, contTpLst: MutableMap<String, Contents_lstDto>, map: MutableMap<String, Any>): Int {
        var cnt = 0

        val mdmCont = contTpLst["DMTP02"]
        val kakaoCont = contTpLst["DMTP03"]
        val rcsCont = contTpLst["DMTP04"]!!

        // 카카오 발송 서버 정보
        val kakaoDbDto = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("KAKAO_DB", dto.usr_grp_cd!!))
        val kakaoDb = kakaoDbDto.cd_val
        val kakaoKey = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("KAKAO_KEY", dto.usr_grp_cd!!)).cd_val

        if(kakaoKey.isNullOrEmpty()){
            return cnt
        }

        // 문자 발송 서버 정보
        val mdmDbDto = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("MDM_DB", dto.usr_grp_cd!!))
        val mdmDb = mdmDbDto.cd_val

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
        var kakaoContUrlList: MutableList<Tblmicp_cont_url_lstDto>? = null
        var kakaoBtnUrl: Tblmicp_cont_url_lstDto? = null
        var kakaoImgUrl: Tblmicp_cont_url_lstDto? = null
        if(kakaoCont != null){
            urlDto.cont_lst_cd = kakaoCont.seq
            kakaoContUrlList = sqlSession.selectList("sel_tblmicp_cont_url_lst", urlDto)
            for (urlLst in kakaoContUrlList) {
                urlLst.url = CommonUtils.EscapeTextToHtml(urlLst.url)
                if("btn" == urlLst.url_tag?.toLowerCase()){
                    kakaoBtnUrl = urlLst
                }else if("img" == urlLst.url_tag?.toLowerCase()){
                    kakaoImgUrl = urlLst
                }
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
        urlDto.cont_lst_cd = rcsCont.seq
        rcsContUrlList = sqlSession.selectList("sel_tblmicp_cont_url_lst", urlDto)
        for (urlLst in rcsContUrlList) {
            urlLst.url = CommonUtils.EscapeTextToHtml(urlLst.url)
        }

        // 발송 리스트
        val sendLst = ArrayList<Any>()
        // Callback 메세지 저장 리스트
        val callbackLst = ArrayList<Tblmicp_send_callback_msgDto>()

        // 이미지 리스트
        val rcsImgLst = ArrayList<LgRcs_imgDto>()

        try {
            var targetSubject = rcsCont.cont_sub
            var targetBody = CommonUtils.EscapeTextToHtml(rcsCont.cont_body)
            var rcs_btn_obj = rcsCont.rcs_btn_obj
            var rcs_btn_cont_1 = rcsCont.rcs_btn_cont_1
            var rcs_btn_cont_2 = rcsCont.rcs_btn_cont_2
            var rcs_btn_cont_3 = rcsCont.rcs_btn_cont_3

            var mdmSubject: String? = null
            var mdmBody: String? = null
            if(mdmCont != null){
                mdmSubject = CommonUtils.EscapeTextToHtml(mdmCont.cont_sub)
                mdmBody = CommonUtils.EscapeTextToHtml(mdmCont.cont_body)
            }
            var kakaoSubject: String? = null
            var kakaoBody: String? = null
            if(kakaoCont != null){
                kakaoSubject = CommonUtils.EscapeTextToHtml(kakaoCont.cont_sub)
                kakaoBody =CommonUtils.EscapeTextToHtml(kakaoCont.cont_body)
            }

            val HstSeq = map["SEND_HST_SEQ"].toString()

            // 제목 , 내용 치환
            for (key in map.keys) {
                targetSubject = targetSubject?.replace("{{$key}}", CommonUtils.stringValueOf(map[key]))
                targetBody = targetBody?.replace("{{$key}}", CommonUtils.stringValueOf(map[key]))
                mdmSubject = mdmSubject?.replace("{{$key}}", CommonUtils.stringValueOf(map[key]))
                mdmBody = mdmBody?.replace("{{$key}}", CommonUtils.stringValueOf(map[key]))
                kakaoSubject = kakaoSubject?.replace("{{$key}}", CommonUtils.stringValueOf(map[key]))
                kakaoBody = kakaoBody?.replace("{{$key}}", CommonUtils.stringValueOf(map[key]))
            }

            // RCS URL to TrackURL
            if (!rcsContUrlList.isNullOrEmpty()) {
                for (urlLst in rcsContUrlList) {
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

            // KAKAO URL to TrackURL
            if (!kakaoContUrlList.isNullOrEmpty()) {
                for (urlLst in kakaoContUrlList) {
                    val url = urlLst.url!!
                    if ("a" == urlLst.url_tag) {
                        kakaoBody = kakaoBody?.replaceFirst(("\\{\\{"
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

            val sendDto = LgRcs_msgDto()
            sendDto.status = "0"
            sendDto.reqdate = dto.start_dt
            sendDto.phone = map["SEND_TO"].toString()
            sendDto.callback = rcsCont.send_to
            sendDto.type = rcsCont.msg_tp_val
            sendDto.msg_header = if (rcsCont.send_tp == "SENDTP01") "1" else "0"
            if(sendDto.type == "12"){
                sendDto.rcs_object = targetBody
                sendDto.sendable = "N" //  (이미지 등록 전 : N, 이미지 등록 완료: Y, 이미지 없을 경우: Y)
            }else{
                sendDto.msg = targetBody
                sendDto.sendable = "Y"
            }
            sendDto.msg_footer =  if (rcsCont.rcs_footer.isNullOrEmpty()) null else rcsCont.rcs_footer
            sendDto.msg_copyallowed = "Y"
            sendDto.brand_id = rcsBrnID
            sendDto.msgbase_id = rcsCont.key_id
            sendDto.fallback_yn = "N"

            sendDto.btn_cnt = if(rcsCont.rcs_btn_cnt.isNullOrEmpty()) "0" else rcsCont.rcs_btn_cnt
            sendDto.btn_insert_type = rcsCont.rcs_btn_ins_tp
            sendDto.btn_text_1 = rcsCont.rcs_btn_1
            sendDto.btn_type_1 = rcsCont.rcs_btn_tp_1
            sendDto.btn_contents_1 = rcs_btn_cont_1
            sendDto.btn_text_2 = rcsCont.rcs_btn_2
            sendDto.btn_type_2 = rcsCont.rcs_btn_tp_2
            sendDto.btn_contents_2 = rcs_btn_cont_2
            sendDto.btn_text_3 = rcsCont.rcs_btn_3
            sendDto.btn_type_3 = rcsCont.rcs_btn_tp_3
            sendDto.btn_contents_3 = rcs_btn_cont_3
            sendDto.btn_object = rcs_btn_obj

            sendDto.etc1 = dto.pro_id
            sendDto.etc2 = dto.seq.toString()
            sendDto.etc3 = map["SEND_HST_SEQ"].toString()
            sendDto.etc4 = mdmDb
            sendDto.etc5 = kakaoDb
            sendDto.etc6 = "MICRM_SALES"

            if (!rcsCont.img_nm_lst.isNullOrBlank()) {
                val list = rcsCont.img_nm_lst!!.split(",")
                sendDto.img_group_cnt = list.size.toString()
                sendDto.img_group_key = "GR_${dto.seq.toString()}"
                if(cnt == 0){
                    for (i in list.indices) {
                        val imgDto = LgRcs_imgDto()
                        imgDto.group_key = "GR_${dto.seq.toString()}"
                        imgDto.group_cnt = list.size.toString()
                        imgDto.status = "0"
                        imgDto.sendable = "N"
                        imgDto.brand_id = rcsBrnID
                        imgDto.img_path = imgPath?.trim() + list[i].trim()
                        imgDto.template_yn = "N"
                        imgDto.m_server = rcsDb
                        rcsImgLst.add(imgDto)
                    }
                }
            }
            sendDto.m_server = rcsDb

            if(kakaoCont != null || mdmCont != null){
                val callbackDto = Tblmicp_send_callback_msgDto()
                callbackDto.hst_seq = HstSeq.toInt()
                callbackDto.send_to = map["SEND_TO"].toString()
                if(kakaoCont != null){
                    callbackDto.kko_tp = kakaoCont.msg_tp
                    callbackDto.kko_from_to = kakaoCont.send_to
                    callbackDto.kko_body = kakaoBody
                    callbackDto.kko_key = kakaoKey
                    if(kakaoBtnUrl != null){
                        callbackDto.kko_btn = "{\"button\":[{\"name\":\"${kakaoCont.kko_btn_nm}\",\"type\":\"WL\",\"url_pc\":\"$trackURL/s/k/${AES256.AES_Encode(HstSeq + "/" + kakaoBtnUrl.seq.toString(), GlobalValues.encKey)}\",\"url_mobile\":\"$trackURL/s/k/${AES256.AES_Encode(HstSeq + "/" + kakaoBtnUrl.seq.toString(), GlobalValues.encKey)}\"}]}"
                    }
                    if(kakaoCont.kko_image_file_nm != null){
                        callbackDto.kko_img_path = imgPath + kakaoCont.kko_image_file_nm
                    }
                    if(kakaoImgUrl != null) {
                        callbackDto.kko_img_url = "$trackURL/s/k/${AES256.AES_Encode(HstSeq + "/" + kakaoImgUrl.seq.toString(), GlobalValues.encKey)}"
                    }
                    callbackDto.kko_server = kakaoDb
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

            sendLst.add(sendDto)
            sqlSession.insert("ins_camp_send_rcs_lg", sendLst)
            cnt++
        } catch (e: Exception) {
            logger.error("ins_sendRcs", e)
            sendLst.clear()
            callbackLst.clear()
            throw Exception()
        }
        return cnt
    }

    override fun upd_send(map: MutableMap<String, Any>): Int {
        map["db"] = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("RCS_DB", map["usr_grp_cd"].toString())).cd_val!!
        return sqlSession.update("upd_rcs_send_lg", map)
    }

    override fun del_send(map: MutableMap<String, Any>): Int {
        map["db"] = sqlSession.selectOne<Tblmi_comm_cdDto>("getCommCD", Tblmi_comm_cdDto("RCS_DB", map["usr_grp_cd"].toString())).cd_val!!
        return sqlSession.update("del_rcs_send_lg", map)
    }
}