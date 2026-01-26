package com.omnilab.micrm.model.table.kakao

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("ButtonJsonDto")
data class ButtonJsonDto(
    var name: String?
    , var type: String?
    , var url_mobile: String?
    , var url_pc: String?
    , var scheme_android: String?
    , var scheme_ios: String?
) {
    constructor(): this(null, null, null, null, null, null)
    constructor(name:String, type: String, urlMobile: String?, urlPc: String?): this(name, type, urlMobile, urlPc, null, null)
    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}