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
        <form id="tmlmiSupForm" name="tmlmiSupForm" onsubmit="return false">
            <div class="row tooltip_area bottom-border cf">
                <div class="left">
                    <!-- location 영역 -->
                    <ul class="location">
                        <li>홈</li>
                        <li>회원관리</li>
                        <li>수신거부 회원</li>
                    </ul>
                    <!-- tooltip 버튼 영역  -->
<%--                    <div class="tooltip_icon">--%>
<%--                        <img src="/image/ico_tooltip.png" alt="Tooltip"/>--%>
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
                    <div class="select style1 left-border" id="rejectSearch">
                        <!-- selected value -->
                        <div class="value searchSelect" data="" >기준선택</div>
                        <!-- option -->
                        <ul class="option">
                            <li data="sup_type">유형</li>
                            <li data="pro_id">회원번호</li>
                            <li data="ch_type">채널</li>
                            <li data="send_to">주소</li>
                            <li data="camp_nm">캠페인</li>
                        </ul>
                    </div>
                    <!-- select 영역 끝 -->
                    <span class="input_append">
                            <input type="text" class="searchInp left-border" name="searchValue" id="searchValue"
                           placeholder="검색어입력"/>
                    </span>
                    <input type="hidden" id="searchType" name="searchType"/>
                    <input type="submit" class="searchBtn" value="검색" onclick="return searchTblmiSup();"/>
                </div>
            </div>
        </form>
        <!-- row 영역 끝 -->
        <!-- row 영역 시작 -->
        <div class="row bottom-border cf">
            <div class="left">
                <input type="button" class="btn_basic down left right-border" value="내려받기"
                       onclick="downloadTblmiSup();"/>
                <input type="button" class="btn_basic rejection left right-border" value="수신거부 추가"
                       onclick="rejectionPopup();"/>
                <input type="button" class="btn_basic checkDelete left right-border" value="선택삭제"
                       onclick="deleteCheck();"/>
                <input type="button" class="btn_basic delete left right-border" value="전체삭제"
                       onclick="allDeletePopup();"/>
                <a href="#" class="btn_basic rejection left right-border"></a>
                <div class="info_txt left">※ 내려받기 시, 검색된 리스트가 다운로드됩니다.</div>
            </div>
        </div>
        <!-- row 영역 끝 -->
        <span id="tblmiSupListAppend"></span>
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

<!-- 수신거부 추가 팝업 영역 시작 -->

<div class="layer_pop rejectionPopup">
    <div class="pop_container popup_size1">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
        <div class="pop_title">수신거부 추가</div>
        <div class="pop_inner">
            <ul class="pop_tap_nav cf">
                <li class="on">개별 등록</li>
                <li>파일 업로드</li>
            </ul>
            <div class="tap_contents on">
                <form id="saveTblmiSupList" name="saveTblmiSupList" onsubmit="return false" >
                <table class="pop_table_type1">
                    <colgroup>
                        <col width="103"/>
                        <col width="*"/>
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>채널</th>
                        <td>
                            <input type="hidden" id="sup_type" name="sup_type" value="SUP02"/>
                            <input type="hidden" id="ch_type" name="ch_type" value="CH02"/>
                            <label class="custom_radio channel">
                                모바일
                                <input name="chennel" type="radio" value="sms" checked><span></span>
                            </label>
                            <label class="custom_radio channel">
                                이메일<input name="chennel" type="radio" value="mail"><span></span>
                            </label>
                        </td>
                    </tr>
                    <tr class="row_mobile">
                        <th>모바일</th>
                        <td>
                            <input type="text" placeholder="핸드폰 번호를 입력해주세요." id="sms" class="input_type1" onkeyup="enterKey();"/>
                        </td>
                    </tr>
                    <tr class="row_email off">
                        <th>이메일</th>
                        <td>
                            <input type="text" placeholder="이메일 주소를 입력해주세요." id="email" class="input_type1" onkeyup="enterKey();"/>
                        </td>
                    </tr>
                    </tbody>
                </table>
                <div class="pop_error_txt blue_point_color" id="individualError"></div>
                <div class="btn_row">
                    <input type="button" class="btn_bg btn_size2 btn_center" value="저장" onclick="channelCheck();"/>
                </div>
                </form>
            </div>
            <div class="tap_contents">
                <form id="fileUpload" name="fileUpload" onsubmit="return false" >
                <article class="pop_section">
                    <div class="btn_form_down" onclick="formFileDown();">양식 파일 다운로드</div>
                    <div class="align_center">
                        <input type="text" id="fileName" class="input_file" placeholder="파일을 선택해주세요." readonly/>
                        <span class="btn_file">선택<input type="file" class="file" name="file" id="file" accept=".xls,.xlsx" onclick="fileReset()"/></span>
                    </div>
                </article>
                <span id="filePreview"></span>
                <div class="btn_row">
                    <input type="button" class="btn_bg btn_size2 btn_center" value="저장" onclick="uploadCheck();"/>
                </div>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- 수신거부 추가 팝업 영역 끝 -->

<!-- 오류안내 팝업 영역 시작 -->
<div class="layer_pop errorPopup">
    <div class="pop_container popup_size3">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
        <div class="pop_title">오류안내</div>
        <div class="pop_inner">
            <div class="alert_txt">
                오류 <span id="errCnt"></span>건이 있습니다.<br/>
                이대로 반영하시겠습니까?<br/><br/>
                *오류 건은 제외 후 리스트에 반영됩니다.
            </div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_inline" onclick="saveTblmiSubFile();" value="확인">
                <input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소">
            </div>
        </div>
    </div>
</div>
<!-- 오류안내 추가 팝업 영역 끝 -->
<!-- 삭제안내 팝업 영역 시작 -->
<div class="layer_pop deletePopup" id="deleteAllPop">
    <div class="pop_container popup_size3">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
        <div class="pop_title">삭제안내</div>
        <div class="pop_inner">
            <div class="alert_txt">
                전체 수신거부 리스트 <span class="length" id="deleteLength"></span>개의 회원을 삭제하시겠습니까?<br/>
                복원이 불가합니다.
            </div>
            <input type="password" placeholder="비밀번호입력" class="password_input border" id="deletePassword"/>
            <div class="pop_error_txt blue_point_color" id="errorArea1"></div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_inline" id="deleteSave"
                       onclick="listDelete(document.getElementById('deletePassword').value);" value="확인"/>
                <input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소"/>
            </div>
        </div>
    </div>
</div>
<!-- 삭제안내 팝업 영역 끝 -->

<script>
    $(function () {
        getTblmiSupList("1");

        $('#rejectSearch .option li').on('click',function(){
            let optionVal = $(this).attr('data');
            if(optionVal == 'sup_type'){
                $('.input_append').html(
                    '<div class="select style1 left-border right-border">' +
                    '<input type="hidden" name="searchValue" id="searchValue"/>' +
                        '<div class="value searchSelect" data="SUP01" id="selectData">Upload</div>' +
                        '<ul class="option">' +
                        '<li data="SUP01">Upload</li>' +
                        '<li data="SUP02">Direct</li>' +
                        '<li data="SUP03">Link</li>' +
                        '</ul>' +
                    '</div>'
                );
            }else if(optionVal == 'ch_type'){
                $('.input_append').html(
                    '<div class="select style1 left-border right-border">' +
                    '<input type="hidden" name="searchValue" id="searchValue"/>' +
                    '<div class="value searchSelect"  data="CH02" id="selectData">모바일</div>' +
                    '<ul class="option">' +
                    '<li data="CH02">모바일</li>' +
                    '<li data="CH01">이메일</li>' +
                    '</ul>' +
                    '</div>'
                );
            }else{
                $('.input_append').html(
                    '<input type="text" class="searchInp left-border" name="searchValue" id="searchValue"'+
                    'placeholder="검색어입력"/>'
                );
            }
        });

        // 전체 체크/해제 동작
        $(document).on('click','.all input[name=checkAll]',function () {
            if ($(this).is(':checked') == true) {
                $('.custom_check1 input[name=checkEach]').not('.all input').prop('checked', true);
            } else {
                $('.custom_check1 input[name=checkEach]').not('.all input').prop('checked', false);
            }
        });

        //화면 체크박스 모두 체크 시 전체체크박스 체크
        $(document).on('click','.table tbody .custom_check1 input[name=checkEach]',function () {
            let total = $('.custom_check1 input[name=checkEach]').not('.all input').length;
            let checkTotal = $('.custom_check1 input[name=checkEach]:checked').not('.all input').length;
            if (total == checkTotal) {
                $('.all input[name=checkAll]').prop('checked', true);
            } else {
                $('.all input[name=checkAll]').prop('checked', false);
            }
        });
        //tab nav click event
        $('.pop_tap_nav li').on('click', function () {
            let tapIndex = $(this).index();
            $(this).addClass('on').siblings().removeClass('on');
            $('.tap_contents').eq(tapIndex).addClass('on').siblings().removeClass('on');
        });

        // channel type click event
        $('.channel input').on('click', function () {
            let chennelVal = $(this).val();
            if (chennelVal == 'sms') {
                $('#ch_type').val('CH02');
                $('.row_mobile').removeClass('off');
                $('.row_email').addClass('off');
            } else {
                $('#ch_type').val('CH01');
                $('.row_mobile').addClass('off');
                $('.row_email').removeClass('off');
            }

        });

    });
    var fileCheck = 0;
    // file form check event
    $('.file').on('change', function () {
        let fileName = $(this).val();
        $("#fileName").val(fileName);
        let format = fileName.slice(fileName.lastIndexOf('.') + 1).toLowerCase();
        if (!(format == "xlsx" || format == "xls" )) {
            alert("'xlsx', 'xls' 파일 형식만 업로드 가능 합니다.");
            $('#filePreview').html('');
            $("#fileName").val('');
            $('#errCnt').html('');
            fileCheck = 0;
        } else {
            var res = function (response) {
                if (response.check) {
                    var totCnt = parseInt(response.mCnt) + parseInt(response.eCnt);
                    var list_cnt = totCnt;
                    if(totCnt > 5){
                        list_cnt = 5;
                    }
                    var totErrCnt = (parseInt(response.mErr)+parseInt(response.eErr));
                    var html =  '<h3 class="popup_title">파일 업로드 결과</h3>'
                        +' <table class="pop_table_type2 pop_margin_bttm">'
                        +'<colgroup>'
                        +'<col width="25%" />'
                        +'<col width="25%" />'
                        +'<col width="25%" />'
                        +'<col width="25%" />'
                        +'</colgroup>'
                        +'<thead>'
                        +'<tr>'
                        +'<th>이메일</th>'
                        +'<th>모바일</th>'
                        +'<th>오류</th>'
                        +'<th>합계</th>'
                        +'</tr>'
                        +'</thead>'
                        +'<tbody>'
                        +'<tr>'
                        +'<td class="en_font">'+response.eCnt+'</td>'
                        +'<td class="en_font">'+response.mCnt+'</td>'
                        +'<td class="en_font">'+totErrCnt+'</td>'
                        +'<td class="en_font">'+totCnt+'</td>'
                        +'</tr>'
                        +'</tbody>'
                        +'</table>'
                        +'<p class="tbl_sub_text">'
                        +'※ 상위 100개까지 유효성 검사를 진행합니다.<br/>'
                        +'※ 작업이력에서 입력된 전체 오류 건수를 확인할 수 있습니다.'
                        +'</p>'
                        +'<h3 class="popup_title">리스트 미리보기</h3>'
                        +'<table class="pop_table_type3 pop_margin_bttm">'
                        +'<colgroup>'
                        +'<col width="50%" />'
                        +'<col width="50%" />'
                        +'</colgroup>'
                        +'<thead>'
                        +'<th>채널</th>'
                        +'<th>주소</th>'
                        +'</thead>'
                        +'<tbody>';
                    for(var i=0; i<list_cnt; i++){
                        html += '<tr>'
                            +'<td>'+response.list[i].ch_type+'</td>'
                            +'<td class="en_font">'+response.list[i].send_to+'</td>'
                            +'</tr>';
                    }
                    html +='</tbody>'
                        +'</table>';

                    $('#filePreview').html(html);
                    $('#errCnt').html(totErrCnt);
                    fileCheck =1;
                } else {
                    popup.popAlert(response.message);
                    fileReset();
                    fileCheck= 0;
                }
            };
            var form = $('#fileUpload')[0];
            var param = new FormData(form);
            com_ajax.ajax_file('${baseURL}/mbr/tblmiSupFormCheck.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
        }
    });
    //수신거부 리스트 가져오기
    function getTblmiSupList(page) {
        var res = function (response) {
            $("#tblmiSupListAppend").html(response);
        };
        var param = $("#tmlmiSupForm").serializeArray();
        param.push({name: 'pageNo', value: page});
        com_ajax.ajax('post', '${baseURL}/mbr/getTblmiSupList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 개별 등록 유효성 체크
    function channelCheck() {
        let regMail = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
        let regPhone =  /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?[0-9]{3,4}-?[0-9]{4}$/;
        let channel = $('.channel input:checked').val();
        let mobile = $('#sms').val();
        let mail = $('#email').val();
        let send_to;
        if (channel == 'sms') {
            if (mobile == '') {
                $('#individualError').html('핸드폰 번호를 입력해주세요.');
                return false;
            }
            if (!regPhone.test(mobile)) {
                $('#individualError').html('핸드폰 번호 형식에 맞게 입력해주세요.');
                return false;
            } else {
                send_to = mobile;
                $('#individualError').html('');
            }
        }
        if (channel == 'mail') {
            if (mail == '') {
                $('#individualError').html('이메일을 입력해주세요.');
                return false;
            }if (!regMail.test(mail)) {
                $('#individualError').html('이메일 형식에 맞게 입력해주세요.');
                return false;
            } else {
                send_to = mail;
                $('#individualError').html('');
            }
        }
        var res = function (response) {
            if(response.message > 0){
                popup.popAlert("저장되었습니다.");
                getTblmiSupList('1');
                $('.rejectionPopup').removeClass('active');
            }
        };
        var param = $("#saveTblmiSupList").serializeArray();
        param.push({name:'send_to',value:send_to});
        com_ajax.ajax('post', '${baseURL}/mbr/saveTblmiSupList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');

    }

    //enter key event
    function enterKey() {
        if (window.event.keyCode == 13) {
            channelCheck();
        }
        return false;
    }

    //수신거부 추가 팝업
    function rejectionPopup() {
        fileReset();
        $('.rejectionPopup').addClass('active');
    }
    //수신거부 파일 리셋
    function fileReset(){
        $('#saveTblmiSupList')[0].reset();
        $("#fileName").val('');
        $('#filePreview').html('');
        $('#errCnt').html('');
        $('#fileUpload')[0].reset();
        $('#file').val('');
        $('#ch_type').val('CH01');
        $('.row_mobile').addClass('on');
        $('.row_mobile').removeClass('off');
        $('.row_email').addClass('off');
        $('.row_email').removeClass('on');
        $('#individualError').html('');
    }
    //수신거부 파일 업로드
    function uploadCheck() {
        let fileVal = $('#fileName').val();
        if (fileVal != '') {
            errorPopup();
            return false;
        } else {
            popup.popAlert('업로드된 파일이 없습니다.');
            fileCheck=0;
            return false;
        }
    }

    //오류안내 팝업
    function errorPopup() {
        $('.errorPopup').addClass('active');
    }

    //선택 삭제 팝업
    function deleteCheck() {
        let checkLength = $('.rejection_tbl .custom_check1').not('.all').find('input:checked').length;
        $('#errorArea1').html('');
        $('#deletePassword').val('');
        $('.deletePopup .length').html(checkLength);
        if (checkLength == 0) {
            popup.popAlert('삭제할 회원을 선택해주세요.');
        } else {
            $('#deleteSave').attr('data', 'each');
            $("#deleteLength").html(checkLength);
            $('#deleteAllPop').addClass('active');
        }
    }

    //전체 삭제 팝업
    function allDeletePopup() {
        $('#deleteAllPop').addClass('active');
        $('#deletePassword').val('');
        $('#deleteLength').html($('#totCnt').html());
        $('#deleteSave').attr('data', 'all');
    }

    //삭제 클릭시 비밀번호확인
    function listDelete(password) {
        let status = $('#deleteSave').attr('data');
        if (password == '') {
            $('#errorArea1').html('비밀번호를 입력해주세요.');
        } else {
            var res = function (response) {
                if (response.status == true) {
                    $('#errorArea1').html('');
                    $(close).parents('.layer_pop').removeClass('active');
                    //삭제 function
                    deleteTblmiSupList(status);
                    $('.rejectionPopup').removeClass('active');
                } else {
                    $('#errorArea1').html('비밀번호를 확인해주세요.');
                }
            };
            var param = {"password": password};
            com_ajax.ajax('post', '${baseURL}/mcr/check/pw.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
        }
        return false;
    };

    //검색 기준확인 function
    function searchTblmiSup() {
        let standard = $('.searchSelect').attr('data');
        let searchValue = $('#searchValue').val().trim();

        if (standard == '' && searchValue != '') {
            popup.searchAlert("기준을 선택해 주세요.");
            return false;
        } else {
            $('#searchType').val(standard);
            if(standard=='sup_type' || standard=='ch_type'){
                var selectData = document.querySelector('#selectData').getAttribute("data");
                $('#searchValue').val(selectData);
            }
            getTblmiSupList('1');
        }
    }
    //실제 삭제 AJAX function
    function deleteTblmiSupList(data) {
        var nowPage;
        var res = function (response) {
            if (response.message >0) {
                popup.popAlert("삭제되었습니다.");
            } else {
                popup.popAlert("삭제도중 오류가 발생하였습니다. 관리자에게 문의해주세요.");
            }
            $('#deleteAllPop').removeClass('active');
            getTblmiSupList(nowPage);
        };
        if(data == 'all'){
            nowPage = '1';
            var searchType = $('#resultSearchType').val();
            searchType = searchType.slice(searchType.lastIndexOf('.') + 1);
            var param = {
                'searchType':searchType,
                'searchValue': $('#resultSearchValue').val()
            };
            com_ajax.ajax('post', '${baseURL}/mbr/deleteAllTblmiSupList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
        }else{
            nowPage = $('#nowPageNo').val();
            var checkList = [];
            var checkLength = $('.custom_check1 input[name=checkEach]:checked').length;
            for(var i=0; i<checkLength; i++){
                checkList.push($('.custom_check1 input[name=checkEach]:checked').eq(i).val());
            }
            var param = {checkList: checkList};
            com_ajax.ajax('post', '${baseURL}/mbr/deleteTblmiSupList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
        }
    }

    //엑셀 업로드 파일 실제 저장
    function saveTblmiSubFile() {
        if (fileCheck == 0) {
            popup.popAlert("업로드된 파일이 없습니다");
            $('#filePreview').html('');
            $("#fileName").val('');
            $('#errCnt').html('');
        } else {
            var res = function (response) {
                popup.popAlert(response.message);
                getTblmiSupList('1');
                $('.rejectionPopup').removeClass('active');
                $('.errorPopup').removeClass('active');
                $('#filePreview').html('');
                $("#fileName").val('');
                $('#errCnt').html('');
                fileCheck = 0;
            };
            var form = $('#fileUpload')[0];
            var param = new FormData(form);
            com_ajax.ajax_file('${baseURL}/mbr/saveTblmiSupForm.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');

        }
    }

    //수신거부 양식 다운로드
    function formFileDown(){
        location.href = '${baseURL}/download/수신거부등록양식.xlsx';
        $('#commonLoading').removeClass('active');
    }

    //검색된 페이지 다운로드
    function downloadTblmiSup() {
        var popupX = (document.body.offsetWidth/2) - (200/2);
        var popupY= (window.screen.height/2) - (300/2);
        var pop = window.open('','popup_down','width=661, height=435, resizable=no, scrollbars=yes, status=yes, toolbars=no, location=no, left='+popupX+', top='+popupY);
        var message = '<!DOCTYPE html>'+
                        '<html lang="ko">'+
                        '<head>'+
                        '<meta charset="UTF-8">'+
                        '<meta name="viewport" content="width=device-width, initial-scale=1.0">'+
                        '<meta http-equiv="X-UA-Compatible" content="ie=edge">'+
                        '<title>miCRM</title>'+
                        '</head>'+
                        '<body>'+
                        '<img src="/image/excelDown.jpg" alt="" style="width:100%;">'+
                        '</body>'+
                        '</html>';
        pop.document.write(message);
        $("#downloadForm").attr("target", "popup_down");
        $("#downloadForm").submit();
    }
</script>
