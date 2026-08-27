package com.omnilab.micrm.service

import com.omnilab.micrm.model.table.Tblmi_workDto


interface WorkService {

    fun insertWorkHistory(workDto : Tblmi_workDto);

    fun updateWorkHistory(workDto: Tblmi_workDto)

}