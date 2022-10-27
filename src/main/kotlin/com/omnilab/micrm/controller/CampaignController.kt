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
     * @Method Decription : 캠페인 > 캠페인 발송
     * @title : 캠페인 발송
     */
    @PostMapping("/sendCampContPreview.ajax")
    fun sendCampContPreview(@RequestParam("cont_id") cont_id: String, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val dto = Contents_searchDto(cont_id.toInt(), UsefulUtils.sessionUser().usr_grp_cd!!, "Y")
        val view = ModelAndView("camp/ajax/sendSettingPreview")
        view.addObject("dto", campaignServiceImpl.getCampContentPreview(dto))
        view.addObject("filePath", sysSettingService.getCommCD(Tblmi_comm_cdDto("COMMON", "UPURL01"))?.cd_val)
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


}
