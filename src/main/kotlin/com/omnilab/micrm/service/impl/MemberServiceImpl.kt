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







