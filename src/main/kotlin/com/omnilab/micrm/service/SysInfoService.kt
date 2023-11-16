package com.omnilab.micrm.service

import com.omnilab.micrm.model.table.Tblmi_comm_cdDto

interface SysInfoService {

    fun setCode(lst: MutableList<Tblmi_comm_cdDto>): Boolean

}