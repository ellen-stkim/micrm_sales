package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmi_kko_at_tmplDto

class AtTmpl_searchDto : Tblmi_kko_at_tmplDto() {

    var usr_grp_cd: String? = null
    var pageNo : Int = 1
    var searchType : String? = null
    var searchValue : String? = null
    var firstIndex : Int?= null
    var recordCountPerPage : Int?= null
    var reg_dt_range: String? = null
    var ex_tmpl_nm: String? = null

    var chan_id: String? = null


}