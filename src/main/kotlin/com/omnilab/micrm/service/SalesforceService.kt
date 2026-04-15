package com.omnilab.micrm.service

import com.omnilab.micrm.model.Content_list_CreateDto
import com.omnilab.micrm.model.ReturnDto
import com.omnilab.micrm.model.SalesforceDto
import com.omnilab.micrm.model.SetLst_searchDto
import com.omnilab.micrm.model.table.*
import javax.servlet.http.HttpSession

interface SalesforceService {

    fun getUser(dto: SalesforceDto, session: HttpSession): Map<String, Any>
    fun mappingLst(dto: SalesforceDto) : Map<String, Any>
    fun insertContentList(dto : Content_list_CreateDto) : ReturnDto
    fun updateContentList(dto : Tblmi_cont_lstDto) : ReturnDto
    fun checkContNm(dto:Tblmi_cont_mstDto):Int
    fun selectSenderList(dto: Tblmi_set_lstDto) : Map<String, Any>
    fun selectRejectTextList(dto: SetLst_searchDto): MutableMap<String, Any>
    fun selectImgForPopup(tblmiContImgdto: Tblmi_cont_imgDto) : Map<String,Any>

    fun getImgNmCh(dto:Tblmi_cont_imgDto): Int

    fun campaingContent(dto: Tblmi_cont_mstDto): Boolean
    fun publish(dto: Tblmicp_cont_mstDto): Boolean
    fun sendCampaign(map: MutableMap<String, Any>): Boolean
    fun getDataExtention(usrCd: String, extentionId: String, mid: String): MutableMap<String,Any>
    fun isCheckSender(usrCd: String): Map<String, Any>
}