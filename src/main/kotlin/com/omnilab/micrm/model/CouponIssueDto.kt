package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmicou_coupon_issueDto
import org.apache.ibatis.type.Alias

@Alias("CouponIssueDto")
class CouponIssueDto: Tblmicou_coupon_issueDto() {

    var encodedCouponSeq: String? = null
    var phoneNumberList: List<String>? = null

}