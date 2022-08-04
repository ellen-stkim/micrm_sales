package com.omnilab.micrm.repository

import com.omnilab.micrm.model.SalesforceDto
import com.omnilab.micrm.model.table.Tblmi_set_lstDto

interface SalesforceDao {

    fun mappingLst(dto: SalesforceDto): List<Tblmi_set_lstDto>

}