package com.omnilab.micrm.repository.impl

import com.omnilab.micrm.model.Content_view_Dto
import com.omnilab.micrm.model.SendReportDto
import com.omnilab.micrm.model.table.Tblmicp_programDto
import com.omnilab.micrm.model.table.Tblmire_camp_mstDto
import com.omnilab.micrm.repository.CampaignReportDao
import org.apache.ibatis.session.SqlSession
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Repository


@Repository("CampaignReportDaoImpl")
class CampaignReportDaoImpl : CampaignReportDao {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    private lateinit var sqlSession: SqlSession

    override fun getCampMstSearchCnt(dto: Tblmicp_programDto): Int {
        return sqlSession.selectOne("getCampMstSearchCnt", dto)
    }

    override fun getCampMstList(dto: Tblmicp_programDto): List<Map<String,Any>> {
        return sqlSession.selectList("getCampMstList", dto)
    }

    override fun getCampMst(proId: String): List<Tblmire_camp_mstDto> {
        return sqlSession.selectList("getCampMst", proId)
    }
/*
    override fun getProgramReportList(dto: Tblmicp_programDto): List<Map<String,Any>> {
        return sqlSession.selectList("getProgramReportList", dto)
    }*/

    override fun getCampMstTotalDetail(map: HashMap<String, Any>): Tblmire_camp_mstDto {
        return sqlSession.selectOne("getCampMstTotalDetail", map)
    }

    override fun getCampMstTotalList(map: HashMap<String, Any>): List<Map<String,Any>>{

        return sqlSession.selectList("getCampMstTotalList", map)
    }

    override fun getSendHstDetail(searchMap: HashMap<String, Any>): List<SendReportDto> {
        return sqlSession.selectList("getSendHstDetail", searchMap)
    }

    override fun openTimingResult(map: HashMap<String, Any>): List<HashMap<String, Any>> {
        return sqlSession.selectList("openTimingResult", map)
    }

    override fun getCampMstContIdByProId(proId: String): MutableList<String>? {
        return sqlSession.selectList<String>("getCampMstContIdByProId", proId)
    }

    override fun getLinkClickCnt(seq: Int?): MutableList<java.util.HashMap<String, Any?>> {
        return sqlSession.selectList("getLinkClickCnt", seq)
    }

    override fun getContentsLst(seq: Int?): Content_view_Dto {
        return sqlSession.selectOne("getContentsLst", seq)
    }



}