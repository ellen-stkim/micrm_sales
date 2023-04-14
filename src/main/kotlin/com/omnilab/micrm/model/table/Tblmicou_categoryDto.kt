package com.omnilab.micrm.model.table

import org.apache.ibatis.type.Alias

@Alias("Tblmicou_categoryDto")
class Tblmicou_categoryDto {

    var seq: Int? = null
    var company_grp_cd: String? = null
    var nm: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null

}