package com.omnilab.micrm.service

import com.omnilab.micrm.model.AtTmpl_searchDto
import com.omnilab.micrm.model.Contents_searchDto
import com.omnilab.micrm.model.table.*
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
    fun cancleKepReq(tmplCd: String?, sendKey: String?): MutableMap<String, Any>?
    fun delTemplate(sendKey: String?, tmplCd: String?): MutableMap<String, Any>
    fun cancleAppTemplate(sendKey: String?, tmplCd: String?): MutableMap<String, Any>
    fun sendSenderKeyToken(param: HashMap<String, String>): MutableMap<String, Any>
    fun createSendProfile(map: MutableMap<String, Any>): MutableMap<String, Any>

}