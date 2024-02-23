package com.omnilab.micrm.model.table

import org.apache.ibatis.type.Alias

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
    constructor(contLstCd: Int?){
        this.cont_lst_cd = contLstCd
    }

    constructor(urlTag: String, url: String, urlId: String, contLstCd: Int){
        this.url_tag = urlTag
        this.url = url
        this.url_id = urlId
        this.cont_lst_cd = contLstCd
    }

    override fun toString(): String {
        return "Tblmi_cont_url_lstDto(seq=$seq, cont_lst_cd=$cont_lst_cd, url_tag=$url_tag, url=$url, url_id=$url_id, url_type=$url_type, map_id=$map_id, map_cords=$map_cords)"
    }


}