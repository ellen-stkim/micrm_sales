package com.omnilab.micrm.config.listener

import org.slf4j.LoggerFactory
import javax.servlet.http.HttpSessionEvent
import javax.servlet.http.HttpSessionListener

class SessionListener: HttpSessionListener {

    val logger = LoggerFactory.getLogger(this::class.java)
    override fun sessionCreated(p0: HttpSessionEvent?) {
        TODO("Not yet implemented")
    }

    override fun sessionDestroyed(p0: HttpSessionEvent?) {
        TODO("Not yet implemented")
    }


}