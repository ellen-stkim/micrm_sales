package com.omnilab.micrm.repository

import com.omnilab.micrm.model.table.Tblmi_workDto


interface WorkDao {

   fun insertWorkHistory(tblmiWorkdto: Tblmi_workDto)

   fun updateWorkHistory(tblmiWorkdto: Tblmi_workDto)

}