package com.omnilab.micrm.model.table.kakao

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.commons.lang3.mutable.Mutable
import org.apache.ibatis.type.Alias

@Alias("KkoBrandTemplateDto")
data class KkoBrandTemplateDto(
    var templateCode: String?,
    var templateName: String?,
    var upgradeTp: String?,
    var content: String?,
    var adult: String?,
    var imageLink: String?,
    var imageUrl: String?,
    var header: String?,
    var additionalContent: String?,
    var carouselHead: CarouselHeadDto?,
    var carousel: MutableList<FtCarouselDto>?,
    var carouselTail: CarouselTailDto?,
    var mainWideItem: WideItemDto?,
    var subWideItemList: MutableList<WideItemDto>?,
    var video: FtVideoDto?,
    var commerce: FtCommerceDto?,
    var buttons: MutableList<FtButtonDto>?,
    var coupon: CouponDto?,
    var head: String?
) {

    constructor() : this(null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null)
    
    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}