package com.omnilab.micrm.model.table
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias
import java.math.BigDecimal

@Alias("Tblmicp_programDto")
open class Tblmicp_programDto {
    var pro_id: String? = null
    var pro_tp: String? = null
    var pro_st: String? = null
    var pro_nm: String? = null
    var pro_tg_tp: String? = null
    var pro_tg_id: String? = null
    var min_start_dt: String? = null
    var max_start_dt: String? = null
    var grp_cnt: Int? = null
    var camp_cnt: Int? = null
    var cont_cnt: Int? = null
    var tar_cnt: Int = 0
    var resp_cnt: Int = 0
    var plan_cost: BigDecimal? = null
    var off_cost: BigDecimal? = null
    var dev_cost: BigDecimal? = null
    var des_cost: BigDecimal? = null
    var usr_grp_cd: String? = null
    var appr_id: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null

    constructor()
    constructor(pro_id: String?){
        this.pro_id = pro_id
    }
    constructor(pro_id: String?, pro_st: String?){
        this.pro_id = pro_id
        this.pro_st = pro_st
    }
    constructor(pro_id: String?, pro_st: String?, usr_grp_cd: String?){
        this.pro_id = pro_id
        this.pro_st = pro_st
        this.usr_grp_cd = usr_grp_cd
    }
    constructor(pro_id: String?, tar_cnt: Int, pro_st: String?, upd_id: String?){
        this.pro_id = pro_id
        this.tar_cnt = tar_cnt
        this.pro_st = pro_st
        this.upd_id = upd_id
    }
    constructor(pro_id: String?, pro_nm: String?, pro_tp: String?, usr_grp_cd: String?){
        this.pro_id = pro_id
        this.pro_nm = pro_nm
        this.pro_tp = pro_tp
        this.usr_grp_cd = usr_grp_cd
    }
    constructor(pro_id: String?, tar_cnt: Int, pro_st: String?, upd_id: String?, min_start_dt: String?, max_start_dt: String?){
        this.pro_id = pro_id
        this.tar_cnt = tar_cnt
        this.pro_st = pro_st
        this.upd_id = upd_id
        this.min_start_dt = min_start_dt
        this.max_start_dt = max_start_dt
    }

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}