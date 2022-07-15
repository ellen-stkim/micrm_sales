package com.omnilab.micrm.model.table

import org.apache.ibatis.type.Alias

@Alias("Tblmire_camp_mstDto")
class Tblmire_camp_mstDto {
    var seq: Long? = null
    var year: Int? = null
    var quater: String? = null
    var month: String? = null
    var pro_id: String? = null
    var camp_id: Long? = null
    var cont_id: Long? = null
    var usr_grp_cd: String? = null
    var camp_ch: String? = null
    var camp_st: String? = null
    var start_dt: String? = null
    var end_dt: String? = null
    var camp_nm: String? = null
    var total_cnt: Long? = 0
    var suc_cnt: Int? = 0
    var open_cnt: Int? = 0
    var click_cnt: Int? = 0
    var sale_cnt: Int? = 0
    var sale_amt: Int? = 0
    var roi: Float? = null
    var ab_gb: String? = null
    var ins_dt: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null
}