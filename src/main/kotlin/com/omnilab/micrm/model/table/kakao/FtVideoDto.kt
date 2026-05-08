package com.omnilab.micrm.model.table.kakao

import com.google.gson.annotations.SerializedName
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("FtVideoDto")
data class FtVideoDto(
    @SerializedName(value = "videoUrl", alternate = ["video_url"])
    var videoUrl: String?,
    @SerializedName(value = "thumbnailUrl", alternate = ["thumbnail_url"])
    var thumbnailUrl: String?
) {
    
    constructor() : this(null, null)
    
    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
    
}