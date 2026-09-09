package com.omnilab.micrm.repository

import com.omnilab.micrm.model.BanWordHst_searchDto
import com.omnilab.micrm.model.table.*

interface CommonDao {

    fun sel_tblmi_usrOne(dto: Tblmi_usrDto): Tblmi_usrDto

    fun sel_tblmi_usr(dto: Tblmi_usrDto): List<Tblmi_usrDto>

    fun insertUserHistoryLog(dto : Tblmi_usr_hstDto) :Int

    fun ins_tblmi_ban_word_hst(dto : Tblmi_ban_word_hstDto) :Int

    fun sel_tblmi_ban_word_hstCnt(dto : BanWordHst_searchDto) :Int

    fun sel_tblmi_ban_word_hst(dto : BanWordHst_searchDto) :List<Tblmi_ban_word_hstDto>

}