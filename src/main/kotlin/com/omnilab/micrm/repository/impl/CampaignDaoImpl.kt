package com.omnilab.micrm.repository.impl

import com.omnilab.micrm.model.*
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.repository.CampaignDao
import org.apache.ibatis.session.ResultContext
import org.apache.ibatis.session.ResultHandler
import org.apache.ibatis.session.SqlSession
import org.apache.poi.ss.usermodel.Workbook
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Repository


@Repository("CampaignDaoImpl")
class CampaignDaoImpl : CampaignDao {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    private lateinit var sqlSession: SqlSession

    override fun sel_ContentsList(dto: Tblmi_cont_mstDto): MutableList<Tblmi_cont_lstDto> {
        return sqlSession.selectList("sel_ContentsList", dto)
    }

    override fun sel_camp_cont_mst(dto: Tblmicp_cont_mstDto): Tblmicp_cont_mstDto {
        return sqlSession.selectOne("sel_camp_cont_mstOne", dto)
    }

    override fun sel_tblmicp_campaign(dto: Tblmicp_campaignDto): MutableList<Tblmicp_campaignDto> {
        return sqlSession.selectList("sel_tblmicp_campaign", dto)
    }

    override fun sel_campaign_data(dto: Tblmicp_campaignDto): MutableList<Campaign_searchDto> {
        return sqlSession.selectList("sel_campaign_data", dto)
    }

    override fun sel_tblmicp_cont_lst(dto: Tblmicp_cont_lstDto): MutableList<Contents_lstDto> {
        return sqlSession.selectList("sel_tblmicp_cont_lst", dto)
    }

    override fun sel_tblmi_traget_grp(dto: Tblmi_target_grpDto): Tblmi_target_grpDto {
        return sqlSession.selectOne("sel_tblmi_traget_grp", dto)
    }

    override fun sel_send_status_cnt(pro_id: String): MutableMap<String, Any> {
        val re_map = HashMap<String, Any>()
        val map = sqlSession.selectList<MutableMap<String, Any>>("sel_send_status_cnt", pro_id)
        for(m in map){
            re_map[m["camp_id"].toString()] = m
        }
        return re_map
    }

    override fun sel_tarck_open_cnt(pro_id: String): MutableMap<String, Any> {
        val re_map = HashMap<String, Any>()
        val map = sqlSession.selectList<MutableMap<String, Any>>("sel_tarck_open_cnt", pro_id)
        for(m in map){
            re_map[m["camp_id"].toString()] = m
        }
        return re_map
    }

    override fun sel_tarck_url_cnt(pro_id: String): MutableMap<String, Any> {
        val re_map = HashMap<String, Any>()
        val map = sqlSession.selectList<MutableMap<String, Any>>("sel_tarck_url_cnt", pro_id)
        for(m in map){
            re_map[m["camp_id"].toString()] = m
        }
        return re_map
    }

    override fun sel_tblmicp_programOne(dto: Tblmicp_programDto): Tblmicp_programDto {
        return sqlSession.selectOne("sel_tblmicp_program", dto)
    }


    override fun sel_camp_ContentsList(dto: Tblmi_cont_mstDto): MutableList<Tblmi_cont_lstDto> {
        return sqlSession.selectList("sel_camp_ContentsList", dto)
    }


    override fun ins_program(dto: Tblmicp_programDto): Int {
        return sqlSession.insert("ins_tblmicp_program", dto)
    }

    override fun ins_programSendHst(dto: Tblmicp_programDto): MutableList<Int> {
        val list = ArrayList<Int>()
        val campLst = sqlSession.selectList<Tblmicp_campaignDto>("sel_tblmicp_campaign", Tblmicp_campaignDto(dto.pro_id))
        for(campDto in campLst){
            val mstDto = Contents_searchDto(campDto.cont_id)
            val contDto = sqlSession.selectOne<Contents_lstDto>("sel_camp_ContentsList", mstDto)

            val sendHstDto = Tblmicp_send_hstDto()
            sendHstDto.pro_id = dto.pro_id
            sendHstDto.camp_id = campDto.seq
            when (campDto.send_tg_tp) {
                "TEST" -> sendHstDto.tbl_id = "tblmite_target_lst"
                "TG02" -> sendHstDto.tbl_id = "tblmi_target_lst"
                else -> sendHstDto.tbl_id = null
            }
            sendHstDto.send_yn = "N"
            sendHstDto.auto_tp = null
            sendHstDto.usr_grp_cd = dto.usr_grp_cd
            sendHstDto.reg_id = dto.reg_id
            sendHstDto.camp_ch = campDto.camp_ch
            sendHstDto.send_mdm = contDto.send_tp

            val insLst = ArrayList<Tblmicp_send_hstDto>()

            sqlSession.select("sel_programSendHst", sendHstDto, object : ResultHandler<Any> {
                override fun handleResult(resultContext: ResultContext<*>) {
                    val dto = resultContext.resultObject as Tblmicp_send_hstDto
                    if (!dto.send_to.isNullOrEmpty()) {
                        insLst.add(dto)
                    }
                    if (insLst.isNotEmpty() && (insLst.size % 1000) == 0) {
                        sqlSession.insert("ins_programSendHst", insLst)
                        insLst.clear()
                    }
                }
            })
            if (insLst.isNotEmpty()) {
                sqlSession.insert("ins_programSendHst", insLst)
                insLst.clear()
            }
            list.add(campDto.seq!!)
        }
        return list
    }

    override fun ins_campaign(dto: Tblmicp_campaignDto): Int {
        return sqlSession.insert("ins_tblmicp_campaign", dto)
    }

    override fun upd_tblmicp_program(dto: Tblmicp_programDto): Int {
        return sqlSession.update("upd_tblmicp_program", dto)
    }

    override fun upd_tblmicp_camapaign_cnt_hst(dto: Tblmicp_campaignDto): Int {
        return sqlSession.update("upd_tblmicp_camapaign_cnt_hst", dto)
    }

    override fun upd_tblmicp_program_cnt_hst(pro_id: String): Int {
        return sqlSession.update("upd_tblmicp_program_cnt_hst", pro_id)
    }

    override fun getTitleProgramCnt(dto: Tblmicp_programDto): MutableMap<String,Any> {
        return sqlSession.selectOne("getTitleProgramCnt",dto)
    }

    override fun ins_programSendHst(dto: Tblmicp_send_hstDto): Int {
        return sqlSession.insert("ins_programSendHstOne", dto)
    }

    override fun getProgramSearchCnt(dto:Tblmicp_programDto): Int{
        return sqlSession.selectOne("getProgramSearchCnt", dto)
    }
    override fun getProgramList(dto: Tblmicp_programDto):List<Tblmicp_programDto>{
        return sqlSession.selectList("getProgramList", dto)
    }

    override fun getProgramCnt(dto: Tblmicp_programDto): MutableMap<String, Any>{
        return sqlSession.selectOne("getProgramCnt", dto)
    }

    override fun sel_send_program_rstLstExcel(book: Workbook, dto: Tblmicp_send_hstDto) {
        sqlSession.select("sel_send_program_rstLst", dto, object : ResultHandler<Any> {
            val sheet = book.getSheet("sheet1")
            var i = sheet.lastRowNum + 1

            override fun handleResult(resultContext: ResultContext<*>) {
                val row = sheet.createRow(i)
                val dd: SendResult_lstDto = resultContext.resultObject as SendResult_lstDto
                row.createCell(0).setCellValue(dd.camp_nm)
                row.createCell(1).setCellValue(dd.send_rst)
                row.createCell(2).setCellValue(dd.send_to)
                row.createCell(3).setCellValue(dd.cd_desc)
                row.createCell(4).setCellValue(dd.send_rep_time)
                row.createCell(5).setCellValue(dd.send_mdm)
                i++
            }
        })
    }

}