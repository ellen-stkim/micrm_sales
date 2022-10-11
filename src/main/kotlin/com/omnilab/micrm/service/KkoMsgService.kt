package com.omnilab.micrm.service

import com.omnilab.micrm.model.AtTmpl_searchDto
import com.omnilab.micrm.model.AtTmpl_viewDto
import com.omnilab.micrm.model.Contents_searchDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.model.table.kakao.Kko_at_tmplDto
import org.springframework.web.multipart.MultipartFile

interface KkoMsgService {
    fun selectAtTemplViewLst(dto: AtTmpl_searchDto): Map<String, Any>
    fun getTmplSearchLst(): Map<String, Any>
    fun tmplCreateLst(): Map<String, Any>
    fun tmplDataLst(): Map<String, Any>
    fun getKkoAtTmplDto(dto: AtTmpl_searchDto): Tblmi_kko_at_tmplDto?
    fun createTmpl(dto: Kko_at_tmplDto, name: Tblmi_kko_at_tmplDto): Map<String, Any>
    fun selTmplDataBySeq(seq: Int): AtTmpl_viewDto
    fun updateTmpl(dto: Kko_at_tmplDto, searchDto: AtTmpl_searchDto): Map<String, Any>
    fun cancleTmplReq(seq: AtTmpl_searchDto, updId: String) : MutableMap<String, Any>
    fun updAtTmplData(searchDto: AtTmpl_searchDto, updId: String?): MutableMap<String, Any>
    fun reqTmplST(searchDto: AtTmpl_searchDto, updId: String?): MutableMap<String, Any>
    fun removeTmpl(searchDto: AtTmpl_searchDto, name: String?): MutableMap<String, Any>
    fun cancleTmplApp(searchDto: AtTmpl_searchDto, name: String?): MutableMap<String, Any>
}