package com.omnilab.micrm.controller

import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestMethod
import javax.servlet.http.HttpServletRequest

@Controller
class CheckController {

    private val logger = LoggerFactory.getLogger(CheckController::class.java)

    @Autowired
    private val threadPoolTaskExecutor: ThreadPoolTaskExecutor? = null

    @RequestMapping(value = ["/check.mi"], method = [RequestMethod.GET, RequestMethod.HEAD])
    fun check(req: HttpServletRequest): ResponseEntity<String?>? {
        req.setAttribute("DoNotLog", "")
        return ResponseEntity(HttpStatus.OK)
    }

    @GetMapping("/threadMonitor.json")
    fun threadCount() {
        logger.error("getCorePoolSize : {}", threadPoolTaskExecutor!!.corePoolSize)
        logger.error("getMaxPoolSize : {}", threadPoolTaskExecutor.maxPoolSize)
        logger.error("getActiveCount : {}", threadPoolTaskExecutor.activeCount)
        logger.error("getKeepAliveSeconds : {}", threadPoolTaskExecutor.keepAliveSeconds)
        logger.error("getPoolSize : {}", threadPoolTaskExecutor.poolSize)
        logger.error("getThreadGroup : {}", threadPoolTaskExecutor.threadGroup)
        logger.error("getThreadNamePrefix : {}", threadPoolTaskExecutor.threadNamePrefix)
        logger.error("getThreadPriority : {}", threadPoolTaskExecutor.threadPriority)
    }


}