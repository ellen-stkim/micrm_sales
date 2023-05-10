package com.omnilab.micrm.model.table

import com.omnilab.micrm.model.SendTarget_Dto
import org.apache.commons.lang3.builder.EqualsBuilder
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias
import java.util.*

@Alias("Tblmicp_send_hstDto")
open class Tblmicp_send_hstDto {

    var seq: Int? = null
    var pro_id: String? = null
    var camp_id: Int? = null
    var cont_id: Int? = null
    var tbl_id: String? = null
    var tbl_lst_id: String? = null
    var camp_ch: String? = null

    var usr_key: String? = null
    var send_to: String? = null
    var send_nm: String? = null
    var send_mdm: String? = null
    var send_rst: String? = null
    var send_rst_tp: String? = null
    var send_rst_det: String? = null
    var send_yn: String? = null
    var auto_tp: String? = null
    var usr_grp_cd: String? = null
    var m_server: String? = null
    var return_path: String? = null
    var send_reg_time: String? = null
    var send_rep_time: String? = null
    var send_log_time: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null

    var use_yn: String? = null

    constructor()
    constructor(pro_id: String?){
        this.pro_id = pro_id
    }
    constructor(pro_id: String?, seq: Int?, tbl_id: String?, use_yn: String?){
        this.pro_id = pro_id
        this.seq = seq
        this.tbl_id = tbl_id
        this.use_yn = use_yn
    }
    constructor(pro_id: String?, camp_id: Int?, cont_id: Int?, tbl_id: String?, tbl_lst_id: String?, camp_ch: String?
                , send_to: String?, send_nm: String?, return_path: String?, usr_grp_cd: String?, reg_id: String?){
        this.pro_id = pro_id
        this.camp_id = camp_id
        this.cont_id = cont_id
        this.tbl_id = tbl_id
        this.tbl_lst_id = tbl_lst_id
        this.camp_ch = camp_ch
        this.send_to = send_to
        this.send_nm = send_nm
        this.usr_grp_cd = usr_grp_cd
        this.reg_id = reg_id
        this.return_path = return_path
    }


    override fun hashCode(): Int {
        return Objects.hash(camp_ch, send_to, send_nm)
    }

    override fun equals(other: Any?): Boolean {
        if (other?.javaClass != this.javaClass)
            return false

        val oth = other as Tblmicp_send_hstDto
        return EqualsBuilder().append(send_to, oth.send_to)
                .append(camp_ch, oth.camp_ch)
                .append(send_nm, oth.send_nm)
                .isEquals
    }

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}