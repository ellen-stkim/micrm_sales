package com.omnilab.micrm.model.table

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Tblmite_target_lst")
open class Tblmite_target_lst {

    var seq:Int? = null
    var grp_no: Int? = null
    var usr_id : String?= null
    var usr_nm: String? = null
    var usr_mob : String? = null
    var usr_myn : String?= null
    var usr_edm : String? = null
    var usr_eyn : String?= null
    var usr_gdr: String? = null
    var usr_addr : String?= null

    // 유저 커스텀 선택 etc 값
    var usr_etc1 : String? = null
    var usr_etc2 : String? = null
    var usr_etc3 : String? = null
    var usr_etc4 : String? = null
    var usr_etc5 : String? = null
    var usr_etc6 : String? = null
    var usr_etc7 : String? = null
    var usr_etc8 : String? = null
    var usr_etc9 : String? = null
    var usr_etc10 : String? = null

    var send_yn: String? = null
    var use_yn: String? = null
    var del_yn : String?= null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}