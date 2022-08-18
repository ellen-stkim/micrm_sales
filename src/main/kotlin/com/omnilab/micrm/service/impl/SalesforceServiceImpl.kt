package com.omnilab.micrm.service.impl

import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.Content_list_CreateDto
import com.omnilab.micrm.model.Image_searchDto
import com.omnilab.micrm.model.SalesforceDto
import com.omnilab.micrm.model.SetLst_searchDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.repository.ContentDao
import com.omnilab.micrm.repository.SalesforceDao
import com.omnilab.micrm.repository.SysSettingDao
import com.omnilab.micrm.service.SalesforceService
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo
import org.apache.http.HttpEntity
import org.apache.http.HttpStatus
import org.apache.http.StatusLine
import org.apache.http.client.HttpClient
import org.apache.http.client.methods.CloseableHttpResponse
import org.apache.http.client.methods.HttpGet
import org.apache.http.impl.client.HttpClients
import org.apache.http.util.EntityUtils
import org.json.simple.JSONArray
import org.json.simple.JSONObject
import org.json.simple.parser.JSONParser
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.http.HttpHeaders
import org.springframework.http.HttpMethod
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Service
import org.springframework.web.client.RestTemplate
import java.util.regex.Pattern

@Service("SalesforceServiceImpl")
class SalesforceServiceImpl : SalesforceService {

    val logger: Logger = LoggerFactory.getLogger(this.javaClass)!!

    @Autowired
    private lateinit var salesforceDao: SalesforceDao

    @Autowired
    @Qualifier("restTemplate")
    private lateinit var restTemplate: RestTemplate

    @Autowired
    @Qualifier("SysSettingDaoImpl")
    private lateinit var systemDao: SysSettingDao

    @Autowired
    @Qualifier("ContentDaoImpl")
    private lateinit var contentDao: ContentDao

    override fun getUser(dto: SalesforceDto): Map<String, Any> {
        val returnMap: MutableMap<String, Any> = HashMap()
        val host: String = dto.host as String
        val token: String = dto.token as String

        try {
            val client: HttpClient = HttpClients.createDefault()
            val httpGet = HttpGet("$host/platform/v1/tokenContext")
            httpGet.addHeader("Content-type", "application/json")
            httpGet.addHeader("Authorization", "Bearer $token")
            val response: CloseableHttpResponse = client.execute(httpGet) as CloseableHttpResponse
            val entity: HttpEntity = response.entity
            val responseBody = EntityUtils.toString(entity, Charsets.UTF_8)
            val statusLine: StatusLine = response.statusLine

            if (statusLine.statusCode == HttpStatus.SC_OK) {
                val jsonParser = JSONParser()
                val jsonObj = jsonParser.parse(responseBody) as JSONObject
                val enterprise = jsonObj["enterprise"] as JSONObject
                val organization = jsonObj["organization"] as JSONObject
                val user = jsonObj["user"] as JSONObject
                val enterpriseId = enterprise["id"] as Long
                val organizationId = organization["id"] as Long
                val userId = user["id"] as Long
                val msg = "\nenterpriseId: $enterpriseId\norganizationId: $organizationId\nuserId: $userId"

                //사용자 조회
                dto.enterpriseId = enterpriseId
                dto.organizationId = organizationId
                dto.userId = userId
                dto.list_tp_id = "CH03"
                dto.list_dt_id = "SPTP01"

                val userInfo = salesforceDao.sel_usrInfo(dto)
                if(userInfo == null){
                    val headers = HttpHeaders()
                    headers.contentType = MediaType.APPLICATION_JSON
                    val acceptableMediaType: MutableList<MediaType> = ArrayList()
                    acceptableMediaType.add(MediaType.APPLICATION_JSON)
                    headers.accept = acceptableMediaType
                    headers.set("Authorization", "Bearer $token")

                    val result: ResponseEntity<String> = restTemplate.exchange("$host/platformv2/userinfo", HttpMethod.GET, org.springframework.http.HttpEntity(null, headers), String::class.java)
                    logger.error("{}", result)
                }else{
                    returnMap["usr_grp_cd"] = "04"  // 테스트용 세일즈포스 테스트 그룹
                    returnMap["msg"] = msg // 테스트용 결과 확인
                    returnMap["status"] = "true"
                }
            } else {
                logger.error("tokenContext fail: $responseBody")
            }
        } catch(e: Exception) {
            logger.error("salesforce getUser :", e)
        }
        return returnMap
    }

    override fun mappingLst(dto: SalesforceDto): Map<String, Any> {
        val returnMap: MutableMap<String, Any> = HashMap()
        dto.list_tp_id = "CH03"
        dto.list_dt_id = "SPTP01"
        returnMap["mappingLst"] = salesforceDao.mappingLst(dto)
        return returnMap
    }

    // ================================================= usr_grp_cd, cont_grp_cd 수정 =================================================== //

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
        //val userInfo = UsefulUtils.sessionUser()
        val usr_id: String = "salesforce"
        val cont_grp_cd = contentListCreatedto.cont_grp_cd

        //logger.error("Ins Dto : " + dto.toString());
        //logger.error("Ins ContetnLstDto : " + contentListCreatedto.toString());

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
            //tblmiContMstDto.reg_id = userInfo.usr_id
            //tblmiContMstDto.cont_grp_cd = userInfo.usr_grp_cd
            tblmiContMstDto.reg_id = usr_id
            tblmiContMstDto.cont_grp_cd = cont_grp_cd

            contentDao.insertContentMaster(tblmiContMstDto);// 마스터 코드 리턴
            statusMap["seq"] = tblmiContMstDto.seq as Int

            // 인덱스 값은 고정되서 넘어온다 [ 0번 인덱스 : kakao , 1번 인덱스 : sms , 2번 인덱스: rcs ]
            val len = contentListCreatedto.send_to_list!!.size - 1;

            for (i in 0..len) {

                // 항상 3번 Insert 작업을 진행한다.
                // 공통 값은 배열로 받아 처리, 나머지는 각자 처리
                val tblmiContLstdto = Tblmi_cont_lstDto()

                tblmiContLstdto.cont_cd = tblmiContMstDto.seq   // 마스터 코드 삽입
                tblmiContLstdto.cont_sub = contentListCreatedto.cont_sub_list!![i].trim()
                tblmiContLstdto.send_to = contentListCreatedto.send_to_list!![i]
                tblmiContLstdto.send_nm = null
                tblmiContLstdto.thm_url = null
                tblmiContLstdto.br_yn = "N"
                tblmiContLstdto.sup_yn = "N"
                //tblmiContLstdto.reg_id = userInfo.usr_id
                //tblmiContLstdto.cont_grp_cd = userInfo.usr_grp_cd
                tblmiContLstdto.reg_id = usr_id
                tblmiContLstdto.cont_grp_cd = cont_grp_cd

                val formatList = contentListCreatedto.formatType

                // 인덱스 번호 0 : 카카오
                if (i == 0) {

                    // 제목 저장
                    tblmiContLstdto.cont_sub = contentListCreatedto.cont_sub_list!![i].trim()

                    // 키 삽입
                    val cdDto = Tblmi_comm_cdDto()
                    cdDto.grp_id = "KAKAO_KEY"
                    //cdDto.cd_id = userInfo.usr_grp_cd
                    cdDto.cd_id = cont_grp_cd

                    val codeDto = systemDao.getCommCdKeyValueNull(cdDto)
                    if (codeDto != null) {
                        tblmiContLstdto.key_id = codeDto.cd_val
                    }

                    // 체크 여부에 따라 USE_YN 설정
                    if (formatList!!.contains("kakao")) {
                        tblmiContLstdto.use_yn = "Y"
                    } else {
                        tblmiContLstdto.use_yn = "N"
                    }
                    tblmiContLstdto.cont_tp = "DMTP03" // 카카오
                    tblmiContLstdto.msg_tp = "DMCH204" // 친구톡

                    val kkoOption = contentListCreatedto.kko_option!!.trim()

                    if (kkoOption.equals("ad")) {
                        // 광고 처리
                        tblmiContLstdto.send_tp = "SENDTP01"
                    } else if (kkoOption.equals("guide")) {
                        // 안내 처리
                        tblmiContLstdto.send_tp = "SENDTP02"
                    }

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
                            //cdDto.cd_id = userInfo.usr_grp_cd
                            cdDto.cd_id = cont_grp_cd

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
                            //cdDto.cd_id = userInfo.usr_grp_cd
                            cdDto.cd_id = cont_grp_cd

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
                            //cdDto.cd_id = userInfo.usr_grp_cd
                            cdDto.cd_id = cont_grp_cd

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
                            //cdDto.cd_id = userInfo.usr_grp_cd
                            cdDto.cd_id = cont_grp_cd

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
        } catch (e: java.lang.Exception) {
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
    override fun updateContentList(dto: Tblmi_cont_lstDto): Map<String, Any> {
        val contentListCreatedto = dto as Content_list_CreateDto

        //logger.error("UPDATE dto :" + contentListCreatedto.toString())

        //val userInfo = UsefulUtils.sessionUser()
        val usr_id: String = "salesforce"
        val usr_grp_cd = contentListCreatedto.cont_grp_cd
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
        tblmiContMstDto.reg_id = usr_id
        tblmiContMstDto.upd_id = usr_id
        tblmiContMstDto.cont_grp_cd = usr_grp_cd

        contentDao.updateMobileMst(tblmiContMstDto);

        val len = contentListCreatedto.send_to_list!!.size - 1;

        for (i in 0..len) {
            // 항상 3번 Insert 작업을 진행한다.

            // 공통 값은 배열로 받아 처리, 나머지는 각자 처리
            val tblmiContLstdto = Tblmi_cont_lstDto()

            tblmiContLstdto.seq = contentListCreatedto.list_seq!![i].toInt()
            tblmiContLstdto.cont_cd = tblmiContMstDto.seq
            tblmiContLstdto.cont_sub = contentListCreatedto.cont_sub_list!![i].trim()
            tblmiContLstdto.send_to = contentListCreatedto.send_to_list!![i]
            tblmiContLstdto.send_nm = null
            tblmiContLstdto.thm_url = null
            tblmiContLstdto.br_yn = "N"
            tblmiContLstdto.sup_yn = "N"
            tblmiContLstdto.reg_id = usr_id
            tblmiContLstdto.upd_id = usr_id
            tblmiContLstdto.cont_grp_cd = usr_grp_cd

            val formatList = contentListCreatedto.formatType

            // 인덱스 번호 0 : 카카오
            if (i == 0) {

                // 체크 여부에 따라 USE_YN 설정
                if (formatList!!.contains("kakao")) {
                    tblmiContLstdto.use_yn = "Y"
                } else {
                    tblmiContLstdto.use_yn = "N"
                }

                tblmiContLstdto.cont_tp = "DMTP03" // 카카오
                tblmiContLstdto.msg_tp = "DMCH204" // 친구톡

                val kkoOption = contentListCreatedto.kko_option!!.trim()
                if (kkoOption.equals("ad")) {
                    // 광고 처리
                    tblmiContLstdto.send_tp = "SENDTP01"
                } else if (kkoOption.equals("guide")) {
                    // 안내 처리
                    tblmiContLstdto.send_tp = "SENDTP02"
                }

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

                // RCS 포멧타입 변경에 따라 Key 값이 바뀔 수 있으므로 활성화 해준다

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

                        // RCS SMS key 값 설정
                        val cdDto = Tblmi_comm_cdDto()
                        cdDto.grp_id = "RCS_SMS_MSG_ID"
                        cdDto.cd_id = usr_grp_cd

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
                        cdDto.cd_id = usr_grp_cd

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
                else if (rcsFormatType.equals("vertical")) {
                    // RCS 세로형의 경우
                    if (rcsMsgType.equals("tall")) {
                        // tall형 인 경우
                        tblmiContLstdto.msg_tp = "DMCH207"

                        // RCS 세로형 Tall Key 값 설정
                        val cdDto = Tblmi_comm_cdDto()
                        cdDto.grp_id = "RCS_L_TALL_MSG_ID"
                        cdDto.cd_id = usr_grp_cd

                        val codeDto = systemDao.getCommCdKeyValueNull(cdDto)
                        if (codeDto != null) {
                            tblmiContLstdto.key_id = codeDto.cd_val
                        }

                    } else if (rcsMsgType.equals("medium")) {
                        // medium인 경우
                        tblmiContLstdto.msg_tp = "DMCH208"

                        // RCS 세로형 Medium Key 값 설정
                        val cdDto = Tblmi_comm_cdDto()
                        cdDto.grp_id = "RCS_L_MD_MSG_ID"
                        cdDto.cd_id = usr_grp_cd

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
                    val contUrlDto: Tblmi_cont_url_lstDto = Tblmi_cont_url_lstDto()
                    contUrlDto.url_tag = "img"
                    contUrlDto.url = contentListCreatedto.kko_img_url
                    contUrlDto.url_id = "kkoImg001"
                    contUrlDto.cont_lst_cd = lastSeq
                    contentDao.insertContentUrl(contUrlDto)
                }
                // btn 처리
                if (!CommonUtils.isEmptyObject(contentListCreatedto.kko_btn_url)) {
                    val contUrlDto: Tblmi_cont_url_lstDto = Tblmi_cont_url_lstDto()
                    contUrlDto.url_tag = "btn"
                    contUrlDto.url = contentListCreatedto.kko_btn_url
                    contUrlDto.url_id = "kkoBtn001"
                    contUrlDto.cont_lst_cd = lastSeq
                    contentDao.insertContentUrl(contUrlDto)
                }
                // 카카오 본문 a 링크 저장 테스트
                val url_kakao_body = contentListCreatedto.kakao_body

                if (url_kakao_body?.contains("{{") == true) {

                    //logger.error("contain url kakao_body : " + url_kakao_body)

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
                                idx++
                                // {{ }} 규칙에 맞는 형태이며, http, https 를 포함하고 있다면 URL을 저장한다
                                //logger.error("parsing url : " + url)
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
                // 모바일 url 링크 저장
                if (!CommonUtils.isEmptyObject(contentListCreatedto.mms_imgurl)) {
                    val contUrlDto: Tblmi_cont_url_lstDto = Tblmi_cont_url_lstDto()
                    contUrlDto.url_tag = "a"
                    contUrlDto.url = contentListCreatedto.mms_imgurl
                    contUrlDto.url_id = "mmsImg001"
                    contUrlDto.cont_lst_cd = lastSeq
                    contentDao.insertContentUrl(contUrlDto)
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
                    var i = 0
                    var idx = 0;

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
                val urlLen = contentListCreatedto?.url_value?.size   // 버튼 창이 클릭되면 hidden 값으로 idx 맞게 들어온다

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
        statusMap["status"] = true
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
                logger.error("비어있음");
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
        val len = contentListCreatedto?.slide_cont_sub?.size
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

            val btn1Value = contentListCreatedto?.slide_rcs_btn_1!![idx]
            val btn1Type = contentListCreatedto?.slide_rcs_btn_tp_1!![idx]
            val btn2Value = contentListCreatedto?.slide_rcs_btn_2!![idx]
            val btn2Type = contentListCreatedto?.slide_rcs_btn_tp_2!![idx]

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

        val len = contentListCreatedto?.copy_value?.size
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
    
    // 컨텐츠 등록 끝
    
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
        //tblmiContMstdto.cont_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        return contentDao.checkContNm(tblmiContMstdto)
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

        //searchDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
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
     * @Method Name  : selectImgForPopup
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : tblmiContImgdto: Tblmi_cont_imgDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 선택된 이미지 팝업 띄우기
     * @title : 선택 이미지 팝업
     */
    override fun selectImgForPopup(tblmiContImgdto: Tblmi_cont_imgDto): Map<String, Any> {

        // 클릭 값에 따라 이미지가 다르게 보여져야함
        val searchDto = tblmiContImgdto as Image_searchDto
        //searchDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd

        val paginationInfo = UsefulUtils.makePage(searchDto.pageNo, 4, 4)
        val paramMap: MutableMap<String, Any> = HashMap()

        searchDto.firstIndex = paginationInfo.firstRecordIndex
        searchDto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = contentDao.getImgListCnt(searchDto)

        paramMap["page"] = paginationInfo
        paramMap["pageNo"] = paginationInfo.currentPageNo
        paramMap["list"] = contentDao.getImgList(searchDto)
        paramMap["listCnt"] = paginationInfo.totalRecordCount

        return paramMap
    }

    /**
     * @Method Name  : getImgNmCh
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : dto: Tblmi_cont_imgDto
     * @return   : Int
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이미지 명 중복확인
     * @title : 이미지면 중복확인
     */
    override fun getImgNmCh(dto:Tblmi_cont_imgDto): Int{
        val idto : Tblmi_cont_imgDto = Tblmi_cont_imgDto()
        idto.img_nm = dto.img_nm
        //idto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        return contentDao.getImgNmCh(idto)

    }

}