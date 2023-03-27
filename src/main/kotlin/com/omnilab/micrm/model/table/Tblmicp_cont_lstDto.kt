package com.omnilab.micrm.model.table

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Tblmicp_cont_lstDto")
class Tblmicp_cont_lstDto: Tblmi_cont_lstDto {

    constructor() {}
    constructor(seq: Int?){
        this.seq = seq
    }

    constructor(cont_cd: Int?, reg_id: String?, cont_grp_cd: String?){
        this.cont_cd = cont_cd
        this.reg_id = reg_id
        this.cont_grp_cd = cont_grp_cd
    }
    constructor(cont_cd: Int?, reg_id: String?, cont_grp_cd: String?, use_yn: String){
        this.cont_cd = cont_cd
        this.reg_id = reg_id
        this.cont_grp_cd = cont_grp_cd
        this.use_yn = use_yn
    }
    constructor(tblmi_cont_lstDto: Tblmi_cont_lstDto){
        this.seq = tblmi_cont_lstDto.seq
        this.cont_cd = tblmi_cont_lstDto.cont_cd
        this.cont_tp = tblmi_cont_lstDto.cont_tp
        this.cont_sub = tblmi_cont_lstDto.cont_sub
        this.cont_top_body = tblmi_cont_lstDto.cont_top_body
        this.cont_body = tblmi_cont_lstDto.cont_body
        this.from_to = tblmi_cont_lstDto.from_to
        this.send_tp = tblmi_cont_lstDto.send_tp
        this.send_to = tblmi_cont_lstDto.send_to
        this.send_nm = tblmi_cont_lstDto.send_nm
        this.thm_url = tblmi_cont_lstDto.thm_url
        this.br_yn = tblmi_cont_lstDto.br_yn
        this.sup_yn = tblmi_cont_lstDto.sup_yn
        this.msg_tp = tblmi_cont_lstDto.msg_tp
        this.kko_img_cd = tblmi_cont_lstDto.kko_img_cd
        this.kko_img_url = tblmi_cont_lstDto.kko_img_url
        this.kko_btn_nm = tblmi_cont_lstDto.kko_btn_nm
        this.kko_btn_url = tblmi_cont_lstDto.kko_btn_url
        this.kko_msg_tp = tblmi_cont_lstDto.kko_msg_tp
        this.kko_btn_obj = tblmi_cont_lstDto.kko_btn_obj
        this.kko_price = tblmi_cont_lstDto.kko_price
        this.kko_currency_type = tblmi_cont_lstDto.kko_currency_type
        this.kko_title = tblmi_cont_lstDto.kko_title
        this.kko_header = tblmi_cont_lstDto.kko_header
        this.img_cd_1 = tblmi_cont_lstDto.img_cd_1
        this.img_cd_2 = tblmi_cont_lstDto.img_cd_2
        this.img_cd_3 = tblmi_cont_lstDto.img_cd_3
        this.img_cd_4 = tblmi_cont_lstDto.img_cd_4
        this.img_cd_5 = tblmi_cont_lstDto.img_cd_5
        this.img_cd_6 = tblmi_cont_lstDto.img_cd_6
        this.rcs_btn_ins_tp = tblmi_cont_lstDto.rcs_btn_ins_tp
        this.rcs_btn_cnt = tblmi_cont_lstDto.rcs_btn_cnt
        this.rcs_btn_obj = tblmi_cont_lstDto.rcs_btn_obj
        this.rcs_btn_1 = tblmi_cont_lstDto.rcs_btn_1
        this.rcs_btn_tp_1 = tblmi_cont_lstDto.rcs_btn_tp_1
        this.rcs_btn_cont_1 = tblmi_cont_lstDto.rcs_btn_cont_1
        this.rcs_btn_2 = tblmi_cont_lstDto.rcs_btn_2
        this.rcs_btn_tp_2 = tblmi_cont_lstDto.rcs_btn_tp_2
        this.rcs_btn_cont_2 = tblmi_cont_lstDto.rcs_btn_cont_2
        this.rcs_btn_3 = tblmi_cont_lstDto.rcs_btn_3
        this.rcs_btn_tp_3 = tblmi_cont_lstDto.rcs_btn_tp_3
        this.rcs_btn_cont_3 = tblmi_cont_lstDto.rcs_btn_cont_3
        this.key_id = tblmi_cont_lstDto.key_id
        this.cont_grp_cd = tblmi_cont_lstDto.cont_grp_cd
        this.rcs_footer = tblmi_cont_lstDto.rcs_footer
        this.use_yn = tblmi_cont_lstDto.use_yn
        this.reg_id = tblmi_cont_lstDto.reg_id
        this.reg_dt = tblmi_cont_lstDto.reg_dt
        this.upd_id = tblmi_cont_lstDto.upd_id
        this.upd_dt = tblmi_cont_lstDto.upd_dt
    }


    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }


}