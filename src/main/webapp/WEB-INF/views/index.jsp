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
    <link rel="stylesheet" type="text/css" href="/css/login.css?v=0.20"/>
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
    <%--
    <tiles:insertAttribute name="menu"/>
    --%>
    <!-- container 영역 시작 -->
    <section class="container">
        <!-- 컨텐츠 영역 시작 -->
        <div class="contents">
            <!-- row 영역 시작 -->
            <div class="row border-bottom tooltip_area">
                <!-- location 영역 -->
                <ul class="location cf">
                    <li>홈</li>
                    <li>로그인</li>
                </ul>
                <!-- tooltip 버튼 영역  -->
<%--                <div class="tooltip_icon">--%>
<%--                    <img src="/image/ico_tooltip.png" alt="Tooltip"/>--%>
<%--                </div>--%>
                <!-- tooltip box 영역 시작 -->
<%--                <div class="tooltip_box">--%>
<%--                    <!-- tooltip bullet 영역 -->--%>
<%--                    <div class="bullet"></div>--%>
<%--                    <span class="bold">계정 정보를 확인 후 시도해주세요.</span>--%>
<%--                    10회 비밀번호 오류 시 현재 접속중인 IP가 차단됩니<br/>--%>
<%--                    다.--%>
<%--                </div>--%>
                <!-- tooltip box 영역 끝 -->
            </div>
            <!-- row 영역 끝 -->
            <!-- 로그인 영역 시작 -->
            <div class="login">
                <!-- log_form 영역 시작 -->
                <div class="log_form">
                    <form:form id="logForm" name="form" method="post" action="/login.service">
                        <div class="txt_input">
                            <!-- 아이디 -->
                            <input type="text" class="" name="id" placeholder="사용자 이메일" tabindex="1"/>
                        </div>
                        <div class="pw_input">
                            <!-- 비밀번호 -->
                            <input type="password" class="" name="password" id="password" placeholder="비밀번호" tabindex="2"/>
                            <div id="passToggle"></div>
                        </div>
                        <div class="error_txt blue_point_color"></div>
                        <!-- 로그인 버튼 -->
                        <input type="submit" class="btn_login" value="로그인" tabindex="3"/>
                    </form:form>
                    <div class="log_info cf">
                        <!-- 아이디/비밀번호 저장 영역 시작 -->
                        <div class="log_check">
                            <label class="checkbox">
                                아이디/비밀번호 저장
                                <input type="checkbox" id="saveCheck"/>
                                <span></span>
                            </label>
                        </div>
                        <!-- 아이디/비밀번호 저장 영역 끝 -->
                        <div class="log_find" onclick="inquiryPop();">
                            아이디/비밀번호 찾기
                        </div>
                    </div>
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

<!-- 아이디/비밀번호 찾기 팝업 영역 시작 -->
<div class="layer_pop inquiryPopup">
    <div class="pop_container popup_size1">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
        <div class="pop_title">아이디·비밀번호 찾기</div>
        <div class="pop_inner">
            <h2 class="table_tit">아이디 찾기</h2>
            <form:form action="/mcr/id" id="idInquiry" method="post">
                <table class="pop_table_type1" summary="아이디 찾기">
                    <colgroup>
                        <col width="102"/>
                        <col width="*"/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th scope="row">이름</th>
                        <td>
                            <input type="text" name="idName" class="full_inp" placeholder="작성자(성함)을 입력해주세요."/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">핸드폰 번호</th>
                        <td>
<%--                            <input type="text" name="idPhone1" class="number_inp"/>--%>
<%--                            <span class="hyphen">-</span>--%>
<%--                            <input type="text" name="idPhone2" class="number_inp"/>--%>
<%--                            <span class="hyphen">-</span>--%>
<%--                            <input type="text" name="idPhone3" class="number_inp"/>--%>
                            <input type="text" name="idPhone" class="full_inp" placeholder="핸드폰번호를 입력해주세요." maxlength="11"/>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </form:form>
            <div class="form_error" id="idError"></div>
            <div class="btn_row margin-bottom">
                <input type="button" class="btn_bg btn_idInquiry" value="찾기"/>
            </div>

            <h2 class="table_tit">비밀번호 찾기</h2>
            <form:form action="" id="pwInquiry">
                <table class="pop_table_type1" summary="비밀번호 찾기">
                    <colgroup>
                        <col width="102"/>
                        <col width="*"/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th scope="row">이름</th>
                        <td>
                            <input type="text" name="pwName" class="full_inp" placeholder="작성자(성함)을 입력해주세요."/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">핸드폰 번호</th>
                        <td>
<%--                            <input type="text" name="pwPhone1" class="number_inp"/>--%>
<%--                            <span class="hyphen">-</span>--%>
<%--                            <input type="text" name="pwPhone2" class="number_inp"/>--%>
<%--                            <span class="hyphen">-</span>--%>
<%--                            <input type="text" name="pwPhone3" class="number_inp"/>--%>
                            <input type="text" name="pwPhone" class="full_inp" placeholder="핸드폰번호를 입력해주세요." maxlength="11"/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">이메일</th>
                        <td>
                            <input type="text" name="email" class="full_inp" placeholder="이메일을 입력해주세요."/>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </form:form>
            <div class="form_error" id="pwError"></div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_pwInquiry" value="찾기"/>
            </div>
        </div>
    </div>
</div>
<form:form id="findPwForm" name="findPwForm" method="post" action="/mcr/send/password.service" target="iframe1">
    <input type ="hidden" name ="usr_log_id" id="find_usr_email"/>
    <input type ="hidden" name ="usr_nm" id="find_usr_nm"/>
    <input type ="hidden" name ="usr_mob" id="find_usr_mob"/>
</form:form>
<!-- 아이디/비밀번호 찾기 팝업 영역 끝 -->

<!-- 아이디 팝업 영역 시작 -->
<div class="layer_pop idPopup">
    <div class="pop_container popup_size2">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
        <div class="pop_title">아이디 찾기</div>
        <div class="pop_inner">
            <div class="alert_txt">
                입력하신 정보와 일치하는 아이디 입니다.
                <span class="en_font" id="findUsrId">milvus@milvus.co.kr</span>
            </div>
            <div class="btn_row">
                <input type="button" class="btn_bg" value="확인" onclick="popupClose(this);"/>
            </div>
        </div>
    </div>
</div>
<!-- 아이디 팝업 영역 끝 -->

<!-- 비밀번호 팝업 영역 시작 -->
<div class="layer_pop pwPopup">
    <div class="pop_container popup_size2">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
        <div class="pop_title">비밀번호 찾기</div>
        <div class="pop_inner padding_none">
            <div class="alert_txt">
                입력하신 이메일 주소로 임시 비밀번호를 발송하였습니다.<br/>
                임시 비밀번호로 로그인 후 비밀번호를 변경하시기 바랍니다.
            </div>
            <div class="btn_row">
                <input type="button" class="btn_bg" value="확인" onclick="popupClose(this);"/>
            </div>
        </div>
    </div>
</div>
<!-- 비밀번호 팝업 영역 끝 -->
<iframe id="iframe1" name="iframe1" style="display:none" title="none"></iframe>
<script>
    $(function () {
        
        $("#logForm").validate({
            errorElement: "div",
            errorPlacement: function (error, element) {
                element.parent("div").after(error);
            },
            rules: {
                id: {
                    required: true,
                    email: true
                },
                password: {
                    required: true
                }
            },
            messages: {
                id: {
                    required: '아이디(이메일)을 입력해 주세요.',
                    email: '아이디(이메일)는 이메일 형식으로 입력해주세요.'
                },
                password: {
                    required: '비밀번호를 입력해 주세요.'
                }
            }
        });//end

        // input 디자인 동작
        $('.txt_input input').keydown(function () {
            let errorLength = $(".txt_input input").parent().next('.error').length;
            if (errorLength > 0) {
                if ($(".txt_input input").parent().next('.error').css('display') == 'none') {
                    $('.pw_input input').css('border-top', 'none');
                } else if ($(".txt_input input").parent().next('.error').css('display') == 'block') {
                    $('.pw_input input').css('border-top', '1px solid #dddddd');
                }
            }
        });

        $('.btn_idInquiry').on('click', function () {
            $('#idInquiry').submit();
        });

        $('.btn_pwInquiry').on('click', function () {
            $('#pwInquiry').submit();
        });

        $('#idInquiry').validate({
            onfocusout: false
            , submitHandler: function () {
                var usr_nm = $('input[name="idName"]').val().trim();
                //var usr_mob = $('input[name="idPhone1"]').val().trim() + $('input[name="idPhone2"]').val().trim() + $('input[name="idPhone3"]').val().trim();
                var usr_mob = $('input[name="idPhone"]').val().trim();
                var res = function(response){
                    if(response.isExist === "true"){
                        $("#findUsrId").text(response.userId);
                        $('#idInquiry')[0].reset();
                        $('#idError').text('');
                        findIdPopup();
                    }else{
                        $("#idError").text("입력 정보가 일치하지 않습니다");
                    }
                };
                var param = {usr_nm : usr_nm , usr_mob : usr_mob};
                com_ajax.ajax('post','${baseURL}/mcr/check/id.ajax', param ,res,'${_csrf.headerName}','${_csrf.token}');
            }
            , errorPlacement: $.noop
            , invalidHandler: function (form, validator) {
                let errors = validator.numberOfInvalids();
                if (errors) {
                    $('#idError').html(validator.errorList[0].message);
                }
            }
            , rules: {
                idName: {
                    required: true
                }
                , idPhone: {
                    required: true
                    , number: true
                    , minlength: 10
                    , maxlength: 11
                }
            }
            , messages: {
                idName: {
                    required: "이름을 입력해주세요."
                }
                , idPhone: {
                    required: "핸드폰 번호를 입력해 주세요."
                    , number: "숫자만 입력해 주세요."
                    , minlength : "핸드폰 번호는 10 ~ 11자리 이내로 입력해 주세요."
                    , maxlength : "핸드폰 번호는 10 ~ 11자리 이내로 입력해 주세요."

                }
            }
        });

        $('#pwInquiry').validate({
            onfocusout: false
            , submitHandler: function () {

                const usr_nm = $('input[name="pwName"]').val().trim();
                //const usr_mob = $('input[name="pwPhone1"]').val().trim() + $('input[name="pwPhone2"]').val().trim() + $('input[name="pwPhone3"]').val().trim();
                const usr_mob = $('input[name="pwPhone"]').val().trim();
                const email = $('input[name="email"]').val().trim();

                const res = function(response) {
                    if(response.isExist == "true") {
                        $('#pwInquiry')[0].reset();
                        $('#pwError').text('');
                        findPwPopup();
                        $("#find_usr_email").val(email);
                        $("#find_usr_nm").val(usr_nm);
                        $("#find_usr_mob").val(usr_mob);
                        $("#findPwForm").submit();
                        return false;
                    }else{
                        $('#pwError').html("입력 정보가 일치하지 않습니다");
                    }
                }
                //const param = {usr_nm : usr_nm ,usr_mob : usr_mob ,usr_email :email}
                const param = {usr_nm : usr_nm ,usr_mob : usr_mob ,usr_log_id :email}
                com_ajax.ajax('post','${baseURL}/mcr/find/pw.ajax', param ,res,'${_csrf.headerName}','${_csrf.token}');
            }
            , errorPlacement: $.noop
            , invalidHandler: function (form, validator) {
                var errors = validator.numberOfInvalids();
                if (errors) {
                    $('#pwError').html(validator.errorList[0].message);
                }
            }
            , rules: {
                pwName: {
                    required: true
                }
                , pwPhone: {
                    required: true
                    , number: true
                    , minlength: 10
                    , maxlength: 11
                }
                , email: {
                    required: true
                    , email: true
                }
            }
            , messages: {
                pwName: {
                    required: "이름을 입력해주세요."
                }
                , pwPhone: {
                    required: "핸드폰 번호를 입력해주세요."
                    , number: "숫자만 입력해주세요."
                    , minlength : "핸드폰 번호는 10 ~ 11자리 이내로 입력해 주세요."
                    , maxlength : "핸드폰 번호는 10 ~ 11자리 이내로 입력해 주세요."
                }
                , email: {
                    required: "이메일을 입력해주세요."
                    , email: "유효하지 않은 이메일 입니다."
                }
            }
        });
    });

    function popupClose(close) {
        $(close).parents('.layer_pop').removeClass('active');
    }

    function inquiryPop() {
        $('#idInquiry')[0].reset();
        $('#idError').text('');
        $('#pwInquiry')[0].reset();
        $('#pwError').text('');
        $('.inquiryPopup').addClass('active');
    }

    function findIdPopup() {
        $('.idPopup').addClass('active');
    }

    function findPwPopup() {
        $('.pwPopup').addClass('active');
    }

    window.onload = function () {
        // let leftLocation = $('.tooltip_icon').offset().left;
        // let leftMinus = leftLocation - 198;
        // $('.bullet').css('left', leftMinus);
    };

    $('.btn_login').on('click', function () {
        var id = $("input[name='id']").val();
        var password = $("input[name='password']").val();
        if(id == null || id == ""){
            popup.popAlert("아이디를 입력해주세요.");
            return false;
        }else if(password == null || password == "") {
            popup.popAlert("비밀번호를 입력해주세요.");
            return false;
        }
        if($("#saveCheck").is(":checked")){
            var userInputId = $("input[name='id']").val();
            setCookie("userInputId", userInputId, 365);
            var userInputPwd = $("input[name='password']").val();
            setCookie("userInputPwd", userInputPwd, 365);
        }
        $('#logForm').submit();

    });
    function setCookie(cookieName, value, exdays){
        var exdate = new Date();
        exdate.setDate(exdate.getDate() + exdays);
        var cookieValue = escape(value) + ((exdays==null) ? "" : "; expires=" + exdate.toGMTString());
        document.cookie = cookieName + "=" + cookieValue;
    }

    function deleteCookie(cookieName){
        var expireDate = new Date();
        expireDate.setDate(expireDate.getDate() - 1); //어제날짜를 쿠키 소멸날짜로 설정
        document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString();
    }

    function getCookie(cookieName) {
        cookieName = cookieName + '=';
        var cookieData = document.cookie;
        var start = cookieData.indexOf(cookieName);
        var cookieValue = '';
        if(start != -1){
            start += cookieName.length;
            var end = cookieData.indexOf(';', start);
            if(end == -1)end = cookieData.length;
            cookieValue = cookieData.substring(start, end);
        }
        return unescape(cookieValue);
    }
    $("#saveCheck").change(function(){
        if($("#saveCheck").is(":checked")){
            var userInputId = $("input[name='id']").val();
            setCookie("userInputId", userInputId, 365);

            var userInputPwd = $("input[name='password']").val();
            setCookie("userInputPwd", userInputPwd, 365);
        }else{
            deleteCookie("userInputId");
            deleteCookie("userInputPwd");
            $("#saveCheck").attr("checked", false);
        }
    });
    $(document).ready(function() {
        var userInputId = getCookie("userInputId");
        if (typeof userInputId != "undefined" && userInputId != null && userInputId != "" && userInputId != "undefined"){
            $("input[name='id']").val(userInputId);
            var userInputPwd = getCookie("userInputPwd");
            $("input[name='password']").val(userInputPwd);
            $("#saveCheck").attr("checked", true);
        }
    });

    // caps lock check
    let password = document.getElementById('password');
    let errorPlace = document.querySelector('.error_txt');
    password.addEventListener('keyup',function(event){
        if(event.getModifierState("CapsLock")){
            errorPlace.innerHTML = 'CapsLock이 켜져 있습니다.';
        }else{
            errorPlace.innerHTML = '';
        }
    });
    // 비밀번호 text 확인
    let toggleBtn = document.getElementById('passToggle');
    toggleBtn.addEventListener('click',function(){
        toggleBtn.classList.toggle('on');
        if(toggleBtn.classList.contains('on')){
            password.type = 'text';
        }else{
            password.type = 'password';

        }
    });



</script>
</body>
</html>

