package com.omnilab.micrm.service.impl

import com.monitorjbl.xlsx.StreamingReader
import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.CommonUtils.isEmptyObject
import com.omnilab.micrm.common.FileUploadUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.*
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.repository.MemberDao
import com.omnilab.micrm.repository.SysSettingDao
import com.omnilab.micrm.repository.SysWorkDao
import com.omnilab.micrm.service.SysSettingService
import com.omnilab.micrm.service.WorkService
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo
import org.apache.poi.ss.usermodel.Workbook
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import org.springframework.web.multipart.MultipartFile
import java.text.SimpleDateFormat
import java.util.*
import java.util.regex.Pattern
import kotlin.collections.ArrayList
import kotlin.collections.HashMap


@Service("SysSettingServiceImpl")

class SysSettingServiceImpl : SysSettingService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Value("\${upload.src}")
    private val filePath: String? = null

    @Autowired
    lateinit var sysSettingDao: SysSettingDao;

    @Autowired
    @Qualifier("SysWorkDaoImpl")
    private lateinit var sysWorkDao: SysWorkDao

    @Autowired
    @Qualifier("WorkServiceImpl")
    private lateinit var workService: WorkService

    @Autowired
    lateinit var fileUpload: FileUploadUtils;

    override fun getNoticeList(ndto: Tblmi_notiDto): MutableMap<String, Any> {
        val dto = ndto as Noti_searchDto

        if(dto.searchType == "noti_popyn") {
            dto.noti_popyn = dto.searchValue
        }else if (dto.searchType == "noti_sub") {
            dto.noti_sub = dto.searchValue
        }else if (dto.searchType == "usr_email") {
            dto.noti_sub = dto.searchValue
        }

        val map: MutableMap<String, Any> = HashMap()
        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val pageNo = if (dto.pageNo == null) {
            1
        } else {
            dto.pageNo!!
        }

        val paginationInfo: PaginationInfo = UsefulUtils.makePage(pageNo, 10, 10)

        dto.firstIndex = paginationInfo.firstRecordIndex
        dto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = sysSettingDao.getNoticeListCnt(dto)

        map["page"] = paginationInfo
        map["pageNo"] = paginationInfo.currentPageNo
        map["cnt"] = paginationInfo.totalRecordCount
        map["list"] = sysSettingDao.getNoticeList(dto);
        return map;
    }

    override fun saveNotice(dto: Tblmi_notiDto): MutableMap<String, Any> {
        val userInfo: Tblmi_usrDto = UsefulUtils.sessionUser()
        val map: MutableMap<String, Any> = HashMap()
        dto.usr_grp_cd = userInfo.usr_grp_cd
        try {
            if (isEmptyObject(dto.seq)) {
                dto.noti_popyn = "N";
                if (dto.noti_chk == null) {
                    dto.noti_chk = "0"
                }
                dto.reg_id = userInfo.usr_id
                dto.upd_id = null
                sysSettingDao.saveNotice(dto);
                map["notiSeq"] = dto.seq.toString()
            } else {
                dto.reg_id = null
                dto.upd_id = userInfo.usr_id
                sysSettingDao.updateNotice(dto);
                map["notiSeq"] = dto.seq.toString()
            }
            map["message"] = 1;
        } catch (e: Exception) {
            map["message"] = 0;
        }

        return map;
    }

    override fun getNoticeDetail(ndto: Tblmi_notiDto): MutableMap<String, Any> {
        val dto = ndto as Noti_searchDto
        val map: MutableMap<String, Any> = HashMap()
        map["list"] = sysSettingDao.getNoticeList(dto);
        return map;
    }

    override fun deleteNotice(dto: Tblmi_notiDto): MutableMap<String, Any> {
        val map: MutableMap<String, Any> = HashMap()
        dto.upd_id = UsefulUtils.sessionUser().usr_id
        dto.noti_popyn = "N"
        dto.del_yn = "Y"
        val deleteCnt: Int = sysSettingDao.deleteNotice(dto)
        if (deleteCnt > 0) {
            map["message"] = deleteCnt
            //삭제 파일 추가 요
            val notiFileDto = Tblmi_noti_fileDto()
            notiFileDto.noti_seq = dto.seq
            val notiFileDtoList = sysSettingDao.getNoticeFileList(notiFileDto)
            if (notiFileDtoList.isNotEmpty()) {
                for (i in notiFileDtoList) {
                    logger.warn(fileUpload.fileDelete(filePath, i.file_nm.toString()))
                    sysSettingDao.deleteNoticeFile(i)
                }
            }
        }

        return map;
    }

    override fun saveNoticePopyn(dto: Tblmi_notiDto): MutableMap<String, Any> {
        val usr_id = UsefulUtils.sessionUser().usr_id
        var map: MutableMap<String, Any> = HashMap()
        //OFF로 바뀔경우
        if (dto.noti_popyn.equals("N")) {
            dto.upd_id = usr_id
            map = saveNotice(dto)
        } else {      //ON으로 바뀔경우 ON 개수 확인.
            val testDto = dto as Noti_searchDto
            testDto.noti_popyn = "Y"
            testDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
            val noticeCnt = sysSettingDao.getNoticeListCnt(testDto)
            if (noticeCnt >= 2) {
                map["message"] = false
            } else {
                dto.upd_id = usr_id
                map = saveNotice(dto)
            }
        }
        return map
    }

    //공지사항 팝업리스트 가져오기
    override fun getNoticePop(ndto: Tblmi_notiDto): MutableMap<String, Any> {
        val dto = ndto as Noti_searchDto
        val map: MutableMap<String, Any> = HashMap()
        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val resultDto: MutableList<Tblmi_notiDto> = sysSettingDao.getNoticeList(dto).toMutableList()
        for (i in resultDto) {
            i.noti_body = i.noti_body?.replace("&lt;", "<")
            i.noti_body = i.noti_body?.replace("&gt;", ">")
            i.noti_body = i.noti_body?.replace("&amp;nbsp;", " ")
            i.noti_body = i.noti_body?.replace("&quot;", "\"")
        }
        dto.usr_grp_cd = "00"
        resultDto += sysSettingDao.getNoticeList(dto)
        map["list"] = resultDto;
        return map;
    }

    //공지사항 파일 업로드 정보 저장
    override fun insertNoticeFile(map: MutableMap<String, Any>): MutableMap<String, Any> {
        val returnMap: MutableMap<String, Any> = HashMap()
        val dto: Tblmi_noti_fileDto = Tblmi_noti_fileDto()
        dto.reg_id = UsefulUtils.sessionUser().usr_id
        dto.file_org_nm = map["fileName"].toString()
        dto.file_nm = map["file_nm"].toString()
        dto.file_extension = map["file_extention"].toString()
        dto.file_mime = map["file_mime"].toString()
        returnMap["message"] = sysSettingDao.insertNoticeFile(dto);
        returnMap["ckFileNm"] = dto.file_nm!!;
        return returnMap;
    }

    //공지사항 파일 업로드 정보 업데이트
    override fun updateNotiFile(dto: Tblmi_notiDto, ckFilename: String): MutableMap<String, Any> {
        val returnMap: MutableMap<String, Any> = HashMap()
        val fileDto: Tblmi_noti_fileDto = Tblmi_noti_fileDto()
        fileDto.upd_id = UsefulUtils.sessionUser().usr_id
        fileDto.noti_seq = dto.seq
        fileDto.file_nm = ckFilename.substring(ckFilename.lastIndexOf("/") + 1)
        returnMap["message"] = sysSettingDao.updateNotiFile(fileDto);
        return returnMap
    }

    override fun getMailSettingList(dto: Tblmi_set_lstDto): MutableMap<String, Any> {

        val map: MutableMap<String, Any> = HashMap()
        val searchDto = dto as SetLst_searchDto

        val pageNo = if (searchDto.pageNo == null) {
            1
        } else {
            searchDto.pageNo!!
        }

        if (searchDto.searchType == "list_nm") {
            searchDto.list_nm = searchDto.searchValue
        } else if (searchDto.searchType == "list_val") {
            searchDto.list_val = searchDto.searchValue
        } else if (searchDto.searchType == "use_yn") {
            searchDto.use_yn = searchDto.searchValue
        }

        searchDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        searchDto.list_tp_id = "CH01"
        searchDto.list_dt_id = "DMTP01"

        val paginationInfo: PaginationInfo = UsefulUtils.makePage(pageNo, 10, 10)

        searchDto.firstIndex = paginationInfo.firstRecordIndex
        searchDto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = sysSettingDao.getMailSettingListCnt(searchDto)

        map["page"] = paginationInfo
        map["pageNo"] = paginationInfo.currentPageNo
        map["cnt"] = paginationInfo.totalRecordCount
        map["list"] = sysSettingDao.getMailSettingList(searchDto);

        return map;
    }

    override fun getCommCD(dto: Tblmi_comm_cdDto): Tblmi_comm_cdDto? {
        return sysSettingDao.getCommCD(dto)
    }

    override fun getCommCDLst(dto: Tblmi_comm_cdDto): List<Tblmi_comm_cdDto> {
        return sysSettingDao.getCommCDLst(dto)
    }

    /**
     * @Method Name  : getDBValue()
     * @Since    : 2021. 03. 07.
     * @author   : Andy
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 그룹 코드에 맞는 Table id 가져오기
     * @title : 테이블 id 가져오기
     */

    override fun getDBValue(): Map<String, Any> {
        //그룹 코드에 맞는 table ID 가져오기 (tblmi_tbl_mst)
        val tblmstDto: Tblmi_tbl_mstDto = Tblmi_tbl_mstDto()
        val map: MutableMap<String, Any> = HashMap<String, Any>()
        tblmstDto.tbl_grp = UsefulUtils.sessionUser().usr_grp_cd
        val resultTblmst = memberDao.getTblmimst(tblmstDto)
        //사용자 화면에서 보여지는 column 명칭 가져오기
        val columnNm: MutableList<String> = java.util.ArrayList<String>()
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
        map["tbl_id"] = false
        //table ID로 table column 정보 가져오기 (tblmi_tbl_info)
        if (resultTblmst != null) {
            val tblInfo: Tblmi_tbl_infoDto = Tblmi_tbl_infoDto()
            tblInfo.tbl_id = resultTblmst.tbl_id
            val tblInfoList = memberDao.getTblInfoList(tblInfo)


            for (i in tblInfoList) {
                for (j: Int in 0 until columnNm.size) {
                    if (columnNm[j] == i.col_id) {
                        columnNm[j] = i.col_nm.toString()
                    }
                }
            }
            map["tbl_id"] = tblInfo.tbl_id.toString()
        }

        //테이블에서 쓰이는 column명 가져오기(tblmi_tbl_info)
        val columnValue: MutableList<String> = java.util.ArrayList<String>()
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

        map["columnNm"] = columnNm
        map["columnValue"] = columnValue


        return map
    }

    override fun selectAlarmList(notiDto: Tblmi_notiDto, workDto: Tblmi_workDto): Map<String, Any> {
        val listMap: MutableMap<String, Any> = HashMap()
        val dateMap = getDate()

        val usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val usr_id = UsefulUtils.sessionUser().usr_id

        val workSearchDto = workDto as WorkSearch_Dto
        workSearchDto.work_usr_id = usr_id
        workSearchDto.work_grp_cd = usr_grp_cd
        workSearchDto.reg_dt = dateMap["weekDay"]
        workSearchDto.reg_dt_range = dateMap["tomorrow"]

        val isNewWorkCnt = sysWorkDao.checkAlarmCnt(workSearchDto)

        if (isNewWorkCnt < 10) {
            // 새로운 작업 내역이 10개 미만일 경우만 10개 제한으로 데이터를 뽑아온다.
            workSearchDto.isLimit = 10
        } else {
            // 새로운 작업 내역이 10개 이상일 경우 읽지 않은 workList를 가져온다
            workSearchDto.notify = 1
        }

        val notiSearchDto = notiDto as Noti_searchDto
        notiSearchDto.usr_grp_cd = usr_grp_cd
        notiSearchDto.noti_popyn = "Y"

        listMap["workCnt"] = isNewWorkCnt
        listMap["workList"] = sysWorkDao.selectWorkListForAlarm(workSearchDto)
        listMap["notiList"] = sysSettingDao.getNoticeList(notiSearchDto)

        return listMap
    }

    override fun checkAlarmCnt(): Int {

        val usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val usr_id = UsefulUtils.sessionUser().usr_id
        val dateMap = getDate()

        val workDto = WorkSearch_Dto()
        workDto.work_usr_id = usr_id
        workDto.work_grp_cd = usr_grp_cd
        workDto.reg_dt = dateMap["weekDay"]
        workDto.reg_dt_range = dateMap["tomorrow"]

        return sysWorkDao.checkAlarmCnt(workDto)
    }

    override fun updateAlarmStatus(workDto: Tblmi_workDto): Map<String, Any> {
        val usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val usr_id = UsefulUtils.sessionUser().usr_id
        val statusMap: MutableMap<String, Any> = HashMap();
        val dateMap = getDate()

        val workSearchDto = workDto as WorkSearch_Dto
        workSearchDto.work_usr_id = usr_id
        workSearchDto.work_grp_cd = usr_grp_cd
        workSearchDto.reg_dt = dateMap["weekDay"]
        workSearchDto.reg_dt_range = dateMap["tomorrow"]

        val resultCnt = sysWorkDao.checkAlarmCnt(workSearchDto)

        if (resultCnt > 0) {
            // 읽지 않은 알람이 있다면 update 처리한다
            //logger.error("읽지 않은 알람 업데 이트 ");
            sysWorkDao.updateAlarmStatus(workSearchDto)
        }

        statusMap["status"] = true
        return statusMap
    }

    private fun getDate(): Map<String, String> {

        val dateMap: MutableMap<String, String> = HashMap()

        // 내일 날짜 구하기
        val tomorrow = Calendar.getInstance()
        tomorrow.add(Calendar.DATE, 1)
        dateMap["tomorrow"] = SimpleDateFormat("yyyy-MM-dd").format(tomorrow.time)

        // 일주일 전 날짜 구하기
        val week = Calendar.getInstance()
        week.add(Calendar.DATE, -7);
        dateMap["weekDay"] = SimpleDateFormat("yyyy-MM-dd").format(week.time);

        return dateMap
    }

    override fun updateSetLstYn(dto: Tblmi_set_lstDto): Map<String, Any> {

        val statusMap: MutableMap<String, Any> = HashMap()

        if (dto.use_yn == "Y") {
            dto.use_yn = "N"
        } else if (dto.use_yn == "N") {
            dto.use_yn = "Y"
        }

        val result = sysSettingDao.updateSetLstYn(dto)
        statusMap["status"] = result >= 1
        return statusMap
    }

    override fun insertMailLst(lstDto: Tblmi_set_lstDto): Map<String, Any> {

        val userInfo = UsefulUtils.sessionUser()
        val statusMap: MutableMap<String, Any> = HashMap()

        lstDto.list_tp_id = "CH01"
        lstDto.list_dt_id = "DMTP01"
        lstDto.usr_grp_cd = userInfo.usr_grp_cd
        lstDto.reg_id = userInfo.usr_id

        val result = sysSettingDao.insertSetLst(lstDto)

        return statusMap
    }

    override fun isExistMailAddress(lstDto: Tblmi_set_lstDto): Map<String, Any> {

        val statusMap: MutableMap<String, Any> = HashMap();

        lstDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        lstDto.list_tp_id = "CH01"
        lstDto.list_dt_id = "DMTP01"

        val cntResult = sysSettingDao.isExistAddress(lstDto)

        statusMap["status"] = cntResult <= 0

        return statusMap
    }

    override fun isExistMailAddressModify(lstDto: Tblmi_set_lstDto): Map<String, Any> {

        val statusMap: MutableMap<String, Any> = HashMap();

        lstDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        lstDto.list_tp_id = "CH01"
        lstDto.list_dt_id = "DMTP01"

        val cntResult = sysSettingDao.isExistModifyAddress(lstDto)

        statusMap["status"] = cntResult <= 0

        return statusMap
    }

    override fun deleteSetLst(dto: Tblmi_set_lstDto): Map<String, Any> {

        val statusMap: MutableMap<String, Any> = HashMap();
        dto.upd_id = UsefulUtils.sessionUser().upd_id

        sysSettingDao.deleteSetLst(dto);
        statusMap["status"] = true
        return statusMap
    }

    /**
     *  기본 발신번호 서비스 로직은 seq로 가져오므로, 하나의 서비스를 공유한다
     */

    override fun changeDefaultLst(dto: Tblmi_set_lstDto): Map<String, Any> {
        val statusMap: MutableMap<String, Any> = HashMap();
        val userInfo = UsefulUtils.sessionUser()
        val setLstDto = dto as SetLst_searchDto

        // 기존 Lst 값 def_yn 변경
        val defaultLstDto = Tblmi_set_lstDto()
        defaultLstDto.seq = setLstDto.defaultMailNo
        defaultLstDto.usr_grp_cd = userInfo.usr_grp_cd
        defaultLstDto.def_yn = "N"

        sysSettingDao.updateDefultSender(defaultLstDto)

        // 새로운 Lst 값 def_yn 설정
        val changeLstDto = Tblmi_set_lstDto()
        changeLstDto.seq = setLstDto.changeMailNo
        changeLstDto.usr_grp_cd = userInfo.usr_grp_cd
        changeLstDto.def_yn = "Y"

        sysSettingDao.updateDefultSender(changeLstDto)

        statusMap["status"] = true
        return statusMap
    }

    /**
     *  기본 발신번호 서비스 로직은 seq로 가져오므로, 하나의 서비스를 공유한다
     */

    override fun detailLst(dto: Tblmi_set_lstDto): Map<String, Any> {
        val paramMap: MutableMap<String, Any> = HashMap();
        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        paramMap["data"] = sysSettingDao.getDetailLst(dto)
        return paramMap
    }

    override fun getSmsSettingList(dto: Tblmi_set_lstDto): Map<String, Any> {
        val map: MutableMap<String, Any> = HashMap()
        val searchDto = dto as SetLst_searchDto

        val pageNo = if (searchDto.pageNo == null) {
            1
        } else {
            searchDto.pageNo!!
        }

        if (searchDto.searchType == "list_nm") {
            searchDto.list_nm = searchDto.searchValue
        } else if (searchDto.searchType == "list_val") {
            searchDto.list_val = searchDto.searchValue
        } else if (searchDto.searchType == "use_yn") {
            searchDto.use_yn = searchDto.searchValue
        }

        searchDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        searchDto.list_tp_id = "CH02"
        searchDto.list_dt_id = "DMTP02"

        val paginationInfo: PaginationInfo = UsefulUtils.makePage(pageNo, 10, 10)

        searchDto.firstIndex = paginationInfo.firstRecordIndex
        searchDto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = sysSettingDao.getSmsSettingListCnt(searchDto)

        map["page"] = paginationInfo
        map["pageNo"] = paginationInfo.currentPageNo
        map["cnt"] = paginationInfo.totalRecordCount
        map["list"] = sysSettingDao.getSmsSettingList(searchDto);

        return map;
    }

    override fun insertSmsLst(lstDto: Tblmi_set_lstDto): Map<String, Any> {
        val userInfo = UsefulUtils.sessionUser()
        val statusMap: MutableMap<String, Any> = HashMap()

        lstDto.list_tp_id = "CH02"
        lstDto.list_dt_id = "DMTP02"
        lstDto.usr_grp_cd = userInfo.usr_grp_cd
        lstDto.reg_id = userInfo.usr_id

        val result = sysSettingDao.insertSetLst(lstDto)

        return statusMap
    }

    override fun isExistSmsAddress(lstDto: Tblmi_set_lstDto): Map<String, Any> {
        val statusMap: MutableMap<String, Any> = HashMap();

        lstDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        lstDto.list_tp_id = "CH02"
        lstDto.list_dt_id = "DMTP02"

        val cntResult = sysSettingDao.isExistAddress(lstDto)

        statusMap["status"] = cntResult <= 0

        return statusMap
    }

    override fun isExistSmsAddressModify(lstDto: Tblmi_set_lstDto): Map<String, Any> {
        val statusMap: MutableMap<String, Any> = HashMap();

        lstDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        lstDto.list_tp_id = "CH02"
        lstDto.list_dt_id = "DMTP02"

        val cntResult = sysSettingDao.isExistModifyAddress(lstDto)

        statusMap["status"] = cntResult <= 0

        return statusMap
    }

    /**
     * 메일, 문자 정보 수정하기 (SEQ를 기준으로 한다)
     */
    override fun updateLst(dto: Tblmi_set_lstDto): Map<String, Any> {

        val statusMap: MutableMap<String, Any> = HashMap()

        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        sysSettingDao.updateSetLst(dto)

        statusMap["status"] = true
        return statusMap
    }


    override fun selectTestGrpLst(dto: Tblmite_target_grp): Map<String, Any> {

        val paramMap: MutableMap<String, Any> = HashMap()
        val testGrpDto = dto as TestGroup_SearchDto

        if (testGrpDto.pageNo == null) {
            testGrpDto.pageNo = 1
        }

        if(testGrpDto.searchType == "grp_nm"){
            testGrpDto.grp_nm = testGrpDto.searchValue
        } else if (testGrpDto.searchType == "use_yn"){
            testGrpDto.use_yn = testGrpDto.searchValue
        }

        testGrpDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val paginationInfo: PaginationInfo = UsefulUtils.makePage(testGrpDto.pageNo, 10, 10)

        testGrpDto.firstIndex = paginationInfo.firstRecordIndex
        testGrpDto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = sysSettingDao.selectTestGrpLstCnt(testGrpDto)

        paramMap["page"] = paginationInfo
        paramMap["pageNo"] = paginationInfo.currentPageNo
        paramMap["list"] = sysSettingDao.selectTestGrpLst(testGrpDto)
        paramMap["listCnt"] = paginationInfo.totalRecordCount

        return paramMap
    }

    override fun updateTestGrpYn(dto: Tblmite_target_grp): Map<String, Any> {

        val statusMap : MutableMap<String,Any> = HashMap()
        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        dto.upd_id = UsefulUtils.sessionUser().upd_id

        if(dto.use_yn == "Y"){
            dto.use_yn = "N"
        }else if(dto.use_yn == "N"){
            dto.use_yn = "Y"
        }
        sysSettingDao.updateTestGrp(dto)

        statusMap["status"] = true
        return statusMap
    }

    override fun deleteTestGrp(dto: Tblmite_target_grp): Map<String, Any> {
        val statusMap : MutableMap<String,Any> = HashMap()
        dto.upd_id = UsefulUtils.sessionUser().usr_id
        dto.status = '3'    // 삭제 처리

        sysSettingDao.updateTestGrp(dto)

        statusMap["status"] = true
        return statusMap
    }

    override fun detailTestGrp(dto: Tblmite_target_grp): Map<String, Any> {
        val paramMap : MutableMap<String,Any> = HashMap();
        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        val detailTestGrpDto = sysSettingDao.detailTestGrp(dto)
        paramMap["grpNm"] =  detailTestGrpDto.grp_nm.toString()
        paramMap["grpNo"] = detailTestGrpDto.seq.toString()
        paramMap["grpCnt"] = detailTestGrpDto.grp_cnt.toString()
        paramMap["edmCnt"] = detailTestGrpDto.edm_cnt.toString()
        paramMap["mobCnt"] = detailTestGrpDto.mob_cnt.toString()

        return paramMap
    }

    override fun selectTestTargetLst(dto: Tblmite_target_lst): Map<String, Any> {

        val testTargetDto = dto as TestTarget_SearchDto
        val paramMap: MutableMap<String, Any> = HashMap()
        val paginationInfo: PaginationInfo = UsefulUtils.makePage(testTargetDto.pageNo, 10, 10)

        //logger.error("testTarget : " + testTargetDto);

        if(testTargetDto.searchType == "usr_id") {
            testTargetDto.usr_id = testTargetDto.searchValue
        } else if (testTargetDto.searchType == "usr_nm") {
            testTargetDto.usr_nm = testTargetDto.searchValue
        } else if (testTargetDto.searchType == "usr_mob") {
            testTargetDto.usr_mob = testTargetDto.searchValue
        } else if (testTargetDto.searchType == "usr_edm") {
            testTargetDto.usr_edm = testTargetDto.searchValue
        } else if (testTargetDto.searchType == "use_yn") {
            testTargetDto.use_yn = testTargetDto.searchValue
        } else if(testTargetDto.searchType == "usr_etc1") {
            testTargetDto.usr_etc1 = testTargetDto.searchValue
        } else if(testTargetDto.searchType == "usr_etc2") {
            testTargetDto.usr_etc2 = testTargetDto.searchValue
        } else if(testTargetDto.searchType == "usr_etc3") {
            testTargetDto.usr_etc3 = testTargetDto.searchValue
        } else if(testTargetDto.searchType == "usr_etc4") {
            testTargetDto.usr_etc4 = testTargetDto.searchValue
        } else if(testTargetDto.searchType == "usr_etc5") {
            testTargetDto.usr_etc5 = testTargetDto.searchValue
        } else if(testTargetDto.searchType == "usr_etc6") {
            testTargetDto.usr_etc6 = testTargetDto.searchValue
        } else if(testTargetDto.searchType == "usr_etc7") {
            testTargetDto.usr_etc7 = testTargetDto.searchValue
        } else if(testTargetDto.searchType == "usr_etc8") {
            testTargetDto.usr_etc8 = testTargetDto.searchValue
        } else if(testTargetDto.searchType == "usr_etc9") {
            testTargetDto.usr_etc9 = testTargetDto.searchValue
        } else if(testTargetDto.searchType == "usr_etc10") {
            testTargetDto.usr_etc10 = testTargetDto.searchValue
        }

        testTargetDto.firstIndex = paginationInfo.firstRecordIndex
        testTargetDto.recordCountPerPage = paginationInfo.recordCountPerPage
        //paginationInfo.totalRecordCount = sysSettingDao.selectTestTargetLstCnt(testTargetDto)

        val cntDto = sysSettingDao.selectTestTargetLstCnt(testTargetDto)
        paginationInfo.totalRecordCount = cntDto.grp_cnt!!.toInt()

        paramMap["page"] = paginationInfo
        paramMap["pageNo"] = paginationInfo.currentPageNo
        paramMap["list"] = sysSettingDao.selectTestTargetLst(testTargetDto)
        paramMap["listCnt"] = paginationInfo.totalRecordCount
        paramMap["grpCnt"] = cntDto.grp_cnt.toString()
        paramMap["mobCnt"] = cntDto.mob_cnt.toString()
        paramMap["edmCnt"] = cntDto.edm_cnt.toString()

        return paramMap;
    }

    override fun importTestGroup(file: MultipartFile): Map<String, Any> {
        val statusMap : MutableMap<String,Any> = HashMap<String, Any>()
        //val userInfo = UsefulUtils.sessionUser()
        val fileMime = CommonUtils.checkEecelMime(file)

        if(fileMime.isNullOrEmpty()) {
            statusMap["result"] = false
            statusMap["message"] = "xlsx, xls 파일 형식만 업로드 가능합니다"
            return statusMap
        } else {
            var targetCnt = 0
            var errorCnt = 0
            var errorMessage = ""
            var idx = 0
            var totalCnt = 0
            var emailCnt = 0;
            var mobileCnt = 0;

            val testTargetLst: MutableList<Tblmite_target_lst> = ArrayList<Tblmite_target_lst>()
            val testTargetErrorLst : MutableList<Tblmite_target_lst> = ArrayList<Tblmite_target_lst>()
            val duplicateEmailLst : MutableList<String> = ArrayList<String>()
            val duplicateMobileLst : MutableList<String> = ArrayList<String>()

            var workbook: Workbook? = null

            try{
                // StreamingReader 사용 으로 OOM 방지
                workbook = StreamingReader.builder()
                        .rowCacheSize(100)
                        .bufferSize(4096)
                        .open(file.inputStream)

                val sheet = workbook.getSheetAt(0)

                for(row in sheet!!) {
                    if(idx > 0) {
                        if (row != null) {

                            var errorResult = 0;
                            val dto = Tblmite_target_lst()
                            dto.usr_id = CommonUtils.Excel_cell_value(row.getCell(0))?.trim()
                            dto.usr_nm = CommonUtils.Excel_cell_value(row.getCell(1))?.trim()
                            dto.usr_edm = CommonUtils.Excel_cell_value(row.getCell(2))?.trim()
                            dto.usr_mob = CommonUtils.Excel_cell_value(row.getCell(3))?.trim()
                            dto.use_yn = CommonUtils.Excel_cell_value(row.getCell(4))?.trim()
                            dto.usr_etc1 = CommonUtils.Excel_cell_value(row.getCell(5))?.trim()
                            dto.usr_etc2 = CommonUtils.Excel_cell_value(row.getCell(6))?.trim()
                            dto.usr_etc3 = CommonUtils.Excel_cell_value(row.getCell(7))?.trim()
                            dto.usr_etc4 = CommonUtils.Excel_cell_value(row.getCell(8))?.trim()
                            dto.usr_etc5 = CommonUtils.Excel_cell_value(row.getCell(9))?.trim()
                            dto.usr_etc6 = CommonUtils.Excel_cell_value(row.getCell(10))?.trim()
                            dto.usr_etc7 = CommonUtils.Excel_cell_value(row.getCell(11))?.trim()
                            dto.usr_etc8 = CommonUtils.Excel_cell_value(row.getCell(12))?.trim()
                            dto.usr_etc9 = CommonUtils.Excel_cell_value(row.getCell(13))?.trim()
                            dto.usr_etc10 = CommonUtils.Excel_cell_value(row.getCell(14))?.trim()


                            if (dto.usr_id == null || !Pattern.matches("^[a-zA-Z0-9가-힣\\s]*$", dto.usr_id)) {
                                /**
                                 * 1. 회원 번호 null은 허용하지 않는다
                                 * 2. 회원 번호에 숫자, 공백, 알파벳, 한글 만 허용한다
                                 */
                                errorCnt++;
                                errorResult++;
                                //errorMessage = (idx + 1).toString() + " 행의 1번째 열 회원 번호를 확인해 주세요"
                                errorMessage =  "회원 번호를 확인해 주세요"
                                //break;
                            }

                            /*if (dto.usr_nm == null || !Pattern.matches("^[a-zA-Z0-9가-힣\\s!@()/_,*]*$", dto.usr_nm)) {
                                *//**
                                 * 1. 회원 명은 알파벳 ,숫자 ,공백,숫자, 한글 만 허용 한다
                                 * 2. 회원명에 null은 허옹햐지 않는다.
                                 *//*
                                errorCnt++;
                                errorResult++;
                                //errorMessage = (idx + 1).toString() + " 행의 2번째 열 회원명을 확인해 주세요"
                                errorMessage = "회원 명을 확인해 주세요"
                                //break;
                            }*/

                            if (dto.usr_nm == null) {
                                /**
                                 * 회원명에 null을 허용하지 않는다
                                 */
                                errorCnt++;
                                errorResult++;
                                //errorMessage = (idx + 1).toString() + " 행의 2번째 열 회원명을 확인해 주세요"
                                errorMessage = "회원 명을 확인해 주세요"
                                //break;
                            }

                            if(!CommonUtils.isEmptyObject(dto.use_yn) && !dto.use_yn.equals("Y") && !dto.use_yn.equals("N")) {
                                errorCnt++
                                errorResult++
                                //errorMessage = (idx + 1).toString() + " 행의 5번째 열 사용 여부 값을 확인해 주세요"
                                errorMessage = "사용 여부 값을 확인해 주세요 (Y,N만 허용)"
                            }

                            if(CommonUtils.isEmptyObject(dto.usr_mob) || CommonUtils.isEmptyObject(dto.usr_edm)) {
                                errorCnt ++;
                                errorResult++;
                                errorMessage = "이메일, 핸드폰 번호에 데이터를 입력해주세요"
                                //errorMessage += (idx + 1).toString() + " 행에 이메일, 핸드폰 번호에 데이터를 입력 해주세요"
                                //break;
                            }

                            // 이메일 카운트 수 증가
                            if(!CommonUtils.isEmptyObject(dto.usr_edm)) {
                                if(UsefulUtils.isCheckEmail(dto.usr_edm!!)){
                                    duplicateEmailLst.add(dto.usr_edm!!)
                                    emailCnt++
                                }
                            }

                            // 모바일 카운트 수 증가
                            if(!CommonUtils.isEmptyObject(dto.usr_mob)) {
                                if(UsefulUtils.isCheckPhoneNumber(dto.usr_mob!!)){
                                    duplicateMobileLst.add(dto.usr_mob!!)
                                    mobileCnt++
                                }
                            }

                            /*if(idx > 100 ) {
                                break;
                            }*/

                            if (idx > 100) {
                                statusMap["status"] = false
                                statusMap["message"] = "100개 이상의 테스트 그룹은 등록 할 수 없습니다"
                                workbook?.close()
                                return statusMap
                            }

                            if (idx <= 5 && errorResult == 0) {
                                // 에러가 아닌 경우 화면에 최대 5개의 리스트 만 뿌려 준다
                                testTargetLst.add(dto)
                            } else if(errorResult > 0) {
                                // 에러인 경우 에러 리스트 에 담는다.
                                //logger.error("에러 리스트 존재 ");
                                testTargetErrorLst.add(dto)
                            }
                        }
                    }
                    idx++;
                }

                if (errorCnt > 0) {
                    // 100개 미만에서 오류 발생시 알림 처리
                    statusMap["status"] = false
                    statusMap["message"] = errorMessage
                    statusMap["errorList"] = testTargetErrorLst
                    //logger.error("testTargetErrorLst : " + testTargetErrorLst);
                    return statusMap;
                }

            } catch (e: Exception) {
                logger.error(e.toString())
                statusMap["status"] = false
                statusMap["message"] = "엑셀 파일에 오류가 존재합니다. 관리자에게 문의 하세요"
                return statusMap
            } finally {
                workbook?.close()
            }

           // logger.error("email duplicate cnt : "  + duplicateMobileOrEmailCnt(duplicateEmailLst));
           // logger.error("mobile duplicate cnt : "  + duplicateMobileOrEmailCnt(duplicateMobileLst));

            statusMap["list"] = testTargetLst
            statusMap["emailCnt"] = emailCnt
            statusMap["emailDupliCnt"] = duplicateMobileOrEmailCnt(duplicateEmailLst)
            statusMap["mobileCnt"] = mobileCnt
            statusMap["mobileDupliCnt"] = duplicateMobileOrEmailCnt(duplicateMobileLst)
            statusMap["totalCnt"] = emailCnt + mobileCnt
            statusMap["status"] = true
            statusMap["message"] = "테스트 그룹 Import 완료"

        }
        return statusMap
    }


    /**
     *
     *  중복 개수 카운트 하기
     */

    private fun duplicateMobileOrEmailCnt(list : MutableList<String>) : Int  {
        val duplicateCntMap : MutableMap<String,Int> = HashMap<String,Int>()
        val len = list.size

        for(i in 0 until len) {
            if(duplicateCntMap.containsKey(list[i])){
                // HashMap 내부에 이미 키가 존재한다면 cnt 증가
                duplicateCntMap[list[i]] = duplicateCntMap[list[i]]!!.plus(1)
            } else {
                duplicateCntMap[list[i]] = 1
            }
        }
        var sum = 0;
        var vCollection = duplicateCntMap.values
        var iterator = vCollection.iterator()

        while(iterator.hasNext()){
            val result = iterator.next();
            // 중복 카운트 가 2개 이상 일때만 더해준다
            if(result >= 2) {
                sum += result
            }
        }
        return sum;
    }

    /**
     *  테스트 그룹과, 테스트 타겟 그룹 리스트를 저장한다.
     */

    override fun insertTestGroup(dto: Tblmite_target_grp): Map<String, Any> {

        val userInfo : Tblmi_usrDto = UsefulUtils.sessionUser()
        val statusMap : MutableMap<String,Any> = HashMap<String,Any>();
        val testSearchDto = dto as TestGroup_SearchDto

        //logger.error("testGrpDto : " + testSearchDto.toString())

        // 초기 워킹 로그 저장 하기
        val workDto = workService.makeWorkHistory("TEST_GROUP","0","테스트 그룹 저장중 입니다");
        workService.insertWorkHistory(workDto)

        val workSeq = workDto.seq

        // 테스트 그룹 저장
        val testGrpDto = Tblmite_target_grp()
        testGrpDto.grp_nm = testSearchDto.grp_nm
        testGrpDto.usr_grp_cd = userInfo.usr_grp_cd
        testGrpDto.status = '0' // 초기 상태 값 ( 0 : 저장중 , 1: 저장 완료 )
        testGrpDto.reg_id = userInfo.usr_id

        // 테스트 그룹 저장 하기
        sysSettingDao.insertTestGrp(testGrpDto)

        val excelfile = testSearchDto?.excelFile
        val fileMime = CommonUtils.checkEecelMime(excelfile)

        if(fileMime.isNullOrEmpty()) {
            // 저장시 파일 상태를 체크해서 상태를 변경해 준다
            logger.error("파일 형식이 맞지 않습 니다")

            val failFileWorkDto = Tblmi_workDto()
            failFileWorkDto.seq = workDto.seq
            failFileWorkDto.upd_id = userInfo.upd_id
            failFileWorkDto.work_stat = "2"
            failFileWorkDto.work_msg = "'xlsx', 'xls' 파일 형식만 업로드 가능 합니다."
            workService.updateWorkHistory(failFileWorkDto)

            // 테스트 그룹 상태 업데이트
            val updTestGrpDto = Tblmite_target_grp()
            updTestGrpDto.seq = testGrpDto.seq
            updTestGrpDto.upd_id = testGrpDto.upd_id
            updTestGrpDto.status = '2'
            sysSettingDao.updateTestGrp(updTestGrpDto)

        } else{
            var idx = 0;
            var cnt = 0;
            var errorCnt = 0;
            var errorMessage = ""
            var emailCnt = 0;
            var mobileCnt = 0;
            var workbook: Workbook? = null

            try{

                var testTargetLst : MutableList<Tblmite_target_lst> = ArrayList<Tblmite_target_lst>()

                // Apache Poi OOM을 방지하기 위한 StreamingReader
                workbook = StreamingReader.builder()
                        .rowCacheSize(100)
                        .bufferSize(4096)
                        .open(excelfile?.inputStream)

                val sheet = workbook.getSheetAt(0)

                for(row in sheet!!) {
                    if(row != null) {
                        if(idx > 0 ){
                            val dto = Tblmite_target_lst()

                            dto.grp_no = testGrpDto.seq // 그룹 번호 지정
                            dto.reg_id = testGrpDto.reg_id
                            dto.send_yn = "Y"
                            dto.usr_eyn = "Y"
                            dto.usr_myn = "Y"
                            dto.use_yn = "Y"
                            dto.del_yn = "N"

                            dto.usr_id = CommonUtils.Excel_cell_value(row.getCell(0))?.trim()
                            if (dto.usr_id == null || !Pattern.matches("^[a-zA-Z0-9가-힣\\s]*$", dto.usr_id)) {
                                /**
                                 * 1. 회원 번호 null은 허용하지 않는다
                                 * 2. 회원 번호에 숫자, 공백, 알파벳, 한글 만 허용한다
                                 */
                                errorCnt++;
                                errorMessage = (idx + 1).toString() + " 행의 1번째 열 회원번호를 확인해 주세요"
                            }

                            dto.usr_nm = CommonUtils.Excel_cell_value(row.getCell(1))?.trim()
                            /*if (dto.usr_nm == null || !Pattern.matches("^[a-zA-Z0-9가-힣\\s!@()/_,*]*$", dto.usr_nm)) {
                                *//**
                                 * 1. 회원 명은 알파벳 ,숫자 ,공백,숫자, 한글 만 허용 한다
                                 * 2. 회원명에 null은 허옹햐지 않는다.
                                 *//*
                                errorCnt++;
                                errorMessage = (idx + 1).toString() + " 행의 2번째 열 회원명을 확인해 주세요"
                                break;
                            }*/
                            if (dto.usr_nm == null) {
                                /**
                                 * 회원명에 null은 허용하지 않는다
                                 */
                                errorCnt++;
                                errorMessage = (idx + 1).toString() + " 행의 2번째 열 회원명을 확인해 주세요"
                                break;
                            }

                            dto.usr_edm = CommonUtils.Excel_cell_value(row.getCell(2))?.trim()
                            if (!CommonUtils.isEmptyObject(dto.usr_edm) && !UsefulUtils.isCheckEmail(dto.usr_edm!!)) {
                                // 이메일에 null 값이 들어갈 수 있다.
                                errorCnt++;
                                errorMessage += (idx + 1).toString() + " 행의 이메일을 확인해 주세요"
                            }

                            /*dto.usr_eyn = CommonUtils.Excel_cell_value(row.getCell(3))?.trim()
                            if (!CommonUtils.isEmptyObject(dto.usr_eyn) && !dto.usr_eyn.equals("Y") && !dto.usr_eyn.equals("N")) {
                                // M , F 이외의 값이 들어온다면 오류
                                errorCnt++;
                                errorMessage += (idx + 1).toString() + " 행의 이메일 수신 동의 값을 Y 또는 N으로 입력해 주세요"
                            }*/

                            dto.usr_mob = CommonUtils.Excel_cell_value(row.getCell(3))?.trim()?.replace("-", "")
                            if (!CommonUtils.isEmptyObject(dto.usr_mob) && !UsefulUtils.isCheckPhoneNumber(dto.usr_mob!!)) {
                                // 핸드폰 번호에 null 값이 들어갈 수 있다.
                                errorCnt++;
                                errorMessage += (idx + 1).toString() + " 행의 핸드폰 번호를 확인해 주세요"
                            }

                            if(CommonUtils.isEmptyObject(dto.usr_mob) || CommonUtils.isEmptyObject(dto.usr_edm)) {
                                errorCnt ++;
                                errorMessage += (idx + 1).toString() + " 행에 이메일, 핸드폰 번호에 데이터를 입력 해주세요"
                            }

                            /*dto.usr_myn = CommonUtils.Excel_cell_value(row.getCell(5))?.trim()
                            if (!CommonUtils.isEmptyObject(dto.usr_myn) && !dto.usr_myn.equals("Y") && !dto.usr_myn.equals("N")) {
                                // M , F 이외의 값이 들어온다면 오류
                                errorCnt++;
                                errorMessage += (idx + 1).toString() + " 행의 모바일 수신 동의 값을 Y 또는 N으로 입력해 주세요"
                            }*/

                            dto.use_yn = CommonUtils.Excel_cell_value(row.getCell(4))?.trim()
                            if(!CommonUtils.isEmptyObject(dto.use_yn) && !dto.use_yn.equals("Y") && !dto.use_yn.equals("N")) {
                                errorCnt++
                                errorMessage = (idx + 1).toString() + " 행의 사용 여부 값을 확인해 주세요"

                            }

                            // 이메일 카운트 수 증가
                            if(!CommonUtils.isEmptyObject(dto.usr_edm)) {
                                if(UsefulUtils.isCheckEmail(dto.usr_edm!!)){
                                    emailCnt++
                                }
                            }

                            // 모바일 카운트 수 증가
                            if(!CommonUtils.isEmptyObject(dto.usr_mob)) {
                                if(UsefulUtils.isCheckPhoneNumber(dto.usr_mob!!)){
                                    mobileCnt++
                                }
                            }

                            dto.usr_etc1 = CommonUtils.Excel_cell_value(row.getCell(5))?.trim()
                            dto.usr_etc2 = CommonUtils.Excel_cell_value(row.getCell(6))?.trim()
                            dto.usr_etc3 = CommonUtils.Excel_cell_value(row.getCell(7))?.trim()
                            dto.usr_etc4 = CommonUtils.Excel_cell_value(row.getCell(8))?.trim()
                            dto.usr_etc5 = CommonUtils.Excel_cell_value(row.getCell(9))?.trim()
                            dto.usr_etc6 = CommonUtils.Excel_cell_value(row.getCell(10))?.trim()
                            dto.usr_etc7 = CommonUtils.Excel_cell_value(row.getCell(11))?.trim()
                            dto.usr_etc8 = CommonUtils.Excel_cell_value(row.getCell(12))?.trim()
                            dto.usr_etc9 = CommonUtils.Excel_cell_value(row.getCell(13))?.trim()
                            dto.usr_etc10 = CommonUtils.Excel_cell_value(row.getCell(14))?.trim()

                            testTargetLst.add(dto)
                            cnt ++
                        }
                    }
                    idx++
                }

                if(errorCnt > 0) {

                    // 에러가 있는 target Lst 테이블을 전부 삭제 한다.
                    val tgr_lst_dto = Tblmite_target_lst()
                    tgr_lst_dto.grp_no = testGrpDto.seq
                    sysSettingDao.exceptionDeleteTarget(tgr_lst_dto)

                    // 에러가 1개라도 존재 하면, 존재 하는 에러를 cnt 한 후 에러 상태를 업데이트 한다
                    val failWorkDto = Tblmi_workDto()
                    failWorkDto.seq = workDto.seq
                    failWorkDto.upd_id = testGrpDto.upd_id
                    failWorkDto.work_stat = "2"
                    failWorkDto.work_msg = "파일명: " + testSearchDto.excelFile?.originalFilename + "<br>" + "그룹 명 : " + testSearchDto.grp_nm +  "에러 내용 : " + errorMessage
                    workService.updateWorkHistory(failWorkDto)

                    // 테스트 그룹 오류 Update
                    val testGrpDtoIn = Tblmite_target_grp()
                    testGrpDtoIn.seq = testGrpDto.seq
                    testGrpDtoIn.upd_id = testGrpDto.upd_id
                    testGrpDtoIn.status = '2'
                    sysSettingDao.updateTestGrp(testGrpDtoIn)

                } else {

                    // 타겟 저장 하기
                    sysSettingDao.insertTestTarget(testTargetLst)

                    // 에러가 존재하지 않는 정상 파일일 경우 상태 업데 이트
                    val successWorkDto = Tblmi_workDto()
                    successWorkDto.seq = workDto.seq
                    successWorkDto.upd_id = testGrpDto.upd_id
                    successWorkDto.work_stat = "1"
                    successWorkDto.work_msg = " 파일 명 " + testSearchDto.excelFile?.originalFilename + "<br>" + "그룹 명 : " + testSearchDto.grp_nm + "<br>" + "생성 결과: " + (idx-1).toString() + "명의 테스트 타겟이 입력되었습니다."
                    workService.updateWorkHistory(successWorkDto)

                    // 테스트 그룹 정상 Update
                    val testGrpDtoIn = Tblmite_target_grp()
                    testGrpDtoIn.seq = testGrpDto.seq
                    testGrpDtoIn.upd_id = testGrpDto.upd_id
                    testGrpDtoIn.grp_cnt = idx - 1
                    testGrpDtoIn.edm_cnt = emailCnt
                    testGrpDtoIn.mob_cnt = mobileCnt
                    testGrpDtoIn.status = '1'

                    sysSettingDao.updateTestGrp(testGrpDtoIn)
                    statusMap["status"] = true
                }

            }catch (e : Exception){
                logger.error("Error " , e)

                // 에러가 있는 target Lst 테이블을 전부 삭제 한다.
                val tgr_lst_dto = Tblmite_target_lst()
                tgr_lst_dto.grp_no = testGrpDto.seq
                sysSettingDao.exceptionDeleteTarget(tgr_lst_dto)

                // 오류 상태 저장 하기
                val failWorkDto = Tblmi_workDto()
                failWorkDto.seq = testGrpDto.seq
                failWorkDto.upd_id = testGrpDto.reg_id
                failWorkDto.work_stat = "2"
                failWorkDto.work_msg = "파일명 : "  + testSearchDto.excelFile?.originalFilename +
                            "<br>" + "그룹 명: " + testSearchDto.grp_nm + "<br>" + "서버 오류 발생"

                workService.updateWorkHistory(failWorkDto)

                // 테스트 그룹 오류 Update
                val testGrpDtoIn = Tblmite_target_grp()
                testGrpDtoIn.seq = testGrpDto.seq
                testGrpDtoIn.upd_id = testGrpDto.upd_id
                testGrpDtoIn.status = '2'
                sysSettingDao.updateTestGrp(testGrpDtoIn)

            } finally {
                workbook?.close()
            }
        }

        return statusMap
    }

    override fun deleteTestTarget(dto: Tblmite_target_lst): Map<String, Any> {
        val statusMap : MutableMap<String,Any> = HashMap()
        dto.upd_id = UsefulUtils.sessionUser().usr_id
        dto.del_yn = "Y"    // 삭제 처리

        sysSettingDao.updateTestTarget(dto)

        statusMap["status"] = true
        return statusMap
    }

    override fun updateTestTargetYn(dto: Tblmite_target_lst): Map<String, Any> {

        val statusMap : MutableMap<String,Any> = HashMap<String,Any>();
        val testTgrDto = dto as TestTarget_SearchDto

        if(testTgrDto.use_yn == "Y") {
            testTgrDto.use_yn = "N"
        } else if (testTgrDto.use_yn == "N") {
            testTgrDto.use_yn = "Y"
        }

        testTgrDto.upd_id = UsefulUtils.sessionUser().usr_id

        sysSettingDao.updateTestTarget(testTgrDto)
        statusMap["status"] = true
        return statusMap
    }

    override fun insertTargetLstOne(dto: Tblmite_target_lst): Map<String, Any> {
        val statusMap : MutableMap<String,Any> = HashMap<String,Any>();

        dto.reg_id = UsefulUtils.sessionUser().usr_id
        dto.usr_myn = "Y"
        dto.usr_eyn = "Y"
        dto.send_yn = "Y"
        dto.del_yn = "N"

        if(dto.usr_mob != null) {
            dto.usr_mob = dto.usr_mob?.trim()?.replace("-","")
        }

        // 저장 하기
        sysSettingDao.insertTargetLstOne(dto)

        // 타겟 수 가져오기
        val cntMap = selectTestTargetMobEdmCnt(dto)

        statusMap["status"] = true
        statusMap["edmCnt"] = cntMap["edmCnt"].toString()
        statusMap["mobCnt"] = cntMap["mobCnt"].toString()
        statusMap["totalCnt"] = cntMap["totalCnt"].toString()

        val grpDto = Tblmite_target_grp()
        grpDto.seq = dto.grp_no
        grpDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        grpDto.edm_cnt = cntMap["edmCnt"].toString().toInt()
        grpDto.mob_cnt = cntMap["mobCnt"].toString().toInt()
        grpDto.grp_cnt = cntMap["totalCnt"].toString().toInt()

        sysSettingDao.updateTestGrp(grpDto)

        return statusMap
    }

    override fun detailTestTarget(dto: Tblmite_target_lst): Map<String, Any> {
        val paramMap : MutableMap<String,Any> = HashMap();
        val detailTestTargetDto = sysSettingDao.detailTestTarget(dto)

        paramMap["grp_no"] =  detailTestTargetDto.grp_no.toString()
        paramMap["usr_id"] =  detailTestTargetDto.usr_id.toString()
        paramMap["usr_nm"] =  detailTestTargetDto.usr_nm.toString()
        paramMap["usr_edm"] =  detailTestTargetDto.usr_edm.toString()
        paramMap["usr_eyn"] =  detailTestTargetDto.usr_eyn.toString()
        paramMap["usr_mob"] =  detailTestTargetDto.usr_mob.toString()
        paramMap["usr_myn"] =  detailTestTargetDto.usr_myn.toString()
        paramMap["use_yn"] = detailTestTargetDto.use_yn.toString()
        paramMap["usr_etc1"] =  detailTestTargetDto.usr_etc1.toString()
        paramMap["usr_etc2"] =  detailTestTargetDto.usr_etc2.toString()
        paramMap["usr_etc3"] =  detailTestTargetDto.usr_etc3.toString()
        paramMap["usr_etc4"] =  detailTestTargetDto.usr_etc4.toString()
        paramMap["usr_etc5"] =  detailTestTargetDto.usr_etc5.toString()

        return paramMap
    }

    override fun updateTestTargetLstOne(dto: Tblmite_target_lst): Map<String, Any> {
        val statusMap : MutableMap<String,Any> = HashMap();
        val cntMap = selectTestTargetMobEdmCnt(dto)

        if(dto.usr_mob != null) {
            dto.usr_mob = dto.usr_mob?.trim()?.replace("-","")
        }

        sysSettingDao.updateTestTargetLstOne(dto)

        statusMap["status"] = true
        statusMap["edmCnt"] = cntMap["edmCnt"].toString()
        statusMap["mobCnt"] = cntMap["mobCnt"].toString()
        statusMap["totalCnt"] = cntMap["totalCnt"].toString()

        val grpDto = Tblmite_target_grp()
        grpDto.seq = dto.grp_no
        grpDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        grpDto.edm_cnt = cntMap["edmCnt"].toString().toInt()
        grpDto.mob_cnt = cntMap["mobCnt"].toString().toInt()
        grpDto.grp_cnt = cntMap["totalCnt"].toString().toInt()

        sysSettingDao.updateTestGrp(grpDto)

        return statusMap
    }

    override fun selectTestTargetMobEdmCnt(dto: Tblmite_target_lst): Map<String, Any> {
        val cntMap : MutableMap<String,Any> = HashMap();
        val testGrpDto = sysSettingDao.selectTestTargetMobEdmCnt(dto)

        cntMap["edmCnt"] = testGrpDto.edm_cnt.toString()
        cntMap["mobCnt"] = testGrpDto.mob_cnt.toString()
        cntMap["totalCnt"] = testGrpDto.grp_cnt.toString()

        //logger.error("cntMap: " + cntMap.toString())

        return cntMap
    }
}
