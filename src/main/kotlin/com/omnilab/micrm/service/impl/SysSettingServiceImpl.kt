package com.omnilab.micrm.service.impl

import com.google.gson.internal.LinkedTreeMap
import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.common.FileUploadUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.SalesforceDto
import com.omnilab.micrm.model.SetLst_searchDto
import com.omnilab.micrm.model.table.*
import com.omnilab.micrm.repository.MemberDao
import com.omnilab.micrm.repository.SalesforceDao
import com.omnilab.micrm.repository.SysSettingDao
import com.omnilab.micrm.service.KkoRestApiService
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
import kotlin.collections.HashMap


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

    @Autowired
    @Qualifier("KkoRestApiServiceImpl")
    lateinit var kkoRestApiService: KkoRestApiService


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
        val userInfo = UsefulUtils.sessionUser()
        val dto  = SalesforceDto()
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

        val cntResult = sysSettingDao.isExistSelLst(lstDto)

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

        sysSettingDao.updateSetDefultYn(defaultLstDto)

        // 새로운 Lst 값 def_yn 설정
        val changeLstDto = Tblmi_set_lstDto()
        changeLstDto.seq = setLstDto.changeMailNo
        changeLstDto.usr_grp_cd = userInfo.usr_grp_cd
        changeLstDto.def_yn = "Y"

        sysSettingDao.updateSetDefultYn(changeLstDto)

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
        paginationInfo.totalRecordCount = sysSettingDao.getSettingListCnt(searchDto)

        map["page"] = paginationInfo
        map["pageNo"] = paginationInfo.currentPageNo
        map["cnt"] = paginationInfo.totalRecordCount
        map["list"] = sysSettingDao.getSettingList(searchDto);

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

        val cntResult = sysSettingDao.isExistSelLst(lstDto)

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
        } else if (searchDto.searchType == "def_yn") {
            searchDto.def_yn = searchDto.searchValue
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
        map["list"] = sysSettingDao.getMappingSettingList(searchDto)

        return map;
    }

    override fun insertMappingLst(lstDto: Tblmi_set_lstDto): Map<String, Any> {
        val userInfo = UsefulUtils.sessionUser()
        val statusMap: MutableMap<String, Any> = HashMap()

        lstDto.list_tp_id = "CH03"
        lstDto.list_dt_id = "SPTP01"
        lstDto.usr_grp_cd = userInfo.usr_grp_cd
        lstDto.reg_id = userInfo.usr_id
        lstDto.list_val = lstDto.list_val!!.lowercase(Locale.getDefault())

        val result = sysSettingDao.insertSetLst(lstDto)

        return statusMap
    }

    override fun isExistMapping(lstDto: Tblmi_set_lstDto): Map<String, Any> {
        val statusMap: MutableMap<String, Any> = HashMap();
        logger.error("{}",lstDto)

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
        paginationInfo.totalRecordCount = sysSettingDao.getSettingListCnt(searchDto)

        // 발신 채널 카테고리
        var cdDto : Tblmi_comm_cdDto = Tblmi_comm_cdDto()
        cdDto.grp_id = "KAKAO_PROF_CATE"
        cdDto.cd_id = "PROF_CATE"
        val cataLst = sysSettingDao.getCommCDLst(cdDto)

        cdDto.cd_id = "CATE_MID"
        val cataMidLst = sysSettingDao.getCommCDLst(cdDto)

        cdDto.cd_id = "CATE_SUB"
        val cataSubLst = sysSettingDao.getCommCDLst(cdDto)

        map["page"] = paginationInfo
        map["pageNo"] = paginationInfo.currentPageNo
        map["cnt"] = paginationInfo.totalRecordCount
        map["list"] = sysSettingDao.getSettingList(searchDto)
        map["cateLst"] = cataLst
        map["cateMidLst"] = cataMidLst
        map["cateSubLst"] = cataSubLst
        map["sendCate"] = sysSettingDao.getSettingList(searchDto)

        return map;
    }

    override fun getRejectSettingList(dto: SetLst_searchDto): Map<String, Any> {
        val map: MutableMap<String, Any> = HashMap()

        val pageNo = if (dto.pageNo == null) {
            1
        } else {
            dto.pageNo!!
        }

        when (dto.searchType) {
            "list_nm" -> {
                dto.list_nm = dto.searchValue
            }
            "list_val" -> {
                dto.list_val = dto.searchValue
            }
            "use_yn" -> {
                dto.use_yn = dto.searchValue
            }
        }

        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        dto.list_tp_id = "CH04"
        dto.list_dt_id = "REJT01"

        val paginationInfo: PaginationInfo = UsefulUtils.makePage(pageNo, 10, 10)

        dto.firstIndex = paginationInfo.firstRecordIndex
        dto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = sysSettingDao.getSettingListCnt(dto)

        map["page"] = paginationInfo
        map["pageNo"] = paginationInfo.currentPageNo
        map["cnt"] = paginationInfo.totalRecordCount
        map["list"] = sysSettingDao.getSettingList(dto);

        return map;
    }

    override fun getRejtSettingList(dto: SetLst_searchDto): Map<String, Any> {
        val map: MutableMap<String, Any> = HashMap()

        val pageNo = if (dto.pageNo == null) {
            1
        } else {
            dto.pageNo!!
        }

        when (dto.searchType) {
            "list_nm" -> {
                dto.list_nm = dto.searchValue
            }
            "list_val" -> {
                dto.list_val = dto.searchValue
            }
            "use_yn" -> {
                dto.use_yn = dto.searchValue
            }
        }

        dto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        dto.list_tp_id = "CH04"
        dto.list_dt_id = "REJT01"

        val paginationInfo: PaginationInfo = UsefulUtils.makePage(pageNo, 10, 10)

        dto.firstIndex = paginationInfo.firstRecordIndex
        dto.recordCountPerPage = paginationInfo.recordCountPerPage
        paginationInfo.totalRecordCount = sysSettingDao.getSettingListCnt(dto)

        map["page"] = paginationInfo
        map["pageNo"] = paginationInfo.currentPageNo
        map["cnt"] = paginationInfo.totalRecordCount
        map["list"] = sysSettingDao.getSettingList(dto);

        return map;
    }

    override fun insertRejectText(lstDto: Tblmi_set_lstDto): Int {
        val userInfo = UsefulUtils.sessionUser()

        lstDto.list_tp_id = "CH04"
        lstDto.list_dt_id = "REJT01"
        lstDto.usr_grp_cd = userInfo.usr_grp_cd
        lstDto.reg_id = userInfo.usr_id

        return sysSettingDao.insertSetLst(lstDto)
    }


    override fun insertKkoSenderKey(param: HashMap<String, String>): Map<String, Any> {
        var result: MutableMap<String, Any> = createSenderKey(param)

        if (result["status"] == 200) {

            val data : MutableMap<String,Any> = result["data"] as MutableMap<String, Any>
            result = createClient(param, data["sendProfileKey"] as String)// 고객사 등록
            
            // 데이터 저장
            if (result["status"] == 200) {
                val userInfo = UsefulUtils.sessionUser()
                val lstDto = Tblmi_set_lstDto("CH02","DMTP03","N",userInfo.usr_grp_cd)
                lstDto.reg_id = userInfo.usr_id
                lstDto.list_nm = param["yellowId"]!!
                lstDto.list_val =  data["sendProfileKey"] as String

                sysSettingDao.insertSetLst(lstDto)
            }
        } else {
            result["status"] = 302
            result["msg"] = "오류가 발생했습니다. 관리자에게 문의바랍니다."
        }
        return result
    }


    override fun isExistKkoAddress(lstDto: Tblmi_set_lstDto): Map<String, Any> {
        val statusMap: MutableMap<String, Any> = HashMap();

        lstDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        lstDto.list_tp_id = "CH02"
        lstDto.list_dt_id = "DMTP03"

        val cntResult = sysSettingDao.isExistSelLst(lstDto)

        statusMap["status"] = cntResult <= 0

        return statusMap
    }

    override fun updateSetTypeYn(dto: Tblmi_set_lstDto): Map<String, Any> {
        val statusMap: MutableMap<String, Any> = HashMap()

        if (dto.def_yn == "Y") {
            dto.def_yn = "N"
        } else if (dto.def_yn == "N") {
            val temp = Tblmi_set_lstDto()
            temp.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
            temp.list_nm = dto.list_nm
            temp.def_yn = "N"
            sysSettingDao.updateSetLstYn(temp)  // 기존 기본값 해제
            
            dto.def_yn = "Y"
        }

        val result = sysSettingDao.updateSetLstYn(dto)
        statusMap["status"] = result >= 1
        return statusMap
    }

    override fun getTeamSettingList(dto: SetLst_searchDto): Map<String, Any?> {
        val map: MutableMap<String, Any> = HashMap()
        val searchDto = dto as SetLst_searchDto

        if (searchDto.searchType == "list_nm") {
            searchDto.list_nm = searchDto.searchValue
        } else if (searchDto.searchType == "list_val") {
            searchDto.list_val = searchDto.searchValue
        } else if (searchDto.searchType == "use_yn") {
            searchDto.use_yn = searchDto.searchValue
        } else if (searchDto.searchType == "def_yn") {
            searchDto.def_yn = searchDto.searchValue
        }

        searchDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        searchDto.list_tp_id = "CH05"
        searchDto.list_dt_id = "TEAM01"

        map["list"] = sysSettingDao.getMappingSettingListSort(searchDto)

        return map
    }

    override fun isExistTeam(lstDto: Tblmi_set_lstDto): Map<String, Any> {
        val statusMap: MutableMap<String, Any> = HashMap();

        lstDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        lstDto.list_tp_id = "CH05"
        lstDto.list_dt_id = "TEAM01"

        val cntResult = sysSettingDao.isExistSelLst(lstDto)

        statusMap["status"] = cntResult <= 0

        return statusMap
    }

    override fun insertTeam(lstDto: Tblmi_set_lstDto): Int {

        val tempDt = Tblmi_set_lstDto("CH05","TEAM01",null,UsefulUtils.sessionUser().usr_grp_cd)
        val maxTeamDto = sysSettingDao.getMaxDtIdByDto(tempDt)

        val userInfo = UsefulUtils.sessionUser()
        if (CommonUtils.isEmptyObject(maxTeamDto)){
            var commDto = Tblmi_comm_cdDto()
            commDto.grp_id = "USR_GRP_CD"
            commDto.cd_id = userInfo.usr_grp_cd
            commDto = sysSettingDao.getCommCD(commDto)!!
            val preId = commDto.cd_val
            lstDto.list_val = preId+"_TM_"+"001"
            lstDto.list_etc = "1"
        }else{
            val maxId = maxTeamDto!!.list_val!!
            val lengthId = maxId.length
            val preId = maxId.substring(0,lengthId-3)
            var surId = maxId.substring(lengthId-3)
            val parseId = (surId.toInt()+1).toString()
            surId = surId.substring(0,surId.length-parseId.length)
            lstDto.list_val = preId + surId + parseId
            lstDto.list_etc = parseId
        }

        lstDto.list_tp_id = "CH05"
        lstDto.list_dt_id = "TEAM01"
        lstDto.usr_grp_cd = userInfo.usr_grp_cd
        lstDto.reg_id = userInfo.usr_id

        return sysSettingDao.insertSetLst(lstDto)
    }

    override fun isExistTeamModify(lstDto: Tblmi_set_lstDto): Map<String, Any> {
        val statusMap: MutableMap<String, Any> = HashMap();

        lstDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        lstDto.list_tp_id = "CH05"
        lstDto.list_dt_id = "TEAM01"

        val cntResult = sysSettingDao.isExistModifyAddress(lstDto)

        statusMap["status"] = cntResult <= 0

        return statusMap
    }

    override fun updateLsts(list: List<Tblmi_set_lstDto>) {
        val usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        list.stream().forEach() { dto -> dto.usr_grp_cd = usr_grp_cd
                            dto.list_dt_id = "CH05"
                            dto.list_dt_id = "TEAM01"
                            sysSettingDao.updateSetLst(dto)
        }
    }

    override fun getNaverApp(): Map<String, Any> {
        val map = HashMap<String, Any>()

        val lstDto = SetLst_searchDto()
        lstDto.usr_grp_cd = UsefulUtils.sessionUser().usr_grp_cd
        lstDto.list_tp_id = "CH06"
        lstDto.list_dt_id = "APPK01"

        val dto = sysSettingDao.getSettingList(lstDto)
        map["list"] = dto
        return map
    }

    override fun insertNaverApp(lstDto: Tblmi_set_lstDto): Map<String, Any> {
        val userInfo = UsefulUtils.sessionUser()
        val statusMap: MutableMap<String, Any> = HashMap()

        lstDto.list_tp_id = "CH06"
        lstDto.list_dt_id = "APPK01"
        lstDto.usr_grp_cd = userInfo.usr_grp_cd
        lstDto.reg_id = userInfo.usr_id

        val result = sysSettingDao.insertSetLst(lstDto)

        return statusMap

    }

    override fun updateNaverApp(lstDto: Tblmi_set_lstDto): Map<String, Any> {
        val userInfo = UsefulUtils.sessionUser()
        val statusMap: MutableMap<String, Any> = HashMap()

        lstDto.list_tp_id = "CH06"
        lstDto.list_dt_id = "APPK01"
        lstDto.usr_grp_cd = userInfo.usr_grp_cd
        lstDto.reg_id = userInfo.usr_id

        val result = sysSettingDao.updateSetLst(lstDto)

        return statusMap

    }
    override fun deleteNaverApp(lstDto: Tblmi_set_lstDto): Map<String, Any> {
        val userInfo = UsefulUtils.sessionUser()
        val statusMap: MutableMap<String, Any> = HashMap()

        lstDto.list_tp_id = "CH06"
        lstDto.list_dt_id = "APPK01"
        lstDto.usr_grp_cd = userInfo.usr_grp_cd
        lstDto.upd_id = userInfo.usr_id

        val result = sysSettingDao.deleteSetLst(lstDto)

        return statusMap
    }

    override fun isExistNaverApi(usrCd: String): Map<String, Any> {
        val map = HashMap<String, Any>()

        val lstDto = SetLst_searchDto()
        lstDto.usr_grp_cd = usrCd
        lstDto.list_tp_id = "CH06"
        lstDto.list_dt_id = "APPK01"

        val dto = sysSettingDao.getSettingList(lstDto)
        map["status"] = dto.isNotEmpty()
        return map
    }


    private fun createSenderKey(param: HashMap<String, String>): MutableMap<String, Any> {
        var result: MutableMap<String, Any>

        val chanId= param["yellowId"]!!
        val map = mutableMapOf<String, Any>(
            "token" to param["token"]!!
            ,"cateCd" to param["cateCd"]!!
            ,"yellowId" to chanId
            ,"phoneNumber" to param["phoneNumber"]!!
        )

        // 발신 프로필 키 등록
        try {
            result = kkoRestApiService.createSendProfile(map)   // 발신프로필 키 등록 후 등록된 프로필 데이터 반환

            val tempData = result["data"] as MutableMap<String, Any>
            result["data"] = tempData["data"] as MutableMap<String, Any>

        } catch (e: Exception) {

            // 발신 프로필 등록 후 데이터 등록 에러 발생시 프로필 리스트 조회 후 데이터 등록
            result = mutableMapOf()
            val getTodaySendProfileResult = kkoRestApiService.getSendProfile(map)
            if(getTodaySendProfileResult["status"] == 200){
                val todaySendProfileList:List<LinkedTreeMap<String, Any>> = getTodaySendProfileResult["data"] as List<LinkedTreeMap<String, Any>>

                var sendKey = ""
                for(sendProfile in todaySendProfileList){
                    if(sendProfile["channelId"] == chanId) {
                        sendKey = sendProfile["sendProfileKey"].toString()
                    }
                }
                if(!CommonUtils.isEmptyObject(sendKey)){
                    result["status"] = 200
                    result["data"] = mutableMapOf("sendProfileKey" to sendKey)
                }
                return result
            }else{
                logger.error("", getTodaySendProfileResult)
                result["status"] = 302
                result["msg"] = "오류가 발생했습니다. 관리자에게 문의바랍니다."
                return result
            }
        }
        return result
    }

    private fun createClient(param: HashMap<String, String>, sendProfileKey: String): MutableMap<String, Any> {
        val cliMap = mutableMapOf<String, Any>(
            "channelId" to param["yellowId"]!!
            ,"bizNo" to param["bizNo"]!!
            ,"bizName" to param["bizName"]!!
            ,"managerName" to param["managerName"]!!
            ,"managerPhoneNo" to param["phoneNumber"]!!
            ,"openDate" to param["openDate"]!!
            ,"sendProfileKey" to sendProfileKey
        )

        return kkoRestApiService.createClient(cliMap)
    }

}
