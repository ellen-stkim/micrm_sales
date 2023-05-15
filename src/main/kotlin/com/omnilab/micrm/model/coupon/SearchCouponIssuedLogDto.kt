package com.omnilab.micrm.model.coupon

import org.apache.ibatis.type.Alias

@Alias("SearchCouponIssuedLogDto")
class SearchCouponIssuedLogDto {

    var category_seq: String? = ""
    var send_start_dt: String? = ""
    var send_end_dt: String? = ""
    var send_status: String? = ""
    var use_yn: String? = ""
    var coupon_nm: String? = ""
    var usr_grp_cd: String? = ""

    var pageNo: Int = 1
    var firstIndex: Int?= null
    var recordCountPerPage: Int = 0
}