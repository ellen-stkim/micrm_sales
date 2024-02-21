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
    constructor(listTpId: String?, listDtId: String?, defYn: String?, usrGrpCd: String?) {
        this.list_tp_id = listTpId
        this.list_dt_id = listDtId
        this.def_yn = defYn
        this.usr_grp_cd = usrGrpCd
    }

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}