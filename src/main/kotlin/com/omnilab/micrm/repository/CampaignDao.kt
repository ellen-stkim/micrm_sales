package com.omnilab.micrm.repository

import com.omnilab.micrm.model.Contents_lstDto
import com.omnilab.micrm.model.SendResult_lstDto
import com.omnilab.micrm.model.table.*
import org.apache.poi.ss.usermodel.Workbook

interface CampaignDao {

    fun sel_ContentsListCnt(dto: Tblmi_cont_mstDto): Int
    fun sel_ContentsList(dto: Tblmi_cont_mstDto): MutableList<Tblmi_cont_lstDto>
    fun sel_camp_ContentsList(dto: Tblmi_cont_mstDto): MutableList<Tblmi_cont_lstDto>
    fun sel_cont_lst(dto: Tblmi_cont_lstDto): MutableList<Tblmi_cont_lstDto>
    fun sel_cont_url_lst(dto: Tblmi_cont_url_lstDto): MutableList<Tblmi_cont_url_lstDto>
    fun sel_camp_cont_mst(dto: Tblmicp_cont_mstDto): Tblmicp_cont_mstDto
    fun sel_camp_send_hst_cnt(dto: Tblmicp_send_hstDto): Int
    fun sel_tblmicp_programOne(dto: Tblmicp_programDto): Tblmicp_programDto
    fun sel_tblmicp_program(dto: Tblmicp_programDto): MutableList<Tblmicp_programDto>
    fun sel_tblmicp_campaign(dto: Tblmicp_campaignDto): MutableList<Tblmicp_campaignDto>
    fun sel_tblmicp_cont_lst(dto: Tblmicp_cont_lstDto): MutableList<Contents_lstDto>
    fun sel_apprLst(dto: Tblmi_usr_authDto): MutableList<Tblmi_usrDto>
    fun sel_tblmi_traget_grp(dto: Tblmi_target_grpDto): Tblmi_target_grpDto
    fun sel_send_status_cnt(pro_id: String): MutableMap<String, Any>
    fun sel_tarck_open_cnt(pro_id: String): MutableMap<String, Any>
    fun sel_tarck_url_cnt(pro_id: String): MutableMap<String, Any>
    fun sel_send_program_cnt(dto: Tblmicp_programDto): MutableMap<String, Any>
    fun sel_send_program_rstLst(dto: Tblmicp_send_hstDto): List<SendResult_lstDto>
    fun sel_send_program_rstLstExcel(book : Workbook, dto : Tblmicp_send_hstDto)
    fun sel_tblmicp_cont_url_lst(urlDto: Tblmicp_cont_url_lstDto): MutableList<Tblmicp_cont_url_lstDto>?

    fun ins_program(dto: Tblmicp_programDto): Int
    fun ins_campaign(dto: Tblmicp_campaignDto): Int
    fun ins_campaign_cont_mst(dto: Tblmicp_cont_mstDto): Int
    fun ins_campaign_cont_lst(dto: Tblmicp_cont_lstDto): Int
    fun ins_campaign_cont_url_lst(list: List<Tblmicp_cont_url_lstDto>): Int
    fun ins_campaign_send_hst(list: List<Tblmicp_send_hstDto>): Int
    fun ins_programSendHst(dto: Tblmicp_programDto): MutableList<Int>

    fun upd_tblmicp_program(dto: Tblmicp_programDto): Int
    fun upd_tblmicp_campaign(dto: Tblmicp_campaignDto): Int
    fun upd_tblmicp_camapaign_cnt_hst(dto: Tblmicp_campaignDto): Int
    fun upd_tblmicp_program_cnt_hst(pro_id: String): Int

    fun del_program(dto: Tblmicp_programDto): Int
    fun del_campaign(dto: Tblmicp_campaignDto): Int
    fun del_camp_content(cont_id: Int): Int
    fun del_err_tblmicp_send_hst(pro_id: String): Int

    fun getProgramSearchCnt(dto:Tblmicp_programDto): Int
    fun getProgramList(dto: Tblmicp_programDto):List<Tblmicp_programDto>
    fun getProgramCnt(dto: Tblmicp_programDto): MutableMap<String, Any>

    fun getTitleProgramCnt(dto : Tblmicp_programDto) : MutableMap<String,Any>


}