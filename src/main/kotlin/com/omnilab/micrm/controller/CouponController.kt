package com.omnilab.micrm.controller

import com.google.zxing.BarcodeFormat
import com.google.zxing.EncodeHintType
import com.google.zxing.qrcode.QRCodeWriter
import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.config.error.CouponException
import com.omnilab.micrm.model.CouponIssueDto
import com.omnilab.micrm.model.coupon.CouponRegisterDto
import com.omnilab.micrm.model.coupon.SearchCouponDto
import com.omnilab.micrm.model.coupon.SearchCouponIssuedLogDto
import com.omnilab.micrm.model.table.Tblmi_comm_cdDto
import com.omnilab.micrm.service.CouponIssueService
import com.omnilab.micrm.service.CouponListService
import com.omnilab.micrm.service.CouponRegisterService
import com.omnilab.micrm.service.SysSettingService
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.*
import org.springframework.web.multipart.MultipartFile
import org.springframework.web.servlet.ModelAndView
import java.awt.image.BufferedImage
import java.io.ByteArrayOutputStream
import java.util.*
import javax.imageio.ImageIO
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

@RequestMapping("/coupon")
@Controller
class CouponController {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    private lateinit var couponListService: CouponListService

    @Autowired
    private lateinit var couponRegisterService: CouponRegisterService

    @Autowired
    private lateinit var couponIssueService: CouponIssueService

    @Autowired
    lateinit var sysSettingService: SysSettingService

    @GetMapping("/couponList.mi")
    fun couponList(searchCouponDto: SearchCouponDto): ModelAndView {
        val view = ModelAndView("coupon/couponList")

        // 카테고리 리스트 조회
        val categoryList = couponRegisterService.getCategory(UsefulUtils.sessionUser().usr_grp_cd!!)
        view.addObject("categoryList", categoryList)

        return view
    }

    @GetMapping("/couponRegister.mi")
    fun couponRegister(): ModelAndView {
        val view = ModelAndView("coupon/couponRegister")

        val user = UsefulUtils.sessionUser()
        val categoryList = couponRegisterService.getCategory(user.usr_grp_cd!!)
        view.addObject("categoryList", categoryList)

        return view
    }

    @GetMapping("/couponUpdate.mi")
    fun couponUpdate(@RequestParam seq: String): ModelAndView {
        val view = ModelAndView("coupon/couponUpdate")

        // 쿠폰 조회
        val couponDto = couponListService.getCoupon(seq)

        // 카테고리 리스트 조회
        val categoryList = couponRegisterService.getCategory(UsefulUtils.sessionUser().usr_grp_cd!!)

        view.addObject("coupon", couponDto)
        view.addObject("categoryList", categoryList)
        view.addObject("couponImageDomain", couponListService.getCouponImageCdnDomain())
        return view
    }

    @GetMapping("/couponIssue.mi")
    fun couponIssue(@RequestParam seq: String?): ModelAndView {
        val view = ModelAndView("coupon/couponIssue")
        if (!CommonUtils.isEmptyObject(seq)) {
            val coupon = couponListService.getCoupon(seq!!)
            view.addObject("coupon", coupon)
        }

        val sendNumber = couponListService.getDefaultSendNumber()
        view.addObject("sendNumber", sendNumber)
        view.addObject("couponImageDomain", couponListService.getCouponImageCdnDomain())
        return view
    }

    @GetMapping("/couponIssuedLog.mi")
    fun couponIssuedLog(): ModelAndView {
        val view = ModelAndView("coupon/couponIssuedLog")

        val categoryList = couponRegisterService.getCategory(UsefulUtils.sessionUser().usr_grp_cd!!)
        view.addObject("categoryList", categoryList)

        return view
    }

    @ResponseBody
    @PostMapping("/registerCoupon.service")
    fun registerCoupon(registerDto: CouponRegisterDto, request: HttpServletRequest): MutableMap<String, Any> {
        couponRegisterService.registerCoupon(registerDto, request)
        val reMap = createResponseMap(HttpStatus.OK, "쿠폰 등록이 완료되었습니다.")
        return reMap
    }

    @ResponseBody
    @PostMapping("/updateCoupon.service")
    fun updateCoupon(registerDto: CouponRegisterDto, request: HttpServletRequest): MutableMap<String, Any> {
        couponRegisterService.updateCoupon(registerDto, request)

        val reMap = createResponseMap(HttpStatus.OK, "쿠폰 수정이 완료되었습니다.")
        return reMap
    }

    @ResponseBody
    @PostMapping("/deleteCoupon.service")
    fun deleteCoupon(@RequestParam(value = "deleteCouponSeq[]") deleteCouponSeq: List<String>): MutableMap<String, Any>  {
        couponRegisterService.deleteCoupon(deleteCouponSeq)
        val reMap = createResponseMap(HttpStatus.OK, "쿠폰 삭제가 완료되었습니다.")
        return reMap
    }

    @ResponseBody
    @PostMapping("/issueCoupon.service")
    fun issueCoupon(couponIssueDto: CouponIssueDto): MutableMap<String, Any> {
        couponIssueService.issueCoupon(couponIssueDto)

        val reMap = createResponseMap(HttpStatus.OK, "쿠폰 발급이 완료되었습니다.")
        return reMap
    }

    @ResponseBody
    @PostMapping("/deleteCouponIssuedLog.service")
    fun deleteCouponIssuedLog(@RequestParam(value = "deleteCouponIssuedLogSeq[]") deleteCouponIssuedLogSeq: MutableList<String>): MutableMap<String, Any>  {
        couponIssueService.deleteCouponIssuedLog(deleteCouponIssuedLogSeq)

        val reMap = createResponseMap(HttpStatus.OK, "쿠폰 발급 내역 삭제가 완료되었습니다.")
        return reMap
    }

    @PostMapping("/getCouponList.ajax")
    fun getCouponList(searchCouponDto: SearchCouponDto): ModelAndView {
        val view = ModelAndView("coupon/ajax/couponListAjax")

        val reMap = couponListService.getCouponList(searchCouponDto)
        view.addObject("couponList", reMap["list"])
        view.addObject("page", reMap["page"])
        view.addObject("pageNo", reMap["pageNo"])
        view.addObject("cnt", reMap["cnt"])
        view.addObject("couponImageDomain", couponListService.getCouponImageCdnDomain())
        return view
    }

    @PostMapping("/getCouponIssuedLogList.ajax")
    fun getCouponIssuedLogList(searchCouponIssuedLogDto: SearchCouponIssuedLogDto): ModelAndView {
        val view = ModelAndView("coupon/ajax/couponIssuedLogListAjax")
        val reMap = couponListService.getCouponIssuedLogList(searchCouponIssuedLogDto)
        view.addObject("couponIssuedLogList", reMap["list"])
        view.addObject("page", reMap["page"])
        view.addObject("pageNo", reMap["pageNo"])
        view.addObject("cnt", reMap["cnt"])
        view.addObject("couponImageDomain", couponListService.getCouponImageCdnDomain())
        return view
    }

    @PostMapping("/extractExcel.ajax")
    fun extractExcel(file: MultipartFile): ModelAndView {
        val view = ModelAndView("coupon/ajax/phoneNumberListAjax")

        val reMap = couponIssueService.extractPhoneNumberToExcel(file)
        view.addObject("phoneNumberList", reMap["phoneNumberList"])
        view.addObject("collectCnt", reMap["collectCnt"])
        view.addObject("duplicateCnt", reMap["duplicateCnt"])
        view.addObject("errorCnt", reMap["errorCnt"])

        return view
    }


    @ResponseBody
    @PostMapping("/getCouponQr.ajax")
    fun extractExcel(@RequestParam sq: String): String {
        val trackUrl = sysSettingService.getCommCD(Tblmi_comm_cdDto("TRACKURL", UsefulUtils.sessionUser().usr_grp_cd!!))?.cd_val
        val data = "$trackUrl/c/rt/$sq"

        // QR 코드 생성 옵션 설정
        val hints = Hashtable<EncodeHintType, Any?>()
        hints[EncodeHintType.MARGIN] = 1 // QR 코드의 여백 설정

        // QR 코드 생성
        val qrCodeWriter = QRCodeWriter()
        val bitMatrix = qrCodeWriter.encode(data, BarcodeFormat.QR_CODE, 300, 300, hints) // 300x300 크기로 생성

        // BitMatrix를 BufferedImage로 변환
        val image = BufferedImage(bitMatrix.width, bitMatrix.height, BufferedImage.TYPE_INT_RGB)
        for (x in 0 until bitMatrix.getWidth()) {
            for (y in 0 until bitMatrix.height) {
                image.setRGB(x, y, if (bitMatrix[x, y]) 0x000000 else 0xFFFFFF) // 검은색(0x000000) 또는 흰색(0xFFFFFF)
            }
        }

        val byteArrayOutputStream = ByteArrayOutputStream()
        ImageIO.write(image, "PNG", byteArrayOutputStream)
        val byteArray = byteArrayOutputStream.toByteArray()
        return Base64.getEncoder().encodeToString(byteArray)
    }



    private fun createResponseMap(status: HttpStatus, message: String?): MutableMap<String, Any> {
        val reMap: MutableMap<String, Any> = HashMap()
        reMap["status"] = status
        reMap["message"] = message ?: ""
        return reMap
    }

    @ExceptionHandler(CouponException::class)
    fun exceptionHandler(e: CouponException, response: HttpServletResponse): ResponseEntity<Any> {
        if (e.message.contains("redirect")) {
            response.sendRedirect(e.message.split(":")[1])
        }
        return ResponseEntity(mapOf("status" to "400", "message" to e.message), HttpStatus.OK)
    }

}