package com.omnilab.micrm.model.table

import org.apache.ibatis.type.Alias

@Alias("Tblmi_cont_lstDto")
open class Tblmi_cont_lstDto {

    var seq: Int? = null    // 시퀀스
    var cont_cd : Int?= null    // 컨텐츠 마스터 번호
    var cont_tp : String?= null // 컨텐츠 타입 (친구톡 / 문자 / RCS / 이메일 )
    var cont_sub : String?= null    // 제목
    var cont_top_body : String?= null    // 제목
    var cont_body : String ?= null  // 내용
    var from_to: String? = null
    var send_tp : String ?= null  // 발신유형(광고/안내)
    var send_to : String?= null // 발신번호/주소 (이메일 : 이메일, 모바일 :핸드폰번호)
    var send_nm : String?= null //발신자 명
    var thm_url : String ?= null    //썸네일 주소
    var br_yn : String ?= null  // 브라우저 보기 여부
    var sup_yn : String ?= null //수신거부 삽입 여부
    var msg_tp : String ?= null // 메세지 타입
    var kko_img_cd : Int?= null // (친구톡) 이미지 번호
    var kko_img_url : String?= null // (친구톡) 이미지 클릭 링크 주소
    var kko_btn_nm : String?= null  // (친구톡) 버튼 내용
    var kko_btn_url : String ?= null    // (친구톡) 버튼 클릭 주소
    var kko_btn_obj : String ?= null    // (알림톡) 버튼 내용
    var kko_etc_1 : String ?= null    // (알림톡) 개인화 변수1
    var kko_etc_2 : String ?= null    // (알림톡) 개인화 변수2
    var kko_etc_3 : String ?= null    // (알림톡) 개인화 변수3
    var kko_etc_4 : String ?= null    // (알림톡) 개인화 변수4
    var kko_etc_5 : String ?= null    // (알림톡) 개인화 변수5
    var kko_etc_6 : String ?= null    // (알림톡) 개인화 변수6
    var kko_etc_7 : String ?= null    // (알림톡) 개인화 변수7
    var kko_etc_8 : String ?= null    // (알림톡) 개인화 변수8
    var kko_etc_9 : String ?= null    // (알림톡) 개인화 변수9
    var kko_etc_10 : String ?= null    // (알림톡) 개인화 변수10
    var img_cd_1 : Int?= null   // 이미지 번호
    var img_cd_2 : Int?= null
    var img_cd_3 : Int?= null
    var img_cd_4 : Int?= null
    var img_cd_5 : Int?= null
    var img_cd_6 : Int?= null
    var rcs_btn_ins_tp : String?= null // RCS 버튼 타입
    var rcs_btn_cnt : String?= null // RCS 버튼 갯수
    var rcs_btn_obj : String?= null // RCS 버튼 Object 내용
    var rcs_btn_1 : String?= null   // 버튼내용
    var rcs_btn_tp_1 : String?= null    // 버튼 타입
    var rcs_btn_cont_1 : String?= null  // 버튼 컨텐츠
    var rcs_btn_2 : String?= null
    var rcs_btn_tp_2 : String?= null
    var rcs_btn_cont_2 : String?= null
    var rcs_btn_3 : String?= null
    var rcs_btn_tp_3 : String?= null
    var rcs_btn_cont_3 : String?= null
    var key_id : String ?= null // 템플릿 사용시 해당 키 아이디
    var cont_grp_cd : String?= null // 그룹 코드
    var rcs_footer : String?= null // rcs 수신거부
    var use_yn : String?= null
    var reg_id : String?= null
    var reg_dt : String?= null
    var upd_id : String ?= null
    var upd_dt : String ?= null

    constructor()
    constructor(seq: Int?){
        this.seq = seq
    }

    override fun toString(): String {
        return "Tblmi_cont_lstDto(seq=$seq, cont_cd=$cont_cd, cont_tp=$cont_tp, cont_sub=$cont_sub, cont_top_body=$cont_top_body, cont_body=$cont_body, from_to=$from_to, send_tp=$send_tp, send_to=$send_to, send_nm=$send_nm, thm_url=$thm_url, br_yn=$br_yn, sup_yn=$sup_yn, msg_tp=$msg_tp, kko_img_cd=$kko_img_cd, kko_img_url=$kko_img_url, kko_btn_nm=$kko_btn_nm, kko_btn_url=$kko_btn_url, kko_btn_obj=$kko_btn_obj, kko_etc_1=$kko_etc_1, kko_etc_2=$kko_etc_2, kko_etc_3=$kko_etc_3, kko_etc_4=$kko_etc_4, kko_etc_5=$kko_etc_5, kko_etc_6=$kko_etc_6, kko_etc_7=$kko_etc_7, kko_etc_8=$kko_etc_8, kko_etc_9=$kko_etc_9, kko_etc_10=$kko_etc_10, img_cd_1=$img_cd_1, img_cd_2=$img_cd_2, img_cd_3=$img_cd_3, img_cd_4=$img_cd_4, img_cd_5=$img_cd_5, img_cd_6=$img_cd_6, rcs_btn_ins_tp=$rcs_btn_ins_tp, rcs_btn_cnt=$rcs_btn_cnt, rcs_btn_obj=$rcs_btn_obj, rcs_btn_1=$rcs_btn_1, rcs_btn_tp_1=$rcs_btn_tp_1, rcs_btn_cont_1=$rcs_btn_cont_1, rcs_btn_2=$rcs_btn_2, rcs_btn_tp_2=$rcs_btn_tp_2, rcs_btn_cont_2=$rcs_btn_cont_2, rcs_btn_3=$rcs_btn_3, rcs_btn_tp_3=$rcs_btn_tp_3, rcs_btn_cont_3=$rcs_btn_cont_3, key_id=$key_id, cont_grp_cd=$cont_grp_cd, rcs_footer=$rcs_footer, use_yn=$use_yn, reg_id=$reg_id, reg_dt=$reg_dt, upd_id=$upd_id, upd_dt=$upd_dt)"
    }


}