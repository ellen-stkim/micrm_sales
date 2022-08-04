package com.omnilab.micrm.model

import org.apache.ibatis.type.Alias

@Alias("SalesforceDto")
class SalesforceDto {
    var host: String? = null
    var token: String? = null

    var enterpriseId: Long? = null
    var organizationId: Long? = null
    var userId: Long? = null

    var list_tp_id : String?= null // 리스트 Type
    var list_dt_id : String?= null // 리스트 상세 타입 Id
}