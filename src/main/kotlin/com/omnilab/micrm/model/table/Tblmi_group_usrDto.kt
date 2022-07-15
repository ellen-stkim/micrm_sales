package com.omnilab.micrm.model.table


import org.apache.ibatis.type.Alias


@Alias("Tblmi_group_usrDto")
open class Tblmi_group_usrDto  {

    var seq:Int? = null
    var grp_no: Int? = null
    var usr_id : String?= null
    var usr_nm: String? = null
    var usr_mob : String? = null
    var usr_edm : String? = null
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
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null

    constructor()

    override fun toString(): String {
        return "Tblmi_group_usrDto(seq=$seq, grp_no=$grp_no, usr_id=$usr_id, usr_nm=$usr_nm, usr_mob=$usr_mob, usr_edm=$usr_edm, usr_gdr=$usr_gdr, usr_addr=$usr_addr, usr_etc1=$usr_etc1, usr_etc2=$usr_etc2, usr_etc3=$usr_etc3, usr_etc4=$usr_etc4, usr_etc5=$usr_etc5, usr_etc6=$usr_etc6, usr_etc7=$usr_etc7, usr_etc8=$usr_etc8, usr_etc9=$usr_etc9, usr_etc10=$usr_etc10, send_yn=$send_yn, use_yn=$use_yn, reg_id=$reg_id, reg_dt=$reg_dt, upd_id=$upd_id, upd_dt=$upd_dt)"
    }

}