package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmi_set_lstDto
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("SetLst_searchDto")
class SetLst_searchDto: Tblmi_set_lstDto {


    var pageNo: Int = 1
    var firstIndex: Int? = null
    var recordCountPerPage: Int? = null
    var searchType : String?= null
    var searchValue : String ?= null

    var defaultMailNo : Int?= null
    var changeMailNo : Int?= null

    constructor()
    constructor(list_tp_id: String?, list_dt_id: String?, def_yn: String?, usr_grp_cd: String?) {
        this.list_tp_id = list_tp_id
        this.list_dt_id = list_dt_id
        this.def_yn = def_yn
        this.usr_grp_cd = usr_grp_cd
    }

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}