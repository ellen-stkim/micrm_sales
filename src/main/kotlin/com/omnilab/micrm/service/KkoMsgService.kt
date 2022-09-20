package com.omnilab.micrm.service

import com.omnilab.micrm.model.AtTmpl_searchDto
import com.omnilab.micrm.model.Contents_searchDto
import com.omnilab.micrm.model.table.*
import org.springframework.web.multipart.MultipartFile

interface KkoMsgService {
    fun selectAtTemplViewLst(dto: AtTmpl_searchDto): Map<String, Any>
    fun getTmplSearchLst(): Map<String, Any>
    fun createTmplLst(): Map<String, Any>


}