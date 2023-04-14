package com.omnilab.micrm.service

import com.omnilab.micrm.model.coupon.CouponListDto
import com.omnilab.micrm.model.coupon.SearchCouponDto
import com.omnilab.micrm.model.coupon.SearchCouponIssuedLogDto
import com.omnilab.micrm.model.table.Tblmicou_couponDto

interface CouponListService {
    fun getCouponList(searchDto: SearchCouponDto): MutableMap<String, Any>
    fun getCoupon(encodedSeq: String): CouponListDto
    fun getCouponIssuedLogList(searchDto: SearchCouponIssuedLogDto): MutableMap<String, Any>
    fun getDefaultSendNumber(): String
}