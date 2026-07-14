package com.omnilab.micrm.model.table

import org.apache.ibatis.type.Alias


@Alias("Tblmi_usr_hstDto")
open class Tblmi_usr_hstDto {
    var seq:Int? = null
    var usr_grp_cd: String? = null
    var usr_seq: Int? = null
    var usr_id: String? = null
    var usr_ip: String? = null
    var work_url: String? = null
    var work_detail: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null
    override fun toString(): String {
        return "Tblmi_usr_hstDto(seq=$seq, usr_grp_cd=$usr_grp_cd, usr_seq=$usr_seq, usr_id=$usr_id, usr_ip=$usr_ip, work_url=$work_url, work_detail=$work_detail, reg_id=$reg_id, reg_dt=$reg_dt, upd_id=$upd_id, upd_dt=$upd_dt)"
    }


}