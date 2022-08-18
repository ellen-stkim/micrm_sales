package com.omnilab.micrm.repository

import com.omnilab.micrm.model.SalesforceDto
import com.omnilab.micrm.model.table.Tblmi_set_lstDto
import com.omnilab.micrm.model.table.Tblmi_usrDto

interface SalesforceDao {

    fun sel_usrInfo(dto: SalesforceDto): Tblmi_usrDto?
    fun mappingLst(dto: SalesforceDto): List<SalesforceDto>

}