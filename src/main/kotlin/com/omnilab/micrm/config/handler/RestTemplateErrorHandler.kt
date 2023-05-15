package com.omnilab.micrm.config.handler

import org.apache.commons.io.IOUtils
import org.slf4j.LoggerFactory
import org.springframework.http.HttpMethod
import org.springframework.http.client.ClientHttpResponse
import org.springframework.util.StreamUtils
import org.springframework.web.client.ResponseErrorHandler
import java.net.HttpURLConnection
import java.net.URI
import java.nio.charset.StandardCharsets

class RestTemplateErrorHandler: ResponseErrorHandler  {

    val logger = LoggerFactory.getLogger(this.javaClass)

    override fun hasError(response: ClientHttpResponse): Boolean {
        val status = response.statusCode.value()
        return !(status >= HttpURLConnection.HTTP_OK && status < HttpURLConnection.HTTP_MULT_CHOICE)
    }

    override fun handleError(response: ClientHttpResponse) {

    }

    override fun handleError(url: URI, method: HttpMethod, response: ClientHttpResponse) {
        logger.error("handleError response: {} ({}) - {} ", url, response.statusCode, StreamUtils.copyToString(response.body, StandardCharsets.UTF_8))
    }
}