package com.omnilab.micrm.controller

import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.*
import com.omnilab.micrm.service.SysSecurityService
import org.springframework.stereotype.Controller
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.web.bind.annotation.*
import org.springframework.web.servlet.ModelAndView


@Controller
@RequestMapping("/sys/security")
class SysIpSecurityController {

    @Autowired
    @Qualifier("SysSecurityServiceImpl")
    private lateinit var sysSecurityService: SysSecurityService
    val logger = LoggerFactory.getLogger(this::class.java)

    /**
     * @Method Name  : adminIpBlockSecurity
     * @Since    : 2021. 03.30
     * @author   : Andy
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 관리자 보안 ip 차단 리스트 가져오기
     * @title : 보안 IP차단
     */
    @GetMapping("/adminIpBlockSecurity.mi")
    fun adminIpBlockSecurity(): ModelAndView {
        val view = ModelAndView("sys/security/adminIpBlockSecurity")
        var dto : Block_searchDto = Block_searchDto()
        dto.block_status = "0"
        val map = sysSecurityService.getAdminIpBlock(dto)
        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])
        return view
    }
    @GetMapping("/ipSecurity.mi")
    fun ipSecurity(): ModelAndView {
        val view = ModelAndView("sys/security/ipSecurity")
        val dto : Block_searchDto = Block_searchDto()
        val map = sysSecurityService.getAdminIpBlock(dto)
        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])
        return view
    }
    @GetMapping("/adminIpSecurity.mi")
    fun adminIpSecurity(): ModelAndView {
        val view = ModelAndView("sys/security/adminIpSecurity")
        val dto : Block_searchDto = Block_searchDto()
        dto.block_status = "1"
        val map = sysSecurityService.getAdminIpBlock(dto)
        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])
        return view
    }
    @GetMapping("/adminPermitSecurity.mi")
    fun adminPermitSecurity(): ModelAndView {
        val view = ModelAndView("sys/security/adminPermitSecurity")
        return view
    }

    @GetMapping("/adminUserLog.mi")
    fun adminUserLog(): ModelAndView {
        val view = ModelAndView("sys/security/adminUserLog")
        val dto : UsrHst_searchDto = UsrHst_searchDto()
        val map = sysSecurityService.getAdminUserLog(dto)
        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])
        return view
    }

    @GetMapping("/userLog.mi")
    fun userLog(): ModelAndView {
        val view = ModelAndView("sys/security/userLog")
        val dto : UsrHst_searchDto = UsrHst_searchDto()
        dto.usr_id = UsefulUtils.sessionUser().usr_id
        val map = sysSecurityService.getAdminUserLog(dto)
        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])
        return view
    }

    /**
     * @Method Name  : updateBlockLst
     * @Since    : 2021. 03.30
     * @author   : Andy
     * @return   : Map
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 관리자 보안 ip 차단 개인 해제 -> 상태값 업데이트
     * @title : 보안 IP 차단 해제
     */
    @ResponseBody
    @PostMapping("/updateBlockLst.ajax")
    fun updateBlockLst(@ModelAttribute("form") dto: Block_searchDto): MutableMap<String, Any> {
        println(dto.block_status)
        val map = sysSecurityService.updateBlockLst(dto)
        return map
    }
    /**
     * @Method Name  : saveBlockList
     * @Since    : 2021. 03.30
     * @author   : Andy
     * @return   : Map
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 관리자 보안 ip 차단 추가
     * @title : 보안 차단 IP 추가
     */
    @ResponseBody
    @PostMapping("/saveBlockList.ajax")
    fun saveBlockList(@ModelAttribute("form") dto: Block_searchDto): MutableMap<String, Any> {
        var map : MutableMap<String, Any> = HashMap()
        val checkMap = sysSecurityService.checkduplicateIp(dto)
        val duplCheck = checkMap["status"]
        if(duplCheck == 0){
            map["status"] = true
            map["message"] = "이미 등록된 IP입니다."
        }else if(duplCheck == 1){
            map = sysSecurityService.saveBlockList(dto)
        }else if(duplCheck == 2){
            dto.block_reg_id = UsefulUtils.sessionUser().usr_id
            dto.block_reg_usr = UsefulUtils.sessionUser().usr_id
            map = sysSecurityService.updateBlockLst(dto)
            map["message"] = "IP가 등록되었습니다."
        }
        return map
    }
    /**
     * @Method Name  : getBlockList
     * @Since    : 2021. 03.30
     * @author   : Andy
     * @return   : Map
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 관리자 보안 ip 검색, 리스트
     * @title : 보안 차단 IP 추가
     */
    @ResponseBody
    @PostMapping("/getBlockList.ajax")
    fun getBlockList(@ModelAttribute("form") dto: Block_searchDto): ModelAndView {
        val view = ModelAndView("sys/security/ajax/adminBlockSecurityAjax")
        if(dto.block_status.isNullOrEmpty()){
            dto.block_status = "0"
        }
        val map = sysSecurityService.getAdminIpBlock(dto)
        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])
        return view
    }
    /**
     * @Method Name  : getIpSecurity
     * @Since    : 2021. 03.30
     * @author   : Andy
     * @return   : Map
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 사용자 보안 ip 검색, 리스트
     * @title : 사용자 보안 ip 검색, 리스트
     */
    @ResponseBody
    @PostMapping("/getIpSecurity.ajax")
    fun getIpSecurity(@ModelAttribute("form") dto: Block_searchDto): ModelAndView {
        val view = ModelAndView("sys/security/ajax/adminIpSecurityAjax")
        val map = sysSecurityService.getAdminIpBlock(dto)
        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])
        return view
    }
    /**
     * @Method Name  : getAdminUserLog
     * @Since    : 2021. 03.30
     * @author   : Andy
     * @return   : Map
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 사용자 로그 list
     * @title : 사용자로그
     */
    @ResponseBody
    @PostMapping("/getAdminUserLog.ajax")
    fun getAdminUserLog(@ModelAttribute("form") dto: UsrHst_searchDto): ModelAndView {
        val view = ModelAndView("sys/security/ajax/adminUserLogAjax")
        val map = sysSecurityService.getAdminUserLog(dto)
        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])
        return view
    }
    /**
     * @Method Name  : getUserLog
     * @Since    : 2021. 03.30
     * @author   : Andy
     * @return   : Map
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 사용자 로그 list
     * @title : 사용자로그
     */
    @ResponseBody
    @PostMapping("/getUserLog.ajax")
    fun getUserLog(@ModelAttribute("form") dto: UsrHst_searchDto): ModelAndView {
        val view = ModelAndView("sys/security/ajax/userLogAjax")
        dto.usr_id = UsefulUtils.sessionUser().usr_id
        val map = sysSecurityService.getAdminUserLog(dto)
        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])
        return view
    }
    /**
     * @Method Name  : getUserBlockList
     * @Since    : 2021. 03.30
     * @author   : Andy
     * @return   : Map
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 관리자 보안 ip 검색, 리스트
     * @title : 보안 차단 IP 추가
     */
    @ResponseBody
    @PostMapping("/getUserIpSecurity.ajax")
    fun getUserIpSecurity(@ModelAttribute("form") dto: Block_searchDto): ModelAndView {
        val view = ModelAndView("sys/security/ajax/ipSecurityAjax")
        val map = sysSecurityService.getAdminIpBlock(dto)
        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])
        return view
    }

}
