package com.omnilab.micrm.service

import com.omnilab.micrm.model.AtTmpl_searchDto
import com.omnilab.micrm.model.Contents_searchDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.model.table.kakao.Kko_at_tmplDto
import org.springframework.web.multipart.MultipartFile

interface KkoRestApiService {
    fun createAtTmpl(dto: Kko_at_tmplDto)


}