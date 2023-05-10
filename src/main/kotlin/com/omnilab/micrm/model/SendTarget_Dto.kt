package com.omnilab.micrm.model

import org.apache.commons.lang3.builder.EqualsBuilder
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias
import java.util.*

@Alias("TestTarget_Dto")
class SendTarget_Dto {

    var usr_nm: String? = null
    var send_to: String? = null

    constructor()
    constructor(usr_nm: String?, send_to: String?){
        this.usr_nm = usr_nm
        this.send_to = send_to
    }

    override fun hashCode(): Int {
        return Objects.hash(usr_nm, send_to)
    }

    override fun equals(other: Any?): Boolean {
        if (other?.javaClass != this.javaClass)
            return false

        val oth = other as SendTarget_Dto
        return EqualsBuilder().append(send_to, oth.send_to).isEquals
    }

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}