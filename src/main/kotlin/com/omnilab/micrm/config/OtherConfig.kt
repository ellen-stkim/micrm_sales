package com.omnilab.micrm.config

import com.omnilab.micrm.common.ImagePaginationRenderer
import com.omnilab.micrm.config.handler.RestInterceptorHandler
import com.omnilab.micrm.config.handler.RestTemplateErrorHandler

import org.springframework.context.annotation.Configuration
import org.springframework.integration.config.EnableIntegration

import egovframework.rte.ptl.mvc.tags.ui.pagination.DefaultPaginationRenderer
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationRenderer
import egovframework.rte.ptl.mvc.tags.ui.pagination.DefaultPaginationManager
import org.apache.http.conn.ssl.NoopHostnameVerifier
import org.apache.http.conn.ssl.SSLConnectionSocketFactory
import org.apache.http.conn.ssl.TrustSelfSignedStrategy
import org.apache.http.impl.client.HttpClientBuilder
import org.apache.http.impl.client.LaxRedirectStrategy
import org.apache.http.ssl.SSLContexts
import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.web.client.RestTemplateBuilder

import org.springframework.context.annotation.Bean
import org.springframework.http.client.BufferingClientHttpRequestFactory
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor
import org.springframework.mail.javamail.JavaMailSenderImpl
import org.springframework.mail.javamail.JavaMailSender
import org.springframework.web.client.RestTemplate
import java.time.Duration

import java.util.*

@Configuration
@EnableIntegration
class OtherConfig {

    @Value("\${variable.mail-username}")
    private val mailUsername: String? = null

    @Value("\${variable.mail-password}")
    private val mailPassword: String? = null

    // MAIL 설정
    @Bean(name = ["javaMailSender"])
    fun javaMailSender(): JavaMailSender {
        val mailSender = JavaMailSenderImpl()
        mailSender.host = "smtp.gmail.com"
        mailSender.port = 465
        mailSender.username = mailUsername
        mailSender.password = mailPassword
        val javaMailProperties = Properties()
        javaMailProperties.setProperty("mail.transport.protocol", "smtp")
        javaMailProperties.setProperty("mail.smtp.ssl.enable", "true")
        javaMailProperties.setProperty("mail.smtp.auth", "true")
        javaMailProperties.setProperty("mail.smtp.starttls.enable", "true")
        javaMailProperties.setProperty("mail.smtp.starttls.required", "true")
        mailSender.javaMailProperties = javaMailProperties
        return mailSender
    }

    //Task Excuetor 설정
    @Bean(name = ["taskExecutor"])
    fun executor(): ThreadPoolTaskExecutor {
        val executor = ThreadPoolTaskExecutor()
        executor.setThreadNamePrefix("template-task-")
        executor.corePoolSize = 10
        executor.maxPoolSize = 100
        executor.keepAliveSeconds = 7200
        executor.queueCapacity = 30
        executor.setAllowCoreThreadTimeOut(false)
        executor.setWaitForTasksToCompleteOnShutdown(false)
        return executor
    }

    @Bean(name = ["paginationManager"])
    fun defaultPaginationManager(): DefaultPaginationManager {
        val manager = DefaultPaginationManager()
        val map = HashMap<String, PaginationRenderer>()
        map["image"] = ImagePaginationRenderer()
        map["text"] = DefaultPaginationRenderer()
        manager.setRendererType(map)
        return manager
    }

    @Bean(name = ["restTemplate"])
    fun restTemplate(): RestTemplate {
        val scsf = SSLConnectionSocketFactory(SSLContexts.custom().loadTrustMaterial(null, TrustSelfSignedStrategy()).build(), NoopHostnameVerifier.INSTANCE)
        val factory = HttpComponentsClientHttpRequestFactory()
        factory.setReadTimeout(5000)
        factory.setConnectTimeout(3000)
        val httpClient = HttpClientBuilder.create()
                .setMaxConnTotal(100)
                .setMaxConnPerRoute(5)
                .setSSLSocketFactory(scsf)
                .setRedirectStrategy(LaxRedirectStrategy())
                .build()
        factory.httpClient = httpClient
        val bufferingFactory = BufferingClientHttpRequestFactory(factory)

        val restTemplateBuilder = RestTemplateBuilder()
                .requestFactory { bufferingFactory }
                .errorHandler(RestTemplateErrorHandler())
                .setConnectTimeout(Duration.ofMinutes(3))
                .interceptors(RestInterceptorHandler())
                .build()
        return restTemplateBuilder
    }
}