package com.omnilab.micrm.model.table

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Tblmi_target_grpDto")
class Tblmi_target_grpDto {

    var seq: Int? = null
    var grp_nm: String? = null
    var usr_grp_cd: String? = null
    var status: String? = null
    var grp_cnt: Int? = null
    var use_yn: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null

    constructor()
    constructor(seq: Int?, usr_grp_cd: String?, use_yn: String?){
        this.seq = seq
        this.usr_grp_cd = usr_grp_cd
        this.use_yn = use_yn
    }


    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}