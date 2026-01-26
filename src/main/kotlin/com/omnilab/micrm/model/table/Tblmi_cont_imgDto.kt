package com.omnilab.micrm.model.table

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Tblmi_cont_imgDto")
open class Tblmi_cont_imgDto {

    var seq: Int? = null
    var ch_tp: String? = null
    var img_nm: String? = null
    var img_org_nm: String? = null
    var img_file_nm: String? = null
    var img_url: String? = null
    var kko_img_url: String? = null
    var use_yn: String? = null
    var del_yn: String? = null
    var usr_grp_cd: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null
    var cd_nm : String? = null

    constructor()
    constructor(seq: Int){
        this.seq = seq
    }
    constructor(kkoImgUrl: String){
        this.kko_img_url = kkoImgUrl
    }

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}