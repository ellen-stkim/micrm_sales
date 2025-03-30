package com.omnilab.micrm.repository.impl

import com.omnilab.micrm.model.AtTmpl_searchDto
import com.omnilab.micrm.model.AtTmpl_viewDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.repository.KkoAtTmplDao
import org.apache.ibatis.session.SqlSession
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Repository

@Repository("KkoAtTmplDaoImpl")
class KkoAtTmplDaoImpl : KkoAtTmplDao {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    private lateinit var sqlSession: SqlSession

    override fun selectAtTmplLst(dto: AtTmpl_searchDto): List<AtTmpl_viewDto> {
        return sqlSession.selectList("selAtTmplLst",dto)
    }

    override fun getTmplSearchLst(searchDto: Tblmi_comm_cdDto): List<Tblmi_comm_cdDto> {
        return sqlSession.selectList("getTmplSearchLst",searchDto)
    }

    override fun selectTotalAtTmplCnt(dto: AtTmpl_searchDto): Int {
        return sqlSession.selectOne("selTotalAtTmplCnt",dto)
    }

    override fun selKkoAtTmpl(dto: AtTmpl_searchDto): Tblmi_kko_at_tmplDto? {
        return sqlSession.selectOne("selKkoAtTmpl",dto)
    }

    override fun insNewTmplDto(tmplDto: Tblmi_kko_at_tmplDto): Int {
        return sqlSession.insert("insNewTmplDto",tmplDto)
    }

    override fun selTmplViewByTmplDto(seq: Tblmi_kko_at_tmplDto): AtTmpl_viewDto {
        return sqlSession.selectOne("selTmplViewByTmplDto",seq)
    }

    override fun selTmplBytmplDto(tmplDto: AtTmpl_searchDto):AtTmpl_viewDto {
        return sqlSession.selectOne("selTmplBytmplDto",tmplDto)
    }

    override fun updTmplDto(tmplDto: Tblmi_kko_at_tmplDto): Int {
        return sqlSession.update("updTmplDto",tmplDto)
    }

    override fun updTmplDtoBySeq(tmplDto: Tblmi_kko_at_tmplDto): Int {
        return sqlSession.update("updTmplDtoBySeq",tmplDto)
    }

    override fun selKkoAtTmplByGrpCd(dto: AtTmpl_searchDto): Tblmi_kko_at_tmplDto? {
        return sqlSession.selectOne("selKkoAtTmplByGrpCd",dto)
    }

    override fun delTmpl(dto: Tblmi_kko_at_tmplDto): Int {
        return sqlSession.update("delTmpl", dto)
    }
}
