package com.omnilab.micrm.model.table.kakao

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("CarouselDto")
data class CarouselDto(
    var header: String?
    , var message: String?
    , var additional_content: String?
    , var attachment: AttachmentDto?
) {

    constructor(): this(null, null, null, null)

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}