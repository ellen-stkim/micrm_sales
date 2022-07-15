package com.omnilab.micrm.service

import com.omnilab.micrm.model.table.Tblmi_usrDto
import com.omnilab.micrm.model.table.Tblmi_usr_log_hstDto


interface SysUserService {

    fun getUserList(udto:Tblmi_usrDto):MutableMap<String, Any>

    fun saveUser(udto:Tblmi_usrDto):MutableMap<String, Any>

    fun getAllUserList(uDto : Tblmi_usrDto): MutableMap<String, Any>

    fun updateUsrSt(uDto : Tblmi_usrDto): MutableMap<String, Any>

    fun getUserLog(uDto : Tblmi_usr_log_hstDto): MutableMap<String, Any>

}