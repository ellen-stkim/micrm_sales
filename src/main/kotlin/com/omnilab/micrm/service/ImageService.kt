package com.omnilab.micrm.service

import com.omnilab.micrm.model.table.Tblmi_cont_imgDto

interface ImageService {

    fun contentUpload(dto : Tblmi_cont_imgDto) : Map<String,Any>

    fun getImgList(dto: Tblmi_cont_imgDto) : Map<String, Any>

    fun deleteImgList(list: MutableList<Int>): Map<String,Any>

    fun selectImgForPopup(tblmiContImgdto: Tblmi_cont_imgDto) : Map<String,Any>

    fun updateImgYn(dto: Tblmi_cont_imgDto) : Int

    fun getImgNmCh(dto:Tblmi_cont_imgDto): Int
}