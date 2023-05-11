<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil"%>
<!-- container 영역 시작 -->
<section class="container">
    <!-- 컨텐츠 영역 시작 -->
    <div class="contents">
        <!-- row 영역 시작 -->
        <div class="row tooltip_area bottom-border cf">
            <div class="left">
                <!-- location 영역 -->
                <ul class="location">
                    <li>홈</li>
                    <li>시스템관리</li>
                    <li>사용자</li>
                </ul>
                <!-- tooltip 버튼 영역  -->
<%--                <div class="tooltip_icon">--%>
<%--                    <img src="../../image/ico_tooltip.png" alt="Tooltip" />--%>
<%--                </div>--%>
                <!-- tooltip box 영역 시작 -->
<%--                <div class="tooltip_box">--%>
<%--                    <!-- tooltip bullet 영역 -->--%>
<%--                    <div class="bullet"></div>--%>
<%--                    <span class="bold">2019년 12월 신규 취급액은 91.6억 중,<br />--%>
<%--								나오론이 52.4억(57.2%)으로 가장 많은 비중을--%>
<%--								차지합니다.</span>--%>
<%--                    스타일론 직장인이 26.69억(29.1%), <br />--%>
<%--                    스타일론 자영업자가 4.1억(4.47%)입니다.<br />--%>
<%--                </div>--%>
                <!-- tooltip box 영역 끝 -->
            </div>
        </div>
        <!-- row 영역 끝 -->
        <div class="tab_row">
            <div class="on">사용자 관리</div>
        </div>
        <!-- section 영역 시작 -->
        <div class="section">
            <div class="count border-bottom cf">
                <div class="total left">사용자 계정 상세 정보</div>
            </div>
            <div class="line_wrap cf">
                <!-- 기본정보 영역 시작 -->
                <div class="user_basic left">
                    <div class="table_tit">
                        <span>기본정보</span>
                        <input type="button" class="btn_sm_line" onclick="accountPopup();" value="수정" />
                    </div>
                    <table class="tableType1" summary="table">
                        <colgroup>
                            <col width="102" />
                            <col width="*" />
                        </colgroup>
                        <tbody id="tableInfo">
                        <tr>
                            <th scope="row">이름</th>
                            <td><span id="usrNm">${list[0].usr_nm}</span></td>
                        </tr>
                        <tr>
                            <th scope="row">로그인 이메일</th>
                            <td><span class="en_font" id="usrLogId">${list[0].usr_log_id}</span></td>
                        </tr>
                        <tr>
                            <th scope="row">이메일</th>
                            <td><span class="en_font" id="usrEmail">${list[0].usr_email}</span></td>
                        </tr>
                        <tr>
                            <th scope="row">휴대폰 번호</th>
                            <td><span class="en_font" id="usrPhone">
                                <c:if test="${!cutil:isEmptyObject(list[0].usr_mob)}">
                                    ${cutil:numberToPhone(list[0].usr_mob)}
                                </c:if>
                            </span></td>
                        </tr>
                        <tr>
                            <th scope="row">권한</th>
                            <td><span id="usrAuth">${list[0].cd_nm}</span></td>
                        </tr>
                        <tr>
                            <th scope="row">비밀번호</th>
                            <td><span>비밀번호는 수정 시 변경 가능합니다.</span></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <!-- 기본정보 영역 끝 -->
                <!-- 개인로그 영역 시작 -->
                <div class="user_log left" id="userLogSection">
                </div>
                <!-- 개인로그 영역 끝 -->
            </div>
        </div>
        <!-- section 영역 끝 -->
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
<!-- 사용자 수정 팝업 영역 시작 -->
<form id="saveUserForm" name="saveUserForm" onsubmit="return false">
    <div class="layer_pop accountPopup">
        <div class="pop_container popup_size1">
            <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
            <div class="pop_title">사용자 수정</div>
            <div class="pop_inner">
                <table class="pop_table_type1" summary="사용자 수정">
                    <colgroup>
                        <col width="103"/>
                        <col width="*"/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th scope="row">이름</th>
                        <td>
                            <input type="text" id="userName" class="input_type1" value="${list[0].usr_nm}" readonly/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">로그인 이메일</th>
                        <td>
                            <input type="text" id="userLogId" class="input_type1" value="${list[0].usr_log_id}" readonly/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">이메일</th>
                        <td>
                            <input type="text" id="userMail" name="usr_email" class="input_type1" value="${list[0].usr_email}"/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">핸드폰번호</th>
                        <td>
                            <input type="text" id="userPhone" placeholder="사용자의 핸드폰 번호을 입력해주세요." name="usr_mob" class="input_type1" value=
                            <c:if test="${!cutil:isEmptyObject(list[0].usr_mob)}">
                                    "${cutil:numberToPhone(list[0].usr_mob)}"
                            </c:if>/>
                        </td>
                    </tr>
                    <sec:authorize access="hasRole('R10')">
                    <tr>
                        <th scope="row">권한</th>
                        <td class="pd_none">
                            <!-- select 영역 시작 -->
                            <div class="select fix">
                                <!-- selected value -->
                                <div class="value" id="authority" data="${list[0].role_cd}">${list[0].cd_nm}</div>
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
                    </sec:authorize>
                    <tr>
                        <th scope="row">새 비밀번호</th>
                        <td>
                            <input type="password" placeholder="새 비밀번호를 입력해주세요." id="password" name="usr_pw"
                                   class="input_type1 pwd"/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">새 비밀번호 확인</th>
                        <td>
                            <input type="password" placeholder="새 비밀번호를 입력해주세요." id="comfirmPsw" name="usr_pw_ck"
                                   class="input_type1 pwd"/>
                            <div class="right blue_point_color" id="errorArea1"></div>
                        </td>
                    </tr>
                    </tbody>
                </table>
                <div class="pop_error_txt blue_point_color" id="errorArea2"></div>
                <div class="btn_row">
                    <input type="hidden" name="seq" id="seq" value="${list[0].seq}"/>
                    <input type="hidden" name="usr_id" id="usr_id" value="${list[0].usr_id}"/>
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
    // 계정 변경 확인 팝업
    let deleteEl;

    function userStatus(user) {
        let userStatus = Number(user.getAttribute('data'));
        stateEl = user;
        let html = '';
        html +=
            '<div class="layer_pop alert active">' +
            '<div class="pop_container popup_size3">' +
            '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
            '<div class="pop_title">계정 상태 변경</div>' +
            '<div class="pop_inner">';
        if (userStatus == 0) {
            html += '<div class="alert_txt">미사용 처리를 하시겠습니까?</div>';
        }
        if (userStatus == 1) {
            html += '<div class="alert_txt">복구 처리를 하시겠습니까?</div>';
        }
        if (userStatus == 2) {
            html += '<div class="alert_txt">해제 처리를 하시겠습니까?</div>';
        }
        html += '<div class="btn_row">' +
            '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="state(stateEl);" value="확인" />' +
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
    function state(row) {
        let userStatus = Number(row.getAttribute('data'));
        if (userStatus == 0) {
            $(row).attr('data', 1);
            $(row).text('복구');
            $(row).parent().siblings('.userStatus').text('미사용');
        }
        if (userStatus == 1) {
            $(row).attr('data', 0);
            $(row).text('미사용');
            $(row).parent().siblings('.userStatus').text('정상');
        }
        if (userStatus == 2) {
            $(row).parent().html(
                '<a href="userDetail.html" class="btn_sm_line">수정</a>' +
                '<div class="btn_sm_line" onclick="userStatus(this);" data="0">미사용</div>'
            );
            $(row).parent().siblings('.userStatus').text('정상');
        }
        $('body .layer_pop.alert').remove();
        return false;
    }

    //유효성 체크
    function accountFormCheck(el) {
        let name = document.getElementById('userName').value;
        let email = document.getElementById('userMail').value;
        let phone = document.getElementById('userPhone').value;
        let authority = document.getElementById('authority').getAttribute('data');
        let authorityNm = $('#authority').html();
        $("#usr_st").val(authority);
        //let regPwd = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,16}$/;
        let password = document.getElementById('password').value;
        let comfirm = document.getElementById('comfirmPsw').value;
        let regPhone = /(01[0|1|6|9|7])[-](\d{3}|\d{4})[-](\d{4}$)/g;
        let regMail = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
        /*let regPwd = /^(?=.*?[a-z])(?=.*?[0-9]).{8,16}$/;*/
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
        if (phone === '') {
            error2.innerHTML = '휴대폰번호를 입력해주세요.';
            return false;
        }
        if (!regPhone.test(phone)) {
            error2.innerHTML = '핸드폰 번호 형식에 맞게 입력해주세요.';
            return false;
        }
        if (!regMail.test(email)) {
            error2.innerHTML = '이메일 형식에 맞게 입력해주세요.';
            return false;
        }
        if (authority == '') {
            error2.innerHTML = '권한을 선택해주세요.';
            return false;
        }
        if(password != ''){
           /* if (!regPwd.test(password)) {
                error2.innerHTML = '8~16자 영문 대 소문자, 숫자, 특수문자를 사용하세요.';
                return false;
            }*/
            if (comfirm == '') {
                 error1.innerHTML = '비밀번호를 입력해주세요.';
                 return false;
            }
            if (password != comfirm) {
                error1.innerHTML = '비밀번호가 일치하지 않습니다.';
                return false;
            }
        }

        var res = function (response) {
            if(response.check === true){
                $('#usrNm').html(name);
                $('#usrEmail').html(email);
                $('#usrPhone').html(phone);
                $('#usrAuth').html(authorityNm);
                popup.popAlert(response.message);
                popupClose(el);
            }else{
                popup.popAlert(response.message);
                popupClose(el);
            }
        };
        var param = $("#saveUserForm").serializeArray();
        param.push({name: 'role_cd', value: authority});
        com_ajax.ajax('post', '${baseURL}/sys/user/saveUser.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    //신규 사용자 추가 팝업
    function accountPopup() {
        $('.accountPopup').addClass('active');
    }

    //개인로그 가져오기
    function getUserLog(page) {
        var res = function (response) {
           $("#userLogSection").html(response);
            var listSize = $('#sizeList').val();
            if(listSize<10){
                var addBodyCnt = 10-listSize;
                var html = '<tr><td></td><td></td><td></td></tr>';
                for(var i =0; i<addBodyCnt; i++){
                    $('#userLogTbody').append(html);
                }
            }
        };

        var param = {usr_id: $('#usr_id').val(),pageNo: page};
        com_ajax.ajax('post', '${baseURL}/sys/user/getUserLog.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    };
    getUserLog('1');

</script>



