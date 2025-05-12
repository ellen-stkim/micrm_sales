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

    var grpIdLst: MutableList<String>? = null
    var extra: String? = null
    constructor()
    constructor(grp_id: String){
        this.grp_id = grp_id
    }
    constructor(grpId: String, cdId: String){
        this.grp_id = grpId
        this.cd_id = cdId
    }
    constructor(grpId: String, cdId: String, cdDesc: String){
        this.grp_id = grpId
        this.cd_id = cdId
        this.cd_desc = cdDesc
    }

    constructor(cdId: String?, parId: String?, parNm: String?, useYn: String?) {
        this.cd_id = cdId
        this.par_id = parId
        this.par_nm = parNm
        this.use_yn = useYn
    }


    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }


}