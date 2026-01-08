package com.omnilab.micrm.model.table.kakao

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Kko_msgDto")
class Kko_msgDto {
    var msgkey: Int? = null
    var serialnum: String? = null
    var id: String? = null
    var status: String? = null
    var phone: String? = null
    var callback: String? = null
    var reqdate: String? = null
    var sentdate: String? = null
    var rsltdate: String? = null
    var reportdate: String? = null
    var rslt: String? = null
    var msg_rslt: String? = null
    var net: String? = null
    var msg: String? = null
    var template_code: String? = null
    var failed_type: String? = null
    var failed_subject: String? = null
    var failed_msg: String? = null
    var failed_img: String? = null
    var profile_key: String? = null
    var url: String? = null
    var url_button_txt: String? = null
    var img_path: String? = null
    var img_url: String? = null
    var button_json: String? = null
    var image_json: String? = null
    var quick_reply_json: String? = null
    var item_highlight_json: String? = null
    var item_json: String? = null
    var coupon_json: String? = null
    var commerce_json: String? = null
    var video_json: String? = null
    var head_json: String? = null
    var carousel_json: String? = null
    var tail_json: String? = null
    var ad_flag: String? = null
    var etc1: String? = null
    var etc2: String? = null
    var etc3: String? = null
    var etc4: String? = null
    var etc5: String? = null
    var etc6: String? = null
    var clientId: String? = null

    var title: String? = null
    var kko_title: String? = null
    var header: String? = null
    var type: String? = null
    var price: String? = null
    var currency_type: String? = null
    var quick_reply: String? = null
    var item_highlight: String? = null
    var item: String? = null
    var m_server: String? = null

    var tax_cd1: String? = null

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}