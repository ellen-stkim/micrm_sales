package com.omnilab.micrm.model

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle

data class ReturnDto (
    var status: Boolean? = null
    , var errMsg: String? = null
    , var data: String? = null
){
    constructor(): this(null, null, null)
    constructor(status: Boolean): this(status, null, null)
    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}