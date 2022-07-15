package com.omnilab.micrm.model.table

import org.apache.ibatis.type.Alias
import org.springframework.web.multipart.MultipartFile
import java.io.Serializable

@Alias("Tblmi_cont_url_lstDto")
open class Tblmi_cont_url_lstDto {

    var seq:Int? = null
    var cont_lst_cd:Int? = null
    var url_tag:String? = null
    var url:String? = null
    var url_id:String? = null
    var url_type:String? = null
    var map_id:String? = null
    var map_cords:String? = null

    constructor()
    constructor(cont_lst_cd: Int?){
        this.cont_lst_cd = cont_lst_cd
    }

    override fun toString(): String {
        return "Tblmi_cont_url_lstDto(seq=$seq, cont_lst_cd=$cont_lst_cd, url_tag=$url_tag, url=$url, url_id=$url_id, url_type=$url_type, map_id=$map_id, map_cords=$map_cords)"
    }


}