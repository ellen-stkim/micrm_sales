package com.omnilab.micrm.model

import com.google.gson.GsonBuilder
import com.omnilab.micrm.model.table.Tblmi_cont_lstDto
import org.apache.commons.lang3.builder.ToStringBuilder
import org.apache.commons.lang3.builder.ToStringStyle
import org.apache.ibatis.type.Alias

@Alias("Content_list_CreateDto")
class Content_list_CreateDto : Tblmi_cont_lstDto()  {

    // 체크한 값 넘기기
    var formatType : List<String> ?= null

    var cont_nm : String ?= null
    //var cont_sub: List<String> ?= null
    var cont_sub_list : List<String> ?= null
    //var send_to : List<String> ?= null
    var send_to_list : List<String> ?= null

    var sms_msg_tp :String ?= null  // 문자 종류
    var rcs_msg_tp :String ?= null  // RCS 종류

    var kko_option: String ? = null // 카카오 유형
    var sms_option: String ?= null // sms 유형
    var rcs_option : String ?= null // rcs 유형

    // body
    var kakao_body : String?= null
    var sms_body : String?= null
    var rcs_body : String?= null

    // rcs 포멧카드
    var rcs_format_type : String?= null

    // url 링크
    var kko_trackinglink : String ?= null
    var sms_trackinglink : String ? = null

    // mms 이미지 a 링크
    var mms_imgurl : String?= null

    // 가로형, 세로형 이미지 번호
    var verticalImg : Int ?= null
    var horizonImg : Int?= null

    // MDS 이미지 번호
    var mds_img_cd : Int ?= null

    // RCS 이미지 번호
    var rcs_img_cd_1 : Integer ?= null
    var rcs_img_cd_2 : Integer ?= null
    var rcs_img_cd_3 : Integer ?= null
    var rcs_img_cd_4 : Integer ?= null
    var rcs_img_cd_5 : Integer ?= null
    var rcs_img_cd_6 : Integer ?= null

    // Preview를 위한 카카오 이미지 URL
    var kko_view_img_url : String?= null


    // Preview를 위한 RCS 이미지 URL
    var rcs_img_url_1 : String ?= null
    var rcs_img_url_2 : String ?= null
    var rcs_img_url_3 : String ?= null
    var rcs_img_url_4 : String ?= null
    var rcs_img_url_5 : String ?= null
    var rcs_img_url_6 : String ?= null

    // 수정을 위한 list_seq
    var mst_seq : String?=null
    var list_seq : List<Integer> ?= null

    // Json으로 저장하기 위한 버튼
    // 1. 복사하기 (RBTN01)
    var copy_value : List<String>? = null
    // 2. URL 연결 (RBTN02)
    var url_value : List<String>?= null

    // 3. 전화번호 연결 (RBTN03)
    var phone_value_03 : List<String>?= null

    // 4. 위도, 경도 지도 보여주기 좌표 (RBTN04)
    var latitude_value : List<String>?= null  // 버튼 위도
    var longitude_value : List<String>?= null // 버튼 경도
    var location_value_04 : List<String>?= null
    var fallback_url_04 : List<String>?= null

    // 5. 위도 , 경도 지도 보여주기 쿼리 (RBTN05)
    var location_value_05 : List<String>?= null  // 장소
    var fallback_url_05 : List<String>?= null // fallback url

    // 6. 현재 위치 ( 생략 : 버튼명만 들어감 )

    // 7. 캘린더 (RBTN07)
    var start_date : List<String>?= null // 시작일
    var end_date : List<String>?= null // 종료일
    var calendar_title : List<String>?= null //캘린더 명
    var calendar_body : List<String>?= null // 캘린더 바디

    // 8. 메세지 전송 (RBTN08)
    var message_value : List<String>?= null
    var phone_value_08: List<String>?= null

    // RCS 슬라이드용 화면 변수
    var slide_cont_sub : List<String> ?= null // 제목
    var slide_cont_body : List<String> ?= null // 내용

    // 슬라이드 버튼
    var slide_rcs_btn_1 : List<String> ?= null  // 슬라이드 버튼 1
    var slide_rcs_btn_2 : List<String> ?= null // 슬라이드 버튼 2
    var slide_rcs_btn_tp_1 : List<String> ?= null // 슬라이드 버튼 1 Type
    var slide_rcs_btn_tp_2 : List<String> ?= null // 슬라이드 버튼 2 Type

    var url_tag:List<String>? = null
    var url:List<String>? = null
    var url_id:List<String>? = null
    var url_type:List<String>? = null
    var map_id:List<String>? = null
    var map_cords:List<String>? = null

    var sales_id:String? = null

    override fun toString(): String {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE)
    }


}