package com.omnilab.micrm.repository

import com.omnilab.micrm.model.Block_searchDto
import com.omnilab.micrm.model.UsrHst_searchDto
import com.omnilab.micrm.model.table.Tblmi_block_lstDto
import com.omnilab.micrm.model.table.Tblmi_usr_hstDto


interface SysSecurityDao {

    fun getAdminUserLogCnt(dto : Tblmi_usr_hstDto) : Int

    fun getAdminUserLogList(dto : Tblmi_usr_hstDto) : MutableList<UsrHst_searchDto>

}
