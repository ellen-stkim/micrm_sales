package com.omnilab.micrm.service.impl

import com.monitorjbl.xlsx.StreamingReader
import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.GroupUsr_SearchDto
import com.omnilab.micrm.model.Group_SearchDto
import com.omnilab.micrm.model.Sup_searchDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.model.Tblmi_tbl_searchDto
import com.omnilab.micrm.model.table.Tblmi_group_listDto
import com.omnilab.micrm.model.table.Tblmi_group_usrDto
import com.omnilab.micrm.model.table.Tblmi_supDto
import com.omnilab.micrm.model.table.Tblmi_usrDto
import com.omnilab.micrm.repository.MemberDao
import com.omnilab.micrm.repository.MicrmUserDao
import com.omnilab.micrm.service.CommonService
import com.omnilab.micrm.service.MemberService
import com.omnilab.micrm.service.WorkService
import com.omnilab.micrm.task.ThreadPool
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo
import org.apache.poi.ss.usermodel.Workbook
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor
import org.springframework.stereotype.Service
import org.springframework.web.multipart.MultipartFile
import java.util.*
import java.util.regex.Pattern
import javax.servlet.http.HttpServletRequest
import kotlin.collections.HashMap

@Service("MemberServiceImpl")
class MemberServiceImpl : MemberService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired(required = true)
    private lateinit var request: HttpServletRequest

    @Autowired
    @Qualifier("ThreadPoolImpl")
    private lateinit var pool: ThreadPool

    @Autowired
    @Qualifier("taskExecutor")
    private lateinit var taskExecutor: ThreadPoolTaskExecutor

    @Autowired
    @Qualifier("MemberDaoImpl")
    private lateinit var memberDao: MemberDao

    @Autowired
    @Qualifier("MicrmUserDaoImpl")
    private lateinit var micrmUserDao: MicrmUserDao

    @Autowired
    @Qualifier("WorkServiceImpl")
    private lateinit var workService: WorkService

    @Autowired
    private lateinit var commonService: CommonService

    override fun insertGroup(groupListDto: Tblmi_group_listDto): String {

        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()

        //초기 로그 insert
        val workDto = workService.makeGrpUserWork()
        workService.insertWorkHistory(workDto);

        groupListDto.status = '0' // 초기 상태값 ( 0: 저장중 , 1: 저장 완료 )
        groupListDto.usr_grp_cd = userInfo.usr_grp_cd
        groupListDto.reg_id = userInfo.usr_id
        groupListDto.work_seq = workDto.seq

        memberDao.insertGroup(groupListDto) // 그룹 리스트 Insert 처리

        // fileMime 체크
        val fileMime = CommonUtils.checkEecelMime(groupListDto.excelFileData);
        if (fileMime.isNullOrEmpty()) { // 저장시 파일 상태 체크는 쓰레드에서 빼서 관리

            logger.error("파일 형식이 맞지 않습니다.")

            val workDto_in = Tblmi_workDto()
            workDto_in.seq = groupListDto.work_seq
            workDto_in.upd_id = groupListDto.reg_id
            workDto_in.work_stat = "2"
            workDto_in.work_msg = "'xlsx', 'xls' 파일 형식만 업로드 가능 합니다."
            workService.updateWorkHistory(workDto_in)

            // 그룹 상태 업데이트
            val groupDto = Tblmi_group_listDto()
            groupDto.seq = groupListDto.seq
            groupDto.upd_id = groupListDto.reg_id
            groupDto.status = '2'
            memberDao.updateGroupList(groupDto)

            return "파일 형식이 맞지 않습니다"
        } else {
            // 파일 형식이 올바르면 Thread 처리
            pool.insertGroupTask(groupListDto)
        }

        logger.info("Group generate Key Sequence : " + groupListDto.seq)
        logger.info("Work generate Key Sequence : " + workDto.seq)

        return "타겟 유저가 생성되었습니다";
    }

    override fun insertGroupUser(groupListDto: Tblmi_group_listDto): String {

        var workbook: Workbook? = null
        var grpUserList: MutableList<Tblmi_group_usrDto> = ArrayList<Tblmi_group_usrDto>()

        var idx = 0;
        var cnt = 0;
        var errorCnt = 0;
        var errorMessage = "";

        try {
            // StreamingReader 사용 으로 OOM 방지
            workbook = StreamingReader.builder()
                    .rowCacheSize(100)
                    .bufferSize(4096)
                    .open(groupListDto.excelFileData?.inputStream)

            val sheet = workbook.getSheetAt(0)

            for (row in sheet!!) {
                if (idx > 0) {  // 초기 column 타이틀 Insert를 제외
                    if (row != null) {

                        val dto = Tblmi_group_usrDto()
                        dto.grp_no = groupListDto.seq // 그룹 번호
                        dto.reg_id = groupListDto.reg_id // 등록 아이디
                        dto.use_yn = "Y"    //사용 여부

                        dto.usr_id = CommonUtils.Excel_cell_value(row.getCell(0))?.trim()
                        if (dto.usr_id == null || !Pattern.matches("^[a-zA-Z0-9가-힣\\s]*$", dto.usr_id)) {
                            /**
                             * 1. 회원 번호 null은 허용하지 않는다
                             * 2. 회원 번호에 숫자, 공백, 알파벳, 한글 (자음, 모음만은 X ) 만 허용한다 (특수 문자 허용 X)
                             */
                            errorCnt++;
                            errorMessage = (idx + 1).toString() + " 행의 1번째 열 회원번호를 확인해 주세요"
                            break;
                        }

                        dto.usr_nm = CommonUtils.Excel_cell_value(row.getCell(1))?.trim()
                       /* if (dto.usr_nm == null || !Pattern.matches("^[a-zA-Z0-9가-힣\\s!@()/_,*]*$", dto.usr_nm)) {
                            *//**
                             * 1. 회원 명은 알파벳 ,숫자 ,공백,숫자, 한글 (자음, 모음만은 X ) 만 허용 한다
                             * 2. 회원명에 null은 허옹햐지 않는다.
                             *//*
                            errorCnt++;
                            errorMessage = (idx + 1).toString() + " 행의 2번째 열 회원명을 확인해 주세요"
                            break;
                        }*/
                        if (dto.usr_nm == null) {
                            /**
                             * 1. 회원 명은 알파벳 ,숫자 ,공백,숫자, 한글 (자음, 모음만은 X ) 만 허용 한다
                             * 2. 회원명에 null은 허옹햐지 않는다.
                             */
                            errorCnt++;
                            errorMessage = (idx + 1).toString() + " 행의 2번째 열 회원명을 확인해 주세요"
                            break;
                        }

                        dto.usr_mob = CommonUtils.Excel_cell_value(row.getCell(2))?.trim()?.replace("-", "")
                        if (!CommonUtils.isEmptyObject(dto.usr_mob) && !UsefulUtils.isCheckPhoneNumber(dto.usr_mob!!)) {
                            // 핸드폰 번호에 null 값이 들어갈 수 있다.
                            errorCnt++;
                            errorMessage = (idx + 1).toString() + " 행의 핸드폰 번호를 확인해주세요"
                            break;
                        }

                        dto.usr_edm = CommonUtils.Excel_cell_value(row.getCell(3))?.trim()
                        if (!CommonUtils.isEmptyObject(dto.usr_edm) && !UsefulUtils.isCheckEmail(dto.usr_edm!!)) {
                            // 이메일에 null 값이 들어갈 수 있다.
                            errorCnt++;
                            errorMessage = (idx + 1).toString() + " 행의 이메일을 확인해 주세요"
                            break;
                        }

                        if (CommonUtils.isEmptyObject(dto.usr_edm) && CommonUtils.isEmptyObject(dto.usr_mob)) {
                            // 둘다 null은 허용하지 않는다
                            errorCnt++;
                            errorMessage = (idx + 1).toString() + "행에 이메일과 핸드폰번호중 하나를 입력해주세요"
                            break;
                        }


                        dto.usr_gdr = CommonUtils.Excel_cell_value(row.getCell(4))?.trim()
                        if (!CommonUtils.isEmptyObject(dto.usr_gdr) && !dto.usr_gdr.equals("M") && !dto.usr_gdr.equals("F")) {
                            // M , F 이외의 값이 들어온다면 오류
                            errorCnt++;
                            errorMessage = (idx + 1).toString() + " 행의 성별을 확인해주세요"
                            break;
                        }

                        dto.usr_addr = CommonUtils.Excel_cell_value(row.getCell(5))?.trim()
                        dto.usr_etc1 = CommonUtils.Excel_cell_value(row.getCell(6))?.trim()
                        dto.usr_etc2 = CommonUtils.Excel_cell_value(row.getCell(7))?.trim()
                        dto.usr_etc3 = CommonUtils.Excel_cell_value(row.getCell(8))?.trim()
                        dto.usr_etc4 = CommonUtils.Excel_cell_value(row.getCell(9))?.trim()
                        dto.usr_etc5 = CommonUtils.Excel_cell_value(row.getCell(10))?.trim()
                        dto.usr_etc6 = CommonUtils.Excel_cell_value(row.getCell(11))?.trim()
                        dto.usr_etc7 = CommonUtils.Excel_cell_value(row.getCell(12))?.trim()
                        dto.usr_etc8 = CommonUtils.Excel_cell_value(row.getCell(13))?.trim()
                        dto.usr_etc9 = CommonUtils.Excel_cell_value(row.getCell(14))?.trim()
                        dto.usr_etc10 = CommonUtils.Excel_cell_value(row.getCell(15))?.trim()

                        grpUserList.add(dto)
                        cnt++

                        if (cnt == 1000) {
                            // 1000개씩 끊어서 보내기
                            memberDao.insertGroupUser(grpUserList)
                            grpUserList = ArrayList<Tblmi_group_usrDto>()
                            cnt = 0
                        }

                    } else {
                        logger.error("Excel data does not exist");

                        // 오류 상태 저장
                        val failWorkDto = Tblmi_workDto()
                        failWorkDto.seq = groupListDto.work_seq
                        failWorkDto.upd_id = groupListDto.reg_id
                        failWorkDto.work_stat = "2"
                        failWorkDto.work_msg = " 파일명 : " + groupListDto.excelFileData?.originalFilename +
                                "<br>" + " 그룹 명 : " + groupListDto.grp_nm + "<br>" + "오류 결과 : 엑셀데이터가 존재하지 않습니다"
                        workService.updateWorkHistory(failWorkDto)

                        // 그룹 상태 업데이트
                        val groupDto = Tblmi_group_listDto()
                        groupDto.seq = groupListDto.seq
                        groupDto.upd_id = groupListDto.reg_id
                        groupDto.status = '2'
                        memberDao.updateGroupList(groupDto)

                        // 오류 이메일 전송
                        val usrDto = Tblmi_usrDto()
                        usrDto.usr_id = groupListDto.reg_id

                        val emailUser = micrmUserDao.sel_tblmi_usr(usrDto)

                        val sendTo = emailUser.usr_email.toString()
                        val sendToNm = emailUser.usr_nm.toString()
                        val sendFrom = UsefulUtils.adminEmail();
                        val subject = "업로드 생성 결과"
                        val body = failWorkDto.work_msg!!
                        commonService.sendMail(sendTo, sendToNm, sendFrom, subject, body);
                    }
                }
                idx++
            }

            if (errorCnt > 0) {
                // 엑셀 데이터에 에러가 존재 한다면 에러 메세지를 리턴한다.

                val groupUserDto = Tblmi_group_usrDto()
                groupUserDto.grp_no = groupListDto.seq
                memberDao.deleteGrpUser(groupUserDto); // 엑셀 Input Error 발생시 저장된 데이터 delete

                // 오류 상태 저장
                val failWorkDto = Tblmi_workDto()
                failWorkDto.seq = groupListDto.work_seq
                failWorkDto.upd_id = groupListDto.reg_id
                failWorkDto.work_stat = "2"
                failWorkDto.work_msg = " 파일명 : " + groupListDto.excelFileData?.originalFilename +
                        "<br>" + " 그룹 명 : " + groupListDto.grp_nm + "<br>" + "오류 결과 : " + errorMessage
                workService.updateWorkHistory(failWorkDto)

                // 그룹 상태 업데이트
                val groupDto = Tblmi_group_listDto()
                groupDto.seq = groupListDto.seq
                groupDto.upd_id = groupListDto.reg_id
                groupDto.status = '2'
                memberDao.updateGroupList(groupDto)

                // 오류 이메일 전송
                val usrDto = Tblmi_usrDto()
                usrDto.usr_id = groupListDto.reg_id

                val emailUser = micrmUserDao.sel_tblmi_usr(usrDto)

                val sendTo = emailUser.usr_email.toString()
                val sendToNm = emailUser.usr_nm.toString()
                val sendFrom = UsefulUtils.adminEmail();
                val subject = "[MICRM] 업로드 생성 결과"
                val body = failWorkDto.work_msg!!

                commonService.sendMail(sendTo, sendToNm, sendFrom, subject, body);

                return errorMessage
            }

            memberDao.insertGroupUser(grpUserList)

        } catch (e: Exception) {

            // 앞의 validation에서 잡지못한 에러를 delete 처리한다.
            logger.error("Error", e)
            val groupUserDto = Tblmi_group_usrDto()
            groupUserDto.grp_no = groupListDto.seq
            memberDao.deleteGrpUser(groupUserDto); // catch 오류 발생시 기존 데이터 delete 후 Error 리턴

            // 오류 상태 저장
            val failWorkDto = Tblmi_workDto()
            failWorkDto.seq = groupListDto.work_seq
            failWorkDto.upd_id = groupListDto.reg_id
            failWorkDto.work_stat = "2"
            failWorkDto.work_msg = " 파일명 : " + groupListDto.excelFileData?.originalFilename + "<br>" + " 그룹 명 : " + groupListDto.grp_nm + "<br>" + "오류 결과 : " + "서버 에러 " + errorMessage
            workService.updateWorkHistory(failWorkDto)

            // 그룹 상태 업데이트
            val groupDto = Tblmi_group_listDto()
            groupDto.seq = groupListDto.seq
            groupDto.upd_id = groupListDto.reg_id
            groupDto.status = '2'
            memberDao.updateGroupList(groupDto)

            // 오류 이메일 전송
            val usrDto = Tblmi_usrDto()
            usrDto.usr_id = groupListDto.reg_id

            val emailUser = micrmUserDao.sel_tblmi_usr(usrDto)

            val sendTo = emailUser.usr_email.toString()
            val sendToNm = emailUser.usr_nm.toString()
            val sendFrom = UsefulUtils.adminEmail();
            val subject = "[MICRM] 업로드 생성 결과"
            val body = failWorkDto.work_msg!!

            commonService.sendMail(sendTo, sendToNm, sendFrom, subject, body);

            return "저장중 서버에러가 발생하였습니다."

        } finally {
            workbook?.close()
        }


        // 성공 상태 저장
        val successWorkDto = Tblmi_workDto()
        successWorkDto.seq = groupListDto.work_seq
        successWorkDto.upd_id = groupListDto.reg_id
        successWorkDto.work_stat = "1"
        successWorkDto.work_msg = " 파일명 : " + groupListDto.excelFileData?.originalFilename + "<br>" + " 그룹 명 : " + groupListDto.grp_nm + "<br>" + "생성 결과 : " + (idx - 1).toString() + " 명의 타겟이 입력되었습니다"
        workService.updateWorkHistory(successWorkDto)

        // 그룹 상태 업데이트
        val groupDto = Tblmi_group_listDto()
        groupDto.seq = groupListDto.seq
        groupDto.upd_id = groupListDto.reg_id
        groupDto.status = '1'
        groupDto.grp_cnt = idx - 1
        memberDao.updateGroupList(groupDto)

        // 이메일 Send
        val usrDto = Tblmi_usrDto()
        usrDto.usr_id = groupListDto.reg_id

        val emailUser = micrmUserDao.sel_tblmi_usr(usrDto)

        val sendTo = emailUser.usr_email.toString()
        val sendToNm = emailUser.usr_nm.toString()
        val sendFrom = UsefulUtils.adminEmail();
        val subject = "[MICRM] 업로드 생성 결과"
        val body = successWorkDto.work_msg!!

        commonService.sendMail(sendTo, sendToNm, sendFrom, subject, body);

        return "업로드 그룹 파일이 성공적으로 저장되었습니다."
    }


    override fun updateGroupState(groupListDto: Tblmi_group_listDto): MutableMap<String, String> {

        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()
        val statusMap: MutableMap<String, String> = HashMap();

        // use_yn 상태 변경
        if (groupListDto.use_yn.equals("Y")) {
            groupListDto.use_yn = "N"
        } else if (groupListDto.use_yn.equals("N")) {
            groupListDto.use_yn = "Y"
        }

        groupListDto.usr_grp_cd = userInfo.usr_grp_cd
        groupListDto.upd_id = userInfo.usr_id.toString()

        memberDao.updateGroupState(groupListDto)

        statusMap["status"] = "success"
        return statusMap
    }

    override fun selectGroupList(dto: Tblmi_group_listDto): MutableMap<String, Any> {

        val groupListDto = dto as Group_SearchDto

        if (groupListDto.pageNo == null) {
            groupListDto.pageNo = 1
        }

        // SearchType 에 따른 값 설정
        if (groupListDto.searchType == "grp_nm") {
            groupListDto.grp_nm = groupListDto.searchValue
        } else if (groupListDto.searchType == "use_yn") {
            groupListDto.use_yn = groupListDto.searchValue
        }

        groupListDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd

        val paramMap: MutableMap<String, Any> = HashMap()
        val paginationInfo: PaginationInfo = UsefulUtils.makePage(groupListDto.pageNo, 10, 10)

        groupListDto.firstIndex = paginationInfo.firstRecordIndex
        groupListDto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = memberDao.selectGroupListCnt(groupListDto)

        paramMap["page"] = paginationInfo
        paramMap["pageNo"] = paginationInfo.currentPageNo
        paramMap["list"] = memberDao.selectGroupList(groupListDto)
        paramMap["listCnt"] = paginationInfo.totalRecordCount

        return paramMap
    }

    override fun selectOneGroup(groupListDto: Tblmi_group_listDto): Tblmi_group_listDto {
        groupListDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        return memberDao.selectOneGroup(groupListDto);
    }

    override fun selectGroupUserList(dto: Tblmi_group_usrDto): MutableMap<String, Any> {

        val groupUserDto = dto as GroupUsr_SearchDto

        val paramMap: MutableMap<String, Any> = HashMap()
        val paginationInfo: PaginationInfo = UsefulUtils.makePage(groupUserDto.pageNo, 10, 10)

        if (!groupUserDto.searchValue.isNullOrEmpty() && !groupUserDto.searchType.isNullOrEmpty()) {
            paramMap["searchType"] = groupUserDto.searchType!!
            paramMap["searchValue"] = groupUserDto.searchValue!!
        } else {
            paramMap["searchType"] = 0
            paramMap["searchValue"] = 0
        }

        if (groupUserDto.searchType == "usr_id") {
            groupUserDto.usr_id = groupUserDto.searchValue
        } else if (groupUserDto.searchType == "usr_nm") {
            groupUserDto.usr_nm = groupUserDto.searchValue
        } else if (groupUserDto.searchType == "usr_mob") {
            groupUserDto.usr_mob = groupUserDto.searchValue
        } else if (groupUserDto.searchType == "usr_edm") {
            groupUserDto.usr_edm = groupUserDto.searchValue
        } else if (groupUserDto.searchType == "usr_gdr") {
            groupUserDto.usr_gdr = groupUserDto.searchValue
        } else if (groupUserDto.searchType == "usr_addr") {
            groupUserDto.usr_addr = groupUserDto.searchValue
        } else if (groupUserDto.searchType == "usr_etc1") {
            groupUserDto.usr_etc1 = groupUserDto.searchValue
        } else if (groupUserDto.searchType == "usr_etc2") {
            groupUserDto.usr_etc2 = groupUserDto.searchValue
        } else if (groupUserDto.searchType == "usr_etc3") {
            groupUserDto.usr_etc3 = groupUserDto.searchValue
        } else if (groupUserDto.searchType == "usr_etc4") {
            groupUserDto.usr_etc4 = groupUserDto.searchValue
        } else if (groupUserDto.searchType == "usr_etc5") {
            groupUserDto.usr_etc5 = groupUserDto.searchValue
        } else if (groupUserDto.searchType == "usr_etc6") {
            groupUserDto.usr_etc6 = groupUserDto.searchValue
        } else if (groupUserDto.searchType == "usr_etc7") {
            groupUserDto.usr_etc7 = groupUserDto.searchValue
        } else if (groupUserDto.searchType == "usr_etc8") {
            groupUserDto.usr_etc8 = groupUserDto.searchValue
        } else if (groupUserDto.searchType == "usr_etc9") {
            groupUserDto.usr_etc9 = groupUserDto.searchValue
        } else if (groupUserDto.searchType == "usr_etc10") {
            groupUserDto.usr_etc10 = groupUserDto.searchValue
        }

        groupUserDto.firstIndex = paginationInfo.firstRecordIndex
        groupUserDto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = memberDao.selectGroupUserListCnt(groupUserDto)

        paramMap["page"] = paginationInfo
        paramMap["pageNo"] = paginationInfo.currentPageNo
        paramMap["list"] = memberDao.selectGroupUserList(groupUserDto)
        paramMap["listCnt"] = paginationInfo.totalRecordCount

        return paramMap;
    }

    override fun selectGroupListCnt(groupListDto: Tblmi_group_listDto): Int {
        groupListDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        return memberDao.selectGroupListCnt(groupListDto)
    }

    override fun selectGroupUserListCnt(groupUserDto: Tblmi_group_usrDto): Int {
        return memberDao.selectGroupUserListCnt(groupUserDto)
    }

    // 그룹 리스트 체크 삭제
    override fun deleteGrpList(grpNoList: MutableList<String>): MutableMap<String, String> {

        val statusMap: MutableMap<String, String> = HashMap();
        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()

        val groupList = mutableListOf<Tblmi_group_listDto>()
        val grpUserList = mutableListOf<Tblmi_group_usrDto>()

        for (i in grpNoList) {
            // 그룹 삭제를 위한 DTO 담기

            val groupDto = Tblmi_group_listDto()
            val grpUserDto = Tblmi_group_usrDto()

            groupDto.seq = i.toInt()
            groupDto.upd_id = userInfo.usr_id
            groupDto.usr_grp_cd = userInfo.usr_grp_cd
            groupList.add(groupDto)

            grpUserDto.grp_no = groupDto.seq
            grpUserDto.upd_id = userInfo.usr_id
            grpUserList.add(grpUserDto);
        }

        memberDao.deleteGrpList(groupList); // 그룹 리스트 삭제
        memberDao.deleteGrpUserList(grpUserList);   // 그룹 리스트 하위 업로드 유저 삭제

        statusMap["status"] = "success"
        return statusMap
    }

    // 그룹 리스트 전체 삭제
    override fun deleteGrpAllList(dto: Tblmi_group_listDto): MutableMap<String, String> {

        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()
        val statusMap: MutableMap<String, String> = HashMap();

        val groupListDto = dto as Group_SearchDto

        groupListDto.upd_id = userInfo.usr_id   // 현재 접속한 유저 아이디 로 Update
        groupListDto.usr_grp_cd = userInfo.usr_grp_cd   // 그룹 코드 추가

        val grpUserDto = Tblmi_group_usrDto()
        grpUserDto.upd_id = userInfo.usr_id

        val selectGrpList = memberDao.selectGroupList(groupListDto) // 검색 조건에 따른 게시글 가져 오기

        val grpUserList = mutableListOf<Tblmi_group_usrDto>()

        for (i in selectGrpList) {
            val grpUserDtoLst = Tblmi_group_usrDto()
            grpUserDtoLst.grp_no = i.seq; // 선택된 게시글 grpNo (그룹 번호) 설정
            grpUserDtoLst.upd_id = userInfo.usr_id
            grpUserList.add(grpUserDtoLst);
        }

        memberDao.deleteGrpAllList(groupListDto)    //  그룹 리스트 전체 삭제
        memberDao.deleteGrpUserList(grpUserList) // 해당하는 그룹 유저 리스트 전체 삭제

        statusMap["status"] = "success"
        return statusMap
    }

    override fun deleteGrpUserList(grpNoList: MutableList<String>): MutableMap<String, String> {

        val statusMap: MutableMap<String, String> = HashMap();
        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()
        val groupUserList = mutableListOf<Tblmi_group_usrDto>()

        for (i in grpNoList) {
            val groupUserDto = Tblmi_group_usrDto()
            groupUserDto.seq = i.toInt()
            groupUserDto.upd_id = userInfo.usr_id
            groupUserList.add(groupUserDto)
        }
        memberDao.deleteGrpUserList(groupUserList);

        // 삭제시 상위 그룹 카운트 변경
        val tempGrpUser = Tblmi_group_usrDto()
        tempGrpUser.seq = grpNoList[0].toInt()
        val grpUser = memberDao.selectOneGroupUser(tempGrpUser) // grp_no 가져오기

        val cntGrpUser = Tblmi_group_usrDto()
        cntGrpUser.grp_no = grpUser.grp_no //
        val targetCnt = memberDao.selectGroupUserListCnt(cntGrpUser) // 타겟 수 새로 가져오기

        val groupListDto = Tblmi_group_listDto()
        groupListDto.grp_cnt = targetCnt
        groupListDto.upd_id = userInfo.usr_id
        groupListDto.seq = grpUser.grp_no
        memberDao.updateGroupList(groupListDto)

        statusMap["status"] = "success"
        return statusMap
    }

    override fun deleteGrpUserAllList(groupUserDto: Tblmi_group_usrDto): MutableMap<String, String> {

        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()
        val statusMap: MutableMap<String, String> = HashMap();

        groupUserDto.upd_id = userInfo.usr_id   // 현재 접속한 유저 아이디 로 Update

        memberDao.deleteGrpUserAllList(groupUserDto)

        val cntGrpUser = Tblmi_group_usrDto()
        cntGrpUser.grp_no = groupUserDto.grp_no

        val targetCnt = memberDao.selectGroupUserListCnt(cntGrpUser) // 타겟 수 새로 가져오기

        val groupListDto = Tblmi_group_listDto()
        groupListDto.grp_cnt = targetCnt
        groupListDto.upd_id = userInfo.usr_id
        groupListDto.seq = groupUserDto.grp_no
        memberDao.updateGroupList(groupListDto)

        var grpList: List<Tblmi_group_listDto> = listOf(groupListDto)
        memberDao.deleteGrpList(grpList)

        statusMap["status"] = "success"
        return statusMap
    }

    override fun excelDownGrpUserList(dto: Tblmi_group_usrDto): MutableMap<String, Any> {

        val excelMap: MutableMap<String, Any> = HashMap();
        val labelList = mutableListOf<String>();

        val groupUserDto = dto as GroupUsr_SearchDto

        if (groupUserDto.searchType == "usr_id") {
            groupUserDto.usr_id = groupUserDto.searchValue
        } else if (groupUserDto.searchType == "usr_nm") {
            groupUserDto.usr_nm = groupUserDto.searchValue
        } else if (groupUserDto.searchType == "usr_mob") {
            groupUserDto.usr_mob = groupUserDto.searchValue
        } else if (groupUserDto.searchType == "usr_edm") {
            groupUserDto.usr_edm = groupUserDto.searchValue
        } else if (groupUserDto.searchType == "usr_gdr") {
            groupUserDto.usr_gdr = groupUserDto.searchValue
        } else if (groupUserDto.searchType == "usr_addr") {
            groupUserDto.usr_addr = groupUserDto.searchValue
        }

        labelList.add("회원번호")
        labelList.add("이름")
        labelList.add("모바일")
        labelList.add("이메일")
        labelList.add("성별")
        labelList.add("주소")
        labelList.add("ETC1")
        labelList.add("ETC2")
        labelList.add("ETC3")
        labelList.add("ETC4")
        labelList.add("ETC5")
        labelList.add("ETC6")
        labelList.add("ETC7")
        labelList.add("ETC8")
        labelList.add("ETC9")
        labelList.add("ETC10")

        val book: Workbook = commonService.createExcel(labelList)
        labelList.clear()

        excelMap["book"] = book
        excelMap["name"] = "UPLOAD_GRP_USER_LIST"

        // 엑셀 리스트를 뽑기위한 ResultHandler 적용
        memberDao.excelDownGrpUserList(book, groupUserDto)

        return excelMap
    }

    override fun getTblmiSupList(sdto: Tblmi_supDto): MutableMap<String, Any> {
        val dto = sdto as Sup_searchDto
        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd

        if (dto.searchType == "sup_type") {
            dto.sup_type = dto.searchValue
        } else if (dto.searchType == "usr_id") {
            dto.pro_id = dto.searchValue
        } else if (dto.searchType == "ch_type") {
            dto.ch_type = dto.searchValue
        } else if (dto.searchType == "send_to") {
            dto.send_to = dto.searchValue
        } else if (dto.searchType == "camp_id") {
            dto.searchType = dto.searchValue
        } else if (dto.searchType == "camp_nm") {
            dto.camp_nm = dto.searchValue
        }

        val pageNo = if (dto.pageNo == null) {
            1
        } else {
            dto.pageNo!!
        }

        val paramMap: MutableMap<String, Any> = HashMap()
        val paginationInfo: PaginationInfo = UsefulUtils.makePage(pageNo, 10, 10)
        dto.firstIndex = paginationInfo.firstRecordIndex
        dto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = memberDao.getTblmiSupListCnt(dto)
        if (!dto.searchValue.isNullOrEmpty() && !dto.searchType.isNullOrEmpty()) {
            paramMap["searchType"] = dto.searchType!!
            paramMap["searchValue"] = dto.searchValue!!
        } else {
            paramMap["searchType"] = 0
            paramMap["searchValue"] = 0
        }
        paramMap["cnt"] = paginationInfo.totalRecordCount
        paramMap["page"] = paginationInfo
        paramMap["pageNo"] = paginationInfo.currentPageNo
        val listDto = memberDao.getTblmiSupList(dto)
        if (!listDto.isNullOrEmpty()) {
            for (i in listDto) {
                i.send_to = CommonUtils.numberToPhone(i.send_to)
            }
        }
        paramMap["list"] = listDto

        return paramMap
    }

    override fun saveTblmiSupList(dto: Tblmi_supDto): MutableMap<String, Any> {
        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()
        dto.reg_id = userInfo.usr_id
        dto.usr_grp_cd = userInfo.usr_grp_cd
        dto.send_to = dto.send_to?.replace("-", "")?.trim()
        val paramMap: MutableMap<String, Any> = HashMap()
        paramMap["message"] = memberDao.saveTblmiSupList(dto)
        return paramMap
    }

    override fun deleteTblmiSupList(sdto: Tblmi_supDto): MutableMap<String, Any> {
        val dto = sdto as Sup_searchDto
        val paramMap: MutableMap<String, Any> = HashMap()
        dto.del_yn = "Y"
        dto.upd_id = UsefulUtils.sessionUser().usr_id
        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        paramMap["message"] = memberDao.updateTblmiSupList(dto);
        return paramMap
    }

    override fun deleteTblmiSupList(list: MutableList<Int>): MutableMap<String, Any> {
        val temp_dto: Tblmi_supDto = Tblmi_supDto()
        val user_id = UsefulUtils.sessionUser().usr_id
        var updateCnt = 0;
        for (i in list) {
            temp_dto.seq = i
            temp_dto.del_yn = "Y"
            temp_dto.upd_id = user_id
            temp_dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
            memberDao.updateTblmiSupList(temp_dto)
            updateCnt++
        }
        val paramMap: MutableMap<String, Any> = HashMap()
        paramMap["message"] = updateCnt
        return paramMap
    }

    //수신거부 리스트 유효성 검증
    override fun tblmiSupFormCheck(file: MultipartFile): MutableMap<String, Any> {
        val paramMap: MutableMap<String, Any> = HashMap()
        val fileMime = CommonUtils.checkEecelMime(file);
        if (fileMime.isNullOrEmpty()) {
            paramMap["check"] = false
            paramMap["message"] = "'xlsx', 'xls' 파일 형식만 업로드 가능 합니다."
            return paramMap
        } else {

            val dtoList = mutableListOf<Tblmi_supDto>()
            var workbook: Workbook? = null
            var idx = 0;

            var mCnt = 0;
            var mErr = 0;

            var eCnt = 0;
            var eErr = 0;
            try {
                // StreamingReader 사용 으로 OOM 방지
                workbook = StreamingReader.builder()
                        .rowCacheSize(100)
                        .bufferSize(4096)
                        .open(file.inputStream)
                val sheet = workbook.getSheetAt(0)
                for (row in sheet!!) {
                    if (idx > 0) {
                        if (row != null) {
                            val dto: Tblmi_supDto = Tblmi_supDto()
                            val ch_type = CommonUtils.Excel_cell_value(row.getCell(0))
                            val send_to = CommonUtils.Excel_cell_value(row.getCell(1))
                            if (ch_type.trim().contains("모바일")) {
                                dto.ch_type = "모바일"
                                mCnt++
                                if (!UsefulUtils.isCheckPhoneNumber(send_to)) {
                                    mErr++
                                }
                            } else if (ch_type.trim().contains("이메일")) {
                                dto.ch_type = "이메일"
                                eCnt++
                                if (!UsefulUtils.isCheckEmail(send_to)) {
                                    eErr++
                                }
                            } else {
                                paramMap["check"] = false
                                paramMap["message"] = "파일 양식이 업로드 양식과 일치하지 않습니다."
                                workbook?.close()
                                return paramMap
                            }
                            dto.send_to = send_to
                            if (idx <= 5) {
                                dtoList.add(dto)
                            }
                            if (idx >= 100) {
                                paramMap["list"] = dtoList
                                paramMap["mCnt"] = mCnt
                                paramMap["mErr"] = mErr
                                paramMap["eCnt"] = eCnt
                                paramMap["eErr"] = eErr
                                paramMap["check"] = true
                                workbook?.close()
                                return paramMap
                            }
                        } else {
                            paramMap["check"] = false
                            paramMap["message"] = "Excel data does not exist"
                            workbook?.close()
                            return paramMap
                        }
                    }
                    idx++
                }
                paramMap["list"] = dtoList
                paramMap["mCnt"] = mCnt
                paramMap["mErr"] = mErr
                paramMap["eCnt"] = eCnt
                paramMap["eErr"] = eErr
                paramMap["check"] = true
            } catch (e: Exception) {
                logger.warn("파일 검사 중 오류 : " + e.message)
                paramMap["check"] = false
                paramMap["message"] = "파일 검사 중 오류가 발생하였습니다. 관리자에게 문의하여 주세요."
                workbook?.close()
                return paramMap
            } finally {
                workbook?.close()
            }
        }
        return paramMap
    }

    override fun saveTblmiSupForm(file: MultipartFile): MutableMap<String, Any> {
        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()
        val usr_id = userInfo.usr_id
        val usr_grp_cd = userInfo.usr_grp_cd
        val fileMime = CommonUtils.checkEecelMime(file);
        var dtoList: MutableList<Tblmi_supDto> = ArrayList<Tblmi_supDto>()
        val paramMap: MutableMap<String, Any> = HashMap()
        val fileNm = file.originalFilename
        if (fileMime.isNullOrEmpty()) {
            paramMap["check"] = false
            paramMap["message"] = "'xlsx', 'xls' 파일 형식만 업로드 가능 합니다."
            return paramMap
            //work log에 실패 내용 업데이트
        } else {
            var uploadCnt = 0;
            var uploadErrCnt = 0;
            var uploaderrIdx = "오류 행 : ";
            val workDto = Tblmi_workDto()
            val ip = CommonUtils.clientip(request)

            if (ip == "0:0:0:0:0:0:0:1")
                workDto.work_usr_ip = "127.0.0.1"
            else
                workDto.work_usr_ip = ip
            workDto.work_type = "수신거부 리스트 업로드"
            workDto.work_usr_id = usr_id
            workDto.work_stat = "0"
            workDto.work_msg = ""
            workDto.work_grp_cd = usr_grp_cd
            workDto.reg_id = usr_id
            workService.insertWorkHistory(workDto)
            var idx = 0;
            var totCnt = 0;

            taskExecutor.submit {
                var workbook: Workbook? = null
                try {
                    workDto.work_stat = "1"
                    // StreamingReader 사용 으로 OOM 방지
                    workbook = StreamingReader.builder()
                            .rowCacheSize(100)
                            .bufferSize(4096)
                            .open(file.inputStream)
                    val sheet = workbook.getSheetAt(0)
                    var realIdx = 1
                    for (row in sheet!!) {
                        if (idx > 0) {
                            if (row != null) {
                                var errCtn = 0;
                                val dto = Tblmi_supDto()
                                dto.reg_id = usr_id
                                dto.usr_grp_cd = usr_grp_cd
                                dto.sup_type = "SUP01"
                                val ch_type = CommonUtils.Excel_cell_value(row.getCell(0))
                                var send_to = CommonUtils.Excel_cell_value(row.getCell(1))
                                if (ch_type.trim().contains("모바일")) {
                                    dto.ch_type = "CH02"
                                    if (!UsefulUtils.isCheckPhoneNumber(send_to)) {
                                        errCtn++
                                        uploadErrCnt++
                                        uploaderrIdx += " $realIdx 행"
                                    } else {
                                        send_to = send_to.replace("-", "")
                                    }
                                } else if (ch_type.trim().contains("이메일")) {
                                    dto.ch_type = "CH01"
                                    if (!UsefulUtils.isCheckEmail(send_to)) {
                                        errCtn++
                                        uploadErrCnt++
                                        uploaderrIdx += " $realIdx 행"
                                    }
                                } else {
                                    errCtn++
                                    uploadErrCnt++
                                    uploaderrIdx += " $realIdx 행"
                                }
                                if (errCtn > 0) {
                                    realIdx++
                                    totCnt++
                                    continue
                                }
                                totCnt++
                                uploadCnt++
                                dto.send_to = send_to.trim()
                                dtoList.add(dto)
                                if (totCnt == 1000) {
                                    memberDao.saveTblmiSupList(dtoList)
                                    dtoList = ArrayList<Tblmi_supDto>()
                                    totCnt = 0
                                }
                            }
                        }
                        realIdx++
                        idx++
                    }
                    memberDao.saveTblmiSupList(dtoList)
                    var workMsg = "파일명 : $fileNm. <br> 수신거부 회원 업로드.<br> "
                    if (uploadErrCnt > 0) {
                        workDto.work_stat = "1"
                        workMsg += "형식 불일치 : $uploadErrCnt 건. <br> $uploaderrIdx 확인."
                    }
                    workDto.work_msg = workMsg
                } catch (e: Exception) {
                    logger.error(e.toString());
                    workDto.work_msg = "파일명 : $fileNm. <br> 오류 발생.<br>"
                    workDto.work_stat = "2"
                    //work log에 실패 내용 업데이트
                } finally {
                    workDto.upd_id = usr_id
                    workService.updateWorkHistory(workDto)
                    //TO DO Email 발송.
                    // 이메일 Send
                    val usrDto = Tblmi_usrDto()
                    usrDto.usr_id = workDto.reg_id

                    val emailUser = micrmUserDao.sel_tblmi_usr(usrDto)

                    val sendTo = emailUser.usr_email.toString()
                    val sendToNm = emailUser.usr_nm.toString()
                    val sendFrom = UsefulUtils.adminEmail();
                    val subject = "[MICRM] 업로드 생성 결과"
                    val body = workDto.work_msg.toString()

                    commonService.sendMail(sendTo, sendToNm, sendFrom, subject, body);
                    workbook?.close()
                }
            }
        }
        paramMap["check"] = true
        paramMap["message"] = "수신거부 목록 업로드 작업이 시작되었습니다."
        return paramMap
    }

    //수신거부 회원 엑셀 다운로드
    override fun downloadTblmiSup(sdto: Tblmi_supDto): MutableMap<String, Any> {
        val dto = sdto as Sup_searchDto
        if (dto.searchType == "sup_type") {
            dto.sup_type = dto.searchValue
        } else if (dto.searchType == "usr_id") {
            dto.pro_id = dto.searchValue
        } else if (dto.searchType == "ch_type") {
            dto.ch_type = dto.searchValue
        } else if (dto.searchType == "send_to") {
            dto.send_to = dto.searchValue
        } else if (dto.searchType == "camp_id") {
            dto.camp_id = dto.searchValue
        } else if (dto.searchType == "camp_nm") {
            dto.camp_nm = dto.searchValue
        }
        val paramMap: MutableMap<String, Any> = HashMap()
        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd

        val labelList = mutableListOf<String>();

        labelList.add("유형")
        labelList.add("회원번호")
        labelList.add("채널")
        labelList.add("주소")
        labelList.add("캠페인")
        labelList.add("등록일")

        val book: Workbook = commonService.createExcel(labelList)
        labelList.clear()

        paramMap["book"] = book
        paramMap["name"] = "reject_member"

        // 엑셀 리스트를 뽑기위한 ResultHandler 적용
        memberDao.downloadTblmiSup(book, dto)

        return paramMap
    }

    override fun importExcel(file: MultipartFile, groupListDto: Tblmi_group_listDto): MutableMap<String, Any> {
        val statusMap = HashMap<String, Any>()
        var workbook: Workbook? = null
        val grpUserList: MutableList<Tblmi_group_usrDto> = ArrayList<Tblmi_group_usrDto>()
        var idx = 0;
        var targetCnt = 0;
        var errorCnt = 0;
        var errorMessage = ""

        val fileMime = CommonUtils.checkEecelMime(file)

        if (fileMime.isNullOrEmpty()) { // 파일 상태 체크
            statusMap["status"] = "Error"
            statusMap["message"] = "'xlsx', 'xls' 파일 형식만 업로드 가능 합니다."
            return statusMap
        } else {
            try {
                // StreamingReader 사용 으로 OOM 방지
                workbook = StreamingReader.builder()
                        .rowCacheSize(100)
                        .bufferSize(4096)
                        .open(file.inputStream)

                val sheet = workbook.getSheetAt(0)

                for (row in sheet!!) {

                    if (idx == 0) {
                        // 초기 컬럼 타이틀 유효성 검사 추가
                        val dto = Tblmi_group_usrDto()

                        dto.usr_id = CommonUtils.Excel_cell_value(row.getCell(0))?.trim()
                        dto.usr_nm = CommonUtils.Excel_cell_value(row.getCell(1))?.trim()
                        dto.usr_mob = CommonUtils.Excel_cell_value(row.getCell(2))?.trim()
                        dto.usr_edm = CommonUtils.Excel_cell_value(row.getCell(3))?.trim()
                        dto.usr_gdr = CommonUtils.Excel_cell_value(row.getCell(4))?.trim()
                        dto.usr_addr = CommonUtils.Excel_cell_value(row.getCell(5))?.trim()
                        dto.usr_etc1 = CommonUtils.Excel_cell_value(row.getCell(6))?.trim()
                        dto.usr_etc2 = CommonUtils.Excel_cell_value(row.getCell(7))?.trim()
                        dto.usr_etc3 = CommonUtils.Excel_cell_value(row.getCell(8))?.trim()
                        dto.usr_etc4 = CommonUtils.Excel_cell_value(row.getCell(9))?.trim()
                        dto.usr_etc5 = CommonUtils.Excel_cell_value(row.getCell(10))?.trim()
                        dto.usr_etc6 = CommonUtils.Excel_cell_value(row.getCell(11))?.trim()
                        dto.usr_etc7 = CommonUtils.Excel_cell_value(row.getCell(12))?.trim()
                        dto.usr_etc8 = CommonUtils.Excel_cell_value(row.getCell(13))?.trim()
                        dto.usr_etc9 = CommonUtils.Excel_cell_value(row.getCell(14))?.trim()
                        dto.usr_etc10 = CommonUtils.Excel_cell_value(row.getCell(15))?.trim()

                        if (!dto.usr_id?.trim().equals("회원번호") || !dto.usr_nm?.trim().equals("이름") || !dto.usr_mob?.trim().equals("모바일")
                                || !dto.usr_edm?.trim().equals("이메일") || !dto.usr_gdr?.trim().equals("성별") || !dto.usr_addr?.trim().equals("주소")
                                || !dto.usr_etc1?.trim().equals("ETC1") || !dto.usr_etc2?.trim().equals("ETC2")
                                || !dto.usr_etc3?.trim().equals("ETC3") || !dto.usr_etc4?.trim().equals("ETC4") || !dto.usr_etc5?.trim().equals("ETC5")
                                || !dto.usr_etc6?.trim().equals("ETC6") || !dto.usr_etc7?.trim().equals("ETC7") || !dto.usr_etc8?.trim().equals("ETC8")
                                || !dto.usr_etc9?.trim().equals("ETC9") || !dto.usr_etc10?.trim().equals("ETC10")) {
                            statusMap["status"] = "Error"
                            statusMap["message"] = "파일 양식이 업로드 양식과 일치하지 않습니다."
                            return statusMap
                        }
                    }

                    if (idx > 0) {  // 초기
                        // column 타이틀 Insert를 제외
                        if (row != null) {

                            val dto = Tblmi_group_usrDto()

                            dto.usr_id = CommonUtils.Excel_cell_value(row.getCell(0))?.trim()
                            dto.usr_nm = CommonUtils.Excel_cell_value(row.getCell(1))?.trim()

                            //dto.usr_mob = CommonUtils.Excel_cell_value(row.getCell(2))?.trim()?.replace("-","")

                            if (!CommonUtils.isEmptyObject(row.getCell(2))) {
                                dto.usr_mob = CommonUtils.Excel_cell_value(row.getCell(2)).replace("-", "").trim()
                            }

                            dto.usr_edm = CommonUtils.Excel_cell_value(row.getCell(3))?.trim()
                            dto.usr_gdr = CommonUtils.Excel_cell_value(row.getCell(4))?.trim()
                            dto.usr_addr = CommonUtils.Excel_cell_value(row.getCell(5))?.trim()
                            dto.usr_etc1 = CommonUtils.Excel_cell_value(row.getCell(6))?.trim()
                            dto.usr_etc2 = CommonUtils.Excel_cell_value(row.getCell(7))?.trim()
                            dto.usr_etc3 = CommonUtils.Excel_cell_value(row.getCell(8))?.trim()
                            dto.usr_etc4 = CommonUtils.Excel_cell_value(row.getCell(9))?.trim()
                            dto.usr_etc5 = CommonUtils.Excel_cell_value(row.getCell(10))?.trim()
                            dto.usr_etc6 = CommonUtils.Excel_cell_value(row.getCell(11))?.trim()
                            dto.usr_etc7 = CommonUtils.Excel_cell_value(row.getCell(12))?.trim()
                            dto.usr_etc8 = CommonUtils.Excel_cell_value(row.getCell(13))?.trim()
                            dto.usr_etc9 = CommonUtils.Excel_cell_value(row.getCell(14))?.trim()
                            dto.usr_etc10 = CommonUtils.Excel_cell_value(row.getCell(15))?.trim()

                            //logger.error("usr_id : " + dto.usr_id);

                            if (dto.usr_id == null || !Pattern.matches("^[a-zA-Z0-9가-힣\\s]*$", dto.usr_id)) {
                                /**
                                 * 1. 회원 번호 null은 허용하지 않는다
                                 * 2. 회원 번호에 숫자, 공백, 알파벳, 한글 만 허용한다
                                 */
                                errorCnt++;
                                errorMessage = (idx + 1).toString() + " 행의 1번째 열 회원번호를 확인해 주세요"
                                break;
                            }

                            /*if (dto.usr_nm == null || !Pattern.matches("^[a-zA-Z0-9가-힣\\s!@()/_,*]*$", dto.usr_nm)) {
                                *//**
                                 * 1. 회원 명은 알파벳 ,숫자 ,공백,숫자, 한글 (자음, 모음만은 X ) 만 허용 한다
                                 * 2. 회원명에 null은 허옹햐지 않는다.
                                 *//*
                                errorCnt++;
                                errorMessage = (idx + 1).toString() + " 행의 2번째 열 회원명을 확인해 주세요"
                                break;
                            }*/

                            if (dto.usr_nm == null) {
                                /**
                                 * 1. 회원명에 null은 허옹햐지 않는다.
                                 */
                                errorCnt++;
                                errorMessage = (idx + 1).toString() + " 행의 2번째 열 회원명을 확인해 주세요"
                                break;
                            }

                            if (!CommonUtils.isEmptyObject(dto.usr_mob) && !UsefulUtils.isCheckPhoneNumber(dto.usr_mob!!)) {
                                // 핸드폰 번호에 null 값이 들어 갈 수 있다.
                                errorCnt++;
                                errorMessage = (idx + 1).toString() + " 행의 3번째 열 핸드폰 번호를 확인해주세요"
                                break;
                            }

                            if (!CommonUtils.isEmptyObject(dto.usr_edm) && !UsefulUtils.isCheckEmail(dto.usr_edm!!)) {
                                // 이메일에 null 값이 들어 갈 수 있다.
                                errorCnt++;
                                errorMessage = (idx + 1).toString() + " 행의 4번째 열 이메일을 확인해 주세요"
                                break;
                            }

                            if (CommonUtils.isEmptyObject(dto.usr_edm) && CommonUtils.isEmptyObject(dto.usr_mob)) {
                                // 이메일과 핸드폰 번호중 하나는 입력되어야 한다
                                errorCnt++;
                                errorMessage = (idx + 1).toString() + "행에 3,4번째 열 이메일과 핸드폰번호중 하나를 입력해주세요"
                                break;
                            }

                            if (!CommonUtils.isEmptyObject(dto.usr_gdr) && !dto.usr_gdr.equals("M") && !dto.usr_gdr.equals("F")) {
                                // M , F 이외의 값이 들어온다면 오류
                                errorCnt++;
                                errorMessage = (idx + 1).toString() + " 행의 5번째 열 성별을 확인해주세요"
                                break;
                            }

                            if (idx <= 5) {
                                // 최대 5개의 Preview 리스트만 뿌려준다
                                grpUserList.add(dto)
                            }

                            if (idx == 100) {
                                // 100개 이상은 검사하지 않는다.
                                break;
                            }
                            targetCnt++;


                            if ((dto.usr_id == null || dto.usr_id == "") && (dto.usr_nm == null || dto.usr_nm == "")
                                    && (dto.usr_mob == null || dto.usr_mob == "") && (dto.usr_edm == null || dto.usr_edm == "")) {
                                // 아이디, 유저 이름, 핸드폰 번호, 이메일이 모두 존재하지 않는데 row 에서 읽어들인다면, 엑셀 파일에 빈셀이 존재한다.
                                statusMap["status"] = "Error"
                                statusMap["message"] = targetCnt.toString() + "행의 엑셀 파일에 빈셀이 있는지 확인해 주세요"
                                return statusMap
                            }

                        } else {
                            statusMap["status"] = "Error"
                            statusMap["message"] = "엑셀 파일이 존재하지 않습니다."
                            return statusMap
                        }
                    }
                    idx++
                }
                if (errorCnt > 0) {
                    // 100개 미만에서 오류 발생시 알림 처리
                    statusMap["status"] = "Error"
                    statusMap["message"] = errorMessage
                    return statusMap;
                }
            } catch (e: Exception) {
                e.printStackTrace()
                statusMap["status"] = "Error"
                statusMap["message"] = "엑셀 파일에 오류가 존재합니다."
                return statusMap
            } finally {
                workbook?.close()
            }
        }

        statusMap["list"] = grpUserList
        statusMap["cnt"] = idx - 1
        statusMap["result"] = true
        statusMap["message"] = "엑셀 Import 완료"
        statusMap["isExist"] = isExistGrpNam(groupListDto)  // 그룹명 존재 여부 확인

        return statusMap

    }

    override fun importDetailExcel(file: MultipartFile, groupListDto: Tblmi_group_listDto): Map<String, Any> {
        val statusMap = HashMap<String, Any>()
        var workbook: Workbook? = null
        val grpUserList: MutableList<Tblmi_group_usrDto> = ArrayList<Tblmi_group_usrDto>()
        var idx = 0;
        var targetCnt = 0;
        var errorCnt = 0;
        var errorMessage = ""

        var memNoCnt = 0
        var memNmCnt = 0
        var mdmCnt = 0
        var edmCnt = 0

        val fileMime = CommonUtils.checkEecelMime(file)

        if (fileMime.isNullOrEmpty()) { // 파일 상태 체크
            statusMap["status"] = "Error"
            statusMap["message"] = "'xlsx', 'xls' 파일 형식만 업로드 가능 합니다."
            return statusMap
        } else {
            try {
                // StreamingReader 사용 으로 OOM 방지
                workbook = StreamingReader.builder()
                        .rowCacheSize(100)
                        .bufferSize(4096)
                        .open(file.inputStream)

                val sheet = workbook.getSheetAt(0)

                for (row in sheet!!) {

                    if (idx == 0) {
                        // 초기 컬럼 타이틀 유효성 검사 추가
                        val dto = Tblmi_group_usrDto()

                        dto.usr_id = CommonUtils.Excel_cell_value(row.getCell(0))?.trim()
                        dto.usr_nm = CommonUtils.Excel_cell_value(row.getCell(1))?.trim()
                        dto.usr_mob = CommonUtils.Excel_cell_value(row.getCell(2))?.trim()
                        dto.usr_edm = CommonUtils.Excel_cell_value(row.getCell(3))?.trim()
                        dto.usr_gdr = CommonUtils.Excel_cell_value(row.getCell(4))?.trim()
                        dto.usr_addr = CommonUtils.Excel_cell_value(row.getCell(5))?.trim()
                        dto.usr_etc1 = CommonUtils.Excel_cell_value(row.getCell(6))?.trim()
                        dto.usr_etc2 = CommonUtils.Excel_cell_value(row.getCell(7))?.trim()
                        dto.usr_etc3 = CommonUtils.Excel_cell_value(row.getCell(8))?.trim()
                        dto.usr_etc4 = CommonUtils.Excel_cell_value(row.getCell(9))?.trim()
                        dto.usr_etc5 = CommonUtils.Excel_cell_value(row.getCell(10))?.trim()
                        dto.usr_etc6 = CommonUtils.Excel_cell_value(row.getCell(11))?.trim()
                        dto.usr_etc7 = CommonUtils.Excel_cell_value(row.getCell(12))?.trim()
                        dto.usr_etc8 = CommonUtils.Excel_cell_value(row.getCell(13))?.trim()
                        dto.usr_etc9 = CommonUtils.Excel_cell_value(row.getCell(14))?.trim()
                        dto.usr_etc10 = CommonUtils.Excel_cell_value(row.getCell(15))?.trim()

                        if (!dto.usr_id?.trim().equals("회원번호") || !dto.usr_nm?.trim().equals("이름") || !dto.usr_mob?.trim().equals("모바일")
                                || !dto.usr_edm?.trim().equals("이메일") || !dto.usr_gdr?.trim().equals("성별") || !dto.usr_addr?.trim().equals("주소")
                                || !dto.usr_etc1?.trim().equals("ETC1") || !dto.usr_etc2?.trim().equals("ETC2")
                                || !dto.usr_etc3?.trim().equals("ETC3") || !dto?.usr_etc4?.trim().equals("ETC4") || !dto.usr_etc5?.trim().equals("ETC5")
                                || !dto.usr_etc6?.trim().equals("ETC6") || !dto.usr_etc7?.trim().equals("ETC7") || !dto.usr_etc8?.trim().equals("ETC8")
                                || !dto.usr_etc9?.trim().equals("ETC9") || !dto.usr_etc10?.trim().equals("ETC10")) {
                            statusMap["status"] = "Error"
                            statusMap["message"] = "파일 양식이 업로드 양식과 일치하지 않습니다."
                            return statusMap
                        }
                    }

                    if (idx > 0) {  // 초기
                        // column 타이틀 Insert를 제외
                        if (row != null) {

                            val dto = Tblmi_group_usrDto()

                            dto.usr_id = CommonUtils.Excel_cell_value(row.getCell(0))?.trim()
                            dto.usr_nm = CommonUtils.Excel_cell_value(row.getCell(1))?.trim()

                            //dto.usr_mob = CommonUtils.Excel_cell_value(row.getCell(2))?.trim()?.replace("-","")

                            if (!CommonUtils.isEmptyObject(row.getCell(2))) {
                                dto.usr_mob = CommonUtils.Excel_cell_value(row.getCell(2)).replace("-", "").trim()
                            }

                            dto.usr_edm = CommonUtils.Excel_cell_value(row.getCell(3))?.trim()
                            dto.usr_gdr = CommonUtils.Excel_cell_value(row.getCell(4))?.trim()
                            dto.usr_addr = CommonUtils.Excel_cell_value(row.getCell(5))?.trim()
                            dto.usr_etc1 = CommonUtils.Excel_cell_value(row.getCell(6))?.trim()
                            dto.usr_etc2 = CommonUtils.Excel_cell_value(row.getCell(7))?.trim()
                            dto.usr_etc3 = CommonUtils.Excel_cell_value(row.getCell(8))?.trim()
                            dto.usr_etc4 = CommonUtils.Excel_cell_value(row.getCell(9))?.trim()
                            dto.usr_etc5 = CommonUtils.Excel_cell_value(row.getCell(10))?.trim()
                            dto.usr_etc6 = CommonUtils.Excel_cell_value(row.getCell(11))?.trim()
                            dto.usr_etc7 = CommonUtils.Excel_cell_value(row.getCell(12))?.trim()
                            dto.usr_etc8 = CommonUtils.Excel_cell_value(row.getCell(13))?.trim()
                            dto.usr_etc9 = CommonUtils.Excel_cell_value(row.getCell(14))?.trim()
                            dto.usr_etc10 = CommonUtils.Excel_cell_value(row.getCell(15))?.trim()

                            //logger.error("usr_id : " + dto.usr_id);

                            if (dto.usr_id == null || !Pattern.matches("^[a-zA-Z0-9가-힣\\s]*$", dto.usr_id)) {
                                /**
                                 * 1. 회원 번호 null은 허용하지 않는다
                                 * 2. 회원 번호에 숫자, 공백, 알파벳, 한글 만 허용한다
                                 */
                                errorCnt++;
                                errorMessage = (idx + 1).toString() + " 행의 1번째 열 회원번호를 확인해 주세요"
                                break;
                            }

                            /*if (dto.usr_nm == null || !Pattern.matches("^[a-zA-Z0-9가-힣\\s!@()/_,*]*$", dto.usr_nm)) {
                                *//**
                                 * 1. 회원 명은 알파벳 ,숫자 ,공백,숫자, 한글 (자음, 모음만은 X ) 만 허용 한다
                                 * 2. 회원명에 null은 허옹햐지 않는다.
                                 *//*
                                errorCnt++;
                                errorMessage = (idx + 1).toString() + " 행의 2번째 열 회원명을 확인해 주세요"
                                break;
                            }*/

                            if (dto.usr_nm == null) {
                                /**
                                 * 1. 회원명에 null은 허용하지 않는다.
                                 */
                                errorCnt++;
                                errorMessage = (idx + 1).toString() + " 행의 2번째 열 회원명을 확인해 주세요"
                                break;
                            }

                            if (!CommonUtils.isEmptyObject(dto.usr_mob) && !UsefulUtils.isCheckPhoneNumber(dto.usr_mob!!)) {
                                // 핸드폰 번호에 null 값이 들어 갈 수 있다.
                                errorCnt++;
                                errorMessage = (idx + 1).toString() + " 행의 3번째 열 핸드폰 번호를 확인해주세요"
                                break;
                            }

                            if (!CommonUtils.isEmptyObject(dto.usr_edm) && !UsefulUtils.isCheckEmail(dto.usr_edm!!)) {
                                // 이메일에 null 값이 들어 갈 수 있다.
                                errorCnt++;
                                errorMessage = (idx + 1).toString() + " 행의 4번째 열 이메일을 확인해 주세요"
                                break;
                            }

                            if (CommonUtils.isEmptyObject(dto.usr_edm) && CommonUtils.isEmptyObject(dto.usr_mob)) {
                                // 이메일과 핸드폰 번호중 하나는 입력되어야 한다
                                errorCnt++;
                                errorMessage = (idx + 1).toString() + "행에 3,4번째 열 이메일과 핸드폰번호중 하나를 입력해주세요"
                                break;
                            }

                            if (!CommonUtils.isEmptyObject(dto.usr_gdr) && !dto.usr_gdr.equals("M") && !dto.usr_gdr.equals("F")) {
                                // M , F 이외의 값이 들어온다면 오류
                                errorCnt++;
                                errorMessage = (idx + 1).toString() + " 행의 5번째 열 성별을 확인해주세요"
                                break;
                            }

                            if (idx <= 5) {
                                // 최대 5개의 Preview 리스트만 뿌려준다
                                grpUserList.add(dto)
                            }

                            if (idx == 100) {
                                // 100개 이상은 검사하지 않는다.
                                break;
                            }
                            targetCnt++;


                            if ((dto.usr_id == null || dto.usr_id == "") && (dto.usr_nm == null || dto.usr_nm == "")
                                    && (dto.usr_mob == null || dto.usr_mob == "") && (dto.usr_edm == null || dto.usr_edm == "")) {
                                // 아이디, 유저 이름, 핸드폰 번호, 이메일이 모두 존재하지 않는데 row 에서 읽어들인다면, 엑셀 파일에 빈셀이 존재한다.
                                statusMap["status"] = "Error"
                                statusMap["message"] = targetCnt.toString() + "행의 엑셀 파일에 빈셀이 있는지 확인해 주세요"
                                return statusMap
                            }

                            // 회원 번호 카운트 증가
                            if (!CommonUtils.isEmptyObject(dto.usr_id)) {
                                if (Pattern.matches("^[a-zA-Z0-9가-힣\\s]*$", dto.usr_id)) {
                                    memNoCnt++
                                }
                            }

                            // 회원 명 카운트 증가
                            if (!CommonUtils.isEmptyObject(dto.usr_nm)) {
                                memNmCnt++
                            }

                            // 이메일 카운트 수 증가
                            if (!CommonUtils.isEmptyObject(dto.usr_edm)) {
                                if (UsefulUtils.isCheckEmail(dto.usr_edm!!)) {
                                    edmCnt++
                                }
                            }

                            // 모바일 카운트 수 증가
                            if (!CommonUtils.isEmptyObject(dto.usr_mob)) {
                                if (UsefulUtils.isCheckPhoneNumber(dto.usr_mob!!)) {
                                    mdmCnt++
                                }
                            }

                        } else {
                            statusMap["status"] = "Error"
                            statusMap["message"] = "엑셀 파일이 존재하지 않습니다."
                            return statusMap
                        }
                    }
                    idx++
                }
                if (errorCnt > 0) {
                    // 100개 미만에서 오류 발생시 알림 처리
                    statusMap["status"] = "Error"
                    statusMap["message"] = errorMessage
                    logger.error("ErrorMessage : " + errorMessage)
                    return statusMap;
                }
            } catch (e: Exception) {
                e.printStackTrace()
                statusMap["status"] = "Error"
                statusMap["message"] = "엑셀 파일에 오류가 존재합니다."
                return statusMap
            } finally {
                workbook?.close()
            }
        }

        statusMap["list"] = grpUserList
        statusMap["totalCnt"] = memNoCnt + memNmCnt + edmCnt + mdmCnt   // 총 개수 카운트
        statusMap["memNoCnt"] = memNoCnt    // 회원 번호 카운트
        statusMap["memNmCnt"] = memNmCnt // 회원 명 카운트
        statusMap["edmCnt"] = edmCnt    // 이메일 카운트
        statusMap["mdmCnt"] = mdmCnt    // 모바일 카운트
        statusMap["result"] = true
        statusMap["message"] = "엑셀 Import 완료"

        return statusMap
    }

    override fun isExistGrpNam(groupListDto: Tblmi_group_listDto): Int {
        groupListDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        return memberDao.isExistGrpNam(groupListDto)
    }

    override fun getTblmimst(pdto: Tblmi_tbl_listDto): MutableMap<String, Any> {
        val dto = pdto as Tblmi_tbl_searchDto
        val map: MutableMap<String, Any> = HashMap<String, Any>()
        var memberList: List<Tblmi_tbl_listDto> = ArrayList<Tblmi_tbl_listDto>()
        //그룹 코드에 맞는 table ID 가져오기 (tblmi_tbl_mst)
        //사용자 화면에서 보여지는 column 명칭 가져오기
        val columnNm: MutableList<String> = ArrayList<String>()
        columnNm.add("회원번호")
        columnNm.add("이름")
        columnNm.add("핸드폰번호")
        columnNm.add("모바일 수신여부")
        columnNm.add("이메일")
        columnNm.add("이메일 동의여부")
        columnNm.add("성별")
        columnNm.add("주소")
        columnNm.add("USR_ETC1")
        columnNm.add("USR_ETC2")
        columnNm.add("USR_ETC3")
        columnNm.add("USR_ETC4")
        columnNm.add("USR_ETC5")
        columnNm.add("USR_ETC6")
        columnNm.add("USR_ETC7")
        columnNm.add("USR_ETC8")
        columnNm.add("USR_ETC9")
        columnNm.add("USR_ETC10")
        //테이블에서 쓰이는 column명 가져오기(tblmi_tbl_info)
        val columnValue: MutableList<String> = ArrayList<String>()
        columnValue.add("SEQ")
        columnValue.add("USR_ID")
        columnValue.add("USR_NM")
        columnValue.add("USR_MOB")
        columnValue.add("USR_MYN")
        columnValue.add("USR_EDM")
        columnValue.add("USR_EYN")
        columnValue.add("USR_GDR")
        columnValue.add("USR_ADDR")
        columnValue.add("USR_ETC1")
        columnValue.add("USR_ETC2")
        columnValue.add("USR_ETC3")
        columnValue.add("USR_ETC4")
        columnValue.add("USR_ETC5")
        columnValue.add("USR_ETC6")
        columnValue.add("USR_ETC7")
        columnValue.add("USR_ETC8")
        columnValue.add("USR_ETC9")
        columnValue.add("USR_ETC10")

        val tblInfo: Tblmi_tbl_infoDto = Tblmi_tbl_infoDto()
        val pageNo = if (dto.pageNo == null) {
            1
        } else {
            dto.pageNo!!
        }

        val paginationInfo: PaginationInfo = UsefulUtils.makePage(pageNo, 10, 10)
        val tblmstDto: Tblmi_tbl_mstDto = Tblmi_tbl_mstDto()
        tblmstDto.tbl_grp = UsefulUtils.sessionUser().usr_grp_cd
        val resultTblmst = memberDao.getTblmimst(tblmstDto)
        if (resultTblmst != null) {
            //table ID로 table column 정보 가져오기 (tblmi_tbl_info)

            tblInfo.tbl_id = resultTblmst.tbl_id
            val tblInfoList = memberDao.getTblInfoList(tblInfo)


            for (i in tblInfoList) {
                for (j: Int in 0 until columnNm.size) {
                    if (columnNm[j] == i.col_id) {
                        columnNm[j] = i.col_nm.toString()
                    }
                }
            }
            //member table 정보(total cnt, send cnt 정보등 가져오기) (tblmi_tbl_sum)
            val tblSumDto: Tblmi_tbl_sumDto = Tblmi_tbl_sumDto()
            tblSumDto.tbl_id = resultTblmst.tbl_id
            val sumCheck = memberDao.getTblTblSum(tblSumDto)
            if (sumCheck != null) {
                map["tblSum"] = sumCheck
            }
            if (dto.searchType == "usr_id") {
                dto.usr_id = dto.searchValue
            } else if (dto.searchType == "usr_mob") {
                dto.usr_mob = dto.searchValue?.replace("-", "")
            } else if (dto.searchType == "usr_edm") {
                dto.usr_edm = dto.searchValue
            }

            dto.tbl_id = resultTblmst.tbl_id
            dto.firstIndex = paginationInfo.firstRecordIndex
            dto.recordCountPerPage = paginationInfo.recordCountPerPage
            if (!CommonUtils.isEmptyObject(dto.tbl_id)) {
                paginationInfo.totalRecordCount = memberDao.getTblTblListCnt(dto)

                memberList = memberDao.getTblTblList(dto)

                for (i in memberList) {
                    i.usr_mob = CommonUtils.numberToPhone(i.usr_mob)
                }
            }

        }


        map["columnNm"] = columnNm
        map["columnValue"] = columnValue
        map["tbl_id"] = tblInfo.tbl_id.toString()
        //map["tblInfo"] = tblInfoList

        map["page"] = paginationInfo
        map["pageNo"] = paginationInfo.currentPageNo
        map["list"] = memberList
        map["listCnt"] = paginationInfo.totalRecordCount
        return map
    }

    override fun getTblTblList(pdto: Tblmi_tbl_listDto): MutableMap<String, Any> {
        val dto = pdto as Tblmi_tbl_searchDto
        var memberList: List<Tblmi_tbl_listDto> = ArrayList<Tblmi_tbl_listDto>()
        when {
            dto.searchType?.toLowerCase() == "usr_id" -> {
                dto.usr_id = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_mob" -> {
                dto.usr_mob = dto.searchValue?.replace("-", "")
            }
            dto.searchType?.toLowerCase() == "usr_edm" -> {
                dto.usr_edm = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_nm" -> {
                dto.usr_nm = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_myn" -> {
                dto.usr_myn = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_eyn" -> {
                dto.usr_eyn = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_gdr" -> {
                dto.usr_gdr = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_addr" -> {
                dto.usr_addr = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_etc1" -> {
                dto.usr_etc1 = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_etc2" -> {
                dto.usr_etc2 = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_etc3" -> {
                dto.usr_etc3 = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_etc4" -> {
                dto.usr_etc4 = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_etc5" -> {
                dto.usr_etc5 = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_etc6" -> {
                dto.usr_etc6 = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_etc7" -> {
                dto.usr_etc7 = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_etc8" -> {
                dto.usr_etc8 = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_etc9" -> {
                dto.usr_etc9 = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_etc10" -> {
                dto.usr_etc10 = dto.searchValue
            }
        }
        //실제 member 리스트 가져오기
        val pageNo = if (dto.pageNo == null) {
            1
        } else {
            dto.pageNo!!
        }
        val paginationInfo: PaginationInfo = UsefulUtils.makePage(pageNo, 10, 10)

        dto.firstIndex = paginationInfo.firstRecordIndex
        dto.recordCountPerPage = paginationInfo.recordCountPerPage
        val map: MutableMap<String, Any> = HashMap()
        if (!CommonUtils.isEmptyObject(dto.tbl_id)) {
            paginationInfo.totalRecordCount = memberDao.getTblTblListCnt(dto)

            map["page"] = paginationInfo
            map["pageNo"] = paginationInfo.currentPageNo

            memberList = memberDao.getTblTblList(dto)

            for (i in memberList) {
                i.usr_mob = CommonUtils.numberToPhone(i.usr_mob)
            }
        }
        map["list"] = memberList
        map["listCnt"] = paginationInfo.totalRecordCount
        map["searchType"] = dto.searchType.toString()
        map["searchValue"] = dto.searchValue.toString()
        //TO DO 통계로 CNT 한번에 가져오기.
        dto.usr_myn = "Y"
        map["mdm_agree_cnt"] = memberDao.getTblTblListCnt(dto)
        dto.usr_myn = null
        dto.usr_eyn = "Y"
        map["edm_agree_cnt"] = memberDao.getTblTblListCnt(dto)
        return map
    }

    override fun downloadTblmiList(pdto: Tblmi_tbl_listDto): MutableMap<String, Any> {
        val dto = pdto as Tblmi_tbl_searchDto
        when {
            dto.searchType?.toLowerCase() == "usr_id" -> {
                dto.usr_id = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_mob" -> {
                dto.usr_mob = dto.searchValue?.replace("-", "")
            }
            dto.searchType?.toLowerCase() == "usr_edm" -> {
                dto.usr_edm = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_nm" -> {
                dto.usr_nm = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_myn" -> {
                dto.usr_myn = dto.searchValue?.toUpperCase()
            }
            dto.searchType?.toLowerCase() == "usr_eyn" -> {
                dto.usr_eyn = dto.searchValue?.toUpperCase()
            }
            dto.searchType?.toLowerCase() == "usr_gdr" -> {
                dto.usr_gdr = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_addr" -> {
                dto.usr_addr = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_etc1" -> {
                dto.usr_etc1 = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_etc2" -> {
                dto.usr_etc2 = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_etc3" -> {
                dto.usr_etc3 = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_etc4" -> {
                dto.usr_etc4 = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_etc5" -> {
                dto.usr_etc5 = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_etc6" -> {
                dto.usr_etc6 = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_etc7" -> {
                dto.usr_etc7 = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_etc8" -> {
                dto.usr_etc8 = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_etc9" -> {
                dto.usr_etc9 = dto.searchValue
            }
            dto.searchType?.toLowerCase() == "usr_etc10" -> {
                dto.usr_etc10 = dto.searchValue
            }
        }
        val paramMap: MutableMap<String, Any> = HashMap()
        val labelList = mutableListOf<String>();
        for (i in dto.columnNm!!) {
            var colNm = i.replace("[", "")
            colNm = colNm.replace("]", "")
            labelList.add(colNm)
        }

        val book: Workbook = commonService.createExcel(labelList)
        labelList.clear()

        paramMap["book"] = book
        paramMap["name"] = "DB_MEMBER"

        // 엑셀 리스트를 뽑기위한 ResultHandler 적용
        memberDao.downloadTblmiList(book, dto)

        return paramMap
    }

    override fun insertOneTargetUser(dto: Tblmi_group_usrDto): Map<String, Any> {
        val statusMap: MutableMap<String, Any> = HashMap()

        val dto = dto as GroupUsr_SearchDto

        dto.reg_id = UsefulUtils.sessionUser().usr_id
        dto.use_yn = "Y"
        memberDao.insertOneTargetUser(dto)

        val usrDto = Tblmi_group_usrDto()
        usrDto.grp_no = dto.grp_no

        val targetCnt = memberDao.selectGroupUserListCnt(usrDto)

        // 타겟 수 갱신 하기
        val groupListDto = Tblmi_group_listDto()
        groupListDto.grp_cnt = targetCnt
        groupListDto.upd_id = UsefulUtils.sessionUser().usr_id
        groupListDto.seq = dto.grp_no

        memberDao.updateGroupList(groupListDto)

        statusMap["status"] = true
        return statusMap
    }



    override fun insertTargetMimeCheck(file: MultipartFile, dto: Tblmi_group_usrDto): Map<String, Any> {

        val dto = dto as GroupUsr_SearchDto
        val fileMime = CommonUtils.checkEecelMime(file)
        val paramMap: MutableMap<String, Any> = HashMap()

        val workDto = workService.makeWorkHistory("TARGET_GROUP", "0", "그룹명 : "  + dto.grp_nm.plus("<br>" + "그룹 추가 타겟 회원 저장 진행중 입니다"))
        workService.insertWorkHistory(workDto)

        dto.work_seq = workDto.seq
        dto.reg_id = UsefulUtils.sessionUser().usr_id

        if (fileMime.isNullOrEmpty()) {
            logger.error("파일 에러")
            paramMap["check"] = false
            paramMap["message"] = "'xlsx', 'xls' 파일 형식만 업로드 가능 합니다."
            return paramMap
        } else{
            pool.insertDetailTargetTask(file,dto)
        }
        return paramMap
    }

    override fun getTblTblSum() : Map<String, Any>{
        val map: MutableMap<String, Any> = HashMap()
        val tblmstDto: Tblmi_tbl_mstDto = Tblmi_tbl_mstDto()
        tblmstDto.tbl_grp = UsefulUtils.sessionUser().usr_grp_cd
        val resultTblmst = memberDao.getTblmimst(tblmstDto)
        if(resultTblmst != null){
            //member table 정보(total cnt, send cnt 정보등 가져오기) (tblmi_tbl_sum)
            val tblSumDto: Tblmi_tbl_sumDto = Tblmi_tbl_sumDto()
            tblSumDto.tbl_id = resultTblmst.tbl_id
            val sumCheck = memberDao.getTblTblSum(tblSumDto)
            if(sumCheck != null){
                map["tblSum"] = sumCheck
                map["tblSumCk"] = true
            }else{
                map["tblSumCk"] = false
            }
        }else{
            map["tblSumCk"] = false
        }
        return map
    }

}







