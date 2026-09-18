package com.omnilab.micrm.controller

import com.omnilab.micrm.model.Group_SearchDto
import com.omnilab.micrm.service.CampaignService
import com.omnilab.micrm.service.MemberService
import com.omnilab.micrm.service.SysSettingService
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.ModelAttribute
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.servlet.ModelAndView


@Controller
@RequestMapping("/mbr")
class MemberController {
    
    val logger = LoggerFactory.getLogger(this::class.java)
    
    @Autowired
    @Qualifier("MemberServiceImpl")
    private lateinit var memberService: MemberService
    
    @Autowired
    @Qualifier("SysSettingServiceImpl")
    private lateinit var sysSettingService: SysSettingService
    
    @Autowired
    @Qualifier("CampaignServiceImpl")
    private lateinit var campaignService: CampaignService
    
    
    @GetMapping("/campmbr.mi")
    fun campmbr(@ModelAttribute dto : Group_SearchDto): ModelAndView {
        val view = ModelAndView("mbr/campmbr")
        val grpMap = memberService.selectGroupList(dto)

        view.addObject("list", grpMap["list"])
        view.addObject("page", grpMap["page"])
        view.addObject("pageNo", grpMap["pageNo"])
        view.addObject("listCnt", grpMap["listCnt"])
        view.addObject("searchType",dto.searchType)
        view.addObject("searchValue",dto.searchValue)
        view.addObject("reg_dt",dto.reg_dt)
        view.addObject("reg_dt_range",dto.reg_dt_range)
        view.addObject("upd_dt",dto.upd_dt)
        view.addObject("upd_dt_range",dto.upd_dt_range)

        return view
    }
}