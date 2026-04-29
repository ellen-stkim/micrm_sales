package com.omnilab.micrm.model

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle

data class ApiResponse<T>(
    val result: Boolean,
    val data: T? = null,
    val status: Int,
    val msg: String? = null
) {
    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}
