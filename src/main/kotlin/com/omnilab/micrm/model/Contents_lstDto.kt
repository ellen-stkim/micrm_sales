package com.omnilab.micrm.model

import com.google.gson.GsonBuilder
import com.omnilab.micrm.model.table.Tblmi_cont_lstDto
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Contents_lstDto")
class Contents_lstDto: Tblmi_cont_lstDto() {

    var cont_nm: String? = null
    var send_tp_nm: String? = null
    var msg_tp_nm: String? = null
    var msg_tp_val: String? = null
    var ch_tp: String? = null
    var del_yn: String? = null
    var cont_tp_lst: String? = null
    var cont_tp_lst_nm: String? = null
    var cont_tp_nm: String? = null
    var kko_image_url: String? = null
    var kko_image_file_nm: String? = null
    var kko_server_image_url: String? = null
    var kko_server_image_url_video: String? = null
    var img_lst: String? = null
    var cont_body_json : List<MutableMap<String, Any>>? = null
        get() = if (!cont_body.isNullOrBlank() && field == null) {
            val obj = GsonBuilder().create().fromJson(cont_body, Object::class.java)
            when (obj) {
                is List<*> -> {
                    obj as MutableList<MutableMap<String, Any>>
                }

                is Map<*, *> -> {
                    val lst = ArrayList<MutableMap<String, Any>>()
                    lst.add(obj as MutableMap<String, Any>)
                    lst
                }

                else -> {
                    ArrayList()
                }
            }
        } else{
            ArrayList()
        }
    var cont_btn_json: List<MutableMap<String, Any>>? = null
        get() = if (!rcs_btn_obj.isNullOrBlank() && field == null) {
            val g = GsonBuilder().create();
            val obj = g.fromJson(rcs_btn_obj, Object::class.java)
            val lst = ArrayList<MutableMap<String, Any>>()
            when (obj) {
                is List<*> -> {
                    for(i in obj){
                        if (i is Map<*, *>) {
                            lst.add(i as MutableMap<String, Any>)
                        }else {
                            lst.add(g.fromJson(i.toString() , Map::class.java)  as MutableMap<String, Any>)
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
        } else{
            ArrayList()
        }

    var img_nm_lst : String ?= null
    // 뷰에 뿌려주기 위한 Slide
    var slideTitle : MutableList<String> = mutableListOf()
    var slideBody : MutableList<String> = mutableListOf()
    var msg_tp_lst : String? = null


    // 알림톡 변수
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
        get() = if (!button_json.isNullOrBlank() && field == null) {
            val g = GsonBuilder().create();
            val obj = g.fromJson(button_json, Object::class.java)
            val lst = ArrayList<MutableMap<String, Any>>()
            when (obj) {
                is List<*> -> {
                    for(i in obj){
                        if (i is Map<*, *>) {
                            lst.add(i as MutableMap<String, Any>)
                        }else {
                            lst.add(g.fromJson(i.toString() , Map::class.java)  as MutableMap<String, Any>)
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
        } else{
            ArrayList()
        }

    var highlight_json: Any? = null
        get() = if (!item_highlight_json.isNullOrBlank() && field == null) {
            val g = GsonBuilder().create();
            val obj = g.fromJson(item_highlight_json, Object::class.java)
            obj
        } else{
            Object()
        }

    var item_list_json: Any? = null
        get() = if (!item_json.isNullOrBlank() && field == null) {
            val g = GsonBuilder().create();
            val obj = g.fromJson(item_json, Object::class.java)
            obj
        } else{
            Object()
        }

    var cardSize : String? = null
    var kakaoImageItemNm0: String? = null
    var kakaoImageItemNm1: String? = null
    var kakaoImageItemNm2: String? = null
    var kakaoImageItemNm3: String? = null
    var kakaoImageItemNm4: String? = null
    var kakaoImageItemNm5: String? = null
    var kakaoImageItemNm6: String? = null
    var kakao_item_img_cd_0: String? = null
    var kakao_item_img_cd_1: String? = null
    var kakao_item_img_cd_2: String? = null
    var kakao_item_img_cd_3: String? = null
    var kakao_item_img_cd_4: String? = null
    var kko_view_item_img_url_0: String? = null
    var kko_view_item_img_url_1: String? = null
    var kko_view_item_img_url_2: String? = null
    var kko_view_item_img_url_3: String? = null
    var kko_view_item_img_url_4: String? = null
    var kko_view_item_img_url_5: String? = null
    var kko_view_item_img_url_6: String? = null
    var kkoItemLst1: String? = null
    var kkoItemLst2: String? = null
    var kkoItemLst3: String? = null
    var kkoItemLst4: String? = null
    var kkoItemUrlLstPc1: String? = null
    var kkoItemUrlLstPc2: String? = null
    var kkoItemUrlLstPc3: String? = null
    var kkoItemUrlLstPc4: String? = null
    var kkoItemUrlLstMo1: String? = null
    var kkoItemUrlLstMo2: String? = null
    var kkoItemUrlLstMo3: String? = null
    var kkoItemUrlLstMo4: String? = null
    var kkoHeader0: String? = null
    var kkoHeader1: String? = null
    var kkoHeader2: String? = null
    var kkoHeader3: String? = null
    var kkoHeader4: String? = null
    var kkoHeader5: String? = null
    var kkoHeader6: String? = null
    var kkoBody0: String? = null
    var kkoBody1: String? = null
    var kkoBody2: String? = null
    var kkoBody3: String? = null
    var kkoBody4: String? = null
    var kkoBody5: String? = null
    var kkoBody6: String? = null
    var kkoBtnLst1_1: String? = null
    var kkoBtnLst1_2: String? = null
    var kkoBtnLst2_1: String? = null
    var kkoBtnLst2_2: String? = null
    var kkoBtnLst3_1: String? = null
    var kkoBtnLst3_2: String? = null
    var kkoBtnLst4_1: String? = null
    var kkoBtnLst4_2: String? = null
    var kkoBtnLst5_1: String? = null
    var kkoBtnLst5_2: String? = null
    var kkoBtnLst6_1: String? = null
    var kkoBtnLst6_2: String? = null
    var kkoBtnUrlLstPc1_1: String? = null
    var kkoBtnUrlLstPc1_2: String? = null
    var kkoBtnUrlLstPc2_1: String? = null
    var kkoBtnUrlLstPc2_2: String? = null
    var kkoBtnUrlLstPc3_1: String? = null
    var kkoBtnUrlLstPc3_2: String? = null
    var kkoBtnUrlLstPc4_1: String? = null
    var kkoBtnUrlLstPc4_2: String? = null
    var kkoBtnUrlLstPc5_1: String? = null
    var kkoBtnUrlLstPc5_2: String? = null
    var kkoBtnUrlLstPc6_1: String? = null
    var kkoBtnUrlLstPc6_2: String? = null
    var kkoBtnUrlLstMo1_1: String? = null
    var kkoBtnUrlLstMo1_2: String? = null
    var kkoBtnUrlLstMo2_1: String? = null
    var kkoBtnUrlLstMo2_2: String? = null
    var kkoBtnUrlLstMo3_1: String? = null
    var kkoBtnUrlLstMo3_2: String? = null
    var kkoBtnUrlLstMo4_1: String? = null
    var kkoBtnUrlLstMo4_2: String? = null
    var kkoBtnUrlLstMo5_1: String? = null
    var kkoBtnUrlLstMo5_2: String? = null
    var kkoBtnUrlLstMo6_1: String? = null
    var kkoBtnUrlLstMo6_2: String? = null
    var kakao_item_img_cd_5: String? = null
    var kakao_item_img_cd_6: String? = null
    var kkoPrice1: Long? = null
    var kkoPrice2: Long? = null
    var kkoPrice3: Long? = null
    var kkoPrice4: Long? = null
    var kkoPrice5: Long? = null
    var kkoPrice6: Long? = null
    var kkoDiscountPrice1: Long? = null
    var kkoDiscountPrice2: Long? = null
    var kkoDiscountPrice3: Long? = null
    var kkoDiscountPrice4: Long? = null
    var kkoDiscountPrice5: Long? = null
    var kkoDiscountPrice6: Long? = null

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}