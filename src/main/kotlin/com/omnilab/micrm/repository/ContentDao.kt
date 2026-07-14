package com.omnilab.micrm.repository

import com.omnilab.micrm.model.Content_view_Dto
import com.omnilab.micrm.model.Contents_lstDto
import com.omnilab.micrm.model.table.*

interface ContentDao {

    fun insertContentMaster(tblmiContMstdto: Tblmi_cont_mstDto):Int

    fun insertContent(tblmiContLstdto: Tblmi_cont_lstDto):Int

    fun insertContentUrl(urlDto: Tblmi_cont_url_lstDto):Int

    fun isCheckMoblieContentNm(tblmiContMstdto: Tblmi_cont_mstDto) : Int

    // 공통 셋팅 리스트에서 발신자 정보를 가져온다
    fun selectSenderList(tblmiSetLstDto: Tblmi_set_lstDto) : List<Tblmi_set_lstDto>

    fun selectSenderListCnt(tblmiSetLstDto: Tblmi_set_lstDto) : Int

    fun contentUpload(dto: Tblmi_cont_imgDto) : Int

    fun selectMobileContent(tblmiContMstdto: Tblmi_cont_mstDto) : List<Contents_lstDto>


    fun selectMobileContentCnt (tblmiContMstdto: Tblmi_cont_mstDto) : Int

    fun deleteMobileContent(tblmiContMstdto: Tblmi_cont_mstDto) : Int

    fun updateMobileUseYn(tblmiContMstdto: Tblmi_cont_mstDto) : Int

    fun getImgListCnt(dto: Tblmi_cont_imgDto) : Int

    fun getImgList(dto: Tblmi_cont_imgDto) : List<Tblmi_cont_imgDto>

    fun updateImgList(dto: Tblmi_cont_imgDto) : Int

    fun getEmdList(dto: Tblmi_cont_mstDto) : List<Content_view_Dto>

    fun getEmdOne(dto: Tblmi_cont_mstDto) : Content_view_Dto

    fun getEmdListCnt(dto: Tblmi_cont_mstDto) : Int

    fun updateEdmMstList(dto : Tblmi_cont_mstDto) : Int

    fun updateEdmList(dto : Tblmi_cont_lstDto) : Int

    fun selectMobileContentUseTitle(tblmiContMstdto: Tblmi_cont_mstDto) : List<Content_view_Dto>

    fun updateImgYn(dto: Tblmi_cont_imgDto) : Int

    // 후에 최적화가 필요할듯
    fun selectImgValue(dto : Tblmi_cont_lstDto) : Tblmi_cont_imgDto?

    fun detailMobileContent(dto : Tblmi_cont_mstDto) : List<Content_view_Dto>

    fun checkContNm(dto: Tblmi_cont_mstDto) : Int

    fun updateMobileMst(dto : Tblmi_cont_mstDto) : Int

    fun updateMobileContent(dto : Tblmi_cont_lstDto) : Int

    fun deleteRealContMst(dto : Tblmi_cont_mstDto) : Int

    fun deleteRealContLst(dto : Tblmi_cont_lstDto) : Int

    fun deleteRealContUrl(dto : Tblmi_cont_url_lstDto) : Int

    fun selectLstSeq(dto : Tblmi_cont_lstDto) : List<Tblmi_cont_lstDto>

    fun getImgNmCh(dto: Tblmi_cont_imgDto) : Int

    fun selTblmicpContUrlLst(dto: Tblmicp_cont_url_lstDto): List<Tblmicp_cont_url_lstDto>

    fun delTblmiContUrlLst(dto: Tblmi_cont_url_lstDto): Int

    fun selTblmiContImg(dto: Tblmi_cont_imgDto): Tblmi_cont_imgDto?

}