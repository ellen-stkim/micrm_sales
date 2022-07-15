package com.omnilab.micrm.model.table

import org.apache.ibatis.type.Alias

@Alias("Tblmi_workDto")
open class Tblmi_workDto  {

    var seq: Int? = null
    var work_type: String? = null
    var work_usr_id: String? = null
    var work_usr_ip: String? = null
    var work_stat: String? = null
    var work_msg: String? = null
    var work_grp_cd: String? = null
    var notify: Int? = null
    var work_st_dt: String? = null
    var work_end_dt: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null

    constructor()

    constructor(work_usr_id: String?, work_grp_cd: String?) {
        this.work_usr_id = work_usr_id
        this.work_grp_cd = work_grp_cd
    }

    override fun toString(): String {
        return "Tblmi_workDto(seq=$seq, work_type=$work_type, work_usr_id=$work_usr_id, work_usr_ip=$work_usr_ip, work_stat=$work_stat, work_msg=$work_msg, work_grp_cd=$work_grp_cd, notify=$notify, work_st_dt=$work_st_dt, work_end_dt=$work_end_dt, reg_id=$reg_id, reg_dt=$reg_dt, upd_id=$upd_id, upd_dt=$upd_dt)"
    }


}