package com.omnilab.micrm.repository.impl

import com.omnilab.micrm.model.Block_searchDto
import com.omnilab.micrm.model.UsrHst_searchDto
import com.omnilab.micrm.model.table.Tblmi_block_lstDto
import com.omnilab.micrm.model.table.Tblmi_usr_hstDto
import com.omnilab.micrm.repository.SysSecurityDao
import org.apache.ibatis.session.SqlSession
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component


@Component("SysSecurityDaoImpl")
class SysSecurityDaoImpl : SysSecurityDao {

    @Autowired
    private lateinit var sqlSession: SqlSession


    override fun getAdminUserLogCnt(dto : Tblmi_usr_hstDto): Int{
        return sqlSession.selectOne("getAdminUserLogCnt", dto)
    }

    override fun getAdminUserLogList(dto : Tblmi_usr_hstDto): MutableList<UsrHst_searchDto>{
        return sqlSession.selectList("getAdminUserLogList", dto)
    }

}
