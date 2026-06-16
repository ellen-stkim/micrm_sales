package com.omnilab.micrm.model.coupon

import com.omnilab.micrm.model.table.Tblmicou_couponDto
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias
import org.springframework.web.multipart.MultipartFile
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

@Alias("CouponRegisterDto")
class CouponRegisterDto : Tblmicou_couponDto() {
    var imgFile: MultipartFile? = null
    var encodedSeq: String? = null
    var usr_grp_cd: String? = null

    var category: String? = null
    var expire_time: String? = ""
        set(value) {
            if (value.isNullOrBlank() || !value.contains(":")) {
                field = ""
            } else if (expire_date.isNullOrBlank()) {
                field = value
            } else {
                field = value
                expire_dt = LocalDateTime.parse("$expire_date $value:00", DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")).toString()
            }
        }
    var expire_date: String? = ""
        set(value) {
            if (value.isNullOrBlank() ) {
                field = ""
            } else if (expire_time.isNullOrBlank()) {
                field = value
            } else {
                field = value
                expire_dt = LocalDateTime.parse("$value $expire_time:00", DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")).toString()
            }
        }

    override var daily_start_time: String? = ""
        set(value) {
            if (value.isNullOrBlank() || !value.contains(":")) {
                field = ""
            } else {
                field = value
            }
        }
    override var daily_end_time: String? = ""
        set(value) {
            if (value.isNullOrBlank() || !value.contains(":")) {
                field = ""
            } else {
                field = value
            }
        }


    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }
}