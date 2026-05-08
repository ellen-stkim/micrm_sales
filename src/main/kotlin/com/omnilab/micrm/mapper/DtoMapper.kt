package com.omnilab.micrm.mapper

import com.omnilab.micrm.model.table.kakao.ButtonJsonDto
import com.omnilab.micrm.model.table.kakao.CarouselDto
import com.omnilab.micrm.model.table.kakao.CommerceDto
import com.omnilab.micrm.model.table.kakao.FtButtonDto
import com.omnilab.micrm.model.table.kakao.FtCarouselDto
import com.omnilab.micrm.model.table.kakao.FtCommerceDto

class DtoMapper {

}

fun CarouselDto.toFtCarouselCommerceDto(): FtCarouselDto {
    return FtCarouselDto(
        header = null,
        content = null,
        additionalContent = this.additional_content,
        imageUrl = this.attachment?.image?.img_url,
        imageLink = null,
        commerce = this.attachment?.commerce?.toFtCommerceDto(),
        buttons = this.attachment?.button?.map { it.toFtButtonDto() },
        coupon = null
    )
}

fun CarouselDto.toFtCarouselLstDto(): FtCarouselDto {
    return FtCarouselDto(
        header = this.header,
        content = this.message,
        additionalContent = null,
        imageUrl = this.attachment?.image?.img_url,
        imageLink = null,
        commerce = null,
        buttons = this.attachment?.button?.map { it.toFtButtonDto() },
        coupon = null
    )
}


fun CommerceDto.toFtCommerceDto(): FtCommerceDto {
    return FtCommerceDto(
        title = this.title,
        regularPrice = this.regular_price,
        discountPrice = this.discount_price,
        discountRate = this.discount_rate?.toLong(),
        discountFixed = this.discount_fixed,
        regularPriceName = null,
        discountPriceName = null,
        discountRateName = null,
        discountFixedName = null,
    )
}

fun ButtonJsonDto.toFtButtonDto(): FtButtonDto {
    return FtButtonDto(
        name = this.name,
        linkType = this.type,
        linkMobile = this.url_mobile,
        linkPc = this.url_pc,
        linkIos = this.scheme_ios,
        linkAndroid = this.scheme_android,
        bizFormId = null
    )
}