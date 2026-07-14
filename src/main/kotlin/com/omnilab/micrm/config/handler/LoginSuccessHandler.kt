package com.omnilab.micrm.config.handler

import com.omnilab.micrm.common.GlobalValues
import com.omnilab.micrm.model.table.Tblmi_usrDto
import com.omnilab.micrm.service.MfaService
import org.springframework.security.core.Authentication
import org.springframework.security.web.authentication.AuthenticationSuccessHandler
import org.springframework.security.web.savedrequest.HttpSessionRequestCache
import org.springframework.security.web.savedrequest.RequestCache
import org.springframework.stereotype.Component
import java.io.IOException
import javax.servlet.ServletException
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import javax.servlet.http.HttpSession
import kotlin.jvm.Throws

@Component
class LoginSuccessHandler(private val mfaService: MfaService) : AuthenticationSuccessHandler {

    @Throws(IOException::class, ServletException::class)
    override fun onAuthenticationSuccess(req: HttpServletRequest, rep: HttpServletResponse, auth: Authentication) {
        val loginDto : Tblmi_usrDto = auth.details as Tblmi_usrDto
        val session: HttpSession? = req.session
        session?.setAttribute("userId", loginDto.usr_id)
        session?.setAttribute("userEmail", loginDto.usr_email)
        session?.setAttribute("userName", loginDto.usr_nm)

        if(loginDto.is_mfa == "Y"){
            req.session.setAttribute("MFA_PENDING", true)
            rep.sendRedirect("/login/mfa.mi")
        } else {
            val requestCache: RequestCache = HttpSessionRequestCache()
            val savedRequest = requestCache.getRequest(req, rep)
            if (savedRequest != null && savedRequest.toString().endsWith("/${GlobalValues.indexpage}")) {
                val redriectUrl = savedRequest.redirectUrl
                rep.sendRedirect(redriectUrl)
            } else {
                rep.sendRedirect("/${GlobalValues.home}")
            }
        }
    }
}