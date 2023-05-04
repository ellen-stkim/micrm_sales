package com.omnilab.micrm.service

import com.omnilab.micrm.model.coupon.CouponRegisterDto
import com.omnilab.micrm.model.table.Tblmi_usrDto
import com.omnilab.micrm.model.table.Tblmicou_categoryDto
import javax.servlet.http.HttpServletRequest

interface CouponRegisterService {
    
    fun getCategory(usrID: String): MutableList<Tblmicou_categoryDto>
    fun registerCoupon(dto: CouponRegisterDto, request: HttpServletRequest)
    fun deleteCoupon(deleteCouponSeq: List<String>)
    fun updateCoupon(dto: CouponRegisterDto, request: HttpServletRequest)
}