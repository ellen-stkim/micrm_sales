package com.omnilab.micrm.model.table

import org.apache.ibatis.type.Alias


@Alias("Tblmi_noti_fileDto")
class Tblmi_noti_fileDto {
    var seq:Int? = null
    var noti_seq:Int? = null
    var file_org_nm: String? = null
    var file_nm: String? = null
    var file_extension: String? = null
    var file_mime: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null
    override fun toString(): String {
        return "Tblmi_noti_fileDto(seq=$seq, noti_seq=$noti_seq, file_org_nm=$file_org_nm, file_nm=$file_nm, file_extension=$file_extension, file_mime=$file_mime, reg_id=$reg_id, reg_dt=$reg_dt, upd_id=$upd_id, upd_dt=$upd_dt)"
    }


}