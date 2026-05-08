package com.omnilab.micrm.model.table.kakao

import com.google.gson.annotations.SerializedName
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("FtCommerceDto")
data class FtCommerceDto(
    var title: String?,
    @SerializedName(value = "regularPrice", alternate = ["regular_price"])
    var regularPrice: Long?,
    @SerializedName(value = "discountPrice", alternate = ["discount_price"])
    var discountPrice: Long?,
    @SerializedName(value = "discountRate", alternate = ["discount_rate"])
    var discountRate: Long?,
    @SerializedName(value = "discountFixed", alternate = ["discount_fixed"])
    var discountFixed: Long?,
    @SerializedName(value = "regularPriceName", alternate = ["regular_price_name"])
    var regularPriceName: String?,
    @SerializedName(value = "discountPriceName", alternate = ["discount_price_name"])
    var discountPriceName: String?,
    @SerializedName(value = "discountRateName", alternate = ["discount_rate_name"])
    var discountRateName: String?,
    @SerializedName(value = "discountFixedName", alternate = ["discount_fixed_name"])
    var discountFixedName: String?
) {
    
    constructor(): this(null, null, null, null, null, null, null, null, null)
    
    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
    
}