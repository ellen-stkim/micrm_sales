<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<c:set var="req" value="${pageContext.request}" />
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
    <title>miCRM::</title>
    <meta name="csfrVal" content="${_csrf.token}">
    <meta name="csrfparameterName" content="${_csrf.parameterName}">
    <meta name="csrfHeaderName" content="${_csrf.headerName}">
    <tiles:insertAttribute name="head"/>
    <link rel="stylesheet" type="text/css" href="/css/login.css?v=0.17"/>
</head>
<body>
<div class="wrap" style="padding-left: 0">
    <!-- header 영역 시작 -->
    <header class="header cf">
        <h1 class="logo" tabindex="0">
            <img src="/image/logo.png" alt="MICRM"/>
        </h1>
    </header>
    <!-- header 영역 끝 -->
    <!-- container 영역 시작 -->
    <section class="container">
        <!-- 컨텐츠 영역 시작 -->
        <div class="contents">
            <!-- row 영역 시작 -->
            <div class="row border-bottom tooltip_area">
                <!-- location 영역 -->
            </div>
            <!-- row 영역 끝 -->
            <!-- 로그인 영역 시작 -->
            <div class="login">
                <!-- log_form 영역 시작 -->
                <div class="log_form">
                    <form:form id="logForm" name="form" method="post" action="/api/sms/verify.service">
                        <div class="txt_input">
                            <!-- 아이디 -->
                            <input type="text" class="" name="code" placeholder="인증코드" tabindex="1"/>
                        </div>
                        <div class="error_txt blue_point_color"></div>
                        <!-- 로그인 버튼 -->
                        <input type="button" class="btn_login" id="resend" style="width: 100px; background: #9e9e9e;" value="재전송" tabindex="3"/>
                        <input type="button" class="btn_login" id="sub" style="width: 210px" value="인증" tabindex="4"/>
                    </form:form>
                </div>
                <!-- log_form 영역 끝 -->
            </div>
            <!-- 로그인 영역 끝 -->
            <!-- footer 영역 시작 -->
            <footer class="footer">
                &copy; Milvus Corp.
            </footer>
            <!-- footer 영역 끝 -->
        </div>
        <!-- 컨텐츠 영역 끝 -->
    </section>
    <!-- container 영역 끝 -->
</div>
<script>
    $(function () {
        $("#resend").click(function (){
            const res = function(response){
                if(response){
                    popup.popAlert("사용자 휴대폰 번호로 전송 되었습니다.");
                }else{
                    popup.popAlert(response.msg);
                }
            }
            com_ajax.ajax('post', '/api/sms/resend.service', null, res, '${_csrf.headerName}', '${_csrf.token}');
        });

        $("#sub").click(function (){
            const res = function(response){
                if(response){
                    location.href = "/home.mi"
                }else{
                    popup.popAlert("인증번호가 올바르지 않습니다.");
                }
            }
            let data = []
            data.push({name: 'code', value: $("input[name='code']").val() });
            com_ajax.ajax('post', '${baseURL}/api/sms/verify.service', data, res, '${_csrf.headerName}', '${_csrf.token}');
        });
    });
</script>
</body>
</html>

