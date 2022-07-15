package com.omnilab.micrm.model.table

import org.apache.ibatis.type.Alias
import org.springframework.web.multipart.MultipartFile

@Alias("Tblmi_group_listDto")
open class Tblmi_group_listDto  {

    var seq:Int? = null
    var grp_nm: String? = null
    var grp_cnt : Int? = null
    var usr_grp_cd: String? = null
    var status: Char? = null
    var use_yn : String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null
    var excelFileData : MultipartFile ?= null
    var work_seq : Int?= null

    constructor() : super()

    override fun toString(): String {
        return "Tblmi_group_listDto(seq=$seq, grp_nm=$grp_nm, grp_cnt=$grp_cnt, usr_grp_cd=$usr_grp_cd, status=$status, use_yn=$use_yn, reg_id=$reg_id, reg_dt=$reg_dt, upd_id=$upd_id, upd_dt=$upd_dt, excelFileData=$excelFileData, work_seq=$work_seq)"
    }

}