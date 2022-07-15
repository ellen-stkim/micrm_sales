package com.omnilab.micrm.model.table

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Tblmite_target_grp")
open class Tblmite_target_grp {

    var seq:Int? = null
    var grp_nm: String? = null
    var usr_grp_cd: String? = null
    var status: Char? = null
    var grp_cnt : Int? = null
    var edm_cnt : Int?= null
    var mob_cnt : Int?= null
    var use_yn : String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}