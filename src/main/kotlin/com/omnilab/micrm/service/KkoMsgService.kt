package com.omnilab.micrm.service

import com.omnilab.micrm.model.AtTmpl_searchDto
import com.omnilab.micrm.model.Contents_searchDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.model.table.kakao.Kko_at_tmplDto
import org.springframework.web.multipart.MultipartFile

interface KkoMsgService {
    fun selectAtTemplViewLst(dto: AtTmpl_searchDto): Map<String, Any>
    fun getTmplSearchLst(): Map<String, Any>
    fun tmplCreateLst(): Map<String, Any>
    fun getKkoAtTmplDto(dto: AtTmpl_searchDto): Tblmi_kko_at_tmplDto?
    fun createTmpl(dto: Kko_at_tmplDto): Any?


}