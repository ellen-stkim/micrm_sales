package com.omnilab.micrm.model.coupon

import com.omnilab.micrm.model.table.Tblmicou_couponDto
import org.apache.ibatis.type.Alias

@Alias("CouponListDto")
class CouponListDto: Tblmicou_couponDto() {

    var category_nm: String? = null
    var img_url: String? = null
    var encodedSeq: String? = null

}