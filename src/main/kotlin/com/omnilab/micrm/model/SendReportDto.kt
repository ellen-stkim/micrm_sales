package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmicp_programDto
import com.omnilab.micrm.model.table.Tblmire_send_hstDto
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("SendReportDto")
class SendReportDto: Tblmire_send_hstDto() {

    var cd_val: String? = null
    var cd_desc: String? = null
    var bounce_cate: String? = null

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}