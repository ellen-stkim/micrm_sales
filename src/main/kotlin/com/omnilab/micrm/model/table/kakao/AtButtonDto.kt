package com.omnilab.micrm.model.table.kakao

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("AtButtonDto")
class AtButtonDto  {
    var ordering: Int? = null
    var name: String? = null
    var linkType: String? = null
    var linkTypeName: String? = null
    var linkMo: String? = null
    var linkPc:String? = null
    var linkAnd: String? = null
    var linkIos: String? = null
    var target: String? = null

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}