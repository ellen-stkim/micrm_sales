package com.omnilab.micrm.repository

import com.omnilab.micrm.model.AtTmpl_searchDto
import com.omnilab.micrm.model.AtTmpl_viewDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.model.table.kakao.Kko_at_tmplDto

interface KkoAtTmplDao {
    fun selectAtTmplLst(dto: AtTmpl_searchDto): List<MutableMap<String, String>>
    fun getTmplSearchLst(searchDto: Tblmi_comm_cdDto): List<Tblmi_comm_cdDto>
    fun selectTotalAtTmplCnt(dto: AtTmpl_searchDto): Int
    fun selKkoAtTmpl(dto: AtTmpl_searchDto): Tblmi_kko_at_tmplDto?
    fun insNewTmplDto(tmplDto: Tblmi_kko_at_tmplDto): Int
    fun selTmplViewByTmplDto(seq: Tblmi_kko_at_tmplDto): AtTmpl_viewDto
    fun selTmplBytmplDto(tmplDto: Tblmi_kko_at_tmplDto): AtTmpl_viewDto
    fun updTmplDto(tmplDto: Tblmi_kko_at_tmplDto): Int

}