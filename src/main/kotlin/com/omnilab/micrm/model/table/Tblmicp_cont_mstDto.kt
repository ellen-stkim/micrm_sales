package com.omnilab.micrm.model.table

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Tblmicp_cont_mstDto")
open class Tblmicp_cont_mstDto: Tblmi_cont_mstDto {

    var cont_seq: Int? = null
    var avo_nm: String? = null
    var lstCd: List<String>? = null

    constructor()
    constructor(seq: Int?){
       this.seq = seq
   }
    constructor(seq: Int?, cont_grp_cd: String?, reg_id: String?){
        this.seq = seq
        this.cont_grp_cd = cont_grp_cd
        this.reg_id = reg_id
    }
    constructor(seq: Int?, cont_grp_cd: String?, reg_id: String?, cont_seq: Int?){
        this.seq = seq
        this.cont_grp_cd = cont_grp_cd
        this.reg_id = reg_id
        this.cont_seq = cont_seq
    }
    constructor(dto: Tblmi_cont_mstDto){
        this.cont_seq = dto.seq
        this.ch_tp = dto.ch_tp
        this.cont_nm = dto.cont_nm
        this.sales_nm = dto.sales_nm
        this.avo_id = dto.avo_id
        this.inten_id = dto.inten_id
        this.orig_id = dto.orig_id
        this.inta_key = dto.inta_key
        this.inta_ve = dto.inta_ve
        this.cont_grp_cd = dto.cont_grp_cd
        this.use_yn = dto.use_yn
        this.del_yn = dto.del_yn
        this.reg_id = dto.reg_id
        this.upd_id = dto.upd_id
    }

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}