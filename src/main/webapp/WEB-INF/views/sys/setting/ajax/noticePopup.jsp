<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<c:if test="${not empty list}">
    <c:forEach var="n" items="${list}" varStatus="status">
        <div class="layer_pop noticePopup active"  name = "popUpCheck">
            <div class="pop_container popup_size1">
                <input type="button" value="닫기" class="btn_pop_close" onclick="thispopupClose(this);"/>
                <div class="pop_title">${n.noti_sub}</div>
                <div class="pop_inner scroll_wrap" id="preview_body">
                    <!-- 공지사항 타이틀 영역 -->
                    ${n.noti_body}
                    <!-- 상세 영역 끝 -->
                </div>
                <!-- 팝업 열지 않음 영역 시작 -->
                <c:if test="${n.noti_chk eq 1}">
                    <div class="today">
                        <label class="custom_check1" onclick="setCookie('${n.seq}',1,this)">오늘 이 창을 열지 않음
                            <input type="checkbox" name="">
                            <span></span>
                        </label>
                    </div>
                </c:if>
                <!-- 팝업 열지 않음 영역 끝 -->
            </div>
        </div>
    </c:forEach>
</c:if>