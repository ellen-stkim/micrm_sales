package com.omnilab.micrm.model

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Tblmi_mfa")
data class Tblmi_mfa (
    val seq:Int?
    , val usr_id: String
    , val phone: String
    , val code: String?
    , val expired_at: String
    , val count: Int?
    , var use_yn: String
    , val reg_id: String?
    , val reg_dt: String?
    , val upd_id: String?
    , val upd_dt: String?
){
    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}