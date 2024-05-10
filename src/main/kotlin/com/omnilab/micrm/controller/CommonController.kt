package com.omnilab.micrm.controller

import com.omnilab.micrm.model.table.Tblmi_comm_cdDto
import com.omnilab.micrm.model.table.Tblmicp_campaignDto
import com.omnilab.micrm.service.MemberService
import com.omnilab.micrm.service.SysSettingService
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.security.core.Authentication
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.*
import org.springframework.web.servlet.ModelAndView

import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import javax.servlet.http.HttpSession

@Controller
class CommonController {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    @Qualifier("MemberServiceImpl")
    private lateinit var memberService: MemberService

    @Autowired
    @Qualifier("SysSettingServiceImpl")
    lateinit var sysSettingService: SysSettingService;

    @Autowired
    @Qualifier("CampaignServiceImpl")
    private lateinit var campaignService : com.omnilab.micrm.service.CampaignService


    @GetMapping("/index.mi")
    fun index(auth: Authentication?): ModelAndView {
        val view = ModelAndView("index")
        if (auth != null) {
            view.viewName = "redirect:/home.mi"
        }
        return view
    }

    /**
     * @Method Name  : home
     * @Since    : 2021. 04. 14.
     * @author   : Andy
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : home 화면 Dashboard 가져오기
     * @title : Dashboard 가져오기
     */
    @GetMapping("/home.mi")
    fun home(req: HttpServletRequest, session: HttpSession): ModelAndView {
        val view = ModelAndView("home")
       /* val map = campaignService.getMainDashBoardReport(dto)*/
        val map =  memberService.getTblTblSum()
        view.addObject("tblSum", map["tblSum"])
        view.addObject("tblSumCk", map["tblSumCk"])
        return view
    }


    /**
     * @Method Name  : getMainCampView
     * @Since    : 2021. 04. 14.
     * @author   : Andy
     * @return   : Map
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : home 화면 캠페인 미리보기 가져오기
     * @title :
     */
    @PostMapping("/getMainCampView.ajax")
    fun getMainCampView(@ModelAttribute dto: Tblmicp_campaignDto): ModelAndView {
        val view = ModelAndView("camp/ajax/homeCampPreview")
        val resultMap =  campaignService.getMainCampView(dto);
        view.addObject("startDt", dto.start_dt)
        view.addObject("tarCnt", dto.tar_cnt)
        view.addObject("campId", dto.seq)
        view.addObject("campST", dto.camp_st)
        view.addObject("campTitle", dto.camp_nm)
        view.addObject("programId", dto.pro_id)
        view.addObject("camp", resultMap["camp"])
        view.addObject("sendCnt", resultMap["sendCnt"])
        view.addObject("openCnt", resultMap["openCnt"])
        view.addObject("trackCnt", resultMap["trackCnt"])
        view.addObject("filePath", sysSettingService.getCommCD(Tblmi_comm_cdDto("COMMON", "UPURL01"))?.cd_val.toString())

        return view
    }
    /**
     * @Method Name  : getCampInfo
     * @Since    : 2021. 04. 14.
     * @author   : Andy
     * @return   : Map
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : home 화면 캠페인 날짜별 가져오기.
     * @title :
     */
    @ResponseBody
    @PostMapping("/getCampInfo.ajax")
    fun getCampInfo(@RequestParam(value = "startDate")startDate: String, @RequestParam(value = "endDate")endDate: String ):List<Tblmicp_campaignDto> {
        val dto = Tblmicp_campaignDto()
        dto.start_dt = startDate
        dto.end_dt = endDate
        val map = campaignService.getCampList(dto);
        val listCamp = map["list"] as List<Tblmicp_campaignDto>
        return listCamp
    }

    @RequestMapping("/error/error.mi")
    fun errorCon(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): String {
        try{
            val throwable = req.getAttribute("javax.servlet.error.exception") as Throwable?
            val statusCode = req.getAttribute("javax.servlet.error.status_code") as Int
            var servletName = req.getAttribute("javax.servlet.error.servlet_name") as String?
            if (servletName == null) {
                servletName = "Unknown"
            }
            var requestUri = req.getAttribute("javax.servlet.error.request_uri") as String?
            if (requestUri == null) {
                requestUri = "Unknown"
            }
            logger.error("##### Error information #####")
            logger.error("The status code : {}", statusCode)
            logger.error("Servlet Name : {}", servletName)
            logger.error("The request URI: {}", requestUri)
            logger.error("ERROR : ", throwable)
            logger.error("#########################")
        }catch (e: Exception) {
            logger.error("EROOR Controller", e)
        }
        return "redirect:/home.mi"
    }

}