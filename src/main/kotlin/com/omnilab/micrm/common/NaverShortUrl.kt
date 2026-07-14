package com.omnilab.micrm.common

import com.google.gson.GsonBuilder
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.http.HttpStatus
import org.springframework.http.RequestEntity
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Component
import org.springframework.web.client.RestTemplate
import org.springframework.web.util.UriComponentsBuilder

@Component("NaverShortUrl")
class NaverShortUrl {

    @Autowired
    @Qualifier("restTemplate")
    private lateinit var restTemplate: RestTemplate

    private val logger = LoggerFactory.getLogger("NaverShortUrl")

    fun shorten(uuid: String, clientId: String, clientSecret:String): String {
        try {
            val text: String = uuid
            val apiURL = "https://naveropenapi.apigw.ntruss.com/util/v1/shorturl"

            val uri = UriComponentsBuilder
                .fromUriString(apiURL)
                .queryParam("url", text)
                .build()
                .toUri()

            val requestEntity = RequestEntity
                .get(uri)
                .header("Content-Type", "application/json")
                .header("X-NCP-APIGW-API-KEY-ID", clientId)
                .header("X-NCP-APIGW-API-KEY", clientSecret)
                .build()
            val result: ResponseEntity<String> = restTemplate.exchange(requestEntity, String::class.java)
            return if (result.statusCode == HttpStatus.OK) {
                val gson = GsonBuilder().create()
                val json = gson.fromJson(result.body, Map::class.java)
                val url = (json["result"] as Map<String, String>)["url"]
                url ?: uuid
            } else {
                uuid
            }
        } catch (e:Exception) {
            logger.error("shorten {}", e)
            return uuid
        }
    }
}