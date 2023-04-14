package com.omnilab.micrm.model.table

import org.apache.ibatis.type.Alias

@Alias("Tblmicou_img_fileDto")
class Tblmicou_img_fileDto {

    var seq: Int? = null
    var img_url: String? = null
    var img_org_name: String? = null
    var img_file_name: String? = null
    var del_yn: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null

    constructor(reg_id: String, img_org_name: String, img_file_name: String, img_url: String) {
        this.reg_id = reg_id
        this.img_url = img_url
        this.img_org_name = img_org_name
        this.img_file_name = img_file_name
    }

}