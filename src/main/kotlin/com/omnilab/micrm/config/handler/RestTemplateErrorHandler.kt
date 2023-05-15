package com.omnilab.micrm.config.handler

import org.slf4j.LoggerFactory
import org.springframework.http.client.ClientHttpResponse
import org.springframework.web.client.ResponseErrorHandler

class RestTemplateErrorHandler: ResponseErrorHandler  {

    val logger = LoggerFactory.getLogger(this.javaClass)

    override fun hasError(response: ClientHttpResponse): Boolean {
        logger.error("Has error response: {}", response)
        return false
    }

    // hasError에서 true를 return하면 해당 메서드 실행.
    override fun handleError(response: ClientHttpResponse) {
        logger.error("Has error response: {}", response)
    }

}