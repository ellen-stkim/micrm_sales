package com.omnilab.micrm.model

import com.omnilab.micrm.model.table.Tblmi_block_lstDto
import org.apache.ibatis.type.Alias

@Alias("Block_searchDto")
class Block_searchDto : Tblmi_block_lstDto()  {
    var pageNo: Int = 1
    var firstIndex: Int?= null
    var recordCountPerPage: Int = 0
    var searchValue : String? = null
    var searchType : String? = null
    var block_reg_id : String? = null
    var block_upd_id : String? = null
    var usr_nm : String? = null
    var cd_nm : String? = null
    override fun toString(): String {
        return "Block_searchDto(pageNo=$pageNo, firstIndex=$firstIndex, recordCountPerPage=$recordCountPerPage, searchValue=$searchValue, searchType=$searchType, block_reg_id=$block_reg_id, block_upd_id=$block_upd_id, usr_nm=$usr_nm, cd_nm=$cd_nm)"
    }


}