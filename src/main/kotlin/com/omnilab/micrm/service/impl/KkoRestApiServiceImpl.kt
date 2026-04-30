package com.omnilab.micrm.service.impl

import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.model.table.kakao.Kko_at_tmplDto
import com.omnilab.micrm.repository.KkoAtTmplDao
import com.omnilab.micrm.common.FilenameAwareInputStreamResource
import com.omnilab.micrm.config.adapter.EmptyStringTypeAdapterFactory
import com.omnilab.micrm.model.ApiResponse
import com.omnilab.micrm.model.table.kakao.KkoBrandTemplateDto
import com.omnilab.micrm.service.KkoRestApiService
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.beans.factory.annotation.Value
import org.springframework.core.io.ByteArrayResource
import org.springframework.http.*
import org.springframework.stereotype.Service
import org.springframework.util.LinkedMultiValueMap
import org.springframework.web.client.RestTemplate
import org.springframework.web.multipart.MultipartFile
import java.net.HttpURLConnection


@Service("KkoRestApiServiceImpl")
class KkoRestApiServiceImpl : KkoRestApiService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Value("\${variable.biz-url}")
    private lateinit var url: String

    @Value("\${variable.biz-msg-url}")
    private lateinit var mstUrl: String

    @Value("\${variable.biz-version}")
    private lateinit var version: String

    @Value("\${variable.biz-id}")
    private lateinit var clientId: String

    private val recellVersion: String = "v1"

    @Value("\${variable.biz-Auth}")
    private lateinit var auth: String

    @Autowired
    @Qualifier("restTemplate")
    private lateinit var restTemplate: RestTemplate
    
    @Autowired
    @Qualifier("KkoAtTmplDaoImpl")
    private lateinit var kkoAtTmplDao: KkoAtTmplDao
    
    val gson = GsonBuilder()
            .registerTypeAdapterFactory(EmptyStringTypeAdapterFactory())
            .create()

    override fun createAtTmpl(dto: Kko_at_tmplDto): MutableMap<String, Any> {
        val token = getToken(url, recellVersion)

        //        header 설정
        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_JSON
        headers.set("Authorization", "Bearer $token")
        headers.set("version", recellVersion)
        headers.set("accept", MediaType.ALL_VALUE)

        val urlString = "$url/$recellVersion/resell/template/create/${dto.send_key}"
        val reMap: MutableMap<String, Any> = restExchange(urlString, HttpMethod.POST, HttpEntity(gson.toJson(dto), headers))
        return reMap
    }

    override fun updateAtTmpl(newDto: Kko_at_tmplDto): MutableMap<String, Any> {
        val token = getToken(url, recellVersion)
        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_JSON
        headers.set("Authorization", "Bearer $token")
        headers.set("version", recellVersion)
        headers.set("accept", MediaType.ALL_VALUE)

        val urlString = "$url/$recellVersion/resell/template/modify/${newDto.send_key}"
        val reMap: MutableMap<String, Any> = restExchange(urlString, HttpMethod.PUT, HttpEntity(gson.toJson(newDto), headers))
        return reMap
    }

    override fun getTmplDetail(tmplCd: String?, sendKey: String?): MutableMap<String, Any> {
        val token = getToken(url, recellVersion)

        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_JSON
        headers.set("Authorization", "Bearer $token")
        headers.set("version", recellVersion)
        headers.set("accept", MediaType.ALL_VALUE)
        val urlString = "$url/$recellVersion/resell/template/select/$sendKey/$tmplCd"
        val reMap: MutableMap<String, Any> = restExchange(urlString, HttpMethod.GET, HttpEntity(null, headers))
        return reMap
    }

    override fun uploadTmplImg(file: MultipartFile): MutableMap<String, Any> {
        val token = getToken(url, recellVersion)
        //        header 설정
        val headers = HttpHeaders()
        headers.contentType = MediaType.MULTIPART_FORM_DATA
        headers.set("Authorization", "Bearer $token")
        headers.set("version", recellVersion)
        headers.set("accept", MediaType.ALL_VALUE)

        val urlString = "$url/$recellVersion/upload/image/alimtalk/template"

        val map = LinkedMultiValueMap<String, Any>()
        val resource = FilenameAwareInputStreamResource(file.inputStream, file.size, file.originalFilename.toString())
        map["image"] = resource
        val reMap: MutableMap<String, Any> = restExchange(urlString, HttpMethod.POST, HttpEntity(map, headers))
        return reMap

    }

    override fun uploadTmplItemImg(file: MultipartFile): MutableMap<String, Any>? {
        val token = getToken(url, recellVersion)

        val headers = HttpHeaders()
        headers.contentType = MediaType.MULTIPART_FORM_DATA
        headers.set("Authorization", "Bearer $token")
        headers.set("version", recellVersion)
        headers.set("accept", MediaType.ALL_VALUE)
        val urlString = "$url/$recellVersion/upload/image/alimtalk/itemHighlight"

        val map = LinkedMultiValueMap<String, Any>()
        val resource = FilenameAwareInputStreamResource(file.inputStream, file.size, file.originalFilename.toString())
        map["image"] = resource

        val reMap: MutableMap<String, Any> = restExchange(urlString, HttpMethod.POST, HttpEntity(map, headers))
        return reMap
    }

    override fun cancelKepReq(tmplCd: String?, sendKey: String?): MutableMap<String, Any>? {
        val token = getToken(url, recellVersion)

        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_JSON
        headers.set("Authorization", "Bearer $token")
        headers.set("version", recellVersion)
        headers.set("accept", MediaType.ALL_VALUE)
        val urlString = "$url/$recellVersion/resell/template/cancel/request/${sendKey}/${tmplCd}"

        return restExchange(urlString, HttpMethod.PUT, HttpEntity(null, headers))
    }

    override fun delTemplate(sendKey: String?, tmplCd: String?): MutableMap<String, Any> {
        val token = getToken(url, recellVersion);

        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_JSON
        headers.set("Authorization", "Bearer $token")
        headers.set("version", recellVersion)
        headers.set("accept", MediaType.ALL_VALUE)
        val urlString = "$url/$recellVersion/resell/template/cancel/request/${sendKey}/${tmplCd}"

        return restExchange(urlString, HttpMethod.PUT, HttpEntity(null, headers))
    }

    override fun cancelAppTemplate(sendKey: String?, tmplCd: String?): MutableMap<String, Any> {
        val token = getToken(url, recellVersion)

        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_JSON
        headers.set("Authorization", "Bearer $token")
        headers.set("version", recellVersion)
        headers.set("accept", MediaType.ALL_VALUE)
        val urlString = "$url/$recellVersion/resell/template/cancel/approval/${sendKey}/${tmplCd}"

        return restExchange(urlString, HttpMethod.PUT, HttpEntity(null, headers))
    }


    override fun uploadFtImg(file: MultipartFile, imgType: String): MutableMap<String, Any> {
        val map = LinkedMultiValueMap<String, Any>()
        val fileBytes = file.bytes
        val resource = object : ByteArrayResource(fileBytes) {
            override fun getFilename(): String = file.originalFilename.toString()
        }

        val token: String
        val urlString: String
        when (imgType) {
            "IMGTP11" -> {
                token = getToken(mstUrl, version)
                urlString = "$mstUrl/$version/upload/bm/image/wide"
                map["image"] = resource
            }
            "IMGTP12" -> {
                token = getToken(mstUrl, version)
                urlString = "$mstUrl/$version/upload/bm/image/wideItemList/first"
                map["image"] = resource
            }
            "IMGTP13" -> {
                token = getToken(url, "v1")
                //urlString = "$mstUrl/$version/upload/bm/image/wideItemList"
                urlString = "$url/v1/upload/$clientId/ftup/image/wideItemList"
                map.add("images", resource)
            }
            "IMGTP14" -> {
                token = getToken(url, "v1")
                //urlString = "$mstUrl/$version/upload/bm/image/carouselCommerce"
                urlString = "$url/v1/upload/$clientId/ftup/image/carouselCommerce"
                map.add("images", resource)
            }
            "IMGTP15" -> {
                token = getToken(url, "v1")
                //urlString = "$mstUrl/$version/upload/bm/image/carouselFeed"
                urlString = "$url/v1/upload/$clientId/ftup/image/carouselFeed"
                map.add("images", resource)
            }
            else -> {
                token = getToken(mstUrl, version)
                urlString = "$mstUrl/$version/upload/bm/image/default"
                map["image"] = resource
            }
        }
        //        header 설정
        val headers = HttpHeaders()
        headers.contentType = MediaType.MULTIPART_FORM_DATA
        headers.set("Authorization", "Bearer $token")
        headers.set("version", version)
        headers.set("accept", MediaType.ALL_VALUE)

        val reMap: MutableMap<String, Any> = restExchange(urlString, HttpMethod.POST, HttpEntity(map, headers))
        logger.error("reMap {}", reMap)
        return reMap
    }


    override fun sendSenderKeyToken(param: java.util.HashMap<String, String>): MutableMap<String, Any> {
        val result: MutableMap<String, Any> = mutableMapOf()
        try {
            val token = getToken(url, recellVersion)
            //        header 설정
            val headers = HttpHeaders()
            headers.contentType = MediaType.APPLICATION_JSON
            headers.set("Authorization", "Bearer $token")
            headers.set("version", recellVersion)
            headers.set("accept", MediaType.ALL_VALUE)

            val chanId = param.get("channelId")
            val phoneNum = param.get("phoneNum")
            val urlString = "$url/$recellVersion/sendProfile/token?yellowId=$chanId&phoneNumber=$phoneNum"

            val reMap: MutableMap<String, Any> = restExchange(urlString, HttpMethod.GET, HttpEntity(null, headers))
            val data = reMap["data"] as MutableMap<String, Any>
            if("API_200" == data["code"]){
                result["status"] = 200
                result["msg"] = "인증번호가 카카오톡으로 발송되었습니다."
            }else{
                result["status"] = data["code"]!!.toString().replace("API_","")
                result["msg"] = data["message"]!!
            }
        }catch (e:Exception){
            result["status"] = 302
            result["msg"] = "에러가 발생했습니다. 새로고침 후 다시 시도해주세요."
        }

        return result
    }

    override fun createSendProfile(map: MutableMap<String, Any>): MutableMap<String, Any> {
        val result = HashMap<String, Any>()
        val token = getToken(url, recellVersion)
        // header 설정
        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_JSON
        headers.set("Authorization", "Bearer $token")
        headers.set("version", recellVersion)
        headers.set("accept", MediaType.ALL_VALUE)

        headers.set("token", map["token"]?.toString())
        headers.set("phoneNumber", map["phoneNumber"]?.toString())

        val urlString = "$url/$recellVersion/sendProfile/create"
        val bodyMap = HashMap<String, String>()
        bodyMap["yellowId"] = map["yellowId"] as String
        bodyMap["categoryCode"] = map["cateCd"] as String
        bodyMap["channelKey"] = "base"

        val reMap: MutableMap<String, Any> = restExchange(urlString, HttpMethod.POST, HttpEntity(gson.toJson(bodyMap), headers))
        val data = reMap["data"] as MutableMap<String, Any>
        logger.info("createSendProfile {}", data)

        if ("API_200" == data["code"]) {
            result["status"] = 200
            result["data"] = data
        } else {
            result["status"] = data["code"]!!.toString().replace("API_","")
            result["msg"] = data["message"]!!
        }
        return result
    }

    override fun getSendProfile(map: MutableMap<String, Any>): MutableMap<String, Any> {
        val result: MutableMap<String, Any> = mutableMapOf()
        val token = getToken(url, recellVersion)
        //        header 설정
        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_JSON
        headers.set("Authorization", "Bearer $token")
        headers.set("version", recellVersion)
        headers.set("accept", MediaType.ALL_VALUE)

        val urlString = "$url/$recellVersion/sendProfile/select"

        val reMap: MutableMap<String, Any> = restExchange(urlString, HttpMethod.GET, HttpEntity(null, headers))
        val data = reMap["data"] as MutableMap<String, Any>

        if ("API_200" == data["code"]) {
            result["status"] = 200
            result["data"] = data["data"] as List<HashMap<String, Any>>
        } else {
            result["status"] = data["code"]!!.toString().replace("API_","")
            result["msg"] = data["message"]!!
        }
        return result

    }

    override fun createClient(bodyMap: MutableMap<String, Any>): MutableMap<String, Any> {
        val result: MutableMap<String, Any> = mutableMapOf()
        val token = getToken(url, recellVersion)
        //        header 설정
        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_JSON
        headers.set("Authorization", "Bearer $token")
        headers.set("version", recellVersion)
        headers.set("accept", MediaType.ALL_VALUE)

        bodyMap["offerCd"] = "API"
        val urlString = "$url/$recellVersion/resell/client/create"

        val reMap: MutableMap<String, Any> = restExchange(urlString, HttpMethod.POST, HttpEntity(gson.toJson(bodyMap), headers))
        val data = reMap["data"] as MutableMap<String, Any>
        if ("API_200" == data["code"]) {
            result["status"] = 200
            result["data"] = data
        } else {
            result["status"] = data["code"]!!.toString().replace("API_", "")
            result["msg"] = data["message"]!!
        }
        return result
    }

    override fun checkBrand(sendKey: String): MutableMap<String, Any> {
        logger.error("{}", sendKey)
        val token = getToken(url, recellVersion)

        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_JSON
        headers.set("Authorization", "Bearer $token")
        headers.set("version", recellVersion)
        headers.set("accept", MediaType.ALL_VALUE)
        headers.set("X-Sender-Key", sendKey)
        
        val urlString = "$url/$recellVersion/bm/check/${clientId}"
        val reMap: MutableMap<String, Any> = restExchange(urlString, HttpMethod.GET, HttpEntity(headers))
        return reMap
    }

    private fun getToken(thisUrl: String, version: String): String {
        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_FORM_URLENCODED
        headers.set("Authorization", auth)
        headers.set("version", recellVersion)
        headers.set("accept", MediaType.ALL_VALUE)

        val map: MutableMap<String, Any> = HashMap()
        map["grant_type"] = "api"

        val urlString = "$thisUrl/$recellVersion/oauth/token"
        val reMap: MutableMap<String, Any> = restExchange(urlString, HttpMethod.POST, HttpEntity(gson.toJson(map), headers));
        val data = reMap["data"] as MutableMap<String, Any>

        return data["access_token"] as String
    }

    private fun restExchange(urlString: String, method: HttpMethod, httpEntity: HttpEntity<Any>): MutableMap<String, Any> {
        val result: ResponseEntity<String> = restTemplate.exchange(urlString, method, httpEntity, String::class.java)
        val status = result.statusCode.value()
        val reMap: MutableMap<String, Any> = HashMap()
        reMap["result"] = status >= HttpURLConnection.HTTP_OK && status < HttpURLConnection.HTTP_MULT_CHOICE
        if (result.body == null) {
            reMap["data"] = ""
        } else {
            val body = result.body!!
            val bodyMap: Map<String, Any> = GsonBuilder().create().fromJson(body, object : TypeToken<Map<String, Any>>() {}.type)
            reMap["data"] = bodyMap
        }
        return reMap
    }
    
    override fun createBrand(sendKey: String, template: KkoBrandTemplateDto): ApiResponse<KkoBrandTemplateDto> {
        val result: MutableMap<String, Any> = mutableMapOf()
        val token = getToken(url, recellVersion)
        
        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_JSON
        headers.set("Authorization", "Bearer $token")
        headers.set("version", recellVersion)
        headers.set("accept", MediaType.ALL_VALUE)
        headers.set("X-Sender-Key", sendKey)

        val urlString = "$url/$recellVersion/ftup/template/${clientId}/create"
        val reMap: MutableMap<String, Any> = restExchange(urlString, HttpMethod.POST, HttpEntity(gson.toJson(template), headers))
        val data = reMap["data"] as MutableMap<String, Any>
        if ("API_200" == data["code"] || data["code"] == "200") {
            return ApiResponse(
                result = true,
                data = CommonUtils.mapToObj(data["data"] as MutableMap<String, Any>, KkoBrandTemplateDto::class.java) as KkoBrandTemplateDto,
                status = 200
            )
        } else {
            result["status"] = data["code"]!!.toString().replace("API_", "")
            result["msg"] = data["message"]!!
            
            return ApiResponse(
                result = false,
                msg = data["message"].toString(),
                status = data["code"]!!.toString().replace("API_", "").toInt()
            )
        }
    }
    
    override fun updateBrand(sendKey: String, template: KkoBrandTemplateDto): ApiResponse<KkoBrandTemplateDto> {
        val result: MutableMap<String, Any> = mutableMapOf()
        val token = getToken(url, recellVersion)
        
        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_JSON
        headers.set("Authorization", "Bearer $token")
        headers.set("version", recellVersion)
        headers.set("accept", MediaType.ALL_VALUE)
        headers.set("X-Sender-Key", sendKey)

        val urlString = "$url/$recellVersion/ftup/template/${clientId}/${template.templateCode}"
        val reMap: MutableMap<String, Any> = restExchange(urlString, HttpMethod.POST, HttpEntity(gson.toJson(template), headers))
        val data = reMap["data"] as MutableMap<String, Any>
        if ("API_200" == data["code"] || data["code"] == "200") {
            return ApiResponse(
                result = true,
                data = CommonUtils.mapToObj(data["data"] as MutableMap<String, Any>, KkoBrandTemplateDto::class.java) as KkoBrandTemplateDto,
                status = 200
            )
        } else {
            result["status"] = data["code"]!!.toString().replace("API_", "")
            result["msg"] = data["message"]!!
            
            return ApiResponse(
                result = false,
                msg = data["message"].toString(),
                status = data["code"]!!.toString().replace("API_", "").toInt()
            )
        }
    }
}
