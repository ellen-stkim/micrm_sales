package com.omnilab.micrm.model.table

import org.apache.ibatis.type.Alias

@Alias("Tblmi_supDto")
open class Tblmi_supDto  {

    var seq: Int? = null
    var pro_id: String? = null
    var camp_id: String? = null
    var tbl_id: String? = null
    var tbl_lst_id: String? = null
    var sup_type: String? = null
    var ch_type: String? = null
    var send_to: String? = null
    var send_from: String? = null
    var usr_grp_cd: String? = null
    var sup_lnk: String? = null
    var del_yn: String? = null
    var del_dt: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null

    constructor() : super()

    override fun toString(): String {
        return "Tblmi_supDto(seq=$seq, pro_id=$pro_id, camp_id=$camp_id, tbl_id=$tbl_id, tbl_lst_id=$tbl_lst_id, sup_type=$sup_type, ch_type=$ch_type, send_to=$send_to, send_from=$send_from, usr_grp_cd=$usr_grp_cd, sup_lnk=$sup_lnk, del_yn=$del_yn, del_dt=$del_dt, reg_id=$reg_id, reg_dt=$reg_dt, upd_id=$upd_id, upd_dt=$upd_dt)"
    }


}