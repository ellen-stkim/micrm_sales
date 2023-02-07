package com.omnilab.micrm.common

import com.omnilab.micrm.model.table.Tblmi_usrDto
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo
import org.json.simple.JSONObject
import org.slf4j.LoggerFactory
import org.springframework.security.core.context.SecurityContextHolder
import java.io.PrintWriter
import java.lang.reflect.Field
import java.util.regex.Pattern
import java.util.*
import javax.servlet.http.HttpServletResponse
import kotlin.reflect.full.memberProperties


class UsefulUtils {

    companion object {
        val logger = LoggerFactory.getLogger(this::class.java)

        fun sessionUser(): Tblmi_usrDto {
            val authentication = SecurityContextHolder.getContext().authentication
            logger.error("{}",authentication.details)
            val loginDto: Tblmi_usrDto = authentication.details as Tblmi_usrDto
            return loginDto
        }

        fun makePage(currentPageNo: Int, pageSize: Int, recordCounterPage: Int): PaginationInfo {
            val pagination = PaginationInfo()

            pagination.currentPageNo = currentPageNo
            pagination.pageSize = pageSize
            pagination.recordCountPerPage = recordCounterPage

            return pagination
        }

        fun isCheckPhoneNumber(phoneNumber : String) : Boolean {
            // 핸드폰 번호 형식일경우 True Return
            return Pattern.matches("^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?[0-9]{3,4}-?[0-9]{4}$", phoneNumber)
        }

        fun isCheckEmail(email : String) : Boolean {
            // 이메일 형식 일 경우 True Return
            //return Pattern.matches("[\\w\\~\\-\\.]+@[\\w\\~\\-]+(\\.[\\w\\~\\-]+)+", email)
            return Pattern.matches("[ㄱ-ㅎ가-힣A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,64}",email)
        }

        fun adminEmail() : String{
            // admin 계정 email
            return "noreply@milvus.co.kr"
        }

        fun alertPopUp(response : HttpServletResponse , alertText : String) {
            response.contentType = "text/html; charset=euc-kr";
            response.characterEncoding = "euc-kr"
            val out: PrintWriter = response.writer
            //out.print("<script type='text/javascript'>alert('"+ alertText + "'); window.open('about:blank', '_self').close();</script>")
            out.print("<script type='text/javascript'>alert('"+ alertText + "'); location.href='javascript:history.back()';</script>")
            out.flush()
            out.close()
        }

    }


}