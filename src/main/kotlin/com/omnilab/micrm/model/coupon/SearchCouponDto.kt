package com.omnilab.micrm.model.coupon

import org.apache.ibatis.type.Alias

@Alias("SearchCouponDto")
class SearchCouponDto {

    var category_seq: String? = null
    var nm: String? = null
    var expire_dt: String? = null

    var pageNo: Int = 1
    var firstIndex: Int?= null
    var recordCountPerPage: Int = 0
}