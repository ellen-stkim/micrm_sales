package com.omnilab.micrm.repository.impl

import com.omnilab.micrm.model.Usr_log_searchDto
import com.omnilab.micrm.model.Usr_searchDto
import com.omnilab.micrm.model.table.Tblmi_usrDto
import com.omnilab.micrm.model.table.Tblmi_usr_authDto
import com.omnilab.micrm.model.table.Tblmi_usr_log_hstDto
import com.omnilab.micrm.repository.SysUserDao
import org.apache.ibatis.session.SqlSession
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component


@Component("SysUserDaoImpl")
class SysUserDaoImpl : SysUserDao {

    @Autowired
    private lateinit var sqlSession: SqlSession

    override fun getUserListCnt(dto: Tblmi_usrDto): Int {
        return sqlSession.selectOne("getUserListCnt", dto);
    }

    override fun getUserList(dto: Tblmi_usrDto): List<Usr_searchDto> {
        return sqlSession.selectList("getUserList", dto)
    }

    override fun insertUser(dto:Tblmi_usrDto) : Int{
        return sqlSession.insert("insertUser", dto)
    }

    override fun updateUser(dto:Tblmi_usrDto) : Int{
        return sqlSession.update("updateUser", dto)
    }

    override fun getMaxUser(dto:Tblmi_usrDto):Tblmi_usrDto? {
        return sqlSession.selectOne("getMaxUser", dto)
    }

    override fun insertUserAuth(dto: Tblmi_usr_authDto) : Int{
        return sqlSession.insert("insertUserAuth", dto)
    }

    override fun duplicationCheckId(dto:Tblmi_usrDto):Int{
        return sqlSession.selectOne("duplicationCheckId",dto)
    }

    override fun getUserLogCnt(dto: Tblmi_usr_log_hstDto): Int {
        return sqlSession.selectOne("getUserLogCnt", dto);
    }

    override fun getUserLog(dto: Tblmi_usr_log_hstDto): List<Usr_log_searchDto> {
        return sqlSession.selectList("getUserLog", dto)
    }

    override fun updateUserAuth(dto: Tblmi_usr_authDto) : Int{
        return sqlSession.update("updateUserAuth", dto)
    }
}
