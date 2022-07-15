package com.omnilab.micrm.service

import org.apache.poi.ss.usermodel.*
import org.apache.poi.xssf.streaming.SXSSFWorkbook
import org.apache.poi.xssf.usermodel.XSSFCellStyle
import org.apache.poi.xssf.usermodel.XSSFColor
import org.apache.poi.xssf.usermodel.XSSFFont
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.boot.web.client.RestTemplateBuilder
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory
import org.springframework.mail.javamail.JavaMailSender
import org.springframework.mail.javamail.MimeMessageHelper
import org.springframework.scheduling.annotation.Async
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor
import org.springframework.stereotype.Service
import org.springframework.util.MultiValueMap
import org.springframework.web.client.RestTemplate
import java.awt.Color
import java.io.UnsupportedEncodingException
import java.nio.charset.StandardCharsets
import javax.mail.MessagingException
import javax.mail.internet.InternetAddress

@Service
class CommonService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    @Qualifier("javaMailSender")
    private lateinit var mail: JavaMailSender

    @Autowired
    @Qualifier("restTemplate")
    private lateinit var restTemplate: RestTemplate

    @Autowired
    @Qualifier("taskExecutor")
    private lateinit var taskExecutor: ThreadPoolTaskExecutor

    fun createExcel(label: List<String>): Workbook {
        val worker: Workbook = SXSSFWorkbook(1000)
        val sheet = (worker as SXSSFWorkbook).createSheet("sheet1")

        //폰트 설정
        val font = worker.createFont()
        font.fontName = XSSFFont.DEFAULT_FONT_NAME

        //라벨 스타일
        val titlestyle: CellStyle = worker.createCellStyle()
        titlestyle.fillForegroundColor = XSSFColor(Color.gray, null).index
        titlestyle.alignment = HorizontalAlignment.CENTER
        titlestyle.setFont(font)

        //컬럼 라벨 설정
        columnLabel(sheet, label, titlestyle)

        //내용 스타일
        val style = worker.createCellStyle() as XSSFCellStyle
        style.setFont(font)

        return worker
    }

    fun sendMail(sendTo: String, sendToNm: String, sendFrom: String, subject: String, body: String) {
        taskExecutor.submit {
            val message = mail.createMimeMessage()
            val messageHelper: MimeMessageHelper = MimeMessageHelper(message, true, "UTF-8")
            try {
                messageHelper.setSubject(subject)
                messageHelper.setText(body, true)
                messageHelper.setFrom(sendFrom)
                messageHelper.setTo(InternetAddress(sendTo, sendToNm, StandardCharsets.UTF_8.name()))
                mail.send(message)
            } catch (e: MessagingException) {
                logger.error("MessagingException", e)
            } catch (e: UnsupportedEncodingException) {
                logger.error("UnsupportedEncodingException", e)
            }
        }
    }

    fun columnLabel(sheet: Sheet, list: List<String>, style: CellStyle) {
        val row = sheet.createRow(0)
        var cell: Cell?
        for (i in list.indices) {
            cell = row.createCell(i)
            cell.setCellValue(list[i])
            cell.cellStyle = style
        }
    }

    fun getRest(url: String, method: String, data: MultiValueMap<String, String>): ResponseEntity<String> {
        return if (method.toUpperCase() == "GET") {
            val rep: ResponseEntity<String> = restTemplate.getForEntity(url, String::class.java, data)
            rep
        } else if (method.toUpperCase() == "POST") {
            val rep: ResponseEntity<String> = restTemplate.postForEntity(url, data, String::class.java)
            rep
        } else {
            ResponseEntity<String>("Not Allow method : $method", null, HttpStatus.INTERNAL_SERVER_ERROR)
        }
    }

}