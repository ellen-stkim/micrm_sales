package com.omnilab.micrm.model.table.kakao

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("ItemInfoDto")
data class ItemInfoDto(
    var title: String?
    , var img_url: String?
    , var scheme_android: String?
    , var scheme_ios: String?
    , var url_mobile: String?
    , var url_pc: String?
) {

    constructor(): this(null, null, null, null, null, null)
    constructor(title: String, imgUrl: String, urlMobile: String, urlPc: String): this(title, imgUrl, null, null, urlMobile, urlPc)
    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}