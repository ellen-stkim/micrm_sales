package com.omnilab.micrm.repository.impl

import com.monitorjbl.xlsx.StreamingReader
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.GroupUsr_SearchDto
import com.omnilab.micrm.model.table.Tblmi_group_listDto
import com.omnilab.micrm.model.table.Tblmi_group_usrDto
import com.omnilab.micrm.repository.MemberDao
import com.omnilab.micrm.repository.MicrmUserDao
import com.omnilab.micrm.repository.WorkDao
import com.omnilab.micrm.service.CommonService
import org.apache.ibatis.session.SqlSession
import org.apache.poi.ss.usermodel.Workbook
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
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
    private lateinit var commonService: com.omnilab.micrm.service.CommonService

    @Autowired
    @Qualifier("MicrmUserDaoImpl")
    private lateinit var micrmUserDao: MicrmUserDao

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

    override fun updateGroupList(groupListDto: Tblmi_group_listDto) {
        sqlSession.update("updateGrpList", groupListDto)
    }

    override fun deleteGrpUser(groupUserDto: Tblmi_group_usrDto) {
        sqlSession.delete("deleteTargetUser", groupUserDto)
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

    override fun selectGroupUserListCnt(groupUserDto: Tblmi_group_usrDto): Int {
        return sqlSession.selectOne("selectGroupUserListCnt", groupUserDto)
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
