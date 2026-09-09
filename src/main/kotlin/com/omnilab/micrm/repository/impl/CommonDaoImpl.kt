package com.omnilab.micrm.repository.impl

import com.omnilab.micrm.model.BanWordHst_searchDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.repository.CommonDao
import org.apache.ibatis.session.SqlSession
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Repository


@Repository("CommonDaoImpl")
class CommonDaoImpl : CommonDao {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    private lateinit var sqlSession: SqlSession

    override fun sel_tblmi_usrOne(dto: Tblmi_usrDto): Tblmi_usrDto {
        return sqlSession.selectOne("sel_tblmi_usr", dto)
    }

    override fun sel_tblmi_usr(dto: Tblmi_usrDto): List<Tblmi_usrDto> {
        return sqlSession.selectList("sel_tblmi_usr", dto)
    }

    override fun insertUserHistoryLog(dto: Tblmi_usr_hstDto): Int {
        return sqlSession.insert("insertUserHistoryLog", dto)
    }

    override fun ins_tblmi_ban_word_hst(dto: Tblmi_ban_word_hstDto): Int {
        return sqlSession.insert("ins_tblmi_ban_word_hst", dto)
    }

    override fun sel_tblmi_ban_word_hstCnt(dto: BanWordHst_searchDto): Int {
        return sqlSession.selectOne("sel_tblmi_ban_word_hstCnt", dto)
    }

    override fun sel_tblmi_ban_word_hst(dto: BanWordHst_searchDto): List<Tblmi_ban_word_hstDto> {
        return sqlSession.selectList("sel_tblmi_ban_word_hst", dto)
    }


}