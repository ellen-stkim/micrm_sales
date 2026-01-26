package com.omnilab.micrm.model.table.kakao

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("AttachmentDto")
data class AttachmentDto(
    var button: List<ButtonJsonDto>?
    , var image: ImageDto?
    , var commerce: String?
) {

    constructor(): this(null, null, null)

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}