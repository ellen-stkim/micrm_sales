package com.omnilab.micrm.service

import com.omnilab.micrm.model.Content_view_Dto
import com.omnilab.micrm.model.Contents_searchDto
import com.omnilab.micrm.model.table.Tblmicp_campaignDto
import com.omnilab.micrm.model.table.*
import java.util.HashMap


interface CampaignService {


    //이후 배치서버로 이전대상
    fun programSend(pro_id: String, auto_tp: Boolean)

    // 타이틀에 필요한 programCnt 가져오기
    fun getTitleProgramCnt() : Map<String,Any>

    //Main 화면 캠페인기준으로 가져오기
    fun getCampList(cDto: Tblmicp_campaignDto) : Map<String, Any>
    //메인 페이지 camp 미리보기 가져오기
    fun getMainCampView(dto: Tblmicp_campaignDto) : Map<String, Any>

    fun getProgramSearch(pdto:Tblmicp_programDto) : Map<String, Any>

    fun getProgramInfo(pro_id: String, usr_grp_cd:String, check: Boolean): MutableMap<String, Any>

    fun getCampContentPreview(dto: Tblmi_cont_mstDto): Tblmi_cont_lstDto

    fun getProgramSendResultExcel(pro_id: String, type: String?, usr_grp_cd: String): MutableMap<String, Any>
    fun getContentPreview(dto: Tblmicp_cont_mstDto): MutableList<HashMap<String, Any?>>
}