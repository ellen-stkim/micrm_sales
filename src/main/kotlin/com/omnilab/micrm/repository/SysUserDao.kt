package com.omnilab.micrm.repository

import com.omnilab.micrm.model.Usr_log_searchDto
import com.omnilab.micrm.model.table.Tblmi_usrDto
import com.omnilab.micrm.model.table.Tblmi_usr_authDto
import com.omnilab.micrm.model.table.Tblmi_usr_log_hstDto

interface SysUserDao {

    fun getUserListCnt(dto: Tblmi_usrDto) : Int

    fun getUserList(dto: Tblmi_usrDto): List<Tblmi_usrDto>

    fun insertUser(dto:Tblmi_usrDto) : Int

    fun updateUser(dto:Tblmi_usrDto) : Int

    fun getMaxUser(dto:Tblmi_usrDto):Tblmi_usrDto?

    fun insertUserAuth(dto:Tblmi_usr_authDto) : Int

    fun duplicationCheckId(dto:Tblmi_usrDto):Int

    fun getUserLogCnt(dto: Tblmi_usr_log_hstDto) : Int

    fun getUserLog(dto: Tblmi_usr_log_hstDto): List<Usr_log_searchDto>

    fun updateUserAuth(dto:Tblmi_usr_authDto) : Int
}