package com.omnilab.micrm.service

import com.omnilab.micrm.model.SalesforceDto
import com.omnilab.micrm.model.table.Tblmi_cont_imgDto
import com.omnilab.micrm.model.table.Tblmi_cont_lstDto
import com.omnilab.micrm.model.table.Tblmi_cont_mstDto
import com.omnilab.micrm.model.table.Tblmi_set_lstDto
import javax.servlet.http.HttpSession

interface SalesforceService {

    fun getUser(dto: SalesforceDto, session: HttpSession): Map<String, Any>

    fun mappingLst(dto: SalesforceDto) : Map<String, Any>

    fun insertContentList(dto : Tblmi_cont_lstDto) : Map<String, Any>

    fun updateContentList(dto : Tblmi_cont_lstDto) : Map<String, Any>

    fun checkContNm(dto:Tblmi_cont_mstDto):Int

    fun selectSenderList(dto: Tblmi_set_lstDto) : Map<String, Any>

    fun selectImgForPopup(tblmiContImgdto: Tblmi_cont_imgDto) : Map<String,Any>

    fun getImgNmCh(dto:Tblmi_cont_imgDto): Int

}