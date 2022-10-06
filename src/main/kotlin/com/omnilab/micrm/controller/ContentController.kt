package com.omnilab.micrm.controller

import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.FileUploadUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.*
import com.omnilab.micrm.model.table.Tblmi_comm_cdDto
import com.omnilab.micrm.model.table.Tblmi_cont_imgDto
import com.omnilab.micrm.model.table.Tblmi_cont_mstDto
import com.omnilab.micrm.model.table.Tblmi_kko_at_tmplDto
import com.omnilab.micrm.model.table.kakao.Kko_at_tmplDto
import com.omnilab.micrm.service.*
import org.apache.commons.io.FilenameUtils
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.*
import org.springframework.web.multipart.MultipartFile
import org.springframework.web.servlet.ModelAndView
import java.awt.Image
import java.awt.image.BufferedImage
import java.io.File
import java.security.Principal
import javax.imageio.ImageIO
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import javax.servlet.http.HttpSession


@Controller
@RequestMapping("/cont")
class ContentController  {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired(required = true)
    @Qualifier("MobileContentServiceImpl")
    private lateinit var mobileContentService: ContentService

    @Autowired(required = true)
    @Qualifier("EmailContentServiceImpl")
    private lateinit var emailContentService: ContentService

    @Autowired(required = true)
    @Qualifier("ImageServiceImpl")
    private lateinit var imageService: ImageService

    @Autowired
    @Qualifier("SysSettingServiceImpl")
    lateinit var sysSettingService: SysSettingService;

    @Autowired
    @Qualifier("CampaignServiceImpl")
    private lateinit var campaignService : CampaignService

    @Autowired
    @Qualifier("KkoMsgServiceImpl")
    private lateinit var kkoMsgService: KkoMsgService

    @Autowired
    lateinit var fileUpload: FileUploadUtils;

    @Autowired
    @Qualifier("KkoRestApiServiceImpl")
    lateinit var kkoRestApiService: KkoRestApiService

    @Value("\${upload.content}")
    private val filePath: String? = null



    // =================================================== Mobile ===================================================== //

    @GetMapping("/mdmLst.mi")
    fun mdmLst(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val view = ModelAndView("cont/mdmLst")
        return view
    }

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

    @PostMapping("/mobileInsert.service")
    fun insertMoblieContent(@ModelAttribute content_list_dto: Content_list_CreateDto, response: HttpServletResponse): ModelAndView {
        content_list_dto.cont_grp_cd = UsefulUtils.sessionUser().usr_grp_cd

        val statusMap = mobileContentService.insertContentList(content_list_dto);
        //mobileContentService.insertContentList(content_list_dto);

        val view = ModelAndView("redirect:/cont/mdmLst.mi")

        if(statusMap["status"] == false) {
            val errorView = ModelAndView("error")
            UsefulUtils.alertPopUp(response,"모바일 컨텐츠 저장 도중 오류가 났습니다. \\n관리자에게 문의 바랍니다.");
            return errorView;
        }
        return view;

    }


    /**
     * @Method Name  : mdmCreate
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : req: HttpServletRequest
     * @param    : rep : HttpServletResponse
     * @param    : session : HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 모바일 컨텐츠 생성 뷰 페이지 조회
     * @title : 모바일 컨텐츠 생성 뷰 페이지
     */
    @GetMapping("/mdmCreate.mi")
    fun mdmCreate(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val view = ModelAndView("cont/mdmCreate")
        val map = sysSettingService.getDBValue()

        val kkoDto = SetLst_searchDto()
        kkoDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        kkoDto.list_tp_id = "CH02"
        kkoDto.list_dt_id = "DMTP03"
        kkoDto.def_yn = "Y"
        val kkoSenderMap = mobileContentService.selectSenderList(kkoDto)

        val smsDto = SetLst_searchDto()
        smsDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        smsDto.list_tp_id = "CH02"
        smsDto.list_dt_id = "DMTP02"
        smsDto.def_yn = "Y"
        val smsSenderMap = mobileContentService.selectSenderList(smsDto)


        val rcsDto = SetLst_searchDto()
        rcsDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        rcsDto.list_tp_id = "CH02"
        rcsDto.list_dt_id = "DMTP04"
        rcsDto.def_yn = "Y"
        val rcsSenderMap = mobileContentService.selectSenderList(rcsDto)


        val cntMap = mobileContentService.isCheckSender()

        // 개인화 변수 추가하기
        view.addObject("column",map)
        view.addObject("list",kkoSenderMap["list"])
        view.addObject("smsSender",smsSenderMap["list"])
        view.addObject("rcsSender",rcsSenderMap["list"])
        view.addObject("kakaoCnt", cntMap["kakaoCnt"])
        view.addObject("smsCnt", cntMap["smsCnt"])
        view.addObject("rcsCnt", cntMap["rcsCnt"])

        return view
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
    @PostMapping("/mobileUpdate.service")
    fun updateMoblieContent(@ModelAttribute content_list_dto: Content_list_CreateDto, response : HttpServletResponse): ModelAndView {
        content_list_dto.cont_grp_cd = UsefulUtils.sessionUser().usr_grp_cd

        val view = ModelAndView("redirect:/cont/mdmLst.mi")
        val statusMap= mobileContentService.updateContentLst(content_list_dto)

        if(statusMap["status"] == false){
            val errorView = ModelAndView("error")
            UsefulUtils.alertPopUp(response,"Byte가 일치하지 않아 모바일 컨텐츠 저장 도중 오류가 났습니다. \\n관리자에게 문의 바랍니다.");
            return errorView;
        }
        return view
    }


    /**
     * @Method Name  : updateMoblieContent
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : seq: Int
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 모바일 컨텐츠 상세 페이지
     * @title : 모바일 컨텐츠 상세 페이지
     */

    @GetMapping("/mdmDetail/{seq}.mi")
    fun detailMobileContent(@PathVariable("seq") seq : Int) : ModelAndView {
        val tblmiContMstdto = Tblmi_cont_mstDto()
        tblmiContMstdto.seq = seq
        val view = ModelAndView("/cont/detailMdm")
        val map = sysSettingService.getDBValue()
        val listMap = mobileContentService.selectOneContentView(tblmiContMstdto)
        val cntMap = mobileContentService.isCheckSender()

        view.addObject("list" , listMap["list"])
        view.addObject("column",map);
        view.addObject("kakaoCnt", cntMap["kakaoCnt"])
        view.addObject("smsCnt", cntMap["smsCnt"])
        view.addObject("rcsCnt", cntMap["rcsCnt"])

        val commonCDDto = Tblmi_comm_cdDto()
        commonCDDto.grp_id = "COMMON"
        commonCDDto.cd_id = "UPURL01"
        val uploadPrefix = sysSettingService.getCommCD(commonCDDto);
        view.addObject("filePath", uploadPrefix?.cd_val)

        return view
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
    @PostMapping("/senderMobileList.ajax")
    fun selectSenderMobileList(@ModelAttribute dto : SetLst_searchDto): ModelAndView {
        val view = ModelAndView("cont/mobile/ajax/senderMobileListAjax")
        val senderMap = mobileContentService.selectSenderList(dto)

        view.addObject("list", senderMap["list"])
        view.addObject("page", senderMap["page"])
        view.addObject("pageNo", senderMap["pageNo"])
        view.addObject("listCnt", senderMap["listCnt"])

        return view
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
    @PostMapping("/isCheckTmplateNm.ajax")
    fun isCheckTemplateName(@ModelAttribute contMstdto: Tblmi_cont_mstDto) : HashMap<String,String>{

        val result = mobileContentService.checkContNm(contMstdto)
        val statusMap = HashMap<String,String>()

        if(result == 0) {
            statusMap["status"] = "true"
            statusMap["message"] = "모바일 컨텐츠 저장이 완료 되었습니다"
        } else {
            statusMap["status"] = "false"
            statusMap["message"] = "중복된 컨텐츠 이름이 존재합니다"
        }
        return statusMap
    }

    /**
     * @Method Name  : selectMobileContent
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : dto: Contents_searchDto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 모바일 컨텐츠 리스트 가져오기
     * @title : 모바일 컨텐츠 리스트
     */
    @ResponseBody
    @PostMapping("/mobileList.ajax")
    fun selectMobileContent(@ModelAttribute dto: Contents_searchDto) : ModelAndView {
        dto.cont_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val view = ModelAndView("cont/mobile/ajax/mdmListAjax")
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
    @GetMapping("/rcsText.ajax")
    fun rcsText(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val view = ModelAndView("cont/mobile/ajax/rcsText")
        view.addObject("column", sysSettingService.getDBValue())
        return view
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
    @GetMapping("/rcsVertical.ajax")
    fun rcsVertical(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val view = ModelAndView("cont/mobile/ajax/rcsVertical")
        view.addObject("column", sysSettingService.getDBValue())
        return view
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
    @GetMapping("/rcsSlide.ajax")
    fun rcsSlide(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val view = ModelAndView("cont/mobile/ajax/rcsSlide")
        view.addObject("column", sysSettingService.getDBValue())
        return view
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
     * @title : RCS 프리뷰 페이지
     */

    @PostMapping("/preview.ajax")
    fun previewService(@ModelAttribute dto : Content_list_CreateDto,@ModelAttribute atSearchDto : AtTmpl_searchDto) : ModelAndView {
        val view = ModelAndView("cont/mobile/ajax/mdmPreview")
        //logger.error("preview Dto : " + dto.toString());
        //logger.error("kakaoUrl : " + dto.kko_view_img_url);
        //logger.error("rcsUrl : " + dto.rcs_img_url_1);

        /**
         * RCS의 Json 데이터는 Model 값으로 jsonContent 값을 뿌려준다
         *      (Content_list_CreateDto로 넘어온 값 재 파싱 후 Contents_lstDto 값 )
         * 그 외의 데이터는 Model 값으로 "content" 값을 뿌려 준다
         *      (Content_list_CreateDto 로 넘어온 값 )
         */

        val formatList = dto.formatType
        val kkoFormatType = dto.kko_format_type

        if(formatList!!.contains("kakao") && "kko_at".equals(kkoFormatType)) {
            // 넘어 오는 Preview 데이터에 카카오 알림톡이 있으면 파싱후 뿌려 준다 -> RCS Json Parsing
            val atDto: Tblmi_kko_at_tmplDto? =kkoMsgService.getKkoAtTmplDto(atSearchDto)
            val map = mobileContentService.previewATJsonService(atDto!!)
            //logger.error("jsonContent : " + map["jsonContent"])
            view.addObject("jsonContent", map["jsonContent"])
        }

        if(formatList.contains("rcs")) {
            // 넘어 오는 Preview 데이터에 RCS가 있으면 파싱후 뿌려 준다 -> RCS Json Parsing
            val map = mobileContentService.previewJsonService(dto);
            //logger.error("jsonContent : " + map["jsonContent"])
            view.addObject("jsonContent", map["jsonContent"])
        }
        view.addObject("content", dto);

        val commonCDDto = Tblmi_comm_cdDto()
        commonCDDto.grp_id = "COMMON"
        commonCDDto.cd_id = "UPURL01"
        val uploadPrefix = sysSettingService.getCommCD(commonCDDto)
        view.addObject("filePath", uploadPrefix?.cd_val)

        return view;
    }

    /**
     * @Method Name  : deleteMobileContent
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : list : MutableList<Int>
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 모바일 컨텐츠 체크 박스 삭제하기
     * @title : 모바일 컨텐츠 삭제하기
     */
    @ResponseBody
    @PostMapping("/deleteMobileContent.ajax")
    fun deleteMobileContent(@RequestParam("checkList[]") list : MutableList<Int>) : Map<String,Any>{
        return mobileContentService.updateContentsMstDelYn(list)
    }

    /**
     * @Method Name  : updateMobileContentUseYn
     * @Since    : 2021. 03. 07.
     * @author   : Grayson
     * @param    : tblmiContMstdto : Tblmi_cont_mstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 모바일 컨텐츠 UseYN 변경하기
     * @title : 모바일 컨텐츠 Use_yn 변경하기
     */
    @ResponseBody
    @PostMapping("/updateMobileUseYn.ajax")
    fun updateMobileContentUseYn(@ModelAttribute tblmiContMstdto: Tblmi_cont_mstDto) : Map<String, Any> {
        return mobileContentService.updateContentMst(tblmiContMstdto)
    }

    //====================================Email =========================================================//
    /**
     * @Method Name  : edmLst
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : req: : HttpServletRequest
     * @param    : rep: : HttpServletResponse
     * @param    : session : HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이메일 리스트 조회하기
     * @title : 이메일 리스트 조회하기
     */
    @GetMapping("/edmLst.mi")
    fun edmLst(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val view = ModelAndView("cont/edmLst")
        val dto : Contents_searchDto = Contents_searchDto()
        val map = emailContentService.selectContentView(dto)
        view.addObject("list", map["list"])
        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])
        view.addObject("listCnt", map["listCnt"])
        view.addObject("nextCk", map["nextCk"])

        val commonCDDto = Tblmi_comm_cdDto()
        commonCDDto.grp_id = "COMMON"
        commonCDDto.cd_id = "UPURL01"
        val uploadPrefix = sysSettingService.getCommCD(commonCDDto);
        view.addObject("filePath", uploadPrefix?.cd_val)
        return view
    }



    /**
     * @Method Name  : imgLst
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : req: : HttpServletRequest
     * @param    : rep: : HttpServletResponse
     * @param    : session : HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이미지 리스트 조회 하기
     * @title : 이미지 리스트 조회 하기
     */
    @GetMapping("/imgLst.mi")
    fun imgLst(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val view = ModelAndView("cont/imgLst")
        val dto = Image_searchDto()

        val map = imageService.getImgList(dto)
        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])
        view.addObject("listCnt", map["listCnt"])
        view.addObject("nextCk", map["nextCk"])

        val commonCDDto = Tblmi_comm_cdDto()
        commonCDDto.grp_id = "COMMON"
        commonCDDto.cd_id = "UPURL01"
        val uploadPrefix = sysSettingService.getCommCD(commonCDDto);
        view.addObject("filePath", uploadPrefix?.cd_val)

        return view
    }

    /**
     * @Method Name  : ImgSaveTest
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : param: : ThumbParseDto
     * @param    : request: : HttpServletRequest
     * @param    : response : HttpServletResponse?
     * @return   : String
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이미지 저장 템플릿 테스트
     * @title : 이미지 저장 테스트
     */

    @ResponseBody
    @PostMapping("thumbnailSave.ajax")
    fun ImgSaveTest(@ModelAttribute param: ThumbParseDto, request: HttpServletRequest, response: HttpServletResponse?): String {
        val paramMap: MutableMap<String, Any> = HashMap()
        paramMap["filename"] = param.filename!!
        paramMap["file"] = param.file!!
        paramMap["templist"] = param.templist!!

        val sb = StringBuilder()
        if (emailContentService.contents_thumbnail_save(paramMap)) {
            sb.append("이메일 템플릿이 저장 되었습니다.")
        } else {
            sb.append("이메일 템플릿 저장에 실패 하였습니다.")
        }
        return sb.toString()
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
     * @Method Decription : 이메일 발신자 리스트 불러오기
     * @title : 발신자 리스트 불러오기
     */
    @PostMapping("/senderList.ajax")
    fun selectSenderList(@ModelAttribute tblmiSetLstDto : SetLst_searchDto): ModelAndView {
        tblmiSetLstDto.list_tp_id = "CH01"
        tblmiSetLstDto.list_dt_id = "DMTP01"
        val view = ModelAndView("cont/mobile/ajax/senderListAjax")
        val senderMap = mobileContentService.selectSenderList(tblmiSetLstDto)

        view.addObject("list", senderMap["list"])
        view.addObject("page", senderMap["page"])
        view.addObject("pageNo", senderMap["pageNo"])
        view.addObject("listCnt", senderMap["listCnt"])

        return view
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
    @PostMapping("/mobileImgList.ajax")
    fun selectImgListForPopUp(@ModelAttribute tblmiContImgdto: Image_searchDto): ModelAndView {

        val view = ModelAndView("cont/mobile/ajax/mdmImgListAjax")
        val senderMap = imageService.selectImgForPopup(tblmiContImgdto)

        view.addObject("list", senderMap["list"])
        view.addObject("page", senderMap["page"])
        view.addObject("pageNo", senderMap["pageNo"])
        view.addObject("listCnt", senderMap["listCnt"])

        val commonCDDto = Tblmi_comm_cdDto()
        commonCDDto.grp_id = "COMMON"
        commonCDDto.cd_id = "UPURL01"
        val uploadPrefix = sysSettingService.getCommCD(commonCDDto);
        view.addObject("filePath", uploadPrefix?.cd_val)

        return view
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
    @RequestMapping("/contentUpload.ajax")
    fun contentUpload(@RequestParam("file") file: MultipartFile?, @ModelAttribute dto: Tblmi_cont_imgDto, request: HttpServletRequest): Map<String, Any> {
        var map: MutableMap<String, Any> = hashMapOf()
        //이미지명 중복 체크 추가.
        val imgNmCh = imageService.getImgNmCh(dto)
        if(imgNmCh > 0 ){
            map["imgCheck"] = 0
            map["imgCheckErr"] = "중복된 이미지명입니다."
            return map;
        }
        if (file != null) {
            try {
                map["imgCheck"] = 1
                val userInfo = UsefulUtils.sessionUser()
                val contentFilePath = filePath + "/"+ userInfo.usr_grp_cd
                map = fileUpload.upload(contentFilePath, file, request);
                if(map["uploaded"].toString() == "0"){
                    logger.info("File Upload fail")
                }else{

                    if(dto.ch_tp != "IMGTP01" && dto.ch_tp != "IMGTP10"){
                        val fileName = map["file_nm"]
                        val image : BufferedImage = ImageIO.read(file.inputStream)
                        val imageWidth: Int = image.width
                        val imageHeight: Int = image.width
                        if(image.width < 500 || image.height < 250) {

                            val newWidth = 500
                            val newHeight = 500
                            val ratio: Double
                            val w: Int
                            var h: Int

                            if (imageWidth > imageHeight) {
                                ratio = newWidth.toDouble() / imageWidth.toDouble()
                                w = (imageWidth * ratio).toInt()
                                h = (imageHeight * ratio).toInt()
                            } else if (imageHeight > imageWidth) {
                                ratio = newHeight.toDouble() / imageHeight.toDouble()
                                w = (imageWidth * ratio).toInt()
                                h = (imageHeight * ratio).toInt()
                            } else {
                                w = newWidth
                                h = newHeight
                            }
                            if(h < 250){
                                h = 250
                            }
                            val resizeImage = image.getScaledInstance(w, h, Image.SCALE_SMOOTH)
                            val newImage = BufferedImage(w, h, BufferedImage.TYPE_INT_RGB)
                            val g = newImage.graphics
                            g.drawImage(resizeImage, 0, 0, null)
                            g.dispose()

                            ImageIO.write(newImage, "jpg", File(FilenameUtils.getFullPath("$contentFilePath/$fileName"), FilenameUtils.getName("$contentFilePath/$fileName")))

                            resizeImage.flush()
                            image.flush()
                        }
                    }
                    var resultMap: MutableMap<String, Any>? = null
                    if(dto.ch_tp == "IMGTP09"){    // 카카오 알림톡 이미지
                        resultMap = kkoRestApiService.uploadTmplImg(file)
                    }else if(dto.ch_tp == "IMGTP10"){
                        resultMap = kkoRestApiService.uploadTmplItemImg(file)
                    }else if(dto.ch_tp == "IMGTP03" || dto.ch_tp == "IMGTP11"){    // 카카오 친구톡 이미지
                        resultMap = kkoRestApiService.uploadFtImg(file, dto.ch_tp!!)
                    }

                    if(!CommonUtils.isEmptyObject(resultMap)){
                        if(resultMap!!["result"] as Boolean){
                            val data: MutableMap<String, Any> = resultMap["data"] as MutableMap<String, Any>
                            if(data["code"] != "API_200" ){
                                map["uploaded"] = 0
                                map["message"] = "파일 저장에 실패하였습니다."
                                logger.info("File DB insert fail")
                                return map
                            }

                            dto.kko_img_url = data["image"].toString() // 카카오 이미지 넣어주기
                        }else{
                            map["uploaded"] = 0
                            map["message"] = "파일 저장에 실패하였습니다."
                            logger.info("File DB insert fail")
                            return map
                        }
                    }

                }

                dto.reg_id = userInfo.usr_id
                dto.usr_grp_cd = userInfo.usr_grp_cd
                dto.img_org_nm = map["fileName"].toString()
                dto.img_file_nm = map["file_nm"].toString()
                dto.img_url = map["url"].toString()
                val returnMap = imageService.contentUpload(dto)
                if(returnMap["message"].toString() == "0"){
                    map["uploaded"] = 0
                    map["message"] = "파일 저장에 실패하였습니다."
                    logger.info("File DB insert fail")
                }

            }catch (e:Exception){
                map["uploaded"] = 0
                map["message"] = "파일 저장에 실패하였습니다."
                logger.info("File DB insert fail")
                return map
            }
        }
        return map
    }
    /**
     * @Method Name  : getImgList
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : dto: : Tblmi_cont_imgDto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이미지 리스트 가져오기
     * @title : 이미지 리스트
     */

    @PostMapping("/getImgList.ajax")
    fun getImgList(@ModelAttribute  dto : Image_searchDto): ModelAndView {
        val view = ModelAndView("cont/ajax/imgLstAjax")

        val map = imageService.getImgList(dto)
        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])
        view.addObject("listCnt", map["listCnt"])
        view.addObject("nextCk", map["nextCk"])

        val commonCDDto = Tblmi_comm_cdDto()
        commonCDDto.grp_id = "COMMON"
        commonCDDto.cd_id = "UPURL01"
        val uploadPrefix = sysSettingService.getCommCD(commonCDDto);
        view.addObject("filePath", uploadPrefix?.cd_val)

        return view
    }
    /**
     * @Method Name  : updateImgYn
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : dto : Tblmi_cont_imgDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이미지 Y,N변경
     * @title : 이미지 Y,N변경
     */

    @ResponseBody
    @RequestMapping("/updateImgYn.ajax")
    fun updateImgYn(@ModelAttribute dto : Image_searchDto): MutableMap<String, Any> {
        val map: MutableMap<String, Any> = hashMapOf()
        val userInfo = UsefulUtils.sessionUser()
        dto.usr_grp_cd = userInfo.usr_grp_cd
        dto.upd_id = userInfo.usr_id
        map["message"] = imageService.updateImgYn(dto)

        val resuleMap =  imageService.getImgList(dto)
        map["list"] = resuleMap["list"] as Any
        return map
    }
    /**
     * @Method Name  : deleteImgList
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : list: : MutableList<Int>
     * @return   : Map<String, Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이미지 삭제하기
     * @title : 이미지 삭제하기
     */
    @ResponseBody
    @PostMapping("/deleteImgList.ajax")
    fun deleteImgList(@RequestParam("checkList[]") list: MutableList<Int>): Map<String, Any> {
        return imageService.deleteImgList(list);
    }
    /**
     * @Method Name  : deleteImgList
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : dto : Image_searchDto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이미지 상세페이지 가져 오기
     * @title : 이미지 상세페이지
     */
    @PostMapping("/updateImg.ajax")
    fun updateImg(@ModelAttribute  dto : Image_searchDto): ModelAndView {

        val view = ModelAndView("cont/ajax/imgDetail")
        val map = imageService.getImgList(dto)

        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])
        view.addObject("listCnt", map["listCnt"])
        view.addObject("nextCk", map["nextCk"])

        val commonCDDto = Tblmi_comm_cdDto()
        commonCDDto.grp_id = "COMMON"
        commonCDDto.cd_id = "UPURL01"
        val uploadPrefix = sysSettingService.getCommCD(commonCDDto);
        view.addObject("filePath", uploadPrefix?.cd_val)

        return view
    }

    /**
     * @Method Name  : getEdmList
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : dto : Content_view_Dto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이메일 리스트 가져오기
     * @title : 이메일 리스트 가져오기
     */
    @PostMapping("/getEdmList.ajax")
    fun getEdmList(@ModelAttribute  dto : Contents_searchDto): ModelAndView {
        val view = ModelAndView("cont/ajax/edmLstAjax")
        val map = emailContentService.selectContentView(dto)
        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])
        view.addObject("listCnt", map["listCnt"])
        view.addObject("nextCk", map["nextCk"])

        val commonCDDto = Tblmi_comm_cdDto()
        commonCDDto.grp_id = "COMMON"
        commonCDDto.cd_id = "UPURL01"
        val uploadPrefix = sysSettingService.getCommCD(commonCDDto)
        view.addObject("filePath", uploadPrefix?.cd_val)

        return view
    }

    /**
     * @Method Name  : deleteEdmList
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : list : MutableList<Int>
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이메일 리스트 삭제하기
     * @title : 이메일 리스트 삭제
     */
    @ResponseBody
    @PostMapping("/deleteEdmList.ajax")
    fun deleteEdmList(@RequestParam("checkList[]") list: MutableList<Int>): Map<String, Any> {
        return emailContentService.updateContentsMstDelYn(list);
    }

    /**
     * @Method Name  : updateEdmYn
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : dto : Tblmi_cont_mstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이메일 컨텐츠 YN 변경
     * @title : 이메일 컨텐츠 YN 변경
     */

    @ResponseBody
    @RequestMapping("/updateEdmYn.ajax")
    fun updateEdmYn(@ModelAttribute dto : Contents_searchDto): MutableMap<String, Any> {
        val map: MutableMap<String, Any> = hashMapOf()

        val returnMap = emailContentService.updateContentMst(dto)
        map["message"] = 0
        if(returnMap["updateCnt"].toString().toInt() > 0){
            val resultMap =  emailContentService.selectOneContentView(dto)
            map["message"] = "1"
            map["list"] = resultMap["list"] as Any
        }
        return map
    }

    /*
     * @Method Name  : saveContForm
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : req: : HttpServletRequest
     * @param    : rep: : HttpServletResponse
     * @param    : session : HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이미지 리스트 조회 하기
     * @title : 이미지 리스트 조회 하기
     */
    //TODO : 이 메소드는 수정 필요
    @PostMapping("/saveContForm.mi")
    fun saveContForm(@ModelAttribute dto: Content_list_CreateDto): ModelAndView {
        val map = emailContentService.insertContentList(dto)
        if (map["result"] == false) {
            val view = ModelAndView("/validate/alertAndClose")
            view.addObject("message", "저장에 실패 하였습니다.")
            view.addObject("url", "/cont/edmLst.mi")
            return view
        } else {
            val view = ModelAndView("cont/thumbnailCreate")
            view.addObject("cont_body", map["cont_body"])
            view.addObject("temp", map["temp"].toString().replace("<iframe", "<iframe?"))
            view.addObject("list", map["list"])
            view.addObject("filename", map["filename"])
            view.addObject("br_yn", map["br_yn"])
            view.addObject("sup_yn", map["sup_yn"])
            view.addObject("cont_top_body", map["cont_top_body"])
            return view
        }
    }
    /*
     * @Method Name  : updateEmailContForm
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : dto : Tblmi_cont_mstDto (DTO 수정 필요)
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이메일 컨텐츠 수정하기
     * @title : 이메일 컨텐츠 수정하기
     */
    @PostMapping("/updateEmailContForm.mi")
    fun updateEmailContForm(@ModelAttribute dto: Content_list_CreateDto): ModelAndView {
        val map = emailContentService.updateContentLst(dto)
        val Result = map["result"]
        when (Result) {
            1 -> {
                //body 변경으로 file 변경
                val view = ModelAndView("cont/thumbnailCreate")
                view.addObject("cont_body", map["cont_body"])
                view.addObject("temp", map["temp"].toString().replace("<iframe", "<iframe?"))
                view.addObject("list", map["list"])
                view.addObject("filename", map["filename"])
                view.addObject("br_yn", map["br_yn"])
                view.addObject("sup_yn", map["sup_yn"])
                view.addObject("cont_top_body", map["cont_top_body"])
                return view
            }
            2 -> {
                //body 변경이 없음 또는 body에 내용 없음
                val view = ModelAndView("/common/alertAndClose")
                view.addObject("message", "변경되었습니다.")
                view.addObject("url", "/cont/edmLst.mi")
                return view
            }
            else -> {
                //실패
                val view = ModelAndView("/common/alertAndClose")
                view.addObject("message", "저장에 실패 하였습니다.")
                view.addObject("url", "/cont/edmLst.mi")
                return view
            }
        }
    }


    @ResponseBody
    @RequestMapping("/checkContNm.ajax")
    fun checkContNm(@ModelAttribute dto : Tblmi_cont_mstDto): Int {
        return emailContentService.checkContNm(dto);
    }

    // ========================= SYS ==============================//

    //DB 개인화변수.
    @ResponseBody
    @PostMapping("/getDBValue.ajax")
    fun getDBValue(@ModelAttribute  dto : Tblmi_cont_imgDto): MutableList<SalesforceDto> {
        return sysSettingService.getDBValue();
    }


    //  ============================ atTemplate =============================//

    /**
     * @Method Name  : atTemplate
     * @Since    : 2022. 09. 13.
     * @author   : Belisa
     * @param    : dto :
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 카카오 알림톡 템플릿 조회
     * @title : 카카오 알림톡 템플릿 조회
     */
    @GetMapping("/atTemplate.mi")
    fun atTemplate(@ModelAttribute  dto : Tblmi_cont_imgDto): ModelAndView {
        val view = ModelAndView("cont/kko/atTemplateLst")
        val map = kkoMsgService.getTmplSearchLst()

        view.addObject("tmplSt",map.get("tmplSt"))
        view.addObject("kepSt",map.get("kepSt"))

        return view
    }

    /**
     * @Method Name  : selectKkoAtTmplLst
     * @Since    : 2022. 09. 15.
     * @author   : Belisa
     * @param    : dto:
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 알림톡 템플릿 리스트 가져오기
     * @title : 알림톡 템플릿 리스트
     */
    @ResponseBody
    @PostMapping("/kko/atTmplLst.ajax")
    fun selectKkoAtTmplLst(@ModelAttribute dto: AtTmpl_searchDto) : ModelAndView {
        val view = ModelAndView("cont/kko/ajax/tmplListAjax")
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
    }


    /**
     * @Method Name  : atTmplCreate
     * @Since    : 2022. 09. 19.
     * @author   : Belisa
     * @param    : req: HttpServletRequest
     * @param    : rep : HttpServletResponse
     * @param    : session : HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 알림톡 탬플릿 생성 뷰 페이지 조회
     * @title : 알림톡 탬플릿 생성 뷰 페이지
     */
    @GetMapping("/kko/tmplCreate.mi")
    fun atTmplCreate(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val view = ModelAndView("cont/kko/tmplCreate")
        val map = kkoMsgService.tmplCreateLst();

        view.addObject("cateLst",map["cateLst"]);
        view.addObject("cateSubLst",map["cateSubLst"])
        view.addObject("msgTpLst", map["msgTpLst"])
        view.addObject("empTpLst", map["empTpLst"])
        view.addObject("cateSubGidLst", map["cateSubGidLst"])
        view.addObject("btnLinkLst", map["btnLinkLst"])
        view.addObject("btnLst", map["btnLst"])

        view.addObject("column",sysSettingService.getDBValue())

        val commonCDDto = Tblmi_comm_cdDto()
        commonCDDto.grp_id = "COMMON"
        commonCDDto.cd_id = "UPURL01"
        val uploadPrefix = sysSettingService.getCommCD(commonCDDto)
        view.addObject("filePath", uploadPrefix?.cd_val)

        return view
    }

    /**
     * @Method Name  : tmplCreateService
     * @Since    : 2022. 09. 19.
     * @author   : Belisa
     * @param    : req: HttpServletRequest
     * @param    : rep : HttpServletResponse
     * @param    : session : HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 알림톡 탬플릿 생성
     * @title : 알림톡 탬플릿 생성
     */
    @ResponseBody
    @PostMapping("/kko/tmplCreate.service")
    fun tmplCreateService(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession,
                          @RequestBody dto : Kko_at_tmplDto, @RequestParam(value="img_seq", required = false) img_seq : String,
                          @RequestParam(value="item_img_seq", required = false) item_img_seq :String, principal: Principal): Any? {
        val tmplDto : Tblmi_kko_at_tmplDto = Tblmi_kko_at_tmplDto(img_seq.toIntOrNull(),item_img_seq.toIntOrNull())
        tmplDto.reg_id = principal.name
        val map = kkoMsgService.createTmpl(dto,tmplDto)
        return map
    }

    /**
     * @Method Name  : isCheckTmplNm
     * @Since    : 2022. 09. 20.
     * @author   : Belisa
     * @param    : req: HttpServletRequest
     * @param    : rep : HttpServletResponse
     * @param    : session : HttpSession
     * @return   : String
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 알림톡 탬플릿명 체크
     * @title : 알림톡 탬플릿명 체크
     */
    @ResponseBody
    @PostMapping("/kko/isCheckTmplNm.ajax")
    fun isCheckTmplNm(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession, @ModelAttribute dto: AtTmpl_searchDto): MutableMap<String, Any> {

        val map :MutableMap<String,Any> = mutableMapOf()
        dto.use_yn = "Y"

        val dto: Tblmi_kko_at_tmplDto? =kkoMsgService.getKkoAtTmplDto(dto)

        if(!CommonUtils.isEmptyObject(dto)){   //
            map.put("status" , HttpServletResponse.SC_BAD_REQUEST)
            map.put("msg" , "이미 사용중인 템플릿명 입니다.")
            return map
        }

        map.put("status" , HttpServletResponse.SC_OK)
        map.put("msg" , "사용가능한 템플릿명 입니다.")

        return map
    }

    /**
     * @Method Name  : isCheckUpdTmplNm
     * @Since    : 2022. 10. 06.
     * @author   : Belisa
     * @param    : req: HttpServletRequest
     * @param    : rep : HttpServletResponse
     * @param    : session : HttpSession
     * @return   : String
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 알림톡 탬플릿명 체크
     * @title : 알림톡 탬플릿명 체크
     */
    @ResponseBody
    @PostMapping("/kko/isCheckUpdTmplNm.ajax")
    fun isCheckUpdTmplNm( req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession, @ModelAttribute curdto: AtTmpl_searchDto, ): MutableMap<String, Any> {

        val map: MutableMap<String, Any> = mutableMapOf()
        curdto.use_yn = "Y"

        val dto: Tblmi_kko_at_tmplDto? = kkoMsgService.getKkoAtTmplDto(curdto)

        if (!CommonUtils.isEmptyObject(dto)) {
            if(!curdto.seq!!.equals(dto!!.seq)){
                map.put("status", HttpServletResponse.SC_BAD_REQUEST)
                map.put("msg", "이미 사용중인 템플릿명 입니다.")
                return map
            }
        }

        map.put("status", HttpServletResponse.SC_OK)
        map.put("msg", "사용가능한 템플릿명 입니다.")

        return map
    }


    /**
     * @Method Name  : getAtTmpl
     * @Since    : 2022. 09. 22.
     * @author   : Belisa
     * @param    : req: HttpServletRequest
     * @param    : rep : HttpServletResponse
     * @param    : session : HttpSession
     * @return   : String
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 알림톡 탬플릿명 조회
     * @title : 알림톡 탬플릿 조회
     */
    @ResponseBody
    @PostMapping("/kko/getAtTmpl.ajax")
    fun getAtTmpl(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession, @ModelAttribute dto: AtTmpl_searchDto): MutableMap<String, Any>? {

        val map :MutableMap<String,Any> = mutableMapOf()

        val dto: Tblmi_kko_at_tmplDto? =kkoMsgService.getKkoAtTmplDto(dto)
        if(CommonUtils.isEmptyObject(dto)){
            rep.status= HttpServletResponse.SC_BAD_REQUEST
            return null
        }
        map.put("status" , HttpServletResponse.SC_OK)
        map.put("dto" , dto!!)
        return map
    }

    /**
     * @Method Name  : updateMoblieContent
     * @Since    : 2022. 10. 05.
     * @author   : Belisa
     * @param    : seq: Int
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 템플릿 수정 페이지
     * @title : 템플릿 수정 페이지
     */

    @GetMapping("/kko/tmplDetail.mi")
    fun detailTmplContent(@RequestParam("seq") seq : Int) : ModelAndView {
        val tblmiContMstdto = Tblmi_cont_mstDto()
        tblmiContMstdto.seq = seq
        val view = ModelAndView("cont/kko/detailTmpl")
        val map = kkoMsgService.tmplCreateLst();

        view.addObject("dto", kkoMsgService.selTmplDataBySeq(seq))
        view.addObject("cateLst",map["cateLst"]);
        view.addObject("cateSubLst",map["cateSubLst"])
        view.addObject("msgTpLst", map["msgTpLst"])
        view.addObject("empTpLst", map["empTpLst"])
        view.addObject("cateSubGidLst", map["cateSubGidLst"])
        view.addObject("btnLinkLst", map["btnLinkLst"])
        view.addObject("btnLst", map["btnLst"])

        view.addObject("column",sysSettingService.getDBValue())

        val commonCDDto = Tblmi_comm_cdDto()
        commonCDDto.grp_id = "COMMON"
        commonCDDto.cd_id = "UPURL01"
        val uploadPrefix = sysSettingService.getCommCD(commonCDDto)
        view.addObject("filePath", uploadPrefix?.cd_val)

        return view
    }


    /**
     * @Method Name  : tmplUpdateService
     * @Since    : 2022. 10. 05.
     * @author   : Belisa
     * @param    : req: HttpServletRequest
     * @param    : rep : HttpServletResponse
     * @param    : session : HttpSession
     * @return   :
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 알림톡 템플릿 수정
     * @title : 알림톡 템플릿 수정
     */
    @ResponseBody
    @PostMapping("/kko/tmplUpate.service")
    fun tmplUpdateService(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession
                          , @RequestBody dto : Kko_at_tmplDto, @RequestParam seq : Int, principal: Principal): Any? {
        val tmplDto :Tblmi_kko_at_tmplDto = Tblmi_kko_at_tmplDto(seq,principal.name,"Y")
        val map = kkoMsgService.updateTmpl(dto,tmplDto)
        return map
    }

}
