package com.omnilab.micrm.model.table

import org.apache.ibatis.type.Alias
import org.springframework.web.multipart.MultipartFile
import java.io.Serializable

@Alias("Tblmi_tbl_sumDto")
class Tblmi_tbl_sumDto {

    var seq: Int? = null
    var tbl_id: String? = null
    var total_cnt: String? = null
    var edm_send_cnt: String? = null
    var mdm_send_cnt: String? = null
    var edm_agree_cnt: String? = null
    var mdm_agree_cnt: String? = null
    var edm_err_cnt: String? = null
    var mdm_err_cnt: String? = null
    var nm_cnt: String? = null
    var nm_duple_cnt: String? = null
    var edm_cnt: String? = null
    var edm_duple_cnt: String? = null
    var mdm_cnt: String? = null
    var mdm_duple_cnt: String? = null
    var id_cnt: String? = null
    var id_duple_cnt: String? = null
    var gd_m_cnt: String? = null
    var gd_f_cnt: String? = null
    var gd_n_cnt: String? = null
    var reg_id: String? = null
    var reg_dt: String? = null
    var upd_id: String? = null
    var upd_dt: String? = null


}