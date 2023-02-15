package com.omnilab.micrm.controller

import com.omnilab.micrm.model.Program_SearchDto
import com.omnilab.micrm.repository.ContentDao
import com.omnilab.micrm.service.CampaignService
import com.omnilab.micrm.service.CostReportService
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.*
import org.springframework.web.servlet.ModelAndView
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import javax.servlet.http.HttpSession

@RequestMapping("/cost")
@Controller
class CostController {

    private val logger = LoggerFactory.getLogger(CostController::class.java)

    @Autowired
    @Qualifier("CostReportServiceImpl")
    private lateinit var costReportService: CostReportService

    @GetMapping("/costDetail.mi")
    fun costDetail(@ModelAttribute dto: Program_SearchDto, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val view = ModelAndView("cost/costDetail")
        val map = costReportService.getCostReport()
        view.addObject("totalMap",map["totalMap"])
        view.addObject("programMap",map["programMap"])
        return view
    }

    @ResponseBody
    @GetMapping("/costDetail.ajax")
    fun costDetailAjax(@ModelAttribute dto: Program_SearchDto, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession): ModelAndView {
        val view = ModelAndView("cost/costDetail")
        return view
    }


}