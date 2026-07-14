package com.omnilab.micrm.model

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle

class SearchSendCostDto : SendCostDto {

    var pageNo : Int = 1
    var pageSize : Int = 10

    var monthly_dt : String? = null

    var firstIndex : Int? = 0
    var recordCountPerPage : Int = 10

    var lstCd: List<String>? = null

    constructor() : super()

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}