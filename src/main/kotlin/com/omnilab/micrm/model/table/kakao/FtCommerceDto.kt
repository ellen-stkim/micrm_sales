package com.omnilab.micrm.model.table.kakao

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("FtCommerceDto")
data class FtCommerceDto(
    var title: String?,
    var regularPrice: Long?,
    var discountPrice: Long?,
    var discountRate: Long?,
    var discountFixed: Long?,
    var regularPriceName: String?,
    var discountPriceName: String?,
    var discountRateName: String?,
    var discountFixedName: String?
) {
    
    constructor(): this(null, null, null, null, null, null, null, null, null)
    
    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
    
}