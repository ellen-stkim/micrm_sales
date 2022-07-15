package com.omnilab.micrm.model.table

import org.apache.ibatis.type.Alias
import java.io.Serializable


@Alias("Tblmi_notiDto")
open class Tblmi_notiDto {
    var seq:Int? = null
    var noti_sub: String? = null
    var noti_body: String? = null
    var noti_bgn_dttm: String? = null
    var noti_end_dttm: String? = null
    var noti_popyn: String? = null
    var noti_chk: String? = null
    var del_yn: String? = null
    var usr_grp_cd: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null
    var notInPop: List<String>? = null
    constructor() : super()


    override fun toString(): String {
        return "Tblmi_notiDto(seq=$seq, noti_sub=$noti_sub, noti_body=$noti_body, noti_bgn_dttm=$noti_bgn_dttm, noti_end_dttm=$noti_end_dttm, noti_popyn=$noti_popyn, noti_chk=$noti_chk, del_yn=$del_yn, usr_grp_cd=$usr_grp_cd, reg_id=$reg_id, reg_dt=$reg_dt, upd_id=$upd_id, upd_dt=$upd_dt)"
    }


}