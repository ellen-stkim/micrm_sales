package com.omnilab.micrm.controller

import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.UsrHst_searchDto
import com.omnilab.micrm.model.Usr_log_searchDto
import com.omnilab.micrm.model.Usr_searchDto
import com.omnilab.micrm.model.table.Tblmi_comm_cdDto
import com.omnilab.micrm.model.table.Tblmi_usrDto
import com.omnilab.micrm.service.CampaignService
import com.omnilab.micrm.service.SysSecurityService
import com.omnilab.micrm.service.SysSettingService
import com.omnilab.micrm.service.SysUserService
import org.springframework.stereotype.Controller
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.web.bind.annotation.*
import org.springframework.web.servlet.ModelAndView


@Controller
@RequestMapping("/sys/user")
class SysUserController {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    lateinit var sysUserService:SysUserService

    @Autowired
    lateinit var sysSettingService:SysSettingService

    @Autowired
    lateinit var sysSecurityService:SysSecurityService

    @Autowired
    @Qualifier("CampaignServiceImpl")
    private lateinit var campaignService : com.omnilab.micrm.service.CampaignService


    @GetMapping("/userManagement.mi")
    fun userManagement(): ModelAndView {
        val view = ModelAndView("sys/user/userManagement")

        //권한 목록 가져오기
        var cdDto : Tblmi_comm_cdDto = Tblmi_comm_cdDto()
        cdDto.grp_id = "ROLE_CD"
        val cdList = sysSettingService.getCommCDLst(cdDto);
        view.addObject("cdDto", cdList)
        //승인담당자 목록 가져오기
        val dto: Usr_searchDto = Usr_searchDto()
        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val map = sysUserService.getAllUserList(dto)
        view.addObject("uslist", map["list"])
        return view
    }
    @PostMapping("/getUserList.ajax")
    fun getUserList(@ModelAttribute("form") dto: Usr_searchDto): ModelAndView {
        val view = ModelAndView("sys/user/ajax/userList")
        val map = sysUserService.getUserList(dto)
        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])
        return view
    }
    @ResponseBody
    @PostMapping("/saveUser.ajax")
    fun saveUser(@ModelAttribute("form") dto: Usr_searchDto): MutableMap<String, Any> {
        val map = sysUserService.saveUser(dto)
        return map
    }

    @PostMapping("/userDetail.mi")
    fun userDetail(@ModelAttribute("form") dto: Usr_searchDto): ModelAndView {
        val view = ModelAndView("sys/user/userDetail")
        val map = sysUserService.getUserList(dto)
        view.addObject("list", map["list"])
        //권한 목록 가져오기
        var cdDto : Tblmi_comm_cdDto = Tblmi_comm_cdDto()
        cdDto.grp_id = "ROLE_CD"
        val cdList = sysSettingService.getCommCDLst(cdDto);
        view.addObject("cdDto", cdList)
        //승인담당자 목록 가져오기
        val searchDto: Usr_searchDto = Usr_searchDto()
        searchDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val userMap = sysUserService.getAllUserList(searchDto)
        view.addObject("uslist", userMap["list"])

        return view
    }

    @ResponseBody
    @PostMapping("/updateUsrSt.ajax")
    fun updateUsrSt(@ModelAttribute("form") dto: Usr_searchDto): MutableMap<String, Any> {
        val map = sysUserService.updateUsrSt(dto)
        return map
    }

    @PostMapping("/getUserLog.ajax")
    fun getUserLog(@ModelAttribute("form") dto: UsrHst_searchDto): ModelAndView {
        val view = ModelAndView("sys/user/ajax/userLog")
        val map = sysSecurityService.getAdminUserLog(dto)
        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])
        return view
    }

    @GetMapping("/myInfo.mi")
    fun myInfo(@ModelAttribute("form") dto: Usr_searchDto): ModelAndView {
        val view = ModelAndView("sys/user/userDetail")
        dto.usr_id = UsefulUtils.sessionUser().usr_id
        val map = sysUserService.getUserList(dto)
        view.addObject("list", map["list"])
        //권한 목록 가져오기
        var cdDto : Tblmi_comm_cdDto = Tblmi_comm_cdDto()
        cdDto.grp_id = "ROLE_CD"
        val cdList = sysSettingService.getCommCDLst(cdDto);
        view.addObject("cdDto", cdList)
        //승인담당자 목록 가져오기
        val searchDto: Usr_searchDto = Usr_searchDto()
        searchDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val userMap = sysUserService.getAllUserList(searchDto)
        view.addObject("uslist", userMap["list"])

        return view
    }
}
