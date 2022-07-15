package com.omnilab.micrm.service

import com.omnilab.micrm.model.table.Tblmi_block_lstDto
import com.omnilab.micrm.model.table.Tblmi_usr_hstDto

interface SysSecurityService {

    fun getAdminIpBlock(bDto : Tblmi_block_lstDto):MutableMap<String, Any>

    fun updateBlockLst(bDto: Tblmi_block_lstDto):MutableMap<String, Any>

    fun saveBlockList(bDto: Tblmi_block_lstDto):MutableMap<String, Any>

    fun getAdminUserLog(uDto : Tblmi_usr_hstDto):MutableMap<String, Any>

    fun checkduplicateIp(bDto: Tblmi_block_lstDto):MutableMap<String, Any>
}