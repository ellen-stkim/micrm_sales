package com.omnilab.micrm.repository

import com.omnilab.micrm.model.SalesforceDto
import com.omnilab.micrm.model.table.*

interface SalesforceDao {

    fun sel_usrInfo(dto: SalesforceDto): Tblmi_usrDto?
    fun mappingLst(dto: SalesforceDto): MutableList<SalesforceDto>
    fun sel_tblmi_cont_mstOne(dto: Tblmi_cont_mstDto): Tblmi_cont_mstDto
    fun sel_tblmi_cont_lst(dto: Tblmi_cont_lstDto): MutableList<Tblmi_cont_lstDto>
    fun sel_tblmicp_cont_mst(dto: Tblmicp_cont_mstDto): MutableList<Tblmicp_cont_mstDto>

    //fun ins_tblmicp_cont(dto: Tblmicp_cont_mstDto): Boolean
    fun ins_tblmicp_cont_mst(dto: Tblmicp_cont_mstDto): Int
    fun ins_tblmicp_cont_lst(dto: Tblmicp_cont_lstDto): Int
    fun ins_tblmicp_cont_url_lst(dto: MutableMap<String, Any>): Int

    fun upd_usrInfo(dto: Tblmi_usrDto): Int
    fun upd_tblmicp_cont_mst(dto: Tblmicp_cont_mstDto): Int

    fun del_tblmicp_cont_url_lst(dto: Tblmicp_cont_url_lstDto): Int
}