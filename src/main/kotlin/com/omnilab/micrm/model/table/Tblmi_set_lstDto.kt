package com.omnilab.micrm.model.table

import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Tblmi_set_lst")
open class Tblmi_set_lstDto {

    var seq : Int ?= null
    var list_tp_id : String?= null // 리스트 Type
    var list_dt_id : String?= null // 리스트 상세 타입 Id
    var list_val : String?= null // 리스트 값
    var list_nm : String ?= null // 리스트 명
    var list_etc : String ?= null // 기타 값
    var def_yn : String ?= null // 삭제 여부
    var addl_use_yn: String? = null // 추가기능 사용 여부
    var del_dt : String ?= null // 삭제 여부
    var use_yn : String ?= null // 사용 여부
    var usr_grp_cd : String ?= null // 사용자 소속 코드
    var reg_id : String ?= null // 등록자
    var reg_dt : String ?= null // 등록일
    var upd_id : String ?= null // 수정자
    var upd_dt : String ?= null // 수정일

    constructor()

    constructor(list_tp_id: String?, list_dt_id: String?, def_yn: String?, usr_grp_cd: String?) {
        this.list_tp_id = list_tp_id
        this.list_dt_id = list_dt_id
        this.def_yn = def_yn
        this.usr_grp_cd = usr_grp_cd
    }

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }

}