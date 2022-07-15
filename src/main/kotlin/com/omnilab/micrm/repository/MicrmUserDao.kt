package com.omnilab.micrm.repository

import com.omnilab.micrm.model.table.Tblmi_usrDto

interface MicrmUserDao {

    fun sel_tblmi_usr( usrDto : Tblmi_usrDto) : Tblmi_usrDto

    fun sel_check_id(usrDto : Tblmi_usrDto) : HashMap<String,String>

    fun updateUserPw(usrDto : Tblmi_usrDto) : HashMap<String,String>
}