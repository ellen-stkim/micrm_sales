package com.omnilab.micrm.repository.impl

import com.google.gson.GsonBuilder
import com.omnilab.micrm.common.AES256
import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.GlobalValues
import com.omnilab.micrm.model.Contents_lstDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.model.table.kakao.ButtonJsonDto
import com.omnilab.micrm.model.table.kakao.Kko_msgDto
import com.omnilab.micrm.repository.CampaignSendDao
import org.apache.ibatis.session.SqlSession
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Repository
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.ArrayList
import kotlin.collections.HashMap
import kotlin.math.log


@Repository("CampaignKakaoDaoImpl")
class CampaignKakaoDaoImpl : CampaignSendDao {

    val logger = LoggerFactory.getLogger(this::class.java)
    val sdf = SimpleDateFormat("yyyyMMddHHmmssSSS")

    @Autowired
    private lateinit var sqlSession: SqlSession

    private val regex = Regex("""\{\{[^{}]*\}\}""")
    val gson = GsonBuilder().disableHtmlEscaping().create()

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
            logger.error("kakaoClientId id null {}", dto.usr_grp_cd)
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

        val kakaoContUrlBtnList = sqlSession.selectList<Tblmicp_cont_url_lstDto>("sel_tblmicp_cont_url_lst", Tblmicp_cont_url_lstDto(kakaoCont.seq!!, "btn"))
        // 카카오 콘텐츠 URL 리스트 정보
        val kakaoBtnUrl: Tblmicp_cont_url_lstDto? = kakaoContUrlBtnList.firstOrNull { it.url_id == "kkoBtn001" }
        val kakaoBtnUrl2: Tblmicp_cont_url_lstDto? = kakaoContUrlBtnList.firstOrNull { it.url_id == "kkoBtn002" }
        val kakaoBtnUrl3: Tblmicp_cont_url_lstDto? = kakaoContUrlBtnList.firstOrNull { it.url_id == "kkoBtn003" }
        val kakaoBtnUrl4: Tblmicp_cont_url_lstDto? = kakaoContUrlBtnList.firstOrNull { it.url_id == "kkoBtn004" }
        val kakaoBtnUrl5: Tblmicp_cont_url_lstDto? = kakaoContUrlBtnList.firstOrNull { it.url_id == "kkoBtn005" }
        val kakaoBtnUrlPc: Tblmicp_cont_url_lstDto? = kakaoContUrlBtnList.firstOrNull { it.url_id == "kkoBtnPc001" }
        val kakaoBtnUrlPc2: Tblmicp_cont_url_lstDto? = kakaoContUrlBtnList.firstOrNull { it.url_id == "kkoBtnPc002" }
        val kakaoBtnUrlPc3: Tblmicp_cont_url_lstDto? = kakaoContUrlBtnList.firstOrNull { it.url_id == "kkoBtnPc003" }
        val kakaoBtnUrlPc4: Tblmicp_cont_url_lstDto? = kakaoContUrlBtnList.firstOrNull { it.url_id == "kkoBtnPc004" }
        val kakaoBtnUrlPc5: Tblmicp_cont_url_lstDto? = kakaoContUrlBtnList.firstOrNull { it.url_id == "kkoBtnPc005" }

        var kakaoImgUrl: Tblmicp_cont_url_lstDto? = null
        // 이미지 리스트
        val kakaoContUrlImgList = sqlSession.selectList<Tblmicp_cont_url_lstDto>("sel_tblmicp_cont_url_lst", Tblmicp_cont_url_lstDto(kakaoCont.seq!!, "img"))
        // 버튼 리스트
        if(!kakaoContUrlImgList.isNullOrEmpty()){
            kakaoImgUrl = kakaoContUrlImgList[0]
        }

        // MDM 콘텐츠 URL 리스트 정보
        var mdmContUrlList: MutableList<Tblmicp_cont_url_lstDto>? = null
        if(mdmCont != null){
            val urlDto = Tblmicp_cont_url_lstDto()
            urlDto.cont_lst_cd = mdmCont.seq
            mdmContUrlList = sqlSession.selectList("sel_tblmicp_cont_url_lst", urlDto)
            for (urlLst in mdmContUrlList) {
                urlLst.url = CommonUtils.escapeTextToHtml(urlLst.url)
            }
        }
        
        // RCS 콘텐츠 URL 리트스 정보
        var rcsContUrlList: MutableList<Tblmicp_cont_url_lstDto>? = null
        if(rcsCont != null){
            val urlDto = Tblmicp_cont_url_lstDto()
            urlDto.cont_lst_cd = rcsCont.seq
            rcsContUrlList = sqlSession.selectList("sel_tblmicp_cont_url_lst", urlDto)
            for (urlLst in rcsContUrlList) {
                urlLst.url = CommonUtils.escapeTextToHtml(urlLst.url)
            }
        }

        // 발송 리스트
        val sendLst = ArrayList<Any>()
        // Callback 메세지 저장 리스트
        val callbackLst = ArrayList<Tblmicp_send_callback_msgDto>()

        try {
            var targetSubject = kakaoCont.cont_sub
            var targetBody = CommonUtils.escapeTextToHtml(kakaoCont.cont_body)
            var mdmSubject: String? = null
            var mdmBody: String? = null
            if(mdmCont != null){
                mdmSubject = mdmCont.cont_sub
                mdmBody = CommonUtils.escapeTextToHtml(mdmCont.cont_body)
            }
            var rcsSubject: String? = null
            var rcsBody: String? = null
            var rcsBtnObj: String? = null
            var rcsBtnCont1: String? = null
            var rcsBtnCont2: String? = null
            var rcsBtnCont3: String? = null
            if(rcsCont != null){
                rcsSubject = rcsCont.cont_sub
                rcsBody = CommonUtils.escapeTextToHtml(rcsCont.cont_body)
                rcsBtnObj = rcsCont.rcs_btn_obj
                rcsBtnCont1 = rcsCont.rcs_btn_cont_1
                rcsBtnCont2 = rcsCont.rcs_btn_cont_2
                rcsBtnCont3 = rcsCont.rcs_btn_cont_3
            }

            val hstSeq = map["SEND_HST_SEQ"].toString()

            // 제목 , 내용 치환
            for (key in map.keys) {
                val reg = Regex("\\{\\{(?i)${key}}}")
                targetSubject = targetSubject?.replace(reg, CommonUtils.stringValueOf(map[key]))
                targetBody = targetBody?.replace(reg, CommonUtils.stringValueOf(map[key]))
                mdmSubject = mdmSubject?.replace(reg, CommonUtils.stringValueOf(map[key]))
                mdmBody = mdmBody?.replace(reg, CommonUtils.stringValueOf(map[key]))
                rcsSubject = rcsSubject?.replace(reg, CommonUtils.stringValueOf(map[key]))
                rcsBody = rcsBody?.replace(reg, CommonUtils.stringValueOf(map[key]))
            }

            // KAKAO URL to TrackURL
            val kakaoContAList = sqlSession.selectList<Tblmicp_cont_url_lstDto>("sel_tblmicp_cont_url_lst", Tblmicp_cont_url_lstDto(kakaoCont.seq!!, "a"))
            if (!kakaoContAList.isNullOrEmpty()) {
                for (urlLst in kakaoContAList) {
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
                        , "$trackURL/s/k/${AES256.AES_Encode(hstSeq + "/" + urlLst.seq.toString(), GlobalValues.encKey)}")
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
                        , "$trackURL/s/m/${AES256.AES_Encode(hstSeq + "/" + urlLst.seq.toString(), GlobalValues.encKey)}")
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
                            , "$trackURL/s/r/${AES256.AES_Encode(hstSeq + "/" + urlLst.seq.toString(), GlobalValues.encKey)}")

                    }else{
                        rcsBtnObj = rcsBtnObj?.replaceFirst(("\\{\\{"
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
                            , "$trackURL/s/r/${AES256.AES_Encode(hstSeq + "/" + urlLst.seq.toString(), GlobalValues.encKey)}")
                        rcsBtnCont1 = rcsBtnCont1?.replaceFirst(("\\{\\{"
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
                            , "$trackURL/s/r/${AES256.AES_Encode(hstSeq + "/" + urlLst.seq.toString(), GlobalValues.encKey)}")
                        rcsBtnCont2 = rcsBtnCont2?.replaceFirst(("\\{\\{"
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
                            , "$trackURL/s/r/${AES256.AES_Encode(hstSeq + "/" + urlLst.seq.toString(), GlobalValues.encKey)}")
                        rcsBtnCont3 = rcsBtnCont3?.replaceFirst(("\\{\\{"
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
                            , "$trackURL/s/r/${AES256.AES_Encode(hstSeq + "/" + urlLst.seq.toString(), GlobalValues.encKey)}")
                    }
                }
            }

            val kkoMsgdto = Kko_msgDto()
            kkoMsgdto.clientId = kakaoClientId
            kkoMsgdto.id = "MICRM_SALES"
            kkoMsgdto.serialnum = "${dto.usr_grp_cd!!}${sdf.format(Date())}${map["SEND_TO"].toString()}"
            kkoMsgdto.status = "1"
            kkoMsgdto.reqdate = dto.start_dt
            kkoMsgdto.phone = map["SEND_TO"].toString()
            kkoMsgdto.callback = kakaoSenderNo
            kkoMsgdto.msg = targetBody
            kkoMsgdto.profile_key = kakaoCont.send_to
            kkoMsgdto.ad_flag = if (kakaoCont.send_tp == "SENDTP01") "Y" else "N"
            kkoMsgdto.template_code = kakaoCont.kko_tmpl_cd
            if(!CommonUtils.isEmptyObject(kakaoCont.kko_tar_tp) && kakaoCont.kko_tar_tp != "-"){
                kkoMsgdto.targeting = kakaoCont.kko_tar_tp
                kkoMsgdto.upgrade_tp = "BM"
            }else{
                kkoMsgdto.upgrade_tp = "FY"
            }
            
            if(kakaoBtnUrl != null){
                val lst = ArrayList<ButtonJsonDto>()
                buildButtonDto(kakaoCont.kko_btn_nm , kakaoBtnUrl , kakaoBtnUrlPc , trackURL!!, hstSeq, map)?.let(lst::add)
                buildButtonDto(kakaoCont.kko_btn_nm2, kakaoBtnUrl2, kakaoBtnUrlPc2, trackURL, hstSeq, map)?.let(lst::add)
                buildButtonDto(kakaoCont.kko_btn_nm3, kakaoBtnUrl3, kakaoBtnUrlPc3, trackURL, hstSeq, map)?.let(lst::add)
                buildButtonDto(kakaoCont.kko_btn_nm4, kakaoBtnUrl4, kakaoBtnUrlPc4, trackURL, hstSeq, map)?.let(lst::add)
                buildButtonDto(kakaoCont.kko_btn_nm5, kakaoBtnUrl5, kakaoBtnUrlPc5, trackURL, hstSeq, map)?.let(lst::add)
                kkoMsgdto.button_json = gson.toJson(lst)
            }

            when (kakaoCont.msg_tp) {
               "DMCH220" -> {
                   kkoMsgdto.type = "U_FL"
                   //kkoMsgdto.item = kakaoCont.kko_item_json
                   var msg = kakaoCont.kko_item_json
                   for (key in map.keys) {
                       val reg = Regex("\\{\\{(?i)${key}}}")
                       msg = msg?.replace(reg, CommonUtils.stringValueOf(map[key]))
                   }
                   kkoMsgdto.item = msg
               }
               "DMCH221" -> {
                   kkoMsgdto.type = "U_FA"
                   var msg = kakaoCont.kko_carousel_json
                   var head = kakaoCont.kko_head_json
                   for (key in map.keys) {
                       val reg = Regex("\\{\\{(?i)${key}}}")
                       msg = msg?.replace(reg, CommonUtils.stringValueOf(map[key]))
                       head = head?.replace(reg, CommonUtils.stringValueOf(map[key]))
                   }
                   kkoMsgdto.carousel_json = msg
                   kkoMsgdto.head_json = head
               }
               "DMCH222" -> {
                   kkoMsgdto.type = "U_FC"
                   //kkoMsgdto.carousel_json = kakaoCont.kko_carousel_json
                   var msg = kakaoCont.kko_carousel_json
                   for (key in map.keys) {
                       val reg = Regex("\\{\\{(?i)${key}}}")
                       msg = msg?.replace(reg, CommonUtils.stringValueOf(map[key]))
                   }
                   kkoMsgdto.carousel_json = msg
               }
               "DMCH223" -> {
                   kkoMsgdto.type = "U_FP"
                   val videoMap = HashMap<String, Any?>()
                   videoMap["video_url"] = kakaoCont.kko_video_url
                   videoMap["thumbnail_url"] = kakaoCont.kko_server_image_url_video
                   kkoMsgdto.video_json = gson.toJson(videoMap)
               }
               else -> {
                   // 이전 버전 호환용
                   if(kakaoCont.kko_server_image_url != null){
                       if(kakaoCont.ch_tp == "IMGTP11"){  // 와이드 이미지
                           kkoMsgdto.type = "U_FW"
                       }else{
                           kkoMsgdto.type = "U_FI"
                       }
                       if(kakaoImgUrl != null) {
                           kkoMsgdto.img_url = "{\"img_url\": \"${kakaoCont.kko_server_image_url}\", \"img_link\": \"$trackURL/s/k/${AES256.AES_Encode(hstSeq + "/" + kakaoImgUrl.seq.toString(), GlobalValues.encKey)}\"}"
                       }else{
                           kkoMsgdto.img_url = "{\"img_url\": \"${kakaoCont.kko_server_image_url}\"}"
                       }
                   }else{
                       kkoMsgdto.type = "U_FT"
                   }
               }
            }

            if(kakaoCont.kko_price != null){
                kkoMsgdto.price = kakaoCont.kko_price.toString()
            }
            kkoMsgdto.currency_type = kakaoCont.kko_currency_type
            kkoMsgdto.title = kakaoCont.kko_title
            kkoMsgdto.header = kakaoCont.kko_header
            kkoMsgdto.failed_type = "NO"
            if(rcsCont != null || mdmCont != null){
                val callbackDto = Tblmicp_send_callback_msgDto()
                callbackDto.hst_seq = hstSeq.toInt()
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
                    callbackDto.rcs_btn_obj = rcsBtnObj
                    callbackDto.rcs_btn_1 = rcsCont.rcs_btn_1
                    callbackDto.rcs_btn_tp_1 = rcsCont.rcs_btn_tp_1
                    callbackDto.rcs_btn_cont_1 = rcsBtnCont1
                    callbackDto.rcs_btn_2 = rcsCont.rcs_btn_2
                    callbackDto.rcs_btn_tp_2 = rcsCont.rcs_btn_tp_2
                    callbackDto.rcs_btn_cont_2 = rcsBtnCont2
                    callbackDto.rcs_btn_3 = rcsCont.rcs_btn_3
                    callbackDto.rcs_btn_tp_3 = rcsCont.rcs_btn_tp_3
                    callbackDto.rcs_btn_cont_3 = rcsBtnCont3
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
            kkoMsgdto.tax_cd1 = dto.usr_grp_cd
            kkoMsgdto.m_server = kakaoDb
            kkoMsgdto.template_code = kakaoCont.kko_tmpl_cd
            kkoMsgdto.targeting = kakaoCont.kko_tar_tp
            sendLst.add(kkoMsgdto)
            logger.error("kakaoCont {}", kakaoCont)
            logger.error("kkoMsgdto {}", kkoMsgdto)
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

    fun containsTemplateVariable(input: String?): Boolean {
        return if(input == null){
            false
        }else{
            regex.containsMatchIn(input)
        }
    }

    fun buildButtonDto(
        name: String?,
        mobile: Tblmicp_cont_url_lstDto?,
        pcData: Tblmicp_cont_url_lstDto?,
        trackURL: String,
        hstSeq: String,
        map: Map<String, Any>
    ): ButtonJsonDto? {
        if (name.isNullOrBlank() || mobile == null) return null
        val pc = pcData ?: mobile

        if (containsTemplateVariable(mobile.url) || containsTemplateVariable(pc.url)) {
            var mobileUrl = mobile.url
            for ((k, v) in map) {
                val reg = Regex("\\{\\{(?i)${Regex.escape(k)}}}")
                mobileUrl = mobileUrl?.replace(reg, CommonUtils.stringValueOf(v))
            }
            var pcUrl = pc.url
            for ((k, v) in map) {
                val reg = Regex("\\{\\{(?i)${Regex.escape(k)}}}")
                pcUrl = pcUrl?.replace(reg, CommonUtils.stringValueOf(v))
            }
            return ButtonJsonDto(
                name,
                "WL",
                mobileUrl,
                pcUrl
            )
        } else {
            val mobileTracked = "$trackURL/s/k/${AES256.AES_Encode("$hstSeq/${mobile.seq}", GlobalValues.encKey)}"
            val pcTracked = "$trackURL/s/k/${AES256.AES_Encode("$hstSeq/${pc.seq}", GlobalValues.encKey)}"
            return ButtonJsonDto(
                name,
                "WL",
                mobileTracked,
                pcTracked
            )
        }
    }



}