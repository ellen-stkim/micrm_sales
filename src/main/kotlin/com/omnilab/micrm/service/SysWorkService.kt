package com.omnilab.micrm.service

import com.omnilab.micrm.model.table.Tblmi_workDto


interface SysWorkService {

    fun getWorkList(dto:Tblmi_workDto): MutableMap<String, Any>
}