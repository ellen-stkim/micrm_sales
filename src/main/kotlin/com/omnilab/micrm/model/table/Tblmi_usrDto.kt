package com.omnilab.micrm.model.table

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias


@Alias("Tblmi_usrDto")
open class Tblmi_usrDto {
    var seq:Int? = null
    var usr_id: String? = null
    var usr_log_id: String? = null
    var usr_email: String? = null
    var usr_pw: String? = null
    var usr_grp_cd: String? = null
    var usr_nm: String? = null
    var usr_tel: String? = null
    var usr_mob: String? = null
    var usr_sales_org_id: String? = null
    var usr_sales_id: String? = null
    var usr_st: String? = null
    var appr_id: String? = null
    var access_yn: String? = null
    var last_log_in_dt: String? = null
    var last_pw_upd_dt: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null
    @set:JvmName("setIs_mfa")
    @get:JvmName("getIs_mfa")
    var is_mfa: String? = null

    var cnt: Int? = null

    constructor()
    constructor(usrId: String?) {
        this.usr_id = usrId
    }

    constructor(usrLogId: String?, usrPw: String?) {
        this.usr_log_id = usrLogId
        this.usr_pw = usrPw
    }

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}