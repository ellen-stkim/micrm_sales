package com.omnilab.micrm.model.table

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Tblmi_comm_cdDto")
class Tblmi_comm_cdDto {

    var seq: Int? = null
    var grp_id: String? = null
    var grp_nm: String? = null
    var cd_id: String? = null
    var cd_nm: String? = null
    var cd_val: String? = null
    var cd_desc: String? = null
    var cd_sn: Int? = null
    var par_id: String? = null
    var par_nm: String? = null
    var use_yn: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null

    constructor()
    constructor(grp_id: String){
        this.grp_id = grp_id
    }
    constructor(grp_id: String, cd_id: String){
        this.grp_id = grp_id
        this.cd_id = cd_id
    }
    constructor(grp_id: String, cd_id: String, cd_desc: String){
        this.grp_id = grp_id
        this.cd_id = cd_id
        this.cd_desc = cd_desc
    }

    constructor(cd_id: String?, par_id: String?, par_nm: String?, use_yn: String?) {
        this.cd_id = cd_id
        this.par_id = par_id
        this.par_nm = par_nm
        this.use_yn = use_yn
    }


    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }


}