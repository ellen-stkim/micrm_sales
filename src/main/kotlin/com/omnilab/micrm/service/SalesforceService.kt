package com.omnilab.micrm.service

import com.omnilab.micrm.model.SalesforceDto

interface SalesforceService {

    fun getUser(dto: SalesforceDto): Map<String, Any>

    fun mappingLst(dto: SalesforceDto) : Map<String, Any>

}