package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmi_cont_mstDto
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Contents_searchDto")
class Contents_searchDto: Tblmi_cont_mstDto {

    var reg_dt_range: String? = null
    var pageNo: Int = 1
    var firstIndex: Int = 0
    var recordCountPerPage: Int = 0
    var cont_sub : String? = null
    var cont_tp : String? = null
    var searchType : String?= null
    var searchValue : String?= null

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

}