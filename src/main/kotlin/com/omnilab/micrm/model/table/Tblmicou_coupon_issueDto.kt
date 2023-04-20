package com.omnilab.micrm.model.table

import org.apache.ibatis.type.Alias

@Alias("Tblmicou_coupon_issueDto")
open class Tblmicou_coupon_issueDto {

    var seq: Int? = null
    var coupon_seq: Int? = null
    var send_phone: String? = null
    var issue_dt: String? = null
    var send_dt: String? = null
    var name: String? = null
    var img_url: String? = null
    var descr: String? = null
    var notice: String? = null
    var expire_dt: String? = null
    var daily_start_time: String? = null
    var daily_end_time: String? = null
    var available_day: String? = null
    var msg_title: String? = null
    var msg_content: String? = null
    var time_cnt: Int? = null
    var camp_seq: Int? = null
    var target_cnt: Int? = null
    var reg_id: String? = null
    var reg_dt: String? = null


}