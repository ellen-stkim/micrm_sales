package com.omnilab.micrm.repository

import com.omnilab.micrm.model.Contents_lstDto
import com.omnilab.micrm.model.table.*

interface CampaignSendDao {

    fun ins_send(dto: Tblmicp_campaignDto,  contTpLst: MutableMap<String, Contents_lstDto>): Int
    fun upd_send(map: MutableMap<String, Any>): Int
    fun del_send(map: MutableMap<String, Any>): Int

}