package com.omnilab.micrm.model

import com.google.gson.GsonBuilder
import com.omnilab.micrm.model.table.Tblmi_kko_at_tmplDto

class AtTmpl_viewDto : Tblmi_kko_at_tmplDto() {

    var sender: String? = null
    var img_nm : String?  = null
    var img_org_nm : String? = null
    var img_url : String? = null
    var kko_img_url : String?= null
    var cate_cd_val : String?= null
    var cate_cd_desc : String?= null
    var cate_cd_sn: String? = null
    var cate_sub_cd_val: String? = null
    var cate_sub_cd_desc: String? = null
    var cate_sub_cd_sn: String? = null
    var msg_tp: String? = null
    var msg_tp_nm: String? = null
    var emp_tp: String? = null
    var emp_tp_nm: String? = null

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
}