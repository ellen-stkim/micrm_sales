package com.omnilab.micrm.controller

import com.omnilab.micrm.common.UsefulUtils
import com.omnilab.micrm.model.Tblmi_comm_cdLstDto
import com.omnilab.micrm.model.UsrHst_searchDto
import com.omnilab.micrm.model.Usr_log_searchDto
import com.omnilab.micrm.model.Usr_searchDto
import com.omnilab.micrm.model.table.Tblmi_comm_cdDto
import com.omnilab.micrm.model.table.Tblmi_usrDto
import com.omnilab.micrm.service.*
import org.springframework.stereotype.Controller
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.web.bind.annotation.*
import org.springframework.web.servlet.ModelAndView
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse
import javax.servlet.http.HttpSession


@Controller
@RequestMapping("/sys/info")
class SysInfoController {

    val logger = LoggerFactory.getLogger(this::class.java)


    @Autowired
    lateinit var sysSettingService: SysSettingService

    @Autowired
    lateinit var sysInfoService: SysInfoService

    @GetMapping("/main.mi")
    fun main(req: HttpServletRequest, rep: HttpServletResponse, sessio: HttpSession): ModelAndView {
        return  ModelAndView("sys/info/main")
    }

    @ResponseBody
    @PostMapping("/codeLst.ajax")
    fun codeLst(req: HttpServletRequest, rep: HttpServletResponse, sessio: HttpSession): MutableList<Tblmi_comm_cdDto> {
        val list: MutableList<String> = ArrayList()
        list.add("API_PRICE")
        list.add("BRURL")
        list.add("COUPON_CDN")
        list.add("COUPON_DOMAIN")
        list.add("IMG_PATH")
        list.add("KAKAO_DB")
        list.add("KAKAO_ID")
        list.add("KAKAO_KEY")
        list.add("MDM_DB")
        list.add("NAVER_APP")
        list.add("RCS_BRND_ID")
        list.add("RCS_DB")
        list.add("RCS_MSG_ID")
        list.add("REDIRECT")
        list.add("RETURN_PATH")
        list.add("SALES_AUTH_URL")
        list.add("SALES_CID")
        list.add("SALES_JWT")
        list.add("SALES_MID")
        list.add("SALES_REST_URL")
        list.add("SALES_SEC")
        list.add("SALES_SFTP")
        list.add("SALES_SOAP_URL")
        list.add("SALES_TOTAL")
        list.add("SUPURL")
        list.add("TRACKURL")

        val dto = Tblmi_comm_cdDto()
        dto.grpIdLst = list
        dto.cd_id = UsefulUtils.sessionUser().usr_grp_cd
        dto.cd_val = UsefulUtils.sessionUser().usr_grp_cd
        val cdList = sysSettingService.getCommCDLst(dto)
        return cdList
    }

    @PostMapping("/save.service")
    fun save(@ModelAttribute dto: Tblmi_comm_cdLstDto, req: HttpServletRequest, rep: HttpServletResponse, sessio: HttpSession): String {
        if(dto.lst != null){
            sysInfoService.setCode(dto.lst!!)
        }
        return "redirect:/sys/info/main.mi"
    }

}