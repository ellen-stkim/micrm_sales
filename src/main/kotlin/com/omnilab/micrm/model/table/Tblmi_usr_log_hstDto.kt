package com.omnilab.micrm.model.table

import org.apache.ibatis.type.Alias


@Alias("Tblmi_usr_log_hstDto")
open class Tblmi_usr_log_hstDto {
    var seq: Int? = null
    var usr_grp_cd: String? = null
    var usr_id: String? = null
    var usr_email: String? = null
    var usr_ip: String? = null
    var fail_yn: String? = null
    var reg_dt: String? = null


    constructor()
    constructor(usr_email: String, usr_ip: String, fail_yn:String){
        this.usr_email = usr_email
        this.usr_ip = usr_ip
        this.fail_yn = fail_yn
    }
    constructor(usr_grp_cd:String, usr_id: String, usr_email: String, usr_ip: String, fail_yn: String){
        this.usr_grp_cd = usr_grp_cd
        this.usr_id = usr_id
        this.usr_email = usr_email
        this.usr_ip = usr_ip
        this.fail_yn = fail_yn
    }
}