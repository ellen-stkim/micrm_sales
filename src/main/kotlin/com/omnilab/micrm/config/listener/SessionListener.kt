package com.omnilab.micrm.config.listener

import org.slf4j.LoggerFactory
import javax.servlet.http.HttpSessionEvent
import javax.servlet.http.HttpSessionListener

class SessionListener: HttpSessionListener {


    val logger = LoggerFactory.getLogger(this::class.java)

    override fun sessionDestroyed(se: HttpSessionEvent?) {
        super.sessionDestroyed(se)
    }

    override fun sessionCreated(se: HttpSessionEvent) {
        super.sessionCreated(se)
    }

}