package com.omnilab.micrm.model.table

import org.apache.ibatis.type.Alias
import org.springframework.web.multipart.MultipartFile
import java.io.Serializable

@Alias("Tblmi_tbl_mstDto")
class Tblmi_tbl_mstDto {

    var seq: Int? = null
    var tbl_id: String? = null
    var usr_seq: Int? = null
    var tbl_grp: String? = null
    var tbl_adm: String? = null
    var upd_chk: Int? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null


    override fun toString(): String {
        return "Tblmi_tbl_mstDto(seq=$seq, tbl_id=$tbl_id, usr_seq=$usr_seq, tbl_grp=$tbl_grp, tbl_adm=$tbl_adm, upd_chk=$upd_chk, reg_id=$reg_id, reg_dt=$reg_dt, upd_id=$upd_id, upd_dt=$upd_dt)"
    }


}