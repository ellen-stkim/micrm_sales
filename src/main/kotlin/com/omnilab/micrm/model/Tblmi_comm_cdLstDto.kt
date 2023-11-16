package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmi_comm_cdDto
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Tblmi_comm_cdLstDto")
class Tblmi_comm_cdLstDto {

    var lst: MutableList<Tblmi_comm_cdDto>? = null

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}