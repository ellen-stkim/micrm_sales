package com.omnilab.micrm.repository

import com.omnilab.micrm.model.table.Tblmi_workDto

interface SysWorkDao {

    fun getWorkListCnt(dto: Tblmi_workDto): Int

    fun getWorkList(dto: Tblmi_workDto): List<Tblmi_workDto>

    fun selectWorkListForAlarm(dto : Tblmi_workDto) : List<Tblmi_workDto>

    fun checkAlarmCnt(dto: Tblmi_workDto) : Int

    fun updateAlarmStatus(dto : Tblmi_workDto) : Int

}