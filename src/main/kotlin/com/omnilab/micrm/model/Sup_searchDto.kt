package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmi_supDto

class Sup_searchDto : Tblmi_supDto {

    var pageNo : Int? = null
    var searchType : String? = null
    var searchValue : String? = null
    var firstIndex : Int?= null
    var recordCountPerPage : Int?= null
    var camp_nm : String? = null

    constructor() : super()
}