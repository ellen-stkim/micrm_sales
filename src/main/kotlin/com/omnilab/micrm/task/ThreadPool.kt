package com.omnilab.micrm.task

import com.omnilab.micrm.model.GroupUsr_SearchDto
import com.omnilab.micrm.model.table.Tblmi_group_listDto
import com.omnilab.micrm.model.table.Tblmi_group_usrDto
import com.omnilab.micrm.model.table.Tblmicp_programDto
import org.springframework.web.multipart.MultipartFile

interface ThreadPool {

    fun sendHstProgram(programDto: Tblmicp_programDto, auto: Boolean)
    fun insertGroupTask(groupListDto: Tblmi_group_listDto)
    fun insertDetailTargetTask(file : MultipartFile, dto : Tblmi_group_usrDto)
}