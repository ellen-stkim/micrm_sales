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
            <div class="right">
                <!-- select 영역 시작 -->
                <div class="select style1 left-border" id="searchItems">
                    <!-- selected value -->
                    <div class="value searchSelect" data="">기준선택</div>
                    <!-- option -->
                    <ul class="option">
                        <li data="list_nm">문구명</li>
                        <li data="list_val">수신거부 문구</li>
                        <li data="use_yn">사용여부</li>
                    </ul>
                </div>
                <div class="left" id="typeArea"></div>
                <!-- select 영역 끝 -->
                <input type="hidden" name="searchType" id="searchType"/>
                <input type="text" class="searchInp left-border searchWord" placeholder="검색어입력"
                       id="searchValue" onkeyup="enterSearch();" />
                <input type="submit" class="searchBtn" value="검색" onclick="return searchSmsSetting();" />
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
                <div class="total left">기본 수신거부 문구</div>
            </div>
            <!-- table 영역 시작 -->
            <table class="tableType2" summary="table">
                <colgroup>
                    <col width="156" />
                    <col width="*" />
                </colgroup>
                <input type ="hidden" id="sendDefaultNo" value="${list[0].seq}"/>
                <tbody>
                <tr>
                    <th>문구명</th>
                    <td>
                        <span class="en_font" id ="sendDefaultNm">
                            <c:if test ="${list[0].def_yn == 'Y'}">
                                ${list[0].list_nm}
                            </c:if>
                        </span>
                    </td>
                </tr>
                <tr>
                    <th>수신거부 문구</th>
                    <td>
                        <textarea id ="sendDefaultAddress" cols="30" rows="10" style="width: 100%;height: 80px; padding: 0 15px; resize: none;" readonly><c:if test = "${list[0].def_yn == 'Y'}">${cutil:numberToPhone(list[0].list_val)}</c:if></textarea>
                    </td>
                </tr>
                </tbody>
            </table>
            <div class="count border-bottom cf">
                <div class="total left">수신거부 문구 리스트</div>
                <div class="btn_col right">
                    <input type="button" value="추가" class="btn_sm_line" onclick="rejectTextAddPopup();" />
                    <input type="button" value="기본 문구 지정" class="btn_sm_line" onclick="callingNumPopup();" />
                </div>
            </div>
            <span id ="smsSettingList"></span>
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

<!-- 수신거부 문구 추가 팝업 영역 시작 -->
<div class="layer_pop rejectTextAddPopup">
    <div class="pop_container popup_size1">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
        <div class="pop_title">수신거부 문구 추가</div>
        <div class="pop_inner">
            <form action="" id="postForm1">
                <table class="pop_table_type1" summary="수신거부 문구 추가">
                    <colgroup>
                        <col width="103" />
                        <col width="*" />
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>문구명</th>
                        <td><input type="text" name="list_nm" id="list_nm" placeholder="문구명을 입력해주세요." class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th>수신거부 문구</th>
                        <td><textarea name="list_val" id ="list_val" cols="30" rows="10" placeholder="수신거부 문구를 입력해주세요." style="width: 100%;height: 80px; padding: 0 15px; resize: none;"></textarea>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </form>
            <div class="pop_error_txt blue_point_color" id="errorArea1"></div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_inline" onclick="checkRejectText();" value="저장" />
            </div>
        </div>
    </div>
</div>
<!-- 수신거부 문구 추가 팝업 영역 끝 -->

<!-- 수신거부 문구 수정 팝업 영역 수정 -->
<div class="layer_pop numberRePopup">
    <div class="pop_container popup_size1">
        <input type="button" value="닫기" class="btn_pop_close" onclick="modifyPopupClose(this);" />
        <div class="pop_title">수신거부 문구 수정</div>
        <div class="pop_inner">
            <form action="" id="postForm2">
                <table class="pop_table_type1" summary="수신거부 문구 수정">
                    <colgroup>
                        <col width="103" />
                        <col width="*" />
                    </colgroup>
                    <tbody>
                    <input type ="hidden" name="seq_mod" id="seq_mod"/>
                    <tr>
                        <th>문구명</th>
                        <td><input type="text" name="list_nm_mod" id="list_nm_mod" placeholder="문구명을 입력해주세요." class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th>수신거부 문구</th>
                        <td>
                            <textarea name="list_val_mod" id ="list_val_mod" cols="30" rows="10" placeholder="수신거부 문구를 입력해주세요." style="width: 100%;height: 80px; padding: 0 15px; resize: none;"></textarea>
                    </tr>
                    </tbody>
                </table>
            </form>
            <div class="pop_error_txt blue_point_color" id="errorArea2"></div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_inline" onclick="checkRejectTextModify($('#seq_mod').val());" value="저장" />
            </div>
        </div>
    </div>
</div>
<script>
    $(document).ready(function () {

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
    });

    getSmsSettingList('1');

    // 문자 저장 팝업 띄우기
    function rejectTextAddPopup() {
        $('.rejectTextAddPopup').addClass('active');
    }

    // 문자 수정 팝업 띄우기
    function numberRePopup(seq) {
        const res = function(response){
            $("#list_nm_mod").val(response.data.list_nm);
            $("#list_etc_mod").val(response.data.list_etc);
            $("#list_val_mod").val(response.data.list_val);
            $("#seq_mod").val(response.data.seq);
            $('.numberRePopup').addClass('active');
        }
        let data = []
        data.push({name: 'seq', value: seq });
        com_ajax.ajax('post', '${baseURL}/sys/setting/detailLst.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 숫자 유효성 검사 진행하기
    function chkNumber(number){
        let regExp = new RegExp("/^[0-9]*$/")
        return !regExp.test(number);
    }


    // 수신거부 문구 저장하기
    function saveText() {

        const res = function(response){
            let nowPageNo = $("#nowPageNo").val();
            $("#list_nm").val('');
            $("#list_val").val('');
            $("#errorArea1").html('');
            $('.rejectTextAddPopup').removeClass('active')
            getSmsSettingList(nowPageNo);
        }

        let data = []
        data.push({name : "list_nm" , value : $("#list_nm").val().trim()})
        data.push({name : "list_val" , value : $("#list_val").val().trim()})

        com_ajax.ajax('post', '${baseURL}/sys/setting/insertRejectText.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 중복 체크하기
    function checkRejectText() {

        let textName = $("#list_nm").val().trim();
        let rejectText = $("#list_val").val().trim();

        if(textName == '') {
            $("#errorArea1").html("문구명을 입력해 주세요.")
            return false;
        }
        if(rejectText == '') {
            $("#errorArea1").html('수신거부 문구를 입력해 주세요.')
            return false;
        }

        const res = function(response) {
            if(response.status == true){
                saveText();
            }  else {
                $("#errorArea1").html('중복된 문구 입니다.')
                return false;
            }
        }

        let data = []
        data.push({name : "list_val" , value : rejectText})
        com_ajax.ajax('post', '${baseURL}/sys/setting/isExistSmsAddress.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 중복 체크하기 (수정)
    function checkRejectTextModify(seq) {

        let textName = $("#list_nm_mod").val().trim();
        let rejectText = $("#list_val_mod").val().trim();

        if(textName == '') {
            $("#errorArea2").html("문구명을 입력해 주세요.")
            return false;
        }
        if(rejectText == '') {
            $("#errorArea2").html('수신거부 문구를 입력해 주세요.')
            return false;
        }
        if(!chkNumber(rejectText)){
            $("#errorArea2").html("숫자만 입력해 주세요");
            return false;
        }

        const res = function(response) {
            if(response.status == true){
                modifySms(seq);
            }  else {
                $("#errorArea2").html('중복된 발신번호입니다.')
                return false;
            }
        }

        let data = []
        data.push({name : "list_val" , value : rejectText} )
        data.push({name : "seq" , value : seq} )
        com_ajax.ajax('post', '${baseURL}/sys/setting/isExistSmsModifyAddress.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 삭제 팝업
    let deleteEl, formatNum;
    function deleteAlert(el,seq) {
        deleteEl = el;
        let html = '';
        html +=
            '<div class="layer_pop alert active">' +
            '<div class="pop_container popup_size3">' +
            '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
            '<div class="pop_title">수신거부 문구 삭제</div>' +
            '<div class="pop_inner">' +
            '<div class="alert_txt">선택된 수신거부 문구를 삭제하시겠습니까?</div>' +
            '<div class="btn_row">' +
            '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="deleteSmsAddress('+ seq +');"  value="확인" />' +
            '<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소" />' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';
        $('body .layer_pop.alert').remove();
        $('body').append(html);
        return false;
    }

    function callingNumPopup() {

        let changeNumber = $('input[name="callingNumber"]:checked').val();  // 바꿀 발신 고유 값
        let changeSendNumber = $('input[name="callingNumber"]:checked').parents('label').find('input[name="changeSendNumber"]').val();  // 바꿀 발신 번호
        let changeSender = $('input[name="callingNumber"]:checked').parents('label').find('input[name="changeSender"]').val();  // 바꿀 발신자 명
        let defaultSendNumber = $("#sendDefaultAddress").text().trim(); // 기본 발신 번호

        if (changeNumber != undefined && changeNumber != '') {
            changeSendNumber = phoneFormatter(changeSendNumber)
            let html = '';
            html += '<div class="layer_pop callingNumPopup active">' +
                '<div class="pop_container popup_size1">' +
                '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
                '<div class="pop_title">기본 수신거부 문구 변경</div>' +
                '<div class="pop_inner">' +
                '<table class="pop_table_type1">' +
                '<colgroup>' +
                '<col width="103"/>' +
                '<col width="*"/>' +
                '</colgroup>' +
                '<tbody>' +
                '<tr>' +
                '<th>기존 수신거부 문구</th>' +
                '<td><span>' + defaultSendNumber + '</span></td>' +
                '</tr>' +
                '<tr>' +
                '<th>변경 수신거부 문구</th>' +
                '<td><span>' + changeSendNumber + '</span></td>' +
                '</tr>' +
                '</tbody>' +
                '</table>' +
                '<div class="btn_row">' +
                '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="modifyDefaultAddress(\''+changeNumber+'\')" value="확인" />' +
                '<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소" />' +
                '</div>' +
                '</div>' +
                '</div>' +
                '</div>';
            $('body .layer_pop.callingNumPopup').remove();
            $('body').append(html);
            return false;
        } if (changeNumber == undefined || changeNumber == '') {
            popup.popAlert("변경할 수신거부 문구를 선택해주세요.");
            return false;
        }
    }

    // 문자 리스트 가져오기
    function getSmsSettingList(page) {
        const res = function (response) {
            $("#smsSettingList").html(response);
        };
        let data = [];
        data.push({name: 'pageNo', value: page});
        data.push({name: 'searchType', value: $("#searchType").val()});
        data.push({name: 'searchValue', value: $("#searchValue").val()});
        com_ajax.ajax('post', '${baseURL}/sys/setting/getRejtSettingList.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function enterSearch() {
        if(window.event.keyCode == 13){
            searchSmsSetting()
        }
    }

    // 문자 리스트 검색하기
    function searchSmsSetting() {

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
            getSmsSettingList('1');
        }
    }

    // 문자 리스트 Y,N 값 변경하기
    function updateSmsLstYn(seq,use_yn) {

        const res = function(response){
            let pageNo = $("#nowPageNo").val();
            getSmsSettingList(pageNo)
        }

        let data = []
        data.push({name : "seq" , value : seq })
        data.push({name : "use_yn" , value : use_yn} )

        com_ajax.ajax('post', '${baseURL}/sys/setting/updateSetLstYn.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 삭제 처리
    function deleteSmsAddress(seq){
        let nowPage = $("#nowPageNo").val();

        const res = function(response) {
            $('.alert').removeClass('active');
            if(response.status == true){
                popup.popAlert("삭제 완료 되었습니다");
                getSmsSettingList(nowPage);
            }
        }
        let param = {seq : seq}
        com_ajax.ajax('post', '${baseURL}/sys/setting/deleteAddress.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
        return false;
    }


    // 기본 메일 값 변경 하기
    function modifyDefaultAddress(changeSendNo){

        let nowPage = $("#nowPageNo").val();
        //let changeFormatNumber = phoneFormatter(changerejectText)
        let defaultMailNo = $("#sendDefaultNo").val();

        const res = function(response){
            $('.callingNumPopup').removeClass('active');
            if(response.status == true){
                popup.popAlert("기본 수신거부 문구 변경 완료 되었습니다");
                // 메일 값 설정해 주기
                let changerejectText = $('input[name="callingNumber"]:checked').parents('label').find('input[name="changeSendNumber"]').val();  // 바꿀 발신 번호
                let changeSender = $('input[name="callingNumber"]:checked').parents('label').find('input[name="changeSender"]').val();  // 바꿀 발신자 명

                $("#sendDefaultNo").val(changeSendNo)
                $("#sendDefaultNm").text(changeSender)
                $("#sendDefaultAddress").text(changerejectText)
                getSmsSettingList(nowPage);
            }
        }
        let data = [];
        data.push({name: 'defaultMailNo', value: defaultMailNo});
        data.push({name: 'changeMailNo', value: changeSendNo});

        com_ajax.ajax('post', '${baseURL}/sys/setting/changeDefaultLst.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function modifyPopupClose() {
        $("#errorArea2").html('')
        $('.numberRePopup').removeClass('active');
    }

    function modifySms(seq){

        let senderNm = $("#list_nm_mod").val().trim();
        let rejectText = $("#list_val_mod").val().trim();
        const pageNo = $("#nowPageNo").val();

        const res = function(response) {
            if(response.status == true) {
                popup.popAlert("수정이 완료 되었습니다.")
                $('#errorArea2').html('');
                $('.numberRePopup').removeClass('active');
                getSmsSettingList(pageNo)
            }
        }

        let data = [];
        data.push({name: 'seq', value: seq});
        data.push({name: 'list_nm', value: senderNm});
        data.push({name: 'list_val', value: rejectText});

        com_ajax.ajax('post', '${baseURL}/sys/setting/updateLst.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');

    }

    function phoneFormatter(num){

        var formatNum;

        if(num.length==11){
            formatNum = num.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
        }else if(num.length==8){
            formatNum = num.replace(/(\d{4})(\d{4})/, '$1-$2');
        }else{
            if(num.indexOf('02')==0){
                formatNum = num.replace(/(\d{2})(\d{4})(\d{4})/, '$1-$2-$3');
            }else{
                formatNum = num.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3');
            }
        }
        return formatNum;
    }


</script>