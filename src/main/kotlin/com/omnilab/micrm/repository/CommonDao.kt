package com.omnilab.micrm.repository

import com.omnilab.micrm.model.Content_view_Dto
import com.omnilab.micrm.model.Contents_lstDto
import com.omnilab.micrm.model.table.*

interface CommonDao {

    fun sel_tblmi_usrOne(dto: Tblmi_usrDto): Tblmi_usrDto
    fun sel_tblmi_usr_authOne(dto: Tblmi_usr_authDto): Tblmi_usr_authDto

    fun sel_tblmi_usr(dto: Tblmi_usrDto): List<Tblmi_usrDto>
    fun sel_tblmi_usr_auth(dto: Tblmi_usr_authDto): List<Tblmi_usr_authDto>

    fun insertUserHistoryLog(dto : Tblmi_usr_hstDto) :Int

}