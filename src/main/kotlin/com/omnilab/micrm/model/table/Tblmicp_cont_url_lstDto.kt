package com.omnilab.micrm.model.table

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias
import org.springframework.web.multipart.MultipartFile
import java.io.Serializable

@Alias("Tblmicp_cont_url_lstDto")
class Tblmicp_cont_url_lstDto: Tblmi_cont_url_lstDto {

    var cont_cd: Int? = null

    constructor()
    constructor(cont_cd: Int?){
        this.cont_cd = cont_cd
    }
    constructor(tbl_cont_url_lstDto: Tblmi_cont_url_lstDto){
        this.seq = tbl_cont_url_lstDto.seq
        this.cont_lst_cd = tbl_cont_url_lstDto.cont_lst_cd
        this.url_tag = tbl_cont_url_lstDto.url_tag
        this.url = tbl_cont_url_lstDto.url
        this.url_id = tbl_cont_url_lstDto.url_id
        this.url_type = tbl_cont_url_lstDto.url_type
        this.map_id = tbl_cont_url_lstDto.map_id
        this.map_cords = tbl_cont_url_lstDto.map_cords
    }

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }


}