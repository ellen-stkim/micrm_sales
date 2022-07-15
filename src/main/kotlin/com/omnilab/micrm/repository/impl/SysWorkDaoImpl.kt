package com.omnilab.micrm.repository.impl

import com.omnilab.micrm.model.table.Tblmi_workDto
import com.omnilab.micrm.repository.SysWorkDao
import org.apache.ibatis.session.SqlSession
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component


@Component("SysWorkDaoImpl")
class SysWorkDaoImpl : SysWorkDao {

    @Autowired
    private lateinit var sqlSession: SqlSession

    override fun getWorkListCnt(dto: Tblmi_workDto): Int {
        return sqlSession.selectOne("getWorkListCnt", dto);
    }

    override fun getWorkList(dto: Tblmi_workDto): List<Tblmi_workDto> {
        return sqlSession.selectList("getWorkList", dto)
    }

    override fun selectWorkListForAlarm(dto: Tblmi_workDto): List<Tblmi_workDto> {
        return sqlSession.selectList("selectWorkHstForAlarm", dto)
    }

    override fun checkAlarmCnt(dto: Tblmi_workDto): Int {
        return sqlSession.selectOne("checkAlarmCnt",dto)
    }

    override fun updateAlarmStatus(dto: Tblmi_workDto): Int {
        return sqlSession.update("updateAlarmStatus", dto)
    }
}