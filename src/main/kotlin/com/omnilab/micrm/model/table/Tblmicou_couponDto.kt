package com.omnilab.micrm.model.table

import org.apache.ibatis.type.Alias

@Alias("Tblmicou_couponDto")
open class Tblmicou_couponDto {
    var seq: Int? = null
    var category_seq: Int? = null
    var nm: String? = null
    var title: String? = null
    var descr: String? = null
    var notice: String? = null
    var expire_dt: String? = null
    open var daily_start_time: String? = null
    open var daily_end_time: String? = null
    var available_day: String? = null // 0~6 (일요일~토요일)
    var img_file_seq: Int? = null
    var content: String? = null
    var password: String? = null
    var qr_yn: String? = null
    var del_yn: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null
}