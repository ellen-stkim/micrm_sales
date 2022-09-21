package com.omnilab.micrm.repository

import com.omnilab.micrm.model.AtTmpl_searchDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.model.table.kakao.Kko_at_tmplDto

interface KkoAtTmplDao {
    fun selectAtTmplLst(dto: AtTmpl_searchDto): List<Tblmi_kko_at_tmplDto>
    fun getTmplSearchLst(searchDto: Tblmi_comm_cdDto): List<Tblmi_comm_cdDto>
    fun selectTotalAtTmplCnt(dto: AtTmpl_searchDto): Int
    fun selKkoAtTmpl(dto: AtTmpl_searchDto): Tblmi_kko_at_tmplDto?

}