package com.omnilab.micrm.model.table.kakao

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("CommerceDto")
data class CommerceDto(
    val title: String?
    , val regular_price: Long?
    , val discount_price: Long?
    , val discount_rate: Int?
    , val discount_fixed: Long?
) {

    constructor(): this(null, null, null, null, null)

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}