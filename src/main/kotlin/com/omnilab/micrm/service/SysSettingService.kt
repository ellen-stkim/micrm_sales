package com.omnilab.micrm.service

import com.omnilab.micrm.model.SalesforceDto
import com.omnilab.micrm.model.SetLst_searchDto
import com.omnilab.micrm.model.table.*
import org.springframework.web.multipart.MultipartFile

interface SysSettingService {

    //공지사항 파일 업로드 정보 저장
    fun insertNoticeFile(map :MutableMap<String, Any>): MutableMap<String, Any>

    fun getMailSettingList(dto: Tblmi_set_lstDto):MutableMap<String, Any>

    fun getCommCD(dto: Tblmi_comm_cdDto) : Tblmi_comm_cdDto?

    fun getCommCDLst(dto: Tblmi_comm_cdDto) : List<Tblmi_comm_cdDto>

    fun getDBValue() : MutableList<SalesforceDto>

    // 발신자 리스트 Y,N 값 변경하기
    fun updateSetLstYn(dto : Tblmi_set_lstDto) : Map<String,Any>

    // 메일 주소 저장하기
    fun insertMailLst(dto : Tblmi_set_lstDto) : Map<String,Any>

    // 메일 주소 중복 검사하기
    fun isExistMailAddress(dto : Tblmi_set_lstDto) : Map<String,Any>

    // 메일 주소 수정 중복 검사하기
    fun isExistMailAddressModify(dto : Tblmi_set_lstDto) : Map<String,Any>

    // 메일 주소 삭제
    fun deleteSetLst(dto: Tblmi_set_lstDto) : Map<String,Any>

    // 기본 값 변경하기
    fun changeDefaultLst(dto: Tblmi_set_lstDto) : Map<String,Any>

    // 문자 정보 리스트 가져오기
    fun getSmsSettingList(dto: Tblmi_set_lstDto) : Map<String,Any>

    // 문자 저장하기
    fun insertSmsLst(dto: Tblmi_set_lstDto) : Map<String,Any>

    // 문자 중복 검사하기
    fun isExistSmsAddress(dto : Tblmi_set_lstDto) : Map<String,Any>

    // 문자 중복 수정 검사하기
    fun isExistSmsAddressModify(dto : Tblmi_set_lstDto) : Map<String,Any>

    // Lst 디테일 값 가져오기
    fun detailLst(dto : Tblmi_set_lstDto) : Map<String,Any>

    // Lst 테이블 변경하기
    fun updateLst(dto : Tblmi_set_lstDto) : Map<String,Any>

    // 매핑정보 리스트 가져오기
    fun getMappingSettingList(dto: Tblmi_set_lstDto) : Map<String,Any>

    // 매핑정보 저장하기
    fun insertMappingLst(dto: Tblmi_set_lstDto) : Map<String,Any>

    // 매핑정보 중복 검사하기
    fun isExistMapping(dto : Tblmi_set_lstDto) : Map<String,Any>

    // 매핑정보 중복 수정 검사하기
    fun isExistMappingModify(dto : Tblmi_set_lstDto) : Map<String,Any>

    fun getKkoSettingList(dto: SetLst_searchDto): Map<String,Any>

    fun getRejectSettingList(dto: SetLst_searchDto): Map<String,Any>

    fun getRejtSettingList(lstStDto: SetLst_searchDto): Map<String,Any>

    fun insertRejectText(lstDto: Tblmi_set_lstDto): Int

    fun insertKkoSenderKey(map: Tblmi_set_lstDto, token: String, cateCd: String): Map<String, Any>

    fun isExistKkoAddress(lstDto: Tblmi_set_lstDto): Map<String, Any>
    fun updateSetTypeYn(lstDto: Tblmi_set_lstDto): Map<String, Any>

}