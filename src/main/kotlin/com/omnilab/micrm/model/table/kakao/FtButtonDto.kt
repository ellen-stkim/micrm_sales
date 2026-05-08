package com.omnilab.micrm.model.table.kakao

import com.google.gson.annotations.SerializedName
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("FtButtonDto")
data class FtButtonDto(
    var name: String?,
    @SerializedName(value = "linkType", alternate = ["link_type"])
    var linkType: String?,
    @SerializedName(value = "linkMobile", alternate = ["link_mobile"])
    var linkMobile: String?,
    @SerializedName(value = "linkPc", alternate = ["link_pc"])
    var linkPc: String?,
    @SerializedName(value = "linkIos", alternate = ["link_ios"])
    var linkIos: String?,
    @SerializedName(value = "linkAndroid", alternate = ["link_android"])
    var linkAndroid: String?,
    @SerializedName(value = "bizFormId", alternate = ["biz_form_id"])
    var bizFormId: String?,
) {
    
    constructor() : this(null, null, null, null, null, null, null)
    
    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
    
}