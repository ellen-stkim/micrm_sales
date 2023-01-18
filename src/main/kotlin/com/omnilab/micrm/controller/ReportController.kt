package com.omnilab.micrm.controller

import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.Program_SearchDto
import com.omnilab.micrm.model.SendReportDto
import com.omnilab.micrm.model.table.Tblmi_comm_cdDto
import com.omnilab.micrm.service.ReportService
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

@Controller
class ReportController {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    @Qualifier("ReportServiceImpl")
    private lateinit var reportService: ReportService

    @Autowired
    @Qualifier("SysSettingServiceImpl")
    private lateinit var sysSettingService: SysSettingService



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
    @GetMapping("/report/main.mi")
    fun home(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val view = ModelAndView("report/main")
        val map = reportService.getReportLst(UsefulUtils.sessionUser().usr_grp_cd!!)
        view.addObject("tableauUrl", map["tableauUrl"])
        return view
    }

    @GetMapping("/report/all.mi")
    fun all(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession, @ModelAttribute dto: Program_SearchDto): ModelAndView {
        val view = ModelAndView("report/campResult")

        val map : MutableMap<String, Any> =  reportService.getTotalCampMstList(dto)
        view.addObject("searchType", dto.searchType)
        view.addObject("searchValue", dto.searchValue)
        view.addObject("stdt", dto.st_dt)
        view.addObject("enddt", dto.end_dt)

        view.addObject("programLst", map["programLst"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])

        return view
    }


    @PostMapping("report/reportAjax.ajax")
    fun reportAjax(@ModelAttribute dto: Program_SearchDto): ModelAndView {

        val view = ModelAndView("report/ajax/reportAjax")
        val map : MutableMap<String, Any> =  reportService.getTotalCampMstList(dto)
        view.addObject("pro_tg_tp", dto.pro_tg_tp)
        view.addObject("searchType", dto.searchType)
        view.addObject("searchValue", dto.searchValue)
        view.addObject("stdt", dto.st_dt)
        view.addObject("enddt", dto.end_dt)
        view.addObject("programLst", map["programLst"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])
        view.addObject("listCnt", map["listCnt"])

        return view
    }

    @PostMapping("/report/dt.mi")
    fun detail(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val view = ModelAndView("report/campDt")
        val cont_seq: Array<String> = req.getParameterValues("cont_seq")

        val map : MutableMap<String, Any> =  reportService.getCampMstTotalDetail(cont_seq)
        view.addObject("cont_seq", cont_seq)
        view.addObject("totalResult", map["totalResult"])
        view.addObject("programLst", map["programLst"])

        return view
    }

    @GetMapping("/report/proDt.mi")
    fun proDt(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession, @RequestParam pro_id : String): ModelAndView {
        val view = ModelAndView("report/campDt")

        val campIds  = reportService.getCampMstContIdByProId(pro_id)!!.toTypedArray()
        val map : MutableMap<String, Any> =  reportService.getCampMstTotalDetail(campIds)
        view.addObject("cont_seq", campIds)
        view.addObject("totalResult", map["totalResult"])
        view.addObject("programLst", map["programLst"])

        return view
    }

    @GetMapping("/report/singleDt.mi")
    fun singleDt(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession, @RequestParam seq : String): ModelAndView {
        val view = ModelAndView("report/campDt")
        var seqs: Array<String> = arrayOf(seq)

        val map : MutableMap<String, Any> =  reportService.getCampMstTotalDetail(seqs)
        view.addObject("cont_seq", seqs)
        view.addObject("totalResult", map["totalResult"])
        view.addObject("programLst", map["programLst"])
        return view
    }


    @ResponseBody
    @PostMapping("/report/getSucTabAjax.ajax")
    fun DetSuc(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession, @RequestParam( required = false,   value="cont_seq[]") cont_seq : Array<String>): List<SendReportDto> {
        return  reportService.getSucTab(cont_seq)
    }

    @ResponseBody
    @PostMapping("/report/getOpenTabAjax.ajax")
    fun getOpenTab(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession , @RequestParam( required = false,   value="cont_seq[]") cont_seq : Array<String> ): List<Any?> {
        return  reportService.getDetOpenDet(cont_seq)
    }
    @ResponseBody
    @PostMapping("/report/getClickTabAjax.ajax")
    fun ClickTab(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession, @RequestParam( required = false,   value="cont_id") cont_id : Int
                 , @RequestParam( required = false,   value="camp_nm") camp_nm : String ): ModelAndView {

        val view= ModelAndView("report/ajax/reportSendPreview")
        val mapLst  =reportService.getClickList(cont_id)
        val filePath= sysSettingService.getCommCD(Tblmi_comm_cdDto("COMMON", "UPURL01"))?.cd_val
        view.addObject("cont_seq", cont_id)
        view.addObject("camp_nm", camp_nm)
        view.addObject("list", mapLst)
        view.addObject("filePath", filePath)

        return  view
    }


}