package com.omnilab.micrm.config.handler

import com.omnilab.micrm.common.CommonUtils
import org.slf4j.LoggerFactory

import org.springframework.security.core.AuthenticationException
import org.springframework.security.web.AuthenticationEntryPoint
import org.springframework.security.access.AccessDeniedException
import org.springframework.security.web.access.AccessDeniedHandler

import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

import com.omnilab.micrm.common.GlobalValues
import org.springframework.stereotype.Component

@Component
class AuthenticationHandler: AuthenticationEntryPoint, AccessDeniedHandler {

    val logger = LoggerFactory.getLogger(this::class.java)

    override fun commence(req: HttpServletRequest, rep: HttpServletResponse, authException: AuthenticationException) {
        logger.error("commence {}, {} | {}", CommonUtils.clientip(req), req.requestURI, authException.message)
        req.characterEncoding = "UTF-8"
        rep.contentType = "text/html; charset=UTF-8"
        when {
            req.requestURI.contains(".ajax") -> {
                rep.status = 401
                rep.sendError(HttpServletResponse.SC_UNAUTHORIZED, "session was not found.")
            }
            else -> {
                val out = rep.writer
                out.print("<script>")
                out.print("alert('로그인된 사용자만 이용할 수 있습니다.');")
                out.print("location.href='/${GlobalValues.indexpage}';")
                out.print("</script>")
                out.flush()
                out.close()
            }
        }
    }

    override fun handle(req: HttpServletRequest, rep: HttpServletResponse, accessDeniedException: AccessDeniedException) {
        logger.error("handle {} | {}", req.requestURI, accessDeniedException.message)
        req.characterEncoding = "UTF-8"
        rep.contentType = "text/html; charset=UTF-8"
        val out = rep.writer
        when {
            req.requestURI == "/" -> {
                rep.sendRedirect("/${GlobalValues.indexpage}")
            }
            req.requestURI.contains(".ajax") -> {
                rep.status = 401
                rep.sendError(HttpServletResponse.SC_UNAUTHORIZED, "session was not found.")
            }
            else -> {
                val session = req.session
                session.invalidate()
                out.print("<script>")
                out.print("alert('로그인된 사용자만 이용할 수 있습니다.');")
                out.print("location.href='${GlobalValues.indexpage}';")
                out.print("</script>")
                out.flush()
                out.close()
            }
        }
    }
}