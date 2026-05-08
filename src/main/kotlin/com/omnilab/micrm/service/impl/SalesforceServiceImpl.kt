package com.omnilab.micrm.service.impl

import com.exacttarget.fuelsdk.*
import com.google.gson.GsonBuilder
import com.google.gson.JsonArray
import com.google.gson.JsonObject
import com.google.gson.reflect.TypeToken
import com.omnilab.micrm.common.AES256
import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.GlobalValues
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.*
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.model.table.kakao.*
import com.omnilab.micrm.model.table.rcs.LgRcs_imgDto
import com.omnilab.micrm.repository.*
import com.omnilab.micrm.service.ContentService
import com.omnilab.micrm.service.CouponIssueService
import com.omnilab.micrm.service.SalesforceService
import com.omnilab.micrm.service.SysSettingService
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
import org.springframework.security.authentication.AuthenticationProvider
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.Authentication
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Propagation
import org.springframework.transaction.annotation.Transactional
import org.springframework.web.client.RestTemplate
import java.net.HttpURLConnection
import java.text.SimpleDateFormat
import java.util.*
import java.util.regex.Pattern
import java.util.stream.Collectors
import javax.servlet.http.HttpSession
import kotlin.collections.ArrayList
import kotlin.collections.HashMap
import kotlin.math.floor


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

    @Autowired
    @Qualifier("CampaignDaoImpl")
    private lateinit var campaignDao: CampaignDao

    @Autowired
    @Qualifier("CampaignMdmDaoImpl")
    private lateinit var mdmSend: CampaignSendDao

    @Autowired
    @Qualifier("CampaignKakaoDaoImpl")
    private lateinit var kkoSend: CampaignSendDao

    @Autowired
    @Qualifier("CampaignKakaoAtDaoImpl")
    private lateinit var kkoSendAt: CampaignSendDao

    @Autowired
    @Qualifier("CampaignRcsDaoImpl")
    private lateinit var rcsSend: CampaignSendDao

    @Autowired
    @Qualifier("SysSettingServiceImpl")
    private lateinit var sysSettingService: SysSettingService

    @Autowired(required = true)
    @Qualifier("MobileContentServiceImpl")
    private lateinit var mobileContentService: ContentService

    @Autowired
    @Qualifier("KkoAtTmplDaoImpl")
    private lateinit var kkoAtTmplDao: KkoAtTmplDao
    
    @Autowired
    private lateinit var kkoRestApiServiceImpl: KkoRestApiServiceImpl
    
    @Autowired
    @Qualifier("CouponIssueServiceImpl")
    private lateinit var couponIssueService: CouponIssueService

    @Autowired
    private lateinit var customAuthenticationProvider: AuthenticationProvider

    private val yyyymmddFormat = SimpleDateFormat("YYYY-MM-dd")
    private val gson = GsonBuilder().create()

    @Transactional(propagation= Propagation.REQUIRES_NEW, rollbackFor = [ Throwable::class ])
    override fun getUser(dto: SalesforceDto, session: HttpSession): Map<String, Any> {
        val returnMap: MutableMap<String, Any> = HashMap()
        try {
            val host: String = dto.host!!
            val token: String? = dto.token
            val fuel2token: String = dto.fuel2token!!

            val client: HttpClient = HttpClients.createDefault()
            val httpGet = HttpGet("$host/platform/v1/tokenContext")
            httpGet.addHeader("Content-type", "application/json")
            httpGet.addHeader("Authorization", "Bearer $fuel2token")
            val response: CloseableHttpResponse = client.execute(httpGet) as CloseableHttpResponse
            val entity: HttpEntity = response.entity
            val responseBody = EntityUtils.toString(entity, Charsets.UTF_8)
            val statusLine: StatusLine = response.statusLine
            //logger.info("responseBody : {}", responseBody)

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
                val token1: Authentication = UsernamePasswordAuthenticationToken(organizationId, userId)

                val auth = customAuthenticationProvider.authenticate(token1)
                if (auth.isAuthenticated) {
                    session.setAttribute("MID", organizationId)
                    SecurityContextHolder.getContext().authentication = auth
                    val loginDto: Tblmi_usrDto = auth.details as Tblmi_usrDto
                    returnMap["usr_grp_cd"] = loginDto.usr_grp_cd!!
                    returnMap["msg"] = msg
                    returnMap["status"] = "true"

                    val kkoDto = SetLst_searchDto()
                    kkoDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
                    kkoDto.list_tp_id = "CH02"
                    kkoDto.list_dt_id = "DMTP03"
                    kkoDto.def_yn = "Y"
                    returnMap["kko"] = mobileContentService.selectSenderList(kkoDto)

                    val smsDto = SetLst_searchDto()
                    smsDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
                    smsDto.list_tp_id = "CH02"
                    smsDto.list_dt_id = "DMTP02"
                    smsDto.def_yn = "Y"
                    returnMap["mdm"] = mobileContentService.selectSenderList(smsDto)

                    val rcsDto = SetLst_searchDto()
                    rcsDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
                    rcsDto.list_tp_id = "CH02"
                    rcsDto.list_dt_id = "DMTP04"
                    rcsDto.def_yn = "Y"
                    returnMap["rcs"] = mobileContentService.selectSenderList(rcsDto)
                }else{
                    returnMap["status"] = "false"
                }

                /*
                val check: Authentication = SecurityContextHolder.getContext().authentication
                //로그인되있음
                if(check !is AnonymousAuthenticationToken){
                    val loginDto: Tblmi_usrDto = check.details as Tblmi_usrDto
                    if(session.getAttribute("MID") != null && session.getAttribute("MID").toString() == loginDto.usr_grp_cd!!){
                        if(loginDto.usr_sales_id.isNullOrEmpty()){
                            loginDto.usr_sales_id = userId.toString()
                            salesforceDao.upd_usrInfo(loginDto)
                        }
                        returnMap["usr_grp_cd"] = loginDto.usr_grp_cd!!
                        returnMap["msg"] = msg
                        returnMap["status"] = "true"

                        val kkoDto = SetLst_searchDto()
                        kkoDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
                        kkoDto.list_tp_id = "CH02"
                        kkoDto.list_dt_id = "DMTP03"
                        kkoDto.def_yn = "Y"
                        returnMap["kko"] = mobileContentService.selectSenderList(kkoDto)

                        val smsDto = SetLst_searchDto()
                        smsDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
                        smsDto.list_tp_id = "CH02"
                        smsDto.list_dt_id = "DMTP02"
                        smsDto.def_yn = "Y"
                        returnMap["mdm"] = mobileContentService.selectSenderList(smsDto)

                        val rcsDto = SetLst_searchDto()
                        rcsDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
                        rcsDto.list_tp_id = "CH02"
                        rcsDto.list_dt_id = "DMTP04"
                        rcsDto.def_yn = "Y"
                        returnMap["rcs"] = mobileContentService.selectSenderList(rcsDto)
                    }else{
                        SecurityContextHolder.clearContext()
                        val token: Authentication = UsernamePasswordAuthenticationToken(organizationId, userId)
                        val auth = customAuthenticationProvider.authenticate(token)
                        if (auth !is AnonymousAuthenticationToken) {
                            session.setAttribute("MID", userId)
                            SecurityContextHolder.getContext().authentication = auth
                            val loginDto: Tblmi_usrDto = auth.details as Tblmi_usrDto
                            returnMap["usr_grp_cd"] = loginDto.usr_grp_cd!!
                            returnMap["msg"] = msg
                            returnMap["status"] = "true"

                            val kkoDto = SetLst_searchDto()
                            kkoDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
                            kkoDto.list_tp_id = "CH02"
                            kkoDto.list_dt_id = "DMTP03"
                            kkoDto.def_yn = "Y"
                            returnMap["kko"] = mobileContentService.selectSenderList(kkoDto)

                            val smsDto = SetLst_searchDto()
                            smsDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
                            smsDto.list_tp_id = "CH02"
                            smsDto.list_dt_id = "DMTP02"
                            smsDto.def_yn = "Y"
                            returnMap["mdm"] = mobileContentService.selectSenderList(smsDto)

                            val rcsDto = SetLst_searchDto()
                            rcsDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
                            rcsDto.list_tp_id = "CH02"
                            rcsDto.list_dt_id = "DMTP04"
                            rcsDto.def_yn = "Y"
                            returnMap["rcs"] = mobileContentService.selectSenderList(rcsDto)
                        }else{
                            returnMap["status"] = "false"
                        }
                    }
                }else{
                    val token: Authentication = UsernamePasswordAuthenticationToken(organizationId, userId)

                    val auth = customAuthenticationProvider.authenticate(token)
                    if (auth.isAuthenticated) {
                        session.setAttribute("MID", userId)
                        SecurityContextHolder.getContext().authentication = auth
                        val loginDto: Tblmi_usrDto = auth.details as Tblmi_usrDto
                        returnMap["usr_grp_cd"] = loginDto.usr_grp_cd!!
                        returnMap["msg"] = msg
                        returnMap["status"] = "true"

                        val kkoDto = SetLst_searchDto()
                        kkoDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
                        kkoDto.list_tp_id = "CH02"
                        kkoDto.list_dt_id = "DMTP03"
                        kkoDto.def_yn = "Y"
                        returnMap["kko"] = mobileContentService.selectSenderList(kkoDto)

                        val smsDto = SetLst_searchDto()
                        smsDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
                        smsDto.list_tp_id = "CH02"
                        smsDto.list_dt_id = "DMTP02"
                        smsDto.def_yn = "Y"
                        returnMap["mdm"] = mobileContentService.selectSenderList(smsDto)

                        val rcsDto = SetLst_searchDto()
                        rcsDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
                        rcsDto.list_tp_id = "CH02"
                        rcsDto.list_dt_id = "DMTP04"
                        rcsDto.def_yn = "Y"
                        returnMap["rcs"] = mobileContentService.selectSenderList(rcsDto)
                    }else{
                        returnMap["status"] = "false"
                    }
                }
                 */
            } else {
                logger.error("tokenContext fail: $responseBody")
            }
        } catch(e: Exception) {
            logger.error("salesforce getUser {} :", dto, e)
        }
        return returnMap
    }

    @Transactional(propagation= Propagation.REQUIRES_NEW, rollbackFor = [ Throwable::class ])
    override fun mappingLst(dto: SalesforceDto): Map<String, Any> {
        val userInfo = UsefulUtils.sessionUser()
        val returnMap: MutableMap<String, Any> = HashMap()
        dto.list_tp_id = "CH03"
        dto.list_dt_id = "SPTP01"
        dto.usr_grp_cd = userInfo.usr_grp_cd!!
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

    @Transactional(propagation= Propagation.REQUIRES_NEW, rollbackFor = [ Throwable::class ])
    override fun insertContentList(dto: Content_list_CreateDto): ReturnDto {
        val re = ReturnDto(true)
        val userInfo = UsefulUtils.sessionUser()

        val isByte = isCheckByte(dto)
        if (!isByte.status!!) {
            return isByte
        }

        val tblmiContMstDto = Tblmi_cont_mstDto()
        try {
            tblmiContMstDto.apply {
                ch_tp = "CH03"
                cont_nm = dto.cont_nm
                reg_id = userInfo.usr_id
                cont_grp_cd = userInfo.usr_grp_cd
                sales_nm = dto.sales_nm
                avo_id = dto.avo_id
                inten_id = dto.inten_id
                orig_id = dto.orig_id
                inta_key = dto.inta_key
                inta_ve = dto.inta_ve
                camp_nm = dto.camp_nm
                team_cd = dto.team_cd
                usr_key = dto.usr_key
                bu_id = dto.bu_id
            }
            //임시 주석
            contentDao.insertContentMaster(tblmiContMstDto)// 마스터 코드 리턴
            re.data = tblmiContMstDto.seq.toString()

            // 3. 리스트 데이터 처리 (0: 카카오, 1: SMS, 2: RCS)
            val len: Int = dto.send_to_list!!.size - 1
            for (i in 0..len) {
                val tblmiContLstdto = Tblmi_cont_lstDto().apply {
                    cont_cd = tblmiContMstDto.seq
                    cont_sub = dto.cont_sub_list!![i].trim()
                    from_to = dto.from_to
                    send_to = dto.send_to_list!![i]
                    reg_id = userInfo.usr_id
                    cont_grp_cd = userInfo.usr_grp_cd
                    br_yn = "N"
                    sup_yn = "N"
                }
                // 채널별 상세 분기 처리
                when (i) {
                    0 -> processKakao(dto, tblmiContLstdto, userInfo, re)?.let { return it }
                    1 -> processSms(dto, tblmiContLstdto)
                    2 -> processRcs(dto, tblmiContLstdto, userInfo, i)
                }
                //임시 주석
                contentDao.insertContent(tblmiContLstdto)
                // 4. URL 저장 로직
                saveUrls(i, dto, tblmiContLstdto.seq!!)
            }
        } catch (e: Exception) {
            logger.error("insert content", e)
            logger.error("마스터 코드 " + tblmiContMstDto.seq);
            handleManualRollback(tblmiContMstDto.seq!!, e)
            re.status = false
            re.errMsg = "모바일 컨텐츠 저장 도중 오류가 발생 했습니다. \n동일 증상이 반복되면 관리자에게 문의 바랍니다."
            return re
        }
        return re
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
    @Transactional(propagation= Propagation.REQUIRES_NEW, rollbackFor = [ Throwable::class ])
    override fun updateContentList(dto: Tblmi_cont_lstDto): ReturnDto {
        val re = ReturnDto(true)
        val createDto = dto as Content_list_CreateDto
        val userInfo = UsefulUtils.sessionUser()

        val isByte = isCheckByte(createDto)
        if (!isByte.status!!) return isByte

        val tblmiContMstDto = Tblmi_cont_mstDto()
        try {
            tblmiContMstDto.apply {
                seq = createDto.mst_seq!!.toInt()
                ch_tp = "CH03"
                cont_nm = createDto.cont_nm
                reg_id = userInfo.usr_id
                upd_id = userInfo.usr_id
                cont_grp_cd = createDto.cont_grp_cd
                sales_nm = createDto.sales_nm
                avo_id = createDto.avo_id
                inten_id = createDto.inten_id
                orig_id = createDto.orig_id
                inta_key = createDto.inta_key
                inta_ve = createDto.inta_ve
                camp_nm = createDto.camp_nm
                team_cd = createDto.team_cd
                usr_key = createDto.usr_key
                bu_id = createDto.bu_id
            }
            contentDao.updateMobileMst(tblmiContMstDto)
            val contLst = salesforceDao.sel_tblmi_cont_lst(Tblmi_cont_lstDto().apply { cont_cd = tblmiContMstDto.seq })
            val len = createDto.send_to_list!!.size - 1
            for (i in 0..len) {
                val tblmiContLstdto = Tblmi_cont_lstDto().apply {
                    seq = when (i) {
                        0 -> contLst.firstOrNull { it.cont_tp in listOf("DMTP03", "DMTP05") }?.seq
                        1 -> contLst.firstOrNull { it.cont_tp == "DMTP02" }?.seq
                        else -> contLst.firstOrNull { it.cont_tp == "DMTP04" }?.seq
                    }
                    cont_cd = tblmiContMstDto.seq
                    cont_sub = createDto.cont_sub_list!![i].trim()
                    send_to = createDto.send_to_list!![i]
                    from_to = createDto.from_to
                    reg_id = userInfo.usr_id
                    upd_id = userInfo.usr_id
                    cont_grp_cd = createDto.cont_grp_cd
                    br_yn = "N"
                    sup_yn = "N"
                    kko_tmpl_cd = contLst.firstOrNull { it.cont_tp in listOf("DMTP03", "DMTP05") }?.kko_tmpl_cd
                }
                when (i) {
                    0 -> processKakao(createDto, tblmiContLstdto, userInfo, ReturnDto())?.let { return it }
                    1 -> processSms(createDto, tblmiContLstdto)
                    2 -> processRcs(createDto, tblmiContLstdto, userInfo, i)
                }
                contentDao.updateMobileContent(tblmiContLstdto)
                contentDao.delTblmiContUrlLst(Tblmi_cont_url_lstDto().apply {
                    cont_lst_cd = tblmiContLstdto.seq!!
                    url_id = if (i == 0) "kko" else "mms"
                })
                saveUrls(i, createDto, tblmiContLstdto.seq!!)
            }
        } catch (e: Exception){
            logger.error("update content", e)
            logger.error("마스터 코드 " + tblmiContMstDto.seq);
            handleManualRollback(tblmiContMstDto.seq!!, e)
            re.status = false
            re.errMsg = "모바일 컨텐츠 수정 도중 오류가 발생 했습니다. \n동일 증상이 반복되면 관리자에게 문의 바랍니다."
            return re
        }
        return re
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

        searchDto.firstIndex = paginationInfo.firstRecordIndex
        searchDto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = contentDao.selectSenderListCnt(searchDto)

        paramMap["page"] = paginationInfo
        paramMap["pageNo"] = paginationInfo.currentPageNo
        paramMap["list"] = contentDao.selectSenderList(searchDto)
        paramMap["listCnt"] = contentDao.selectSenderListCnt(searchDto)

        return paramMap
    }

    override fun selectRejectTextList(dto: SetLst_searchDto): MutableMap<String, Any> {
        val searchDto = dto as SetLst_searchDto
        val paramMap: MutableMap<String, Any> = HashMap()
        val paginationInfo: PaginationInfo = UsefulUtils.makePage(searchDto.pageNo, 10, 5)

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
        searchDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd

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
        val idto = Tblmi_cont_imgDto()
        idto.img_nm = dto.img_nm
        idto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        return contentDao.getImgNmCh(idto)
    }

    override fun campaingContent(dto: Tblmi_cont_mstDto): Boolean {
        try {
            val mstDto: Tblmi_cont_mstDto = salesforceDao.sel_tblmi_cont_mstOne(dto)
            // Journey Builder 정보 조회
            val commDto = Tblmi_comm_cdDto()
            commDto.cd_id = mstDto.cont_grp_cd
            commDto.par_id = "SALESFORCE"
            val urlInfo = systemDao.getCommCDLst(commDto)
            
            val restUrl = urlInfo.stream().filter { it.grp_id.equals("SALES_REST_URL") }.findAny().orElse(null)
            val authUrl = urlInfo.stream().filter { it.grp_id.equals("SALES_AUTH_URL") }.findAny().orElse(null)
            val cid = urlInfo.stream().filter { it.grp_id.equals("SALES_CID") }.findAny().orElse(null)
            val sec = urlInfo.stream().filter { it.grp_id.equals("SALES_SEC") }.findAny().orElse(null)
            
            val postData = HashMap<String, String>()
            postData["grant_type"] = "client_credentials"
            postData["client_id"] = cid.cd_val.toString()
            postData["client_secret"] = sec.cd_val.toString()
            if (!mstDto.bu_id.isNullOrEmpty()) {
                postData["account_id"] = mstDto.bu_id.toString()
            }
            
            //logger.info("gson.toJson(postData) {}", gson.toJson(postData))
            
            val headers = HttpHeaders()
            headers.contentType = MediaType.APPLICATION_JSON
            val acceptableMediaType: MutableList<MediaType> = ArrayList()
            acceptableMediaType.add(MediaType.APPLICATION_JSON)
            headers.accept = acceptableMediaType
            
            val tokenResult = connection("${authUrl!!.cd_val}/v2/token", HttpMethod.POST, gson.toJson(postData), null)
            if (tokenResult["result"] as Boolean) {
                val tokenMap = gson.fromJson(tokenResult["data"].toString(), MutableMap::class.java)
                val token = tokenMap["access_token"].toString()
                val result = connection("${restUrl!!.cd_val}/interaction/v1/interactions/${dto.orig_id}?versionNumber=${dto.inta_ve}", HttpMethod.GET, null, token)
                if (result["result"] as Boolean) {
                    val data = gson.fromJson(result["data"].toString(), MutableMap::class.java)
                    val activities = data["activities"] as MutableList<MutableMap<String, Any>>
                    val fillterActivities = activities.stream().filter {
                        it["type"].toString() == "REST" && it["id"] == dto.avo_id
                    }.collect(Collectors.toList())
                    
                    if (!fillterActivities.isNullOrEmpty()) {
                        for (activity in fillterActivities) {
                            //val type = activity["type"].toString()
                            //if (type == "REST") {
                            logger.error("activity : {}", activity)
                            val salesNm = data["name"].toString()
                            val avoNm = activity["name"].toString()
                            val avoId = activity["id"].toString()
                            val seq = (((activity["arguments"] as MutableMap<String, Any>)["execute"] as MutableMap<String, Any>)["inArguments"] as MutableList<MutableMap<String, Any>>)[0]["seq"].toString().split(".")[0]
                            val temp = Tblmi_cont_mstDto(seq.toInt())
                            val contDto: Tblmi_cont_mstDto = salesforceDao.sel_tblmi_cont_mstOne(temp)
                            val usrId = if (mstDto.upd_id == null) {
                                mstDto.reg_id
                            } else {
                                mstDto.upd_id
                            }
                            val cpMstDto = Tblmicp_cont_mstDto(contDto)
                            cpMstDto.cont_seq = seq.toInt()
                            cpMstDto.sales_nm = salesNm
                            cpMstDto.camp_nm = contDto.camp_nm
                            cpMstDto.team_cd = contDto.team_cd
                            cpMstDto.usr_key = contDto.usr_key
                            cpMstDto.avo_nm = avoNm
                            cpMstDto.avo_id = avoId
                            cpMstDto.inten_id = dto.inten_id
                            cpMstDto.orig_id = dto.orig_id
                            cpMstDto.inta_key = dto.inta_key
                            cpMstDto.inta_ve = dto.inta_ve
                            cpMstDto.pub_yn = dto.pub_yn
                            salesforceDao.ins_tblmicp_cont_mst(cpMstDto)
                            
                            // 중복 데이터 이슈로 인한 체크 변경
                            if (cpMstDto.seq != null) {
                                //기존 데이터가 있을 경우 삭제
                                salesforceDao.del_tblmicp_cont_url_lst(cpMstDto.seq.toString())
                                salesforceDao.del_tblmicp_cont_lst(cpMstDto.seq.toString())
                                salesforceDao.del_tblmicou_coupon_issue(cpMstDto.seq.toString())
                                
                                //신규 데이터 삽입
                                val contListDto = Tblmi_cont_lstDto()
                                contListDto.cont_cd = seq.toInt()
                                contListDto.reg_id = usrId
                                contListDto.upd_id = usrId
                                contListDto.use_yn = "Y"
                                val contLst = salesforceDao.sel_tblmi_cont_lst(contListDto)
                                
                                for (i in contLst) {
                                    val oriSeq = i.seq.toString()
                                    // 리스트 삽입
                                    val tblmicpContLstdto = Tblmicp_cont_lstDto(i)
                                    tblmicpContLstdto.seq = null
                                    tblmicpContLstdto.cont_cd = cpMstDto.seq
                                    tblmicpContLstdto.reg_id = usrId
                                    tblmicpContLstdto.upd_id = usrId
                                    salesforceDao.ins_tblmicp_cont_lst(tblmicpContLstdto)
                                    
                                    //신규 url 리스트 삽입
                                    val map = HashMap<String, Any>()
                                    map["cont_lst_cd"] = tblmicpContLstdto.seq!!
                                    map["list_seq"] = oriSeq
                                    salesforceDao.ins_tblmicp_cont_url_lst(map)
                                    
                                    // 쿠폰 발급 이력 생성
                                    if (i.cont_tp == "DMTP02" && !i.coupon_seq.isNullOrEmpty()) {
                                        val couponIssueDto = CouponIssueDto()
                                        couponIssueDto.coupon_seq = Integer.parseInt(i.coupon_seq)
                                        couponIssueDto.send_phone = tblmicpContLstdto.send_to
                                        couponIssueDto.msg_title = i.cont_sub
                                        couponIssueDto.msg_content = i.cont_body
                                        couponIssueDto.usr_grp_cd = i.cont_grp_cd
                                        couponIssueDto.reg_id = i.reg_id
                                        couponIssueDto.camp_seq = cpMstDto.seq
                                        salesforceDao.insert_coupon_issue(couponIssueDto)
                                    }
                                }
                            }
                            //}
                        }
                    } else {
                        logger.error("fillterActivities is null : {}", dto)
                    }
                    return true
                } else {
                    logger.error("connection Error : {} / {}", "${restUrl.cd_val}/interaction/v1/interactions/${dto.orig_id}?versionNumber=${dto.inta_ve}", result)
                    return false
                }
            } else {
                logger.error("connection Error : {}", tokenResult)
                return false
            }
        }catch (e: Exception){
            logger.error("campaingContent ERROR", e)
            throw Exception("rollback")
        }
    }

    //@Transactional(propagation= Propagation.REQUIRES_NEW, rollbackFor = [ Throwable::class ])
    override fun publish(dto: Tblmicp_cont_mstDto): Boolean {
        val save = salesforceDao.upd_tblmicp_cont_mst(dto)
        return if(save == 1){
            if(dto.pub_yn == "Y"){
                val mstContDto = Tblmicp_cont_mstDto()
                mstContDto.inten_id = dto.inten_id
                mstContDto.orig_id = dto.orig_id
                mstContDto.inta_key = dto.inta_key
                mstContDto.inta_ve = dto.inta_ve
                val contLstM = salesforceDao.sel_tblmicp_cont_mst(mstContDto)
                val usrId = if (contLstM[0].upd_id == null) {
                    contLstM[0].reg_id
                } else {
                    contLstM[0].upd_id
                }

                val check = Tblmicp_programDto()
                check.inten_id = dto.inten_id
                check.orig_id = dto.orig_id
                check.inta_key = dto.inta_key
                check.inta_ve = dto.inta_ve
                check.reg_id = usrId
                check.upd_id = usrId

                var proDto = salesforceDao.sel_tblmicp_program(check)
                if(proDto == null){
                    val temp = Tblmicp_programDto()
                    temp.pro_id = "PRO${CommonUtils.getDateTimeNowYYYMMDDSSS()}${dto.cont_grp_cd}"
                    temp.pro_tp = "SALES"
                    temp.pro_st = "03" // 발송 진행 중
                    temp.pro_tg_tp = "TG01"
                    temp.pro_tg_id = "SALES"
                    temp.cont_cnt = contLstM.size
                    temp.camp_cnt = contLstM.size
                    temp.pro_nm = contLstM[0].sales_nm
                    temp.team_cd = contLstM[0].team_cd
                    temp.usr_grp_cd = contLstM[0].cont_grp_cd
                    temp.inten_id = dto.inten_id
                    temp.orig_id = dto.orig_id
                    temp.inta_key = dto.inta_key
                    temp.inta_ve = dto.inta_ve
                    temp.reg_id = usrId
                    temp.upd_id = usrId
                    campaignDao.ins_program(temp)
                    proDto = salesforceDao.sel_tblmicp_program(check)
                }

                for(i in contLstM){
                    val campaignDto = Tblmicp_campaignDto(proDto!!.pro_id)
                    campaignDto.cont_id = i.seq
                    campaignDto.send_tg_tp = "TG01"
                    campaignDto.send_tg_id = "SALES"
                    campaignDto.camp_st = "03"
                    campaignDto.camp_nm = contLstM[0].camp_nm
                    campaignDto.team_cd = contLstM[0].team_cd
                    campaignDto.camp_ch = i.ch_tp
                    campaignDto.sto = "01"
                    campaignDto.usr_grp_cd = proDto.usr_grp_cd
                    campaignDto.reg_id = proDto.reg_id
                    campaignDto.start_dt = CommonUtils.getDateTimeNow()
                    campaignDto.send_st_tp = "1"
                    campaignDao.ins_campaign(campaignDto)

                    // RCS img
                    val contListDto = Tblmicp_cont_lstDto()
                    contListDto.cont_cd = i.seq
                    contListDto.reg_id = usrId
                    contListDto.upd_id = usrId
                    contListDto.cont_grp_cd = proDto.usr_grp_cd
                    contListDto.cont_tp ="DMTP04"
                    contListDto.use_yn = "Y"
                    val contLst = campaignDao.sel_tblmicp_cont_lst(contListDto)
                    for (cont in contLst) {
                        val rcsBrnID = sysSettingService.getCommCD(Tblmi_comm_cdDto("RCS_BRND_ID", contListDto.cont_grp_cd!!))!!.cd_val
                        // 이미지 저장 경로
                        val imgPath = sysSettingService.getCommCD(Tblmi_comm_cdDto("IMG_PATH", contListDto.cont_grp_cd!!))!!.cd_val
                        // RCS 발송 서버 정보
                        val rcsDb = sysSettingService.getCommCD(Tblmi_comm_cdDto("RCS_DB", contListDto.cont_grp_cd!!))!!.cd_val

                        val urlLst = cont.img_nm_lst!!.split(",")
                        // 이미지 리스트
                        val rcsImgLst = ArrayList<LgRcs_imgDto>()
                        val urlSize = urlLst.size.toString()
                        for (j in urlLst.indices) {
                            if(!CommonUtils.isEmptyObject(urlLst[j].trim())){
                                val imgDto = LgRcs_imgDto()
                                imgDto.group_key = "GR_${campaignDto.seq.toString()}"
                                imgDto.group_cnt = urlSize
                                imgDto.status = "0"
                                imgDto.sendable = "N"
                                imgDto.brand_id = rcsBrnID
                                imgDto.img_path = imgPath?.trim() + urlLst[j].trim()
                                imgDto.template_yn = "N"
                                imgDto.m_server = rcsDb
                                rcsImgLst.add(imgDto)
                            }
                        }
                        if(rcsImgLst.size > 0){
                            salesforceDao.ins_camp_send_rcs_img_lg(rcsImgLst)
                        }
                    }
                }
                true
            }else{
                true
            }
        }else{
            false
        }
    }

    @Transactional(propagation= Propagation.REQUIRES_NEW, rollbackFor = [ Throwable::class ])
    override fun sendCampaign(map: MutableMap<String, Any>): Boolean {
        val inArguments = mutableMapOf<String,Any>()
        val inArgumentsChil = (map["inArguments"] as MutableList<MutableMap<String, Any>>)[0]
        inArgumentsChil.forEach{ tempMap -> inArguments[tempMap.key.lowercase(Locale.getDefault())] = tempMap.value }

        val avoId: String = map["activityId"].toString()
        val intenId = map["journeyId"].toString()
        val keyValue = map["keyValue"].toString()
        val exMap = HashMap<String, Any>(map)
        exMap["inArguments"] = (map["inArguments"] as MutableList<MutableMap<String, Any>>)[0]

        // 컨테츠 마스터 정보
        val contMstDto = Tblmicp_cont_mstDto()
        contMstDto.avo_id = avoId
        contMstDto.inten_id = intenId
        val contMst = campaignDao.sel_camp_cont_mst(contMstDto)

        if(contMst == null){
            logger.error("contMst == null")
            salesforceDao.ins_tblmicp_sales_execute(exMap)
            return false
        }else {
            //캠페인 정보
            val cDto = Tblmicp_campaignDto()
            cDto.cont_id = contMst.seq
            val campLst = campaignDao.sel_tblmicp_campaign(cDto)

            if(campLst.isEmpty()){
                return false
            }else{
                val date = Date()
                for(campaignDto in campLst){
                    campaignDto.start_dt = CommonUtils.getDateTimeNow()
                    // 타겟수 업데이트
                    if(campaignDto.tar_cnt == null || campaignDto.tar_cnt == 0){
                        var targetCnt: Int? = null
                        if(!CommonUtils.isEmptyObject(inArguments["§extention_cnt§"])){
                            targetCnt = inArguments["§extention_cnt§"].toString().split(".")[0].toInt()
                            inArguments.remove("§extention_cnt§")
                            inArguments.remove("§data_extension_id§")
                        }
                        campaignDto.tar_cnt = targetCnt

                        campaignDto.start_dt = CommonUtils.getDateTimeNow()   // 캠페인 시작 시점
                        salesforceDao.upd_tblmicp_campaign(campaignDto)

                        // 프로그램 total target cnt 수정
                        val program = Tblmicp_programDto(campaignDto.pro_id)
                        program.pro_id = campaignDto.pro_id
                        salesforceDao.upd_tblmicp_program_total_cnt(program)
                    }

                    // sendhst 삽입
                    val sendHstDto = Tblmicp_send_hstDto()
                    sendHstDto.pro_id = campaignDto.pro_id
                    sendHstDto.camp_id = campaignDto.seq
                    sendHstDto.cont_id = campaignDto.cont_id
                    sendHstDto.tbl_id = "sales"
                    sendHstDto.tbl_lst_id = keyValue
                    sendHstDto.send_yn = "N"
                    sendHstDto.auto_tp = null
                    sendHstDto.usr_grp_cd = campaignDto.usr_grp_cd
                    sendHstDto.reg_id = campaignDto.reg_id
                    sendHstDto.camp_ch = campaignDto.camp_ch
                    sendHstDto.camp_dt = yyyymmddFormat.format(date)
                    if(!CommonUtils.isEmptyObject(inArguments[contMst.usr_key])){
                        sendHstDto.usr_key = inArguments[contMst.usr_key]?.toString() // 회원 정보 추가
                    }

                    //컨텐츠 리스트
                    val contLst = campaignDao.sel_tblmicp_cont_lst(Tblmicp_cont_lstDto(campaignDto.cont_id, campaignDto.reg_id, campaignDto.usr_grp_cd))
                    val contTpLst = HashMap<String, Contents_lstDto>()
                    for (check in contLst) {
                        contTpLst[check.cont_tp.toString()] = check
                    }
                    //logger.error("{}",contTpLst)

                    val isCouponSend = contTpLst["DMTP02"] != null && !contTpLst["DMTP02"]?.coupon_seq.isNullOrBlank()
                    if (isCouponSend && map["couponIssuedLogDto"] != null) {
                        val couponIssuedLog = map["couponIssuedLogDto"] as Tblmicou_coupon_issued_logDto
                        contTpLst["DMTP02"]?.cont_body = contTpLst["DMTP02"]?.cont_body?.replace("{쿠폰링크}", couponIssuedLog.short_url!!)
                    }

                    // 발송
                    when {
                        // 카카오 브랜드톡
                        contTpLst["DMTP03"] != null -> {
                            val sendTo = inArguments[contTpLst["DMTP03"]?.from_to]
                            if(sendTo == null){
                                logger.error("sendTo == null")
                                exMap["inArguments"] = exMap["inArguments"].toString()
                                salesforceDao.ins_tblmicp_sales_execute(exMap)
                            }else{
                                sendHstDto.send_to = sendTo.toString()
                                campaignDao.ins_programSendHst(sendHstDto)
                                inArguments["SEND_HST_SEQ"] = sendHstDto.seq!!
                                inArguments["SEND_TO"] = sendTo.toString()
                                kkoSend.ins_send(campaignDto, contTpLst, inArguments)
                            }
                        }
                        // 카카오 알림톡
                        contTpLst["DMTP05"] != null -> {
                            val sendTo = inArguments[contTpLst["DMTP05"]?.from_to]
                            if(sendTo == null){
                                exMap["inArguments"] = exMap["inArguments"].toString()
                                salesforceDao.ins_tblmicp_sales_execute(exMap)
                            }else{
                                sendHstDto.send_to = sendTo.toString()
                                campaignDao.ins_programSendHst(sendHstDto)
                                inArguments["SEND_HST_SEQ"] = sendHstDto.seq!!
                                inArguments["SEND_TO"] = sendTo.toString()
                                kkoSendAt.ins_send(campaignDto, contTpLst, inArguments)
                            }
                        }
                        // RCS
                        contTpLst["DMTP04"] != null -> {
                            val sendTo = inArguments[contTpLst["DMTP04"]?.from_to]
                            if(sendTo == null){
                                logger.error("sendTo == null")
                                exMap["inArguments"] = exMap["inArguments"].toString()
                                salesforceDao.ins_tblmicp_sales_execute(exMap)
                            }else{
                                sendHstDto.send_to = sendTo.toString()
                                campaignDao.ins_programSendHst(sendHstDto)
                                inArguments["SEND_HST_SEQ"] = sendHstDto.seq!!
                                inArguments["SEND_TO"] = sendTo.toString()
                                rcsSend.ins_send(campaignDto, contTpLst, inArguments)
                            }
                        }
                        // 문자
                        else -> {
                            val sendTo = inArguments[contTpLst["DMTP02"]?.from_to]
                            if(sendTo == null){
                                logger.error("sendTo == null")
                                exMap["inArguments"] = exMap["inArguments"].toString()
                                salesforceDao.ins_tblmicp_sales_execute(exMap)
                            }else{
                                sendHstDto.send_to = sendTo.toString()
                                campaignDao.ins_programSendHst(sendHstDto)
                                inArguments["SEND_HST_SEQ"] = sendHstDto.seq!!
                                inArguments["SEND_TO"] = sendTo.toString()
                                mdmSend.ins_send(campaignDto, contTpLst, inArguments)
                            }
                        }
                    }

                    if (isCouponSend) {
                        val dto = map["couponIssuedLogDto"] as Tblmicou_coupon_issued_logDto
                        dto.phone = sendHstDto.send_to
                        dto.msgkey = sendHstDto.seq.toString()
                    }
                }
            }
        }
        return true
    }

    override fun getDataExtention(usrCd: String, extentionId: String, mid: String) : MutableMap<String,Any> {
        val reMap = HashMap<String, Any>()
        val commCdList  = systemDao.getCommCDList(Tblmi_comm_cdDto(usrCd,"SALESFORCE","SALESFORCE","Y"))
        try{
            val configuration = ETConfiguration()
            for (commCd in commCdList){
                when (commCd.grp_id) {
                    "SALES_CID" -> configuration["clientId"] = commCd.cd_val
                    "SALES_SEC" ->  configuration["clientSecret"] = commCd.cd_val
                    "SALES_AUTH_URL" ->  configuration["authEndpoint"] = commCd.cd_val
                    "SALES_REST_URL" ->  configuration["endpoint"] = commCd.cd_val
                    "SALES_SOAP_URL" ->  configuration["soapEndpoint"] = commCd.cd_val
                }
            }
            configuration["accountId"] = mid
            configuration["useOAuth2Authentication"] = "true"
            val client = ETClient(configuration)
            val filter = ETFilter()
            val exp = ETExpression()

            exp.property = "id"
            exp.operator = ETExpression.Operator.EQUALS
            exp.addValue(extentionId)
            filter.expression = exp

            val response = client.retrieve(ETDataExtension::class.java, filter)

            val dataExtension = response.result.getObject()
            val reList =  dataExtension.retrieveColumns().stream().map {column-> column.name.lowercase(Locale.getDefault()) }.collect(Collectors.toList())

            // cloudPage 조회 후 실패할 경우 dataExtension의 totalcnt를 조회한다. (최대 2500개까지 조회 가능)
            val totalCnt = try {
                val data: MutableMap<String, Any>? = getTotalcnt(usrCd, dataExtension.name)
                if (!CommonUtils.isEmptyObject(data)) {
                    data!!["rowCount"].toString().toInt()
                }else{
                    dataExtension.select().totalCount
                }
            } catch (e:Exception){
                logger.error("getDataExtention",e)
                dataExtension.select().totalCount
            }
            reMap["check"] = true
            reMap["list"] = reList
            reMap["totalCnt"] = totalCnt
        }catch (e: Exception){
            reMap["check"] = false
            logger.error("getDataExtention ${usrCd}/${extentionId}/${mid}", e)
        }
        return reMap
    }


    /**
     * @Method Name  : isCheckSender
     * @Since    : 2023. 01. 05.
     * @author   : Belisa
     * @return    : Int
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 카카오 발신자 체크 하기
     * @title  카카오 발신자 체크
     */
    override fun isCheckSender(usrCd: String): Map<String, Any> {
        val paramMap: MutableMap<String, Any> = java.util.HashMap()

        val tblmiDto = Tblmi_set_lstDto()
        tblmiDto.list_tp_id = "CH02"
        tblmiDto.list_dt_id = "DMTP03"
        tblmiDto.usr_grp_cd = usrCd

        val smsMiDto = Tblmi_set_lstDto()
        smsMiDto.list_tp_id = "CH02"
        smsMiDto.list_dt_id = "DMTP02"
        smsMiDto.usr_grp_cd = usrCd

        val rcsMiDto = Tblmi_set_lstDto()
        rcsMiDto.list_tp_id = "CH02"
        rcsMiDto.list_dt_id = "DMTP04"
        rcsMiDto.usr_grp_cd = usrCd

        paramMap["kakaoCnt"] = contentDao.selectSenderListCnt(tblmiDto)
        paramMap["smsCnt"] = contentDao.selectSenderListCnt(smsMiDto)
        paramMap["rcsCnt"] = contentDao.selectSenderListCnt(rcsMiDto)

        return paramMap
    }

    @Throws
    private fun getTotalcnt(usr_cd: String, key : String): MutableMap<String, Any>? {
        val tempComm = Tblmi_comm_cdDto("SALES_TOTAL",usr_cd)
        tempComm.use_yn ="Y"
        val commCd  = systemDao.getCommCDList(tempComm)
        if(CommonUtils.isEmptyObject(commCd)){
            return null
        }

        val totalCntUrl  = commCd[0].cd_val

        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_FORM_URLENCODED
        headers.set("accept", MediaType.ALL_VALUE)

        val urlString = "$totalCntUrl?key=$key"

        val result: ResponseEntity<String> = restTemplate.exchange(urlString, HttpMethod.GET, org.springframework.http.HttpEntity(null, headers), String::class.java)
        val status = result.statusCode.value()
        return if (status >= HttpURLConnection.HTTP_OK && status < HttpURLConnection.HTTP_MULT_CHOICE) {
            if(CommonUtils.isEmptyObject(result.body)){
                logger.error("getTotalCnt url : {}",urlString)
            }
            val body = result.body!!
            gson.fromJson(body, object : TypeToken<Map<String, Any>>() {}.type)
        }else {
            null
        }
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
    private fun isCheckByte(dto: Content_list_CreateDto): ReturnDto {
        val re = ReturnDto()
        // 카카오의 본문 body byte를 체크한다
        if (!CommonUtils.isEmptyObject(dto.kakao_body)) {
            if (!CommonUtils.isEmptyObject(dto.kko_img_cd)) {
                //if (!CommonUtils.checkByteLength(dto.kakao_body, 400)) {
                if (dto.kakao_body!!.length > 400) {
                    logger.error("KaKao 400Byte Error {}, {}", dto.kakao_body?.length, dto.kakao_body)
                    re.status = false
                    re.errMsg = "카카오 메시지 본문이 400자를 초과 합니다."
                    return re
                }
            } else if (CommonUtils.isEmptyObject(dto.kko_img_cd)) {
                //if (!CommonUtils.checkByteLength(dto.kakao_body, 2000)) {
                if (dto.kakao_body!!.length > 1000) {
                    logger.error("KaKao 2000Byte Error {}, {}", dto.kakao_body?.length, dto.kakao_body)
                    re.status = false
                    re.errMsg = "카카오 메시지 본문이 1000자를 초과 합니다."
                    return re
                }
            }
        }

        val smsContSub = dto.cont_sub_list!![1].trim()
        val smsMsgTp = dto.sms_msg_tp

        // 문자의 경우 제목 byte 체크 필요
        if (!CommonUtils.checkByteLength(smsContSub, 80)) {
            logger.error("SMS Title 40Byte Error")
            re.status = false
            re.errMsg = "문자 제목이 40Byte를 초과 합니다."
            return re
        }

        if (smsMsgTp.equals("LMS")) {     // LMS의 경우 본문 Byte 2000 제한
            if (!CommonUtils.checkByteLength(dto.sms_body, 2000)) {
                logger.error("LMS 2000 Byte Error")
                re.status = false
                re.errMsg = "문자 내용이 2000Byte를 초과 합니다."
                return re
            }
        } else if (smsMsgTp.equals("MMS")) {
            //  MMS의 경우 본문 2000 Byte 제한
            // 단, 이미지가 1개일때만 2000Byte 까지 제한하고, 여러개면 1000Byte로 제한한다
            if (!CommonUtils.checkByteLength(dto.sms_body, 2000)) {
                re.status = false
                re.errMsg = "문자 내용이 2000Byte를 초과 합니다."
                return re
            }
        } else if (smsMsgTp.equals("SMS")) { // SMS 의 경우 본문 90 Byte 제한
            if (!CommonUtils.checkByteLength(dto.sms_body, 90)) {
                logger.error("SMS 90 Byte Error")
                re.status = false
                re.errMsg = "문자 내용이 90Byte를 초과 합니다."
                return re
            }
        }
        re.status = true
        return re
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
     *      2021.04.30 수정 : 슬라이드 RCS 발송을 위해 JsonArray에 담는 구조가 아닌
     *      JsonObject 형태로 변경
     * @title : RCS 슬라이드 세팅
     */
    private fun rcsSlideSetting(contentListCreatedto: Content_list_CreateDto, tblmiContLstdto: Tblmi_cont_lstDto) {
        val len = contentListCreatedto.slide_cont_sub?.size
        var slideCnt = 0

        if (len != 0) {
            val jsonTitle = JSONObject()
            val jsonBody = JSONObject()
            for (i in 0 until len!!) {
                slideCnt++
                val titleIdx = "title$slideCnt"
                val descriptionIdx = "description$slideCnt"

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
                jsonActionBtn1Object["displayText"] = contentListCreatedto.slide_rcs_btn_1!![idx]
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
                jsonActionBtn2Object["displayText"] = contentListCreatedto.slide_rcs_btn_2!![idx]
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
            for (i in 0 until len) {
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

                        //logger.error("jsonActionObj : " + jsonActionObject)

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
                    jsonActionObject["displayText"] = contentListCreatedto.rcs_btn_1
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
                    jsonActionObject["displayText"] = contentListCreatedto.rcs_btn_3
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

    private fun connection(url: String, method: HttpMethod, data: String?, authKey: String?): MutableMap<String, Any> {
        val reMap: MutableMap<String, Any> = HashMap()
        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_JSON
        val acceptableMediaType: MutableList<MediaType> = ArrayList()
        acceptableMediaType.add(MediaType.APPLICATION_JSON)
        headers.accept = acceptableMediaType
        if(authKey != null){
            headers.set("Authorization", "Bearer $authKey")
        }
        try{
            val result: ResponseEntity<String> = restTemplate.exchange(url, method, org.springframework.http.HttpEntity(data, headers), String::class.java)
            val status = result.statusCode.value()
            reMap["result"] = status >= HttpURLConnection.HTTP_OK && status < HttpURLConnection.HTTP_MULT_CHOICE
            reMap["status"] = status
            if(result.body == null){
                reMap["data"] = ""
            }else{
                reMap["data"] = result.body!!
                //log.error("{}", result.body)
            }
            return reMap
        }catch (e: Exception){
            logger.error("connection {}", e)
            reMap["result"] = false
            return reMap
        }
    }

    private fun insertContentUrl(urlTag: String, url: String, urlId: String, contLstCd: Int) {
        contentDao.insertContentUrl(Tblmi_cont_url_lstDto(urlTag, url, urlId, contLstCd))
    }

    private fun processKakao(dto: Content_list_CreateDto, listDto: Tblmi_cont_lstDto, userInfo: Tblmi_usrDto, re: ReturnDto): ReturnDto? {
        listDto.use_yn = if (dto.formatType!!.contains("kakao")) "Y" else "N"
        listDto.send_tp = if (dto.kko_option == "ad") "SENDTP01" else "SENDTP02"

        if ("kko_at" == dto.kko_format_type) {
            val atDto = AtTmpl_searchDto(dto.key_id, dto.tmpl_nm, "Y").apply {
                usr_grp_cd = dto.cont_grp_cd
                kep_status = "O"
            }
            kkoAtTmplDao.selTmplBytmplDto(atDto).let { result ->
                listDto.apply {
                    key_id = result.tmpl_cd
                    cont_tp = "DMTP05"
                    msg_tp = if (result.tmpl_empsize_tp == "IMAGE") "DMCH219" else "DMCH216"
                    cont_body = result.tmpl_cont
                    kko_img_cd = result.img_seq
                    kko_img_url = result.kko_img_url
                    kko_title = result.tmpl_tit
                    kko_header = result.tmpl_header
                    kko_msg_tp = if (result.tmpl_empsize_tp == "IMAGE") "AI" else "AT"

                    val obj = JsonObject().apply {
                        add("button", gson.fromJson(result.button_json, JsonArray::class.java))
                        add("quick_reply", gson.fromJson(result.quick_repl_json, JsonArray::class.java))
                        add("item_highlight", gson.fromJson(result.item_highlight_json, JsonObject::class.java))
                        add("item", gson.fromJson(result.item_json, JsonObject::class.java))
                    }
                    kko_btn_obj = gson.toJson(obj)
                }
            }
        } else {
            listDto.cont_tp = "DMTP03"
            val kkoDto = SetLst_searchDto("CH02", "DMTP03", "Y", userInfo.usr_grp_cd).apply { list_val = dto.key_id }
            contentDao.selectSenderList(kkoDto).firstOrNull()?.let { listDto.key_id = it.list_val }

            when (dto.kko_msg_tp) {
                "1" -> {
                    if (!validateKakaoList(dto, re)) return re
                    listDto.msg_tp = "DMCH220"
                    listDto.kko_item_json = createKakaoItemJson(dto)
                    listDto.kko_header = listDto.cont_sub?.let { if (it.length > 20) it.substring(0, 20) else it }
                }
                "2" -> {
                    listDto.msg_tp = "DMCH221"
                    val img = listOf(dto.kakao_item_img_cd_0, dto.kakao_item_img_cd_1, dto.kakao_item_img_cd_2, dto.kakao_item_img_cd_3, dto.kakao_item_img_cd_4, dto.kakao_item_img_cd_5, dto.kakao_item_img_cd_6)
                    val header = listOf(dto.kkoHeader0, dto.kkoHeader1, dto.kkoHeader2, dto.kkoHeader3, dto.kkoHeader4, dto.kkoHeader5, dto.kkoHeader6)
                    val body = listOf(dto.kkoBody0, dto.kkoBody1, dto.kkoBody2, dto.kkoBody3, dto.kkoBody4, dto.kkoBody5, dto.kkoBody6)

                    val price = listOf("", dto.kkoPrice1, dto.kkoPrice2, dto.kkoPrice3, dto.kkoPrice4, dto.kkoPrice5, dto.kkoPrice6)
                    val discountPrice = listOf("", dto.kkoDiscountPrice1, dto.kkoDiscountPrice2, dto.kkoDiscountPrice3, dto.kkoDiscountPrice4, dto.kkoDiscountPrice5, dto.kkoDiscountPrice6)

                    val btn1Nm = listOf("", dto.kkoBtnLst1_1, dto.kkoBtnLst2_1, dto.kkoBtnLst3_1, dto.kkoBtnLst4_1, dto.kkoBtnLst5_1, dto.kkoBtnLst6_1)
                    val btn1Pc = listOf("", dto.kkoBtnUrlLstPc1_1, dto.kkoBtnUrlLstPc2_1, dto.kkoBtnUrlLstPc3_1, dto.kkoBtnUrlLstPc4_1, dto.kkoBtnUrlLstPc5_1, dto.kkoBtnUrlLstPc6_1)
                    val btn1Mo = listOf("", dto.kkoBtnUrlLstMo1_1, dto.kkoBtnUrlLstMo2_1, dto.kkoBtnUrlLstMo3_1, dto.kkoBtnUrlLstMo4_1, dto.kkoBtnUrlLstMo5_1, dto.kkoBtnUrlLstMo6_1)

                    val btn2Nm = listOf("", dto.kkoBtnLst1_2, dto.kkoBtnLst2_2, dto.kkoBtnLst3_2, dto.kkoBtnLst4_2, dto.kkoBtnLst5_2, dto.kkoBtnLst6_2)
                    val btn2Pc = listOf("", dto.kkoBtnUrlLstPc1_2, dto.kkoBtnUrlLstPc2_2, dto.kkoBtnUrlLstPc3_2, dto.kkoBtnUrlLstPc4_2, dto.kkoBtnUrlLstPc5_2, dto.kkoBtnUrlLstPc6_2)
                    val btn2Mo = listOf("", dto.kkoBtnUrlLstMo1_2, dto.kkoBtnUrlLstMo2_2, dto.kkoBtnUrlLstMo3_2, dto.kkoBtnUrlLstMo4_2, dto.kkoBtnUrlLstMo5_2, dto.kkoBtnUrlLstMo6_2)

                    // 2. 작성 여부 판별 (any)
                    val any = BooleanArray(7)
                    for (i in 0..6) {
                        val basicAny = !img[i].isNullOrBlank() || !header[i].isNullOrBlank() || !body[i].isNullOrBlank()
                        val btnAny = if (i == 0) false else (!btn1Nm[i].isNullOrBlank() || !btn2Nm[i].isNullOrBlank())
                        any[i] = basicAny || btnAny
                    }

                    // 3. 카드 최소 2개 필수 (1~6번 중)
                    val cardFilledCount = (1..6).count { any[it] }
                    if (cardFilledCount < 2) {
                        re.status = false
                        re.errMsg = "상품 카드를 최소 2개 이상 작성해주세요."
                        return re
                    }

                    var maxCardIdx = 0
                    for (i in 1..6) if (any[i]) maxCardIdx = i

                    // 4. 상세 유효성 루프
                    for (i in 0..maxCardIdx) {
                        // 순서대로 작성했는지 체크
                        if (!any[i]) {
                            re.status = false
                            re.errMsg = "카드${i}을(를) 먼저 작성해주세요."
                            return re
                        }

                        // [공통 필수] 이미지, 타이틀, 내용
                        if (img[i].isNullOrBlank() || header[i].isNullOrBlank() || body[i].isNullOrBlank()) {
                            val name = if (i == 0) "Intro" else "카드${i}"
                            re.status = false
                            re.errMsg = "${name}의 이미지, 타이틀(상품명), 내용은 필수입니다."
                            return re
                        }

                        if (i == 0) {
                            // --- 인트로 제약조건 ---
                            if (header[0]!!.length > 20 || header[0]!!.contains("\n")) {
                                re.status = false; re.errMsg = "Intro 타이틀은 20자 이내(줄바꿈 불가)여야 합니다."; return re
                            }
                            if (body[0]!!.length > 50 || body[0]!!.count { it == '\n' } > 2) {
                                re.status = false; re.errMsg = "Intro 내용은 50자 이내(줄바꿈 최대 2회)여야 합니다."; return re
                            }
                        } else {
                            // --- 카드 제약조건 ---
                            if (price[i] == null) {
                                re.status = false; re.errMsg = "카드${i}의 가격은 필수 입력 사항입니다."; return re
                            }

                            if (header[i]!!.length > 30) {
                                re.status = false; re.errMsg = "카드${i} 상품명은 30자 이내여야 합니다."; return re
                            }
                            if (body[i]!!.length > 34 || body[i]!!.count { it == '\n' } > 1) {
                                re.status = false; re.errMsg = "카드${i} 내용은 34자 이내(줄바꿈 최대 1회)여야 합니다."; return re
                            }

                            // --- 버튼 유효성 검사 (기존과 동일) ---
                            val b1Any = !btn1Nm[i].isNullOrBlank() || !btn1Pc[i].isNullOrBlank() || !btn1Mo[i].isNullOrBlank()
                            val b2Any = !btn2Nm[i].isNullOrBlank() || !btn2Pc[i].isNullOrBlank() || !btn2Mo[i].isNullOrBlank()

                            if (b2Any && !b1Any) {
                                re.status = false
                                re.errMsg =  "카드${i}의 버튼 2가 입력되었으나 버튼 1이 비어있습니다. 버튼 1부터 입력해주세요."
                                return re
                            }
                            if (!b1Any) {
                                re.status = false
                                re.errMsg = "카드${i}의 버튼 정보를 입력해주세요."
                                return re
                            }
                            if (btn1Nm[i].isNullOrBlank() || btn1Pc[i].isNullOrBlank() || btn1Mo[i].isNullOrBlank()) {
                                re.status = false
                                re.errMsg = "카드${i}의 버튼 1 명칭과 링크(PC/Mo)를 모두 입력해주세요."
                                return re
                            }
                            if (btn1Nm[i]!!.length > 8) {
                                re.status = false
                                re.errMsg = "카드${i}의 버튼 1 명칭은 8자 이내여야 합니다."
                                return re
                            }
                            if (b2Any) {
                                if (btn2Nm[i].isNullOrBlank() || btn2Pc[i].isNullOrBlank() || btn2Mo[i].isNullOrBlank()) {
                                    re.status = false
                                    re.errMsg = "카드${i}의 버튼 2 명칭과 링크(PC/Mo)를 모두 입력해주세요."
                                    return re
                                }
                                if (btn2Nm[i]!!.length > 8) {
                                    re.status = false
                                    re.errMsg = "카드${i}의 버튼 2 명칭은 8자 이내여야 합니다."
                                    return re
                                }
                            }
                        }
                    }
                    val carouselLst = ArrayList<CarouselDto>()
                    var headData: HeadDto? = null // 인트로용 별도 객체

                    for (i in 0..maxCardIdx) {
                        // 인트로를 작성하지 않았으면 건너뜀
                        if (i == 0 && !any[0]) continue

                        val imgId = img[i]?.toIntOrNull() ?: 0
                        val imgDto = contentDao.selTblmiContImg(Tblmi_cont_imgDto(imgId))

                        if (i == 0) {
                            // --- [인트로] head 객체 세팅 ---
                            headData = HeadDto().apply {
                                this.header = header[i]
                                this.content = body[i]
                                this.image_url = imgDto?.kko_img_url
                            }
                        } else {
                            // --- [카드] carousel 리스트 세팅 ---
                            val buttonLst = ArrayList<ButtonJsonDto>()
                            // 버튼 1 (필수)
                            buttonLst.add(ButtonJsonDto(btn1Nm[i].toString(), "WL", btn1Mo[i].toString(), btn1Pc[i].toString()))

                            // 버튼 2 (선택)
                            val b2Any = !btn2Nm[i].isNullOrBlank() || !btn2Pc[i].isNullOrBlank() || !btn2Mo[i].isNullOrBlank()
                            if (b2Any) {
                                buttonLst.add(ButtonJsonDto(btn2Nm[i].toString(), "WL", btn2Mo[i].toString(), btn2Pc[i].toString()))
                            }

                            val itemCard = CarouselDto().apply {
                                this.header = header[i]
                                this.additional_content = body[i]

                                val origin = price[i]?.toString()?.replace(Regex("[^0-9]"), "")?.toLongOrNull() ?: 0L
                                val sale = discountPrice[i]?.toString()?.replace(Regex("[^0-9]"), "")?.toLongOrNull() ?: 0L

                                val discountRate = if (sale > 0L && origin > 0L) {
                                    val rate = (origin - sale).toDouble() / origin * 100
                                    floor(rate).toInt()
                                } else {
                                    0
                                }
                                val commerce = CommerceDto(header[i], origin, sale, discountRate, null)
                                this.attachment = AttachmentDto(
                                    buttonLst,
                                    ImageDto(imgDto?.kko_img_url, null),
                                    commerce
                                )
                            }
                            carouselLst.add(itemCard)
                        }
                    }
                    if(headData != null){
                        listDto.kko_head_json = gson.toJson(headData)
                    }
                    listDto.kko_carousel_json = gson.toJson(carouselLst)
                }
                "3" -> {
                    listDto.msg_tp = "DMCH222"
                    val img = listOf(dto.kakao_item_img_cd_1, dto.kakao_item_img_cd_2, dto.kakao_item_img_cd_3, dto.kakao_item_img_cd_4, dto.kakao_item_img_cd_5, dto.kakao_item_img_cd_6)
                    val header = listOf(dto.kkoHeader1, dto.kkoHeader2, dto.kkoHeader3, dto.kkoHeader4, dto.kkoHeader5, dto.kkoHeader6)
                    val body = listOf(dto.kkoBody1, dto.kkoBody2, dto.kkoBody3, dto.kkoBody4, dto.kkoBody5, dto.kkoBody6)

                    val btn1Nm = listOf(dto.kkoBtnLst1_1, dto.kkoBtnLst2_1, dto.kkoBtnLst3_1, dto.kkoBtnLst4_1, dto.kkoBtnLst5_1, dto.kkoBtnLst6_1)
                    val btn1Pc = listOf(dto.kkoBtnUrlLstPc1_1, dto.kkoBtnUrlLstPc2_1, dto.kkoBtnUrlLstPc3_1, dto.kkoBtnUrlLstPc4_1, dto.kkoBtnUrlLstPc5_1, dto.kkoBtnUrlLstPc6_1)
                    val btn1Mo = listOf(dto.kkoBtnUrlLstMo1_1, dto.kkoBtnUrlLstMo2_1, dto.kkoBtnUrlLstMo3_1, dto.kkoBtnUrlLstMo4_1, dto.kkoBtnUrlLstMo5_1, dto.kkoBtnUrlLstMo6_1)

                    val btn2Nm = listOf(dto.kkoBtnLst1_2, dto.kkoBtnLst2_2, dto.kkoBtnLst3_2, dto.kkoBtnLst4_2, dto.kkoBtnLst5_2, dto.kkoBtnLst6_2)
                    val btn2Pc = listOf(dto.kkoBtnUrlLstPc1_2, dto.kkoBtnUrlLstPc2_2, dto.kkoBtnUrlLstPc3_2, dto.kkoBtnUrlLstPc4_2, dto.kkoBtnUrlLstPc5_2, dto.kkoBtnUrlLstPc6_2)
                    val btn2Mo = listOf(dto.kkoBtnUrlLstMo1_2, dto.kkoBtnUrlLstMo2_2, dto.kkoBtnUrlLstMo3_2, dto.kkoBtnUrlLstMo4_2, dto.kkoBtnUrlLstMo5_2, dto.kkoBtnUrlLstMo6_2)

                    // 카드 작성 여부(any): 이미지/타이틀/내용/버튼 중 하나라도 있으면 작성으로 간주
                    val any = BooleanArray(6)
                    for (i in 0..5) {
                        any[i] = !img[i].isNullOrBlank() || !header[i].isNullOrBlank() || !body[i].isNullOrBlank() ||
                            !btn1Nm[i].isNullOrBlank() || !btn1Pc[i].isNullOrBlank() || !btn1Mo[i].isNullOrBlank() ||
                            !btn2Nm[i].isNullOrBlank() || !btn2Pc[i].isNullOrBlank() || !btn2Mo[i].isNullOrBlank()
                    }
                    val filledCount = any.count { it }
                    if (filledCount < 2) {
                        re.status = false; re.errMsg = "카드를 최소 2개이상 작성해주세요."; return re
                    }

                    var maxFilled = 0
                    for (i in 0..5) if (any[i]) maxFilled = i + 1

                    // 1..maxFilled 중간 누락 금지
                    for (i in 0 until maxFilled) {
                        if (!any[i]) {
                            re.status = false; re.errMsg = "카드${i + 1}을(를) 작성해주세요."; return re
                        }
                    }

                    // 카드1/2 필수 + 1..maxFilled 완성 체크(부분입력 금지)
                    for (i in 0 until maxFilled) {
                        if (img[i].isNullOrBlank() || header[i].isNullOrBlank() || body[i].isNullOrBlank()) {
                            re.status = false; re.errMsg = "카드${i + 1}은 이미지/타이틀/내용이 필수 입니다."; return re
                        }

                        val b1Any = !btn1Nm[i].isNullOrBlank() || !btn1Pc[i].isNullOrBlank() || !btn1Mo[i].isNullOrBlank()
                        if (b1Any && (btn1Nm[i].isNullOrBlank() || btn1Pc[i].isNullOrBlank() || btn1Mo[i].isNullOrBlank())) {
                            re.status = false; re.errMsg = "카드${i + 1} 버튼1은 버튼명/PC 링크/Mobile 링크가 모두 필요합니다."; return re
                        }

                        val b2Any = !btn2Nm[i].isNullOrBlank() || !btn2Pc[i].isNullOrBlank() || !btn2Mo[i].isNullOrBlank()
                        if (b2Any) {
                            if (!b1Any) {
                                re.status = false; re.errMsg = "카드${i + 1}에서 버튼2가 입력되었는데 버튼1이 비어있습니다. 버튼1부터 입력해주세요."; return re
                            }
                            if (btn2Nm[i].isNullOrBlank() || btn2Pc[i].isNullOrBlank() || btn2Mo[i].isNullOrBlank()) {
                                re.status = false; re.errMsg = "카드${i + 1} 버튼2는 버튼명/PC 링크/Mobile 링크가 모두 필요합니다."; return re
                            }
                        }
                    }

                    val carouselLst = ArrayList<CarouselDto>()
                    for (i in 0 until maxFilled) {
                        val b2Any = !btn2Nm[i].isNullOrBlank() || !btn2Pc[i].isNullOrBlank() || !btn2Mo[i].isNullOrBlank()

                        val buttonLst: List<ButtonJsonDto> = if(b2Any) {
                            listOf(ButtonJsonDto(btn1Nm[i].toString(), "WL",  btn1Mo[i].toString(), btn1Pc[i].toString()), ButtonJsonDto(btn2Nm[i].toString(), "WL",  btn2Mo[i].toString(), btn2Pc[i].toString()))
                        }else{
                            listOf(ButtonJsonDto(btn1Nm[i].toString(), "WL",  btn1Mo[i].toString(), btn1Pc[i].toString()))
                        }
                        val imgDto = contentDao.selTblmiContImg(Tblmi_cont_imgDto(img[i]!!.toInt()))
                        val dd = CarouselDto().apply {
                            this.header = header[i]
                            this.message = body[i]
                            this.attachment = AttachmentDto(buttonLst, ImageDto(imgDto?.kko_img_url, null), null)
                        }
                        carouselLst.add(dd)
                    }
                    listDto.kko_carousel_json = gson.toJson(carouselLst)
                }
                "4" -> listDto.msg_tp = "DMCH223"
                else -> {
                    if (CommonUtils.isEmptyObject(dto.kko_img_cd)) listDto.msg_tp = "DMCH204"
                    else {
                        val imgDto = contentDao.selTblmiContImg(Tblmi_cont_imgDto(dto.kko_img_cd!!))
                        listDto.msg_tp = if (imgDto?.ch_tp == "IMGTP11") "DMCH218" else "DMCH217"
                    }
                }
            }
            listDto.apply {
                kko_img_cd = dto.kko_img_cd
                cont_body = dto.kakao_body
                kko_img_url = dto.kko_img_url
                kko_btn_nm = dto.kko_btn_nm
                kko_btn_url = dto.kko_btn_url
                kko_btn_urlPc = dto.kko_btn_urlPc
                kko_btn_nm2 = dto.kko_btn_nm2
                kko_btn_url2 = dto.kko_btn_url2
                kko_btn_urlPc2 = dto.kko_btn_urlPc2
                kko_btn_nm3 = dto.kko_btn_nm3
                kko_btn_url3 = dto.kko_btn_url3
                kko_btn_urlPc3 = dto.kko_btn_urlPc3
                kko_btn_nm4 = dto.kko_btn_nm4
                kko_btn_url4 = dto.kko_btn_url4
                kko_btn_urlPc4 = dto.kko_btn_urlPc4
                kko_btn_nm5 = dto.kko_btn_nm5
                kko_btn_url5 = dto.kko_btn_url5
                kko_btn_urlPc5 = dto.kko_btn_urlPc5
                kko_video_url = dto.kko_video_url
                kko_thumbnail_img_cd = dto.kko_thumbnail_img_cd
            }
            
            // 브랜드톡 등록
            if(!CommonUtils.isEmptyObject(dto.kko_tar_tp) && dto.kko_tar_tp != "-"){
                val reg = convertBrandTalk(dto.cont_nm.toString(), listDto.key_id.toString(), listDto)
                if(!reg.status!!){
                    return reg
                }else{
                    listDto.kko_tar_tp = dto.kko_tar_tp
                    listDto.kko_tmpl_cd = reg.data
                }
            }
        }
        return null
    }

    private fun validateKakaoList(dto: Content_list_CreateDto, re: ReturnDto): Boolean {
        val requiredMap = linkedMapOf(
            "리스트 1 항목명" to dto.kkoItemLst1,
            "리스트 2 항목명" to dto.kkoItemLst2,
            "리스트 3 항목명" to dto.kkoItemLst3,
            "리스트 1 이미지" to dto.kakao_item_img_cd_1,
            "리스트 2 이미지" to dto.kakao_item_img_cd_2,
            "리스트 3 이미지" to dto.kakao_item_img_cd_3,
            "리스트 1 PC URL" to dto.kkoItemUrlLstPc1,
            "리스트 2 PC URL" to dto.kkoItemUrlLstPc2,
            "리스트 3 PC URL" to dto.kkoItemUrlLstPc3,
            "리스트 1 모바일 URL" to dto.kkoItemUrlLstMo1,
            "리스트 2 모바일 URL" to dto.kkoItemUrlLstMo2,
            "리스트 3 모바일 URL" to dto.kkoItemUrlLstMo3
        )
        for ((label, value) in requiredMap) {
            if (CommonUtils.isEmptyObject(value)) {
                re.status = false; re.errMsg = "$label 이(가) 누락되었습니다."; return false
            }
        }
        val group4 = listOf(dto.kkoItemLst4, dto.kakao_item_img_cd_4, dto.kkoItemUrlLstPc4, dto.kkoItemUrlLstMo4)
        if (group4.any { !CommonUtils.isEmptyObject(it) } && !group4.all { !CommonUtils.isEmptyObject(it) }) {
            re.status = false; re.errMsg = "리스트 4번 항목은 하나라도 입력 시 모든 값이 필수 입니다."; return false
        }
        return true
    }

    private fun createKakaoItemJson(dto: Content_list_CreateDto): String {
        val hasAllGroup4 = listOf(dto.kkoItemLst4, dto.kakao_item_img_cd_4, dto.kkoItemUrlLstPc4, dto.kkoItemUrlLstMo4).all { !CommonUtils.isEmptyObject(it) }
        val itemLst = arrayListOf(
            ItemInfoDto(dto.kkoItemLst1!!, dto.kko_view_item_img_url_1!!, dto.kkoItemUrlLstMo1!!, dto.kkoItemUrlLstPc1!!),
            ItemInfoDto(dto.kkoItemLst2!!, dto.kko_view_item_img_url_2!!, dto.kkoItemUrlLstMo2!!, dto.kkoItemUrlLstPc2!!),
            ItemInfoDto(dto.kkoItemLst3!!, dto.kko_view_item_img_url_3!!, dto.kkoItemUrlLstMo3!!, dto.kkoItemUrlLstPc3!!)
        ).apply {
            if (hasAllGroup4) add(
                ItemInfoDto(dto.kkoItemLst4!!, dto.kko_view_item_img_url_4!!, dto.kkoItemUrlLstMo4!!, dto.kkoItemUrlLstPc4!!)
            )
        }
        return gson.toJson(itemLst)
    }

    private fun processSms(dto: Content_list_CreateDto, listDto: Tblmi_cont_lstDto) {
        listDto.use_yn = if (dto.formatType!!.contains("sms")) "Y" else "N"
        listDto.cont_tp = "DMTP02"
        listDto.send_tp = if (dto.sms_option == "ad") "SENDTP01" else "SENDTP02"
        listDto.msg_tp = when (dto.sms_msg_tp) {
            "LMS" -> "DMCH202"
            "MMS" -> {
                listDto.img_cd_1 = dto.mds_img_cd
                "DMCH203"
            }
            else -> "DMCH201"
        }
        if (!dto.coupon_seq.isNullOrEmpty()) {
            listDto.coupon_seq = AES256.AES_Decode(dto.coupon_seq, GlobalValues.encKey)
        }
        listDto.short_url_yn = dto.short_url_yn
        listDto.cont_body = dto.sms_body
    }

    private fun processRcs(dto: Content_list_CreateDto, listDto: Tblmi_cont_lstDto, userInfo: Tblmi_usrDto, i: Int) {
        listDto.use_yn = if (dto.formatType!!.contains("rcs")) "Y" else "N"
        listDto.cont_tp = "DMTP04"
        listDto.rcs_footer = dto.rcs_footer
        listDto.send_tp = if (dto.rcs_option == "ad") "SENDTP01" else "SENDTP02"

        listDto.img_cd_1 = dto.rcs_img_cd_1
        listDto.img_cd_2 = dto.rcs_img_cd_2
        listDto.img_cd_3 = dto.rcs_img_cd_3
        listDto.img_cd_4 = dto.rcs_img_cd_4
        listDto.img_cd_5 = dto.rcs_img_cd_5
        listDto.img_cd_6 = dto.rcs_img_cd_6

        val rcsFormatType = dto.rcs_format_type!!.trim()
        val rcsMsgType = dto.rcs_msg_tp!!.trim()

        when (rcsFormatType) {
            "text" -> {
                listDto.msg_tp = if (rcsMsgType == "sms") "DMCH205" else "DMCH206"
                val grpId = if (rcsMsgType == "sms") "RCS_SMS_MSG_ID" else "RCS_LMS_MSG_ID"
                systemDao.getCommCdKeyValueNull(Tblmi_comm_cdDto(grpId, userInfo.usr_grp_cd!!))?.let { listDto.key_id = it.cd_val }
                listDto.cont_body = dto.rcs_body
            }
            "vertical" -> {
                listDto.msg_tp = if (rcsMsgType == "tall") "DMCH207" else "DMCH208"
                val grpId = if (rcsMsgType == "tall") "RCS_L_TALL_MSG_ID" else "RCS_L_MD_MSG_ID"
                systemDao.getCommCdKeyValueNull(Tblmi_comm_cdDto(grpId, userInfo.usr_grp_cd!!))?.let { listDto.key_id = it.cd_val }

                listDto.cont_body = JSONObject().apply {
                    put("title", dto.cont_sub_list?.get(i))
                    put("description", dto.rcs_body)
                }.toString()
                listDto.img_cd_1 = dto.verticalImg
            }
            "slide" -> {
                listDto.msg_tp = if (rcsMsgType == "small") "DMCH211" else "DMCH212"
                rcsSlideSetting(dto, listDto)
            }
        }
        if (rcsFormatType == "slide") rcsButtonMakeJsonStringSlide(dto, listDto)
        else rcsButtonMakeJsonString(dto, listDto)
    }

    private fun saveUrls(i: Int, dto: Content_list_CreateDto, listSeq: Int) {
        when (i) {
            0 -> {
                if (!dto.kko_img_url.isNullOrEmpty()) insertContentUrl("img", dto.kko_img_url!!, "kkoImg001", listSeq)
                val btnPairs = listOf(
                    dto.kko_btn_url to dto.kko_btn_urlPc,
                    dto.kko_btn_url2 to dto.kko_btn_urlPc2,
                    dto.kko_btn_url3 to dto.kko_btn_urlPc3,
                    dto.kko_btn_url4 to dto.kko_btn_urlPc4,
                    dto.kko_btn_url5 to dto.kko_btn_urlPc5
                )
                btnPairs.forEachIndexed { idx, pair ->
                    if (!pair.first.isNullOrEmpty()) {
                        insertContentUrl("btn", pair.first!!, "kkoBtn00${idx + 1}", listSeq)
                        insertContentUrl("btn", pair.second!!, "kkoBtnPc00${idx + 1}", listSeq)
                    }
                }
                parseAndInsertBodyUrls(dto.kakao_body, "kkoTrk", listSeq)
            }

            1 -> {
                if (!dto.mms_imgurl.isNullOrEmpty()) insertContentUrl("a", dto.mms_imgurl!!, "mmsImg001", listSeq)
                parseAndInsertBodyUrls(dto.sms_body, "smsTrk", listSeq)
            }

            2 -> {
                dto.url_value?.forEachIndexed { j, url ->
                    if (!url.isNullOrEmpty()) insertContentUrl("btn", url, "urlBtn${j + 1}", listSeq)
                    dto.fallback_url_04?.getOrNull(j)?.let { if (it.isNotEmpty()) insertContentUrl("btn", it, "fallPosiBtn${j + 1}", listSeq) }
                    dto.fallback_url_05?.getOrNull(j)?.let { if (it.isNotEmpty()) insertContentUrl("btn", it, "fallQueryBtn${j + 1}", listSeq) }
                }
            }
        }
    }
    private fun parseAndInsertBodyUrls(body: String?, prefix: String, listSeq: Int) {
        if (body?.contains("{{") != true) return
        val matcher = Pattern.compile("\\{\\{[^{]+}}").matcher(body)
        var idx = 0
        while (matcher.find()) {
            val url = matcher.group().replace("{{", "").replace("}}", "")
            if (url.contains("http")) {
                idx++
                val urlId = if (idx >= 10) "${prefix}0$idx" else "${prefix}00$idx"
                contentDao.insertContentUrl(Tblmi_cont_url_lstDto().apply {
                    url_tag = "a"; this.url = url; this.url_id = urlId; cont_lst_cd = listSeq
                })
            }
        }
    }

    private fun handleManualRollback(mstSeq: Int, e: Exception) {
        logger.error("insert content error. MstSeq: $mstSeq", e)
        val lstSeqList = contentDao.selectLstSeq(Tblmi_cont_lstDto().apply { cont_cd = mstSeq })
        lstSeqList.forEach { contentDao.deleteRealContUrl(Tblmi_cont_url_lstDto(it.seq)) }
        contentDao.deleteRealContMst(Tblmi_cont_mstDto(mstSeq))
        contentDao.deleteRealContLst(Tblmi_cont_lstDto().apply { cont_cd = mstSeq })
    }

    private fun convertBrandTalk(contNm: String, sendKey: String, listDto: Tblmi_cont_lstDto): ReturnDto {
        val kkoBrandDto = KkoBrandTemplateDto()
        kkoBrandDto.templateName = contNm
        when (listDto.msg_tp) {
           "DMCH220" -> {
               kkoBrandDto.upgradeTp = "U_FL"
           }
           "DMCH221" -> {
               kkoBrandDto.upgradeTp = "U_FA"
           }
           "DMCH222" -> {
               kkoBrandDto.upgradeTp = "U_FC"
           }
           "DMCH223" -> {
               kkoBrandDto.upgradeTp = "U_FP"
           }
           else -> {
               // 이전 버전 호환용
               if(listDto.kko_img_cd != null){
                   val imgDto = Tblmi_cont_imgDto(listDto.kko_img_cd!!)
                   val imgInfo = contentDao.selTblmiContImg(imgDto)
                   if(imgInfo == null){
                       return ReturnDto().apply {
                           status = false
                           errMsg = "이미지 로드 정보 조회 오류"
                       }
                   }else{
                       if(imgInfo.ch_tp == "IMGTP11") {  // 와이드 이미지
                           kkoBrandDto.upgradeTp = "U_FW"
                       } else {
                           kkoBrandDto.upgradeTp = "U_FI"
                       }
                       kkoBrandDto.imageUrl = imgInfo.kko_img_url
                   }
               }else{
                   kkoBrandDto.upgradeTp  = "U_FT"
               }
           }
        }
        kkoBrandDto.content = listDto.cont_body?.replace(Regex("\\{\\{\\s*(.*?)\\s*\\}\\}"), "#{$1}")
        kkoBrandDto.header = listDto.kko_header
        if(!listDto.kko_item_json.isNullOrEmpty()) {
            val itemLst = gson.fromJson<MutableList<WideItemDto>>(listDto.kko_item_json, object : TypeToken<MutableList<WideItemDto>>() {}.type)
            val subWideItemList = ArrayList<WideItemDto>()
            for((index, item) in itemLst.withIndex()){
                if(index == 0){
                    kkoBrandDto.mainWideItem = item
                }else{
                    subWideItemList.add(item)
                }
            }
            kkoBrandDto.subWideItemList = subWideItemList
        }
        
        val listBtn = ArrayList<FtButtonDto>()
        if(!CommonUtils.isEmptyObject(listDto.kko_btn_nm)) {
            val dd = FtButtonDto().apply {
                name = listDto.kko_btn_nm
                linkType = "WL"
                linkMobile = "https://#{btnUrl1}"
                linkPc = "https://#{btnUrl1}"
            }
            listBtn.add(dd)
        }
        if(!CommonUtils.isEmptyObject(listDto.kko_btn_nm2)) {
            val dd = FtButtonDto().apply {
                name = listDto.kko_btn_nm2
                linkType = "WL"
                linkMobile = "https://#{btnUrl2}"
                linkPc = "https://#{btnUrl2}"
            }
            listBtn.add(dd)
        }
        if(!CommonUtils.isEmptyObject(listDto.kko_btn_nm3)) {
            val dd = FtButtonDto().apply {
                name = listDto.kko_btn_nm3
                linkType = "WL"
                linkMobile = "https://#{btnUrl3}"
                linkPc = "https://#{btnUrl3}"
            }
            listBtn.add(dd)
        }
        if(!CommonUtils.isEmptyObject(listDto.kko_btn_nm4)) {
            val dd = FtButtonDto().apply {
                name = listDto.kko_btn_nm4
                linkType = "WL"
                linkMobile = "https://#{btnUrl4}"
                linkPc = "https://#{btnUrl4}"
            }
            listBtn.add(dd)
        }
        if(!CommonUtils.isEmptyObject(listDto.kko_btn_nm5)) {
            val dd = FtButtonDto().apply {
                name = listDto.kko_btn_nm5
                linkType = "WL"
                linkMobile = "https://#{btnUrl5}"
                linkPc = "https://#{btnUrl5}"
            }
            listBtn.add(dd)
        }
        if(listBtn.isNotEmpty()){
            kkoBrandDto.buttons = listBtn
        }
        
        val createBrand = if(listDto.kko_tmpl_cd.isNullOrEmpty()){
            kkoRestApiServiceImpl.createBrand(sendKey, kkoBrandDto)
        }else{
            kkoBrandDto.templateCode = listDto.kko_tmpl_cd
            kkoRestApiServiceImpl.updateBrand(sendKey, kkoBrandDto)
        }
        
        if(createBrand.result){
            val re = ReturnDto(true)
            re.data = createBrand.data!!.templateCode
            return re
        }else{
            val re = ReturnDto(false)
            re.errMsg = createBrand.msg
            return re
        }
    }
    
}