<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<c:set var="req" value="${pageContext.request}" />
<c:set var="urlPath" value="${requestScope['javax.servlet.forward.request_uri']}" scope="request" />
<c:choose>
	<c:when test="${header['X-Forwarded-Proto'] eq 'https'}">
		<c:set var="baseURL" value="https://${req.serverName}${req.contextPath}" />
	</c:when>
	<c:otherwise>
		<c:set var="baseURL" value="${req.scheme}://${req.serverName}:${req.serverPort}${req.contextPath}" />
	</c:otherwise>
</c:choose>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<title>miCRM::
		</title>
		<meta name="csfrVal" content="${_csrf.token}">
		<meta name="csrfparameterName" content="${_csrf.parameterName}">
	 	<meta name="csrfHeaderName" content="${_csrf.headerName}">
		<tiles:insertAttribute name="head"/>
	</head>
	<body>
		<!-- 시스템 공지사항 팝업 영역 시작-->
		<div id="noticePopAppend"></div>
		<!-- 시스템 공지사항 팝업 영역 끝 -->
		<div class="wrap" style="padding-top: 0; padding-left: 0">
			<!-- 알림 영역 시작 -->
			<aside class="side_notice">
				<div class="top bottom-border cf">
					<h3>알림</h3>
					<p id ="alarmTitle"></p>
					<button class="side_close" onclick="sideNoticeClose();"></button>
				</div>
				<div class="row cf">
					<h4>작업내역</h4>
					<p>최근 7일간 기록만 확인할 수 있습니다.</p>
					<button class="refresh" onclick="refreshWork();"></button>
				</div>
				<div class="body_list middle" id="work_body">
				</div>
				<div class="bottom top-border">
					<div class="row cf">
						<h4>공지사항</h4>
					</div>
					<div class="body_list" id="notice_body">
						<%--<div class="article">
							<div class="date en_font">2021-02-04 13:00:00.0</div>
							<div class="notice_txt">
							시스템 점검 안내
							</div>
						</div>--%>
					</div>
					<!-- 관리자 메일 문의 영역 -->
					<button class="row_mail en_font">support@micrm.co.kr</button>
				</div>
			</aside>
			<!-- 알림 영역 끝 -->
			<tiles:insertAttribute name="body"/>
		<div class="layer_pop" id="commonLoading">
			<img src="/image/loading.svg" alt="" />
		</div>
	</body>
</html>