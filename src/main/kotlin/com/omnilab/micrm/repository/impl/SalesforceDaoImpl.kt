package com.omnilab.micrm.repository.impl

import com.omnilab.micrm.model.SalesforceDto
import com.omnilab.micrm.model.table.Tblmi_set_lstDto
import com.omnilab.micrm.model.table.Tblmi_usrDto
import com.omnilab.micrm.repository.SalesforceDao
import org.apache.ibatis.session.SqlSession
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Repository

@Repository("SalesforceDaoImpl")
class SalesforceDaoImpl : SalesforceDao {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    private lateinit var sqlSession: SqlSession

    override fun sel_usrInfo(dto: SalesforceDto): Tblmi_usrDto? {
        return sqlSession.selectOne("sel_usrInfo", dto)
    }

    override fun mappingLst(dto: SalesforceDto): List<SalesforceDto> {
        return sqlSession.selectList("selectMappingLst", dto)
    }

    override fun upd_usrInfo(dto: Tblmi_usrDto): Int {
        return sqlSession.update("upd_usrInfo", dto)
    }
}