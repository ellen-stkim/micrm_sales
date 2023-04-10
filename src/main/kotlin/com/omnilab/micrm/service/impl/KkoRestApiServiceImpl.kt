package com.omnilab.micrm.service.impl

import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import com.omnilab.micrm.common.CommonUtils
import com.omnilab.micrm.model.table.kakao.Kko_at_tmplDto
import com.omnilab.micrm.repository.KkoAtTmplDao
import com.omnilab.micrm.common.FilenameAwareInputStreamResource
import com.omnilab.micrm.service.KkoRestApiService
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.beans.factory.annotation.Value
import org.springframework.http.*
import org.springframework.stereotype.Service
import org.springframework.util.LinkedMultiValueMap
import org.springframework.web.client.RestTemplate
import org.springframework.web.multipart.MultipartFile
import java.net.HttpURLConnection
import kotlin.math.log


@Service("KkoRestApiServiceImpl")
class KkoRestApiServiceImpl : KkoRestApiService {

    val logger = LoggerFactory.getLogger(this::class.java)

    @Value("\${variable.biz-url}")
    private lateinit var url: String

    @Value("\${variable.biz-msg-url}")
    private lateinit var mstUrl: String

    @Value("\${variable.biz-version}")
    private lateinit var version: String

    @Value("\${variable.biz-Auth}")
    private lateinit var auth: String

    @Autowired
    @Qualifier("restTemplate")
    private lateinit var restTemplate: RestTemplate


    @Autowired
    @Qualifier("KkoAtTmplDaoImpl")
    private lateinit var kkoAtTmplDao: KkoAtTmplDao

    override fun createAtTmpl(dto: Kko_at_tmplDto): MutableMap<String, Any> {
        val token = getToken(url);

        //        header 설정
        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_JSON
        headers.set("Authorization", "Bearer $token")
        headers.set("version", version)
        headers.set("accept", MediaType.ALL_VALUE)

        var urlString = "$url/$version/resell/template/create/${dto.send_key}"
        val gson = GsonBuilder().create()

        val re_map: MutableMap<String, Any> = restExchange(urlString!!, HttpMethod.POST, HttpEntity(gson.toJson(dto), headers))

        return re_map
    }

    override fun updateAtTmpl(newDto: Kko_at_tmplDto): MutableMap<String, Any> {
        val token = getToken(url);

        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_JSON
        headers.set("Authorization", "Bearer $token")
        headers.set("version", version)
        headers.set("accept", MediaType.ALL_VALUE)

        var urlString = "$url/$version/resell/template/modify/${newDto.send_key}"
        val gson = GsonBuilder().create()

        val re_map: MutableMap<String, Any> = restExchange(urlString!!, HttpMethod.PUT, HttpEntity(gson.toJson(newDto), headers))

        return re_map
    }

    override fun getTmplDetail(tmplCd: String?, sendKey: String?): MutableMap<String, Any> {
        val token = getToken(url)

        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_JSON
        headers.set("Authorization", "Bearer $token")
        headers.set("version", version)
        headers.set("accept", MediaType.ALL_VALUE)
        var urlString = "$url/$version/resell/template/select/$sendKey/$tmplCd"
        val re_map: MutableMap<String, Any> = restExchange(urlString!!, HttpMethod.GET, HttpEntity(null, headers))
        return re_map
    }

    override fun uploadTmplImg(file: MultipartFile): MutableMap<String, Any> {
        val token = getToken(url);
        //        header 설정
        val headers = HttpHeaders()
        headers.contentType = MediaType.MULTIPART_FORM_DATA
        headers.set("Authorization", "Bearer $token")
        headers.set("version", version)
        headers.set("accept", MediaType.ALL_VALUE)

        val urlString = "$url/$version/upload/image/alimtalk/template"

        val map = LinkedMultiValueMap<String, Any>()
        val resource = FilenameAwareInputStreamResource(file.inputStream, file.size, file.originalFilename.toString())
        map["image"] = resource

        val re_map: MutableMap<String, Any> = restExchange(urlString, HttpMethod.POST, HttpEntity(map, headers))

        return re_map

    }

    override fun uploadTmplItemImg(file: MultipartFile): MutableMap<String, Any>? {
        val token = getToken(url)

        val headers = HttpHeaders()
        headers.contentType = MediaType.MULTIPART_FORM_DATA
        headers.set("Authorization", "Bearer $token")
        headers.set("version", version)
        headers.set("accept", MediaType.ALL_VALUE)

        val urlString = "$url/$version/upload/image/alimtalk/itemHighlight"

        val map = LinkedMultiValueMap<String, Any>()
        val resource = FilenameAwareInputStreamResource(file.inputStream, file.size, file.originalFilename.toString())
        map["image"] = resource

        val re_map: MutableMap<String, Any> = restExchange(urlString, HttpMethod.POST, HttpEntity(map, headers))

        return re_map
    }

    override fun cancleKepReq(tmplCd: String?, sendKey: String?): MutableMap<String, Any>? {
        val token = getToken(url)

        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_JSON
        headers.set("Authorization", "Bearer $token")
        headers.set("version", version)
        headers.set("accept", MediaType.ALL_VALUE)
        var urlString = "$url/$version/resell/template/cancel/request/${sendKey}/${tmplCd}"

        return restExchange(urlString!!, HttpMethod.PUT, HttpEntity(null, headers))
    }

    override fun delTemplate(sendKey: String?, tmplCd: String?): MutableMap<String, Any> {
        val token = getToken(url);

        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_JSON
        headers.set("Authorization", "Bearer $token")
        headers.set("version", version)
        headers.set("accept", MediaType.ALL_VALUE)
        var urlString = "$url/$version/resell/template/cancel/request/${sendKey}/${tmplCd}"

        return restExchange(urlString!!, HttpMethod.PUT, HttpEntity(null, headers))
    }

    override fun cancleAppTemplate(sendKey: String?, tmplCd: String?): MutableMap<String, Any> {
        val token = getToken(url)

        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_JSON
        headers.set("Authorization", "Bearer $token")
        headers.set("version", version)
        headers.set("accept", MediaType.ALL_VALUE)
        var urlString = "$url/$version/resell/template/cancel/approval/${sendKey}/${tmplCd}"

        return restExchange(urlString!!, HttpMethod.PUT, HttpEntity(null, headers))
    }


    override fun uploadFtImg(file: MultipartFile, imgType: String): MutableMap<String, Any> {
        val token = getToken(mstUrl);
        //        header 설정
        val headers = HttpHeaders()
        headers.contentType = MediaType.MULTIPART_FORM_DATA
        headers.set("Authorization", "Bearer $token")
        headers.set("version", version)
        headers.set("accept", MediaType.ALL_VALUE)

        val urlString = if("IMGTP03".equals(imgType)) "$mstUrl/$version/upload/ft/image"
                            else "$mstUrl/$version/upload/ft/wide/image"

        val map = LinkedMultiValueMap<String, Any>()
        val resource = FilenameAwareInputStreamResource(file.inputStream, file.size, file.originalFilename.toString())
        map["image"] = resource

        val re_map: MutableMap<String, Any> = restExchange(urlString, HttpMethod.POST, HttpEntity(map, headers))

        return re_map
    }


    override fun sendSenderKeyToken(param: java.util.HashMap<String, String>): MutableMap<String, Any> {
        val result: MutableMap<String, Any> = mutableMapOf()
        try {
            val token = getToken(url);
            //        header 설정
            val headers = HttpHeaders()
            headers.contentType = MediaType.APPLICATION_JSON
            headers.set("Authorization", "Bearer $token")
            headers.set("version", version)
            headers.set("accept", MediaType.ALL_VALUE)

            val chanId = param.get("channelId")
            val phoneNum = param.get("phoneNum")
            val urlString = "$url/$version/sendProfile/token?yellowId=$chanId&phoneNumber=$phoneNum"

            val re_map: MutableMap<String, Any> = restExchange(urlString, HttpMethod.GET, HttpEntity(null, headers))

            val data = re_map["data"] as MutableMap<String, Any>

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
        val result: MutableMap<String, Any> = mutableMapOf()
        val token = getToken(url)
        //        header 설정
        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_JSON
        headers.set("Authorization", "Bearer $token")
        headers.set("version", version)
        headers.set("accept", MediaType.ALL_VALUE)

        headers.set("token", map["token"]?.toString())
        headers.set("phoneNumber", map["phoneNumber"]?.toString())

        val urlString = "$url/$version/sendProfile/create"
        val bodyMap = HashMap<String, String>()
        bodyMap["yellowId"] = map["yellowId"] as String
        bodyMap["categoryCode"] = map["cateCd"] as String
        bodyMap["channelKey"] = "base"

        val gson = GsonBuilder().create()

        val re_map: MutableMap<String, Any> = restExchange(urlString, HttpMethod.POST, HttpEntity(gson.toJson(bodyMap), headers))
        val data = re_map["data"] as MutableMap<String, Any>

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
        val token = getToken(url)
        //        header 설정
        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_JSON
        headers.set("Authorization", "Bearer $token")
        headers.set("version", version)
        headers.set("accept", MediaType.ALL_VALUE)

        val urlString = "$url/$version/sendProfile/select"

        val re_map: MutableMap<String, Any> = restExchange(urlString, HttpMethod.GET, HttpEntity(null, headers))
        val data = re_map["data"] as MutableMap<String, Any>

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
        val token = getToken(url)
        //        header 설정
        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_JSON
        headers.set("Authorization", "Bearer $token")
        headers.set("version", version)
        headers.set("accept", MediaType.ALL_VALUE)

        bodyMap["offerCd"] = "API"

        val gson = GsonBuilder().create()

        val urlString = "$url/$version/resell/client/create"

        val re_map: MutableMap<String, Any> =
            restExchange(urlString, HttpMethod.POST, HttpEntity(gson.toJson(bodyMap), headers))

        val data = re_map["data"] as MutableMap<String, Any>
        if ("API_200" == data["code"]) {
            result["status"] = 200
            result["data"] = data
        } else {
            result["status"] = data["code"]!!.toString().replace("API_", "")
            result["msg"] = data["message"]!!
        }
        return result
    }

    private fun getToken(thisUrl:String): String {

        val headers = HttpHeaders()
        headers.contentType = MediaType.APPLICATION_FORM_URLENCODED
        headers.set("Authorization", auth)
        headers.set("version", version)
        headers.set("accept", MediaType.ALL_VALUE)

        val map: MutableMap<String, Any> = HashMap()
        map["grant_type"] = "api"

        val gson = GsonBuilder().create()
        val urlString = "$thisUrl/$version/oauth/token"
        val re_map: MutableMap<String, Any> =
            restExchange(urlString, HttpMethod.POST, HttpEntity(gson.toJson(map), headers));

        val data = re_map["data"] as MutableMap<String, Any>

        return data["access_token"] as String
    }


    private fun restExchange(urlString: String, method: HttpMethod, httpEntity: HttpEntity<Any>): MutableMap<String, Any> {

        val result: ResponseEntity<String> = restTemplate.exchange(urlString, method, httpEntity, String::class.java)
        val status = result.statusCode.value()
        val re_map: MutableMap<String, Any> = HashMap()
        re_map["result"] = status >= HttpURLConnection.HTTP_OK && status < HttpURLConnection.HTTP_MULT_CHOICE
        if (result.body == null) {
            re_map["data"] = ""
        } else {
            val body = result.body!!
            val bodyMap: Map<String, Any> = GsonBuilder().create().fromJson(body, object : TypeToken<Map<String, Any>>() {}.type)
            re_map["data"] = bodyMap

        }
        return re_map
    }


}
