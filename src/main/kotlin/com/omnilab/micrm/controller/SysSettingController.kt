package com.omnilab.micrm.controller

import com.omnilab.micrm.common.FileUploadUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.*
import com.omnilab.micrm.model.table.Tblmi_comm_cdDto
import com.omnilab.micrm.model.table.Tblmi_set_lstDto
import com.omnilab.micrm.model.table.Tblmite_target_grp
import com.omnilab.micrm.model.table.Tblmite_target_lst
import com.omnilab.micrm.service.CampaignService
import com.omnilab.micrm.service.SysSettingService
import org.springframework.stereotype.Controller
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.beans.factory.annotation.Value
import org.springframework.web.bind.annotation.*
import org.springframework.web.multipart.MultipartFile
import org.springframework.web.servlet.ModelAndView
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpSession


@Controller
@RequestMapping("/sys/setting")
class SysSettingController {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Value("\${upload.src}")
    private val filePath: String? = null

    @Autowired
    lateinit var sysSettingService: SysSettingService;

    @Autowired
    @Qualifier("CampaignServiceImpl")
    private lateinit var campaignService : CampaignService

    @Autowired
    lateinit var fileUpload: FileUploadUtils;

    /**
     * @Method Name  : titleCnt
     * @Since    : 2021. 03. 25.
     * @author   : Grayson
     * @return   : Map<String,String>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 상위 타이틀 개수 구하기
     * @title : 상위 타이틀 개수 구하기
     */
    @ModelAttribute("titleCnt")
    fun titleCnt() : Map<String,String> {
        val paramMap : MutableMap<String,String> = HashMap();
        val prdMap = campaignService.getTitleProgramCnt()

        paramMap["alarmCnt"] = sysSettingService.checkAlarmCnt().toString()
        paramMap["sendExpect"] = prdMap["sendExpect"].toString()
        paramMap["sending"] = prdMap["sending"].toString()
        paramMap["apprCnt"] = prdMap["apprCnt"].toString()

        return paramMap
    }

    @GetMapping("/mailSetting.mi")
    fun mailSetting(): ModelAndView {
        val view = ModelAndView("sys/setting/mailSetting")
        val dto = SetLst_searchDto()
        val map = sysSettingService.getMailSettingList(dto)
        view.addObject("list",map["list"])
        view.addObject("page",map["page"])
        view.addObject("pageNo",map["pageNo"])

        return view
    }

    @GetMapping("/noticeSetting.mi")
    fun noticeSetting(): ModelAndView {
        val view = ModelAndView("sys/setting/noticeSetting")
        return view
    }

    //공지사항 리스트 가져오기
    @PostMapping("/getNoticeList.ajax")
    fun getNoticeList(@ModelAttribute("form") dto: Noti_searchDto): ModelAndView {
        val view = ModelAndView("sys/setting/ajax/noticeList")
        val map = sysSettingService.getNoticeList(dto)
        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])
        return view
    }

    //공지사항 저장
    @ResponseBody
    @PostMapping("/saveNotice.ajax")
    fun saveNotice(@ModelAttribute("form") dto: Noti_searchDto, @RequestParam("ckFileNm")ckFileNm :String): MutableMap<String, Any> {
        //공지사항 저장
        val map = sysSettingService.saveNotice(dto)
        //공지사항 저장후 등록된 사징 있을경우 공지사항 기본키 업데이트
        if(ckFileNm != "0"){
            dto.seq = map["notiSeq"].toString().toInt()
            sysSettingService.updateNotiFile(dto,ckFileNm)
        }
        return map
    }

    //공지사항 상세 가져오기
    @ResponseBody
    @PostMapping("/getNoticeDetail.ajax")
    fun getNoticeDetail(@ModelAttribute("form") dto: Noti_searchDto): MutableMap<String, Any> {
        val map = sysSettingService.getNoticeDetail(dto)
        return map
    }

    //공지사항 삭제
    @ResponseBody
    @PostMapping("/deleteNotice.ajax")
    fun deletNotice(@ModelAttribute("form") dto: Noti_searchDto): MutableMap<String, Any> {
        val map = sysSettingService.deleteNotice(dto)
        return map
    }

    //공지사항 ON/OFF 확인, 저장
    @ResponseBody
    @PostMapping("/saveNoticePopyn.ajax")
    fun saveNoticePopyn(@ModelAttribute("form") dto: Noti_searchDto): MutableMap<String, Any> {
        val map = sysSettingService.saveNoticePopyn(dto)
        return map
    }

    //공지사항 팝업 띄우기
    @PostMapping("/getNoticePop.ajax")
    fun getNoticePop(@ModelAttribute("form") dto: Noti_searchDto): ModelAndView {
        val view = ModelAndView("sys/setting/ajax/noticePopup")
        val map = sysSettingService.getNoticePop(dto)
        view.addObject("list", map["list"])
        return view
    }

    @ResponseBody
    @RequestMapping("/upload.mi")
    fun upload(@RequestParam("upload") file: MultipartFile, request: HttpServletRequest, session:HttpSession): MutableMap<String, Any> {
        val filePathGrp = filePath+"/"+UsefulUtils.sessionUser().usr_grp_cd
        val map: MutableMap<String, Any> = fileUpload.upload(filePathGrp, file, request);
        if(map["uploaded"].toString() == "0"){
            logger.info("File Upload fail")
        }else{
            val commonCDDto = Tblmi_comm_cdDto()
            commonCDDto.grp_id = "COMMON"
            commonCDDto.cd_id = "UPURL01"
            val uploadPrefix = sysSettingService.getCommCD(commonCDDto);
            val uploadUrl = map["url"].toString()
            map["url"] = uploadPrefix?.cd_val + uploadUrl
        }
        val returnMap = sysSettingService.insertNoticeFile(map)
        if(returnMap["message"].toString() == "0"){
            map["uploaded"] = 0
            map["message"] = "파일 저장에 실패하였습니다."
            logger.info("File DB insert fail")
        }
        return map
    }

    @PostMapping("/getMailSettingList.ajax")
    fun getMailSettingList(@ModelAttribute("form") dto : SetLst_searchDto): ModelAndView {
        val view = ModelAndView("sys/setting/ajax/getMailSettingList")
        val map = sysSettingService.getMailSettingList(dto)
        view.addObject("list", map["list"])
        view.addObject("page", map["page"])
        view.addObject("pageNo", map["pageNo"])
        return view
    }


    /**
     * @Method Name  : selectAlarmList
     * @Since    : 2021. 03. 22
     * @author   : Grayson
     * @param    : notiDto: Noti_searchDto , workSearchDto :  WorkSearch_Dto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 알람에 필요한 공지사항, 작업내역 가져오기
     * @title : 알람 리스트
     */

    @ResponseBody
    @PostMapping("/selectAlarmList.ajax")
    fun selectAlarmList(notiDto : Noti_searchDto , workSearchDto: WorkSearch_Dto) : ModelAndView {
        val listMap = sysSettingService.selectAlarmList(notiDto,workSearchDto)
        val view = ModelAndView("sys/setting/ajax/alarmPopup")

        view.addObject("workList" , listMap["workList"])
        view.addObject("workCnt",listMap["workCnt"])
        view.addObject("notiList",listMap["notiList"])
        return view
    }


    /**
     * @Method Name  : selectAlarmAndUpdate
     * @Since    : 2021. 03. 22
     * @author   : Grayson
     * @param    : notiDto: Noti_searchDto , workSearchDto : WorkSearch_Dto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 알람 상태 업데이트 후 리스트 출력하기
     * @title : 알람 상태 업데이트 후 리스트 출력하기
     */
    @ResponseBody
    @PostMapping("/selectAlarmAndUpdate.ajax")
    fun selectAlarmAndUpdate(notiDto : Noti_searchDto , workSearchDto: WorkSearch_Dto) : ModelAndView {
        val updateMap = sysSettingService.updateAlarmStatus(workSearchDto)
        val listMap = sysSettingService.selectAlarmList(notiDto,workSearchDto)
        val view = ModelAndView("sys/setting/ajax/alarmPopup")

        view.addObject("workList" , listMap["workList"])
        view.addObject("workCnt",listMap["workCnt"])

        return view
    }


    /**
     * @Method Name  : updateAlarmStatus
     * @Since    : 2021. 03. 22
     * @author   : Grayson
     * @param    : workSearchDto: WorkSearch_Dto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 알람 상태 업데이트하기
     * @title : 알람 상태 업데이트하기
     */

    @ResponseBody
    @PostMapping("/updateAlarmStatus.ajax")
    fun updateAlarmStatus(workSearchDto: WorkSearch_Dto) : Map<String,Any>  {
        return sysSettingService.updateAlarmStatus(workSearchDto)
    }


    /**
     * @Method Name  : updateSetLstYn
     * @Since    : 2021. 03. 26
     * @author   : Grayson
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 메일 Use_YN 변경하기
     * @title : 메일 Use_YN 변경하기
     */

    @ResponseBody
    @PostMapping("/updateSetLstYn.ajax")
    fun updateSetLstYn(lstDto: Tblmi_set_lstDto) : Map<String,Any>  {
       return sysSettingService.updateSetLstYn(lstDto)
    }

    /**
     * @Method Name  : insertMail
     * @Since    : 2021. 03. 29
     * @author   : Grayson
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 메일 주소 INSERT 하기
     * @title : 메일 주소 INSERT 하기
     */

    @ResponseBody
    @PostMapping("/insertMail.ajax")
    fun insertMailLst(lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.insertMailLst(lstDto)
    }

    /**
     * @Method Name  : isExistMailAddress
     * @Since    : 2021. 03. 29
     * @author   : Grayson
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 메일 주소 저장시 중복 여부 확인하기
     * @title : 메일 주소 중복 확인
     */

    @ResponseBody
    @PostMapping("/isExistMailAddress.ajax")
    fun isExistMailAddress(lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.isExistMailAddress(lstDto)
    }

    /**
     * @Method Name  : isExistMailAddressModify
     * @Since    : 2021. 03. 30
     * @author   : Grayson
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 메일 주소 수정 중복여부 확인하기
     * @title : 메일 주소 수정 중복 확인
     */

    @ResponseBody
    @PostMapping("/isExistMailModifyAddress.ajax")
    fun isExistMailAddressModify(lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.isExistMailAddressModify(lstDto)
    }

    /**
     * @Method Name  : deleteMailAddress
     * @Since    : 2021. 03. 29
     * @author   : Grayson
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 연락처 삭제하기
     * @title : 연락처 삭제 하기
     */

    @ResponseBody
    @PostMapping("/deleteAddress.ajax")
    fun deleteMailAddress(lstDto: Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.deleteSetLst(lstDto)
    }

    /**
     * @Method Name  : changeDefaultMail
     * @Since    : 2021. 03. 30
     * @author   : Grayson
     * @param    : lstStDto: SetLst_searchDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 기본 연락처 값 변경하기
     * @title : 기본 연락처 값 변경하기
     */

    @ResponseBody
    @PostMapping("/changeDefaultLst.ajax")
    fun changeDefaultLst(lstStDto : SetLst_searchDto) : Map<String,Any>{
        return sysSettingService.changeDefaultLst(lstStDto)
    }

    /**
     * @Method Name  : detailLst
     * @Since    : 2021. 03. 30
     * @author   : Grayson
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : seq 값으로 detailLst 값 조회 한다.
     * @title : 디테일 메일 값 조회
     */
    @ResponseBody
    @PostMapping("/detailLst.ajax")
    fun detailLst(lstDto : Tblmi_set_lstDto) : Map<String,Any>{
        return sysSettingService.detailLst(lstDto)
    }


    /**
     * @Method Name  : smsSetting
     * @Since    : 2021. 03. 30
     * @author   : Grayson
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 문자 정보 설정 페이지 조회
     * @title : 문자 정보 설정 페이지 조회
     */

    @GetMapping("/smsSetting.mi")
    fun smsSetting() : ModelAndView {
        val view = ModelAndView("sys/setting/smsSetting")
        val dto = SetLst_searchDto()
        val map = sysSettingService.getSmsSettingList(dto)
        view.addObject("list",map["list"])
        view.addObject("page",map["page"])
        view.addObject("pageNo",map["pageNo"])

        return view;
    }

    /**
     * @Method Name  : getSmsSettingList
     * @Since    : 2021. 03. 30
     * @author   : Grayson
     * @param    : lstStDto: SetLst_searchDto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 문자 정보 설정 페이지 가져오기
     * @title : 문자 정보 설정 페이지 가져오기
     */

    @PostMapping("/getSmsSettingList.ajax")
    fun getSmsSettingList(@ModelAttribute("form") lstStDto: SetLst_searchDto) : ModelAndView {
        val view = ModelAndView("sys/setting/ajax/getSmsSettingList")
        val map = sysSettingService.getSmsSettingList(lstStDto)
        view.addObject("list",map["list"])
        view.addObject("page",map["page"])
        view.addObject("pageNo",map["pageNo"])
        return view;
    }


    /**
     * @Method Name  : insertSmsLst
     * @Since    : 2021. 03. 30
     * @author   : Grayson
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : SMS INSERT 하기
     * @title : SMS INSERT 하기
     */

    @ResponseBody
    @PostMapping("/insertSms.ajax")
    fun insertSmsLst(lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.insertSmsLst(lstDto)
    }


    /**
     * @Method Name  : isExistSmsAddress
     * @Since    : 2021. 03. 30
     * @author   : Grayson
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 메일 주소 중복 여부 확인하기
     * @title : 메일 주소 중복 확인
     */

    @ResponseBody
    @PostMapping("/isExistSmsAddress.ajax")
    fun isExistSmsAddress(lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.isExistSmsAddress(lstDto)
    }

    /**
     * @Method Name  : isExistSmsModifyAddress
     * @Since    : 2021. 03. 30
     * @author   : Grayson
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 메일 주소 수정 중복 여부 확인하기
     * @title : 메일 주소 수정 중복 여부 확인하기
     */

    @ResponseBody
    @PostMapping("/isExistSmsModifyAddress.ajax")
    fun isExistSmsModifyAddress(lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.isExistSmsAddressModify(lstDto)
    }

    /**
     * @Method Name  : updateLst
     * @Since    : 2021. 03. 30
     * @author   : Grayson
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 발신자 수정하기
     * @title : 발신자 수정하기
     */
    @ResponseBody
    @PostMapping("/updateLst.ajax")
    fun updateLst(lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.updateLst(lstDto)
    }

    /**
     * @Method Name  : selectTestGroup
     * @Since    : 2021. 03. 31
     * @author   : Grayson
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 테스트 그룹 조회 페이지
     * @title : 테스트 그룹 조회 페이지
     */
    @GetMapping("/testGroup.mi")
    fun selectTestGroup(@ModelAttribute dto: TestGroup_SearchDto) : ModelAndView{

        val view = ModelAndView("sys/setting/testGroup")
        val testGrpLstMap = sysSettingService.selectTestGrpLst(dto)

        view.addObject("list", testGrpLstMap["list"])
        view.addObject("page", testGrpLstMap["page"])
        view.addObject("pageNo", testGrpLstMap["pageNo"])
        view.addObject("listCnt", testGrpLstMap["listCnt"])
        view.addObject("searchType",dto.searchType)
        view.addObject("searchValue",dto.searchValue)
        view.addObject("reg_dt" , dto.reg_dt)
        view.addObject("reg_dt_range" ,dto.reg_dt_range)
        view.addObject("upd_dt", dto.upd_dt)
        view.addObject("upd_dt_range", dto.upd_dt_range)

        return view
    }

    /**
     * @Method Name  : selectTestGrpLst
     * @Since    : 2021. 03. 31
     * @author   : Grayson
     * @param    : testGrpDto : TestGroup_SearchDto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 테스트 그룹 조회 페이지
     * @title : 테스트 그룹 조회 페이지
     */

    @PostMapping("/testGrpList.ajax")
    fun selectTestGroupLst(@ModelAttribute testGrpDto : TestGroup_SearchDto) : ModelAndView {
        val view = ModelAndView("sys/setting/ajax/testGrpLst")
        val testGrpLstMap = sysSettingService.selectTestGrpLst(testGrpDto)

        view.addObject("list", testGrpLstMap["list"])
        view.addObject("page", testGrpLstMap["page"])
        view.addObject("pageNo", testGrpLstMap["pageNo"])
        view.addObject("listCnt", testGrpLstMap["listCnt"])

        return view
    }

    /**
     * @Method Name  : updateTestGrpYn
     * @Since    : 2021. 03. 31
     * @param    : testGrpDto : Tblmi_testGrpDto
     * @author   : Grayson
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 테스트 그룹 Y,N 변경하기
     * @title : 테스트 그룹 Y,N 변경하기
     */

    @ResponseBody
    @PostMapping("/updateTestGrpYn.ajax")
    fun updateTestGrpYn(@ModelAttribute testGrpDto: Tblmite_target_grp) : Map<String,Any>{
        return sysSettingService.updateTestGrpYn(testGrpDto)
    }

    /**
     * @Method Name  : deleteTestGrp
     * @Since    : 2021. 03. 31
     * @param    : testGrpDto : Tblmi_testGrpDto
     * @author   : Grayson
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 테스트 그룹 삭제하기
     * @title : 테스트 그룹 삭제하기
     */

    @ResponseBody
    @PostMapping("/deleteTestGrp.ajax")
    fun deleteTestGrp(@ModelAttribute testGrpDto : Tblmite_target_grp) : Map<String,Any>{
        return sysSettingService.deleteTestGrp(testGrpDto)
    }


    /**
     * @Method Name  : detailTestGrp
     * @Since    : 2021. 03. 31
     * @author   : Grayson
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 테스트 그룹 상세 조회하기
     * @title : 테스트 그룹 상세 조회하기
     */

    @GetMapping("/detailTestGrp/{seq}.mi")
    fun detailTestGrp(@PathVariable("seq") seq: Int) : ModelAndView{
        val view = ModelAndView("sys/setting/testGroupDetail")
        val testGrpDto = Tblmite_target_grp()
        testGrpDto.seq = seq
        val oneTestGrpMap = sysSettingService.detailTestGrp(testGrpDto)
        view.addObject("grpNm" , oneTestGrpMap["grpNm"])
        view.addObject("grpNo" , oneTestGrpMap["grpNo"])
        view.addObject("grpCnt" , oneTestGrpMap["grpCnt"])
        view.addObject("edmCnt" , oneTestGrpMap["edmCnt"])
        view.addObject("mobCnt" , oneTestGrpMap["mobCnt"])

        return view
    }


    /**
     * @Method Name  : selectTestTargetLst
     * @Since    : 2021. 03. 31
     * @param    : testGrpDto : TestGroup_SearchDto
     * @author   : Grayson
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 테스트 그룹 조회 페이지
     * @title : 테스트 그룹 조회 페이지
     */

    @PostMapping("/testGrpTargetList.ajax")
    fun selectTestTargetLst(@ModelAttribute testGrpDtoDto : TestTarget_SearchDto) : ModelAndView {

        val view = ModelAndView("sys/setting/ajax/testGrpTargetLst")
        val testGrpLstMap = sysSettingService.selectTestTargetLst(testGrpDtoDto)

        view.addObject("list", testGrpLstMap["list"])
        view.addObject("page", testGrpLstMap["page"])
        view.addObject("pageNo", testGrpLstMap["pageNo"])
        view.addObject("listCnt", testGrpLstMap["listCnt"])
        view.addObject("searchType", testGrpLstMap["searchType"])
        view.addObject("searchValue", testGrpLstMap["searchValue"])

        view.addObject("grpCnt", testGrpLstMap["grpCnt"])
        view.addObject("mobCnt", testGrpLstMap["mobCnt"])
        view.addObject("edmCnt", testGrpLstMap["edmCnt"])

        return view
    }


    /**
     * @Method Name  : importTestGroup
     * @Since    : 2021. 04.01
     * @param    : file : MultipartFile?
     * @author   : Grayson
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 테스트 타겟 그룹 import 하기
     * @title : 테스트 타겟 그룹 import
     */

    @ResponseBody
    @PostMapping("/testTargetImport.ajax")
    fun importTestGroup(@RequestParam("excelFile") file : MultipartFile?) : Map<String,Any> {

        var statusMap : MutableMap<String,Any> =  HashMap<String,Any>()

        if(file == null) {
            statusMap["result"] = false
            statusMap["message"] = "엑셀 파일이 존재 하지 않습 니다"
            return statusMap
        } else {
            return sysSettingService.importTestGroup(file)
        }
    }


    /**
     * @Method Name  : insertTestGroup
     * @Since    : 2021. 04.01
     * @param    : testGrpDto : TestTarget_SearchDto
     * @author   : Grayson
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 테스트 타겟 그룹 저장하기
     * @title : 테스트 타겟 그룹 저장하기
     */

    @ResponseBody
    @PostMapping("/testTargetInsert.ajax")
    fun insertTestGroup(@ModelAttribute testGrpDto : TestGroup_SearchDto) : Map<String,Any> {
        val messageMap : MutableMap<String,String> = HashMap();
        sysSettingService.insertTestGroup(testGrpDto)

        messageMap["message"] = "테스트 타겟 유저 생성중입니다. 생성시까지 시간이 소모 될 수 있습니다"
        return messageMap
    }

    /**
     * @Method Name  : deleteTestTarget
     * @Since    : 2021. 04. 14
     * @param    : dto : Tblmite_target_lst
     * @author   : Grayson
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 테스트 그룹 타겟 삭제하기
     * @title : 테스트 그룹 타겟 삭제하기
     */

    @ResponseBody
    @PostMapping("/deleteTestTarget.ajax")
    fun deleteTestTarget(@ModelAttribute dto : Tblmite_target_lst) : Map<String,Any>{
        return sysSettingService.deleteTestTarget(dto)
    }

    /**
     * @Method Name  : updateTestTargetYN
     * @Since    : 2021. 04. 14
     * @param    : dto : Tblmite_target_lst
     * @author   : Grayson
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 테스트 타겟 수신동의 Y,N 값 변경하기
     * @title : 테스트 그룹 타겟 수신동의 Y,N 값 변경하기
     */
    @ResponseBody
    @PostMapping("/updateTestTargetYn.ajax")
    fun updateTestTargetYn(@ModelAttribute dto : TestTarget_SearchDto) : Map<String,Any> {
        return sysSettingService.updateTestTargetYn(dto)
    }


    /**
     * @Method Name  : insertTargetLstOne
     * @Since    : 2021. 04. 14
     * @param    : dto : Tblmite_target_lst
     * @author   : Grayson
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 테스트 타겟 한 개 추가하기
     * @title : 테스트 타겟 한 개 추가하기
     */
    @ResponseBody
    @PostMapping("/insertTargetLstOne.ajax")
    fun insertTargetLstOne(@ModelAttribute dto : Tblmite_target_lst) : Map<String,Any> {
        return sysSettingService.insertTargetLstOne(dto)
    }

    /**
     * @Method Name  : insertTargetLstOne
     * @Since    : 2021. 04. 14
     * @param    : dto : Tblmite_target_lst
     * @author   : Grayson
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 테스트 타겟 한 개 변경하기
     * @title : 테스트 타겟 한 개 변경하기
     */
    @ResponseBody
    @PostMapping("/updateTestTargetLstOne.ajax")
    fun updateTestTargetLstOne(@ModelAttribute dto : Tblmite_target_lst) : Map<String,Any> {
        return sysSettingService.updateTestTargetLstOne(dto)
    }


    /**
     * @Method Name  : detailTestTarget
     * @Since    : 2021. 04. 14
     * @param    : dto : Tblmite_target_lst
     * @author   : Grayson
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 테스트 타겟 한 개 조회하기
     * @title : 테스트 타겟 한 개 조회 하기
     */
    @ResponseBody
    @PostMapping("/detailTestTarget.ajax")
    fun detailTestTarget(@ModelAttribute dto : Tblmite_target_lst) : Map<String,Any>{
        return sysSettingService.detailTestTarget(dto)
    }


}
