package com.omnilab.micrm.model.table.kakao

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Kko_at_msgDto")
open class Kko_at_tmplDto {

    var send_key:String? = null
    var templateCode: String? = null
    var templateName: String? = null
    var templateContent: String? = null
    var templateImageName: String? = null
    var templateImageUrl: String? = null
    var channelId: String? = null
    var securityFlag: String? = null
    var templateStatus: String? = null
    var kepStatus: String? = null
    var templateMessageType: String? = null
    var templateExtra: String? = null
    var templateAd: String? = null
    var templateTitle: String? = null
    var templateSubtitle: String? = null
    var templateEmphasizeType: String? = null
    var categoryCode: String? = null
    var templateHeader: String? = null

    var newTemplateCode: String? = null
    var newTemplateName: String? = null
    var newTemplateContent: String? = null
    var newTemplateImageName: String? = null
    var newTemplateImageUrl: String? = null
    var newSenderKeyType: String? = null
    var newTemplateMessageType: String? = null
    var newTemplateExtra: String? = null
    var newTemplateAd: String? = null
    var newTemplateEmphasizeType: String? = null
    var newTemplateTitle: String? = null
    var newTemplateSubtitle: String? = null
    var newCategoryCode: String? = null
    var newTemplateHeader: String? = null

    var buttons: MutableList<AtButtonDto>? = null
    var quickReplies: MutableList<QuickReplyDto>? = null

    var templateItemHighlight: MutableMap<String,String>? = null
    var templateItem: MutableMap<String,Any>? = null

    var newTemplateItemHighlight: MutableMap<String,String>? = null
    var newTemplateItem: MutableMap<String,Any>? = null

    constructor()

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}

