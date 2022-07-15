package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmi_set_lstDto
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("SetLst_searchDto")
class SetLst_searchDto : Tblmi_set_lstDto() {

    var pageNo: Int = 1
    var firstIndex: Int = 0
    var recordCountPerPage: Int = 0
    var searchType : String?= null
    var searchValue : String ?= null

    var defaultMailNo : Int?= null
    var changeMailNo : Int?= null

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}