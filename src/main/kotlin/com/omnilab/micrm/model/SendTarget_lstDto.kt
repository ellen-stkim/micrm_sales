package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmicp_programDto
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("TestSend_lstDto")
class SendTarget_lstDto: Tblmicp_programDto() {

    var usr_nm: List<String>? = null
    var usr_edm: List<String>? = null
    var usr_mob: List<String>? = null
    var cont_id: List<String>? = null
    var cont_sub: List<String>? = null

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}