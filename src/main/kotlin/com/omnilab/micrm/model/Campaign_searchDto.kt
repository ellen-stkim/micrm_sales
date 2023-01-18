package com.omnilab.micrm.model

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Campaign_searchDto")
open class Campaign_searchDto : Tblmicp_campaignDto {
    var team_cd: String? = null
    var team_nm: String? = null

    constructor()

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}