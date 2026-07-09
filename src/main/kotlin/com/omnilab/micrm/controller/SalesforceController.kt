package com.omnilab.micrm.controller

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.google.gson.GsonBuilder
import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.FileUploadUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.*
import com.omnilab.micrm.model.coupon.SearchCouponDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.repository.SalesforceDao
import com.omnilab.micrm.repository.SysSettingDao
import com.omnilab.micrm.service.*
import io.jsonwebtoken.SignatureAlgorithm
import io.jsonwebtoken.impl.crypto.DefaultJwtSignatureValidator
import org.json.simple.JSONObject
import org.json.simple.parser.JSONParser
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.beans.factory.annotation.Value
import org.springframework.core.io.ClassPathResource
import org.springframework.core.io.Resource
import org.springframework.dao.DuplicateKeyException
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.web.bind.WebDataBinder
import org.springframework.web.bind.annotation.*
import org.springframework.web.multipart.MultipartFile
import org.springframework.web.servlet.ModelAndView
import java.beans.PropertyEditorSupport
import java.io.InputStreamReader
import java.sql.SQLIntegrityConstraintViolationException
import java.time.LocalDateTime
import java.time.LocalTime
import java.time.format.DateTimeFormatter
import java.util.*
import javax.crypto.spec.SecretKeySpec
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import javax.servlet.http.HttpSession
import kotlin.collections.HashMap


@Controller
@RequestMapping("/sf")
class SalesforceController {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    lateinit var salesforceService: SalesforceService;

    @Autowired(required = true)
    @Qualifier("MobileContentServiceImpl")
    private lateinit var mobileContentService: ContentService

    @Autowired
    @Qualifier("SysSettingServiceImpl")
    lateinit var sysSettingService: SysSettingService

    @Autowired(required = true)
    @Qualifier("ImageServiceImpl")
    private lateinit var imageService: ImageService

    @Autowired
    lateinit var fileUpload: FileUploadUtils;

    @Autowired
    @Qualifier("SalesforceDaoImpl")
    lateinit var salesforceDao : SalesforceDao

    @Autowired
    @Qualifier("SysSettingDaoImpl")
    lateinit var sysSettingDao : SysSettingDao

    @Autowired
    @Qualifier("KkoRestApiServiceImpl")
    lateinit var kkoRestApiService: KkoRestApiService

    @Autowired
    @Qualifier("KkoMsgServiceImpl")
    private lateinit var kkoMsgService: KkoMsgService

    @Autowired
    private lateinit var couponListService: CouponListService

    @Autowired
    @Qualifier("CouponIssueServiceImpl")
    private lateinit var couponIssueService: CouponIssueService
    
    @Value("\${upload.content}")
    private val filePath: String? = null

    fun getUsrGrpCd(usrGrpCd: String): Tblmi_comm_cdDto?{
        val dto = Tblmi_comm_cdDto("USR_GRP_CD", usrGrpCd)
        dto.use_yn = "Y"
        return sysSettingDao.getCommCD(dto)
    }

    @ResponseBody
    @GetMapping("/{usr_cd}/config.json")
    fun configJson(@PathVariable(value = "usr_cd") usrCd: String): JSONObject {
        if(getUsrGrpCd(usrCd) != null){
            val resource: Resource = ClassPathResource("static/sf/config.json")
            val json: JSONObject = JSONParser().parse(InputStreamReader(resource.inputStream, "UTF-8")) as JSONObject
            val arguments: JSONObject = json["arguments"] as JSONObject
            val execute: JSONObject = arguments["execute"] as JSONObject
            execute.replace("url", execute["url"].toString().replace("/sf", "/sf/$usrCd"))

            val configurationArguments: JSONObject = json["configurationArguments"] as JSONObject
            val keys = configurationArguments.keys
            for(i in keys){
                val temp = configurationArguments[i] as JSONObject
                temp.replace("url", temp["url"].toString().replace("/sf", "/sf/$usrCd"))
            }

            if(usrCd == "22"){
                val configurationArguments: JSONObject = json["lang"] as JSONObject
                val keys = configurationArguments.keys
                for(i in keys){
                    val temp = configurationArguments[i] as JSONObject
                    temp.replace("name", temp["name"].toString().replace("SMS/KAKAO", "micrmApi"))
                }
            }
            return json
        }else{
            return JSONObject()
        }
    }

    /**
     * @Method Name  : salesIndex.html
     * @Since    : 2022. 08. 03.
     * @author   : SSW
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 세일즈포스 뷰 페이지 조회
     * @title : 세일즈포스 뷰 페이지
     */
    @GetMapping("/{usr_cd}/index.mi")
    fun mdmCreate(@PathVariable(value = "usr_cd") usrCd: String): ModelAndView {
        if(getUsrGrpCd(usrCd) != null){
            val view =  ModelAndView("cont/salesforce")
            view.addObject("usr_cd", usrCd)

            val searchDto = SetLst_searchDto()
            searchDto.usr_grp_cd = usrCd
            searchDto.list_tp_id = "CH05"
            searchDto.list_dt_id = "TEAM01"
            searchDto.use_yn = "Y"
            view.addObject("teamLst", sysSettingDao.getMappingSettingListSort(searchDto))

            val temp = SetLst_searchDto("CH03", "SPTP01", "Y", usrCd)
            temp.list_nm = "USR_KEY"
            view.addObject("usrKeyLst", sysSettingDao.getMappingSettingList(temp))

            temp.list_nm = "from_to"
            view.addObject("fromToLst", sysSettingDao.getMappingSettingList(temp))

            //임시 주석
            val cntMap = salesforceService.isCheckSender(usrCd)
            view.addObject("kakaoCnt", cntMap["kakaoCnt"])
            view.addObject("smsCnt", cntMap["smsCnt"])
            view.addObject("rcsCnt", cntMap["rcsCnt"])
            return view
        }else{
            return ModelAndView("redirect:/html/not.html")
        }
    }

    // =================================================== Mobile ========================================================= //

    /**
     * @Method Name  : insertMoblieContent
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : content_list_dto: Content_list_CreateDto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 모바일 컨텐츠 생성하기
     * @title : 모바일 컨텐츠 생성하기
     */
    @ResponseBody
    @PostMapping("/{usr_cd}/mobileInsert.service")
    fun insertMoblieContent(@ModelAttribute contentListDto: Content_list_CreateDto, @PathVariable(value = "usr_cd") usrCd: String, session: HttpSession): ReturnDto {
        return if(getUsrGrpCd(usrCd) != null && usrCd == UsefulUtils.sessionUser().usr_grp_cd){
            contentListDto.cont_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
            if(!CommonUtils.isEmptyObject(session.getAttribute("MID"))){
                contentListDto.bu_id = CommonUtils.nullToBlankStr(session.getAttribute("MID"))
            }
            salesforceService.insertContentList(contentListDto)
        }else{
            ReturnDto(false)
        }
    }

    /**
     * @Method Name  : updateMoblieContent
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : content_list_dto: Content_list_CreateDto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 모바일 컨텐츠 수정하기
     * @title : 모바일 컨텐츠 수정하기
     */
    @ResponseBody
    @PostMapping("/{usr_cd}/mobileUpdate.service")
    fun updateMoblieContent(@ModelAttribute contentListDto: Content_list_CreateDto, @PathVariable(value = "usr_cd") usrCd: String, session: HttpSession): ReturnDto {
        return if(getUsrGrpCd(usrCd) != null && usrCd == UsefulUtils.sessionUser().usr_grp_cd){
            contentListDto.cont_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
            if(!CommonUtils.isEmptyObject(session.getAttribute("MID"))){
                contentListDto.bu_id = CommonUtils.nullToBlankStr(session.getAttribute("MID"))
            }
            salesforceService.updateContentList(contentListDto)
        }else{
            ReturnDto(false)
        }
    }

    @PostMapping("/{usr_cd}/mobileInfo.ajax")
    fun selectMobileContent(@RequestParam(value = "seq", required = true) seq: Int, @PathVariable(value = "usr_cd") usrCd: String): ModelAndView {
        if(getUsrGrpCd(usrCd) != null){
            val tblmiContMstdto = Tblmi_cont_mstDto()
            tblmiContMstdto.seq = seq
            tblmiContMstdto.cont_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
            tblmiContMstdto.reg_dt = UsefulUtils.sessionUser().usr_grp_cd
            val view = ModelAndView("/cont/salesforceDetail")
            val listMap = mobileContentService.selectOneContentView(tblmiContMstdto)
            val cntMap = salesforceService.isCheckSender(usrCd)

            val list = listMap["list"] as MutableList<Content_view_Dto>
            if(list.isNotEmpty()){
                val rejDto = SetLst_searchDto()
                rejDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
                rejDto.list_tp_id = "CH04"
                rejDto.list_dt_id = "REJT01"
                rejDto.def_yn = "Y"
                val smsRejectTextMap = mobileContentService.selectRejectTextList(rejDto)

                view.addObject("rejectText",smsRejectTextMap["list"])
                view.addObject("kakaoCnt", cntMap["kakaoCnt"])
                view.addObject("smsCnt", cntMap["smsCnt"])
                view.addObject("rcsCnt", cntMap["rcsCnt"])

                val commonCDDto = Tblmi_comm_cdDto()
                commonCDDto.grp_id = "COMMON"
                commonCDDto.cd_id = "UPURL01"
                val uploadPrefix = sysSettingService.getCommCD(commonCDDto)
                view.addObject("filePath", uploadPrefix?.cd_val)

                val searchDto = SetLst_searchDto()
                searchDto.usr_grp_cd = usrCd
                searchDto.list_tp_id = "CH05"
                searchDto.list_dt_id = "TEAM01"
                searchDto.use_yn = "Y"
                view.addObject("teamLst", sysSettingDao.getMappingSettingListSort(searchDto))

                val temp = SetLst_searchDto("CH03", "SPTP01", "Y", usrCd)
                temp.list_nm = "USR_KEY"
                view.addObject("usrKeyLst", sysSettingDao.getMappingSettingList(temp))

                temp.list_nm = "from_to"
                view.addObject("fromToLst", sysSettingDao.getMappingSettingList(temp))
            }
            view.addObject("list" , listMap["list"])
            view.addObject("kakaoCnt", cntMap["kakaoCnt"])
            view.addObject("smsCnt", cntMap["smsCnt"])
            view.addObject("rcsCnt", cntMap["rcsCnt"])
            return view
        }else{
            return ModelAndView("redirect:/html/not.html")
        }
    }

    @InitBinder
    fun initBinder(binder: WebDataBinder) {
        binder.registerCustomEditor(
            MutableList::class.java,
            "kkoBtnLst",
            object : PropertyEditorSupport() {
                override fun setValue(value: Any?) {
                    when (value) {
                        null -> super.setValue(null)
                        // 반복 파라미터로 들어온 경우: ["낙원,의밤", "낙원,의밤2"]
                        is Array<*> -> super.setValue(
                            value.filterIsInstance<String>().toMutableList()
                        )
                        // 단일 값으로 들어온 경우: "낙원,의밤" -> split 금지, 그대로 1개
                        is String -> super.setValue(mutableListOf(value))
                        else -> super.setValue(value)
                    }
                }
                override fun setAsText(text: String?) {
                    super.setValue(if (text.isNullOrBlank()) null else mutableListOf(text))
                }
            }
        )
    }

    /** @Method Name  : previewService
     * @Since    : 2021. 05. 31.
     * @author   : Grayson
     * @param    : dto : ContentListCreateDto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : RCS 프리뷰 페이지
     * RCS의 Json 데이터는 Model 값으로 jsonContent 값을 뿌려준다
     * (Content_list_CreateDto로 넘어온 값 재 파싱 후 Contents_lstDto 값 )
     * 그 외의 데이터는 Model 값으로 "content" 값을 뿌려 준다
     * (Content_list_CreateDto 로 넘어온 값 )
     *
     * @title : RCS 프리뷰 페이지
     */

    @PostMapping("/{usr_cd}/preview.ajax")
    fun previewService(@ModelAttribute dto : Content_list_CreateDto, @PathVariable(value = "usr_cd") usrCd: String, req: HttpServletRequest) : ModelAndView {
        if(getUsrGrpCd(usrCd) != null){
            val view = ModelAndView("cont/mobile/ajax/mdmPreview")
            val formatList = dto.formatType
            if(formatList!!.contains("rcs")) {
                // 넘어 오는 Preview 데이터에 RCS가 있으면 파싱후 뿌려 준다 -> RCS Json Parsing
                val map = mobileContentService.previewJsonService(dto)
                view.addObject("jsonContent", map["jsonContent"])
            }
            view.addObject("content", dto)
            val commonCDDto = Tblmi_comm_cdDto("COMMON", "UPURL01")
            val uploadPrefix = sysSettingService.getCommCD(commonCDDto)
            view.addObject("filePath", uploadPrefix?.cd_val)
            return view
        }else{
            return ModelAndView("redirect:/html/not.html")
        }
    }

    /**
     * @Method Name  : isCheckTemplateName
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : contMstdto: Tblmi_cont_mstDto
     * @return   : HashMap<String,String>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 모바일 컨텐츠 이름 중복 체크하기
     * @title : 모바일 컨텐츠 이름 중복 체크 하기
     */
    @ResponseBody
    @PostMapping("/{usr_cd}/isCheckTmplateNm.ajax")
    fun isCheckTemplateName(@ModelAttribute contMstdto: Tblmi_cont_mstDto, @PathVariable(value = "usr_cd") usrCd: String) : HashMap<String,String>{
        if(getUsrGrpCd(usrCd) != null){
            val result = salesforceService.checkContNm(contMstdto)
            val statusMap = HashMap<String,String>()
            if(result == 0) {
                statusMap["status"] = "true"
                statusMap["message"] = "모바일 컨텐츠 저장이 완료 되었습니다"
            } else {
                statusMap["status"] = "false"
                statusMap["message"] = "중복된 컨텐츠 이름이 존재합니다"
            }
            return statusMap
        }else{
            return HashMap()
        }
    }

    /**
     * @Method Name  : selectSenderMobileList
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : tblmiSetLstdto: Tblmi_set_lstDto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 모바일 발신자 리스트 가져오기
     * @title : 모바일 발신자 리스트 가져오기
     */
    @PostMapping("/{usr_cd}/senderMobileList.ajax")
    fun selectSenderMobileList(@ModelAttribute dto : SetLst_searchDto, @PathVariable(value = "usr_cd") usrCd: String): ModelAndView {
        return if(getUsrGrpCd(usrCd) != null){
            dto.usr_grp_cd = usrCd
            val view = ModelAndView("cont/mobile/ajax/senderMobileListAjax")
            val senderMap = salesforceService.selectSenderList(dto)
            view.addObject("list", senderMap["list"])
            view.addObject("page", senderMap["page"])
            view.addObject("pageNo", senderMap["pageNo"])
            view.addObject("listCnt", senderMap["listCnt"])
            view
        }else{
            ModelAndView("redirect:/html/not.html")
        }
    }

    /**
     * @Method Name  : mobileRejectTextList
     * @Since    : 2023. 01. 05.
     * @author   : Grayson
     * @param    : tblmiSetLstdto: Tblmi_set_lstDto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 모바일 수신거부 문자 리스트 가져오기
     * @title : 모바일 수신거부 문자 리스트 가져오기
     */
    @PostMapping("/{usr_cd}/mobileRejectTextList.ajax")
    fun mobileRejectTextList(@PathVariable(value = "usr_cd") usrCd: String, @ModelAttribute dto : SetLst_searchDto): ModelAndView {
        if(getUsrGrpCd(usrCd) != null){
            dto.usr_grp_cd = usrCd
            val view = ModelAndView("cont/mobile/ajax/mobileRejectTextListAjax")
            val senderMap = salesforceService.selectRejectTextList(dto)
            view.addObject("list", senderMap["list"])
            view.addObject("page", senderMap["page"])
            view.addObject("pageNo", senderMap["pageNo"])
            view.addObject("listCnt", senderMap["listCnt"])
            return view
        }else{
            return ModelAndView("redirect:/html/not.html")
        }
    }

    /**
     * @Method Name  : selectSenderList
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : tblmiSetLstDto: : SetLst_searchDto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이미지 팝업 리스트 가져오기
     * @title : 이미지 팝업 리스트 가져오기
     */
    @PostMapping("/{usr_cd}/mobileImgList.ajax")
    fun selectImgListForPopUp(@ModelAttribute tblmiContImgdto: Image_searchDto, @PathVariable(value = "usr_cd") usrCd: String): ModelAndView {
        if(getUsrGrpCd(usrCd) != null){
            val view = ModelAndView("cont/mobile/ajax/mdmImgListAjax")
            val senderMap = salesforceService.selectImgForPopup(tblmiContImgdto)
            view.addObject("list", senderMap["list"])
            view.addObject("page", senderMap["page"])
            view.addObject("pageNo", senderMap["pageNo"])
            view.addObject("listCnt", senderMap["listCnt"])
            val commonCDDto = Tblmi_comm_cdDto()
            commonCDDto.grp_id = "COMMON"
            commonCDDto.cd_id = "UPURL01"
            val uploadPrefix = sysSettingService.getCommCD(commonCDDto)
            view.addObject("filePath", uploadPrefix?.cd_val)
            return view
        }else{
            return ModelAndView("redirect:/html/not.html")
        }
    }

    /**
     * @Method Name  : rcsText
     * @Since    : 2021. 05. 11.
     * @author   : Dana
     * @param    : req: HttpServletRequest
     * @param    : rep : HttpServletResponse
     * @param    : session : HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : RCS 텍스트형 페이지
     * @title : RCS 텍스트형 페이지
     */
    @GetMapping("/{usr_cd}/rcsText.ajax")
    fun rcsText(@PathVariable(value = "usr_cd") usrCd: String, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        return if(getUsrGrpCd(usrCd) != null){
            val view = ModelAndView("cont/mobile/ajax/rcsText")
            view
        }else{
            ModelAndView("redirect:/html/not.html")
        }
    }

    /** @Method Name  : rcsVertical
     * @Since    : 2021. 05. 11.
     * @author   : Dana
     * @param    : req: HttpServletRequest
     * @param    : rep : HttpServletResponse
     * @param    : session : HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : RCS 세로형 페이지
     * @title : RCS 세로형 페이지
     */
    @GetMapping("/{usr_cd}/rcsVertical.ajax")
    fun rcsVertical(@PathVariable(value = "usr_cd") usrCd: String, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        return if(getUsrGrpCd(usrCd) != null){
            val view = ModelAndView("cont/mobile/ajax/rcsVertical")
            view
        }else{
            ModelAndView("redirect:/html/not.html")
        }
    }

    /** @Method Name  : rcsSlide
     * @Since    : 2021. 05. 11.
     * @author   : Dana
     * @param    : req: HttpServletRequest
     * @param    : rep : HttpServletResponse
     * @param    : session : HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : RCS 슬라이드형 페이지
     * @title : RCS 슬라이드형 페이지
     */
    @GetMapping("/{usr_cd}/rcsSlide.ajax")
    fun rcsSlide(@PathVariable(value = "usr_cd") usrCd: String, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        return if(getUsrGrpCd(usrCd) != null){
            val view = ModelAndView("cont/mobile/ajax/rcsSlide")
            view
        }else{
            ModelAndView("redirect:/html/not.html")
        }
    }

    /** @Method Name  : brandNormal
     * @Since    : 2026. 01. 07.
     * @author   : lucas
     * @param    : req: HttpServletRequest
     * @param    : rep : HttpServletResponse
     * @param    : session : HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 브랜드톡 일반 페이지
     * @title : 브랜드톡 일반 페이지
     */
    @GetMapping("/{usr_cd}/brandNormal.ajax")
    fun brandNormal(@PathVariable(value = "usr_cd") usrCd: String, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        return if(getUsrGrpCd(usrCd) != null){
            val view = ModelAndView("cont/kko/ajax/brandNormal")
            view
        }else{
            ModelAndView("redirect:/html/not.html")
        }
    }

    /** @Method Name  : brandNormal
     * @Since    : 2026. 01. 07.
     * @author   : lucas
     * @param    : req: HttpServletRequest
     * @param    : rep : HttpServletResponse
     * @param    : session : HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 브랜드톡 일반 페이지
     * @title : 브랜드톡 일반 페이지
     */
    @GetMapping("/{usr_cd}/brandVideo.ajax")
    fun brandVideo(@PathVariable(value = "usr_cd") usrCd: String, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        return if(getUsrGrpCd(usrCd) != null){
            val view = ModelAndView("cont/kko/ajax/brandVideo")
            view
        }else{
            rep.status = 401
            ModelAndView("redirect:/html/not.html")
        }
    }

    /** @Method Name  : brandNormal
     * @Since    : 2026. 01. 07.
     * @author   : lucas
     * @param    : req: HttpServletRequest
     * @param    : rep : HttpServletResponse
     * @param    : session : HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 브랜드톡 일반 페이지
     * @title : 브랜드톡 일반 페이지
     */
    @GetMapping("/{usr_cd}/brandWideLst.ajax")
    fun brandWide(@PathVariable(value = "usr_cd") usrCd: String, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        return if(getUsrGrpCd(usrCd) != null){
            val view = ModelAndView("cont/kko/ajax/brandWideLst")
            view
        }else{
            rep.status = 401
            ModelAndView("redirect:/html/not.html")
        }
    }


    /** @Method Name  : brandNormal
     * @Since    : 2026. 01. 07.
     * @author   : lucas
     * @param    : req: HttpServletRequest
     * @param    : rep : HttpServletResponse
     * @param    : session : HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 브랜드톡 일반 페이지
     * @title : 브랜드톡 일반 페이지
     */
    @GetMapping("/{usr_cd}/brandFc.ajax")
    fun brandFc(@PathVariable(value = "usr_cd") usrCd: String, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        return if(getUsrGrpCd(usrCd) != null){
            val view = ModelAndView("cont/kko/ajax/brandFc")
            view
        }else{
            ModelAndView("redirect:/html/not.html")
        }
    }

    /** @Method Name  : brandNormal
     * @Since    : 2026. 01. 07.
     * @author   : lucas
     * @param    : req: HttpServletRequest
     * @param    : rep : HttpServletResponse
     * @param    : session : HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 브랜드톡 일반 페이지
     * @title : 브랜드톡 일반 페이지
     */
    @GetMapping("/{usr_cd}/brandFa.ajax")
    fun brandFa(@PathVariable(value = "usr_cd") usrCd: String, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        return if(getUsrGrpCd(usrCd) != null){
            val view = ModelAndView("cont/kko/ajax/brandFa")
            view
        }else{
            ModelAndView("redirect:/html/not.html")
        }
    }

    /**
     * @Method Name  : contentUpload
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : file: : MultipartFile
     * @param    : dto : Tblmi_cont_imgDto
     * @param    : request : HttpServletRequest
     * @return   :
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이미지 업로드 하기
     * @title : 이미지 업로드
     */
    @ResponseBody
    @RequestMapping("/{usr_cd}/contentUpload.ajax")
    fun contentUpload(@PathVariable(value = "usr_cd") usrCd: String, @RequestParam("file") file: MultipartFile, @ModelAttribute dto: Tblmi_cont_imgDto, request: HttpServletRequest): Map<String, Any> {
        if(getUsrGrpCd(usrCd) != null){
            return imageService.mobileUpload(file, dto)
        }else{
            return HashMap()
        }
    }

    @ResponseBody
    @PostMapping("/{usr_cd}/mobileList.ajax")
    fun selectMobileContent(@PathVariable(value = "usr_cd") usrCd: String, @ModelAttribute dto: Contents_searchDto) : ModelAndView {
        if(getUsrGrpCd(usrCd) != null){
            dto.cont_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
            dto.use_yn = "Y"
            val view = ModelAndView("cont/mobile/ajax/salesMdmListAjax")
            val paramMap = mobileContentService.selectContentView(dto)

            view.addObject("list" , paramMap["list"])
            view.addObject("page", paramMap["page"])
            view.addObject("pageNo", paramMap["pageNo"])
            view.addObject("nextCk", paramMap["nextCk"])
            view.addObject("titleList",paramMap["titleList"])

            val commonCDDto = Tblmi_comm_cdDto()
            commonCDDto.grp_id = "COMMON"
            commonCDDto.cd_id = "UPURL01"
            val uploadPrefix = sysSettingService.getCommCD(commonCDDto)
            view.addObject("filePath", uploadPrefix?.cd_val)

            return view
        }else{
            return ModelAndView("redirect:/html/not.html")
        }
    }


    // =================================================== Salesforce ===================================================== //
    /**
     * @Method Name  : getUser
     * @Since    : 2022. 08. 04.
     * @author   : SSW
     * @param    : dto: SalesforceDto
     * @return   : Map<String, Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 사용자 조회
     * @title : 사용자 조회
     */
    @ResponseBody
    @PostMapping("/{usr_cd}/getUser.ajax")
    fun getUser(@PathVariable(value = "usr_cd") usrCd: String, @ModelAttribute dto: SalesforceDto, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): Map<String, Any> {
        if(getUsrGrpCd(usrCd) != null){
            return salesforceService.getUser(dto, session)
        }else{
            return HashMap()
        }
    }
/*
    *//**
     * @Method Name  : mappingLst
     * @Since    : 2022. 08. 04.
     * @author   : SSW
     * @param    : dto: SalesforceDto
     * @return   : Map<String, Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 사용자 조회
     * @title : 사용자 조회
     *//*
    @ResponseBody
    @PostMapping("/{usr_cd}/mappingLst.ajax")
    fun mappingLst(@PathVariable(value = "usr_cd") usr_cd: String, @ModelAttribute dto: SalesforceDto, session: HttpSession): Map<String, Any> {
        return salesforceService.mappingLst(dto)
    }*/

    @ResponseBody
    @PostMapping("/{usr_cd}/save.service")
    fun save(@PathVariable(value = "usr_cd") usrCd: String, @RequestBody data : MutableMap<String, Any>): ResponseEntity<Any> {
        return if(getUsrGrpCd(usrCd) != null){
            logger.info("/save.service data: $data")
            val dto = Tblmi_cont_mstDto()
            dto.avo_id = data["activityObjectID"].toString()
            dto.inten_id = data["interactionId"].toString()
            dto.orig_id = data["originalDefinitionId"].toString()
            dto.inta_key = data["interactionKey"].toString()
            dto.inta_ve = data["interactionVersion"].toString()
            val save = salesforceDao.upd_tblmi_cont_mst(dto)
            ResponseEntity(null, HttpStatus.OK)
            /*
            return if(save == 1){
                ResponseEntity(null, HttpStatus.OK)
            }else{
                ResponseEntity(null, HttpStatus.INTERNAL_SERVER_ERROR)
            }
             */
        }else{
            ResponseEntity(null, HttpStatus.INTERNAL_SERVER_ERROR)
        }
    }

    @ResponseBody
    @PostMapping("/{usr_cd}/publish.service")
    fun publish(@PathVariable(value = "usr_cd") usrCd: String, @RequestBody data : MutableMap<String, Any>): ResponseEntity<Any> {
        return if(getUsrGrpCd(usrCd) != null){
            logger.info("/publish.service data: $data")
            val dto = Tblmicp_cont_mstDto()
            dto.avo_id = data["activityObjectID"].toString()
            dto.inten_id = data["interactionId"].toString()
            dto.orig_id = data["originalDefinitionId"].toString()
            dto.inta_key = data["interactionKey"].toString()
            dto.inta_ve = data["interactionVersion"].toString()
            dto.pub_yn = if(data["isPublished"] as Boolean) { "Y" } else { "N" }
            val cont = salesforceService.campaingContent(dto)
            return if(cont) {
                val save = salesforceService.publish(dto)
                if(save){
                    ResponseEntity(null, HttpStatus.OK)
                }else{
                    logger.error("{}", "publish save ERROR")
                    ResponseEntity(null, HttpStatus.INTERNAL_SERVER_ERROR)
                }
            }else{
                logger.error("{}", "publish cont ERROR")
                ResponseEntity(null, HttpStatus.INTERNAL_SERVER_ERROR)
            }
        }else{
            ResponseEntity(null, HttpStatus.INTERNAL_SERVER_ERROR)
        }
    }

    @ResponseBody
    @PostMapping("/{usr_cd}/unpublish.service")
    fun unpublish(@PathVariable(value = "usr_cd") usrCd: String, @RequestBody data : MutableMap<String, Any>): ResponseEntity<Any> {
        return if(getUsrGrpCd(usrCd) != null){
            logger.info("/unpublish.service data: $data")

            val dto = Tblmicp_cont_mstDto()
            var save = 0
            try{
                val prgDto = Tblmicp_programDto()
                prgDto.inten_id = data["interactionId"].toString()
                prgDto.orig_id = data["originalDefinitionId"].toString()
                prgDto.inta_key = data["interactionKey"].toString()
                prgDto.inta_ve = data["interactionVersion"].toString()
                prgDto.pro_st = "04"
                salesforceDao.upd_tblmicp_program_sales(prgDto)
                if(prgDto.pro_id != null){
                    val campDto = Tblmicp_campaignDto()
                    campDto.pro_id = prgDto.pro_id
                    campDto.camp_st = "04"
                    salesforceDao.upd_tblmicp_campaign(campDto)
                }

                dto.inten_id = data["interactionId"].toString()
                dto.orig_id = data["originalDefinitionId"].toString()
                dto.inta_key = data["interactionKey"].toString()
                dto.inta_ve = data["interactionVersion"].toString()
                dto.pub_yn = if(data["isPublished"] as Boolean) { "Y" } else { "N" }
                save = salesforceDao.upd_tblmicp_cont_mst_pub(dto)
            }catch (e: Exception){
                logger.error("unpublish Service error : {}", dto)
                logger.error("unpublish Service error", e)
            }

            if(save > 0){
                ResponseEntity(null, HttpStatus.OK)
            }else{
                logger.error("{}", "unpublish ERROR")
                ResponseEntity(null, HttpStatus.INTERNAL_SERVER_ERROR)
            }
        }else{
            ResponseEntity(null, HttpStatus.INTERNAL_SERVER_ERROR)
        }
    }

    @ResponseBody
    @PostMapping("/{usr_cd}/validate.service")
    fun validate(@PathVariable(value = "usr_cd") usrCd: String, @RequestBody data : MutableMap<String, Any>, req: HttpServletRequest): ResponseEntity<Any> {
        return if(getUsrGrpCd(usrCd) != null){
            logger.info("/validate.service data: $data")
            ResponseEntity(null, HttpStatus.OK)
        }else{
            ResponseEntity(null, HttpStatus.INTERNAL_SERVER_ERROR)
        }
    }

    @ResponseBody
    @PostMapping("/{usr_cd}/stop.service")
    fun stop(@PathVariable(value = "usr_cd") usrCd: String, @RequestBody data : MutableMap<String, Any>) {
        if(getUsrGrpCd(usrCd) != null){
            logger.info("/stop.service data: $data")
            val dto = Tblmicp_programDto()
            try{
                dto.inten_id = data["interactionId"].toString()
                dto.orig_id = data["originalDefinitionId"].toString()
                dto.inta_key = data["interactionKey"].toString()
                dto.inta_ve = data["interactionVersion"].toString()
                dto.pro_st = "04"
                salesforceDao.upd_tblmicp_program_sales(dto)
                if(dto.pro_id != null){
                    val campDto = Tblmicp_campaignDto()
                    campDto.pro_id = dto.pro_id
                    campDto.camp_st = "04"
                    salesforceDao.upd_tblmicp_campaign(campDto)
                }

                val dto1 = Tblmicp_cont_mstDto()
                dto1.inten_id = data["interactionId"].toString()
                dto1.orig_id = data["originalDefinitionId"].toString()
                dto1.inta_key = data["interactionKey"].toString()
                dto1.inta_ve = data["interactionVersion"].toString()
                dto1.pub_yn = "Y"
                salesforceDao.upd_tblmicp_cont_mst_pub(dto1)
            }catch (e: Exception){
                logger.error("stop Service error : {}", dto)
            }
        }
    }

    @ResponseBody
    @PostMapping("/{usr_cd}/TestSave.service")
    fun TestSave(@PathVariable(value = "usr_cd") usrCd: String, @RequestBody data : MutableMap<String, Any>) {
        if(getUsrGrpCd(usrCd) != null){
            logger.info("/TestSave.service data: $data")
        }else{
            logger.info("/TestSave.service data: $data")
        }
    }

    // done 동작
    @ResponseBody
    @PostMapping("/{usr_cd}/execute.service")
    fun execute(@PathVariable(value = "usr_cd") usrCd: String, req: HttpServletRequest, rep: HttpServletResponse, @RequestBody data: String): ResponseEntity<Any> {
        if(getUsrGrpCd(usrCd) != null){
            logger.info("/execute.service data: $data")
            val commonCDDto = Tblmi_comm_cdDto()
            commonCDDto.grp_id = "SALES_JWT"
            commonCDDto.cd_id = usrCd
            val jwtCode = sysSettingService.getCommCD(commonCDDto)
            val secretKey = jwtCode?.cd_val

            var payload: String? = null
            try {
                // jwt
                val chunks: List<String> = data.split(".")
                val decoder: Base64.Decoder = Base64.getUrlDecoder()
                payload = String(decoder.decode(chunks[1]))
                //logger.info("payload: $payload")

                val sa: SignatureAlgorithm = SignatureAlgorithm.HS256
                val secretKeySpec = SecretKeySpec(secretKey?.toByteArray(), sa.jcaName)
                val tokenWithoutSignature = chunks[0] + "." + chunks[1]
                val signature = chunks[2]
                val validator = DefaultJwtSignatureValidator(sa, secretKeySpec)

                // jwt 확인
                if (!validator.isValid(tokenWithoutSignature, signature)) {
                    logger.error("Could not verify JWT token integrity! {}", tokenWithoutSignature)
                } else {
                    val gson = GsonBuilder().create()
                    val data1 = gson.fromJson(payload, MutableMap::class.java)
                    var couponIssuedLogDto = couponIssueService.createCouponLink(data1 as MutableMap<String, Any>)
                    if (couponIssuedLogDto != null) data1["couponIssuedLogDto"] = couponIssuedLogDto
                    salesforceService.sendCampaign(data1)
                    if (couponIssuedLogDto != null) {
                        couponIssuedLogDto = data1["couponIssuedLogDto"] as Tblmicou_coupon_issued_logDto
                        couponIssueService.issueCouponAtSales(couponIssuedLogDto)
                    }
                }
                return ResponseEntity(null, HttpStatus.OK)
            } catch (e: Exception) {
                logger.error("Exception {}", e.javaClass)
                if(e is SQLIntegrityConstraintViolationException || e is DuplicateKeyException){
                    logger.error("execute.service SQLIntegrityConstraintViolationException : {} | {}", e.message, payload)
                }else{
                    logger.error("execute.service", e)
                }
                return ResponseEntity(null, HttpStatus.INTERNAL_SERVER_ERROR)
            }
        }else{
            return ResponseEntity(null, HttpStatus.INTERNAL_SERVER_ERROR)
        }
    }

    @ResponseBody
    @PostMapping("/{usr_cd}/kko/atTmplLst.ajax")
    fun selectKkoAtTmplLst(@ModelAttribute dto: AtTmpl_searchDto, @PathVariable(value = "usr_cd") usrCd: String) : ModelAndView {
        if(getUsrGrpCd(usrCd) != null){
            val view = ModelAndView("cont/kko/ajax/tmplListAjax")
            dto.usr_grp_cd = usrCd
            val paramMap = kkoMsgService.selectAtTemplViewLst(dto)

            view.addObject("list" , paramMap["list"])
            view.addObject("page", paramMap["page"])
            view.addObject("pageNo", paramMap["pageNo"])
            view.addObject("nextCk", paramMap["nextCk"])

            val commonCDDto = Tblmi_comm_cdDto()
            commonCDDto.grp_id = "COMMON"
            commonCDDto.cd_id = "UPURL01"
            val uploadPrefix = sysSettingService.getCommCD(commonCDDto)
            view.addObject("filePath", uploadPrefix?.cd_val)

            return view
        }else{
            return ModelAndView("redirect:/html/not.html")
        }
    }

    @ResponseBody
    @PostMapping("/{usr_cd}/kko/getAtTmpl.ajax")
    fun getAtTmpl(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession, @ModelAttribute dto: AtTmpl_searchDto, @PathVariable(value = "usr_cd") usrCd: String): MutableMap<String, Any>? {
        if(getUsrGrpCd(usrCd) != null){
            val map :MutableMap<String,Any> = mutableMapOf()
            dto.usr_grp_cd = usrCd
            val dto1: Tblmi_kko_at_tmplDto? = kkoMsgService.getKkoAtTmplDto(dto)
            if(CommonUtils.isEmptyObject(dto1)){
                rep.status= HttpServletResponse.SC_BAD_REQUEST
                return null
            }
            map["status"] = HttpServletResponse.SC_OK
            map["dto"] = dto1!!
            return map
        }else{
            return HashMap()
        }
    }

    @ResponseBody
    @GetMapping("/{usr_cd}/getDataExtension.ajax")
    fun getDataExtension(@RequestParam(value = "extentionId") extentionId: String, @PathVariable(value = "usr_cd") usrCd: String, session: HttpSession): MutableMap<String, Any> {
        return if(getUsrGrpCd(usrCd) != null){
            salesforceService.getDataExtention(usrCd, extentionId, session.getAttribute("MID").toString())
        }else{
            HashMap()
        }
    }

    @GetMapping("/{usr_cd}/error")
    fun error(@PathVariable(value = "usr_cd") usrCd: String): String {
        logger.error("error")
        return "index"
    }

    /**
     * 쿠폰 기능
     */
    @PostMapping("/{usr_cd}/coupon/getCouponListAtSales.ajax")
    fun couponList(@PathVariable(value = "usr_cd") usrCd: String, searchCouponDto: SearchCouponDto): ModelAndView {
        return if(getUsrGrpCd(usrCd) != null){
            val view = ModelAndView("cont/coupon/couponListAjax")
            val reMap = couponListService.getCouponListAtSales(searchCouponDto, usrCd)
            view.addObject("couponList", reMap["list"])
            view.addObject("page", reMap["page"])
            view.addObject("pageNo", reMap["pageNo"])
            view.addObject("cnt", reMap["cnt"])
            view
        }else{
            ModelAndView("redirect:/html/not.html")
        }
    }

    @PostMapping("/{usr_cd}/coupon/getCouponAtSales.ajax")
    fun couponPreview(@PathVariable(value = "usr_cd") usrCd: String, @RequestParam seq: String): ModelAndView {
        return if(getUsrGrpCd(usrCd) != null){
            val view = ModelAndView("cont/coupon/couponPreviewAjax")

            val couponListDto = couponListService.getCoupon(seq)
            couponListDto.daily_start_time = formattingTime(couponListDto.daily_start_time!!)
            couponListDto.daily_end_time = formattingTime(couponListDto.daily_end_time!!)
            couponListDto.expire_dt = formattingDate(couponListDto.expire_dt!!)

            view.addObject("coupon", couponListDto)
            view.addObject("couponImageDomain", couponListService.getCouponImageCdnDomain())
            view
        }else{
            ModelAndView("redirect:/html/not.html")
        }
    }

    @ResponseBody
    @PostMapping("/{usr_cd}/coupon/checkNaverApi.ajax")
    fun checkNaverApi(@PathVariable(value = "usr_cd") usrCd: String): Map<String, Any> {
        return if(getUsrGrpCd(usrCd) != null){
            sysSettingService.isExistNaverApi(usrCd)
        }else{
            HashMap()
        }
    }

    private fun formattingDate(time: String): String {
        return LocalDateTime.parse(time, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")).toString().replace("T", " ")
    }

    private fun formattingTime(time: String): String {
        val splitTime = time.split(":").map { it.toInt() }
        val localTime = LocalTime.of(splitTime[0], splitTime[1])
        return localTime.format(DateTimeFormatter.ofPattern("h:mm a", Locale.US))
    }

}