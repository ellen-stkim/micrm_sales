package com.omnilab.micrm.repository.impl

import com.omnilab.micrm.repository.TestDao
import org.apache.ibatis.session.SqlSession
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component


@Component("TestDaoImpl")
class TestDaoImpl: TestDao{

    @Autowired
    private lateinit var sqlSession: SqlSession

    override fun test(test:String): Int {
        return sqlSession.insert("test", test)
    }
}