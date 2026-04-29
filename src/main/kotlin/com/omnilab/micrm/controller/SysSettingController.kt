package com.omnilab.micrm.controller

import com.omnilab.micrm.common.FileUploadUtils
import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.SetLst_searchDto
import com.omnilab.micrm.model.table.Tblmi_comm_cdDto
import com.omnilab.micrm.model.table.Tblmi_set_lstDto
import com.omnilab.micrm.service.CampaignService
import com.omnilab.micrm.service.KkoRestApiService
import com.omnilab.micrm.service.SysSettingService
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Controller
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
    private lateinit var filePath: String

    @Autowired
    lateinit var sysSettingService: SysSettingService;

    @Autowired
    @Qualifier("KkoRestApiServiceImpl")
    lateinit var kkoRestApiService: KkoRestApiService

    @Autowired
    lateinit var fileUpload: FileUploadUtils

    /**
     * @Method Name  : mappingSetting
     * @Since    : 2023. 02. 03
     * @author   : Belisa
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 매핑 정보 설정 페이지 조회
     * @title : 매핑 정보 설정 페이지 조회
     */
    @GetMapping("/teamSetting.mi")
    fun teamSetting() : ModelAndView {
        val view = ModelAndView("sys/setting/teamSetting")
        val dto = SetLst_searchDto()
        val map = sysSettingService.getTeamSettingList(dto)
        view.addObject("list",map["list"])

        return view;
    }



    /**
     * @Method Name  : updateSortLst
     * @Since    : 2023. 02. 07
     * @author   : Belisa
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 매핑 정보 설정 페이지 조회
     * @title : 매핑 정보 설정 페이지 조회
     */
    @ResponseBody
    @PostMapping("/updateSortLst.ajax")
    fun updateSortLst(@RequestBody list : List<Tblmi_set_lstDto>) {
        return sysSettingService.updateLsts(list)
    }


    /**
     * @Method Name  : mappingSetting
     * @Since    : 2022. 07. 25
     * @author   : Belisa
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 매핑 정보 설정 페이지 조회
     * @title : 매핑 정보 설정 페이지 조회
     */
    @GetMapping("/mappingSetting.mi")
    fun mappingSetting() : ModelAndView {
        val view = ModelAndView("sys/setting/mappingSetting")
        val dto = SetLst_searchDto()
        val map = sysSettingService.getMappingSettingList(dto)
        view.addObject("list",map["list"])
        view.addObject("page",map["page"])
        view.addObject("pageNo",map["pageNo"])

        return view;
    }

    /**
     * @Method Name  : getMappingSettingList
     * @Since    : 2022. 07. 25
     * @author   : Belisa
     * @param    : lstStDto: SetLst_searchDto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 매핑 정보 설정 페이지 가져오기
     * @title : 매핑 정보 설정 페이지 가져오기
     */

    @PostMapping("/getMappingSettingList.ajax")
    fun getMappingSettingList(@ModelAttribute("form") lstStDto: SetLst_searchDto) : ModelAndView {
        val view = ModelAndView("sys/setting/ajax/getMappingSettingList")
        val map = sysSettingService.getMappingSettingList(lstStDto)
        view.addObject("list",map["list"])
        view.addObject("page",map["page"])
        view.addObject("pageNo",map["pageNo"])
        return view;
    }


    /**
     * @Method Name  : getTeamSettingList
     * @Since    : 2023.02.03
     * @author   : Belisa
     * @param    : lstStDto: SetLst_searchDto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 팀 정보 설정 페이지 가져오기
     * @title : 팀 정보 설정 페이지 가져오기
     */

    @PostMapping("/getTeamSettingList.ajax")
    fun getTeamSettingList(@ModelAttribute("form") lstStDto: SetLst_searchDto) : ModelAndView {
        val view = ModelAndView("sys/setting/ajax/getTeamSettingList")
        val map = sysSettingService.getTeamSettingList(lstStDto)
        view.addObject("list",map["list"])
        view.addObject("teamCd",map["teamCd"])
        return view;
    }

    /**
     * @Method Name  : isExistTeam
     * @Since    : 2023.02.06
     * @author   : Belisa
     * @param    : lstStDto: SetLst_searchDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 팀 명 중복확인
     * @title : 팀 명 중복확인
     */

    @ResponseBody
    @PostMapping("/isExistTeam.ajax")
    fun isExistTeam(lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.isExistTeam(lstDto)
    }

    /**
     * @Method Name  : insertTeam
     * @Since    :  2023.02.06
     * @author   : Belisa
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 팀 정보 INSERT 하기
     * @title : 팀 정보 INSERT 하기
     */

    @ResponseBody
    @PostMapping("/insertTeam.ajax")
    fun insertTeam(lstDto : Tblmi_set_lstDto) : Int {
        return sysSettingService.insertTeam(lstDto)
    }

    /**
     * @Method Name  : isExistTeamModify
     * @Since    : 2023. 02. 06
     * @author   : Belisa
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 팀 정보 수정 중복여부 확인하기
     * @title : 팀 정보 수정 중복 확인
     */

    @ResponseBody
    @PostMapping("/isExistTeamModify.ajax")
    fun isExistTeamModify(lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.isExistTeamModify(lstDto)
    }


    /**
     * 
     */
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


    @ResponseBody
    @RequestMapping("/upload.mi")
    fun upload(@RequestParam("upload") file: MultipartFile, request: HttpServletRequest, session:HttpSession): MutableMap<String, Any> {
        val usrCd = UsefulUtils.sessionUser().usr_grp_cd
        val filePathGrp = filePath+"/"+UsefulUtils.sessionUser().usr_grp_cd
        val map: MutableMap<String, Any> = fileUpload.upload(usrCd!!, file)
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
    @PostMapping("/changeTypeDefYn.ajax")
    fun changeTypeDefYn(lstDto: Tblmi_set_lstDto) : Map<String,Any>  {
        return sysSettingService.updateSetTypeYn(lstDto)
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
     * @Method Name  : requestKkoToken
     * @Since    : 2023. 01. 09
     * @author   : Belisa
     * @param    :
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : SMS INSERT 하기
     * @title : SMS INSERT 하기
     */

    @ResponseBody
    @PostMapping("/requestKkoToken.ajax")
    fun requestKkoToken(@RequestBody param : HashMap<String,String>) : Map<String,Any> {
        return kkoRestApiService.sendSenderKeyToken(param)
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
     * @Method Name  : insertMappingLst
     * @Since    : 2022. 08. 02
     * @author   : SSW
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 매핑정보 INSERT 하기
     * @title : 매핑정보 INSERT 하기
     */

    @ResponseBody
    @PostMapping("/insertMapping.ajax")
    fun insertMapping(lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.insertMappingLst(lstDto)
    }

    /**
     * @Method Name  : isExistMapping
     * @Since    : 2022. 08. 02
     * @author   : SSW
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 매핑정보 중복 여부 확인하기
     * @title : 매핑정보 중복 확인
     */

    @ResponseBody
    @PostMapping("/isExistMapping.ajax")
    fun isExistMappingAddress(@ModelAttribute lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.isExistMapping(lstDto)
    }

    /**
     * @Method Name  : isExistMappingModify
     * @Since    : 2022. 08. 02
     * @author   : SSW
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 매핑정보 수정 중복 여부 확인하기
     * @title : 매핑정보 수정 중복 여부 확인하기
     */

    @ResponseBody
    @PostMapping("/isExistMappingModify.ajax")
    fun isExistSmsModify(lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.isExistMappingModify(lstDto)
    }

    /**
     * @Method Name  : deleteMapping
     * @Since    : 2022. 08. 02
     * @author   : SSW
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 매핑정보 삭제하기
     * @title : 매핑정보 삭제하기
     */

    @ResponseBody
    @PostMapping("/deleteMapping.ajax")
    fun deleteMapping(lstDto: Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.deleteSetLst(lstDto)
    }


    @GetMapping("/kkoSetting.mi")
    fun kkoSetting() : ModelAndView {
        val view = ModelAndView("sys/setting/kkoSetting")
        val dto = SetLst_searchDto()
        val map = sysSettingService.getKkoSettingList(dto)
        view.addObject("list",map["list"])
        view.addObject("cateLst",map["cateLst"])
        view.addObject("cateMidLst",map["cateMidLst"])
        view.addObject("cateSubLst",map["cateSubLst"])
        view.addObject("page",map["page"])
        view.addObject("pageNo",map["pageNo"])

        return view;
    }

    /**
     * @Method Name  : getKkoSettingList
     * @Since    : 2023. 01. 11
     * @author   : Belisa
     * @param    : lstStDto: SetLst_searchDto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 카카오 정보 설정 페이지 가져오기
     * @title : 카카오 정보 설정 페이지 가져오기
     */

    @PostMapping("/getKkoSettingList.ajax")
    fun getKkoSettingList(@ModelAttribute("form") lstStDto: SetLst_searchDto) : ModelAndView {
        val view = ModelAndView("sys/setting/ajax/getKkoSettingList")
        val map = sysSettingService.getKkoSettingList(lstStDto)
        view.addObject("list",map["list"])
        view.addObject("page",map["page"])
        view.addObject("pageNo",map["pageNo"])
        return view;
    }

    /**
     * @Method Name  : isExistKkoAddress
     * @Since    : 2023. 01. 12
     * @author   : Grayson
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 카카오 프로필키 중복 여부 확인하기
     * @title : 카카오 프로필키 중복 확인
     */

    @ResponseBody
    @PostMapping("/isExistKkoAddress.ajax")
    fun isExistKkoAddress(lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.isExistKkoAddress(lstDto)
    }

    /**
     * @Method Name  : insertKkoSenderKey
     * @Since    : 2023. 01. 09
     * @author   : Belisa
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 카카오 발신자 프로필 등록
     * @title : 카카오 발신자 프로필 등록
     */
    @ResponseBody
    @PostMapping("/insertKkoSenderKey.ajax")
    fun insertKkoSenderKey(@RequestBody param : HashMap<String,String>) : Map<String,Any> {
        return sysSettingService.insertKkoSenderKey(param)
    }


    /**
     * @Method Name  : rejectSetting
     * @Since    : 2023. 01. 03
     * @author   : Belisa
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 수신거부 문구 설정 페이지 조회
     * @title : 수신거부 문구 설정 페이지 조회
     */

    @GetMapping("/rejectSetting.mi")
    fun rejectSetting() : ModelAndView {
        val view = ModelAndView("sys/setting/rejectSetting")
        val dto = SetLst_searchDto()
        val map = sysSettingService.getRejectSettingList(dto)
        view.addObject("list",map["list"])
        view.addObject("page",map["page"])
        view.addObject("pageNo",map["pageNo"])

        return view;
    }

    /**
     * @Method Name  : getRejtSettingList
     * @Since    : 2023. 01. 03
     * @author   : Belisa
     * @param    : lstStDto: SetLst_searchDto
     * @return   : ModelAndView
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 수신거부 문구 리스트
     * @title :  수신거부 문구 리스트
     */

    @PostMapping("/getRejtSettingList.ajax")
    fun getRejtSettingList(@ModelAttribute("form") lstStDto: SetLst_searchDto) : ModelAndView {
        val view = ModelAndView("sys/setting/ajax/getRejectSettingList")
        val map = sysSettingService.getRejtSettingList(lstStDto)
        view.addObject("list",map["list"])
        view.addObject("page",map["page"])
        view.addObject("pageNo",map["pageNo"])
        return view;
    }

    /**
     * @Method Name  : isExistRejectText
     * @Since    : 2023. 01. 05
     * @author   : Belisa
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 수신거부 문자 중복 여부 확인하기
     * @title : 수신 거부 문자 중복 확인
     */

    @ResponseBody
    @PostMapping("/isExistRejectText.ajax")
    fun isExistRejectText(lstDto : Tblmi_set_lstDto) : Map<String,Any> {
        return sysSettingService.isExistSmsAddress(lstDto)
    }


    /**
     * @Method Name  : insertRejectText
     * @Since    : 2023. 01. 05
     * @author   : Belisa
     * @param    : lstDto: Tblmi_set_lstDto
     * @return   : Map<String,Any>
     * @excetion :
     * @see      :
     * @version  : 0.01
     * @Method Decription : 수신 거부 문자 INSERT 하기
     * @title : 수신 거부 문자 INSERT 하기
     */

    @ResponseBody
    @PostMapping("/insertRejectText.ajax")
    fun insertRejectText(lstDto : Tblmi_set_lstDto) : Int {
        return sysSettingService.insertRejectText(lstDto)
    }

    @GetMapping("/naverAppSetting.mi")
    fun appKeySetting(): ModelAndView {
        val view = ModelAndView("sys/setting/naverAppSetting")
        val map = sysSettingService.getNaverApp();
        view.addObject("list", map)

        return view;
    }

    @ResponseBody
    @PostMapping("/insertNaverApp.ajax")
    fun insertNaverApp(lstDto: Tblmi_set_lstDto) : Map<String, Any> {
        return sysSettingService.insertNaverApp(lstDto)
    }

    @ResponseBody
    @PostMapping("/updateNaverApp.ajax")
    fun updateNaverApp(lstDto: Tblmi_set_lstDto) : Map<String, Any> {
        return sysSettingService.updateNaverApp(lstDto)
    }

    @ResponseBody
    @PostMapping("/deleteNaverApp.ajax")
    fun deleteNaverApp(lstDto: Tblmi_set_lstDto) : Map<String, Any> {
        return sysSettingService.deleteNaverApp(lstDto)
    }

    @ResponseBody
    @PostMapping("/getBrandyn.ajax")
    fun getBrandyn(@RequestParam(value = "key") key: String) : Map<String, Any> {
        return kkoRestApiService.checkBrand(key)
    }
    
    /*
    @ResponseBody
    @PostMapping("/updateBrandYn.ajax")
    fun getBrandyn(lstDto: Tblmi_set_lstDto) : Map<String, Any> {
        return kaka.deleteNaverApp(lstDto)
    }
     */
    
}
