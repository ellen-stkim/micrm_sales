package com.omnilab.micrm.service

import com.omnilab.micrm.model.Content_list_CreateDto
import com.omnilab.micrm.model.Content_view_Dto
import com.omnilab.micrm.model.table.Tblmi_cont_imgDto
import com.omnilab.micrm.model.table.Tblmi_cont_lstDto
import com.omnilab.micrm.model.table.Tblmi_cont_mstDto
import com.omnilab.micrm.model.table.Tblmi_set_lstDto

interface MobileContentService {

    fun insertMobileContentList(tblmiContMstdto: Tblmi_cont_mstDto, contentListCreatedto: Content_list_CreateDto) : HashMap<String,String>

    fun select_sender_list(tblmiSetLstDto: Tblmi_set_lstDto) : MutableMap<String, Any>

    fun isCheckMoblieContentNm(tblmiContMstdto: Tblmi_cont_mstDto) : HashMap<String,String>

    fun contentUpload(dto: Tblmi_cont_imgDto) : MutableMap<String, Any>

   // fun selectMobileContent(tblmiContMstdto: Tblmi_cont_mstDto) : MutableMap<String,Any>

    fun selectMobileContentCnt(tblmiContMstdto: Tblmi_cont_mstDto) : Int

    fun deleteMobileContent(mobileNoList : MutableList<Int>) : MutableMap<String,String>

    fun updateMobileUseYn(tblmiContMstdto: Tblmi_cont_mstDto) : MutableMap<String,String>

    fun getImgList(dto: Tblmi_cont_imgDto) : MutableMap<String, Any>

    fun deleteImgList(list: MutableList<Int>): MutableMap<String,Any>

    fun selectMobileContentUseTitle(tblmiContMstdto: Tblmi_cont_mstDto) : List<Content_view_Dto>

    fun updateImgYn(dto: Tblmi_cont_imgDto) : Int

    fun selectPriorityMobileContent(tblmiContMstdto: Tblmi_cont_mstDto ) : List<Content_view_Dto>

    fun selectImgForPopup(tblmiContImgdto: Tblmi_cont_imgDto) : MutableMap<String,Any>
    
    fun detailMobileContent(tblmiContMstdto: Tblmi_cont_mstDto) : MutableMap<String,Any>

    fun rcsButtonMakeJsonString(contentListCreatedto: Content_list_CreateDto, tblmiContLstdto : Tblmi_cont_lstDto)

    fun rcsButtonMakeJsonStringSlide(contentListCreatedto: Content_list_CreateDto , tblmiContLstdto : Tblmi_cont_lstDto)

    fun rcsSlideSetting(contentListCreatedto: Content_list_CreateDto, tblmiContLstdto: Tblmi_cont_lstDto)

    fun updateMobileContent(contentListCreatedto: Content_list_CreateDto, tblmiContMstdto: Tblmi_cont_mstDto)

    fun jsonViewContentsParsing(contentViewDto: Content_view_Dto)

    fun isExistKakao() : Int


}