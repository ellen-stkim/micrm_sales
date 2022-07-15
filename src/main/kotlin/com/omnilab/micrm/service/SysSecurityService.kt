package com.omnilab.micrm.service

import com.omnilab.micrm.model.table.Tblmi_block_lstDto
import com.omnilab.micrm.model.table.Tblmi_usr_hstDto

interface SysSecurityService {

    fun getAdminUserLog(uDto : Tblmi_usr_hstDto):MutableMap<String, Any>
}