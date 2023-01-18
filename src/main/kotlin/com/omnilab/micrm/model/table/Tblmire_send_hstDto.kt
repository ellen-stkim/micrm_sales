package com.omnilab.micrm.model.table

import com.omnilab.micrm.model.SendTarget_Dto
import org.apache.commons.lang3.builder.EqualsBuilder
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias
import java.util.*

@Alias("Tblmire_send_hstDto")
open class Tblmire_send_hstDto {

    var seq: Int? = null
    var pro_id: String? = null
    var camp_id: Int? = null
    var send_cnt: String? = null
    var m_server: String? = null
    var send_rst: String? = null
    var send_rst_det: String? = null
    var usr_grp_cd: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null

    constructor()

    constructor(seq: Int?, usr_grp_cd: String?) {
        this.seq = seq
        this.usr_grp_cd = usr_grp_cd
    }

}