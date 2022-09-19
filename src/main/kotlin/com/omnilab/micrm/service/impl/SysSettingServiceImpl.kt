package com.omnilab.micrm.service.impl

import com.omnilab.micrm.common.FileUploadUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.SalesforceDto
import com.omnilab.micrm.model.SetLst_searchDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.repository.MemberDao
import com.omnilab.micrm.repository.SalesforceDao
import com.omnilab.micrm.repository.SysSettingDao
import com.omnilab.micrm.service.SysSettingService
import com.omnilab.micrm.service.WorkService
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import java.text.SimpleDateFormat
import java.util.*


@Service("SysSettingServiceImpl")

class SysSettingServiceImpl : SysSettingService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Value("\${upload.src}")
    private val filePath: String? = null

    @Autowired
    lateinit var sysSettingDao: SysSettingDao;

    @Autowired
    @Qualifier("WorkServiceImpl")
    private lateinit var workService: WorkService

    @Autowired
    @Qualifier("MemberDaoImpl")
    private lateinit var memberDao: MemberDao

    @Autowired
    private lateinit var salesforceDao: SalesforceDao

    @Autowired
    lateinit var fileUpload: FileUploadUtils;


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

    override fun getDBValue(): MutableList<SalesforceDto> {
        /*//그룹 코드에 맞는 table ID 가져오기 (tblmi_tbl_mst)
        val tblmstDto: Tblmi_tbl_mstDto = Tblmi_tbl_mstDto()
        val map: MutableMap<String, Any> = HashMap<String, Any>()
        tblmstDto.tbl_grp = UsefulUtils.sessionUser().usr_grp_cd
        val resultTblmst = memberDao.getTblmimst(tblmstDto)
        //사용자 화면에서 보여지는 column 명칭 가져오기
        val columnNm: MutableList<String> = java.util.ArrayList<String>()
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

        map["columnNm"] = columnNm
        map["columnValue"] = columnValue*/
        val userInfo = UsefulUtils.sessionUser()
        var dto : SalesforceDto = SalesforceDto()
        dto.list_tp_id = "CH03"
        dto.list_dt_id = "SPTP01"
        dto.usr_grp_cd = userInfo.usr_grp_cd!!

        return salesforceDao.mappingLst(dto)
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

    override fun getMappingSettingList(dto: Tblmi_set_lstDto): Map<String, Any> {
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
        searchDto.list_tp_id = "CH03"
        searchDto.list_dt_id = "SPTP01"

        val paginationInfo: PaginationInfo = UsefulUtils.makePage(pageNo, 10, 10)

        searchDto.firstIndex = paginationInfo.firstRecordIndex
        searchDto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = sysSettingDao.getMappingSettingListCnt(searchDto)

        map["page"] = paginationInfo
        map["pageNo"] = paginationInfo.currentPageNo
        map["cnt"] = paginationInfo.totalRecordCount
        map["list"] = sysSettingDao.getMappingSettingList(searchDto);

        return map;
    }

    override fun insertMappingLst(lstDto: Tblmi_set_lstDto): Map<String, Any> {
        val userInfo = UsefulUtils.sessionUser()
        val statusMap: MutableMap<String, Any> = HashMap()

        lstDto.list_tp_id = "CH03"
        lstDto.list_dt_id = "SPTP01"
        lstDto.usr_grp_cd = userInfo.usr_grp_cd
        lstDto.reg_id = userInfo.usr_id

        val result = sysSettingDao.insertSetLst(lstDto)

        return statusMap
    }

    override fun isExistMapping(lstDto: Tblmi_set_lstDto): Map<String, Any> {
        val statusMap: MutableMap<String, Any> = HashMap();

        lstDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        lstDto.list_tp_id = "CH03"
        lstDto.list_dt_id = "SPTP01"

        val cntResult = sysSettingDao.isExistMapping(lstDto)

        statusMap["status"] = cntResult <= 0

        return statusMap
    }

    override fun isExistMappingModify(lstDto: Tblmi_set_lstDto): Map<String, Any> {
        val statusMap: MutableMap<String, Any> = HashMap();

        lstDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        lstDto.list_tp_id = "CH03"
        lstDto.list_dt_id = "SPTP01"

        val cntResult = sysSettingDao.isExistModifyMapping(lstDto)

        statusMap["status"] = cntResult <= 0

        return statusMap
    }

    override fun getKkoSettingList(dto: SetLst_searchDto): Map<String, Any> {
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
        searchDto.list_dt_id = "DMTP03"

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

}
