package com.omnilab.micrm.controller

import com.omnilab.micrm.model.WorkSearch_Dto
import com.omnilab.micrm.model.table.Tblmi_workDto
import com.omnilab.micrm.service.CampaignService
import com.omnilab.micrm.service.SysSettingService
import com.omnilab.micrm.service.SysWorkService
import org.springframework.stereotype.Controller
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.web.bind.annotation.*
import org.springframework.web.servlet.ModelAndView

@Controller
@RequestMapping("/sys/work")
class SysWorkController {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    lateinit var sysWorkService:SysWorkService

    @Autowired
    @Qualifier("CampaignServiceImpl")
    private lateinit var campaignService : CampaignService

    @Autowired
    @Qualifier("SysSettingServiceImpl")
    private lateinit var sysSettingService: SysSettingService


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

    @GetMapping("/workList.mi")
    fun workList(): ModelAndView {
        val view = ModelAndView("sys/work/workList")
        return view
    }

    @PostMapping("/getWorkList.ajax")
    fun getWorkList(@ModelAttribute("form") dto: WorkSearch_Dto): ModelAndView {
        val view = ModelAndView("sys/work/ajax/workListAjax")
        val map = sysWorkService.getWorkList(dto)
        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])
        return view
    }
}
