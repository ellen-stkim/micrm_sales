package com.omnilab.micrm.task

import com.omnilab.micrm.model.table.Tblmi_group_usrDto
import org.springframework.web.multipart.MultipartFile

interface ThreadPool {
    fun insertDetailTargetTask(file : MultipartFile, dto : Tblmi_group_usrDto)
}