package com.omnilab.micrm.common

import com.google.gson.GsonBuilder
import org.json.simple.JSONObject
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

    fun shorten(uuid: String): String {
        try {

            val clientId = "rfsedehh6a" //애플리케이션 클라이언트 아이디값";
            val clientSecret = "Wgz9vBfeS8FzVY7WR00mcz02yhW0tDoXDzKnAGW3" //애플리케이션 클라이언트 시크릿값";


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
            if (result.statusCode == HttpStatus.OK) {
                val gson = GsonBuilder().create()
                val json = gson.fromJson(result.body, Map::class.java)
                val url = (json["result"] as Map<String, String>)["url"]
                return url ?: uuid
            } else {
                return uuid
            }
        } catch (e:Exception) {
            return uuid
        }
    }
}