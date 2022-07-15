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
<%--                <div class="tooltip_icon">--%>
<%--                    <img src="../../image/ico_tooltip.png" alt="Tooltip"/>--%>
<%--                </div>--%>
                <!-- tooltip box 영역 시작 -->
<%--                <div class="tooltip_box">--%>
<%--                    <!-- tooltip bullet 영역 -->--%>
<%--                    <div class="bullet"></div>--%>
<%--                    <span class="bold">2019년 12월 신규 취급액은 91.6억 중,<br/>--%>
<%--                                나오론이 52.4억(57.2%)으로 가장 많은 비중을--%>
<%--                                차지합니다.</span>--%>
<%--                    스타일론 직장인이 26.69억(29.1%), <br/>--%>
<%--                    스타일론 자영업자가 4.1억(4.47%)입니다.<br/>--%>
<%--                </div>--%>
                <!-- tooltip box 영역 끝 -->
            </div>
            <div class="right">
                <!-- select 영역 시작 -->
                <div class="select style1 left-border" id="searchItems">
                    <!-- selected value -->
                    <div class="value searchSelect" data="">기준선택</div>
                    <!-- option -->
                    <ul class="option">
                        <li data="list_nm">발신자명</li>
                        <li data="list_val">발신주소</li>
                        <li data="use_yn">사용여부</li>
                    </ul>
                </div>
                <div class="left" id="typeArea"></div>
                <!-- select 영역 끝 -->
                <input type="hidden" name="searchType" id="searchType"/>
                <input type="text" class="searchInp left-border searchWord" id="searchValue" placeholder="검색어입력"
                       onkeyup="enterSearch();"/>
                <input type="submit" class="searchBtn" value="검색" onclick="return searchMailSetting();"/>
            </div>
        </div>
        <!-- row 영역 끝 -->
        <ul class="tab_row">
            <!-- Tab menu -->
            <li<c:if test="${urlPath eq '/sys/setting/mailSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/mailSetting.mi">메일 정보 설정</a></li>
            <li<c:if test = "${urlPath eq '/sys/setting/smsSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/smsSetting.mi">문자 정보 설정</a></li>
            <li<c:if test = "${urlPath eq '/sys/setting/testGroup.mi'}"> class='on'</c:if>><a href="/sys/setting/testGroup.mi">테스트 그룹 설정</a></li>
            <sec:authorize access="hasRole('R10')">
                <li<c:if test="${urlPath eq '/sys/setting/noticeSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/noticeSetting.mi">공지사항 설정</a></li>
            </sec:authorize>
            <%--<li><a href="approval.html">승인 절차 설정</a></li>--%>
        </ul>

        <!-- section 영역 시작 -->
        <div class="section">
            <div class="count border-bottom cf">
                <div class="total left">기본 메일 주소</div>
            </div>
            <!-- table 영역 시작 -->

            <table class="tableType2">
                <colgroup>
                    <col width="156"/>
                    <col width="*"/>
                </colgroup>
                <tbody>
                <input type ="hidden" id="sendDefaultNo" value="${list[0].seq}"/>
                <tr>
                    <th>발신자명</th>
                    <td>
                        <span class="en_font" id="sendDefaultNm">
                            <c:if test ="${list[0].def_yn == 'Y'}">
                                ${list[0].list_nm}
                            </c:if>
                        </span>
                    </td>
                </tr>
                <tr>
                    <th>발신주소</th>
                    <td>
                        <span class="en_font" id="sendDefaultAddress">
                            <c:if test ="${list[0].def_yn == 'Y'}">
                                ${list[0].list_val}
                            </c:if>
                        </span>
                    </td>
                </tr>
                </tbody>
            </table>
            <div class="count border-bottom cf">
                <div class="total left">메일 리스트</div>
                <div class="btn_col right">
                    <input type="button" value="추가" class="btn_sm_line" onclick="addressAddPopup();"/>
                    <input type="button" value="기본 메일 지정" class="btn_sm_line" onclick="mailPostPopup();"/>
                </div>
            </div>
            <form id="userSearchForm" name="userSearchForm" onsubmit="return false">
                <span id="mailSettingList"></span>
            </form>
        </div>
    </div>
    <!-- 컨텐츠 영역 끝 -->
    <!-- footer 영역 시작 -->
    <footer class="footer">
        &copy; Milvus Corp.
    </footer>
    <!-- footer 영역 끝 -->
</section>
<!-- container 영역 끝 -->
<!-- wrap end -->

<div class="layer_pop addressAddPopup">
    <div class="pop_container popup_size1">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
        <div class="pop_title">메일 주소 추가</div>
        <div class="pop_inner">
            <form action="" id="postForm1">
                <table class="pop_table_type1">
                    <colgroup>
                        <col width="103" />
                        <col width="*" />
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>발신자명</th>
                        <td><input type="text" name="list_nm" id ="list_nm" placeholder="발신자명을 입력해주세요." class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th>설명</th>
                        <td><input type="text" name="list_etc" id="list_etc" placeholder="설명을 입력해주세요." class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th>발신주소</th>
                        <td><input type="text" name="list_val" id="list_val" placeholder="발신주소를 입력해주세요." class="input_type1" /></td>
                    </tr>
                    </tbody>
                </table>
            </form>
            <div class="pop_error_txt blue_point_color" id="errorArea1"></div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_inline" onclick="checkMailAddress();" value="저장" />
            </div>
        </div>
    </div>
</div>

<div class="layer_pop addressRePopup">
    <div class="pop_container popup_size1">
        <input type="button" value="닫기" class="btn_pop_close" onclick="modifyPopupClose(this);" />
        <div class="pop_title">메일 주소 수정</div>
        <div class="pop_inner">
            <form action="" id="postForm2">
                <table class="pop_table_type1">
                    <colgroup>
                        <col width="103" />
                        <col width="*" />
                    </colgroup>
                    <tbody>
                    <input type ="hidden" name="seq_mod" id="seq_mod"/>
                    <tr>
                        <th>발신자명</th>
                        <td><input type="text" name="list_nm_mod" id="list_nm_mod" placeholder="발신자명을 입력해주세요." class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th>설명</th>
                        <td><input type="text" name="list_etc_mod" id="list_etc_mod" placeholder="설명을 입력해주세요." class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th>발신주소</th>
                        <td><input type="text" name="list_val_mod" id="list_val_mod" placeholder="발신주소를 입력해주세요." class="input_type1" /></td>
                    </tr>
                    </tbody>
                </table>
            </form>
            <div class="pop_error_txt blue_point_color" id="errorArea2"></div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_inline" onclick="checkMailAddressModify($('#seq_mod').val());" value="저장" />
            </div>
        </div>
    </div>
</div>

<script>
    $(function() {
        $('#searchItems ul li').on('click',function(){
            let searchItem = $(this).attr('data');

            if(searchItem == "list_nm" || searchItem == "list_val"){
                $("#searchValue").val('');
            }

            if(searchItem == "use_yn"){
                $('#searchValue').hide();
                $('#typeArea').html(
                    '<div class="select style1 right-border left-border">' +
                    '<div class="value searchSelect" id="yn_select" data="Y">Y</div>' +
                    '<ul class="option">' +
                    '<li data="Y">Y</li>' +
                    '<li data="N">N</li>' +
                    '</ul>' +
                    '</div> '
                );
            }

            if(searchItem != 'use_yn'){
                $('#searchValue').show();
                $('#typeArea').children().remove();
            }
        });

    })

    getMailSettingList('1');

    function enterSearch() {
        if(window.event.keyCode == 13){
            searchMailSetting()
        }
    }

    function searchMailSetting() {

        let standard = $('.searchSelect').attr('data');
        let searchValue = $("#searchValue").val().trim();

        if(standard == 'use_yn') {
            let yn_data = $("#yn_select").attr('data');
            $("#searchValue").val(yn_data)
        }

        if (standard == '' && searchValue != '') {
            popup.searchAlert("기준을 선택해 주세요.");
            return false;
        } else {
            $('#searchType').val(standard);
            if (standard == 'noti.NOTI_POPYN') {
                var selectData = document.querySelector('#selectData').getAttribute("data");
                $('#searchValue').val(selectData);
            }
            getMailSettingList('1');
        }
    }

    //유저리스트
    function getMailSettingList(page) {
        const res = function (response) {
            $("#mailSettingList").html(response);
        };

        let data = [];
        data.push({name: 'pageNo', value: page});
        data.push({name: 'searchType', value: $("#searchType").val()});
        data.push({name: 'searchValue', value: $("#searchValue").val()});
        com_ajax.ajax('post', '${baseURL}/sys/setting/getMailSettingList.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 메일리스트 Y,N 값 변경하기
    function updateMailLstYn(seq,use_yn) {

        const res = function(response){
            let pageNo = $("#nowPageNo").val();
            getMailSettingList(pageNo)
        }

        let data = []
        data.push({name : "seq" , value : seq })
        data.push({name : "use_yn" , value : use_yn} )

        com_ajax.ajax('post', '${baseURL}/sys/setting/updateSetLstYn.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 추가 팝업 띄우기
    function addressAddPopup() {
        $('.addressAddPopup').addClass('active');
    }

    // 수정 팝업 띄우기
    function addressRePopup(seq){

        const res = function(response){
            $("#list_nm_mod").val(response.data.list_nm);
            $("#list_etc_mod").val(response.data.list_etc);
            $("#list_val_mod").val(response.data.list_val);
            $("#seq_mod").val(response.data.seq);
            $('.addressRePopup').addClass('active');
        }

        let data = []
        data.push({name: 'seq', value: seq });
        com_ajax.ajax('post', '${baseURL}/sys/setting/detailLst.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 메일 저장하기
    function saveMail() {

        const res = function(response){
            let nowPageNo = $("#nowPageNo").val();
            $("#list_nm").val('');
            $("#list_etc").val('');
            $("#list_val").val('');
            $("#errorArea1").html('');
            $('.addressAddPopup').removeClass('active')
            getMailSettingList(nowPageNo);
        }

        let data = []
        data.push({name : "list_nm" , value : $("#list_nm").val().trim()})
        data.push({name : "list_etc" , value : $("#list_etc").val().trim()})
        data.push({name : "list_val" , value : $("#list_val").val().trim()})

        com_ajax.ajax('post', '${baseURL}/sys/setting/insertMail.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 이메일 유효성 검사 진행하기
    function chkEmail(email){
        let regExp = new RegExp("[ㄱ-ㅎ가-힣A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,64}")
        return regExp.test(email);
    }

    // 중복 메일 체크하기
    function checkMailAddress() {

        let senderNm = $("#list_nm").val().trim();
        let sendAddress = $("#list_val").val().trim();
        let sendEtc = $("#list_etc").val().trim();

        if(senderNm == '') {
            $("#errorArea1").html("발신자명을 입력해주세요.")
            return false;
        }
        if(sendEtc == '') {
            $("#errorArea1").html("설명을 입력해주세요.");
            return false;
        }
        if(sendAddress == '') {
            $("#errorArea1").html('발신주소를 입력해주세요.')
            return false;
        }
        if(!chkEmail(sendAddress)){
            $("#errorArea1").html("이메일 형식이 일치하지 않습니다");
            return false;
        }

        const res = function(response) {
            if(response.status == true){
                saveMail();
            }  else {
                $("#errorArea1").html('중복된 발신주소입니다.')
                return false;
            }
        }

        let data = []
        data.push({name : "list_val" , value : sendAddress} )
        com_ajax.ajax('post', '${baseURL}/sys/setting/isExistMailAddress.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 중복 메일 수정 체크하기
    function checkMailAddressModify(seq) {

        let senderNm = $("#list_nm_mod").val().trim();
        let sendAddress = $("#list_val_mod").val().trim();
        let sendEtc = $("#list_etc_mod").val().trim();

        if(senderNm == '') {
            $("#errorArea2").html("발신자명을 입력해주세요.")
            return false;
        }
        if(sendEtc == '') {
            $("#errorArea2").html("설명을 입력해주세요.");
            return false;
        }
        if(sendAddress == '') {
            $("#errorArea2").html('발신주소를 입력해주세요.')
            return false;
        }
        if(!chkEmail(sendAddress)){
            $("#errorArea2").html("이메일 형식이 일치하지 않습니다");
            return false;
        }

        const res = function(response) {
            if(response.status == true){
               modifyMail(seq);
            }  else {
                $("#errorArea2").html('중복된 발신주소입니다.')
                return false;
            }
        }

        let data = []
        data.push({name : "list_val" , value : sendAddress} )
        data.push({name : "seq" , value : seq} )
        com_ajax.ajax('post', '${baseURL}/sys/setting/isExistMailModifyAddress.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 기존 주소값 변경
    function mailPostPopup() {
        let changeMail = $('input[name="mailAddress"]:checked').parents('label').find('input[name="changeMail"]').val()
        let changeSender = $('input[name="mailAddress"]:checked').parents('label').find('input[name="changeSender"]').val()
        let changeMailNo = $('input[name=mailAddress]:checked').val();
        let defaultMail = $('#sendDefaultAddress').text().trim();

        if (changeMail != undefined && changeMail != '') {
            let html = '';
            html += '<div class="layer_pop mailPostPopup active">' +
                '<div class="pop_container popup_size1">' +
                '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
                '<div class="pop_title">기본 메일 변경</div>' +
                '<div class="pop_inner">' +
                '<table class="pop_table_type1">' +
                '<colgroup>' +
                '<col width="103"/>' +
                '<col width="*"/>' +
                '</colgroup>' +
                '<tbody>' +
                '<tr>' +
                '<th>기존 메일</th>' +
                '<td><span>' + defaultMail + '</span></td>' +
                '</tr>' +
                '<tr>' +
                '<th>변경 메일</th>' +
                '<td><span>' + changeMail + '</span></td>' +
                '</tr>' +
                '</tbody>' +
                '</table>' +
                '<div class="btn_row">' +
                '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="modifyDefaultAddress(\''+changeMailNo+'\',\''+changeSender+'\',\''+changeMail+'\')" value="확인" />' +
                '<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소" />' +
                '</div>' +
                '</div>' +
                '</div>' +
                '</div>';
            $('body .layer_pop.mailPostPopup').remove();
            $('body').append(html);
            return false;
        } if (changeMail == undefined || changeMail == '') {
            popup.popAlert("변경할 메일 주소를 선택해주세요.");
            return false;
        }
    }

    // 삭제 팝업
    function deleteAlert(el,seq) {
        deleteEl = el;
        let html = '';
        html +=
            '<div class="layer_pop alert active" id="deleteMailPopUp">' +
            '<div class="pop_container popup_size3">' +
            '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
            '<div class="pop_title">메일 주소 삭제</div>' +
            '<div class="pop_inner">' +
            '<div class="alert_txt">선택된 메일 주소를 삭제하시겠습니까?</div>' +
            '<div class="btn_row">' +
            '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="deleteMailAddress('+ seq +');" value="확인" />' +
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
    function deleteMailAddress(seq){
        let nowPage = $("#nowPageNo").val();

        const res = function(response) {
            $('.alert').removeClass('active');
            if(response.status == true){
                popup.popAlert("삭제 완료 되었습니다");
                getMailSettingList(nowPage);
            }
        }

        let param = {seq : seq}
        com_ajax.ajax('post', '${baseURL}/sys/setting/deleteAddress.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
        return false;
    }

    // 기본 메일 변경하기
    function modifyDefaultAddress(changeMailNo,changeSender,changeMail){

        let nowPage = $("#nowPageNo").val();
        let defaultMailNo = $("#sendDefaultNo").val();

        const res = function(response){
            $('.mailPostPopup').removeClass('active');
            if(response.status == true){
                popup.popAlert("기본 메일 변경 완료 되었습니다");
                // 메일 값 설정해 주기
                $("#sendDefaultNo").val(changeMailNo)
                $("#sendDefaultNm").text(changeSender)
                $("#sendDefaultAddress").text(changeMail)
                getMailSettingList(nowPage);
            }
        }

        let data = [];
        data.push({name: 'defaultMailNo', value: defaultMailNo});
        data.push({name: 'changeMailNo', value: changeMailNo});

        com_ajax.ajax('post', '${baseURL}/sys/setting/changeDefaultLst.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 수정하기
    function modifyMail(seq){

        let senderNm = $("#list_nm_mod").val().trim();
        let sendAddress = $("#list_val_mod").val().trim();
        let sendEtc = $("#list_etc_mod").val().trim();
        const pageNo = $("#nowPageNo").val();

        console.log("pageNo :" + pageNo)

        const res = function(response) {
            if(response.status == true) {
                popup.popAlert("수정이 완료 되었습니다.")
                $('#errorArea2').html('');
                $('.addressRePopup').removeClass('active');
                getMailSettingList(pageNo)
            }
        }

        let data = [];
        data.push({name: 'seq', value: seq});
        data.push({name: 'list_nm', value: senderNm});
        data.push({name: 'list_val', value: sendAddress});
        data.push({name: 'list_etc', value: sendEtc});

        com_ajax.ajax('post', '${baseURL}/sys/setting/updateLst.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');

    }

    function modifyPopupClose() {
        $("#errorArea2").html('')
        $('.addressRePopup').removeClass('active');
    }


</script>
