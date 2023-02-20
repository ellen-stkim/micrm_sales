package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmi_supDto
import com.omnilab.micrm.model.table.Tblmire_send_hstDto
import org.apache.poi.hpsf.Decimal
import java.math.BigDecimal

class SearchSendCostDto : SendCostDto {

    var pageNo : Int = 1
    var pageSize : Int = 10

    var firstIndex : Int? = 0
    var recordCountPerPage : Int = 10

    constructor() : super()
}