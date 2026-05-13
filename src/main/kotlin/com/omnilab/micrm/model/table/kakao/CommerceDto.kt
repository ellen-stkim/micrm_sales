package com.omnilab.micrm.model.table.kakao

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("CommerceDto")
data class CommerceDto(
    var title: String?
    , var regular_price: Long?
    , var discount_price: Long?
    , var discount_rate: Int?
    , var discount_fixed: Long?
) {

    constructor(): this(null, null, null, null, null)

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}