package com.omnilab.micrm.repository.impl

import com.omnilab.micrm.model.table.Tblmi_usrDto
import com.omnilab.micrm.repository.MicrmUserDao
import org.apache.ibatis.session.SqlSession
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Repository

@Repository("MicrmUserDaoImpl")
class MicrmUserDaoImpl : MicrmUserDao {

    @Autowired
    private lateinit var sqlSession : SqlSession

    override fun sel_tblmi_usr(usrDto: Tblmi_usrDto) : Tblmi_usrDto {
        val userInfo : Tblmi_usrDto? = sqlSession.selectOne("sel_tblmi_usr",usrDto)
        return userInfo!!
    }

    override fun sel_login(usrDto: Tblmi_usrDto): Tblmi_usrDto {
        val userInfo : Tblmi_usrDto = sqlSession.selectOne("sel_login",usrDto)
        return userInfo
    }

    override fun sel_check_id(usrDto: Tblmi_usrDto): HashMap<String, String> {
        val statusMap = HashMap<String,String>()
        val userInfo : Tblmi_usrDto?= sqlSession.selectOne("sel_tblmi_usr",usrDto)

        if(userInfo == null){
            statusMap["isExist"] = "false"
            return statusMap
        }else{
            statusMap["isExist"] = "true"
            statusMap["userId"] = userInfo.usr_email.toString()
            return statusMap
        }
    }

    override fun updateUserPw(usrDto: Tblmi_usrDto): HashMap<String,String> {
        val statusMap = HashMap<String,String>()
        statusMap["status"] = "true"
        sqlSession.update("updateUserPw",usrDto)
        return statusMap
    }
}