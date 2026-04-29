package com.omnilab.micrm.model.table.kakao

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("FtVideoDto")
data class FtVideoDto(
    var videoUrl: String?,
    var thumbnailUrl: String?
) {
    
    constructor() : this(null, null)
    
    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
    
}