package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmi_supDto
import com.omnilab.micrm.model.table.Tblmire_send_hstDto
import org.apache.poi.hpsf.Decimal
import java.math.BigDecimal

open class SendCostDto : Tblmire_send_hstDto {

    var pro_nm : String? = null
    var prg_start_dt : String? = null
    var req_id : String? = null
    var total_cnt : Long?= null
    var total_cost : BigDecimal?= null
    var send_mon : String?= null

    var team_nm : String? = null
    var team_cd : String? = null

    var start_dt : String? = null
    var end_dt : String? = null

    constructor() : super()

    constructor(usr_grp_cd: String?, start_dt: String?, end_dt: String?) : super(usr_grp_cd) {
        this.usr_grp_cd = usr_grp_cd
        this.start_dt = start_dt
        this.end_dt = end_dt
    }

    override fun toString(): String {
        return "SendCostDto(pro_nm=$pro_nm, prg_start_dt=$prg_start_dt, req_id=$req_id, total_cnt=$total_cnt, total_cost=$total_cost, send_mon=$send_mon, team_nm=$team_nm, team_cd=$team_cd, start_dt=$start_dt, end_dt=$end_dt)"
    }


}