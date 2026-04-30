package com.omnilab.micrm.service

import com.omnilab.micrm.model.ApiResponse
import com.omnilab.micrm.model.table.kakao.KkoBrandTemplateDto
import com.omnilab.micrm.model.table.kakao.Kko_at_tmplDto
import org.springframework.web.multipart.MultipartFile
import java.util.HashMap

interface KkoRestApiService {
    fun createAtTmpl(dto: Kko_at_tmplDto): MutableMap<String, Any>
    fun uploadTmplImg(file: MultipartFile): MutableMap<String, Any>
    fun uploadFtImg(file: MultipartFile, imgType: String): MutableMap<String, Any>
    fun updateAtTmpl(newDto: Kko_at_tmplDto): MutableMap<String, Any>
    fun getTmplDetail(tmplCd: String?, sendKey: String?): MutableMap<String, Any>
    fun uploadTmplItemImg(file: MultipartFile): MutableMap<String, Any>?
    fun cancelKepReq(tmplCd: String?, sendKey: String?): MutableMap<String, Any>?
    fun delTemplate(sendKey: String?, tmplCd: String?): MutableMap<String, Any>
    fun cancelAppTemplate(sendKey: String?, tmplCd: String?): MutableMap<String, Any>
    fun sendSenderKeyToken(param: HashMap<String, String>): MutableMap<String, Any>
    fun createSendProfile(map: MutableMap<String, Any>): MutableMap<String, Any>
    fun getSendProfile(map: MutableMap<String, Any>): MutableMap<String, Any>
    fun createClient(map: MutableMap<String, Any>): MutableMap<String, Any>

    fun checkBrand(sendKey: String): MutableMap<String, Any>
    fun createBrand(sendKey: String, template: KkoBrandTemplateDto): ApiResponse<KkoBrandTemplateDto>
    fun updateBrand(sendKey: String, template: KkoBrandTemplateDto): ApiResponse<KkoBrandTemplateDto>
    
}
