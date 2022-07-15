<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<div class="top bottom-border cf">
        <h3>알림</h3>
        <c:if test ="${workCnt > 0}">
            <p id="alarmTitle">오늘의 새로운 알림이 있습니다</p>
        </c:if>
        <c:if test ="${workCnt eq '0'}">
            <p id="alarmTitle"></p>
        </c:if>
        <button class="side_close" onclick="sideNoticeClose();"></button>
    </div>
    <div class="row cf">
        <h4>작업내역</h4>
        <p>최근 7일간 기록만 확인할 수 있습니다.</p>
        <button class="refresh"></button>
    </div>
    <div class="body_list middle" id="work_body_list">
        <c:forEach var ="workList" items="${workList}">
            <div class="article">
                <!-- 날짜 영역 -->
                <div class="date en_font">${workList.work_st_dt}</div>
                <div class="notice_txt">
                    ${workList.work_msg}&nbsp;
                    <c:if test ="${workList.notify == '1'}">
                        <img src="/image/ico_new.png" alt=""/>
                    </c:if>
                </div>
            </div>
        </c:forEach>
    </div>
    <div class="bottom top-border">
        <div class="row cf">
            <h4>공지사항</h4>
        </div>
        <div class="body_list" id ="notice_body_list">
            <c:forEach var ="notiList" items="${notiList}">
                <div class="article">
                    <div class="date en_font">${notiList.reg_dt}</div>
                    <div class="notice_txt">
                        ${notiList.noti_sub}
                    </div>
                </div>
            </c:forEach>
        </div>
        <!-- 관리자 메일 문의 영역 -->
        <button class="row_mail en_font">support@micrm.co.kr</button>
</div>
