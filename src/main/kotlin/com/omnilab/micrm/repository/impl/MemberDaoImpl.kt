package com.omnilab.micrm.repository.impl

import com.monitorjbl.xlsx.StreamingReader
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.GroupUsr_SearchDto
import com.omnilab.micrm.model.Sup_searchDto
import com.omnilab.micrm.model.table.Tblmi_group_listDto
import com.omnilab.micrm.model.table.Tblmi_group_usrDto
import com.omnilab.micrm.model.table.Tblmi_supDto
import com.omnilab.micrm.repository.MemberDao
import com.omnilab.micrm.repository.MicrmUserDao
import com.omnilab.micrm.repository.WorkDao
import com.omnilab.micrm.service.CommonService
import com.omnilab.micrm.service.WorkService
import org.apache.ibatis.session.ResultContext
import org.apache.ibatis.session.ResultHandler
import org.apache.ibatis.session.SqlSession
import org.apache.poi.ss.usermodel.Workbook
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor
import org.springframework.stereotype.Repository
import org.springframework.web.multipart.MultipartFile
import java.io.InputStream
import java.util.ArrayList
import java.util.HashMap
import java.util.regex.Pattern
import kotlin.Exception

@Repository("MemberDaoImpl")
class MemberDaoImpl : MemberDao {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Autowired
    private lateinit var sqlSession: SqlSession

    @Autowired
    @Qualifier("WorkHistoryDaoImpl")
    private lateinit var workDao: WorkDao

    @Autowired
    private lateinit var commonService: CommonService

    @Autowired
    @Qualifier("MicrmUserDaoImpl")
    private lateinit var micrmUserDao: MicrmUserDao

    @Autowired
    @Qualifier("taskExecutor")
    private lateinit var taskExecutor: ThreadPoolTaskExecutor

    override fun insertGroup(groupListDto: Tblmi_group_listDto) {
        sqlSession.insert("insertGroupList", groupListDto)
    }

    override fun insertGroupUser(groupUserList: List<Tblmi_group_usrDto>) {
        val splitNum = 1000 // 1000 개씩 끊어서 insert
        val roopNum = Math.ceil((groupUserList.size.toFloat() / splitNum).toDouble()).toInt()
        var lastNum: Int

        var paramMap: MutableMap<String, List<Tblmi_group_usrDto>> = HashMap<String, List<Tblmi_group_usrDto>>()

        for (i in 0 until roopNum) {
            lastNum = splitNum * (i + 1)
            if (lastNum > groupUserList.size) lastNum = groupUserList.size
            logger.warn(lastNum.toString() + " / " + groupUserList.size)
            paramMap["groupUserList"] = groupUserList.subList(i * splitNum, lastNum)
            sqlSession.insert("insertGrpUser", paramMap)
        }
    }

    /*fun insertGroupUser(groupUserList: List<Tblmi_group_usrDto>) {
        // 대용량 처리를 위한 배치 처리 Insert

        val splitNum = 1000 // 1000 개씩 끊어서 insert
        val roopNum = Math.ceil((groupUserList.size.toFloat() / splitNum).toDouble()).toInt()
        var lastNum: Int

        var paramMap: MutableMap<String, List<Tblmi_group_usrDto>> = HashMap<String, List<Tblmi_group_usrDto>>()

        for (i in 0 until roopNum) {
            lastNum = splitNum * (i + 1)
            if (lastNum > groupUserList.size) lastNum = groupUserList.size
            logger.warn(lastNum.toString() + " / " + groupUserList.size)
            paramMap["groupUserList"] = groupUserList.subList(i * splitNum, lastNum)
            sqlSession.insert("insertGrpUser", paramMap)
        }

    }*/

    override fun selectOneGroup(groupListDto: Tblmi_group_listDto): Tblmi_group_listDto {
        return sqlSession.selectOne("selectOneGroup", groupListDto)
    }

    override fun selectGroupList(groupListDto: Tblmi_group_listDto): List<Tblmi_group_listDto> {
        return sqlSession.selectList("selectGroupList", groupListDto)
    }

    override fun selectGroupUserList(groupUserDto: Tblmi_group_usrDto): List<Tblmi_group_listDto> {
        return sqlSession.selectList("selectGroupUserList", groupUserDto)
    }

    override fun selectGroupListCnt(groupListDto: Tblmi_group_listDto): Int {
        return sqlSession.selectOne("selectGroupListCnt", groupListDto)
    }

    override fun selectGroupUserListCnt(groupUserDto: Tblmi_group_usrDto): Int {
        return sqlSession.selectOne("selectGroupUserListCnt", groupUserDto)
    }

    override fun selectGroupUserCnt(groupUserDto: Tblmi_group_usrDto): Int {
        return sqlSession.selectOne("selectGroupUserCnt", groupUserDto)
    }

    override fun selectOneGroupUser(groupUserDto: Tblmi_group_usrDto): Tblmi_group_usrDto {
        return sqlSession.selectOne("selectOneGroupUser", groupUserDto)
    }

    override fun updateGroupList(groupListDto: Tblmi_group_listDto) {
        sqlSession.update("updateGrpList", groupListDto)
    }

    override fun updateGroupState(groupListDto: Tblmi_group_listDto) {
        sqlSession.update("updateGrpUseYn", groupListDto)
    }

    override fun deleteGrpUser(groupUserDto: Tblmi_group_usrDto) {
        sqlSession.delete("deleteTargetUser", groupUserDto)
    }

    override fun deleteGrpList(groupList: List<Tblmi_group_listDto>) {
        for (i in groupList) {
            sqlSession.update("deleteGrpList", i);
        }
    }

    override fun deleteGrpAllList(groupListDto: Tblmi_group_listDto) {
        sqlSession.update("deleteAllGrpList", groupListDto)
    }

    override fun deleteGrpUserList(groupUserList: List<Tblmi_group_usrDto>) {
        for (i in groupUserList) {
            sqlSession.update("deleteGrpUserList", i);
        }
    }

    override fun deleteGrpUserAllList(groupUserDto: Tblmi_group_usrDto) {
        sqlSession.update("deleteAllGrpUserList", groupUserDto)
    }

    override fun excelDownGrpUserList(book: Workbook, groupUserDto: Tblmi_group_usrDto) {
        // 대용량 처리를 위해 ResultHandler 적용
        sqlSession.select("selectGroupUserList", groupUserDto, object : ResultHandler<Any?> {

            var sheet = book.getSheet("sheet1")
            var i = sheet.lastRowNum + 1

            override fun handleResult(resultContext: ResultContext<*>) {
                val row = sheet.createRow(i)
                val groupUserDtoR: Tblmi_group_usrDto = resultContext.resultObject as Tblmi_group_usrDto
                row.createCell(0).setCellValue(groupUserDtoR.usr_id)
                row.createCell(1).setCellValue(groupUserDtoR.usr_nm)
                //row.createCell(2).setCellValue(CommonUtils.numberToPhone(groupUserDtoR.usr_mob))

                if (!CommonUtils.isEmptyObject(groupUserDtoR.usr_mob)) {
                    row.createCell(2).setCellValue(CommonUtils.numberToPhone(groupUserDtoR.usr_mob))
                }

                row.createCell(3).setCellValue(groupUserDtoR.usr_edm)
                row.createCell(4).setCellValue(groupUserDtoR.usr_gdr)
                row.createCell(5).setCellValue(groupUserDtoR.usr_addr)
                row.createCell(6).setCellValue(groupUserDtoR.usr_etc1)
                row.createCell(7).setCellValue(groupUserDtoR.usr_etc2)
                row.createCell(8).setCellValue(groupUserDtoR.usr_etc3)
                row.createCell(9).setCellValue(groupUserDtoR.usr_etc4)
                row.createCell(10).setCellValue(groupUserDtoR.usr_etc5)
                row.createCell(11).setCellValue(groupUserDtoR.usr_etc6)
                row.createCell(12).setCellValue(groupUserDtoR.usr_etc7)
                row.createCell(13).setCellValue(groupUserDtoR.usr_etc8)
                row.createCell(14).setCellValue(groupUserDtoR.usr_etc9)
                row.createCell(15).setCellValue(groupUserDtoR.usr_etc10)
                i++
            }
        })
    }

    override fun getTblmiSupListCnt(dto: Tblmi_supDto): Int {
        return sqlSession.selectOne("getTblmiSupListCnt", dto)
    }

    override fun getTblmiSupList(dto: Tblmi_supDto): List<Tblmi_supDto> {
        return sqlSession.selectList("getTblmiSupList", dto)
    }

    override fun saveTblmiSupList(dto: Tblmi_supDto): Int {
        return sqlSession.insert("saveTblmiSup", dto)
    }

    override fun saveTblmiSupList(dtoList: List<Tblmi_supDto>): Int {
        return sqlSession.insert("saveTblmiSupList", dtoList)
    }

    override fun updateTblmiSupList(dto: Tblmi_supDto): Int {
        return sqlSession.update("updateTblmiSup", dto)
    }

    override fun downloadTblmiSup(book: Workbook, dto: Tblmi_supDto) {
        sqlSession.select("getTblmiSupList", dto, object : ResultHandler<Any?> {

            var sheet = book.getSheet("sheet1")
            var i = sheet.lastRowNum + 1
            override fun handleResult(resultContext: ResultContext<*>) {
                val row = sheet.createRow(i)
                val reusultDto: Sup_searchDto = resultContext.resultObject as Sup_searchDto
                row.createCell(0).setCellValue(reusultDto.sup_type)
                row.createCell(1).setCellValue(reusultDto.pro_id)
                row.createCell(2).setCellValue(reusultDto.ch_type)
                row.createCell(3).setCellValue(reusultDto.send_to)
                row.createCell(4).setCellValue(reusultDto.camp_nm)
                row.createCell(5).setCellValue(reusultDto.reg_dt)
                i++
            }
        })
    }

    // 그룹명 존재여부 확인
    override fun isExistGrpNam(groupListDto: Tblmi_group_listDto): Int {
        return sqlSession.selectOne("isExistGrpNm", groupListDto)
    }

    //member 마스터 테이블 정보 가져오기
    override fun getTblmimst(dto: Tblmi_tbl_mstDto): Tblmi_tbl_mstDto? {
        return sqlSession.selectOne("getTblmimst", dto)
    }

    //member 테이블 컬럼 정보
    override fun getTblInfoList(dto: Tblmi_tbl_infoDto): List<Tblmi_tbl_infoDto> {
        return sqlSession.selectList("getTblInfoList", dto)
    }

    //member 통계
    override fun getTblTblSum(dto: Tblmi_tbl_sumDto): Tblmi_tbl_sumDto? {
        return sqlSession.selectOne("getTblTblSum", dto)
    }

    //member 리스트
    override fun getTblTblList(dto: Tblmi_tbl_listDto): List<Tblmi_tbl_listDto> {
        return sqlSession.selectList("getTblTblList", dto)
    }

    //member 리스트 카운트
    override fun getTblTblListCnt(dto: Tblmi_tbl_listDto): Int {
        return sqlSession.selectOne("getTblTblListCnt", dto)
    }

    override fun downloadTblmiList(book: Workbook, dto: Tblmi_tbl_listDto) {
        sqlSession.select("getTblTblList", dto, object : ResultHandler<Any?> {

            var sheet = book.getSheet("sheet1")
            var i = sheet.lastRowNum + 1
            override fun handleResult(resultContext: ResultContext<*>) {
                val row = sheet.createRow(i)
                val reusultDto: Tblmi_tbl_listDto = resultContext.resultObject as Tblmi_tbl_listDto

                //toString 한 내용이 null 이면 excel에 null 기입.
                row.createCell(0).setCellValue(reusultDto.usr_id)
                row.createCell(1).setCellValue(reusultDto.usr_nm)
                row.createCell(2).setCellValue(CommonUtils.numberToPhone(reusultDto.usr_mob))
                row.createCell(3).setCellValue(reusultDto.usr_myn)
                row.createCell(4).setCellValue(reusultDto.usr_edm)
                row.createCell(5).setCellValue(reusultDto.usr_eyn)
                row.createCell(6).setCellValue(reusultDto.usr_gdr)
                row.createCell(7).setCellValue(reusultDto.usr_addr)
                row.createCell(8).setCellValue(reusultDto.usr_etc1)
                row.createCell(9).setCellValue(reusultDto.usr_etc2)
                row.createCell(10).setCellValue(reusultDto.usr_etc3)
                row.createCell(11).setCellValue(reusultDto.usr_etc4)
                row.createCell(12).setCellValue(reusultDto.usr_etc5)
                row.createCell(13).setCellValue(reusultDto.usr_etc6)
                row.createCell(14).setCellValue(reusultDto.usr_etc7)
                row.createCell(15).setCellValue(reusultDto.usr_etc8)
                row.createCell(16).setCellValue(reusultDto.usr_etc9)
                row.createCell(17).setCellValue(reusultDto.usr_etc10)
                i++
            }
        })
    }

    override fun insertOneTargetUser(dto: Tblmi_group_usrDto): Int {
        return sqlSession.insert("insertOneTargetUser", dto)
    }

    override fun insertTargetGrp(file: MultipartFile, excel_file: InputStream, dto: Tblmi_group_usrDto): Map<String, Any> {

        val dto = dto as GroupUsr_SearchDto

        val fileNm = file?.originalFilename
        val paramMap: MutableMap<String, Any> = HashMap()
        val grp_no = dto.grp_no
        val grp_nm = dto.grp_nm
        val usr_id = dto.reg_id
        val workSeq = dto.work_seq

        var workbook: Workbook? = null
        var grpUserList: MutableList<Tblmi_group_usrDto> = ArrayList<Tblmi_group_usrDto>()

        var idx = 0
        var cnt = 0;
        var errorCnt = 0
        var errorMessage = "";

        val failWorkDto = Tblmi_workDto()


        try {
            workbook = StreamingReader.builder()
                    .rowCacheSize(100)
                    .bufferSize(4096)
                    .open(file.inputStream)

            val sheet = workbook?.getSheetAt(0)

            for (row in sheet!!) {
                if (idx > 0) {
                    if (row != null) {

                        val dto = Tblmi_group_usrDto()
                        dto.grp_no = grp_no
                        dto.reg_id = usr_id
                        dto.use_yn = "Y"

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
                        /*if (dto.usr_nm == null || !Pattern.matches("^[a-zA-Z0-9가-힣\\s!@()/_,*]*$", dto.usr_nm)) {
                            *//**
                             * 1. 회원 명은 알파벳 ,숫자 ,공백,숫자, 한글 (자음, 모음만은 X ) 만 허용 한다 (특수 문자 허용 X)
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
                            //logger.error("edm : "  +dto.usr_edm)
                            //logger.error("mdm : "  +dto.usr_mob)
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
                            // 1000 개씩 끊어서 보내기
                            //memberDao.insertGroupUser(grpUserList)

                            val splitNum = 1000 // 1000 개씩 끊어서 insert
                            val roopNum = Math.ceil((grpUserList.size.toFloat() / splitNum).toDouble()).toInt()
                            var lastNum: Int

                            val dataMap : MutableMap<String, List<Tblmi_group_usrDto>> = HashMap<String, List<Tblmi_group_usrDto>>()

                            for (i in 0 until roopNum) {
                                lastNum = splitNum * (i + 1)
                                if (lastNum > grpUserList.size) lastNum = grpUserList.size
                                logger.warn(lastNum.toString() + " / " + grpUserList.size)
                                dataMap["groupUserList"] = grpUserList.subList(i * splitNum, lastNum)
                                sqlSession.insert("insertGrpUser", dataMap)
                            }
                            grpUserList = ArrayList<Tblmi_group_usrDto>()
                            cnt = 0
                        }
                    }
                }
                idx++
            }

            if (errorCnt > 0) {
                // 엑셀 데이터에 에러가 존재 한다면 에러 리턴

                // 오류 상태 저장
                //val failWorkDto = Tblmi_workDto()
                /*failWorkDto.seq = workSeq
                failWorkDto.upd_id = dto.reg_id
                failWorkDto.work_stat = "2"
                failWorkDto.work_msg = " 파일명 : " + fileNm + "<br>" + " 그룹 명 : " + dto.grp_nm + "<br>" + "오류 결과 : " + "서버 에러 " + errorMessage
                workDao.updateWorkHistory(failWorkDto)

                // 오류 이메일 전송
                val usrDto = Tblmi_usrDto()
                usrDto.usr_id = dto.reg_id

                val emailUser = micrmUserDao.sel_tblmi_usr(usrDto)

                val sendTo = emailUser.usr_email.toString()
                val sendToNm = emailUser.usr_nm.toString()
                val sendFrom = UsefulUtils.adminEmail();
                val subject = "[MICRM] 업로드 생성 결과"
                val body = failWorkDto.work_msg!!
                commonService.sendMail(sendTo, sendToNm, sendFrom, subject, body);*/

                logger.error("Excel Data Error")
                throw Exception()
            }
            //memberDao.insertGroupUser(grpUserList)

            val splitNum = 1000 // 1000 개씩 끊어서 insert
            val roopNum = Math.ceil((grpUserList.size.toFloat() / splitNum).toDouble()).toInt()
            var lastNum: Int

            val dataMap = HashMap<String, List<Tblmi_group_usrDto>>()

            for (i in 0 until roopNum) {
                lastNum = splitNum * (i + 1)
                if (lastNum > grpUserList.size) lastNum = grpUserList.size
                logger.warn(lastNum.toString() + " / " + grpUserList.size)
                dataMap["groupUserList"] = grpUserList.subList(i * splitNum, lastNum)
                sqlSession.insert("insertGrpUser", dataMap)
            }

        } catch (e: Exception) {

            logger.error("Catch Server Error : {}" , e.printStackTrace())

            // 오류 상태 저장
            /*val failWorkDto = Tblmi_workDto()
            failWorkDto.seq = workSeq
            failWorkDto.upd_id = dto.reg_id
            failWorkDto.work_stat = "2"
            failWorkDto.work_msg = " 파일명 : " + fileNm + "<br>" + " 그룹 명 : " + dto.grp_nm + "<br>" + "오류 결과 : " + "서버 에러 " + errorMessage
            workDao.updateWorkHistory(failWorkDto)*/

            failWorkDto.work_msg = " 파일명 : " + fileNm + "<br>" + " 그룹 명 : " + dto.grp_nm + "<br>" + "오류 결과 : " + "서버 에러 " + errorMessage
            logger.error("errorMessage : " + errorMessage)

            // 오류 이메일 전송
            val usrDto = Tblmi_usrDto()
            usrDto.usr_id = dto.reg_id

            val emailUser = micrmUserDao.sel_tblmi_usr(usrDto)

            val sendTo = emailUser.usr_email.toString()
            val sendToNm = emailUser.usr_nm.toString()
            val sendFrom = UsefulUtils.adminEmail();
            val subject = "[MICRM] 업로드 생성 결과"
            val body = failWorkDto.work_msg!!
            commonService.sendMail(sendTo, sendToNm, sendFrom, subject, body);
            throw Exception(errorMessage)

        } finally {
            workbook?.close()
        }
        // 성공 상태 저장
        val successWorkDto = Tblmi_workDto()
        successWorkDto.seq = workSeq
        successWorkDto.upd_id = dto.reg_id
        successWorkDto.work_stat = "1"
        successWorkDto.work_msg = "test"
        successWorkDto.work_msg = " 파일명 : " + file.originalFilename + "<br>" + " 그룹 명 : " + dto.grp_nm + "<br>" + "생성 결과 : " + (idx - 1).toString() + " 명의 타겟이 입력되었습니다";
        workDao.updateWorkHistory(successWorkDto)

        // 타겟 수 갱신하기
        val targetDto = Tblmi_group_usrDto()
        targetDto.grp_no = dto.grp_no

        val targetCnt = selectGroupUserListCnt(targetDto)

        val groupListDto = Tblmi_group_listDto()
        groupListDto.grp_cnt = targetCnt
        groupListDto.upd_id = usr_id
        groupListDto.seq = dto.grp_no

        updateGroupList(groupListDto)

        // 이메일 Send
        val usrDto = Tblmi_usrDto()
        usrDto.usr_id = dto.reg_id

        val emailUser = micrmUserDao.sel_tblmi_usr(usrDto)

        val sendTo = emailUser.usr_email.toString()
        val sendToNm = emailUser.usr_nm.toString()
        val sendFrom = UsefulUtils.adminEmail();
        val subject = "[MICRM] 업로드 생성 결과"
        val body = successWorkDto.work_msg!!

        commonService.sendMail(sendTo, sendToNm, sendFrom, subject, body);
        paramMap["message"] = "업로드 그룹 파일이 성공적으로 저장되었습니다"
        return paramMap
    }

}
