package com.omnilab.micrm.model.table

import org.apache.ibatis.type.Alias

@Alias("Tblmicou_coupon_issued_logDto")
open class Tblmicou_coupon_issued_logDto() {

    var seq: Int? = null
    var msgkey: String? = null
    var msgtp: String? = null
    var usr_grp_cd: String? = null
    var coupon_issue_seq: Int? = null
    var coupon_uuid: String? = null
    var short_url: String? = null
    var phone: String? = null
    var send_status: String? = null
    var del_yn: String? = null
    var send_dt: String? = null
    var read_yn: String? = null
    var use_yn: String? = null
    var use_dt: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null

    constructor(msgkey: String,
                msgtp: String,
                coupon_issue_seq: Int,
                coupon_uuid: String,
                shortUrl: String,
                receiveNumber: String,
                usr_id: String?,
                usr_grp_cd: String?) : this() {
        this.msgkey = msgkey
        this.msgtp = msgtp
        this.coupon_issue_seq = coupon_issue_seq
        this.coupon_uuid = coupon_uuid
        this.short_url = shortUrl
        this.phone = receiveNumber
        this.reg_id = usr_id
        this.usr_grp_cd = usr_grp_cd
    }

    constructor(coupon_issue_seq: Int,
                coupon_uuid: String,
                shortUrl: String,
                receiveNumber: String,
                usr_id: String?,
                usr_grp_cd: String?) : this() {
        this.coupon_issue_seq = coupon_issue_seq
        this.coupon_uuid = coupon_uuid
        this.short_url = shortUrl
        this.phone = receiveNumber
        this.reg_id = usr_id
        this.usr_grp_cd = usr_grp_cd
    }

}