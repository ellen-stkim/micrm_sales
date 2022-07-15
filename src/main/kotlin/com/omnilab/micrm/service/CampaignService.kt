package com.omnilab.micrm.service

import com.omnilab.micrm.model.SendAuthLstDto
import com.omnilab.micrm.model.table.*


interface CampaignService {

    fun getContentsLst(dto: Tblmi_cont_mstDto): MutableMap<String, Any>
    fun getContentPreview(dto: Tblmi_cont_mstDto): Tblmi_cont_lstDto
    fun getCampContentPreview(dto: Tblmi_cont_mstDto): Tblmi_cont_lstDto
    fun getApprLst(dto: SendAuthLstDto): MutableList<Tblmi_usrDto>
    fun getProgramInfo(pro_id: String, usr_grp_cd:String, check: Boolean): MutableMap<String, Any>
    fun editProgramSt(pro_id: String, usr_grp_cd:String): Boolean
    fun apprProgramSt(pro_id: String, usr_id: String, usr_grp_cd:String): MutableMap<String, Any>
    fun cancelProgramSt(pro_id: String, usr_id: String, usr_grp_cd:String, gbn: String): MutableMap<String, Any>
    fun delProgram(pro_id: String, usr_id: String, usr_grp_cd:String): MutableMap<String, Any>
    fun getProgramSendResult(pro_id: String, type: String?,usr_grp_cd: String): MutableMap<String, Any>
    fun getProgramSendResultExcel(pro_id: String, type: String?, usr_grp_cd: String): MutableMap<String, Any>

    fun sendTempProgram(dto: Tblmicp_programDto): MutableMap<String, Any>
    fun sendProgram(dto: Tblmicp_programDto): MutableMap<String, Any>
    fun sendProgramTargetLst(dto: Tblmicp_programDto): MutableMap<String, Any>
    fun sendReject(pro_id: String, usr_id:String, usr_grp_cd:String, message: String): MutableMap<String, Any>
    fun sendInquiry(map: MutableMap<String, Any>): MutableMap<String, Any>

    //이후 배치서버로 이전대상
    fun programSend(pro_id: String, auto_tp: Boolean)

    fun getProgramSearch(pdto:Tblmicp_programDto) : Map<String, Any>

    fun getAllStatusCnt(pdto : Tblmicp_programDto) : Map<String, Any>

    // 타이틀에 필요한 programCnt 가져오기
    fun getTitleProgramCnt() : Map<String,Any>

    //Main 화면 캠페인기준으로 가져오기
    fun getCampList(cDto: Tblmicp_campaignDto) : Map<String, Any>
    //메인 페이지 camp 미리보기 가져오기
    fun getMainCampView(dto: Tblmicp_campaignDto) : Map<String, Any>

    // 캠페인명 중복체크
    fun isCheckProNm(dto : Tblmicp_programDto) : Map<String,Any>

    //타겟팅
    fun getTargetInfo(usr_grp_cd: String): Map<String, Any?>

}