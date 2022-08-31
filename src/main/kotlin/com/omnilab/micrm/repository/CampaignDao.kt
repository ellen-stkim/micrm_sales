package com.omnilab.micrm.repository

import com.omnilab.micrm.model.Contents_lstDto
import com.omnilab.micrm.model.SendResult_lstDto
import com.omnilab.micrm.model.table.*
import org.apache.poi.ss.usermodel.Workbook

interface CampaignDao {

    fun sel_ContentsList(dto: Tblmi_cont_mstDto): MutableList<Tblmi_cont_lstDto>
    fun sel_camp_cont_mst(dto: Tblmicp_cont_mstDto): Tblmicp_cont_mstDto?
    fun sel_tblmicp_campaign(dto: Tblmicp_campaignDto): MutableList<Tblmicp_campaignDto>
    fun sel_tblmicp_cont_lst(dto: Tblmicp_cont_lstDto): MutableList<Contents_lstDto>
    fun sel_tblmi_traget_grp(dto: Tblmi_target_grpDto): Tblmi_target_grpDto
    fun sel_send_status_cnt(pro_id: String): MutableMap<String, Any>
    fun sel_tarck_open_cnt(pro_id: String): MutableMap<String, Any>
    fun sel_tarck_url_cnt(pro_id: String): MutableMap<String, Any>

    fun ins_program(dto: Tblmicp_programDto): Int
    fun ins_programSendHst(dto: Tblmicp_programDto): MutableList<Int>
    fun ins_programSendHst(dto: Tblmicp_send_hstDto): Int

    fun ins_campaign(dto: Tblmicp_campaignDto): Int

    fun upd_tblmicp_program(dto: Tblmicp_programDto): Int
    fun upd_tblmicp_camapaign_cnt_hst(dto: Tblmicp_campaignDto): Int
    fun upd_tblmicp_program_cnt_hst(pro_id: String): Int

    fun getTitleProgramCnt(dto : Tblmicp_programDto) : MutableMap<String,Any>


}