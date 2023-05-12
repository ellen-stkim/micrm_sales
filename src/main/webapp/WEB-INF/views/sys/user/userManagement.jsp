<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>

<!-- container 영역 시작 -->
<section class="container">
    <!-- 컨텐츠 영역 시작 -->
    <div class="contents">
        <!-- row 영역 시작 -->
        <form:form id="userSearchForm" name="userSearchForm" method="post" onsubmit="return false">
            <div class="row tooltip_area bottom-border cf">
                <div class="left">
                    <!-- location 영역 -->
                    <ul class="location">
                        <li>홈</li>
                        <li>시스템관리</li>
                        <li>사용자</li>
                    </ul>
                    <!-- tooltip 버튼 영역  -->
<%--                    <div class="tooltip_icon">--%>
<%--                        <img src="../../image/ico_tooltip.png" alt="Tooltip"/>--%>
<%--                    </div>--%>
                    <!-- tooltip box 영역 시작 -->
<%--                    <div class="tooltip_box">--%>
<%--                        <!-- tooltip bullet 영역 -->--%>
<%--                        <div class="bullet"></div>--%>
<%--                        <span class="bold">2019년 12월 신규 취급액은 91.6억 중,<br/>--%>
<%--                                나오론이 52.4억(57.2%)으로 가장 많은 비중을--%>
<%--                                차지합니다.</span>--%>
<%--                        스타일론 직장인이 26.69억(29.1%), <br/>--%>
<%--                        스타일론 자영업자가 4.1억(4.47%)입니다.<br/>--%>
<%--                    </div>--%>
                    <!-- tooltip box 영역 끝 -->
                </div>
                <div class="right">
                    <!-- select 영역 시작 -->
                    <div class="select style1 left-border">
                        <!-- selected value -->
                        <div class="value searchSelect" data="">기준선택</div>
                        <!-- option -->
                        <ul class="option">
                            <li data="USR_ST">상태</li>
                            <li data="USR_NM">이름</li>
                            <li data="USR_EMAIL">이메일</li>
                            <li data="USR_MOB">휴대폰번호</li>
                            <li data="USR_ST">권한</li>
                            <%--<li data="담당승인자">담당승인자</li>--%>
                        </ul>
                    </div>
                    <!-- select 영역 끝 -->
                    <input type="text" class="searchInp left-border searchWord" name="searchValue" id="searchValue" placeholder="검색어입력"
                           onkeydown="enterSubmit();"/>
                    <input type="hidden" id="searchType" name="searchType"/>
                    <button type="button" class="searchBtn" onclick="return searchUser();">검색</button>
                </div>
            </div>
            <!-- row 영역 끝 -->
            <ul class="tab_row">
                <li class="on"><a href="/sys/user/userManagement.mi">사용자 관리</a></li>
               <%-- <li><a href="permission.html">권한 설정</a></li>--%>
<%--                <li><a href="#">권한 설정</a></li>--%>
            </ul>
        </form:form>
        <form:form id="userDetailForm" name="userDetailForm" method="post" >
        <span id="userList"></span>
        <input type="hidden" name="seq" id="seq"/>
        </form:form>
    </div>
    <!-- 컨텐츠 영역 끝 -->
    <!-- footer 영역 시작 -->
    <footer class="footer">
        &copy; Milvus Corp.
    </footer>
    <!-- footer 영역 끝 -->
</section>
<!-- container 영역 끝 -->
</div>
<!-- wrap end -->

<!-- 사용자 신규 추가 팝업 영역 시작 -->
<form id="saveUserForm" name="saveUserForm" onsubmit="return false">
    <div class="layer_pop accountPopup">
        <div class="pop_container popup_size1">
            <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
            <div class="pop_title">사용자 신규 추가</div>
            <div class="pop_inner">
                <table class="pop_table_type1" summary="사용자 신규 추가">
                    <colgroup>
                        <col width="103"/>
                        <col width="*"/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>이름</th>
                        <td>
                            <input type="text" id="userName" placeholder="이름을 입력해주세요." name="usr_nm" class="input_type1"/>
                        </td>
                    </tr>
                    <tr>
                        <th>로그인 이메일</th>
                        <td>
                            <input type="text" id="usr_log_id" placeholder="사용자의 로그인 이메일을 입력해주세요." name="usr_log_id" class="input_type1"/>
                        </td>
                    </tr>
                    <tr>
                        <th>이메일</th>
                        <td>
                            <input type="text" id="userMail" placeholder="사용자의 이메일을 입력해주세요." name="usr_email"
                                   class="input_type1"/>
                        </td>
                    </tr>
                    <tr>
                        <th>핸드폰번호</th>
                        <td>
                            <input type="text" id="userPhone" placeholder="사용자의 핸드폰번호을 입력해주세요." name="usr_mob"
                                   class="input_type1"/>
                        </td>
                    </tr>
                    <tr>
                        <th>권한</th>
                        <td class="pd_none">
                            <!-- select 영역 시작 -->
                            <div class="select style1">
                                <!-- selected value -->
                                <div class="value" id="authority" data="">선택</div>
                                <!-- option -->
                                <ul class="option">
                                    <c:forEach var="n" items="${cdDto}" varStatus="status">
                                        <li data="${n.cd_id}">${n.cd_nm}</li>
                                    </c:forEach>
                                </ul>
                            </div>
                            <!-- select 영역 끝 -->
                        </td>
                    </tr>
                    <tr>
                        <th>비밀번호</th>
                        <td>
                            <input type="password" placeholder="비밀번호를 입력해주세요." id="password" name="usr_pw"
                                   class="input_type1 pwd"/>
                        </td>
                    </tr>
                    <tr>
                        <th>비밀번호 확인</th>
                        <td>
                            <input type="password" placeholder="비밀번호를 입력해주세요." id="comfirmPsw" name="usr_pw_ck"
                                   class="input_type1 pwd"/>
                            <div class="right blue_point_color" id="errorArea1"></div>
                        </td>
                    </tr>
                    </tbody>
                </table>
                <div class="pop_error_txt blue_point_color" id="errorArea2"></div>
                <div class="btn_row">
                    <input type="hidden" id="usr_st" name="usr_st" value=""/>
                    <input type="button" class="btn_bg btn_size2 btn_center" onclick="accountFormCheck(this);"
                           value="저장"/>
                </div>
            </div>
        </div>
    </div>
</form>
<!-- 사용자 신규 추가 팝업 영역 끝 -->
<!-- wrap end -->
<script>

    getUserList('1');
    // 검색영역 enter key event
    function enterSubmit() {
        if (window.event.keyCode == 13) {
            searchUser();
        }
        return false;
    }

    // 계정 변경 확인 팝업
    let deleteEl;

    function userStatus(user, seqId) {
        let userStatus = Number(user.getAttribute('data'));
        stateEl = user;
        let html = '';
        html +=
            '<div class="layer_pop alert active">' +
            '<div class="pop_container popup_size3">' +
            '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
            '<div class="pop_title">계정 상태 변경</div>' +
            '<div class="pop_inner">';
        if (userStatus == 1) {
            html += '<div class="alert_txt">미사용 처리를 하시겠습니까?</div>';
        }
        if (userStatus == 2) {
            html += '<div class="alert_txt">복구 처리를 하시겠습니까?</div>';
        }
        if (userStatus == 3) {
            html += '<div class="alert_txt">해제 처리를 하시겠습니까?</div>';
        }
        html += '<div class="btn_row">' +
            '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="state(stateEl,'+ seqId+');" value="확인" />' +
            '<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소" />' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';
        $('body .layer_pop.alert').remove();
        $('body').append(html);
        return false;
    }

    // 계정 상태 변경 동작
    function state(row, seqId) {
        let userStatus = Number(row.getAttribute('data'));
        let afterStatus = '';
        if (userStatus == 1) {
            afterStatus = 2;
        }else if (userStatus == 2) {
            afterStatus = 1;
        }else if (userStatus == 3) {
            afterStatus = 2;
        }
        var res = function (response) {
            if(response.check === true){
                if (userStatus == 1) {
                    $(row).attr('data', 2);
                    $(row).text('복구');
                    $(row).parent().siblings('.userStatus').text('미사용');
                }
                if (userStatus == 2) {
                    $(row).attr('data', 1);
                    $(row).text('미사용');
                    $(row).parent().siblings('.userStatus').text('정상');
                }
                if (userStatus == 3) {
                    $(row).parent().html(
                        '<a href="userDetail.html" class="btn_sm_line">수정</a>' +
                        '<div class="btn_sm_line" onclick="userStatus(this);" data="2">미사용</div>'
                    );
                    $(row).parent().siblings('.userStatus').text('정상');
                }
                $('body .layer_pop.alert').remove();
            }else{
                popup.popAlert(response.message);
                popupClose(el);
            }
        };
        var param = {seq:seqId ,usr_st :afterStatus };
        com_ajax.ajax('post', '${baseURL}/sys/user/updateUsrSt.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');

        return false;
    }

    //유효성 체크
    function accountFormCheck(el) {
        let name = document.getElementById('userName').value;
        let email = document.getElementById('userMail').value;
        let logEmail = document.getElementById('usr_log_id').value;
        let phone = document.getElementById('userPhone').value;
        let authority = document.getElementById('authority').getAttribute('data');
        $("#usr_st").val(1);
        let password = document.getElementById('password').value;
        let comfirm = document.getElementById('comfirmPsw').value;
        let regPhone = /(01[0|1|6|9|7])[-](\d{3}|\d{4})[-](\d{4}$)/g;
        let regMail = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
        //let regPwd = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,16}$/;
        let regPwd = /^(?=.*?[a-z])(?=.*?[0-9]).{8,16}$/;
        let error1 = document.getElementById('errorArea1');
        let error2 = document.getElementById('errorArea2');

        error1.innerHTML = '';
        error2.innerHTML = '';

        if (name === '') {
            error2.innerHTML = '이름을 입력해주세요.';
            return false;
        }
        if (email === '') {
            error2.innerHTML = '이메일을 입력해주세요.';
            return false;
        }
        if (logEmail === '') {
            error2.innerHTML = '로그인 이메일을 입력해주세요.';
            return false;
        }
        if (phone === '') {
            error2.innerHTML = '핸드폰 번호를 입력해주세요.';
            return false;
        }
        if (!regMail.test(email)) {
            error2.innerHTML = '이메일 형식에 맞게 입력해주세요.';
            return false;
        }
        if (!regMail.test(logEmail)) {
            error2.innerHTML = '이메일 형식에 맞게 입력해주세요.';
            return false;
        }
        if (!regPhone.test(phone)) {
            error2.innerHTML = '핸드폰 번호 형식에 맞게 입력해주세요.';
            return false;
        }
        if (authority == '') {
            error2.innerHTML = '권한을 선택해주세요.';
            return false;
        }
        if (password == '') {
            error2.innerHTML = '비밀번호를 입력해주세요.';
            return false;
        }
        if (!regPwd.test(password)) {
            error2.innerHTML = '8~16자 영문 대 소문자, 숫자, 특수문자를 사용하세요.';
            return false;
        }
        if (comfirm == '') {
            error1.innerHTML = '비밀번호를 입력해주세요.';
            return false;
        }
        if (password != comfirm) {
            error1.innerHTML = '비밀번호가 일치하지 않습니다.';
            return false;
        } else {
            var res = function (response) {
                if(response.check === true){
                    popup.popAlert(response.message);
                    popupClose(el);
                    getUserList('1')
                }else{
                    popup.popAlert(response.message);
                }
            };
            var param = $("#saveUserForm").serializeArray();
            param.push({name: 'role_cd', value: authority});
            com_ajax.ajax('post', '${baseURL}/sys/user/saveUser.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');

        }
    }

    //신규 사용자 추가 팝업
    function accountPopup() {
        $("#saveUserForm")[0].reset();
        $('.accountPopup').addClass('active');
    }

    function searchUser() {
        let standard = $('.searchSelect').attr('data');
        if (standard == '') {
            popup.searchAlert("기준을 선택해 주세요.");
            return false;
        } else {
            $('#searchType').val(standard);
            getUserList('1');
        }
    }

    //유저리스트
    function getUserList(page) {
        var res = function (response) {
            $("#userList").html(response);
        };
        var param = $("#userSearchForm").serializeArray();
        param.push({name: 'pageNo', value: page});
        com_ajax.ajax('post', '${baseURL}/sys/user/getUserList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function userDetail(seqNo) {
        $('#seq').val(seqNo);
        $('#userDetailForm').attr('action','${baseURL}/sys/user/userDetail.mi');
        $('#userDetailForm').submit();
    }
</script>



