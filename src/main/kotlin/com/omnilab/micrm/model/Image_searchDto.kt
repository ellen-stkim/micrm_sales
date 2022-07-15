package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmi_cont_imgDto
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle

class Image_searchDto : Tblmi_cont_imgDto() {

    var pageNo: Int = 1
    var firstIndex: Int = 0
    var recordCountPerPage: Int = 0
    var reg_dt_range: String? = null


    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}