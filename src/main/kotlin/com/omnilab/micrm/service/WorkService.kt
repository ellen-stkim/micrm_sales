package com.omnilab.micrm.service

import com.omnilab.micrm.model.table.Tblmi_workDto


interface WorkService {

    fun insertWorkHistory(workDto : Tblmi_workDto);

    fun updateWorkHistory(workDto: Tblmi_workDto)

    // 그룹 유저 Insert 작업 로그 작성
    fun makeGrpUserWork() : Tblmi_workDto;

    // 그룹 유저 Success Work
    fun successGrpUserWork(workDto: Tblmi_workDto)

    // 그룹 유저 Fail
    fun failGrpUserWork(workDto: Tblmi_workDto)

    fun makeWorkHistory(workType : String , workState : String, workMsg : String) : Tblmi_workDto

}