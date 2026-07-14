package com.omnilab.micrm.model.table.kakao

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("CouponDto")
data class CouponDto(
    var title: String?,
    var description: String?,
    var linkMobile: String?,
    var linkPc: String?,
    var linkIos: String?,
    var linkAndroid: String?
){
    constructor(): this(null, null, null, null, null, null)

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
    
}
