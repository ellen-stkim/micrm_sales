package com.omnilab.micrm.controller

import com.omnilab.micrm.common.FileUploadUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.*
import com.omnilab.micrm.model.table.Tblmi_comm_cdDto
import com.omnilab.micrm.model.table.Tblmi_cont_imgDto
import com.omnilab.micrm.model.table.Tblmi_cont_lstDto
import com.omnilab.micrm.model.table.Tblmi_cont_mstDto
import com.omnilab.micrm.service.CampaignService
import com.omnilab.micrm.service.ContentService
import com.omnilab.micrm.service.ImageService
import com.omnilab.micrm.service.SysSettingService
import org.apache.commons.io.FilenameUtils
import org.json.simple.JSONObject
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
    lateinit var fileUpload: FileUploadUtils;

    @Value("\${upload.content}")
    private val filePath: String? = null


    /**
     * @Method Name  : titleCnt
     * @Since    : 2021. 03. 25.
     * @author   : Grayson
     * @return   : Map<String,String>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 상위 타이틀 개수 구하기
     * @title : 상위 타이틀 개수 구하기
     */
    @ModelAttribute("titleCnt")
    fun titleCnt() : Map<String,String> {
        val paramMap : MutableMap<String,String> = HashMap();
        val prdMap = campaignService.getTitleProgramCnt()

        paramMap["alarmCnt"] = sysSettingService.checkAlarmCnt().toString()
        paramMap["sendExpect"] = prdMap["sendExpect"].toString()
        paramMap["sending"] = prdMap["sending"].toString()
        paramMap["apprCnt"] = prdMap["apprCnt"].toString()

        return paramMap
    }


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
        val map = sysSettingService.getDBValue();

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
        view.addObject("columnValue",map["columnValue"]);
        view.addObject("columnNm",map["columnNm"]);
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
        val map = sysSettingService.getDBValue();
        val listMap = mobileContentService.selectOneContentView(tblmiContMstdto)
        val cntMap = mobileContentService.isCheckSender()

        view.addObject("list" , listMap["list"])
        view.addObject("columnValue",map["columnValue"]);
        view.addObject("columnNm",map["columnNm"]);
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
    fun previewService(@ModelAttribute dto : Content_list_CreateDto) : ModelAndView {
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
        if(formatList!!.contains("rcs")) {
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
     * @Method Name  : edmCreate
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : req: : HttpServletRequest
     * @param    : rep: : HttpServletResponse
     * @param    : session : HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이메일 리스트 생성 뷰 페이지
     * @title : 이메일 리스트 조회 하기
     */
    @GetMapping("/edmCreate.mi")
    fun edmCreate(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val view = ModelAndView("cont/edmCreate")
        val map = sysSettingService.getDBValue();
        view.addObject("columnValue",map["columnValue"]);
        view.addObject("columnNm",map["columnNm"]);

        val dto = SetLst_searchDto()
        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        dto.list_tp_id = "CH01"
        dto.list_dt_id = "DMTP01"
        dto.def_yn = "Y"
        val sendList = mobileContentService.selectSenderList(dto)
        view.addObject("slist", sendList["list"])
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
        //val dto : Tblmi_cont_imgDto = Tblmi_cont_imgDto()
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
            map["imgCheck"] = 1
            val userInfo = UsefulUtils.sessionUser()
            var contentFilePath = filePath + "/"+ userInfo.usr_grp_cd
            map = fileUpload.upload(contentFilePath, file, request);
            if(map["uploaded"].toString() == "0"){
                logger.info("File Upload fail")
            }else{
                if(dto.ch_tp != "IMGTP01"){
                    val fileName = map["file_nm"]
                    var image : BufferedImage = ImageIO.read(file.inputStream)
                    val imageWidth: Int = image.getWidth()
                    val imageHeight: Int = image.getWidth()
                    if(image.getWidth() < 500 || image.getHeight() < 250) {

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

                        ImageIO.write(newImage, "jpg", File(FilenameUtils.getFullPath(contentFilePath + "/" + fileName), FilenameUtils.getName(contentFilePath + "/" + fileName)))

                        resizeImage.flush()
                        image.flush()
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

    /**
     * @Method Name  : updateImgYn
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : dto : Tblmi_cont_mstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이메일 컨텐츠 상세 페이지
     * @title : 이메일 컨텐츠 상세 페이지
     */
    @PostMapping("/edmDetail.mi")
    fun detailEdm(@ModelAttribute dto : Tblmi_cont_mstDto): ModelAndView {
        val view = ModelAndView("cont/detailEdm")
        val tempDto : Contents_searchDto = Contents_searchDto()
        tempDto.seq = dto.seq
        val resuleMap =  emailContentService.selectOneContentView(tempDto)
        view.addObject("list",resuleMap["list"])

        val map = sysSettingService.getDBValue();
        view.addObject("columnValue",map["columnValue"]);
        view.addObject("columnNm",map["columnNm"]);
        return view
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


    /**
     * @Method Name  : checkContNm
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @param    : dto : Tblmi_cont_mstDto
     * @return   : Int
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 이메일 컨텐츠 캠페인 이름 조회
     * @title : 이메일 컨텐츠 캠페인 이름 조회
     */

    @ResponseBody
    @RequestMapping("/checkContNm.ajax")
    fun checkContNm(@ModelAttribute dto : Tblmi_cont_mstDto): Int {
        return emailContentService.checkContNm(dto);
    }

    // ========================= SYS ==============================//

    //DB 개인화변수.
    @ResponseBody
    @PostMapping("/getDBValue.ajax")
    fun getDBValue(@ModelAttribute  dto : Tblmi_cont_imgDto): Map<String, Any> {
        return sysSettingService.getDBValue();
    }

}