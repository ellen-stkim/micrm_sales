<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<!-- left menu 영역 시작 -->
<nav class="nav">
	<!-- gnb 영역 시작 -->
	<ul class="gnb">
		<li>
			<span>메시지</span>
			<ul class="sub_menu">
				<%--<li<c:if test="${fn:contains(urlPath,'/cont/edm')}"> class='on'</c:if>><a href="/cont/edmLst.mi">이메일</a></li>--%>
				<li<c:if test="${fn:contains(urlPath, '/cont/mdm')}"> class='on'</c:if>><a href="/cont/mdmLst.mi">모바일</a></li>
				<li<c:if test="${urlPath eq '/cont/atTemplate.mi'  || fn:contains(urlPath, '/cont/kko/')}"> class='on'</c:if>><a href="/cont/atTemplate.mi">알림톡 템플릿</a></li>
				<li<c:if test="${urlPath eq '/cont/imgLst.mi'}"> class='on'</c:if>><a href="/cont/imgLst.mi">이미지 파일</a></li>
			</ul>
		</li>
		<li>
			<span>쿠폰</span>
			<ul class="sub_menu">

				<li<c:if test="${fn:contains(urlPath,'/coupon/couponList')}"> class='on'</c:if>><a href="/coupon/couponList.mi">리스트</a></li>
				<li<c:if test="${fn:contains(urlPath,'/coupon/couponRegister')}"> class='on'</c:if>><a href="/coupon/couponRegister.mi">쿠폰등록</a></li>
				<li<c:if test="${urlPath eq '/coupon/couponIssue.mi'}"> class='on'</c:if>><a href="/coupon/couponIssue.mi">쿠폰발급</a></li>
				<li<c:if test="${fn:contains(urlPath,'/coupon/couponIssuedHistory')}"> class='on'</c:if>><a href="/coupon/couponIssuedHistory.mi">쿠폰발급내역</a></li>
			</ul>
		</li>
		<li>
			<span>리포트</span>
			<ul class="sub_menu">
				<%--<li<c:if test="${fn:contains(urlPath,'/report/main.mi')}"> class='on'</c:if>><a href="/report/main.mi">리포트</a></li>--%>
				<li<c:if test="${fn:contains(urlPath,'/camp/st/')}"> class='on'</c:if>><a href="/camp/st/sendStatus.mi">발송 현황</a></li>
				<li<c:if test="${fn:contains(urlPath,'/cost/')}"> class='on'</c:if>><a href="/cost/costDetail.mi">발송 비용</a></li>
				<%--<li><a href="javascript:void(0);" onclick="popup.popAlert('페이지 준비중입니다.')">리포트</a></li>--%>
				<li <c:if test="${fn:contains(urlPath,'/report/all.mi') ||fn:contains(urlPath,'/report/singleDt.mi')||fn:contains(urlPath,'/report/dt.mi') ||fn:contains(urlPath,'/report/proDt.mi')}"> class='on'</c:if>><a href="/report/all.mi">캠페인 통합</a></li>
			</ul>
		</li>
		<li>
			<span>시스템 관리</span>
			<ul class="sub_menu">
				<sec:authorize access="hasRole('R10')">
					<li<c:if test="${fn:contains(urlPath,'/sys/user')}"> class='on'</c:if>><a href="/sys/user/userManagement.mi">사용자</a></li>
					<li<c:if test="${fn:contains(urlPath, '/sys/setting')}"> class='on'</c:if>><a href="/sys/setting/teamSetting.mi">환경</a></li>
				</sec:authorize>
				<sec:authorize access="hasAnyRole('R1','R2')">
					<li<c:if test="${fn:contains(urlPath,'/sys/user')}"> class='on'</c:if>><a href="/sys/user/myInfo.mi">사용자</a></li>
				</sec:authorize>
			</ul>
		</li>
	</ul>
	<!-- gnb 영역 끝 -->
	<!-- 로그인 정보 영역 -->
	<div class="user_info cf">
		<c:if test = "${sessionScope.userName ne null}">
			<div class="user">${sessionScope.userName} 님</div>
			<form:form id="logout" action="/logout.service" method="post">
				<input type="submit" class="logout" value="로그아웃"/>
			</form:form>
		</c:if>
	</div>
</nav>
<!-- left menu 영역 끝 -->