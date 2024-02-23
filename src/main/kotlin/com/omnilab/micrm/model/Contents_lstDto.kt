package com.omnilab.micrm.model

import com.google.gson.GsonBuilder
import com.omnilab.micrm.model.table.Tblmi_cont_lstDto
import com.omnilab.micrm.model.table.Tblmi_cont_mstDto
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
    var img_lst: String? = null
    var cont_body_json : List<MutableMap<String, Any>>? = null
        get() = if (!cont_body.isNullOrEmpty() && field == null) {
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
        get() = if (!rcs_btn_obj.isNullOrEmpty() && field == null) {
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
        get() = if (!button_json.isNullOrEmpty() && field == null) {
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
        get() = if (!item_highlight_json.isNullOrEmpty() && field == null) {
            val g = GsonBuilder().create();
            val obj = g.fromJson(item_highlight_json, Object::class.java)
            obj
        } else{
            Object()
        }

    var item_list_json: Any? = null
        get() = if (!item_json.isNullOrEmpty() && field == null) {
            val g = GsonBuilder().create();
            val obj = g.fromJson(item_json, Object::class.java)
            obj
        } else{
            Object()
        }

    var cardSize : String? = null

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}