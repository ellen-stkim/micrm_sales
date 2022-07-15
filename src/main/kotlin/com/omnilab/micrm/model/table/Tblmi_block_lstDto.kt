package com.omnilab.micrm.model.table

import org.apache.ibatis.type.Alias

@Alias("Tblmi_block_lstDto")
open class Tblmi_block_lstDto  {

    var seq: Int? = null
    var block_type: String? = null
    var block_target: String? = null
    var block_reg_usr: String? = null
    var block_st_dt: Char? = null
    var block_end_dt: String? = null
    var block_status: String? = null
    var block_grp_cd: String? = null
    var block_memo: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null

    override fun toString(): String {
        return "Tblmi_block_lstDto(seq=$seq, block_type=$block_type, block_target=$block_target, block_reg_usr=$block_reg_usr, block_st_dt=$block_st_dt, block_end_dt=$block_end_dt, block_status=$block_status, block_grp_cd=$block_grp_cd, reg_id=$reg_id, reg_dt=$reg_dt, upd_id=$upd_id, upd_dt=$upd_dt)"
    }


}