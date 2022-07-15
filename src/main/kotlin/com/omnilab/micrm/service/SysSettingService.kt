package com.omnilab.micrm.service

import com.omnilab.micrm.model.table.*
import org.springframework.web.multipart.MultipartFile

interface SysSettingService {

    //공지사항 리스트 가져오기
    fun getNoticeList(ndto: Tblmi_notiDto): MutableMap<String, Any>
   
    //공지사항 저장하기
    fun saveNotice(dto: Tblmi_notiDto): MutableMap<String, Any>

    //공지사항 상세내용 가져오기
    fun getNoticeDetail(dto: Tblmi_notiDto): MutableMap<String, Any>

    //공지사항 삭제
    fun deleteNotice(dto:Tblmi_notiDto): MutableMap<String, Any>

    //공지사항 팝업여부 수정
    fun saveNoticePopyn(dto: Tblmi_notiDto): MutableMap<String, Any>

    //공지사항 팝업리스트 가져오기
    fun getNoticePop(dto: Tblmi_notiDto): MutableMap<String, Any>

    //공지사항 파일 업로드 정보 저장
    fun insertNoticeFile(map :MutableMap<String, Any>): MutableMap<String, Any>
    
    //공지사항 파일 업로드 정보 업데이트
    fun updateNotiFile( dto: Tblmi_notiDto, ckFilename :String): MutableMap<String, Any>

    fun getMailSettingList(dto: Tblmi_set_lstDto):MutableMap<String, Any>

    fun getCommCD(dto: Tblmi_comm_cdDto) : Tblmi_comm_cdDto?

    fun getCommCDLst(dto: Tblmi_comm_cdDto) : List<Tblmi_comm_cdDto>

    fun getDBValue() : Map<String,Any>

    // 알람 리스트 불러오기
    fun selectAlarmList(notiDto : Tblmi_notiDto , workDto : Tblmi_workDto) : Map<String,Any>
    
    // 알람 상태 업데이트 하기
    fun updateAlarmStatus(workDto : Tblmi_workDto) : Map<String,Any>

    // 알람 개수 체크하기
    fun checkAlarmCnt() : Int

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

    /**
     *  테스트 그룹
     */
    fun selectTestGrpLst(dto : Tblmite_target_grp) : Map<String, Any>

    fun updateTestGrpYn(dto : Tblmite_target_grp) : Map<String,Any>

    fun deleteTestGrp(dto : Tblmite_target_grp) : Map<String,Any>

    fun detailTestGrp(dto : Tblmite_target_grp) : Map<String,Any>

    fun selectTestTargetLst(dto : Tblmite_target_lst) : Map<String,Any>

    // 테스트 타겟 리스트 엑셀 데이터 Import 하기
    fun importTestGroup(file : MultipartFile) : Map<String,Any>

    // 테스트 타겟 리스트 저장하기
    fun insertTestGroup(dto: Tblmite_target_grp) : Map<String,Any>

    // 테스트 타겟 리스트 삭제 처리 (del_yn : Y )
    fun deleteTestTarget(dto : Tblmite_target_lst) : Map<String,Any>

    // 테스트 타겟 리스트 사용 여부 변경
    fun updateTestTargetYn(dto : Tblmite_target_lst) : Map<String,Any>

    // 테스트 타겟 한 개 추가 하기
    fun insertTargetLstOne(dto : Tblmite_target_lst) : Map<String,Any>

    // 테스트 타겟 한 개 가져 오기
    fun detailTestTarget(dto : Tblmite_target_lst) : Map<String,Any>

    // 테스트 그룹 상태 변경 하기
    fun updateTestTargetLstOne(dto : Tblmite_target_lst) : Map<String,Any>

    // 테스트 타겟 그룹 이메일 모바일 cnt 구하기
    fun selectTestTargetMobEdmCnt(dto : Tblmite_target_lst) : Map<String,Any>
}