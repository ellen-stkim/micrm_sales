package com.omnilab.micrm.config.handler

import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.model.table.Tblmi_usrDto
import org.apache.commons.lang.RandomStringUtils
import org.slf4j.MDC
import org.springframework.security.authentication.AnonymousAuthenticationToken
import org.springframework.security.core.context.SecurityContext
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.web.context.SecurityContextRepository
import org.springframework.security.web.session.SessionManagementFilter
import org.springframework.stereotype.Component
import org.springframework.web.filter.OncePerRequestFilter
import javax.servlet.FilterChain
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse


@Component
class LogFilter : OncePerRequestFilter() {
    override fun doFilterInternal(req: HttpServletRequest, res: HttpServletResponse, filterChain: FilterChain) {
        MDC.put("REQSEQ",RandomStringUtils.randomAlphanumeric(10))

        val context: SecurityContext = SecurityContextHolder.getContext()

        val authentication = context.authentication

        if(authentication != null && authentication.isAuthenticated){
            if(authentication.name != "anonymousUser"){
                val usr = authentication.details as Tblmi_usrDto
                MDC.put("USER",usr.usr_id)
            }
        }

        filterChain.doFilter(req, res)
        MDC.clear()
    }
}