<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <ul class="tab_row">
            <!-- Tab menu -->
            <li<c:if test = "${urlPath eq '/sys/setting/teamSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/teamSetting.mi">팀 정보 설정</a></li>
            <li<c:if test = "${urlPath eq '/sys/setting/mappingSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/mappingSetting.mi">매핑 정보 설정</a></li>
            <li<c:if test = "${urlPath eq '/sys/setting/smsSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/smsSetting.mi">문자 정보 설정</a></li>
            <%--<li><a href="approval.html">승인 절차 설정</a></li>--%>
            <li<c:if test = "${urlPath eq '/sys/setting/kkoSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/kkoSetting.mi">카카오 정보 설정</a></li>
            <li<c:if test = "${urlPath eq '/sys/setting/rejectSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/rejectSetting.mi">수신거부 문구 설정</a></li>
            <%--<li<c:if test = "${urlPath eq '/sys/setting/naverAppSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/naverAppSetting.mi">네이버 Short URL 설정</a></li>--%>
            <li<c:if test = "${urlPath eq '/sys/setting/mcSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/mcSetting.mi">Marketing Cloud 설정</a></li>
        </ul>
