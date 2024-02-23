package com.omnilab.micrm.model

import com.google.gson.GsonBuilder
import com.omnilab.micrm.model.table.Tblmi_cont_mstDto
import org.apache.ibatis.type.Alias


@Alias("Content_view_Dto")
class Content_view_Dto : Tblmi_cont_mstDto() {

    var list_seq: Int? = null    // 시퀀스
    var cont_cd: Int? = null    // 컨텐츠 마스터 번호
    var cont_tp: String? = null // 컨텐츠 타입 (친구톡 / 문자 / RCS / 이메일 )
    var cont_sub: String? = null    // 제목
    var cont_top_body: String? = null    // 제목
    var cont_body: String? = null  // 내용
    var send_tp: String? = null  // 발신유형(광고/내용)
    var send_tp_nm: String? = null  // 발신유형명
    var send_to: String? = null // 발신번호/주소 (이메일 : 이메일, 모바일 :핸드폰번호)
    var send_nm: String? = null //발신자 명
    var thm_url: String? = null    //썸네일 주소
    var br_yn: String? = null  // 브라우저 보기 여부
    var sup_yn: String? = null //수신거부 삽입 여부
    var msg_tp: String? = null // 메세지 타입
    var kko_img_cd: Int? = null // (친구톡) 이미지 번호
    var kko_img_url: String? = null // (친구톡) 이미지 클릭 링크 주소
    var kko_btn_nm: String? = null  // (친구톡) 버튼 내용
    var kko_img_nm: String? = null // 카카오 이미지 명
    var kko_btn_url: String? = null    // (친구톡) 버튼 클릭 주소
    var kko_btn_nm2: String? = null  // (친구톡) 버튼 내용
    var kko_btn_url2: String? = null    // (친구톡) 버튼 클릭 주소
    var kko_btn_nm3: String? = null  // (친구톡) 버튼 내용
    var kko_btn_url3: String? = null    // (친구톡) 버튼 클릭 주소
    var kko_btn_nm4: String? = null  // (친구톡) 버튼 내용
    var kko_btn_url4: String? = null    // (친구톡) 버튼 클릭 주소
    var kko_btn_nm5: String? = null  // (친구톡) 버튼 내용
    var kko_btn_url5: String? = null    // (친구톡) 버튼 클릭 주소
    var kko_img_lst: String? = null //
    var coupon_seq: String? = null // 선택한 쿠폰 시퀀스
    var coupon_nm: String? = null // 선택한 쿠폰명
    var short_url_yn: String? = null // short url 사용 여부
    var img_cd_1: Int? = null   // 이미지 번호
    var img_cd_2: Int? = null
    var img_cd_3: Int? = null
    var img_cd_4: Int? = null
    var img_cd_5: Int? = null
    var img_cd_6: Int? = null
    var rcs_btn_obj: String? = null // rcs object 형태
    var rcs_btn_1: String? = null   // 버튼내용
    var rcs_btn_tp_1: String? = null    // 버튼 타입
    var rcs_btn_cont_1: String? = null  // 버튼 컨텐츠
    var rcs_btn_2: String? = null
    var rcs_btn_tp_2: String? = null
    var rcs_btn_cont_2: String? = null
    var rcs_btn_3: String? = null
    var rcs_btn_tp_3: String? = null
    var rcs_btn_cont_3: String? = null
    var key_id: String? = null // 템플릿 사용시 해당 키 아이디
    var list_use_yn: String? = null
    var list_reg_id: String? = null
    var list_reg_dt: String? = null
    var list_upd_id: String? = null
    var list_upd_dt: String? = null
    var rcs_footer: String? = null

    var img_org_nm: String? = null
    var img_nm: String? = null
    var image_db_url: String? = null

    var slideTitle: MutableList<String> = mutableListOf()
    var slideBody: MutableList<String> = mutableListOf()
    var img_lst: String? = null
    var img_nm_lst: String? = null
    var send_num: String? = null
    var sender: String? = null

    var cardSize: String? = null

    var team_nm: String? = null


    // 수정을 위한 버튼 뷰 뿌리기

    // 버튼명
    var btnText: MutableList<String>? = mutableListOf()

    // 버튼 데이터
    //var btnData : MutableList<String> ?= mutableListOf()

    var btnData: MutableList<List<String>>? = mutableListOf()

    // 버튼 타입
    var btnType: MutableList<String>? = mutableListOf()
    var slideBtnType: MutableList<MutableList<String>?>? = mutableListOf()

    // btn_데이터 뿌려주기
    var cont_btn_json: List<MutableMap<String, Any>>? = null
        get() = if (!rcs_btn_obj.isNullOrEmpty() && field == null) {
            val g = GsonBuilder().create();
            val obj = g.fromJson(rcs_btn_obj, Object::class.java)
            val lst = ArrayList<MutableMap<String, Any>>()
            when (obj) {
                is List<*> -> {
                    for (i in obj) {
                        if (i is Map<*, *>) {
                            lst.add(i as MutableMap<String, Any>)
                        } else {
                            lst.add(g.fromJson(i.toString(), Map::class.java) as MutableMap<String, Any>)
                        }
                    }
                    lst
                }
                is Map<*, *> -> {
                    lst.add(obj as MutableMap<String, Any>)
                    lst
                }
                else -> {
                    ArrayList()
                }
            }
        } else {
            ArrayList()
        }

    // 알림톡 변수
    var tmpl_nm: String? = null
    var tmpl_cd: String? = null
    var tmpl_msg_tp: String? = null
    var tmpl_ext: String? = null
    var tmpl_ad: String? = null
    var tmpl_tit: String? = null
    var tmpl_subtit: String? = null
    var tmpl_empsize_tp: String? = null
    var tmpl_header: String? = null
    var button_json: String? = null
    var quick_repl_json: String? = null
    var item_highlight_json: String? = null
    var item_img_seq: Int? = null
    var item_json: String? = null

    var btn_json: ArrayList<MutableMap<String, Any>>? = null
        get() = if (!button_json.isNullOrEmpty() && field == null) {
            val g = GsonBuilder().create();
            val obj = g.fromJson(button_json, Object::class.java)
            val lst = ArrayList<MutableMap<String, Any>>()
            if(obj is List<*>){
                for(i in obj){
                    if (i is Map<*, *>) {
                        lst.add(i as MutableMap<String, Any>)
                    }else {
                        lst.add(g.fromJson(i.toString() , Map::class.java)  as MutableMap<String, Any>)
                    }
                }
                lst
            }else if(obj is Map<*, *>){
                lst.add(obj as MutableMap<String, Any>)
                lst
            } else{
                ArrayList()
            }
        } else{
            ArrayList()
        }

    var highlight_json: Object? = null
        get() = if (!item_highlight_json.isNullOrEmpty() && field == null) {
            val g = GsonBuilder().create();
            val obj = g.fromJson(item_highlight_json, Object::class.java)
            obj
        } else{
            Object()
        }

    var item_list_json: Object? = null
        get() = if (!item_json.isNullOrEmpty() && field == null) {
            val g = GsonBuilder().create();
            val obj = g.fromJson(item_json, Object::class.java)
            obj
        } else{
            Object()
        }

    var from_to: String? = null

    var at_btn_obj :String? = null
    var at_btn_json: ArrayList<MutableMap<String, Any>>? = null
        get() = if (!at_btn_obj.isNullOrEmpty() && field == null) {
            val g = GsonBuilder().create();
            val obj = g.fromJson(at_btn_obj, Object::class.java)
            val lst = ArrayList<MutableMap<String, Any>>()
            if(obj is List<*>){
                for(i in obj){
                    if (i is Map<*, *>) {
                        lst.add(i as MutableMap<String, Any>)
                    }else {
                        lst.add(g.fromJson(i.toString() , Map::class.java)  as MutableMap<String, Any>)
                    }
                }
                lst
            }else if(obj is Map<*, *>){
                lst.add(obj as MutableMap<String, Any>)
                lst
            } else{
                ArrayList()
            }
        } else{
            ArrayList()
        }
}


