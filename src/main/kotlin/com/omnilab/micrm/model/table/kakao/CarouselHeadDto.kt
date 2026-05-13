package com.omnilab.micrm.model.table.kakao

import com.google.gson.annotations.SerializedName
import com.omnilab.micrm.model.table.kakao.CommerceDto
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("CarouselHeadDto")
data class CarouselHeadDto(
    var header: String?,
    var content: String?,
    @SerializedName(value = "imageUrl", alternate = ["image_url"])
    var imageUrl: String?,
    @SerializedName(value = "linkMobile", alternate = ["url_mobile"])
    var linkMobile: String?,
    @SerializedName(value = "linkPc", alternate = ["url_pc"])
    var linkPc: String?,
    @SerializedName(value = "linkIos", alternate = ["scheme_ios"])
    var linkIos: String?,
    @SerializedName(value = "linkAndroid", alternate = ["scheme_android"])
    var linkAndroid: String?,
){
    constructor(): this(null, null, null, null, null, null, null)

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
    
}
