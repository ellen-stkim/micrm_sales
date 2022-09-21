package com.omnilab.micrm.model.table

import org.apache.ibatis.type.Alias

@Alias("Tblmi_cont_imgDto")
open class Tblmi_cont_imgDto() {

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

    override fun toString(): String {
        return "Tblmi_cont_imgDto(seq=$seq, ch_tp=$ch_tp, img_nm=$img_nm, img_org_nm=$img_org_nm, img_file_nm=$img_file_nm, img_url=$img_url, use_yn=$use_yn, del_yn=$del_yn, usr_grp_cd=$usr_grp_cd, reg_id=$reg_id, reg_dt=$reg_dt, upd_id=$upd_id, upd_dt=$upd_dt, cd_nm=$cd_nm)"
    }


}