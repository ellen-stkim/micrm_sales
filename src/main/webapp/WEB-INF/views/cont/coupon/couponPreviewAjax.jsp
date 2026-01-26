<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil"%>
<%@ taglib uri="/WEB-INF/tlds/Page.tld" prefix="ui" %>
<% pageContext.setAttribute("newLineChar", "\n"); %>
<span id="body">
    <div class="pop_container">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
        <div class="pop_title"></div>
        <div class="pop_inner">
            <div class="coupon_preview">
                <!-- 쿠폰 만료시 coupon_img에 disable 클래스 추가 -->
                <div class="coupon_img">
                    <img src="${couponImageDomain}${coupon.img_url}" alt="쿠폰 이미지" style="width: 500px"/>
                </div>
                <div class="coupon_cont">
                    <div class="info">
                        <h5>${fn:replace(coupon.title, newLineChar, "<br/>")}</h5>
                      <!-- 해당하는 버튼에 active 클래스 추가가 -->
                        <div class="btn_group">
                            <div class="btn able active">사용하기</div>
                            <div class="btn disable">쿠폰 유효기간 만료</div>
                        </div>
                        <div class="period">
                            <dl>
                                <dt>쿠폰 유효기간 :&nbsp;</dt>
                                <dd>${coupon.expire_dt}</dd>
                            </dl>
                            <dl>
                                <dt>쿠폰 사용 가능 요일 :&nbsp;</dt>
                                <dd lang="ko">
                                <c:forEach var="date" varStatus="status" items="${fn:split(coupon.available_day, ',')}">
                                    <c:choose>
                                        <c:when test="${date == '1'}">월</c:when>
                                        <c:when test="${date == '2'}">화</c:when>
                                        <c:when test="${date == '3'}">수</c:when>
                                        <c:when test="${date == '4'}">목</c:when>
                                        <c:when test="${date == '5'}">금</c:when>
                                        <c:when test="${date == '6'}">토</c:when>
                                        <c:when test="${date == '0'}">일</c:when>
                                    </c:choose>
                                    <c:if test="${!status.last}">,</c:if>
                                </c:forEach>
                                </dd>
                            </dl>
                            <dl>
                                <dt>쿠폰 사용 가능 시간 :&nbsp;</dt>
                                <dd>${coupon.daily_start_time} - ${coupon.daily_end_time}</dd>
                            </dl>
                        </div>
                    </div>
                    <div class="issue">
                        <div class="inner">
<%--                            <h6></h6>--%>
                            <ol>
                                <c:forEach var="d" items="${fn:split(coupon.descr, newLineChar)}" >
                                    <li>${d}</li>
                                </c:forEach>
                            </ol>
                        </div>
                        <article class="btn_field">
                            <button type="button" class="btn detail" onclick="openInnerModal('detail')">자세히 알아보기</button>
                        </article>
                    </div>
                </div>
            </div>
        </div>

        <!-- 쿠폰 설명 자세히 보기 팝업 시작 -->
        <article class="inner_modal detail">
            <div class="inner_modal_wrapper">
                <div class="inner_modal_container">
                    <div class="contents">
                        <article class="area top">
                            <h3>유의사항</h3>
                            <button type="button" class="btn close" onclick="closeInnerModal(this)"></button>
                        </article>
                        <div class="area description">
                            <div class="items">
                                <section class="item">
                                    <ul class="list">
                                        <c:forEach var="n" items="${fn:split(coupon.notice, newLineChar)}" >
                                            <li>${n}</li>
                                        </c:forEach>
                                    </ul>
                                </section>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </article>
        <!-- 쿠폰 설명 자세히 보기 팝업 끝 -->
    </div>
</span>
