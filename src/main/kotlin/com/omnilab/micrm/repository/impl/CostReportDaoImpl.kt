package com.omnilab.micrm.repository.impl

import com.omnilab.micrm.common.AES256
import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.GlobalValues
import com.omnilab.micrm.model.table.edm.Camp_send_edm_tableDto
import com.omnilab.micrm.model.Contents_lstDto
import com.omnilab.micrm.model.SearchSendCostDto
import com.omnilab.micrm.model.SendCostDto
import com.omnilab.micrm.model.table.Tblmicp_campaignDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.repository.CampaignSendDao
import com.omnilab.micrm.repository.CostReportDao
import org.apache.ibatis.session.ResultContext
import org.apache.ibatis.session.ResultHandler
import org.apache.ibatis.session.SqlSession
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Repository

@Repository("CostReportDaoImpl")
class CostReportDaoImpl : CostReportDao {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    private lateinit var sqlSession: SqlSession

    override fun selSendCostLst(hstDto: SearchSendCostDto?): MutableList<SendCostDto> {

        return sqlSession.selectList("selSendCostLst", hstDto)
    }

    override fun selDailySendCostLst(searchDto: SearchSendCostDto): List<SendCostDto> {
        return sqlSession.selectList("selDailySendCostLst", searchDto)
    }

    override fun selTotalSendCost(searchDto: SearchSendCostDto): List<SendCostDto> {
        return sqlSession.selectList("selTotalSendCost", searchDto)
    }

    override fun selPrgSendCostLst(hstDto: SendCostDto?): MutableList<SendCostDto> {
        return sqlSession.selectList("selPrgSendCostLst", hstDto)
    }

    override fun selPrgSendCostLstCnt(searchDto: SearchSendCostDto?): Int {
        return sqlSession.selectOne("selPrgSendCostLstCnt", searchDto)
    }



}