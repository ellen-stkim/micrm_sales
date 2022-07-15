package com.omnilab.micrm.config.handler

import com.omnilab.micrm.common.GlobalValues
import org.springframework.security.core.AuthenticationException
import org.springframework.security.web.authentication.AuthenticationFailureHandler
import java.io.IOException
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import kotlin.jvm.Throws

class LoginFailHandler : AuthenticationFailureHandler {

    @Throws(IOException::class)
    override fun onAuthenticationFailure(req: HttpServletRequest, rep: HttpServletResponse, auth: AuthenticationException) {
        req.characterEncoding = "UTF-8"
        rep.contentType = "text/html; charset=UTF-8"
        val out = rep.writer
        if (auth.localizedMessage == "BAD") {
            if (req.getParameter("gubun") != null && req.getParameter("gubun") == "re") {
                out.print("<script>alert('로그인 정보가 올바르지 않습니다.');</script>")
                out.flush()
                out.close()
            } else {
                out.print("<script>alert('로그인 정보가 올바르지 않습니다.'); location.href = '/${GlobalValues.indexpage}'</script>")
                out.flush()
                out.close()
            }
        } else {
            out.print("<script>alert('" + auth.localizedMessage + "'); location.href = '/${GlobalValues.indexpage}'</script>")
            out.flush()
            out.close()
        }
    }
}