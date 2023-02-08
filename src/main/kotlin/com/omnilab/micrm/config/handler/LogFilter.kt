package com.omnilab.micrm.config.handler

import lombok.extern.slf4j.Slf4j
import org.apache.commons.lang.RandomStringUtils
import org.slf4j.MDC
import org.springframework.stereotype.Component
import org.springframework.web.filter.OncePerRequestFilter
import javax.servlet.FilterChain
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse


@Slf4j
@Component
class LogFilter  : OncePerRequestFilter() {
    override fun doFilterInternal(req: HttpServletRequest, res: HttpServletResponse, filterChain: FilterChain) {
        MDC.put("REQSEQ",RandomStringUtils.randomAlphanumeric(10))
        filterChain.doFilter(req, res)
    }
}