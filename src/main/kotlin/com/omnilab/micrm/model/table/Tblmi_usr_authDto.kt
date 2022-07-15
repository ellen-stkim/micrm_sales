package com.omnilab.micrm.model.table

import org.apache.ibatis.type.Alias


@Alias("Tblmi_usr_authDto")
open class Tblmi_usr_authDto {
    var usr_id: String? = null
    var role_cd: String? = null
    var del_dt: String? = null
    var reg_dt: String? = null
    var reg_id: String? = null
    var upd_dt: String? = null
    var upd_id: String? = null

    constructor()
    constructor(usr_id: String){
        this.usr_id = usr_id
    }
}