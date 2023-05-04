package com.omnilab.micrm.service

import com.omnilab.micrm.model.CouponIssueDto
import com.omnilab.micrm.model.table.Tblmicou_coupon_issueDto
import org.springframework.web.multipart.MultipartFile

interface CouponIssueService {


    fun issueCoupon(couponIssueDto: CouponIssueDto)
    fun extractPhoneNumberToExcel(file: MultipartFile): MutableMap<String, Any>
    fun deleteCouponIssuedLog(deleteCouponIssuedLogSeq: MutableList<String>)
}