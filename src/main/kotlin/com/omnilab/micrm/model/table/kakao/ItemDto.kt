package com.omnilab.micrm.model.table.kakao

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("ItemDto")
class ItemDto {
    var list: List<ItemDetailDto>? = null
    var summary: List<ItemDetailDto>? = null

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}