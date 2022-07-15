package com.omnilab.micrm.model

import org.apache.ibatis.type.Alias
import org.springframework.web.multipart.MultipartFile
import java.io.Serializable

class Email_url_lstDto {

    var url_tag:Array<String>? = null
    var url:Array<String>? = null
    var url_id:Array<String>? = null
    var url_type:Array<String>? = null
    var map_id:Array<String>? = null
    var map_cords:Array<String>? = null

    override fun toString(): String {
        return "Email_url_lstDto(url_tag=${url_tag?.contentToString()}, url=${url?.contentToString()}, url_id=${url_id?.contentToString()}, url_type=${url_type?.contentToString()}, map_id=${map_id?.contentToString()}, map_cords=${map_cords?.contentToString()})"
    }


}