package com.omnilab.micrm.config.view

import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.web.servlet.view.AbstractView
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import java.io.IOException
import java.lang.StringBuilder


class PrintView: AbstractView() {

    val log:Logger = LoggerFactory.getLogger(this::javaClass.name)

    override fun getContentType(): String? {
        return "text/html; charset=UTF-8"
    }

    override fun renderMergedOutputModel(map: MutableMap<String, Any>, request: HttpServletRequest, response: HttpServletResponse) {
       response.characterEncoding = "UTF-8"
        try {
            response.writer.use { out ->
                val ms = StringBuilder()
                ms.append("<script>")
                ms.append("alert('${map["message"]}');")
                ms.append("location.href='${map["redirect"]}';")
                ms.append("</script>")
                out.println(ms.toString())
                out.flush()
            }
        } catch (e: IOException) {
            log.error("PrintView", e)
        }
    }
}