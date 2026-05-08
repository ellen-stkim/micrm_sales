package com.omnilab.micrm.model.table.kakao

import com.google.gson.annotations.SerializedName
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("FtCarouselDto")
data class FtCarouselDto(
    var header: String?,
    var content: String?,
    @SerializedName(value = "additionalContent", alternate = ["additional_content"])
    var additionalContent: String?,
    @SerializedName(value = "imageUrl", alternate = ["img_url"])
    var imageUrl: String?,
    @SerializedName(value = "imageLink", alternate = ["img_link"])
    var imageLink: String?,
    var commerce: FtCommerceDto?,
    var buttons: List<FtButtonDto>?,
    var coupon: CouponDto?,
) {
    
    constructor(): this(null, null, null, null, null, null, null, null)
    
    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
    
}