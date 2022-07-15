package com.omnilab.micrm.controller

import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.Contents_searchDto
import com.omnilab.micrm.model.SendAuthLstDto
import com.omnilab.micrm.model.SendCampaignDto
import com.omnilab.micrm.model.Program_SearchDto
import com.omnilab.micrm.model.Group_SearchDto
import com.omnilab.micrm.model.SendTarget_lstDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.service.CampaignService
import com.omnilab.micrm.service.CommonService
import com.omnilab.micrm.service.MemberService
import com.omnilab.micrm.service.SysSettingService
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.*
import org.springframework.web.servlet.ModelAndView
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import javax.servlet.http.HttpSession
import kotlin.collections.HashMap


@Controller
@RequestMapping("/camp")
class CampaignController {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    @Qualifier("MemberServiceImpl")
    private lateinit var memberService: MemberService

    @Autowired
    @Qualifier("SysSettingServiceImpl")
    private lateinit var sysSettingService: SysSettingService

    @Autowired
    @Qualifier("CampaignServiceImpl")
    private lateinit var campaignServiceImpl: CampaignService

    @Autowired
    private lateinit var commonService: CommonService

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
        val prdMap = campaignServiceImpl.getTitleProgramCnt()

        paramMap["alarmCnt"] = sysSettingService.checkAlarmCnt().toString()
        paramMap["sendExpect"] = prdMap["sendExpect"].toString()
        paramMap["sending"] = prdMap["sending"].toString()
        paramMap["apprCnt"] = prdMap["apprCnt"].toString()

        return paramMap
    }

    /**
     * @Method Name  : sendSetting
     * @Since    : 2021. 03. 03.
     * @author   : Lucas
     * @param    : req - HttpServletRequest
     * @param    : rep - HttpServletResponse
     * @param    : sessoin - HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @serial   : CAMP_01
     * @see      :
     * @version  : 0.01
     * @Method Decription : 캠페인 > 캠페인 발송
     * @title : 캠페인 발송
     */
    @GetMapping("/sendSetting.mi")
    fun sendSetting(@RequestParam(value = "pid", required = false) pro_id: String?, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd!!
        val view = ModelAndView("camp/sendSetting")
        if(pro_id.isNullOrEmpty()){
            view.viewName = "camp/sendSetting"
        }else{
            view.viewName = "camp/sendSettingEdit"
            val map = campaignServiceImpl.getProgramInfo(pro_id, usr_grp_cd, true)
            if(map["status"] as Boolean){
                view.addObject("dto", map["programDto"])
                view.addObject("targetDto", map["targetDto"])
                view.addObject("campLst", map["campaignLst"])
                view.addObject("contLst", map["contDto"])
            }else{
                view.viewName = "PrintView"
                view.addObject("status", false)
                view.addObject("message", "캠페인이 수정 가능한 상태가 아닙니다.")
                view.addObject("redirect", "/camp/st/sendStatus.mi")
            }
        }
        val priceMap: MutableMap<String, Any> = HashMap()
        val priceLst = sysSettingService.getCommCDLst(Tblmi_comm_cdDto("API_PRICE", usr_grp_cd))
        for(i in priceLst){
            priceMap[i.cd_val!!.toLowerCase()] = i.cd_desc!!
        }
        view.addObject("TgCd", sysSettingService.getCommCDLst(Tblmi_comm_cdDto("TGTP")))
        view.addObject("CtCd", sysSettingService.getCommCDLst(Tblmi_comm_cdDto("COM0001")))

        val authLst = campaignServiceImpl.getApprLst(SendAuthLstDto(UsefulUtils.sessionUser().usr_grp_cd, listOf("R10")))
        view.addObject("authLst", authLst)

        val serachAppr = authLst.stream().filter {
            it.usr_id == UsefulUtils.sessionUser().appr_id
        }.toArray()

        if(!serachAppr.isNullOrEmpty()){
            view.addObject("apprInfo", serachAppr[0])
        }
        view.addObject("apiPrice", priceMap)
        return view
    }

    /**
     * @Method Name  : sendSettingTargetLst
     * @Since    : 2021. 03. 03.
     * @author   : Lucas
     * @param    : req - HttpServletRequest
     * @param    : rep - HttpServletResponse
     * @param    : sessoin - HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @serial   : CAMP_01
     * @see      :
     * @version  : 0.01
     * @Method Decription : 캠페인 > 캠페인 발송
     * @title : 캠페인 발송
     */
    @PostMapping("/sendTragetList.ajax")
    fun sendSettingTargetLst(@ModelAttribute groupDto: Group_SearchDto, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        groupDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        groupDto.use_yn = "Y"
        val view = ModelAndView("camp/ajax/sendSettingTargetLst")
        if(groupDto.searchType == "TG01"){ // DB 그룹
            val grpMap = memberService.selectGroupList(groupDto)
            view.addObject("list", grpMap["list"])
            view.addObject("page", grpMap["page"])
            view.addObject("pageNo", grpMap["pageNo"])
            view.addObject("listCnt", grpMap["listCnt"])
        }else {     // 업로드 그룹
            val grpMap = memberService.selectGroupList(groupDto)
            view.addObject("list", grpMap["list"])
            view.addObject("page", grpMap["page"])
            view.addObject("pageNo", grpMap["pageNo"])
            view.addObject("listCnt", grpMap["listCnt"])
        }
        return view
    }

    /**
     * @Method Name  : sendContList
     * @Since    : 2021. 03. 03.
     * @author   : Lucas
     * @param    : req - HttpServletRequest
     * @param    : rep - HttpServletResponse
     * @param    : sessoin - HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @serial   : CAMP_01
     * @see      :
     * @version  : 0.01
     * @Method Decription : 컨텐츠 리트스 목록 출력
     * @title : 캠페인 발송
     */
    @PostMapping("/sendContList.ajax")
    fun sendContList(@ModelAttribute dto: Contents_searchDto, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        dto.cont_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val view = ModelAndView("camp/ajax/sendSettingContLst")

        val map = campaignServiceImpl.getContentsLst(dto)
        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("filePath", sysSettingService.getCommCD(Tblmi_comm_cdDto("COMMON", "UPURL01"))?.cd_val)
        return view
    }

    /**
     * @Method Name  : sendSettingTargetLst
     * @Since    : 2021. 03. 03.
     * @author   : Lucas
     * @param    : req - HttpServletRequest
     * @param    : rep - HttpServletResponse
     * @param    : sessoin - HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @serial   : CAMP_01
     * @see      :
     * @version  : 0.01
     * @Method Decription : 캠페인 > 캠페인 발송
     * @title : 캠페인 발송
     */
    @PostMapping("/sendContPreview.ajax")
    fun contentPreview(@RequestParam("cont_id") cont_id: String, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val dto = Contents_searchDto(cont_id.toInt(), UsefulUtils.sessionUser().usr_grp_cd!!, "Y")
        val view = ModelAndView("camp/ajax/sendSettingPreview")
        view.addObject("dto", campaignServiceImpl.getContentPreview(dto))
        view.addObject("filePath", sysSettingService.getCommCD(Tblmi_comm_cdDto("COMMON", "UPURL01"))?.cd_val)
        return view
    }

    /**
     * @Method Name  : sendSettingTargetLst
     * @Since    : 2021. 03. 03.
     * @author   : Lucas
     * @param    : req - HttpServletRequest
     * @param    : rep - HttpServletResponse
     * @param    : sessoin - HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @serial   : CAMP_01
     * @see      :
     * @version  : 0.01
     * @Method Decription : 캠페인 > 캠페인 발송
     * @title : 캠페인 발송
     */
    @PostMapping("/sendCampContPreview.ajax")
    fun sendCampContPreview(@RequestParam("cont_id") cont_id: String, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val dto = Contents_searchDto(cont_id.toInt(), UsefulUtils.sessionUser().usr_grp_cd!!, "Y")
        val view = ModelAndView("camp/ajax/sendSettingPreview")
        view.addObject("dto", campaignServiceImpl.getCampContentPreview(dto))
        view.addObject("filePath", sysSettingService.getCommCD(Tblmi_comm_cdDto("COMMON", "UPURL01"))?.cd_val)
        logger.error("{}",campaignServiceImpl.getCampContentPreview(dto).msg_tp)
        return view
    }

    /**
     * @Method Name  : sendSettingTargetLst
     * @Since    : 2021. 03. 03.
     * @author   : Lucas
     * @param    : req - HttpServletRequest
     * @param    : rep - HttpServletResponse
     * @param    : sessoin - HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @serial   : CAMP_01
     * @see      :
     * @version  : 0.01
     * @Method Decription : 캠페인 > 캠페인 테스트 발송
     * @title : 캠페인 테스트 발송
     */
    @ResponseBody
    @PostMapping("/sendTest.ajax")
    fun testSend(@ModelAttribute dto: SendTarget_lstDto, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): MutableMap<String, Any> {
        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        dto.reg_id = UsefulUtils.sessionUser().usr_id
        dto.pro_tp = "TEST"
        dto.pro_tg_tp = "TEST"
        dto.pro_tg_id = "0"
        dto.appr_id = UsefulUtils.sessionUser().usr_id
        return campaignServiceImpl.sendProgramTargetLst(dto)
    }

    /**
     * @Method Name  : sendSettingTargetLst
     * @Since    : 2021. 03. 03.
     * @author   : Lucas
     * @param    : req - HttpServletRequest
     * @param    : rep - HttpServletResponse
     * @param    : sessoin - HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @serial   : CAMP_01
     * @see      :
     * @version  : 0.01
     * @Method Decription : 캠페인 > 캠페인 임시저장
     * @title : 캠페인 임시 저장
     */
    @ResponseBody
    @PostMapping("/sendTempCreate.ajax")
    fun tempcreateSend(@ModelAttribute dto: SendCampaignDto, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): MutableMap<String, Any> {
        dto.pro_tp = "CAMP"
        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        dto.reg_id = UsefulUtils.sessionUser().usr_id
        return campaignServiceImpl.sendTempProgram(dto)
    }

    /**
     * @Method Name  : sendSettingTargetLst
     * @Since    : 2021. 03. 03.
     * @author   : Lucas
     * @param    : req - HttpServletRequest
     * @param    : rep - HttpServletResponse
     * @param    : sessoin - HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @serial   : CAMP_01
     * @see      :
     * @version  : 0.01
     * @Method Decription : 캠페인 > 캠페인 생성
     * @title : 캠페인 테스트 발송
     */
    @PostMapping("/sendCreate.service")
    fun createSend(@ModelAttribute dto: SendCampaignDto, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        dto.pro_tp = "CAMP"
        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        dto.reg_id = UsefulUtils.sessionUser().usr_id

        val map =  campaignServiceImpl.sendProgram(dto)

        val view = ModelAndView("PrintView")
        view.addObject("status", map["status"])
        view.addObject("message", map["message"])
        view.addObject("redirect", "/camp/st/sendStatus.mi")
        return view
    }

    /**
     * @Method Name  : sendSettingTargetLst
     * @Since    : 2021. 03. 03.
     * @author   : Lucas
     * @param    : req - HttpServletRequest
     * @param    : rep - HttpServletResponse
     * @param    : sessoin - HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @serial   : CAMP_01
     * @see      :
     * @version  : 0.01
     * @Method Decription : 캠페인 > 캠페인 생성
     * @title : 캠페인 테스트 발송
     */
    @PostMapping("/rejectSend.service")
    fun rejectSend(@RequestParam("pro_id") pro_id: String, @RequestParam("message") message: String, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd!!
        val usr_id = UsefulUtils.sessionUser().usr_id!!
        val map = campaignServiceImpl.sendReject(pro_id, usr_id, usr_grp_cd, message)
        val view = ModelAndView("PrintView")
        view.addObject("status", map["status"])
        view.addObject("message", map["message"])
        view.addObject("redirect", "/camp/st/sendStatus.mi")
        return view
    }

    /**
     * @Method Name  : sendSettingTargetLst
     * @Since    : 2021. 03. 03.
     * @author   : Lucas
     * @param    : req - HttpServletRequest
     * @param    : rep - HttpServletResponse
     * @param    : sessoin - HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @serial   : CAMP_01
     * @see      :
     * @version  : 0.01
     * @Method Decription : 캠페인 > 캠페인 생성
     * @title : 캠페인 테스트 발송
     */
    @PostMapping("/inquirySend.service")
    fun inquirySend(@RequestParam map: MutableMap<String, Any>, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        map["usr_grp_cd"] = UsefulUtils.sessionUser().usr_grp_cd.toString()
        map["usr_id"] = UsefulUtils.sessionUser().usr_id.toString()
        map["usr_nm"] = UsefulUtils.sessionUser().usr_nm.toString()
        map["usr_email"] = UsefulUtils.sessionUser().usr_email.toString()

        val re_map = campaignServiceImpl.sendInquiry(map)
        val view = ModelAndView("PrintView")
        view.addObject("status", re_map["status"])
        view.addObject("message", re_map["message"])
        view.addObject("redirect", "/camp/st/sendStatus.mi")
        return view
    }

    /**
     * @Method Name  : sendStatus
     * @Since    : 2021. 03. 03.
     * @author   : Lucas
     * @param    : req - HttpServletRequest
     * @param    : rep - HttpServletResponse
     * @param    : sessoin - HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @serial   : CAMP_02
     * @see      :
     * @version  : 0.01
     * @Method Decription : 캠페인 > 발송 현황
     * @title : 발송 현황
     */
    @GetMapping("/st/sendStatus.mi")
    fun sendStatus(@ModelAttribute dto:Program_SearchDto,req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val view = ModelAndView("camp/sendStatus")
        val map = campaignServiceImpl.getProgramSearch(dto)
        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])
        view.addObject("protp",dto.pro_tp)
        view.addObject("protgtp",dto.pro_tg_tp)
        view.addObject("searchType",dto.searchType)
        view.addObject("searchValue",dto.searchValue)
        view.addObject("stdt",dto.st_dt)
        view.addObject("enddt",dto.end_dt)
        val paramMap = campaignServiceImpl.getAllStatusCnt(dto)
        view.addObject("tempSave",paramMap["temp_cnt"])
        view.addObject("waitAppo",paramMap["aw_cnt"])
        view.addObject("waitSend",paramMap["wait_cnt"])
        view.addObject("targeting",paramMap["tar_cnt"])
        view.addObject("sending",paramMap["send_cnt"])
        view.addObject("success",paramMap["suc_cnt"])
        view.addObject("error",paramMap["err_cnt"])
        return view
    }

    /**
     * @Method Name  : sendDetail
     * @Since    : 2021. 03. 03.
     * @author   : Lucas
     * @param    : req - HttpServletRequest
     * @param    : rep - HttpServletResponse
     * @param    : sessoin - HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @serial   : CAMP_03
     * @see      :
     * @version  : 0.01
     * @Method Decription : 캠페인 > 발송 현황 > 캠페인 상세
     * @title : 캠페인 상세
     */
    @GetMapping("/st/sendDetail.mi")
    fun sendDetail(@RequestParam(value = "pid", required = true) pro_id: String, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd!!
        val view = ModelAndView("camp/sendDetail")
        val map = campaignServiceImpl.getProgramInfo(pro_id, usr_grp_cd, false)
        view.addObject("dto", map["programDto"])
        view.addObject("targetDto", map["targetDto"])
        view.addObject("campLst", map["campaignLst"])
        view.addObject("contLst", map["contDto"])
        view.addObject("sendCnt", map["sendCnt"])
        view.addObject("openCnt", map["openCnt"])
        view.addObject("trackCnt", map["trackCnt"])
        return view
    }

    /**
     * @Method Name  : sendSettingTargetLst
     * @Since    : 2021. 03. 03.
     * @author   : Lucas
     * @param    : req - HttpServletRequest
     * @param    : rep - HttpServletResponse
     * @param    : sessoin - HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @serial   : CAMP_01
     * @see      :
     * @version  : 0.01
     * @Method Decription : 캠페인 > 캠페인 생성
     * @title : 캠페인 테스트 발송
     */
    @ResponseBody
    @PostMapping("/changeCamp.ajax")
    fun rejectSend(@RequestParam("pro_id") pro_id: String, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): Boolean {
        val usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd!!
        return campaignServiceImpl.editProgramSt(pro_id, usr_grp_cd)
    }

    /**
     * @Method Name  : sendSettingTargetLst
     * @Since    : 2021. 03. 03.
     * @author   : Lucas
     * @param    : req - HttpServletRequest
     * @param    : rep - HttpServletResponse
     * @param    : sessoin - HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @serial   : CAMP_01
     * @see      :
     * @version  : 0.01
     * @Method Decription : 캠페인 > 캠페인 생성
     * @title : 캠페인 테스트 발송
     */
    @ResponseBody
    @PostMapping("/apprCamp.ajax")
    fun apprCamp(@RequestParam("pro_id") pro_id: String, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): MutableMap<String, Any> {
        val usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd!!
        val usr_id = UsefulUtils.sessionUser().usr_id!!
        return campaignServiceImpl.apprProgramSt(pro_id, usr_id, usr_grp_cd)
    }

    /**
     * @Method Name  : sendSettingTargetLst
     * @Since    : 2021. 03. 03.
     * @author   : Lucas
     * @param    : req - HttpServletRequest
     * @param    : rep - HttpServletResponse
     * @param    : sessoin - HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @serial   : CAMP_01
     * @see      :
     * @version  : 0.01
     * @Method Decription : 캠페인 > 캠페인 생성
     * @title : 캠페인 테스트 발송
     */
    @ResponseBody
    @PostMapping("/cancelCamp.ajax")
    fun cancelCamp(@RequestParam("pro_id") pro_id: String, @RequestParam("gbn") gbn:String, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): MutableMap<String, Any> {
        val usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd!!
        val usr_id = UsefulUtils.sessionUser().usr_id!!
        return campaignServiceImpl.cancelProgramSt(pro_id, usr_id, usr_grp_cd, gbn)
    }


    /**
     * @Method Name  : sendSettingTargetLst
     * @Since    : 2021. 03. 03.
     * @author   : Lucas
     * @param    : req - HttpServletRequest
     * @param    : rep - HttpServletResponse
     * @param    : sessoin - HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @serial   : CAMP_01
     * @see      :
     * @version  : 0.01
     * @Method Decription : 캠페인 > 캠페인 생성
     * @title : 캠페인 테스트 발송
     */
    @ResponseBody
    @PostMapping("/delCamp.ajax")
    fun delCamp(@RequestParam("pro_id") pro_id: String, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): MutableMap<String, Any> {
        val usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd!!
        val usr_id = UsefulUtils.sessionUser().usr_id!!
        return campaignServiceImpl.delProgram(pro_id, usr_id, usr_grp_cd)
    }

    //DB 회원 검색
    /**
     * @Method Name  : getSearchSendStatus
     * @Since    : 2021. 03. 03.
     * @author   : andy
     * @param    : req - HttpServletRequest
     * @param    : rep - HttpServletResponse
     * @param    : sessoin - HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @serial   :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 캠페인 > 발송 현황 paging, search
     * @title : 캠페인 상세
     */
    @ResponseBody
    @PostMapping("/getSearchSendStatus.ajax")
    fun getTblmitblSearch(@ModelAttribute("form") dto: Program_SearchDto): ModelAndView {
        val view = ModelAndView("camp/ajax/sendStatusList")
        val map = campaignServiceImpl.getProgramSearch(dto)
        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])

        val paramMap = campaignServiceImpl.getAllStatusCnt(dto)
        view.addObject("tempSave",paramMap["temp_cnt"])
        view.addObject("waitAppo",paramMap["aw_cnt"])
        view.addObject("waitSend",paramMap["wait_cnt"])
        view.addObject("targeting",paramMap["tar_cnt"])
        view.addObject("sending",paramMap["send_cnt"])
        view.addObject("success",paramMap["suc_cnt"])
        view.addObject("error",paramMap["err_cnt"])
        return view
    }

    /**
     * @Method Name  : getSendHst
     * @Since    : 2021. 03. 03.
     * @author   : andy
     * @param    : req - HttpServletRequest
     * @param    : rep - HttpServletResponse
     * @param    : sessoin - HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @serial   :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 캠페인 > TEST 발송 결과 가져오기
     * @title : 캠페인 상세
     */
    @ResponseBody
    @PostMapping("/getSendHst.ajax")
    fun getSendHst(@RequestParam(value = "pid", required = true) pro_id: String, @RequestParam(value = "type", required = false) type: String?): ModelAndView {
        val map = campaignServiceImpl.getProgramSendResult(pro_id, type, UsefulUtils.sessionUser().usr_grp_cd!!)
        val view = ModelAndView("camp/ajax/sendDetailPop")
        view.addObject("cnt", map["cnt"])
        view.addObject("list", map["list"])
        return view
    }

    /**
     * @Method Name  : getSendHst
     * @Since    : 2021. 03. 03.
     * @author   : andy
     * @param    : req - HttpServletRequest
     * @param    : rep - HttpServletResponse
     * @param    : sessoin - HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @serial   :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 캠페인 > TEST 발송 결과 가져오기
     * @title : 캠페인 상세
     */
    @PostMapping("/getSendHstDown.service")
    fun getSendHstDown(@RequestParam(value = "pid", required = true) pro_id: String, @RequestParam(value = "type", required = false) type: String?): ModelAndView {
        val map = campaignServiceImpl.getProgramSendResultExcel(pro_id, type, UsefulUtils.sessionUser().usr_grp_cd!!)
        val view = ModelAndView("ExcelDownView")
        view.addObject("name", map["name"])
        view.addObject("book", map["book"])
        return view
    }

    /**
     * @Method Name  : tgLst
     * @Since    : 2021. 04. 20.
     * @author   : lucas
     * @param    : req - HttpServletRequest
     * @param    : rep - HttpServletResponse
     * @param    : sessoin - HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @serial   :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 캠페인 > 타겟팅
     * @title : 타겟팅 리스트
     */
    @GetMapping("/tg/tgLst.mi")
    fun tgLst(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val view = ModelAndView("/camp/tgLst")
        return view
    }

    /**
     * @Method Name  : tgLst
     * @Since    : 2021. 04. 20.
     * @author   : lucas
     * @param    : req - HttpServletRequest
     * @param    : rep - HttpServletResponse
     * @param    : sessoin - HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @serial   :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 캠페인 > 타겟팅
     * @title : 타겟팅 리스트
     */
    @GetMapping("/tg/tgTab.ajax")
    fun tgTab(@RequestParam("prefix") prefix: String, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val map = campaignServiceImpl.getTargetInfo(UsefulUtils.sessionUser().usr_grp_cd!!)
        val view = ModelAndView("camp/ajax/tgTab")
        view.addObject("prefix", prefix)
        view.addObject("tableauUrl", map["tableauUrl"])
        return view
    }

    /**
    * @Method Name  : tgCreate
    * @Since    : 2021. 04. 20.
    * @author   : lucas
    * @param    : req - HttpServletRequest
    * @param    : rep - HttpServletResponse
    * @param    : sessoin - HttpSession
    * @return   : ModelAndView
    * @excetion :
    * @serial   :
    * @see      :
    * @version  : 0.01
    * @Method Decription : 캠페인 > 타겟팅
    * @title : 타겟팅 리스트
    */
   @GetMapping("/tg/tgCreate.mi")
   fun tgCreate(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val view = ModelAndView("/camp/tgCreate")
        return view
   }


    /**
     * @Method Name  : getSendHst
     * @Since    : 2021. 05. 06.
     * @author   : andy
     * @param    : req - HttpServletRequest
     * @param    : rep - HttpServletResponse
     * @param    : sessoin - HttpSession
     * @return   : ModelAndView
     * @excetion :
     * @serial   :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 캠페인 > 캠페인명 중복 체크하기
     * @title : 캠페인명 중복 체크하기
     */

    @ResponseBody
    @PostMapping("/isCheckProNm.ajax")
    fun isCheckProNm(@ModelAttribute dto : Tblmicp_programDto) : Map<String,Any> {
        return campaignServiceImpl.isCheckProNm(dto)
    }


}
