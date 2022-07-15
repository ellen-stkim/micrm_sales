<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<!-- header 영역 시작 -->
<header class="header cf">
	<h1 class="logo"><a href="/home.mi"><img src="/image/logo.png" alt="MICRM" /></a></h1>
	<div class="right cf">
		<ol class="summary">
			<li><span>발송예정</span> ${titleCnt.sendExpect}</li>
			<li><span>발송중</span> ${titleCnt.sending}</li>
			<li><span>승인요청</span> ${titleCnt.apprCnt}</li>
		</ol>
		<div class="ico_notice" id="ico_notice" onclick="sideNoticeOpen();"><span>알림</span>
			<c:if test = "${titleCnt.alarmCnt > 0}">
				<img src="${baseURL}/image/ico_new.png" alt="" />
			</c:if>
		</div>
	</div>
</header>
<!-- header 영역 끝 -->