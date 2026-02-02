package com.omnilab.micrm.model.table

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Tblmicp_cont_lstDto")
class Tblmicp_cont_lstDto: Tblmi_cont_lstDto {

    constructor()
    constructor(seq: Int?){
        this.seq = seq
    }

    constructor(contCd: Int?, regId: String?, contGrpCd: String?){
        this.cont_cd = contCd
        this.reg_id = regId
        this.cont_grp_cd = contGrpCd
    }
    constructor(contCd: Int?, regId: String?, contGrpCd: String?, useYn: String){
        this.cont_cd = contCd
        this.reg_id = regId
        this.cont_grp_cd = contGrpCd
        this.use_yn = useYn
    }
    constructor(tblmiContLstdto: Tblmi_cont_lstDto){
        this.seq = tblmiContLstdto.seq
        this.cont_cd = tblmiContLstdto.cont_cd
        this.cont_tp = tblmiContLstdto.cont_tp
        this.cont_sub = tblmiContLstdto.cont_sub
        this.cont_top_body = tblmiContLstdto.cont_top_body
        this.cont_body = tblmiContLstdto.cont_body
        this.from_to = tblmiContLstdto.from_to
        this.send_tp = tblmiContLstdto.send_tp
        this.send_to = tblmiContLstdto.send_to
        this.send_nm = tblmiContLstdto.send_nm
        this.thm_url = tblmiContLstdto.thm_url
        this.br_yn = tblmiContLstdto.br_yn
        this.sup_yn = tblmiContLstdto.sup_yn
        this.msg_tp = tblmiContLstdto.msg_tp
        this.kko_img_cd = tblmiContLstdto.kko_img_cd
        this.kko_img_url = tblmiContLstdto.kko_img_url
        this.kko_btn_nm = tblmiContLstdto.kko_btn_nm
        this.kko_btn_url = tblmiContLstdto.kko_btn_url
        this.kko_btn_urlPc = tblmiContLstdto.kko_btn_urlPc
        this.kko_btn_nm2 = tblmiContLstdto.kko_btn_nm2
        this.kko_btn_url2 = tblmiContLstdto.kko_btn_url2
        this.kko_btn_urlPc2 = tblmiContLstdto.kko_btn_urlPc2
        this.kko_btn_nm3 = tblmiContLstdto.kko_btn_nm3
        this.kko_btn_url3 = tblmiContLstdto.kko_btn_url3
        this.kko_btn_urlPc3 = tblmiContLstdto.kko_btn_urlPc3
        this.kko_btn_nm4 = tblmiContLstdto.kko_btn_nm4
        this.kko_btn_url4 = tblmiContLstdto.kko_btn_url4
        this.kko_btn_urlPc4 = tblmiContLstdto.kko_btn_urlPc4
        this.kko_btn_nm5 = tblmiContLstdto.kko_btn_nm5
        this.kko_btn_url5 = tblmiContLstdto.kko_btn_url5
        this.kko_btn_urlPc5 = tblmiContLstdto.kko_btn_urlPc5
        this.kko_msg_tp = tblmiContLstdto.kko_msg_tp
        this.kko_btn_obj = tblmiContLstdto.kko_btn_obj
        this.kko_price = tblmiContLstdto.kko_price
        this.kko_currency_type = tblmiContLstdto.kko_currency_type
        this.kko_title = tblmiContLstdto.kko_title
        this.kko_header = tblmiContLstdto.kko_header
        this.coupon_seq = tblmiContLstdto.coupon_seq
        this.short_url_yn = tblmiContLstdto.short_url_yn
        this.img_cd_1 = tblmiContLstdto.img_cd_1
        this.img_cd_2 = tblmiContLstdto.img_cd_2
        this.img_cd_3 = tblmiContLstdto.img_cd_3
        this.img_cd_4 = tblmiContLstdto.img_cd_4
        this.img_cd_5 = tblmiContLstdto.img_cd_5
        this.img_cd_6 = tblmiContLstdto.img_cd_6
        this.rcs_btn_ins_tp = tblmiContLstdto.rcs_btn_ins_tp
        this.rcs_btn_cnt = tblmiContLstdto.rcs_btn_cnt
        this.rcs_btn_obj = tblmiContLstdto.rcs_btn_obj
        this.rcs_btn_1 = tblmiContLstdto.rcs_btn_1
        this.rcs_btn_tp_1 = tblmiContLstdto.rcs_btn_tp_1
        this.rcs_btn_cont_1 = tblmiContLstdto.rcs_btn_cont_1
        this.rcs_btn_2 = tblmiContLstdto.rcs_btn_2
        this.rcs_btn_tp_2 = tblmiContLstdto.rcs_btn_tp_2
        this.rcs_btn_cont_2 = tblmiContLstdto.rcs_btn_cont_2
        this.rcs_btn_3 = tblmiContLstdto.rcs_btn_3
        this.rcs_btn_tp_3 = tblmiContLstdto.rcs_btn_tp_3
        this.rcs_btn_cont_3 = tblmiContLstdto.rcs_btn_cont_3
        this.key_id = tblmiContLstdto.key_id
        this.cont_grp_cd = tblmiContLstdto.cont_grp_cd
        this.rcs_footer = tblmiContLstdto.rcs_footer
        this.use_yn = tblmiContLstdto.use_yn
        this.reg_id = tblmiContLstdto.reg_id
        this.reg_dt = tblmiContLstdto.reg_dt
        this.upd_id = tblmiContLstdto.upd_id
        this.upd_dt = tblmiContLstdto.upd_dt
        this.kko_video_url = tblmiContLstdto.kko_video_url
        this.kko_thumbnail_img_cd = tblmiContLstdto.kko_thumbnail_img_cd
        this.kko_item_json = tblmiContLstdto.kko_item_json
        this.kko_carousel_json = tblmiContLstdto.kko_carousel_json
        this.kko_head_json = tblmiContLstdto.kko_head_json
    }

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}