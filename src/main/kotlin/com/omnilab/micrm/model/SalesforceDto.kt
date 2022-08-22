package com.omnilab.micrm.model

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("SalesforceDto")
class SalesforceDto {
    var seq: Int? = null

    var host: String? = null
    val fuelToken: String? = null
    var token: String? = null

    var enterpriseId: Long? = null
    var organizationId: Long? = null
    var userId: Long? = null

    var list_val : String? = null // 리스트 값
    var list_nm : String? = null // 리스트 명
    var list_tp_id : String? = null // 리스트 Type
    var list_dt_id : String? = null // 리스트 상세 타입 Id
    var usr_grp_cd : String? = null // 사용자 소속 코드

    constructor()
    constructor(organizationId: Long){
        this.organizationId = organizationId
    }

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}