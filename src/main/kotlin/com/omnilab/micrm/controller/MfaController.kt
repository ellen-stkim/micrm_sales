package com.omnilab.micrm.controller

import com.omnilab.micrm.model.table.Tblmi_usrDto
import com.omnilab.micrm.service.MfaService
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.security.core.Authentication
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.*
import org.springframework.web.servlet.ModelAndView
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import javax.servlet.http.HttpSession

@Controller
class MfaController {

    @Autowired
    private lateinit var mfaService: MfaService

    @GetMapping("/login/mfa.mi")
    fun mfaPage(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession, auth: Authentication) : ModelAndView{
        if(session.getAttribute("MFA_PENDING") == null){
            return ModelAndView("redirect:/home.mi")
        } else {
            val loginDto : Tblmi_usrDto = auth.details as Tblmi_usrDto
            val a = mfaService.sendVerificationCode(loginDto.usr_id!!, loginDto.usr_mob!!, loginDto.usr_grp_cd!!)
            val view = ModelAndView("login/mfa")
            view.addObject("data", a)
            return view
        }
    }

    @ResponseBody
    @PostMapping("/api/sms/resend.service")
    fun resend(req: HttpServletRequest, rep: HttpServletResponse, auth: Authentication) : MutableMap<String, Any>{
        val loginDto : Tblmi_usrDto = auth.details as Tblmi_usrDto
        return mfaService.sendVerificationCode(loginDto.usr_id!!, loginDto.usr_mob!!, loginDto.usr_grp_cd!!)
    }

    @ResponseBody
    @PostMapping("/api/sms/verify.service")
    fun mfaPage(@RequestParam code:String, req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession, auth: Authentication) : Boolean {
        if(code.isEmpty()){
            return false
        }
        val loginDto : Tblmi_usrDto = auth.details as Tblmi_usrDto
        val codeCheck = mfaService.codeCheck(loginDto.usr_id!!, loginDto.usr_mob!!, code)
        if(codeCheck) {
            session.removeAttribute("MFA_PENDING")
        }
        return codeCheck
    }

}