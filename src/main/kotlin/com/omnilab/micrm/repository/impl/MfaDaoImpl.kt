package com.omnilab.micrm.repository.impl

import com.omnilab.micrm.model.*
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.model.table.mdm.LgSc_tranDto
import com.omnilab.micrm.repository.MfaDao
import org.apache.ibatis.session.SqlSession
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Repository


@Repository("MfaDaoImpl")
class MfaDaoImpl : MfaDao {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    private lateinit var sqlSession: SqlSession

    override fun selTblmiMfa(dto: Tblmi_mfa): Tblmi_mfa? {
        return sqlSession.selectOne("selTblmiMfa", dto)
    }

    override fun insTblmiMfa(dto: Tblmi_mfa): Int {
        return sqlSession.insert("insTblmiMfa", dto)
    }

    override fun updTblmiMfa(dto: Tblmi_mfa): Int {
        return sqlSession.update("updTblmiMfa", dto)
    }

    override fun insSmsLg(dto: LgSc_tranDto): Int {
        return sqlSession.insert("insSmsLg", dto)
    }
}