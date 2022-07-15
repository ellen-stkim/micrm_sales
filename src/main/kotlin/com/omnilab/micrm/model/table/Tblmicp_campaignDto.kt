package com.omnilab.micrm.model.table

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Tblmicp_campaignDto")
open class Tblmicp_campaignDto {
    var seq: Int? = null
    var pro_id: String? = null
    var cont_id: Int? = null
    var send_tg_tp: String? = null
    var send_tg_id: String? = null
    var camp_st: String? = null
    var camp_nm: String? = null
    var camp_ch: String? = null
    var sto: String? = null
    var send_st_tp: String? = null
    var tar_cnt: Int? = null
    var start_dt: String? = null
    var end_dt: String? = null
    var suppressed: String? = null
    var optout: String? = null
    var duplicate: String? = null
    var test_tp: String? = null
    var test_dt: Int = 0
    var test_sampling: String? = null
    var cont_cnt: Int = 0
    var test_cnt: Int = 0
    var real_cnt: Int = 0
    var ab_gb: String? = null
    var ab_st: String? = null
    var usr_grp_cd: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null

    constructor()
    constructor(pro_id: String?){
        this.pro_id = pro_id
    }
    constructor(pro_id: String?, seq: Int?){
        this.pro_id = pro_id
        this.seq = seq
    }


    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}