package com.omnilab.micrm.model.table.kakao

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("AtButtonDto")
class AtButtonDto  {
    var name: String? = null
    var type: String? = null
    var scheme_android: String? = null
    var scheme_ios: String? = null
    var url_mobile: String? = null
    var url_pc:String? = null

    var chat_extra: String? = null
    var chat_event: String? = null
    var plugin_id: String? = null
    var relay_id: String? = null
    var oneclick_id: String? = null
    var product_id:String? = null
    var target:String? = null

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}