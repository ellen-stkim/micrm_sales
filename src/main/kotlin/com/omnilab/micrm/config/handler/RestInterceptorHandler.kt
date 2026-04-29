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
import org.springframework.http.HttpRequest
import org.springframework.http.client.ClientHttpRequestExecution
import org.springframework.http.client.ClientHttpRequestInterceptor
import org.springframework.http.client.ClientHttpResponse
import org.springframework.stereotype.Component

@Component
class RestInterceptorHandler: ClientHttpRequestInterceptor {

    val logger = LoggerFactory.getLogger(this::class.java)
    
    override fun intercept(request: HttpRequest, body: ByteArray, execution: ClientHttpRequestExecution): ClientHttpResponse {
        logRequest(request, body)
        val response = execution.execute(request, body)
        logResponse(response)
        return response
    }
    
    private fun logRequest(request: HttpRequest, body: ByteArray) {
        logger.info("===== REQUEST =====")
        logger.info("URI: ${request.uri}")
        logger.info("Method: ${request.method}")
        logger.info("Headers: ${request.headers}")
        logger.info("Body: ${String(body, Charsets.UTF_8)}")
    }

    private fun logResponse(response: ClientHttpResponse) {
        logger.info("===== RESPONSE =====")
        logger.info("Status: ${response.statusCode}")
        logger.info("Headers: ${response.headers}")
        val responseBody = response.body.bufferedReader().use { it.readText() }
        logger.info("Body: $responseBody")
    }
    
}