package com.omnilab.micrm.model

import org.apache.ibatis.type.Alias
import org.springframework.web.multipart.MultipartFile

@Alias("ThumbParseDto")
class ThumbParseDto {
    var filename: String? = null
    var file: MultipartFile? = null
    var templist: List<String>? = null
}