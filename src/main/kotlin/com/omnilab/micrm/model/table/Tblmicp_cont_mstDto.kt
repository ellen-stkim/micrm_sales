package com.omnilab.micrm.model.table

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Tblmicp_cont_mstDto")
open class Tblmicp_cont_mstDto: Tblmi_cont_mstDto {

    var cont_seq: Int? = null

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

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}