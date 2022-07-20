package com.omnilab.micrm.repository

import com.omnilab.micrm.model.Content_view_Dto
import com.omnilab.micrm.model.Contents_lstDto
import com.omnilab.micrm.model.table.*

interface CommonDao {

    fun sel_tblmi_usrOne(dto: Tblmi_usrDto): Tblmi_usrDto

    fun sel_tblmi_usr(dto: Tblmi_usrDto): List<Tblmi_usrDto>

    fun insertUserHistoryLog(dto : Tblmi_usr_hstDto) :Int

}