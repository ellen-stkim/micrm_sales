package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmi_kko_at_tmplDto

class AtTmpl_searchDto : Tblmi_kko_at_tmplDto {

    var pageNo : Int = 1
    var searchType : String? = null
    var searchValue : String? = null
    var firstIndex : Int?= null
    var recordCountPerPage : Int?= null

    constructor() : super()
}