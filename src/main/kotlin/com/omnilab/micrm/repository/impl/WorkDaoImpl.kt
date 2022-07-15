package com.omnilab.micrm.repository.impl

import com.omnilab.micrm.model.table.Tblmi_workDto
import com.omnilab.micrm.repository.WorkDao
import org.apache.ibatis.session.SqlSession
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Repository

@Repository("WorkHistoryDaoImpl")
class WorkDaoImpl : WorkDao {

    @Autowired
    private lateinit var sqlSession : SqlSession

    override fun insertWorkHistory(tblmiWorkdto: Tblmi_workDto) {
        sqlSession.insert("insertWorkHistory", tblmiWorkdto)
    }

    override fun updateWorkHistory(tblmiWorkdto: Tblmi_workDto) {
        sqlSession.update("updateWorkHistory",tblmiWorkdto)
    }
}