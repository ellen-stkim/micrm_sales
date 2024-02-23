package com.omnilab.micrm.service.impl


import com.google.gson.*
import com.omnilab.micrm.common.AES256
import com.omnilab.micrm.common.BtnValueUtils
import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.GlobalValues
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.*
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.repository.ContentDao
import com.omnilab.micrm.repository.CouponDao
import com.omnilab.micrm.repository.KkoAtTmplDao
import com.omnilab.micrm.repository.SysSettingDao
import com.omnilab.micrm.service.ContentService
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo
import org.json.simple.JSONArray
import org.json.simple.JSONObject
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Service
import java.util.*
import java.util.regex.Pattern

@Service("MobileContentServiceImpl")
class MobileContentServiceImpl : ContentService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    @Qualifier("SysSettingDaoImpl")
    private lateinit var systemDao: SysSettingDao

    @Autowired
    @Qualifier("ContentDaoImpl")
    private lateinit var contentDao: ContentDao

    @Autowired
    @Qualifier("KkoAtTmplDaoImpl")
    private lateinit var kkoAtTmplDao: KkoAtTmplDao

    @Autowired
    @Qualifier("CouponDaoImpl")
    private lateinit var couponDao: CouponDao


    /**
     * @Method Name  : insertMobileContentList
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : contentListCreatedto: Content_list_CreateDto
     * @return   : Map<String, Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 모바일 컨텐츠 저장
     * @title : 모바일 컨텐츠 저장
     */

    override fun insertContentList(dto: Tblmi_cont_lstDto): Map<String, Any> {
        val statusMap: MutableMap<String, Any> = HashMap()
        val contentListCreatedto = dto as Content_list_CreateDto
        val userInfo = UsefulUtils.sessionUser()

        val isByte = isCheckByte(contentListCreatedto);

        if (!isByte) {
            statusMap["status"] = false
            return statusMap
        }
        statusMap["status"] = true

        val tblmiContMstDto = Tblmi_cont_mstDto()

        try {

            tblmiContMstDto.ch_tp = "CH03"
            tblmiContMstDto.cont_nm = contentListCreatedto.cont_nm
            tblmiContMstDto.reg_id = userInfo.usr_id
            tblmiContMstDto.cont_grp_cd = userInfo.usr_grp_cd

            contentDao.insertContentMaster(tblmiContMstDto);
            statusMap["seq"] = tblmiContMstDto.seq as Int

            // 인덱스 값은 고정되서 넘어온다 [ 0번 인덱스 : kakao , 1번 인덱스 : sms , 2번 인덱스: rcs ]
            val len = contentListCreatedto.send_to_list!!.size - 1;

            for (i in 0..len) {
                // 항상 3번 Insert 작업을 진행한다.
                // 공통 값은 배열로 받아 처리, 나머지는 각자 처리
                val tblmiContLstdto = Tblmi_cont_lstDto()

                tblmiContLstdto.cont_cd = tblmiContMstDto.seq   // 마스터 코드 삽입
                tblmiContLstdto.cont_sub = contentListCreatedto.cont_sub_list!![i].trim()
                tblmiContLstdto.from_to = contentListCreatedto.from_to
                tblmiContLstdto.send_to = contentListCreatedto.send_to_list!![i]
                tblmiContLstdto.send_nm = null
                tblmiContLstdto.thm_url = null
                tblmiContLstdto.br_yn = "N"
                tblmiContLstdto.sup_yn = "N"
                tblmiContLstdto.reg_id = userInfo.usr_id
                tblmiContLstdto.cont_grp_cd = userInfo.usr_grp_cd

                val formatList = contentListCreatedto.formatType

                // 인덱스 번호 0 : 카카오
                if (i == 0) {
                    // 제목 저장
                    tblmiContLstdto.cont_sub = contentListCreatedto.cont_sub_list!![i].trim()

                    // 체크 여부에 따라 USE_YN 설정
                    if (formatList!!.contains("kakao")) {
                        tblmiContLstdto.use_yn = "Y"
                    } else {
                        tblmiContLstdto.use_yn = "N"
                    }

                    val kkoOption = contentListCreatedto.kko_option!!.trim()
                    if (kkoOption.equals("ad")) {
                        // 광고 처리
                        tblmiContLstdto.send_tp = "SENDTP01"
                    } else if (kkoOption.equals("guide")) {
                        // 안내 처리
                        tblmiContLstdto.send_tp = "SENDTP02"
                    }

                    if ("kko_at".equals(contentListCreatedto.kko_format_type)) {  // 알림톡

                        // 템플릿 조회
                        val atDto =  AtTmpl_searchDto(contentListCreatedto.key_id,contentListCreatedto.tmpl_nm,"Y")
                        atDto.usr_grp_cd =contentListCreatedto.cont_grp_cd
                        atDto.kep_status = "O"  // 승인완료

                        val resultDto = kkoAtTmplDao.selTmplBytmplDto(atDto)
                        if(!CommonUtils.isEmptyObject(resultDto)){
                            tblmiContLstdto.key_id = resultDto!!.tmpl_cd

                            val g = GsonBuilder().create()
                            val obj = JsonObject()
                            obj.add("button",g.fromJson(resultDto.button_json, JsonArray::class.java))
                            obj.add("quick_reply",g.fromJson(resultDto.quick_repl_json, JsonArray::class.java))
                            obj.add("item_highlight", g.fromJson(resultDto.item_highlight_json, JsonObject::class.java))
                            obj.add("item", g.fromJson(resultDto.item_json, JsonObject::class.java))
                            tblmiContLstdto.kko_btn_obj = g.toJson(obj)
                            tblmiContLstdto.kko_img_cd = resultDto.img_seq
                            tblmiContLstdto.kko_img_url = resultDto.kko_img_url
                            tblmiContLstdto.kko_title = resultDto.tmpl_tit
                            tblmiContLstdto.kko_header = resultDto.tmpl_header
                            tblmiContLstdto.kko_msg_tp = if (resultDto.tmpl_empsize_tp == "IMAGE") "AI" else "AT"

                            tblmiContLstdto.cont_tp = "DMTP05"
                            tblmiContLstdto.msg_tp = "DMCH216"

                            tblmiContLstdto.cont_body = resultDto.tmpl_cont
                        }

                    } else {
                        // key_id 로 발신키 유효한지 확인
                        val cdDto = Tblmi_comm_cdDto()
                        cdDto.grp_id = "KAKAO_KEY"
                        cdDto.cd_id = userInfo.usr_grp_cd

                        val kkoDto = SetLst_searchDto("CH02","DMTP03","Y",UsefulUtils.sessionUser().usr_grp_cd)
                        kkoDto.list_val = contentListCreatedto.key_id
                        val kkoSenderLst = contentDao.selectSenderList(kkoDto)

                        if (kkoSenderLst.size > 0) {
                            tblmiContLstdto.key_id = kkoSenderLst[0].list_val
                        }

                        tblmiContLstdto.cont_tp = "DMTP03" // 카카오
                        tblmiContLstdto.msg_tp = "DMCH204" // 친구톡


                        // 카카오 이미지 처리
                        if (CommonUtils.isEmptyObject(contentListCreatedto.kko_img_cd)) {
                            tblmiContLstdto.kko_img_cd = null
                        } else {
                            tblmiContLstdto.kko_img_cd = contentListCreatedto.kko_img_cd
                        }


                        tblmiContLstdto.cont_body = contentListCreatedto.kakao_body
                        tblmiContLstdto.kko_img_url = contentListCreatedto.kko_img_url
                        tblmiContLstdto.kko_btn_nm = contentListCreatedto.kko_btn_nm
                        tblmiContLstdto.kko_btn_url = contentListCreatedto.kko_btn_url
                    }
                }

                // 인덱스 번호 1: SMS (문자 )
                if (i == 1) {
                    if (formatList!!.contains("sms")) {
                        tblmiContLstdto.use_yn = "Y"
                    } else {
                        tblmiContLstdto.use_yn = "N"
                    }

                    tblmiContLstdto.cont_tp = "DMTP02"
                    // SMS 광고 , 안내 유형 선택
                    val smsOption = contentListCreatedto.sms_option!!.trim()

                    if (smsOption.equals("ad")) {
                        // 광고 처리
                        tblmiContLstdto.send_tp = "SENDTP01"
                    } else if (smsOption.equals("guide")) {
                        // 안내 처리
                        tblmiContLstdto.send_tp = "SENDTP02"
                    }

                    val smsMsgTp = contentListCreatedto.sms_msg_tp

                    // SMS 문자 타입 설정
                    if (smsMsgTp.equals("LMS")) {
                        tblmiContLstdto.msg_tp = "DMCH202"
                        tblmiContLstdto.img_cd_1 = null
                    } else if (smsMsgTp.equals("MMS")) {
                        tblmiContLstdto.msg_tp = "DMCH203"
                        tblmiContLstdto.img_cd_1 = contentListCreatedto.mds_img_cd
                    } else {
                        tblmiContLstdto.msg_tp = "DMCH201"
                        tblmiContLstdto.img_cd_1 = null
                    }
                    tblmiContLstdto.cont_body = contentListCreatedto.sms_body
                }

                // 인덱스 번호 2: RCS 분기 처리
                if (i == 2) {

                    // 이미지 저장
                    tblmiContLstdto.img_cd_1 = contentListCreatedto.rcs_img_cd_1?.toInt()
                    tblmiContLstdto.img_cd_2 = contentListCreatedto.rcs_img_cd_2?.toInt()
                    tblmiContLstdto.img_cd_3 = contentListCreatedto.rcs_img_cd_3?.toInt()
                    tblmiContLstdto.img_cd_4 = contentListCreatedto.rcs_img_cd_4?.toInt()
                    tblmiContLstdto.img_cd_5 = contentListCreatedto.rcs_img_cd_5?.toInt()
                    tblmiContLstdto.img_cd_6 = contentListCreatedto.rcs_img_cd_6?.toInt()

                    // USE_YN 처리
                    if (formatList!!.contains("rcs")) {
                        tblmiContLstdto.use_yn = "Y"
                    } else {
                        tblmiContLstdto.use_yn = "N"
                    }

                    tblmiContLstdto.cont_tp = "DMTP04"
                    tblmiContLstdto.rcs_footer = contentListCreatedto.rcs_footer

                    // rcs 광고 , 유형 선택
                    val rcsOption = contentListCreatedto.rcs_option!!.trim()

                    if (rcsOption.equals("ad")) {
                        // 광고 처리
                        tblmiContLstdto.send_tp = "SENDTP01"
                    } else if (rcsOption.equals("guide")) {
                        // 안내 처리
                        tblmiContLstdto.send_tp = "SENDTP02"
                    }

                    val rcsFormatType = contentListCreatedto.rcs_format_type!!.trim()   // rcs 포멧 타입
                    val rcsMsgType = contentListCreatedto.rcs_msg_tp!!.trim() // rcs 메세지 타입

                    if (rcsFormatType.equals("text")) {
                        // RCS 텍스트 형의 경우
                        if (rcsMsgType.equals("sms")) {
                            // SMS의 경우
                            tblmiContLstdto.msg_tp = "DMCH205"

                            // SMS Key 값 설정
                            val cdDto = Tblmi_comm_cdDto()
                            cdDto.grp_id = "RCS_SMS_MSG_ID"
                            cdDto.cd_id = userInfo.usr_grp_cd

                            val codeDto = systemDao.getCommCdKeyValueNull(cdDto)
                            if (codeDto != null) {
                                tblmiContLstdto.key_id = codeDto.cd_val
                            }

                        } else if (rcsMsgType.equals("lms")) {
                            // LMS의 경우
                            tblmiContLstdto.msg_tp = "DMCH206"

                            // LMS 키 값 설정
                            val cdDto = Tblmi_comm_cdDto()
                            cdDto.grp_id = "RCS_LMS_MSG_ID"
                            cdDto.cd_id = userInfo.usr_grp_cd

                            val codeDto = systemDao.getCommCdKeyValueNull(cdDto)
                            if (codeDto != null) {
                                tblmiContLstdto.key_id = codeDto.cd_val
                            }

                        }
                        tblmiContLstdto.cont_body = contentListCreatedto.rcs_body
                    }
                    // 2021-05-03 가로형 삭제로 인한 주석 처리
                    /*else if (rcsFormatType.equals("horizontal")) {
                        if (rcsMsgType.equals("left")) {
                            tblmiContLstdto.msg_tp = "DMCH209"

                            val cdDto = Tblmi_comm_cdDto()
                            cdDto.grp_id = "RCS_W_LEFT_MSG_ID"
                            cdDto.cd_id = userInfo.usr_grp_cd

                            val codeDto = systemDao.getCommCdKeyValueNull(cdDto)
                            if (codeDto != null) {
                                tblmiContLstdto.key_id = codeDto.cd_val
                            }

                        } else if (rcsMsgType.equals("right")) {
                            tblmiContLstdto.msg_tp = "DMCH210"

                            val cdDto = Tblmi_comm_cdDto()
                            cdDto.grp_id = "RCS_W_RIGHT_MSG_ID"
                            cdDto.cd_id = userInfo.usr_grp_cd

                            val codeDto = systemDao.getCommCdKeyValueNull(cdDto)
                            if (codeDto != null) {
                                tblmiContLstdto.key_id = codeDto.cd_val
                            }

                        }
                        val jsonBody = JSONObject()

                        jsonBody["title"] = contentListCreatedto.cont_sub_list?.get(i)
                        jsonBody["description"] = contentListCreatedto.rcs_body

                        tblmiContLstdto.cont_body = jsonBody.toJSONString().replace("\\r\\n","\\\\r\\\\n")
                        tblmiContLstdto.img_cd_1 = contentListCreatedto.horizonImg

                    }*/
                    else if (rcsFormatType.equals("vertical")) {
                        // RCS 세로형의 경우
                        if (rcsMsgType.equals("tall")) {
                            // tall형 인 경우
                            tblmiContLstdto.msg_tp = "DMCH207"

                            // RCS 세로형 Tall Key 값 설정
                            val cdDto = Tblmi_comm_cdDto()
                            cdDto.grp_id = "RCS_L_TALL_MSG_ID"
                            cdDto.cd_id = userInfo.usr_grp_cd

                            val codeDto = systemDao.getCommCdKeyValueNull(cdDto)
                            if (codeDto != null) {
                                tblmiContLstdto.key_id = codeDto.cd_val
                            }

                        } else if (rcsMsgType.equals("medium")) {
                            // Medium 경우
                            tblmiContLstdto.msg_tp = "DMCH208"

                            // RCS 세로형 Medium Key 값 설정
                            val cdDto = Tblmi_comm_cdDto()
                            cdDto.grp_id = "RCS_L_MD_MSG_ID"
                            cdDto.cd_id = userInfo.usr_grp_cd

                            val codeDto = systemDao.getCommCdKeyValueNull(cdDto)
                            if (codeDto != null) {
                                tblmiContLstdto.key_id = codeDto.cd_val
                            }
                        }

                        val jsonBody = JSONObject()

                        jsonBody["title"] = contentListCreatedto.cont_sub_list?.get(i)
                        jsonBody["description"] = contentListCreatedto.rcs_body

                        // 공백 파싱 처리
                        //tblmiContLstdto.cont_body = jsonBody.toString().replace("\\r\\n","\\\\r\\\\n")
                        tblmiContLstdto.cont_body = jsonBody.toString();
                        tblmiContLstdto.img_cd_1 = contentListCreatedto.verticalImg

                    } else if (rcsFormatType.equals("slide")) {
                        // 슬라이드 형의 경우 타입 설정
                        if (rcsMsgType.equals("small")) {
                            tblmiContLstdto.msg_tp = "DMCH211"
                        } else if (rcsMsgType.equals("medium")) {
                            tblmiContLstdto.msg_tp = "DMCH212"
                        }
                        // RCS 슬라이드 관련 INSERT 처리
                        rcsSlideSetting(contentListCreatedto, tblmiContLstdto)
                    } else {
                        // 에러 발생
                        logger.error("RCS TYPE 에러 발생")
                    }

                    // RCS 버튼 체크 기능 개발
                    if (rcsFormatType.equals("slide")) {
                        rcsButtonMakeJsonStringSlide(contentListCreatedto, tblmiContLstdto)
                    } else {
                        // Button이 1개이상 존재할때 Json형태로 버튼 Insert
                        rcsButtonMakeJsonString(contentListCreatedto, tblmiContLstdto)
                    }

                }
                contentDao.insertContent(tblmiContLstdto)

                // Url 처리
                val lastSeq = tblmiContLstdto.seq

                /**
                 *  URL 저장하기 로직
                 *  카카오, 모바일 같은 경우 알맞게 저장된다
                 *  RCS의 경우
                 *      1) slide가 아닐때 버튼 순서대로 들어간다
                 *      2) slide형태는 최대 버튼 개수가 2개 이므로 2개씩 끊어서 판단한다
                 *      (ex : urlBtn3, urlBtn5 로 저장 되었다면 카드 2의 1번 버튼 ,카드 3의 1번 버튼에 저장됨 )
                 */

                if (i == 0) {

                    // 카카오 이미지 URL 링크 저장
                    if (!CommonUtils.isEmptyObject(contentListCreatedto.kko_img_url)) {
                        val contUrlDto: Tblmi_cont_url_lstDto = Tblmi_cont_url_lstDto()
                        contUrlDto.url_tag = "img"
                        contUrlDto.url = contentListCreatedto.kko_img_url
                        contUrlDto.url_id = "kkoImg001"
                        contUrlDto.cont_lst_cd = lastSeq
                        contentDao.insertContentUrl(contUrlDto)
                    }

                    // 카카오 버튼 링크 저장
                    if (!CommonUtils.isEmptyObject(contentListCreatedto.kko_btn_url)) {
                        val contUrlDto: Tblmi_cont_url_lstDto = Tblmi_cont_url_lstDto()
                        contUrlDto.url_tag = "btn"
                        contUrlDto.url = contentListCreatedto.kko_btn_url
                        contUrlDto.url_id = "kkoBtn001"
                        contUrlDto.cont_lst_cd = lastSeq
                        contentDao.insertContentUrl(contUrlDto)
                    }

                    // 카카오 본문 a 링크 저장
                    val url_kakao_body = contentListCreatedto.kakao_body
                    if (url_kakao_body?.contains("{{") == true) {

                        val regex = "\\{\\{[^{]+}}"
                        val p = Pattern.compile(regex)
                        val matcher = p.matcher(url_kakao_body)

                        var start = 0
                        var chk = true
                        var i = 0
                        var idx = 0;

                        while (chk) {
                            if (matcher.find(start)) {
                                start = matcher.start() + matcher.group().length
                                val url = matcher.group()
                                    .replace("{{", "")
                                    .replace("}}", "")
                                if (url.contains("http") || url.contains("https")) {
                                    // {{ }} 규칙에 맞는 형태이며, http, https 를 포함하고 있다면 URL을 저장한다
                                    idx++
                                    val contUrlDto: Tblmi_cont_url_lstDto = Tblmi_cont_url_lstDto()
                                    contUrlDto.url_tag = "a"
                                    contUrlDto.url = url
                                    if (idx >= 10) {
                                        contUrlDto.url_id = "kkoTrk0" + idx
                                    } else {
                                        contUrlDto.url_id = "kkoTrk00" + idx
                                    }
                                    contUrlDto.cont_lst_cd = lastSeq
                                    contentDao.insertContentUrl(contUrlDto)
                                }
                            } else {
                                chk = false
                            }
                        }

                    }
                }
                if (i == 1) {

                    // 모바일 이미지 a 링크 저장 (이미지 경로)
                    if (!CommonUtils.isEmptyObject(contentListCreatedto.mms_imgurl)) {
                        val contUrlDto: Tblmi_cont_url_lstDto = Tblmi_cont_url_lstDto()
                        contUrlDto.url_tag = "a"
                        contUrlDto.url = contentListCreatedto.mms_imgurl
                        contUrlDto.url_id = "mmsImg001"
                        contUrlDto.cont_lst_cd = lastSeq
                        contentDao.insertContentUrl(contUrlDto)
                    }

                    // 모바일 본문 추적 a 링크 저장
                    val url_sms_body = contentListCreatedto.sms_body
                    if (url_sms_body?.contains("{{") == true) {

                        val regex = "\\{\\{[^{]+}}"
                        val p = Pattern.compile(regex)
                        val matcher = p.matcher(url_sms_body)

                        var start = 0
                        var chk = true
                        var i = 0
                        var idx = 0;

                        while (chk) {
                            if (matcher.find(start)) {
                                start = matcher.start() + matcher.group().length
                                val url = matcher.group()
                                    .replace("{{", "")
                                    .replace("}}", "")
                                if (url.contains("http") || url.contains("https")) {
                                    // {{ }} 규칙에 맞는 형태이며, http, https 를 포함하고 있다면 URL을 저장한다
                                    idx++
                                    val contUrlDto: Tblmi_cont_url_lstDto = Tblmi_cont_url_lstDto()
                                    contUrlDto.url_tag = "a"
                                    contUrlDto.url = url
                                    if (idx >= 10) {
                                        contUrlDto.url_id = "smsTrk0" + idx
                                    } else {
                                        contUrlDto.url_id = "smsTrk00" + idx
                                    }
                                    contUrlDto.cont_lst_cd = lastSeq
                                    contentDao.insertContentUrl(contUrlDto)
                                }
                            } else {
                                chk = false
                            }
                        }

                    }

                }

                if (i == 2) {
                    val urlLen = contentListCreatedto.url_value?.size   // 버튼 창이 클릭되면 hidden 값으로 idx 맞게 들어온다

                    if (urlLen != null) {
                        // 버튼이 한 개라도 입력될 경우 URL을 등록한다 ( 버튼이 한 개라도 존재시 빈 값으로 넘어온다)
                        for (i in 0 until urlLen) {

                            val urlValue = contentListCreatedto?.url_value?.get(i)?.trim()
                            val fallback_url_position = contentListCreatedto?.fallback_url_04?.get(i)?.trim()
                            val fallback_url_query = contentListCreatedto?.fallback_url_05?.get(i)?.trim()

                            if (!CommonUtils.isEmptyObject(urlValue)) {
                                val contUrlDto = Tblmi_cont_url_lstDto()
                                contUrlDto.url_tag = "btn"
                                contUrlDto.url = urlValue
                                contUrlDto.url_id = "urlBtn" + (i + 1)
                                contUrlDto.cont_lst_cd = lastSeq
                                contentDao.insertContentUrl(contUrlDto)
                            }

                            if (!CommonUtils.isEmptyObject(fallback_url_position)) {
                                val contUrlDto = Tblmi_cont_url_lstDto()
                                contUrlDto.url_tag = "btn"
                                contUrlDto.url = fallback_url_position
                                contUrlDto.url_id = "fallPosiBtn" + (i + 1)
                                contUrlDto.cont_lst_cd = lastSeq
                                contentDao.insertContentUrl(contUrlDto)
                            }

                            if (!CommonUtils.isEmptyObject(fallback_url_query)) {
                                val contUrlDto = Tblmi_cont_url_lstDto()
                                contUrlDto.url_tag = "btn"
                                contUrlDto.url = fallback_url_query
                                contUrlDto.url_id = "fallQueryBtn" + (i + 1)
                                contUrlDto.cont_lst_cd = lastSeq
                                contentDao.insertContentUrl(contUrlDto)
                            }
                        }
                    }
                }

            }
        } catch (e: Exception) {
            logger.error("마스터 코드 " + tblmiContMstDto.seq);
            e.printStackTrace()
            // url 삭제하기
            val lstSeqDto = Tblmi_cont_lstDto()
            lstSeqDto.cont_cd = tblmiContMstDto.seq
            val urlSeqLstList = contentDao.selectLstSeq(lstSeqDto)
            for (i in 0 until urlSeqLstList.size) {
                val seq = urlSeqLstList[i].seq
                contentDao.deleteRealContUrl(Tblmi_cont_url_lstDto(seq))
            }
            // mst 삭제하기
            contentDao.deleteRealContMst(Tblmi_cont_mstDto(tblmiContMstDto.seq))
            // lst 삭제하기
            val lstDto = Tblmi_cont_lstDto()
            lstDto.cont_cd = tblmiContMstDto.seq
            contentDao.deleteRealContLst(lstDto)
            statusMap["status"] = false
            return statusMap
        }

        return statusMap
    }

    /**
     * @Method Name  : isCheckByte
     * @Since    : 2021. 03. 24
     * @author   : Grayson
     * @param    : dto: Content_list_CreateDto
     * @return   : Boolean
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 앞단에서 체크하지 못한 byte 체크를 백단에서 체크한다
     * @title : 모바일 컨텐츠 바이트 체크
     */

    private fun isCheckByte(dto: Content_list_CreateDto): Boolean {
        // 카카오의 본문 body byte를 체크한다
        if (!CommonUtils.isEmptyObject(dto.kakao_body)) {

            if (!CommonUtils.isEmptyObject(dto.kko_img_cd)) {
                if (!CommonUtils.checkByteLength(dto.kakao_body, 400)) {
                    logger.error("KaKao 400Byte Error")
                    return false;
                }
            } else if (CommonUtils.isEmptyObject(dto.kko_img_cd)) {
                if (!CommonUtils.checkByteLength(dto.kakao_body, 2000)) {
                    logger.error("KaKao 2000Byte Error")
                    return false;
                }
            }
        }

        val sms_cont_sub = dto.cont_sub_list!![1].trim()
        val smsMsgTp = dto.sms_msg_tp

        // 문자의 경우 제목 byte 체크 필요
        if (!CommonUtils.checkByteLength(sms_cont_sub, 40)) {
            logger.error("SMS Title 40Byte Error")
            return false;
        }

        if (smsMsgTp.equals("LMS")) {     // LMS의 경우 본문 Byte 2000 제한
            if (!CommonUtils.checkByteLength(dto.sms_body, 2000)) {
                logger.error("LMS 2000 Byte Error")
                return false;
            }
        } else if (smsMsgTp.equals("MMS")) {
            //  MMS의 경우 본문 2000 Byte 제한
            // 단, 이미지가 1개일때만 2000Byte 까지 제한하고, 여러개면 1000Byte로 제한한다
            if (!CommonUtils.checkByteLength(dto.sms_body, 2000)) {
                logger.error("MMS 2000 Byte Error")
                return false;
            }
        } else if (smsMsgTp.equals("SMS")) { // SMS 의 경우 본문 90 Byte 제한
            if (!CommonUtils.checkByteLength(dto.sms_body, 90)) {
                logger.error("SMS 90 Byte Error")
                return false
            }
        }
        return true;
    }


    /**
     * @Method Name  : selectSenderList
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : tblmiSetLstDto: Tblmi_set_lstDto
     * @return   : Map<String, Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 발신자 리스트 가져오기
     * @title : 발신자 리스트 가져오기
     */

    override fun selectSenderList(tblmiSetLstDto: Tblmi_set_lstDto): Map<String, Any> {

        val searchDto = tblmiSetLstDto as SetLst_searchDto
        val paramMap: MutableMap<String, Any> = HashMap()
        val paginationInfo: PaginationInfo = UsefulUtils.makePage(searchDto.pageNo, 10, 5)

        searchDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        searchDto.firstIndex = paginationInfo.firstRecordIndex
        searchDto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = contentDao.selectSenderListCnt(searchDto)

        paramMap["page"] = paginationInfo
        paramMap["pageNo"] = paginationInfo.currentPageNo
        paramMap["list"] = contentDao.selectSenderList(searchDto)
        paramMap["listCnt"] = contentDao.selectSenderListCnt(searchDto)

        return paramMap
    }


    /**
     * @Method Name  : isCheckMoblieContentNm
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : tblmiContMstdto: Tblmi_cont_mstDto
     * @return   : Map<String, Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 컨텐츠 명 중복 확인 하기
     * @title : 컨텐츠 명 중복 확인 하기
     */

    override fun checkContNm(tblmiContMstdto: Tblmi_cont_mstDto): Int {
        tblmiContMstdto.cont_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        return contentDao.checkContNm(tblmiContMstdto)
    }


    /**
     * @Method Name  : selectContentView
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : dto: Tblmi_cont_mstDto
     * @return   : Map<String, Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 모바일 컨텐츠 리스트
     * @title : 컨텐츠 명 중복 확인 하기
     */

    override fun selectContentView(dto: Tblmi_cont_mstDto): Map<String, Any> {
        val paramMap: MutableMap<String, Any> = HashMap()
        val searchDto = dto as Contents_searchDto

        if (searchDto.searchType == "cont_nm") {
            searchDto.cont_nm = searchDto.searchValue
        } else if (searchDto.searchType == "cont_sub") {
            searchDto.cont_sub = searchDto.searchValue
        } else if (searchDto.searchType == "use_yn") {
            searchDto.use_yn = searchDto.searchValue
        }

        val paginationInfo: PaginationInfo = UsefulUtils.makePage(searchDto.pageNo, 4, 4)

        searchDto.ch_tp = "CH03"
        searchDto.del_yn = "N"
        searchDto.firstIndex = paginationInfo.firstRecordIndex
        searchDto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = selectMobileContentCnt(searchDto)

        paramMap["page"] = paginationInfo
        paramMap["pageNo"] = paginationInfo.currentPageNo
        paramMap["listCnt"] = paginationInfo.totalRecordCount
        paramMap["list"] = selectMobileContent(searchDto)

        paramMap["nextCk"] = paginationInfo.currentPageNo != paginationInfo.lastPageNo

        return paramMap
    }

    private fun selectMobileContentCnt(tblmiContMstdto: Tblmi_cont_mstDto): Int {
        return contentDao.selectMobileContentCnt(tblmiContMstdto)
    }


    /**
     * @Method Name  : updateContentMst
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : dto: Tblmi_cont_mstDto
     * @return   : Map<String, Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 모바일 컨텐츠 USE_YN 업데이트 하기
     * @title : 모바일 컨텐츠 수정
     */

    override fun updateContentMst(dto: Tblmi_cont_mstDto): Map<String, Any> {
        val paramMap: MutableMap<String, Any> = HashMap()
        val userInfo = UsefulUtils.sessionUser()

        dto.upd_id = userInfo.usr_id
        dto.cont_grp_cd = userInfo.usr_grp_cd

        contentDao.updateMobileUseYn(dto)
        paramMap["result"] = "success"
        return paramMap;
    }


    /**
     * @Method Name  : updateContentsMstDelYn
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : list: MutableList<Int>
     * @return   : Map<String, Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 모바일 컨텐츠 체크 삭제 Del_yn 업데이트 하기
     * @title : 모바일 컨텐츠 수정
     */

    override fun updateContentsMstDelYn(list: MutableList<Int>): Map<String, Any> {
        val paramMap: MutableMap<String, String> = HashMap()
        val deleteMobileDto = Tblmi_cont_mstDto()
        val usrId = UsefulUtils.sessionUser().usr_id
        var delCnt = 0

        for (i in list) {
            deleteMobileDto.seq = i
            deleteMobileDto.del_yn = "Y"
            deleteMobileDto.upd_id = usrId
            contentDao.deleteMobileContent(deleteMobileDto)
            delCnt++
        }

        paramMap["message"] = delCnt.toString() + "개의 모바일 컨텐츠가 삭제 되었습니다"
        paramMap["status"] = "true"
        return paramMap
    }

    // ContentService를 위한 임시 로직
    override fun contents_thumbnail_save(map: MutableMap<String, Any>): Boolean {
        TODO("Not yet implemented")
    }


    /**
     * @Method Name  : selectMobileContent
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : dto: Tblmi_cont_mstDto
     * @return   : List<Tblmi_cont_lstDto>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 리스트 화면에 필요한 Json 양식 형태로 모바일 컨텐츠 출력 -> 05.03 파싱 제거 수정
     * @title : 모바일 컨텐츠 리스트 뽑아내기
     */
    private fun selectMobileContent(dto: Tblmi_cont_mstDto): List<Contents_lstDto> {
        return contentDao.selectMobileContent(dto)
    }

    /**
     * @Method Name  : selectOneMobileContent
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : dto: Tblmi_cont_mstDto
     * @return   : List<Content_view_Dto>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 수정 화면에 필요한 형태를 Json 양식으로 출력
     * @title : 모바일 컨텐츠 뽑아내기
     */
    private fun selectOneMobileContent(dto: Tblmi_cont_mstDto): List<Content_view_Dto> {

        val contentOne = contentDao.detailMobileContent(dto)
        val contentOneList = mutableListOf<Content_view_Dto>()
        val len = contentOne.size

        for (i in 0 until len) {
            //logger.error("one content: " + contentOne[i])
            val dto = contentOne[i]

            if (dto.cont_tp.equals("DMTP04")) {
                // RCS 형태인 경우 Json 파싱해서 뷰에 뿌려준다
                jsonOneContentsParsing(dto)
            }
            if (!CommonUtils.isEmptyObject(dto.rcs_btn_obj)) {
                jsonButtonParsing(dto)
            }
            // 이전에 선택한 쿠폰 시퀀스와 이름 조회
            if (dto.cont_tp.equals("DMTP02") && !dto.coupon_seq.isNullOrEmpty()) {
                val selectCoupon = couponDao.selectCoupon(dto.coupon_seq!!.toInt())
                dto.coupon_nm = selectCoupon.nm
                dto.coupon_seq = AES256.AES_Encode(dto.coupon_seq, GlobalValues.encKey)
            }
            contentOneList.add(dto)
        }
        return contentOneList
    }


    /**
     * @Method Name  : selectOneContentView
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : tblmiContMstdto : Tblmi_cont_mstDto
     * @return   : Map<String, Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이미지가 포함된 모바일 디테일 리스트를 가져온다
     * @title  : 모바일 컨텐츠 가져오기
     */

    override fun selectOneContentView(dto: Tblmi_cont_mstDto): Map<String, Any> {
        val paramMap: MutableMap<String, Any> = HashMap()

        //paramMap["list"] = contentDao.detailMobileContent(dto)
        paramMap["list"] = selectOneMobileContent(dto)

        return paramMap
    }


    /**
     * @Method Name  : updateContentLst
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : contentListCreatedto : Content_list_CreateDto
     * @return   : Map<String, Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 모바일 컨텐츠 수정하기
     * @title  : 모바일 컨텐츠 수정
     */

    override fun updateContentLst(dto: Tblmi_cont_lstDto): Map<String, Any> {
        val contentListCreatedto = dto as Content_list_CreateDto
        val userInfo = UsefulUtils.sessionUser()
        val statusMap: MutableMap<String, Any> = HashMap()
        val tblmiContMstDto = Tblmi_cont_mstDto()

        val isByte = isCheckByte(contentListCreatedto);

        if (!isByte) {
            statusMap["status"] = false
            return statusMap
        }

        tblmiContMstDto.seq = contentListCreatedto.mst_seq!!.toInt()
        tblmiContMstDto.ch_tp = "CH02"
        tblmiContMstDto.cont_nm = contentListCreatedto.cont_nm
        tblmiContMstDto.reg_id = userInfo.usr_id
        tblmiContMstDto.upd_id = userInfo.usr_id
        tblmiContMstDto.cont_grp_cd = userInfo.usr_grp_cd

        contentDao.updateMobileMst(tblmiContMstDto)

        val len = contentListCreatedto.send_to_list!!.size - 1;

        for (i in 0..len) {
            // 기존 URL 정보 삭제
            contentDao.deleteRealContUrl(Tblmi_cont_url_lstDto(contentListCreatedto.list_seq!![i]))
            // 항상 3번 Insert 작업을 진행한다.

            // 공통 값은 배열로 받아 처리, 나머지는 각자 처리
            val tblmiContLstdto = Tblmi_cont_lstDto()

            tblmiContLstdto.seq = contentListCreatedto.list_seq!![i]
            tblmiContLstdto.cont_cd = tblmiContMstDto.seq
            tblmiContLstdto.cont_sub = contentListCreatedto.cont_sub_list!![i].trim()
            tblmiContLstdto.send_to = contentListCreatedto.send_to_list!![i]
            tblmiContLstdto.send_nm = null
            tblmiContLstdto.thm_url = null
            tblmiContLstdto.br_yn = "N"
            tblmiContLstdto.sup_yn = "N"
            tblmiContLstdto.reg_id = userInfo.usr_id
            tblmiContLstdto.upd_id = userInfo.usr_id
            tblmiContLstdto.cont_grp_cd = userInfo.usr_grp_cd

            val formatList = contentListCreatedto.formatType

            // 인덱스 번호 0 : 카카오
            if (i == 0) {
                // 체크 여부에 따라 USE_YN 설정
                if (formatList!!.contains("kakao")) {
                    tblmiContLstdto.use_yn = "Y"
                } else {
                    tblmiContLstdto.use_yn = "N"
                }

                val kkoOption = contentListCreatedto.kko_option!!.trim()
                if (kkoOption == "ad") {
                    // 광고 처리
                    tblmiContLstdto.send_tp = "SENDTP01"
                } else if (kkoOption == "guide") {
                    // 안내 처리
                    tblmiContLstdto.send_tp = "SENDTP02"
                }

                if ("kko_at" == contentListCreatedto.kko_format_type) {  // 알림톡
                    // 템플릿 조회
                    val atDto =  AtTmpl_searchDto(contentListCreatedto.key_id, contentListCreatedto.tmpl_nm,"Y")
                    atDto.usr_grp_cd =contentListCreatedto.cont_grp_cd
                    atDto.kep_status = "O"  // 승인완료

                    val resultDto = kkoAtTmplDao.selTmplBytmplDto(atDto)
                    if(!CommonUtils.isEmptyObject(resultDto)){
                        tblmiContLstdto.key_id = resultDto.tmpl_cd

                        val g = GsonBuilder().create()
                        val obj = JsonObject()
                        obj.add("button",g.fromJson(resultDto.button_json, JsonArray::class.java))
                        obj.add("quick_reply",g.fromJson(resultDto.quick_repl_json, JsonArray::class.java))
                        obj.add("item_highlight", g.fromJson(resultDto.item_highlight_json, JsonObject::class.java))
                        obj.add("item", g.fromJson(resultDto.item_json, JsonObject::class.java))
                        tblmiContLstdto.kko_btn_obj = g.toJson(obj)
                        tblmiContLstdto.kko_img_cd = resultDto.img_seq
                        tblmiContLstdto.kko_img_url = resultDto.kko_img_url
                        tblmiContLstdto.kko_title = resultDto.tmpl_tit
                        tblmiContLstdto.kko_header = resultDto.tmpl_header
                        tblmiContLstdto.kko_msg_tp = if (resultDto.tmpl_empsize_tp == "IMAGE") "AI" else "AT"

                        tblmiContLstdto.cont_tp = "DMTP05"
                        tblmiContLstdto.msg_tp = "DMCH216"

                        tblmiContLstdto.cont_body = resultDto.tmpl_cont
                    }
                }else{
                    // key_id 로 발신키 유효한지 확인
                    val cdDto = Tblmi_comm_cdDto()
                    cdDto.grp_id = "KAKAO_KEY"
                    cdDto.cd_id = userInfo.usr_grp_cd

                    val kkoDto = SetLst_searchDto("CH02","DMTP03","Y",UsefulUtils.sessionUser().usr_grp_cd)
                    kkoDto.list_val = contentListCreatedto.key_id
                    val kkoSenderLst = contentDao.selectSenderList(kkoDto)

                    if (kkoSenderLst.isNotEmpty()) {
                        tblmiContLstdto.key_id = kkoSenderLst[0].list_val
                    }

                    tblmiContLstdto.cont_tp = "DMTP03" // 카카오
                    tblmiContLstdto.msg_tp = "DMCH204" // 친구톡

                    // 카카오 이미지 처리
                    if (CommonUtils.isEmptyObject(contentListCreatedto.kko_img_cd)) {
                        tblmiContLstdto.kko_img_cd = null
                    } else {
                        tblmiContLstdto.kko_img_cd = contentListCreatedto.kko_img_cd
                    }

                    tblmiContLstdto.cont_body = contentListCreatedto.kakao_body
                    tblmiContLstdto.kko_img_url = contentListCreatedto.kko_img_url
                    tblmiContLstdto.kko_btn_nm = contentListCreatedto.kko_btn_nm
                    tblmiContLstdto.kko_btn_url = contentListCreatedto.kko_btn_url
                    tblmiContLstdto.kko_btn_nm2 = contentListCreatedto.kko_btn_nm2
                    tblmiContLstdto.kko_btn_url2 = contentListCreatedto.kko_btn_url2
                    tblmiContLstdto.kko_btn_nm3 = contentListCreatedto.kko_btn_nm3
                    tblmiContLstdto.kko_btn_url3 = contentListCreatedto.kko_btn_url3
                    tblmiContLstdto.kko_btn_nm4 = contentListCreatedto.kko_btn_nm4
                    tblmiContLstdto.kko_btn_url4 = contentListCreatedto.kko_btn_url4
                    tblmiContLstdto.kko_btn_nm5 = contentListCreatedto.kko_btn_nm5
                    tblmiContLstdto.kko_btn_url5 = contentListCreatedto.kko_btn_url5
                }
            }

            // 인덱스 번호 1: SMS (문자 )
            if (i == 1) {
                if (formatList!!.contains("sms")) {
                    tblmiContLstdto.use_yn = "Y"
                } else {
                    tblmiContLstdto.use_yn = "N"
                }
                tblmiContLstdto.cont_tp = "DMTP02"

                // SMS 광고 , 안내 유형 선택
                val smsOption = contentListCreatedto.sms_option!!.trim()

                if (smsOption == "ad") {
                    // 광고 처리
                    tblmiContLstdto.send_tp = "SENDTP01"
                } else if (smsOption == "guide") {
                    // 안내 처리
                    tblmiContLstdto.send_tp = "SENDTP02"
                }

                val smsMsgTp = contentListCreatedto.sms_msg_tp

                // SMS 문자 타입 설정
                if (smsMsgTp.equals("LMS")) {
                    tblmiContLstdto.msg_tp = "DMCH202"
                    tblmiContLstdto.img_cd_1 = null
                } else if (smsMsgTp.equals("MMS")) {
                    tblmiContLstdto.msg_tp = "DMCH203"
                    tblmiContLstdto.img_cd_1 = contentListCreatedto.mds_img_cd
                } else {
                    tblmiContLstdto.msg_tp = "DMCH201"
                    tblmiContLstdto.img_cd_1 = null
                }
                tblmiContLstdto.cont_body = contentListCreatedto.sms_body
            }

            // 인덱스 번호 2: RCS 분기 처리
            if (i == 2) {

                // RCS 포멧타입 변경에 따라 Key 값이 바뀔 수 있으므로 활성화 해준다

                tblmiContLstdto.img_cd_1 = contentListCreatedto.rcs_img_cd_1
                tblmiContLstdto.img_cd_2 = contentListCreatedto.rcs_img_cd_2
                tblmiContLstdto.img_cd_3 = contentListCreatedto.rcs_img_cd_3
                tblmiContLstdto.img_cd_4 = contentListCreatedto.rcs_img_cd_4
                tblmiContLstdto.img_cd_5 = contentListCreatedto.rcs_img_cd_5
                tblmiContLstdto.img_cd_6 = contentListCreatedto.rcs_img_cd_6

                // USE_YN 처리
                if (formatList!!.contains("rcs")) {
                    tblmiContLstdto.use_yn = "Y"
                } else {
                    tblmiContLstdto.use_yn = "N"
                }

                tblmiContLstdto.cont_tp = "DMTP04"
                tblmiContLstdto.rcs_footer = contentListCreatedto.rcs_footer

                // rcs 광고 , 유형 선택
                val rcsOption = contentListCreatedto.rcs_option!!.trim()

                if (rcsOption.equals("ad")) {
                    // 광고 처리
                    tblmiContLstdto.send_tp = "SENDTP01"
                } else if (rcsOption.equals("guide")) {
                    // 안내 처리
                    tblmiContLstdto.send_tp = "SENDTP02"
                }

                val rcsFormatType = contentListCreatedto.rcs_format_type!!.trim()   // rcs 포멧 타입
                val rcsMsgType = contentListCreatedto.rcs_msg_tp!!.trim() // rcs 메세지 타입

                when (rcsFormatType) {
                    "text" -> {
                        // RCS 텍스트 형의 경우
                        if (rcsMsgType == "sms") {
                            // SMS의 경우
                            tblmiContLstdto.msg_tp = "DMCH205"

                            // RCS SMS key 값 설정
                            val cdDto = Tblmi_comm_cdDto()
                            cdDto.grp_id = "RCS_SMS_MSG_ID"
                            cdDto.cd_id = userInfo.usr_grp_cd

                            val codeDto = systemDao.getCommCdKeyValueNull(cdDto)
                            if (codeDto != null) {
                                tblmiContLstdto.key_id = codeDto.cd_val
                            }

                        } else if (rcsMsgType.equals("lms")) {
                            // LMS의 경우
                            tblmiContLstdto.msg_tp = "DMCH206"

                            // RCS LMS Key 값 설정
                            val cdDto = Tblmi_comm_cdDto()
                            cdDto.grp_id = "RCS_LMS_MSG_ID"
                            cdDto.cd_id = userInfo.usr_grp_cd

                            val codeDto = systemDao.getCommCdKeyValueNull(cdDto)
                            if (codeDto != null) {
                                tblmiContLstdto.key_id = codeDto.cd_val
                            }
                        }
                        tblmiContLstdto.cont_body = contentListCreatedto.rcs_body
                    }
                    // RCS 가로형 서비스 중단으로 인한 삭제 처리
                    /*else if (rcsFormatType.equals("horizontal")) {
                        if (rcsMsgType.equals("left")) {

                            tblmiContLstdto.msg_tp = "DMCH209"
                        } else if (rcsMsgType.equals("right")) {
                            tblmiContLstdto.msg_tp = "DMCH210"
                        }

                        val jsonBody = JSONObject()
                        jsonBody["title"] = contentListCreatedto.cont_sub_list?.get(i)
                        jsonBody["description"] = contentListCreatedto.rcs_body
                        tblmiContLstdto.cont_body = jsonBody.toString().replace("\\r\\n","\\\\r\\\\n")
                        tblmiContLstdto.img_cd_1 = contentListCreatedto.horizonImg

                    }*/
                    "vertical" -> {
                        // RCS 세로형의 경우
                        if (rcsMsgType == "tall") {
                            // tall형 인 경우
                            tblmiContLstdto.msg_tp = "DMCH207"

                            // RCS 세로형 Tall Key 값 설정
                            val cdDto = Tblmi_comm_cdDto()
                            cdDto.grp_id = "RCS_L_TALL_MSG_ID"
                            cdDto.cd_id = userInfo.usr_grp_cd

                            val codeDto = systemDao.getCommCdKeyValueNull(cdDto)
                            if (codeDto != null) {
                                tblmiContLstdto.key_id = codeDto.cd_val
                            }

                        } else if (rcsMsgType == "medium") {
                            // medium인 경우
                            tblmiContLstdto.msg_tp = "DMCH208"

                            // RCS 세로형 Medium Key 값 설정
                            val cdDto = Tblmi_comm_cdDto()
                            cdDto.grp_id = "RCS_L_MD_MSG_ID"
                            cdDto.cd_id = userInfo.usr_grp_cd

                            val codeDto = systemDao.getCommCdKeyValueNull(cdDto)
                            if (codeDto != null) {
                                tblmiContLstdto.key_id = codeDto.cd_val
                            }

                        }

                        // Json 바디 형태로 저장
                        val jsonBody = JSONObject()
                        jsonBody["title"] = contentListCreatedto.cont_sub_list?.get(i)
                        jsonBody["description"] = contentListCreatedto.rcs_body
                        tblmiContLstdto.cont_body = jsonBody.toString()
                        //.replace("\\r\\n", "\\\\r\\\\n")
                        tblmiContLstdto.img_cd_1 = contentListCreatedto.verticalImg

                    }
                    "slide" -> {
                        // 슬라이드 형의 경우 타입 설정
                        if (rcsMsgType == "small") {
                            tblmiContLstdto.msg_tp = "DMCH211"
                        } else if (rcsMsgType == "medium") {
                            tblmiContLstdto.msg_tp = "DMCH212"
                        }
                        // RCS 슬라이드 관련 INSERT 처리
                        rcsSlideSetting(contentListCreatedto, tblmiContLstdto)
                    }
                    else -> {
                        // 에러 발생
                        logger.error("RCS TYPE 에러 발생")
                    }
                }

                // RCS 버튼 체크 기능 개발
                if (rcsFormatType == "slide") {
                    // Slide 여러개 Button 처리
                    rcsButtonMakeJsonStringSlide(contentListCreatedto, tblmiContLstdto)
                } else {
                    // Button 처리
                    //logger.error("rcs button 수정 json");
                    rcsButtonMakeJsonString(contentListCreatedto, tblmiContLstdto)
                }

            }
            contentDao.updateMobileContent(tblmiContLstdto)

            val lastSeq = tblmiContLstdto.seq

            /**
             *  URL 저장하기 로직
             *  카카오, 모바일 같은 경우 알맞게 저장된다
             *  RCS의 경우
             *      1) slide가 아닐때 버튼 순서대로 들어간다
             *      2) slide형태는 최대 버튼 개수가 2개 이므로 2개씩 끊어서 판단한다
             *      (ex : urlBtn3, urlBtn5 로 저장 되었다면 카드 2의 1번 버튼 ,카드 3의 1번 버튼에 저장됨 )
             */

            if (i == 0) {
                // 카카오 url 링크 저장
                if (!CommonUtils.isEmptyObject(contentListCreatedto.kko_img_url)) {
                    insertContentUrl("img", contentListCreatedto.kko_img_url!!, "kkoImg001", lastSeq!!)
                }
                // btn 처리
                if (!CommonUtils.isEmptyObject(contentListCreatedto.kko_btn_url)) {
                    insertContentUrl("btn", contentListCreatedto.kko_btn_url!!, "kkoBtn001", lastSeq!!)
                }
                if (!CommonUtils.isEmptyObject(contentListCreatedto.kko_btn_url2)) {
                    insertContentUrl("btn", contentListCreatedto.kko_btn_url2!!, "kkoBtn002", lastSeq!!)
                }
                if (!CommonUtils.isEmptyObject(contentListCreatedto.kko_btn_url3)) {
                    insertContentUrl("btn", contentListCreatedto.kko_btn_url3!!, "kkoBtn003", lastSeq!!)
                }
                if (!CommonUtils.isEmptyObject(contentListCreatedto.kko_btn_url4)) {
                    insertContentUrl("btn", contentListCreatedto.kko_btn_url4!!, "kkoBtn004", lastSeq!!)
                }
                if (!CommonUtils.isEmptyObject(contentListCreatedto.kko_btn_url5)) {
                    insertContentUrl("btn", contentListCreatedto.kko_btn_url5!!, "kkoBtn005", lastSeq!!)
                }

                // 카카오 본문 a 링크 저장 테스트
                val urlKakaoBody = contentListCreatedto.kakao_body
                if (urlKakaoBody?.contains("{{") == true) {

                    //logger.error("contain url kakao_body : " + url_kakao_body)

                    val regex = "\\{\\{[^{]+}}"
                    val p = Pattern.compile(regex)
                    val matcher = p.matcher(urlKakaoBody)

                    var start = 0
                    var chk = true
                    var idx = 0

                    while (chk) {
                        if (matcher.find(start)) {
                            start = matcher.start() + matcher.group().length
                            val url = matcher.group()
                                .replace("{{", "")
                                .replace("}}", "")
                            if (url.contains("http") || url.contains("https")) {
                                idx++
                                // {{ }} 규칙에 맞는 형태이며, http, https 를 포함하고 있다면 URL을 저장한다
                                //logger.error("parsing url : " + url)
                                val contUrlDto: Tblmi_cont_url_lstDto = Tblmi_cont_url_lstDto()
                                contUrlDto.url_tag = "a"
                                contUrlDto.url = url
                                if (idx >= 10) {
                                    contUrlDto.url_id = "kkoTrk0$idx"
                                } else {
                                    contUrlDto.url_id = "kkoTrk00$idx"
                                }
                                contUrlDto.cont_lst_cd = lastSeq
                                contentDao.insertContentUrl(contUrlDto)
                            }
                        } else {
                            chk = false
                        }
                    }

                }
            }
            if (i == 1) {
                // 모바일 url 링크 저장
                if (!CommonUtils.isEmptyObject(contentListCreatedto.mms_imgurl)) {
                    insertContentUrl("a", contentListCreatedto.mms_imgurl!!, "mmsImg001", lastSeq!!)
                }

                /*if (!CommonUtils.isEmptyObject(contentListCreatedto.sms_trackinglink)) {
                    val contUrlDto: Tblmi_cont_url_lstDto = Tblmi_cont_url_lstDto()
                    contUrlDto.url_tag = "a"
                    contUrlDto.url = contentListCreatedto.sms_trackinglink
                    contUrlDto.url_id = "smsTrk001"
                    contUrlDto.cont_lst_cd = lastSeq
                    contentDao.insertContentUrl(contUrlDto)
                }
*/
                val url_sms_body = contentListCreatedto.sms_body

                if (url_sms_body?.contains("{{") == true) {

                    val regex = "\\{\\{[^{]+}}"
                    val p = Pattern.compile(regex)
                    val matcher = p.matcher(url_sms_body)

                    var start = 0
                    var chk = true
                    var idx = 0

                    while (chk) {
                        if (matcher.find(start)) {
                            start = matcher.start() + matcher.group().length
                            val url = matcher.group()
                                .replace("{{", "")
                                .replace("}}", "")
                            if (url.contains("http") || url.contains("https")) {
                                idx++
                                // {{ }} 규칙에 맞는 형태이며, http, https 를 포함하고 있다면 URL을 저장한다
                                //logger.error("parsing url : " + url)
                                val contUrlDto: Tblmi_cont_url_lstDto = Tblmi_cont_url_lstDto()
                                contUrlDto.url_tag = "a"
                                contUrlDto.url = url
                                if (idx >= 10) {
                                    contUrlDto.url_id = "smsTrk0" + idx
                                } else {
                                    contUrlDto.url_id = "smsTrk00" + idx
                                }
                                contUrlDto.cont_lst_cd = lastSeq
                                contentDao.insertContentUrl(contUrlDto)
                            }
                        } else {
                            chk = false
                        }
                    }

                }
            }

            if (i == 2) {
                //logger.error("rcs 버튼 url");
                val urlLen = contentListCreatedto.url_value?.size   // 버튼 창이 클릭되면 hidden 값으로 idx 맞게 들어온다

                if (urlLen != null) {
                    // 버튼이 한 개라도 입력될 경우 URL을 등록한다 ( 버튼이 한 개라도 존재시 빈 값으로 넘어온다)
                    for (j in 0 until urlLen) {
                        val urlValue = contentListCreatedto.url_value?.get(j)?.trim()
                        val fallbackUrlPosition = contentListCreatedto.fallback_url_04?.get(j)?.trim()
                        val fallbackUrlQuery = contentListCreatedto.fallback_url_05?.get(j)?.trim()

                        if (!CommonUtils.isEmptyObject(urlValue)) {
                            insertContentUrl("btn", urlValue!!, "urlBtn" + (j + 1), lastSeq!!)
                        }

                        if (!CommonUtils.isEmptyObject(fallbackUrlPosition)) {
                            insertContentUrl("btn", fallbackUrlPosition!!, "fallPosiBtn" + (j + 1), lastSeq!!)
                        }

                        if (!CommonUtils.isEmptyObject(fallbackUrlQuery)) {
                            insertContentUrl("btn", fallbackUrlQuery!!, "fallQueryBtn" + (j + 1), lastSeq!!)
                        }
                    }
                }
            }
        }
        statusMap["status"] = true
        return statusMap
    }

    /**
     * @Method Name  : isCheckSender
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @return    : Int
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 카카오 발신자 체크 하기
     * @title  카카오 발신자 체크
     */

    override fun isCheckSender(): Map<String, Any> {

        val paramMap: MutableMap<String, Any> = HashMap()

        val tblmiDto = Tblmi_set_lstDto()
        tblmiDto.list_tp_id = "CH02"
        tblmiDto.list_dt_id = "DMTP03"
        tblmiDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd

        val smsMiDto = Tblmi_set_lstDto()
        smsMiDto.list_tp_id = "CH02"
        smsMiDto.list_dt_id = "DMTP02"
        smsMiDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd

        val rcsMiDto = Tblmi_set_lstDto()
        rcsMiDto.list_tp_id = "CH02"
        rcsMiDto.list_dt_id = "DMTP04"
        rcsMiDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd

        paramMap["kakaoCnt"] = contentDao.selectSenderListCnt(tblmiDto)
        paramMap["smsCnt"] = contentDao.selectSenderListCnt(smsMiDto)
        paramMap["rcsCnt"] = contentDao.selectSenderListCnt(rcsMiDto)

        return paramMap
    }


    /**
     * @Method Name  : jsonOneContentsParsing
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : dto: Tblmi_cont_mstDto
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 뷰에 뿌려줄 Json 데이터 파싱하기
     * @title : 제이슨 컨텐츠 파싱
     */

    private fun jsonOneContentsParsing(dto: Tblmi_cont_mstDto) {
        // 수정 페이지 json 파싱하기
        val jsonParser = JsonParser()
        val dto = dto as Content_view_Dto
        val rcsMsgTp = dto.msg_tp

        if (rcsMsgTp.equals("DMCH209") || rcsMsgTp.equals("DMCH208") || rcsMsgTp.equals("DMCH207") || rcsMsgTp.equals("DMCH210")) {
            // 가로, 세로형 이라면 cont_body Json 형태 파싱
            if (dto.cont_body != null) {
                val jsonObject = jsonParser.parse(dto.cont_body).asJsonObject
                dto.cont_body = jsonObject.get("description").toString()
                    .replace("\\\\r\\\\n", "<br/>")
                    .replace("\\r\\n", "<br/>")
                    .replace("\"", "")
            }
        }
        if (rcsMsgTp.equals("DMCH211") || rcsMsgTp.equals("DMCH212")) {
            val slideJsonObject = jsonParser.parse(dto.cont_body).asJsonObject
            val len = slideJsonObject.size() / 2  // title과 description이 하나의 쌍이 되기에 나눠준다
            dto.cardSize = len.toString()

            var idx = 0
            for (i in 0 until len) {
                idx++

                val title = "title" + idx
                val description = "description" + idx

                dto.slideTitle.add(
                    slideJsonObject.get(title).toString()
                        .replace("\\\\r\\\\n", "<br/>")
                        .replace("\\r\\n", "<br/>")
                        .replace("\"", "")
                )

                dto.slideBody.add(
                    slideJsonObject.get(description).toString()
                        .replace("\\\\r\\\\n", "<br/>")
                        .replace("\\r\\n", "<br/>")
                        .replace("\"", "")
                )
            }
        }
    }

    /**
     * @Method Name  : jsonButtonParsing
     * @Since    : 2021. 03. 11
     * @author   : Grayson
     * @param    : dto: Tblmi_cont_mstDto
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 수정을 위한 Json 버튼 파싱 작업
     * @title : 제이슨 버튼 파싱
     */
    private fun jsonButtonParsing(dto: Tblmi_cont_mstDto) {
        val jsonParser = JsonParser()
        val dto = dto as Content_view_Dto
        val rcsMsgTp = dto.msg_tp

        if (rcsMsgTp.equals("DMCH205") || rcsMsgTp.equals("DMCH206") ||
            rcsMsgTp.equals("DMCH207") || rcsMsgTp.equals("DMCH208") || rcsMsgTp.equals("DMCH209")
            || rcsMsgTp.equals("DMCH210")
        ) {
            // 슬라이드 형태가 아닌 것들 Json 파싱
            // 초기 Suggestion Json 배열은 1개이다
            val jsonBtnArray = jsonParser.parse(dto.rcs_btn_obj).asJsonArray
            val jsonSuggestArray = jsonBtnArray.get(0).asJsonObject.get("suggestions").asJsonArray
            val len = jsonSuggestArray.size()

            //logger.error("jsonBtnArray : " + jsonBtnArray.size())
            // logger.error("jsonSuggestArray : " + jsonSuggestArray.size())


            for (i in 0 until len) {
                val gson = Gson()
                val suggestObj = jsonSuggestArray.get(i).asJsonObject
                val actionObj = suggestObj.get("action").asJsonObject
                val displayText = actionObj.get(BtnValueUtils.displayText);

                //logger.error("actionObj : " + actionObj.toString());

                if (!CommonUtils.isEmptyObject(actionObj?.get(BtnValueUtils.clipBoardAction))) {
                    // 복사하기 버튼
                    val dataJsonObj = actionObj?.get(BtnValueUtils.clipBoardAction)
                    val jsonDataMap = gson.fromJson(dataJsonObj.toString(), MutableMap::class.java)
                    val textData = (jsonDataMap[BtnValueUtils.copyToClipboard] as? MutableMap<*, *>)?.get(BtnValueUtils.text)

                    //logger.error("복사 데이터가 존재한다 : " + dataJsonObj.toString());

                    dto.btnData?.add(listOf(textData.toString()))
                    dto.btnType?.add(BtnValueUtils.clipBoardAction)
                    dto.btnText?.add(displayText.toString()
                        .replace("\"", ""));

                } else if (!CommonUtils.isEmptyObject(actionObj?.get(BtnValueUtils.urlAction))) {
                    // URL 버튼
                    val dataJsonObj = actionObj?.get(BtnValueUtils.urlAction)
                    val jsonDataMap = gson.fromJson(dataJsonObj.toString(), MutableMap::class.java)
                    val urlData = (jsonDataMap[BtnValueUtils.openUrl] as? MutableMap<*, *>)?.get(BtnValueUtils.url)

                    //logger.error("URL 데이터가 존재한다 : " + dataJsonObj.toString());
                    //logger.error("urlData : " + urlData.toString())

                    dto.btnType?.add(BtnValueUtils.urlAction)
                    dto.btnData?.add(listOf(urlData.toString()))
                    dto.btnText?.add(displayText.toString()
                        .replace("\"", ""))

                } else if (!CommonUtils.isEmptyObject(actionObj?.get(BtnValueUtils.dialerAction))) {
                    // 전화 버튼
                    val dataJsonObj = actionObj?.get(BtnValueUtils.dialerAction)
                    val jsonDataMap = gson.fromJson(dataJsonObj.toString(), MutableMap::class.java)
                    val phoneNumber = (jsonDataMap[BtnValueUtils.dialPhoneNumber] as? MutableMap<*, *>)?.get(BtnValueUtils.phoneNumber)

                    //logger.error("전화 데이터가 존재한다 : " + dataJsonObj.toString())
                    // logger.error("phoneNumber : " + phoneNumber.toString())

                    dto.btnType?.add(BtnValueUtils.dialerAction)
                    dto.btnData?.add(listOf(phoneNumber.toString()))
                    dto.btnText?.add(displayText.toString().replace("\"", ""))

                } else if (!CommonUtils.isEmptyObject(actionObj?.get(BtnValueUtils.mapAction))) {
                    // MapAction의 경우 3가지가 존재한다 ( 1. 좌표 입력 , 2. 쿼리 입력 , 3. 내 위치 보내기)
                    val mapObj = actionObj?.get(BtnValueUtils.mapAction)
                    val jsonDataMap = gson.fromJson(mapObj.toString(), MutableMap::class.java)

                    //logger.error("jsonDataMapAction :" + jsonDataMap)
                    //logger.error("mapObj" + mapObj.toString())
                    //logger.error("requestLocationPush : " + jsonDataMap[BtnValueUtils.requestLocationPush]);

                    if (jsonDataMap.containsKey(BtnValueUtils.requestLocationPush)) {
                        logger.error("requestLocationPush !! : 현재 위치 ")
                        dto.btnType?.add(BtnValueUtils.requestLocationPush)
                        dto.btnData?.add(listOf(""))
                        dto.btnText?.add(displayText.toString().replace("\"", ""))
                    } else {
                        logger.error("nothing : 좌표 or 쿼리 입력")
                        val fallbackUrl = (jsonDataMap[BtnValueUtils.showLocation] as? MutableMap<*, *>)?.get(BtnValueUtils.fallbackUrl).toString()

                        // 좌표 입력과 쿼리 입력 여부의 차이는 location 하위의 query 여부이다
                        val location = gson.fromJson((jsonDataMap[BtnValueUtils.showLocation] as? MutableMap<*, *>)?.get(BtnValueUtils.location).toString(), MutableMap::class.java)

                        if (!CommonUtils.isEmptyObject(location[BtnValueUtils.query])) {
                            // 좌표 쿼리가 존재하는 Json 버튼 데이터
                            val query = location[BtnValueUtils.query].toString()
                            // logger.error("좌표 쿼리 존재1 " + query);
                            dto.btnData?.add(listOf(query, fallbackUrl))
                            dto.btnText?.add(displayText.toString().replace("\"", ""))
                            dto.btnType?.add(BtnValueUtils.query)

                        } else {
                            // 좌표 쿼리가 존재하지 않는 Json 버튼 데이터
                            val latitude = location[BtnValueUtils.latitude].toString()
                            val longitude = location[BtnValueUtils.longitude].toString()
                            val label = location[BtnValueUtils.label].toString()

                            logger.error("좌표 쿼리 존재 X " + latitude);
                            logger.error("좌표 쿼리 존재 X " + longitude);
                            logger.error("좌표 쿼리 존재 X " + label);

                            dto.btnData?.add(listOf(latitude, longitude, label, fallbackUrl))
                            dto.btnText?.add(displayText.toString().replace("\"", ""))
                            dto.btnType?.add(BtnValueUtils.latitude)
                        }
                    }


                    /* if (!CommonUtils.isEmptyObject(jsonDataMap[BtnValueUtils.requestLocationPush])) {
                         // 현재 위치 버튼
                          logger.error("현재위치");
                         dto.btnType?.add(BtnValueUtils.requestLocationPush)
                         dto.btnData?.add(listOf(""))
                         dto.btnText?.add(displayText.toString()
                                 .replace("\"", ""))

                     } else {
                         logger.error("현재 위치 아님");
                         // fallbackUrl
                         val fallbackUrl =
                                 (jsonDataMap[BtnValueUtils.showLocation] as? MutableMap<*, *>)
                                         ?.get(BtnValueUtils.fallbackUrl)
                                         .toString()

                         // 좌표 입력과 쿼리 입력 여부의 차이는 location 하위의 query 여부이다
                         val location =
                                 gson?.fromJson((jsonDataMap[BtnValueUtils.showLocation] as? MutableMap<*, *>)
                                         ?.get(BtnValueUtils.location)
                                         .toString(), MutableMap::class.java)

                         if (!CommonUtils.isEmptyObject(location[BtnValueUtils.query])) {
                             // 좌표 쿼리가 존재하는 Json 버튼 데이터
                             val query = location[BtnValueUtils.query].toString()
                             // logger.error("좌표 쿼리 존재1 " + query);
                             dto.btnData?.add(listOf(query, fallbackUrl))
                             dto.btnText?.add(displayText.toString()
                                     .replace("\"", ""))
                             dto.btnType?.add(BtnValueUtils.query)

                         } else {
                             // 좌표 쿼리가 존재하지 않는 Json 버튼 데이터
                             val latitude = location[BtnValueUtils.latitude].toString()
                             val longitude = location[BtnValueUtils.longitude].toString()
                             val label = location[BtnValueUtils.label].toString()

                             logger.error("좌표 쿼리 존재 X " + latitude);
                             logger.error("좌표 쿼리 존재 X " + longitude);
                             logger.error("좌표 쿼리 존재 X " + label);

                             dto.btnData?.add(listOf(latitude, longitude, label, fallbackUrl))
                             dto.btnText?.add(displayText.toString()
                                     .replace("\"", ""))
                             dto.btnType?.add(BtnValueUtils.latitude)
                         }
                     }*/

                } else if (!CommonUtils.isEmptyObject(actionObj?.get(BtnValueUtils.calendarAction))) {
                    val dataJsonObj = actionObj?.get(BtnValueUtils.calendarAction)
                    val jsonDataMap = gson.fromJson(dataJsonObj.toString(), MutableMap::class.java)

                    val description = (jsonDataMap[BtnValueUtils.createCalendarEvent] as? MutableMap<*, *>)?.get(BtnValueUtils.description).toString()
                    val startTime = (jsonDataMap[BtnValueUtils.createCalendarEvent] as? MutableMap<*, *>)?.get(BtnValueUtils.startTime).toString().split("T")
                    val endTime = (jsonDataMap[BtnValueUtils.createCalendarEvent] as? MutableMap<*, *>)?.get(BtnValueUtils.endTime).toString().split("T")
                    val title = (jsonDataMap[BtnValueUtils.createCalendarEvent] as? MutableMap<*, *>)?.get(BtnValueUtils.title).toString()

                    dto.btnData?.add(listOf(startTime[0], endTime[0], title, description))
                    dto.btnText?.add(displayText.toString().replace("\"", ""))
                    dto.btnType?.add(BtnValueUtils.calendarAction)


                    /* logger.error("dataJsonObj 캘린더 : " + dataJsonObj);
                     logger.error("jsonDataMap 캘린더 : " + jsonDataMap);
                     logger.error("description : " + description);
                     logger.error("startTime : " + startTime);
                     logger.error("endTime : " + endTime);
                     logger.error("title : " + title);*/
                } else if (!CommonUtils.isEmptyObject(actionObj?.get(BtnValueUtils.composeAction))) {
                    val dataJsonObj = actionObj?.get(BtnValueUtils.composeAction)
                    val jsonDataMap = gson.fromJson(dataJsonObj.toString(), MutableMap::class.java)

                    val phoneNumber = (jsonDataMap[BtnValueUtils.composeTextMessage] as? MutableMap<*, *>)?.get(BtnValueUtils.phoneNumber).toString()
                    val text = (jsonDataMap[BtnValueUtils.composeTextMessage] as? MutableMap<*, *>)?.get(BtnValueUtils.text).toString()

                    dto.btnData?.add(listOf(phoneNumber, text))
                    dto.btnText?.add(displayText.toString().replace("\"", ""))
                    dto.btnType?.add(BtnValueUtils.composeAction)

                    //logger.error("text : " + text);
                    //logger.error("phoneNumber : " + phoneNumber);
                } else {
                    //logger.error("Json 데이터가 존재하지 않는다");
                }
                // 버튼은 그냥 담기
                logger.error("suggestObj : $suggestObj");
                logger.error("버튼명 : $displayText")

                logger.error("btnText : " + dto.btnText);
                logger.error("버튼 타입: " + dto.btnType);
                logger.error("버튼데이터 : " + dto.btnData);
            }
        }
    }

    /**
     * @Method Name  : jsonViewContentsParsing
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : dto: Tblmi_cont_lstDto
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 뷰에 뿌려줄 Json 데이터 파싱하기
     * @title : 제이슨 컨텐츠 파싱
     */

    private fun jsonViewContentsParsing(dto: Tblmi_cont_lstDto) {
        // 뷰에 뿌려줄 Json 데이터 파싱하기

        /*var jsonParser = JsonParser()
        val dto = dto as Contents_lstDto
        val rcsMsgTp = dto.msg_tp*/

        /* if (rcsMsgTp.equals("DMCH209") || rcsMsgTp.equals("DMCH208") || rcsMsgTp.equals("DMCH207")
                 || rcsMsgTp.equals("DMCH210")) {
             // 가로, 세로형 이라면 cont_body Json 형태 파싱
             if (dto.cont_body != null) {
                 var jsonObject = jsonParser.parse(dto.cont_body).asJsonObject
                 dto.cont_body = jsonObject.get("description").toString()
                         .replace("\\\\r\\\\n", "<br>")
                         .replace("\\r\\n","<br>")
                         .replace("\"", "")
             }
         }*/
        /*if (rcsMsgTp.equals("DMCH211") || rcsMsgTp.equals("DMCH212")) {

            val jsonArray = jsonParser.parse(dto.cont_body).asJsonArray
            val len = jsonArray.size()

            for (i in 0 until len) {
                val jsonObject = jsonArray.get(i).asJsonObject
                dto.slideTitle.add(jsonObject.get("title").toString()
                        .replace("\"", ""))
                dto.slideBody.add(jsonObject.get("description").toString()
                        .replace("\\\\r\\\\n", "<br>")
                        .replace("\"", "")
                )
            }
        }*/
    }

    /**
     * @Method Name  : rcsSlideSetting
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : contentListCreatedto: Content_list_CreateDto
     * @param    : tblmiContLstdto: Tblmi_cont_lstDto
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : RCS 슬라이드 저장 을 위한 JSON 파싱
     * @title : RCS 슬라이드 세팅
     */

    /**
     * 2021.04.30 수정 : 슬라이드 RCS 발송을 위해 JsonArray에 담는 구조가 아닌
     * JsonObject 형태로 변경
     */

    private fun rcsSlideSetting(contentListCreatedto: Content_list_CreateDto, tblmiContLstdto: Tblmi_cont_lstDto) {
        val len = contentListCreatedto.slide_cont_sub?.size
        var slideCnt = 0

        if (len != 0) {

            val jsonTitle = JSONObject()
            val jsonBody = JSONObject()

            for (i in 0 until len!!) {

                slideCnt++
                val titleIdx = "title" + slideCnt
                val descriptionIdx = "description" + slideCnt

                // API -> title ( title은 Title만 입력)
                jsonTitle[titleIdx] = contentListCreatedto.slide_cont_sub?.get(i)

                // API -> title , body 모두 입력 (body는 title,description 모두 입력)
                jsonBody[titleIdx] = contentListCreatedto.slide_cont_sub?.get(i)
                jsonBody[descriptionIdx] = contentListCreatedto.slide_cont_body?.get(i)

            }

            val title = jsonTitle.toString()
            val body = jsonBody.toString()

            tblmiContLstdto.cont_body = body
            tblmiContLstdto.cont_sub = title

            // 슬라이드 형 개수에 따른 Key 값 설정
            val rcsMsgType = contentListCreatedto.rcs_msg_tp!!.trim()

            val cdDto = Tblmi_comm_cdDto()
            cdDto.cd_id = UsefulUtils.sessionUser().usr_grp_cd

            if (rcsMsgType == "small") {
                // RCS 슬라 이드형 Small 일 경우
                // 카드 개수에 따른 Key 값 설정
                when (slideCnt) {
                    3 -> {
                        cdDto.grp_id = "RCS_SLIDE_SM_CT_03"
                    }
                    4 -> {
                        cdDto.grp_id = "RCS_SLIDE_SM_CT_04"
                    }
                    5 -> {
                        cdDto.grp_id = "RCS_SLIDE_SM_CT_05"
                    }
                    6 -> {
                        cdDto.grp_id = "RCS_SLIDE_SM_CT_06"
                    }
                }
            } else if (rcsMsgType == "medium") {
                // RCS 슬라 이드형 Medium 일 경우
                when (slideCnt) {
                    3 -> {
                        cdDto.grp_id = "RCS_SLIDE_MD_CT_03"
                    }
                    4 -> {
                        cdDto.grp_id = "RCS_SLIDE_MD_CT_04"
                    }
                    5 -> {
                        cdDto.grp_id = "RCS_SLIDE_MD_CT_05"
                    }
                    6 -> {
                        cdDto.grp_id = "RCS_SLIDE_MD_CT_06"
                    }
                }
            }

            val codeDto = systemDao.getCommCdKeyValueNull(cdDto)
            if (codeDto != null) {
                tblmiContLstdto.key_id = codeDto.cd_val
            }
        }
    }

    /**
     * @Method Name  : rcsButtonMakeJsonString
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : contentListCreatedto: Content_list_CreateDto
     * @param    : tblmiContLstdto: Tblmi_cont_lstDto
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : RCS 버튼 저장 Json 파싱
     * @title : RCS 버튼 저장
     */
    private fun rcsButtonMakeJsonString(contentListCreatedto: Content_list_CreateDto, tblmiContLstdto: Tblmi_cont_lstDto) {
        val len = contentListCreatedto.copy_value?.size
        val jsonSuggestObj = JSONObject()
        val jsonSuggestArr = JSONArray()
        val jsonBtnArray = JSONArray()
        var btnCnt = 0;

        // 첫번째 버튼이 없을 경우 버튼 존재 x -> 버튼 초기화
        if (contentListCreatedto.rcs_btn_tp_1.equals("0")) {
            // RCS 버튼이 없을 경우
            logger.error("rcs 버튼 없음");
            tblmiContLstdto.rcs_btn_obj = null
            tblmiContLstdto.rcs_btn_cnt = null
            tblmiContLstdto.rcs_btn_ins_tp = null
        }

        if (len != 0 && len != null) {
            //logger.error("버튼 check");
            // 버튼을 체크하지 않았을 경우를 처리 한다.
            for (i in 0 until len!!) {
                val jsonMainObject = JSONObject()
                val jsonActionObject = JSONObject()
                val jsonTitleObject = JSONObject()
                val jsonDataObject = JSONObject()
                val jsonPostBack = JSONObject()

                if (i == 0 && !CommonUtils.isEmptyObject(contentListCreatedto.rcs_btn_1)) {
                    btnCnt++;
                    //("버튼 1번째 값")
                    if (contentListCreatedto.rcs_btn_tp_1.equals("RBTN01")) {
                        jsonDataObject["text"] = contentListCreatedto.copy_value?.get(i)
                        jsonTitleObject["copyToClipboard"] = jsonDataObject
                        jsonActionObject["clipboardAction"] = jsonTitleObject
                        jsonPostBack["data"] = "set_by_chatbot_copy_to_clipboard"
                    } else if (contentListCreatedto.rcs_btn_tp_1.equals("RBTN02")) {
                        // 버튼 액션 : URL 연결
                        jsonDataObject["url"] = contentListCreatedto.url_value?.get(i)
                        jsonTitleObject["openUrl"] = jsonDataObject
                        jsonActionObject["urlAction"] = jsonTitleObject
                        jsonPostBack["data"] = "set_by_chatbot_open_url"
                    } else if (contentListCreatedto.rcs_btn_tp_1.equals("RBTN03")) {
                        // 버튼 액션 : 전화 걸기
                        jsonDataObject["phoneNumber"] = contentListCreatedto.phone_value_03?.get(i)
                        jsonTitleObject["dialPhoneNumber"] = jsonDataObject
                        jsonActionObject["dialerAction"] = jsonTitleObject
                        jsonPostBack["data"] = "set_by_chatbot_dial_phone_number"
                    } else if (contentListCreatedto.rcs_btn_tp_1.equals("RBTN04")) {
                        // 버튼 액션 : 위도/경도 지도 보여주기 좌표
                        val jsonLatitude = JSONObject()

                        jsonDataObject["latitude"] = contentListCreatedto.latitude_value?.get(i)
                        jsonDataObject["longitude"] = contentListCreatedto.longitude_value?.get(i)
                        jsonDataObject["label"] = contentListCreatedto.location_value_04?.get(i)
                        jsonLatitude["location"] = jsonDataObject
                        jsonLatitude["fallbackUrl"] = contentListCreatedto.fallback_url_04?.get(i)
                        jsonTitleObject["showLocation"] = jsonLatitude
                        jsonActionObject["mapAction"] = jsonTitleObject
                        jsonPostBack["data"] = "set_by_chatbot_show_location"

                    } else if (contentListCreatedto.rcs_btn_tp_1.equals("RBTN05")) {
                        // 버튼 액션 : 위도 /경도 지도 보여주기 쿼리
                        val jsonLatitude = JSONObject()

                        jsonDataObject["query"] = contentListCreatedto.location_value_05?.get(i)
                        jsonLatitude["location"] = jsonDataObject
                        jsonLatitude["fallbackUrl"] = contentListCreatedto.fallback_url_05?.get(i)
                        jsonTitleObject["showLocation"] = jsonLatitude
                        jsonActionObject["mapAction"] = jsonTitleObject
                        jsonPostBack["data"] = "set_by_chatbot_search_locations"

                    } else if (contentListCreatedto.rcs_btn_tp_1.equals("RBTN06")) {
                        // 버튼 액션 : 현재 위치 보내기
                        //jsonDataObject["requestLocationPush"] = "{}"
                        val jsonObj = JSONObject()
                        jsonDataObject["requestLocationPush"] = jsonObj
                        jsonActionObject["mapAction"] = jsonDataObject
                        jsonPostBack["data"] = "set_by_chatbot_request_location_push"

                        /*tblmiContLstdto.rcs_btn_ins_tp = "D"
                        tblmiContLstdto.rcs_btn_1 = contentListCreatedto.rcs_btn_1
                        tblmiContLstdto.rcs_btn_cont_1 = contentListCreatedto.url_value?.get(i)
                        tblmiContLstdto.rcs_btn_tp_1 = contentListCreatedto.rcs_btn_tp_1*/
                    } else if (contentListCreatedto.rcs_btn_tp_1.equals("RBTN07")) {
                        // 버튼 : 캘린더 (시작일, 종료일, 타이틀 ,BODY)
                        val startTime = contentListCreatedto.start_date?.get(i) + "T00:00:00Z"
                        val endTime = contentListCreatedto.end_date?.get(i) + "T23:59:59Z"

                        //jsonDataObject["startTime"] = contentListCreatedto.start_date?.get(i)
                        //jsonDataObject["endTime"] = contentListCreatedto.end_date?.get(i)

                        jsonDataObject["startTime"] = startTime
                        jsonDataObject["endTime"] = endTime
                        jsonDataObject["title"] = contentListCreatedto.calendar_title?.get(i)
                        jsonDataObject["description"] = contentListCreatedto.calendar_body?.get(i)
                        jsonTitleObject["createCalendarEvent"] = jsonDataObject
                        jsonActionObject["calendarAction"] = jsonTitleObject
                        jsonPostBack["data"] = "set_by_chatbot_create_calendar_event"

                        logger.error("jsonActionObj : " + jsonActionObject)

                    } else if (contentListCreatedto.rcs_btn_tp_1.equals("RBTN08")) {
                        //logger.error("rbtn08");
                        // 메세지 , 핸드폰 번호 설정
                        jsonDataObject["phoneNumber"] = contentListCreatedto.phone_value_08?.get(i)
                        jsonDataObject["text"] = contentListCreatedto.message_value?.get(i)
                        jsonTitleObject["composeTextMessage"] = jsonDataObject
                        jsonActionObject["composeAction"] = jsonTitleObject
                        jsonPostBack["data"] = "set_by_chatbot_compose_text_message"
                    }

                    jsonMainObject["action"] = jsonActionObject
                    jsonActionObject["displayText"] = contentListCreatedto?.rcs_btn_1
                    jsonActionObject["postback"] = jsonPostBack

                    jsonBtnArray.add(jsonMainObject)
                    //tblmiContLstdto.rcs_btn_1 = contentListCreatedto.rcs_btn_1
                    //tblmiContLstdto.rcs_btn_tp_1 = contentListCreatedto.rcs_btn_tp_1

                } else if (i == 1 && !CommonUtils.isEmptyObject(contentListCreatedto.rcs_btn_2)) {
                    // 인덱스가 1번이고, rcs_bn_tp_2 값이 있을경우
                    //logger.error("버튼 2번쨰 값");
                    btnCnt++;

                    if (contentListCreatedto.rcs_btn_tp_2.equals("RBTN01")) {
                        jsonDataObject["text"] = contentListCreatedto.copy_value?.get(i)
                        jsonTitleObject["copyToClipboard"] = jsonDataObject
                        jsonActionObject["clipboardAction"] = jsonTitleObject
                        jsonPostBack["data"] = "set_by_chatbot_copy_to_clipboard"
                    } else if (contentListCreatedto.rcs_btn_tp_2.equals("RBTN02")) {
                        // 버튼 액션 : URL 연결
                        jsonDataObject["url"] = contentListCreatedto.url_value?.get(i)
                        // 역슬래시 치환
                        //val replaceStr = jsonDataObject.toString().replace("\","");
                        jsonTitleObject["openUrl"] = jsonDataObject
                        jsonActionObject["urlAction"] = jsonTitleObject
                        jsonPostBack["data"] = "set_by_chatbot_open_url"
                    } else if (contentListCreatedto.rcs_btn_tp_2.equals("RBTN03")) {
                        // 버튼 액션 : 전화 걸기
                        jsonDataObject["phoneNumber"] = contentListCreatedto.phone_value_03?.get(i)
                        jsonTitleObject["dialPhoneNumber"] = jsonDataObject
                        jsonActionObject["dialerAction"] = jsonTitleObject
                        jsonPostBack["data"] = "set_by_chatbot_dial_phone_number"
                    } else if (contentListCreatedto.rcs_btn_tp_2.equals("RBTN04")) {
                        // 버튼 액션 : 위도/경도 지도 보여주기 좌표
                        val jsonLatitude = JSONObject()
                        jsonDataObject["latitude"] = contentListCreatedto.latitude_value?.get(i)
                        jsonDataObject["longitude"] = contentListCreatedto.longitude_value?.get(i)
                        jsonDataObject["label"] = contentListCreatedto.location_value_04?.get(i)
                        jsonLatitude["location"] = jsonDataObject
                        jsonLatitude["fallbackUrl"] = contentListCreatedto.fallback_url_04?.get(i)
                        jsonTitleObject["showLocation"] = jsonLatitude
                        jsonActionObject["mapAction"] = jsonTitleObject
                        jsonPostBack["data"] = "set_by_chatbot_show_location"

                    } else if (contentListCreatedto.rcs_btn_tp_2.equals("RBTN05")) {
                        // 버튼 액션 : 위도 /경도 지도 보여주기 쿼리
                        val jsonLatitude = JSONObject()
                        jsonDataObject["query"] = contentListCreatedto.location_value_05?.get(i)
                        jsonLatitude["location"] = jsonDataObject
                        jsonLatitude["fallbackUrl"] = contentListCreatedto.fallback_url_05?.get(i)
                        jsonTitleObject["showLocation"] = jsonLatitude
                        jsonActionObject["mapAction"] = jsonTitleObject
                        jsonPostBack["data"] = "set_by_chatbot_search_locations"
                    } else if (contentListCreatedto.rcs_btn_tp_2.equals("RBTN06")) {
                        //jsonDataObject["requestLocationPush"] = "{}"
                        val jsonObj = JSONObject()
                        jsonDataObject["requestLocationPush"] = jsonObj

                        jsonActionObject["mapAction"] = jsonDataObject
                        jsonPostBack["data"] = "set_by_chatbot_request_location_push"

                    } else if (contentListCreatedto.rcs_btn_tp_2.equals("RBTN07")) {
                        // 버튼 : 캘린더 (시작일, 종료일, 타이틀 ,BODY)

                        val startTime = contentListCreatedto.start_date?.get(i) + "T00:00:00Z"
                        val endTime = contentListCreatedto.end_date?.get(i) + "T23:59:59Z"

                        //jsonDataObject["startTime"] = contentListCreatedto.start_date?.get(i)
                        //jsonDataObject["endTime"] = contentListCreatedto.end_date?.get(i)

                        jsonDataObject["startTime"] = startTime
                        jsonDataObject["endTime"] = endTime
                        jsonDataObject["title"] = contentListCreatedto.calendar_title?.get(i)
                        jsonDataObject["description"] = contentListCreatedto.calendar_body?.get(i)
                        jsonTitleObject["createCalendarEvent"] = jsonDataObject
                        jsonActionObject["calendarAction"] = jsonTitleObject
                        jsonPostBack["data"] = "set_by_chatbot_create_calendar_event"
                    } else if (contentListCreatedto.rcs_btn_tp_2.equals("RBTN08")) {
                        // 메세지 , 핸드폰 번호 설정
                        jsonDataObject["phoneNumber"] = contentListCreatedto.phone_value_08?.get(i)
                        jsonDataObject["text"] = contentListCreatedto.message_value?.get(i)
                        jsonTitleObject["composeTextMessage"] = jsonDataObject
                        jsonActionObject["composeAction"] = jsonTitleObject
                        jsonPostBack["data"] = "set_by_chatbot_compose_text_message"
                    }

                    jsonMainObject["action"] = jsonActionObject
                    jsonActionObject["displayText"] = contentListCreatedto?.rcs_btn_2
                    jsonActionObject["postback"] = jsonPostBack

                    jsonBtnArray.add(jsonMainObject)

                    //tblmiContLstdto.rcs_btn_2 = contentListCreatedto.rcs_btn_2
                    //tblmiContLstdto.rcs_btn_tp_2 = contentListCreatedto.rcs_btn_tp_2


                } else if (i == 2 && !CommonUtils.isEmptyObject(contentListCreatedto.rcs_btn_3)) {
                    // 인덱스가 2번이고, rcs_bn_tp_3 값이 있을경우
                    //
                    // logger.error("버튼 3번째 값");
                    btnCnt++;

                    if (contentListCreatedto.rcs_btn_tp_3.equals("RBTN01")) {
                        jsonDataObject["text"] = contentListCreatedto.copy_value?.get(i)
                        jsonTitleObject["copyToClipboard"] = jsonDataObject
                        jsonActionObject["clipboardAction"] = jsonTitleObject
                        jsonPostBack["data"] = "set_by_chatbot_copy_to_clipboard"
                    } else if (contentListCreatedto.rcs_btn_tp_3.equals("RBTN02")) {
                        // 버튼 액션 : URL 연결
                        jsonDataObject["url"] = contentListCreatedto.url_value?.get(i)
                        jsonTitleObject["openUrl"] = jsonDataObject
                        jsonActionObject["urlAction"] = jsonTitleObject
                        jsonPostBack["data"] = "set_by_chatbot_open_url"
                    } else if (contentListCreatedto.rcs_btn_tp_3.equals("RBTN03")) {
                        // 버튼 액션 : 전화 걸기
                        jsonDataObject["phoneNumber"] = contentListCreatedto.phone_value_03?.get(i)
                        jsonTitleObject["dialPhoneNumber"] = jsonDataObject
                        jsonActionObject["dialerAction"] = jsonTitleObject
                        jsonPostBack["data"] = "set_by_chatbot_dial_phone_number"
                    } else if (contentListCreatedto.rcs_btn_tp_3.equals("RBTN04")) {
                        // 버튼 액션 : 위도/경도 지도 보여주기 좌표
                        val jsonLatitude = JSONObject()
                        jsonDataObject["latitude"] = contentListCreatedto.latitude_value?.get(i)
                        jsonDataObject["longitude"] = contentListCreatedto.longitude_value?.get(i)
                        jsonDataObject["label"] = contentListCreatedto.location_value_04?.get(i)
                        jsonLatitude["location"] = jsonDataObject
                        jsonLatitude["fallbackUrl"] = contentListCreatedto.fallback_url_04?.get(i)
                        jsonTitleObject["showLocation"] = jsonLatitude
                        jsonActionObject["mapAction"] = jsonTitleObject
                        jsonPostBack["data"] = "set_by_chatbot_show_location"
                    } else if (contentListCreatedto.rcs_btn_tp_3.equals("RBTN05")) {
                        // 버튼 액션 : 위도 /경도 지도 보여주기 쿼리
                        val jsonLatitude = JSONObject()
                        jsonDataObject["query"] = contentListCreatedto.location_value_05?.get(i)
                        jsonLatitude["location"] = jsonDataObject
                        jsonLatitude["fallbackUrl"] = contentListCreatedto.fallback_url_05?.get(i)
                        jsonTitleObject["showLocation"] = jsonLatitude
                        jsonActionObject["mapAction"] = jsonTitleObject
                        jsonPostBack["data"] = "set_by_chatbot_search_locations"
                    } else if (contentListCreatedto.rcs_btn_tp_3.equals("RBTN06")) {
                        // 버튼 액션 : 현재 위치 보여주기
                        //jsonDataObject["requestLocationPush"] = "{}"
                        val jsonObj = JSONObject()
                        jsonDataObject["requestLocationPush"] = jsonObj
                        jsonActionObject["mapAction"] = jsonDataObject
                        jsonPostBack["data"] = "set_by_chatbot_request_location_push"
                    } else if (contentListCreatedto.rcs_btn_tp_3.equals("RBTN07")) {
                        // 버튼 : 캘린더 (시작일, 종료일, 타이틀 ,BODY)

                        val startTime = contentListCreatedto.start_date?.get(i) + "T00:00:00Z"
                        val endTime = contentListCreatedto.end_date?.get(i) + "T23:59:59Z"

                        //jsonDataObject["startTime"] = contentListCreatedto.start_date?.get(i)
                        //jsonDataObject["endTime"] = contentListCreatedto.end_date?.get(i)
                        jsonDataObject["startTime"] = startTime
                        jsonDataObject["endTime"] = endTime
                        jsonDataObject["title"] = contentListCreatedto.calendar_title?.get(i)
                        jsonDataObject["description"] = contentListCreatedto.calendar_body?.get(i)
                        jsonTitleObject["createCalendarEvent"] = jsonDataObject
                        jsonActionObject["calendarAction"] = jsonTitleObject
                        jsonPostBack["data"] = "set_by_chatbot_create_calendar_event"
                    } else if (contentListCreatedto.rcs_btn_tp_3.equals("RBTN08")) {
                        // 메세지 , 핸드폰 번호 설정
                        jsonDataObject["phoneNumber"] = contentListCreatedto.phone_value_08?.get(i)
                        jsonDataObject["text"] = contentListCreatedto.message_value?.get(i)
                        jsonTitleObject["composeTextMessage"] = jsonDataObject
                        jsonActionObject["composeAction"] = jsonTitleObject
                        jsonPostBack["data"] = "set_by_chatbot_compose_text_message"
                    }

                    jsonMainObject["action"] = jsonActionObject
                    jsonActionObject["displayText"] = contentListCreatedto?.rcs_btn_3
                    jsonActionObject["postback"] = jsonPostBack

                    jsonBtnArray.add(jsonMainObject)

                    //tblmiContLstdto.rcs_btn_3 = contentListCreatedto.rcs_btn_3
                    //tblmiContLstdto.rcs_btn_tp_3 = contentListCreatedto.rcs_btn_tp_3

                    // logger.error("jsonActionObject : " + jsonActionObject);
                }
            }

            jsonSuggestObj["suggestions"] = jsonBtnArray
            jsonSuggestArr.add(jsonSuggestObj)

            logger.debug("jsonSuggestArr toString Replace : " + jsonSuggestArr.toString().replace("\\", ""))

            if (jsonBtnArray.size == 0) {
                // 담긴 json 배열이 없다면 null 처리한다
                tblmiContLstdto.rcs_btn_obj = null
                tblmiContLstdto.rcs_btn_cnt = null
                tblmiContLstdto.rcs_btn_ins_tp = null
            } else {
                // 담긴 json 배열을 replace 한 후 처리한다
                tblmiContLstdto.rcs_btn_obj = jsonSuggestArr.toString().replace("\\", "")
                tblmiContLstdto.rcs_btn_cnt = btnCnt.toString()
                tblmiContLstdto.rcs_btn_ins_tp = "A"
            }
        }
    }


    /**
     * @Method Name  : rcsButtonMakeJsonStringSlide
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : contentListCreatedto: Content_list_CreateDto
     * @param    : tblmiContLstdto: Tblmi_cont_lstDto
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : RCS 슬라이드 버튼 Json 파싱
     * @title : RCS 슬라이드 버튼 저장
     */

    private fun rcsButtonMakeJsonStringSlide(contentListCreatedto: Content_list_CreateDto, tblmiContLstdto: Tblmi_cont_lstDto) {
        /*
            1. slide_rcs_btn_tp 값과 slide_rcs_btn 값은 카드의 개수 만큼 고정 되서 들어 온다 (각각 분리되어 카드의 idx로 체크한다)
            2. 버튼에 따른 필요 값들은 뷰에서 index 를 지키며 들어 온다 ( 짝수 인덱스 : 버튼 1번 , 홀수 인덱스 : 버튼 2번 )
         */
        val btn1Len = contentListCreatedto.slide_rcs_btn_1?.size
        val btn2Len = contentListCreatedto.slide_rcs_btn_2?.size

        var btn1Idx = 0;
        var btn2Idx = 1;
        var btnCnt = 0;

        val jsonSuggestArr = JSONArray()

        for (idx in 0 until btn1Len!!) {
            // 카드의 개수 만큼 버튼을 담으며 For 문 돌린다.
            //logger.error("현재 인덱스 : " + idx)

            val btn1Value = contentListCreatedto.slide_rcs_btn_1!![idx]
            val btn1Type = contentListCreatedto.slide_rcs_btn_tp_1!![idx]
            val btn2Value = contentListCreatedto.slide_rcs_btn_2!![idx]
            val btn2Type = contentListCreatedto.slide_rcs_btn_tp_2!![idx]

            //logger.error("버튼 1번 값 : " + btn1Value)
            //logger.error("버튼 1번 Type : " + btn1Type)
            //logger.error("버튼 2번 값 : " + btn2Value)
            //logger.error("버튼 2번 Type : " + btn2Type)

            val jsonSuggestObj = JSONObject()
            val jsonBtnArray = JSONArray()

            val jsonMainBtn1Object = JSONObject()
            val jsonActionBtn1Object = JSONObject()
            val jsonTitleBtn1Object = JSONObject()
            val jsonDataBtn1Object = JSONObject()
            val jsonPostBtn1Back = JSONObject()

            if (!CommonUtils.isEmptyObject(btn1Value)) {
                // 1번 버튼에 값이 있을 때 처리
                if (btn1Type.equals("RBTN01")) {
                    jsonDataBtn1Object["text"] = contentListCreatedto.copy_value?.get(btn1Idx)
                    jsonTitleBtn1Object["copyToClipboard"] = jsonDataBtn1Object
                    jsonActionBtn1Object["clipboardAction"] = jsonTitleBtn1Object
                    jsonPostBtn1Back["data"] = "set_by_chatbot_copy_to_clipboard"
                } else if (btn1Type.equals("RBTN02")) {
                    // 버튼 액션 : URL 연결
                    jsonDataBtn1Object["url"] = contentListCreatedto.url_value?.get(btn1Idx)
                    jsonTitleBtn1Object["openUrl"] = jsonDataBtn1Object
                    jsonActionBtn1Object["urlAction"] = jsonTitleBtn1Object
                    jsonPostBtn1Back["data"] = "set_by_chatbot_open_url"
                } else if (btn1Type.equals("RBTN03")) {
                    // 버튼 액션 : 전화 걸기
                    jsonDataBtn1Object["phoneNumber"] = contentListCreatedto.phone_value_03?.get(btn1Idx)
                    jsonTitleBtn1Object["dialPhoneNumber"] = jsonDataBtn1Object
                    jsonActionBtn1Object["dialerAction"] = jsonTitleBtn1Object
                    jsonPostBtn1Back["data"] = "set_by_chatbot_dial_phone_number"
                } else if (btn1Type.equals("RBTN04")) {
                    // 버튼 액션 : 위도/경도 지도 보여주기 좌표
                    val jsonLatitude = JSONObject()
                    jsonDataBtn1Object["latitude"] = contentListCreatedto.latitude_value?.get(btn1Idx)
                    jsonDataBtn1Object["longitude"] = contentListCreatedto.longitude_value?.get(btn1Idx)
                    jsonDataBtn1Object["label"] = contentListCreatedto.location_value_04?.get(btn1Idx)
                    jsonLatitude["location"] = jsonDataBtn1Object
                    jsonLatitude["fallbackUrl"] = contentListCreatedto.fallback_url_04?.get(btn1Idx)
                    jsonTitleBtn1Object["showLocation"] = jsonLatitude
                    jsonActionBtn1Object["mapAction"] = jsonTitleBtn1Object
                    jsonPostBtn1Back["data"] = "set_by_chatbot_show_location"
                } else if (btn1Type.equals("RBTN05")) {
                    // 버튼 액션 : 위도 /경도 지도 보여주기 쿼리
                    val jsonLatitude = JSONObject()
                    jsonDataBtn1Object["query"] = contentListCreatedto.location_value_05?.get(btn1Idx)
                    jsonLatitude["location"] = jsonDataBtn1Object
                    jsonLatitude["fallbackUrl"] = contentListCreatedto.fallback_url_05?.get(btn1Idx)
                    jsonTitleBtn1Object["showLocation"] = jsonLatitude
                    jsonActionBtn1Object["mapAction"] = jsonTitleBtn1Object
                    jsonPostBtn1Back["data"] = "set_by_chatbot_search_locations"
                } else if (btn1Type.equals("RBTN06")) {
                    //jsonDataBtn1Object["requestLocationPush"] = "{}"
                    val jsonObj = JSONObject()
                    jsonDataBtn1Object["requestLocationPush"] = jsonObj
                    jsonActionBtn1Object["mapAction"] = jsonDataBtn1Object
                    jsonPostBtn1Back["data"] = "set_by_chatbot_request_location_push"
                } else if (btn1Type.equals("RBTN07")) {
                    // 버튼 : 캘린더 (시작일, 종료일, 타이틀 ,BODY)

                    val startTime = contentListCreatedto.start_date?.get(btn1Idx) + "T00:00:00Z"
                    val endTime = contentListCreatedto.end_date?.get(btn1Idx) + "T23:59:59Z"

                    //jsonDataBtn1Object["startTime"] = contentListCreatedto.start_date?.get(btn1Idx)
                    //jsonDataBtn1Object["endTime"] = contentListCreatedto.end_date?.get(btn1Idx)
                    jsonDataBtn1Object["startTime"] = startTime
                    jsonDataBtn1Object["endTime"] = endTime
                    jsonDataBtn1Object["title"] = contentListCreatedto.calendar_title?.get(btn1Idx)
                    jsonDataBtn1Object["description"] = contentListCreatedto.calendar_body?.get(btn1Idx)
                    jsonTitleBtn1Object["createCalendarEvent"] = jsonDataBtn1Object
                    jsonActionBtn1Object["calendarAction"] = jsonTitleBtn1Object
                    jsonPostBtn1Back["data"] = "set_by_chatbot_create_calendar_event"
                } else if (btn1Type.equals("RBTN08")) {
                    // 메세지 , 핸드폰 번호 설정
                    jsonDataBtn1Object["phoneNumber"] = contentListCreatedto.phone_value_08?.get(btn1Idx)
                    jsonDataBtn1Object["text"] = contentListCreatedto.message_value?.get(btn1Idx)
                    jsonTitleBtn1Object["composeTextMessage"] = jsonDataBtn1Object
                    jsonActionBtn1Object["composeAction"] = jsonTitleBtn1Object
                    jsonPostBtn1Back["data"] = "set_by_chatbot_compose_text_message"
                }

                jsonMainBtn1Object["action"] = jsonActionBtn1Object
                jsonActionBtn1Object["displayText"] = contentListCreatedto?.slide_rcs_btn_1!![idx]
                jsonActionBtn1Object["postback"] = jsonPostBtn1Back
                jsonBtnArray.add(jsonMainBtn1Object)
                //logger.error("slide jsonObject 버튼1 : " + jsonMainBtn1Object.toJSONString())
                btnCnt++;
            }

            val jsonMainBtn2Object = JSONObject()
            val jsonActionBtn2Object = JSONObject()
            val jsonTitleBtn2Object = JSONObject()
            val jsonDataBtn2Object = JSONObject()
            val jsonPostBtn2Back = JSONObject()

            if (!CommonUtils.isEmptyObject(btn2Value)) {
                // 2번 버튼에 값이 있을때 처리
                if (btn2Type.equals("RBTN01")) {
                    jsonDataBtn2Object["text"] = contentListCreatedto.copy_value?.get(btn2Idx)
                    jsonTitleBtn2Object["copyToClipboard"] = jsonDataBtn2Object
                    jsonActionBtn2Object["clipboardAction"] = jsonTitleBtn2Object
                    jsonPostBtn2Back["data"] = "set_by_chatbot_copy_to_clipboard"
                } else if (btn2Type.equals("RBTN02")) {
                    // 버튼 액션 : URL 연결
                    jsonDataBtn2Object["url"] = contentListCreatedto.url_value?.get(btn2Idx)
                    jsonTitleBtn2Object["openUrl"] = jsonDataBtn2Object
                    jsonActionBtn2Object["urlAction"] = jsonTitleBtn2Object
                    jsonPostBtn2Back["data"] = "set_by_chatbot_open_url"
                } else if (btn2Type.equals("RBTN03")) {
                    // 버튼 액션 : 전화 걸기
                    jsonDataBtn2Object["phoneNumber"] = contentListCreatedto.phone_value_03?.get(btn2Idx)
                    jsonTitleBtn2Object["dialPhoneNumber"] = jsonDataBtn2Object
                    jsonActionBtn2Object["dialerAction"] = jsonTitleBtn2Object
                    jsonPostBtn2Back["data"] = "set_by_chatbot_dial_phone_number"
                } else if (btn2Type.equals("RBTN04")) {
                    // 버튼 액션 : 위도/경도 지도 보여주기 좌표
                    val jsonLatitude = JSONObject()
                    jsonDataBtn2Object["latitude"] = contentListCreatedto.latitude_value?.get(btn2Idx)
                    jsonDataBtn2Object["longitude"] = contentListCreatedto.longitude_value?.get(btn2Idx)
                    jsonDataBtn2Object["label"] = contentListCreatedto.location_value_04?.get(btn2Idx)
                    jsonLatitude["location"] = jsonDataBtn2Object
                    jsonLatitude["fallbackUrl"] = contentListCreatedto.fallback_url_04?.get(btn2Idx)
                    jsonTitleBtn2Object["showLocation"] = jsonLatitude
                    jsonActionBtn2Object["mapAction"] = jsonTitleBtn2Object
                    jsonPostBtn2Back["data"] = "set_by_chatbot_show_location"
                } else if (btn2Type.equals("RBTN05")) {
                    // 버튼 액션 : 위도 /경도 지도 보여주기 쿼리
                    val jsonLatitude = JSONObject()
                    jsonDataBtn2Object["query"] = contentListCreatedto.location_value_05?.get(btn2Idx)
                    jsonLatitude["location"] = jsonDataBtn2Object
                    jsonLatitude["fallbackUrl"] = contentListCreatedto.fallback_url_05?.get(btn2Idx)
                    jsonTitleBtn2Object["showLocation"] = jsonLatitude
                    jsonActionBtn2Object["mapAction"] = jsonTitleBtn2Object
                    jsonPostBtn2Back["data"] = "set_by_chatbot_search_locations"
                } else if (btn2Type.equals("RBTN06")) {
                    val jsonObj = JSONObject()
                    //jsonDataBtn2Object["requestLocationPush"] = "{}"
                    jsonDataBtn2Object["requestLocationPush"] = jsonObj
                    jsonActionBtn2Object["mapAction"] = jsonDataBtn2Object
                    jsonPostBtn2Back["data"] = "set_by_chatbot_request_location_push"
                } else if (btn2Type.equals("RBTN07")) {
                    // 버튼 : 캘린더 (시작일, 종료일, 타이틀 ,BODY)

                    val startTime = contentListCreatedto.start_date?.get(btn2Idx) + "T00:00:00Z"
                    val endTime = contentListCreatedto.end_date?.get(btn2Idx) + "T23:59:59Z"
                    //jsonDataBtn2Object["startTime"] = contentListCreatedto.start_date?.get(btn2Idx)
                    //jsonDataBtn2Object["endTime"] = contentListCreatedto.end_date?.get(btn2Idx)
                    jsonDataBtn2Object["startTime"] = startTime
                    jsonDataBtn2Object["endTime"] = endTime
                    jsonDataBtn2Object["title"] = contentListCreatedto.calendar_title?.get(btn2Idx)
                    jsonDataBtn2Object["description"] = contentListCreatedto.calendar_body?.get(btn2Idx)
                    jsonTitleBtn2Object["createCalendarEvent"] = jsonDataBtn2Object
                    jsonActionBtn2Object["calendarAction"] = jsonTitleBtn2Object
                    jsonPostBtn2Back["data"] = "set_by_chatbot_create_calendar_event"
                } else if (btn2Type.equals("RBTN08")) {
                    // 메세지 , 핸드폰 번호 설정
                    jsonDataBtn2Object["phoneNumber"] = contentListCreatedto.phone_value_08?.get(btn2Idx)
                    jsonDataBtn2Object["text"] = contentListCreatedto.message_value?.get(btn2Idx)
                    jsonTitleBtn2Object["composeTextMessage"] = jsonDataBtn2Object
                    jsonActionBtn2Object["composeAction"] = jsonTitleBtn2Object
                    jsonPostBtn2Back["data"] = "set_by_chatbot_compose_text_message"
                }

                jsonMainBtn2Object["action"] = jsonActionBtn2Object
                jsonActionBtn2Object["displayText"] = contentListCreatedto?.slide_rcs_btn_2!![idx]
                jsonActionBtn2Object["postback"] = jsonPostBtn2Back
                jsonBtnArray.add(jsonMainBtn2Object)
                //logger.error("slide jsonObject 버튼2 : " + jsonMainBtn2Object.toJSONString())
                btnCnt++;
            }

            if (!CommonUtils.isEmptyObject(btn1Value) || !CommonUtils.isEmptyObject(btn2Value)) {
                // 버튼이 한개 라도 존재할 경우 suggestions Object 담는다
                jsonSuggestObj["suggestions"] = jsonBtnArray
                jsonSuggestArr.add(jsonSuggestObj)
            } else {
                // 버튼이 존재하지 않을 경우 {} 값으로 채워넣는다
                //logger.error("버튼 is not exist");
                //jsonSuggestArr.add("{}")

                val emptyJson = JSONObject()
                jsonSuggestArr.add(emptyJson)
            }
            //logger.error("jsonSuggestArr toString Replace : " + jsonSuggestArr.toString().replace("\\", ""))

            btn1Idx += 2
            btn2Idx += 2
        }
        if (btnCnt != 0) {
            // 버튼 개수가 0개 이상일때 Type과 버튼 개수를 추가한다
            tblmiContLstdto.rcs_btn_cnt = btnCnt.toString()
            tblmiContLstdto.rcs_btn_ins_tp = "A"
        }
        tblmiContLstdto.rcs_btn_obj = jsonSuggestArr.toString().replace("\\", "")
    }


    override fun previewJsonService(dto: Tblmi_cont_lstDto): Map<String, Any> {
        val dataMap = HashMap<String, Any>()
        val contentListCreatedto = dto as Content_list_CreateDto
        val rcsFormatType = contentListCreatedto.rcs_format_type!!.trim()   // rcs 포멧 타입
        val tblmiContLstDto = Tblmi_cont_lstDto()

        if (rcsFormatType == "vertical") {
            val jsonBody = JSONObject()
            jsonBody["title"] = contentListCreatedto.cont_sub_list?.get(2)
            jsonBody["description"] = contentListCreatedto.rcs_body
            // 공백 파싱 처리
            tblmiContLstDto.cont_body = jsonBody.toString()
            tblmiContLstDto.img_cd_1 = contentListCreatedto.verticalImg
        } else if (rcsFormatType == "slide") {
            // RCS 슬라이드 관련 INSERT 처리
            rcsSlideSetting(contentListCreatedto, tblmiContLstDto)
        }

        // RCS 버튼 JSON 파싱
        if (rcsFormatType == "slide") {
            // 슬라 이드
            rcsButtonMakeJsonStringSlide(contentListCreatedto, tblmiContLstDto)
        } else {
            // TEXT, 세로형 버튼 파싱
            rcsButtonMakeJsonString(contentListCreatedto, tblmiContLstDto)
        }

        val viewDto = Contents_lstDto()
        viewDto.rcs_btn_obj = tblmiContLstDto.rcs_btn_obj
        viewDto.cont_body = tblmiContLstDto.cont_body
        dataMap["jsonContent"] = viewDto

        return dataMap;
    }

    override fun previewATJsonService(dto: Tblmi_kko_at_tmplDto): Map<String, Any> {
        val dataMap = HashMap<String, Any>();

        val g = GsonBuilder().create()
        val buttons = g.fromJson(dto.button_json, JsonArray::class.java)
        val quickLst = g.fromJson(dto.quick_repl_json, JsonArray::class.java)
        val itemHighs = g.fromJson(dto.item_highlight_json, JsonObject::class.java)
        val items = g.fromJson(dto.item_json, JsonObject::class.java)

        val obj = JsonObject()
        obj.add("button", buttons)
        obj.add("quick_reply", quickLst)
        obj.add("item_highlight", itemHighs)
        obj.add("item", items)

        dataMap["kko_btn_obj"] = obj
        return dataMap
    }

    override fun selectRejectTextList(dto: SetLst_searchDto): Map<String, Any> {
        val searchDto = dto
        val paramMap: MutableMap<String, Any> = HashMap()
        val paginationInfo: PaginationInfo = UsefulUtils.makePage(searchDto.pageNo, 10, 5)

        searchDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        searchDto.firstIndex = paginationInfo.firstRecordIndex
        searchDto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = contentDao.selectSenderListCnt(searchDto)

        paramMap["page"] = paginationInfo
        paramMap["pageNo"] = paginationInfo.currentPageNo
        paramMap["list"] = contentDao.selectSenderList(searchDto)
        paramMap["listCnt"] = contentDao.selectSenderListCnt(searchDto)

        return paramMap
    }
    private fun insertContentUrl(urlTag: String, url: String, urlId: String, contLstCd: Int) {
        val contUrlDto = Tblmi_cont_url_lstDto()
        contUrlDto.url_tag = urlTag
        contUrlDto.url = url
        contUrlDto.url_id = urlId
        contUrlDto.cont_lst_cd = contLstCd
        contentDao.insertContentUrl(contUrlDto)
    }
}

