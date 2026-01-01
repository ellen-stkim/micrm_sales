package com.omnilab.micrm.service

import com.omnilab.micrm.model.SetLst_searchDto
import com.omnilab.micrm.model.table.Tblmi_cont_lstDto
import com.omnilab.micrm.model.table.Tblmi_cont_mstDto
import com.omnilab.micrm.model.table.Tblmi_kko_at_tmplDto
import com.omnilab.micrm.model.table.Tblmi_set_lstDto

interface ContentService {

    fun selectContentView(dto : Tblmi_cont_mstDto) : Map<String,Any>

    fun selectOneContentView(dto:Tblmi_cont_mstDto):Map<String, Any>

    fun updateContentMst(dto:Tblmi_cont_mstDto):Map<String, Any>

    fun updateContentsMstDelYn(list : MutableList<Int>) : Map<String,Any>

    //fun insertContentList(dto:Content_list_CreateDto):Map<String, Any>

    fun insertContentList(dto : Tblmi_cont_lstDto) : Map<String,Any>

    //fun updateContentLst(dto:Content_list_CreateDto) : Map<String, Any>

    fun updateContentLst(dto : Tblmi_cont_lstDto) : Map<String,Any>

    fun checkContNm(dto:Tblmi_cont_mstDto):Int

    fun selectSenderList(dto: Tblmi_set_lstDto) : Map<String, Any>

    fun isCheckSender() : Map<String,Any>

    fun contentsThumbnailSave(map: MutableMap<String, Any>) : Boolean

    fun previewJsonService(dto : Tblmi_cont_lstDto) : Map<String,Any>

    fun previewATJsonService(dto: Tblmi_kko_at_tmplDto): Map<String,Any>

    fun selectRejectTextList(smsDto: SetLst_searchDto): Map<String,Any>

}