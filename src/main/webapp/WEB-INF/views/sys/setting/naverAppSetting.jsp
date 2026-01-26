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
                    <li>환경</li>
                </ul>
                <!-- tooltip 버튼 영역  -->
                <div class="tooltip_icon">
                    <img src="../../image/ico_tooltip.png" alt="Tooltip" />
                </div>
                <!-- tooltip box 영역 시작 -->
                <%--<div class="tooltip_box">
                    <!-- tooltip bullet 영역 -->
                    <div class="bullet"></div>
                    <span class="bold">2019년 12월 신규 취급액은 91.6억 중,<br />
                                나오론이 52.4억(57.2%)으로 가장 많은 비중을
                                차지합니다.</span>
                    스타일론 직장인이 26.69억(29.1%), <br />
                    스타일론 자영업자가 4.1억(4.47%)입니다.<br />
                </div>--%>
                <!-- tooltip box 영역 끝 -->
            </div>

        </div>
        <!-- row 영역 끝 -->
        <ul class="tab_row">
            <!-- Tab menu -->
            <li<c:if test = "${urlPath eq '/sys/setting/teamSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/teamSetting.mi">팀 정보 설정</a></li>
            <li<c:if test = "${urlPath eq '/sys/setting/mappingSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/mappingSetting.mi">매핑 정보 설정</a></li>
            <li<c:if test = "${urlPath eq '/sys/setting/smsSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/smsSetting.mi">문자 정보 설정</a></li>
            <%--<li><a href="approval.html">승인 절차 설정</a></li>--%>
            <li<c:if test = "${urlPath eq '/sys/setting/kkoSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/kkoSetting.mi">카카오 정보 설정</a></li>
            <li<c:if test = "${urlPath eq '/sys/setting/rejectSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/rejectSetting.mi">수신거부 문구 설정</a></li>
            <li<c:if test = "${urlPath eq '/sys/setting/naverAppSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/naverAppSetting.mi">네이버 Short URL 설정</a></li>
        </ul>
        <!-- section 영역 시작 -->
        <div class="section">
            <div class="count border-bottom cf">
                <div class="total left">네이버 Short URL 설정</div>
                <div class="btn_col right">
                        <c:if test = "${list.list[0].seq eq null}">
                            <input type="button" value="추가" id="addBtn" class="btn_sm_line" onclick="naverAppAddPopup()" />
                        </c:if>
                        <c:if test = "${list.list[0].seq ne null}">
                            <input type="button" value="수정" id="modifyBtn" class="btn_sm_line" onclick="naverAppModifyPopup()" />
                            <input type="button" value="삭제" id="deleteBtn" class="btn_sm_line" onclick="naverAppDeletePopup()" />
                        </c:if>

                </div>

            </div>
            <!-- table 영역 시작 -->
            <table class="tableType2" summary="table">
                <colgroup>
                    <col width="156" />
                    <col width="*" />
                </colgroup>
                <input type ="hidden" id="seq" value="${list.list[0].seq}"/>
                <tbody>
                <tr>
                    <th scope="row">Client ID</th>
                    <td>
                        <span class="en_font" id ="clientId">
                            ${list.list[0].list_nm}
                        </span>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Client Secret</th>
                    <td>
                        <span class="en_font" id="clientSecret">
                            ${list.list[0].list_val}
                        </span>
                    </td>
                </tr>
                </tbody>
            </table>

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

<div class="layer_pop naverAppAddPopup">
    <div class="pop_container popup_size1">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
        <div class="pop_title">네이버 Short URL 설정 추가</div>
        <div class="pop_inner">
            <form action="" id="postForm1">
                <table class="pop_table_type1" summary="네이버 Short URL 설정 추가">
                    <colgroup>
                        <col width="103" />
                        <col width="*" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th>Client ID</th>
                            <td><input type="text" name="list_client_id" id ="list_client_id" placeholder="Client ID를 입력해주세요." class="input_type1" /></td>
                        </tr>
                        <tr>
                            <th>Client Secret</th>
                            <td><input type="text" name="list_client_secret" id ="list_client_secret" placeholder="Client Secret을 입력해주세요." class="input_type1" /></td>
                        </tr>
                    </tbody>
                </table>
            </form>
            <div class="pop_error_txt blue_point_color" id="errorArea1"></div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_inline" onclick="addNaverApp();" value="저장" />
            </div>
        </div>
    </div>
</div>
<div class="layer_pop naverAppModifyPopup">
    <div class="pop_container popup_size1">
        <input type="button" value="닫기" class="btn_pop_close" onclick="modifyPopupClose(this);" />
        <div class="pop_title">네이버 Short URL 설정 수정</div>
        <div class="pop_inner">
            <form action="" id="postForm2">
                <table class="pop_table_type1" summary="네이버 Short URL 설정 정보 수정">
                    <colgroup>
                        <col width="103" />
                        <col width="*" />
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>Client ID</th>
                        <td><input type="text" name="list_client_id_mod" id="list_client_id_mod" value="${list.list[0].list_nm}" placeholder="Client ID를 입력해주세요." class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th>Client Secret</th>
                        <td><input type="text" name="list_client_secret_mod" id="list_client_secret_mod" value="${list.list[0].list_val}" placeholder="Client Secret을 입력해주세요." class="input_type1" /></td>
                    </tr>
                    </tbody>
                </table>
            </form>
            <div class="pop_error_txt blue_point_color" id="errorArea2"></div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_inline" onclick="modifyNaverApp()" value="저장" />
            </div>
        </div>
    </div>
</div>
<script>

    function naverAppAddPopup() {
        $('.naverAppAddPopup').addClass('active');
    }

    function addNaverApp() {
        checkAddInput();

        const res = function(response){
            window.location.href = '';
        }

        let data = []
        data.push({name : "list_nm" , value : $("#list_client_id").val().trim()})
        data.push({name : "list_val" , value : $("#list_client_secret").val().trim()})

        com_ajax.ajax('post', '${baseURL}/sys/setting/insertNaverApp.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function checkAddInput() {

        let clientId = $("#list_client_id").val().trim();
        let clientSecret = $("#list_client_secret").val().trim();

        if(clientId == '') {
            $("#errorArea1").html('Client ID를 입력해 주세요.')
            return false;
        }
        if(clientSecret == '') {
            $("#errorArea1").html('Client Secret을 입력해 주세요.')
            return false;
        }
    }

    function naverAppModifyPopup() {
        $('.naverAppModifyPopup').addClass('active');
    }

    function modifyPopupClose() {
        $("#errorArea2").html('')
        $('.naverAppModifyPopup').removeClass('active');
    }

    function modifyNaverApp(){
        checkModifyInput();

        let clientId = $("#list_client_id_mod").val().trim();
        let clientSecret = $("#list_client_secret_mod").val().trim();
        let seq = $("#seq").val();

        const res = function(response) {
            popup.popAlertCallback("수정이 완료 되었습니다.", "window.location.reload();")
        }

        let data = [];
        data.push({name: 'list_nm', value: clientId});
        data.push({name: 'list_val', value: clientSecret});
        data.push({name : "seq" , value : seq} )
        com_ajax.ajax('post', '${baseURL}/sys/setting/updateNaverApp.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function checkModifyInput() {

        let clientId = $("#list_client_id_mod").val().trim();
        let clientSecret = $("#list_client_secret_mod").val().trim();

        if(clientId == '') {
            $("#errorArea2").html('Client ID를 입력해 주세요.')
            return false;
        }
        if(clientSecret == '') {
            $("#errorArea2").html('Client Secret을 입력해 주세요.')
            return false;
        }
    }

    // 삭제 팝업
    function naverAppDeletePopup() {
        let html = '';
        html +=
            '<div class="layer_pop alert active">' +
            '<div class="pop_container popup_size3">' +
            '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
            '<div class="pop_title">네이버 Short URL 설정 삭제</div>' +
            '<div class="pop_inner">' +
            '<div class="alert_txt">네이버 Short URL 설정을 삭제하시겠습니까?</div>' +
            '<div class="btn_row">' +
            '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="deleteNaverApp();"  value="확인" />' +
            '<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소" />' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';
        $('body .layer_pop.alert').remove();
        $('body').append(html);
        return false;
    }

    // 삭제 처리
    function deleteNaverApp(){
        let seq = $("#seq").val();

        const res = function() {
            $('.alert').removeClass('active');

            popup.popAlertCallback("삭제 완료 되었습니다.", "window.location.reload();")
        }
        let data = [];
        data.push({name : "seq" , value : seq} )
        com_ajax.ajax('post', '${baseURL}/sys/setting/deleteNaverApp.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
        return false;
    }

</script>