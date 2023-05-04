package com.omnilab.micrm.service

import com.omnilab.micrm.model.Contents_lstDto
import com.omnilab.micrm.model.CouponIssueDto
import com.omnilab.micrm.model.table.Tblmicou_coupon_issueDto
import com.omnilab.micrm.model.table.Tblmicp_campaignDto
import org.springframework.web.multipart.MultipartFile

interface CouponIssueService {


    fun issueCoupon(couponIssueDto: CouponIssueDto)
    fun issueCouponAtSales(dto: Tblmicp_campaignDto, contTpLst: MutableMap<String, Contents_lstDto>, map: MutableMap<String, Any>)
    fun extractPhoneNumberToExcel(file: MultipartFile): MutableMap<String, Any>
    fun deleteCouponIssuedLog(deleteCouponIssuedLogSeq: MutableList<String>)
}