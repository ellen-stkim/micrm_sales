package com.omnilab.micrm.controller

import com.omnilab.micrm.model.table.Tblmi_usrDto
import com.omnilab.micrm.service.MicrmUserService
import org.springframework.stereotype.Controller
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.web.bind.annotation.ModelAttribute
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.ResponseBody
import javax.servlet.http.HttpServletRequest


@Controller
@RequestMapping("/mcr")
class MicrmUserController {

	val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    @Qualifier("MicrmUserServiceImpl")
    private lateinit var micrmUserService : MicrmUserService

    @ResponseBody
    @PostMapping("/check/id.ajax")
    fun getUserId(usrDto : Tblmi_usrDto): MutableMap<String,String> {
        val userInfoMap = micrmUserService.sel_check_id(usrDto)
        return userInfoMap
    }

    @ResponseBody
    @PostMapping("/check/pw.ajax")
    fun checkPassword(@ModelAttribute("password") password: String, req: HttpServletRequest) : MutableMap<String,Boolean>{
        val userInfoMap: MutableMap<String, Boolean> = HashMap()
        val status = micrmUserService.checkUserPassWord(req.getParameter("password"))
        userInfoMap["status"] = status
        return userInfoMap;
    }

    @ResponseBody
    @PostMapping("/find/pw.ajax")
    fun findPw(usrDto : Tblmi_usrDto) : MutableMap<String,String> {
        return micrmUserService.sel_check_id(usrDto)
    }

    @ResponseBody
    @PostMapping("/send/password.service")
    fun sendPassword(usrDto : Tblmi_usrDto) {
        micrmUserService.sendPassword(usrDto)
    }
}