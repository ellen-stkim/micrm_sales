package com.omnilab.micrm.config.handler

import org.slf4j.LoggerFactory
import org.springframework.security.web.firewall.RequestRejectedException
import org.springframework.web.HttpRequestMethodNotSupportedException
import javax.servlet.http.HttpSession
import javax.servlet.http.HttpServletResponse
import javax.servlet.http.HttpServletRequest
import org.springframework.web.servlet.NoHandlerFoundException
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.*

@ControllerAdvice
class CommonExceptionHandler {

    val logger = LoggerFactory.getLogger("CommonExceptionHandler")

    //404 에러 페이지
    @ResponseStatus(HttpStatus.NOT_FOUND)
    @ExceptionHandler(NoHandlerFoundException::class)
    fun handlesdConflict(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession, e: NoHandlerFoundException) {
		try {
            logger.error("error", e)
            rep.sendRedirect("/html/not.html")
        } catch (err: Exception) {

        }
    }

    //잘못된 요청
    @ResponseStatus(HttpStatus.METHOD_NOT_ALLOWED)
    @ExceptionHandler(value = [HttpRequestMethodNotSupportedException::class])
    fun handleException(req: HttpServletRequest, rep: HttpServletResponse, session: HttpSession, e: HttpRequestMethodNotSupportedException) {
		try {
            logger.error("invalid {}", req.requestURI, e)
            rep.sendRedirect("/html/error.html")
        } catch (err: Exception) {

        }
    }

    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    @ExceptionHandler(value = [RequestRejectedException::class])
    fun rejected(e: RequestRejectedException): String {
        logger.error("error", e)
		return "redirect:/html/error2.html"
    }

    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    @ExceptionHandler(value = [Exception::class])
    fun handleException(e: Exception): String {
        if(e.message != "rollback"){
            logger.error("error", e)
        }else{
            logger.error("error", "rollback")
        }
		return "redirect:/html/error2.html"
    }

    /*@ExceptionHandler(value = [Exception::class])
    fun handleServerException(e : Exception) : String{
        logger.error("error", e);
        return "redirect:/html/error2.html"
    }*/
}