package com.omnilab.micrm.service

import com.omnilab.micrm.model.Contents_lstDto
import com.omnilab.micrm.model.CouponIssueDto
import com.omnilab.micrm.model.table.Tblmicou_coupon_issued_logDto
import com.omnilab.micrm.model.table.Tblmicp_campaignDto
import org.springframework.web.multipart.MultipartFile

interface CouponIssueService {


    fun issueCoupon(couponIssueDto: CouponIssueDto)
    fun createCouponLink(map: MutableMap<String, Any>): Tblmicou_coupon_issued_logDto?
    fun issueCouponAtSales(couponIssuedLogDto: Tblmicou_coupon_issued_logDto)
    fun extractPhoneNumberToExcel(file: MultipartFile): MutableMap<String, Any>
    fun deleteCouponIssuedLog(deleteCouponIssuedLogSeq: MutableList<String>)
}