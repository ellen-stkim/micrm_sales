package com.omnilab.micrm.common

/**
 *  차후에 url data key 값이 바뀔 경우를 대비해 static 선언
 */
object BtnValueUtils {

    // 버튼명
    const val displayText : String = "displayText"
    const val text : String = "text"

    /**
     *  복사하기 Btn
     */
    const val clipBoardAction : String = "clipboardAction"
    const val copyToClipboard : String = "copyToClipboard"

    /**
     *  Url Btn
     */
    const val urlAction : String = "urlAction"
    const val openUrl : String = "openUrl"
    const val url : String = "url"

    /**
     * Dial Btn
     */
    const val dialerAction : String = "dialerAction"
    const val dialPhoneNumber : String = "dialPhoneNumber"
    const val phoneNumber : String = "phoneNumber"

    /**
     * mapAction
     */
    const val mapAction : String = "mapAction"
    const val showLocation : String = "showLocation"
    const val location : String = "location"
    const val fallbackUrl : String = "fallbackUrl"

    /**
     * 지도 보여주기 좌표
     */
    const val latitude : String = "latitude"
    const val longitude : String = "longitude"
    const val label : String = "label"

    /**
     *  지도 보여주기 쿼리
     */
    const val query : String = "query"

    /**
     *  request Url
     */
    const val requestLocationPush : String = "requestLocationPush"

    /**
     *  캘린더 액션
     */

    const val calendarAction : String = "calendarAction"
    const val createCalendarEvent : String = "createCalendarEvent"
    const val description : String = "description"
    const val startTime : String = "startTime"
    const val endTime : String = "endTime"
    const val title : String = "title"

    /**
     * 메세지 전송 로직
     */
    const val composeAction : String = "composeAction"
    const val composeTextMessage : String = "composeTextMessage"



}