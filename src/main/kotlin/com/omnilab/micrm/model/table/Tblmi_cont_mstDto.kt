package com.omnilab.micrm.model.table

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Tblmi_cont_mstDto")
open class Tblmi_cont_mstDto: Cloneable {

    var seq: Int ?= null
    var ch_tp : String ?= null  // 채널 타입
    var cont_nm : String ?= null    // 콘텐츠 명
    var pro_nm : String ?= null    // 프로그램 명
    var team_cd : String ?= null    // 팀코드
    var sales_nm: String? = null
    var avo_id: String? = null
    var inten_id: String? = null
    var orig_id: String? = null
    var inta_key: String? = null
    var inta_ve: String? = null
    var pub_yn: String? = null
    var cont_grp_cd : String ?= null    //그룹 코드
    var use_yn : String ?= null
    var del_yn : String ?= null
    var reg_id : String ?= null
    var reg_dt : String ?= null
    var upd_id : String ?= null
    var upd_dt : String ?= null

    constructor()
    constructor(seq: Int?){
        this.seq = seq
    }
    constructor(seq: Int, cont_grp_cd: String, use_yn: String){
        this.seq = seq
        this.cont_grp_cd = cont_grp_cd
        this.use_yn = use_yn
    }

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

    public override fun clone(): Tblmicp_cont_mstDto {
        return super.clone() as Tblmicp_cont_mstDto
    }
}