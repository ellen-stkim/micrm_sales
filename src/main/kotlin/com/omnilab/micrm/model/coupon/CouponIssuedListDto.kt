package com.omnilab.micrm.model.coupon

import com.omnilab.micrm.model.table.Tblmicou_coupon_issued_logDto
import org.apache.ibatis.type.Alias

@Alias("CouponIssuedListDto")
class CouponIssuedListDto: Tblmicou_coupon_issued_logDto() {

    var img_url: String? = null
    var encodedSeq: String? = null
    var coupon_nm: String? = null
    var expire_dt: String? = null
}