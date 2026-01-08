package com.omnilab.micrm.model.table

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Tblmi_cont_lstDto")
open class Tblmi_cont_lstDto {

    var seq: Int? = null    // 시퀀스
    var cont_cd : Int?= null    // 컨텐츠 마스터 번호
    var cont_tp : String?= null // 컨텐츠 타입 (브랜드톡 / 문자 / RCS / 이메일 )
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
    var kko_img_cd : Int?= null // (브랜드톡) 이미지 번호
    var kko_img_url : String?= null // (브랜드톡) 이미지 클릭 링크 주소
    var kko_btn_nm : String?= null  // (브랜드톡) 버튼 내용
    var kko_btn_url : String ?= null    // (브랜드톡) 버튼 클릭 주소
    var kko_btn_urlPc : String ?= null    // (브랜드톡) 버튼 클릭 주소
    var kko_btn_nm2 : String?= null  // (브랜드톡) 버튼 내용
    var kko_btn_url2 : String ?= null    // (브랜드톡) 버튼 클릭 주소
    var kko_btn_urlPc2 : String ?= null    // (브랜드톡) 버튼 클릭 주소
    var kko_btn_nm3 : String?= null  // (브랜드톡) 버튼 내용
    var kko_btn_url3 : String ?= null    // (브랜드톡) 버튼 클릭 주소
    var kko_btn_urlPc3 : String ?= null    // (브랜드톡) 버튼 클릭 주소
    var kko_btn_nm4 : String?= null  // (브랜드톡) 버튼 내용
    var kko_btn_url4 : String ?= null    // (브랜드톡) 버튼 클릭 주소
    var kko_btn_urlPc4 : String ?= null    // (브랜드톡) 버튼 클릭 주소
    var kko_btn_nm5 : String?= null  // (브랜드톡) 버튼 내용
    var kko_btn_url5 : String ?= null    // (브랜드톡) 버튼 클릭 주소
    var kko_btn_urlPc5 : String ?= null    // (브랜드톡) 버튼 클릭 주소
    var kko_video_url: String? = null // (브랜드톡) 비디오 url
    var kko_thumbnail_img_cd: String? = null // (브랜드톡) 비디오 이미지 cd
    var kko_msg_tp : String ?= null    // (알림톡) 메세지 타입
    var kko_btn_obj : String ?= null    // (알림톡) 버튼 내용
    var kko_price : Int ?= null    // (알림톡) message 내 포함된 가격/금액/결제금액
    var kko_currency_type : String ?= null    // (알림톡)
    var kko_title : String ?= null    // (알림톡) 템플릿 내용 중 강조 표기할 핵심 정보 text(50)
    var kko_header : String ?= null    // (알림톡) 메시지 상단에 표기할 제목 text(16)

    var coupon_seq : String? = null // 쿠폰 시퀀스
    var short_url_yn : String? = null // 쿠폰 short url 사용 여부
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
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }


}