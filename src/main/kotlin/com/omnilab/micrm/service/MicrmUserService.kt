package com.omnilab.micrm.service

import com.omnilab.micrm.model.table.Tblmi_usrDto

interface MicrmUserService {

    fun sel_tblmi_usr( usrDto : Tblmi_usrDto) : Tblmi_usrDto

    fun checkUserPassWord(password : String) : Boolean

    fun sel_check_id(usrDto : Tblmi_usrDto) : HashMap<String,String>

    fun sendPassword(usrDto : Tblmi_usrDto) : HashMap<String,String>
}