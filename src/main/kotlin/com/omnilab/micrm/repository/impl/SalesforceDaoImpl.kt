package com.omnilab.micrm.repository.impl

import com.omnilab.micrm.model.SalesforceDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.repository.SalesforceDao
import org.apache.ibatis.session.SqlSession
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Repository

@Repository("SalesforceDaoImpl")
class SalesforceDaoImpl: SalesforceDao {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    private lateinit var sqlSession: SqlSession

    override fun sel_usrInfo(dto: SalesforceDto): Tblmi_usrDto? {
        return sqlSession.selectOne("sel_usrInfo", dto)
    }

    override fun mappingLst(dto: SalesforceDto): MutableList<SalesforceDto> {
        return sqlSession.selectList("selectMappingLst", dto)
    }

    override fun sel_tblmi_cont_mstOne(dto: Tblmi_cont_mstDto): Tblmi_cont_mstDto {
        return sqlSession.selectOne("sel_tblmi_cont_mstOne", dto)
    }

    override fun sel_tblmi_cont_lst(dto: Tblmi_cont_lstDto): MutableList<Tblmi_cont_lstDto> {
        return sqlSession.selectList("sel_tblmi_cont_lst", dto)
    }

    override fun sel_tblmicp_cont_mst(dto: Tblmicp_cont_mstDto): MutableList<Tblmicp_cont_mstDto> {
        return sqlSession.selectList("sel_tblmicp_cont_mst", dto)
    }

    /*
    override fun ins_tblmicp_cont(dto: Tblmicp_cont_mstDto): Boolean {
        return true
    }
     */


    override fun ins_tblmicp_cont_mst(dto: Tblmicp_cont_mstDto): Int {
        val check = sqlSession.selectOne<Tblmicp_cont_mstDto>("sel_tblmicp_cont_mst", dto)
        return if(check == null){
            sqlSession.insert("ins_tblmicp_cont_mst", dto)
        }else{
            sqlSession.update("upd_tblmicp_cont_mst", dto)
        }
    }

    override fun ins_tblmicp_cont_lst(dto: Tblmicp_cont_lstDto): Int {
        return sqlSession.insert("ins_tblmicp_cont_lst", dto)
    }

    override fun ins_tblmicp_cont_url_lst(dto: MutableMap<String, Any>): Int {
        return sqlSession.insert("ins_tblmicp_cont_url_lst", dto)
    }

    override fun ins_tblmicp_sales_execute(dto: MutableMap<String, Any>): Int {
        return sqlSession.insert("ins_tblmicp_sales_execute", dto)
    }


    override fun upd_tblmicp_cont_mst(dto: Tblmicp_cont_mstDto): Int {
        return sqlSession.update("upd_tblmicp_cont_mst", dto)
    }

    override fun upd_usrInfo(dto: Tblmi_usrDto): Int {
        return sqlSession.update("upd_usrInfo", dto)
    }

    override fun upd_tblmi_cont_mst(dto: Tblmi_cont_mstDto): Int {
        return sqlSession.update("upd_tblmi_cont_mst", dto)
    }

    override fun del_tblmicp_cont_lst(cont_cd: String): Int {
        return sqlSession.delete("del_tblmicp_cont_lst", cont_cd)
    }

    override fun del_tblmicp_cont_url_lst(cont_cd: String): Int {
        return sqlSession.delete("del_tblmicp_cont_url_lst", cont_cd)
    }
}