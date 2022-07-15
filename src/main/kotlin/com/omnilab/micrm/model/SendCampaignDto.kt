package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmicp_programDto
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("SendCampaignDto")
class SendCampaignDto: Tblmicp_programDto() {

    var camp_id: List<String>? = null
    var cont_id: List<String>? = null
    var sto: List<String>? = null
    var send_tp: List<String>? = null
    var send_dt: List<String>? = null
    var send_time: List<String>? = null

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}