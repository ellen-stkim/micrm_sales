package com.omnilab.micrm.model.table

import org.apache.ibatis.type.Alias

@Alias("Tblmi_tbl_infoDto")
class Tblmi_tbl_infoDto {

    var seq: Int? = null
    var tbl_id: String? = null
    var col_id: String? = null
    var col_nm: String? = null
    var col_act: String? = null
    var col_use: Char? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null

    override fun toString(): String {
        return "Tblmi_tbl_infoDto(seq=$seq, tbl_id=$tbl_id, col_id=$col_id, col_nm=$col_nm, col_act=$col_act, col_use=$col_use, reg_id=$reg_id, reg_dt=$reg_dt, upd_id=$upd_id, upd_dt=$upd_dt)"
    }


}