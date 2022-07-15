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
        <div class="row tooltip_area bottom-border cf">
            <form id="noticeForm" name="noticeForm" onsubmit="return false">
                <div class="left">
                    <!-- location 영역 -->
                    <ul class="location">
                        <li>홈</li>
                        <li>시스템관리</li>
                        <li>환경</li>
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
                    <div class="select style1 left-border" id="searchOption">
                        <!-- selected value -->
                        <div class="value searchSelect"  data="">기준선택</div>
                        <!-- option -->
                        <ul class="option">
                            <li data="noti_popyn">ON/OFF</li>
                            <li data="noti_sub">제목</li>
                            <li data="usr_email">등록자</li>
                        </ul>
                    </div>
                    <!-- select 영역 끝 -->
                    <span class="input_append">
                        <input type="text" class="searchInp left-border searchWord" name="searchValue" id="searchValue" placeholder="검색어입력"
                               onkeyup="enterSubmit();"/>
                    </span>
                    <input type="hidden" id="searchType" name="searchType"/>
                    <input type="submit" class="searchBtn" value="검색" onclick="return searchNotice();"/>
                </div>
            </form>
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
        <span id="noticeListBody"></span>
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

<!-- 공지사항 작성 팝업 영역 시작 -->
<form id="saveNoticeForm" name="saveNoticeForm" onsubmit="return false" >
    <div class="layer_pop noticeCrtPopup">
        <div class="pop_container popup_size7">
            <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
            <div class="pop_title">공지사항 작성</div>
            <input type="hidden" id="seq" name="seq"/>
            <div class="pop_inner">
                <div class="form_search">
                        <input type="text" class="calendar" id ="noti_bgn_dttm" name="noti_bgn_dttm" placeholder="시작일 선택"/>
                        <span class="hyphen"></span>
                        <input type="text" class="calendar" id ="noti_end_dttm" name="noti_end_dttm" placeholder="종료일 선택" />
                    </div>
                <div class="form_title">
                    <div class="th">제목</div>
                    <div class="td"><input type="text" id ="noti_sub" name="noti_sub" placeholder="제목을 입력해주세요."/></div>
                    <div class="">
                        <label class="custom_check1">오늘 이 창을 열지 않음<input type="checkbox" id="noti_chk" name="noti_chk" value="1"/><span></span></label>
                    </div>
                </div>
                <div class="editor_box">
                    <textarea id="noti_body" name="noti_body"></textarea>
                </div>
                <div class="today_check" name="check1" id="check1">
                    <img src="/image/img_today.jpg" alt="">
                </div>
                <div class="btn_row">
                    <input type="hidden" name="nowPageNo" id="nowPageNo" value="1"/>
                    <input type="button" class="btn_bg btn_size2 btn_inline" onclick="saveNotice();" value="저장"/>
                    <input type="button" class="btn_bg2 btn_size2 btn_inline" value="미리보기" onclick="previewPopup();"/>
                </div>
            </div>
        </div>
    </div>
</form>
<!-- 공지사항 작성 팝업 영역 끝 -->

<!-- 미리보기 팝업 영역 시작 -->
<div class="layer_pop previewPopup">
    <div class="pop_container popup_size1">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
        <div class="pop_title"><span class="mark">미리보기</span><span type="text" id = "preview_sub" name="preview_sub"></span></div>
        <div class="pop_inner">
            <div class="preview">
                <div class="editor_box">
                    <span id="preview_body" name="preview_body"></span>
                </div>
            </div>
            <div class="today" id="preview_check" name="preview_check">
                <label class="custom_check1">오늘 이 창을 열지 않음<input type="checkbox"/><span></span></label>
            </div>
        </div>
    </div>
</div>
<!-- 미리보기 팝업 영역 끝 -->
<!-- wrap end -->
<script>
    var ckFileNm ='0';
    function searchNotice() {
        let standard = $('.searchSelect').attr('data');
        if (standard == '') {
            popup.searchAlert("기준을 선택해 주세요.");
            return false;
        } else {
            $('#searchType').val(standard);
            if(standard=='noti_popyn'){
                var selectData = document.querySelector('#selectData').getAttribute("data");
                $('#searchValue').val(selectData);
            }
            getNoticeList('1');
        }
    }

    //공지사항 리스트 가져오기
    function getNoticeList(page) {
        var res = function (response) {
            $("#noticeListBody").html(response);
        };
        var param = $("#noticeForm").serializeArray();
        param.push({name : 'pageNo', value : page});
        com_ajax.ajax('post', '${baseURL}/sys/setting/getNoticeList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }
    //공지사항저장
    function saveNotice() {
        let startDate = document.getElementById('noti_bgn_dttm').value;
        let endDate = document.getElementById('noti_end_dttm').value;
        let title = document.getElementById('noti_sub').value;
        let noti_body = CKEDITOR.instances.noti_body.getData();

        let pageNo = $('#nowPageNo').val();
        if(startDate == ''){
            popup.popAlert("시작일을 입력해주세요.");
            return false;
        }
        if(endDate == ''){
            popup.popAlert("종료일을 입력해주세요.");
            return false;
        }
        if(title == ''){
            popup.popAlert("제목을 입력해주세요.");
            return false;
        }
        if(noti_body == ''){
            popup.popAlert("내용을 입력해주세요.");
            return false;
        }else{
            var res = function (response) {
                $('.noticeCrtPopup').removeClass('active');
                if(response.message > 0){
                    popup.popAlert("공지사항이 저장되었습니다.");
                    ckFileNm ='0';
                    getNoticeList(pageNo);
                }
            };
            $('#noti_body').val(noti_body);
            var param = $("#saveNoticeForm").serializeArray();
            param.push({name:'ckFileNm', value:ckFileNm});
            com_ajax.ajax('post', '${baseURL}/sys/setting/saveNotice.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
        }
        //$("#noticeListBody").html($("#noticeListBody", $doc).html());
    }
    //공지사항 수정페이지 내용 가져오기
    function noticeRePopup(seq, pageNo) {
        var res = function (response) {
            $('#noti_sub').val(response.list[0].noti_sub);
            $('#noti_bgn_dttm').val(response.list[0].noti_bgn_dttm);
            $('#noti_end_dttm').val(response.list[0].noti_end_dttm);
            $('#seq').val(response.list[0].seq);
            if(response.list[0].noti_chk === "1"){
                $('#noti_chk').prop('checked', true);
                document.querySelector('#check1 img').style.display = 'block';
            }
            var noti_body = response.list[0].noti_body;
            noti_body = noti_body.replaceAll('&lt;', '<');
            noti_body = noti_body.replaceAll('&gt;', '>');
            noti_body = noti_body.replaceAll('&amp;nbsp;', ' ');
            noti_body = noti_body.replaceAll('&quot;', '"');
            CKEDITOR.instances.noti_body.setData(noti_body);
            $('#nowPageNo').val(pageNo);
            $('.noticeCrtPopup').addClass('active');
        };
        var param = {seq : seq};
        com_ajax.ajax('post', '${baseURL}/sys/setting/getNoticeDetail.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function popynChange(popyn, seq, pageNo) {
        let useValue = $(popyn).val();
        if (useValue == 'ON') {
            useValue = "N";
        }else{
            useValue = "Y";
        }

        var res = function (response) {
            if(response.message == false) {
               popup.popAlert("공지사항은 최대 2건까지 오픈 가능합니다.");
            }else if(response.message > 0 ){
                getNoticeList(pageNo);
            }
        };
        var param = {seq : seq, noti_popyn : useValue};
        com_ajax.ajax('post', '${baseURL}/sys/setting/saveNoticePopyn.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');


    };

    // 검색영역 enter key event
    function enterSubmit() {
        if (window.event.keyCode == 13) {
            searchNotice();
        }
        return false;
    }

    $(document).ready(function () {
        getNoticeList('1');
        // calendar default option
        $.datepicker.setDefaults({
            dateFormat: 'yy-mm-dd'
            , monthNames: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
            , showMonthAfterYear: true
            , yearSuffix: "."
        });

        //ckeditor option  팝업
        CKEDITOR.replace('noti_body', {
            extraPlugins:'uploadimage',
            height: 325,
            resize_minHeight: 325,
            resize_maxHeight: 325,
            resize_minWidth: 600,
            resize_maxWidth: 600,
            filebrowserUploadUrl : '/sys/setting/upload.mi?_csrf=' + $('meta[name="csfrVal"]').attr('content'),
            toolbar : [
                { name: 'document', groups: [ 'mode', 'document', 'doctools' ], items: [ 'Source', '-', 'Templates' ] },
                { name: 'clipboard', groups: [ 'clipboard', 'undo' ], items: [ 'Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-', 'Undo', 'Redo' ] },
                { name: 'editing', groups: [ 'find', 'selection', 'spellchecker' ], items: [ 'Find', 'Replace', '-', 'SelectAll', '-', 'Scayt' ] },
                { name: 'forms', items: [ 'Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 'HiddenField' ] },
                { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ], items: [ 'Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat' ] },
                '/',
                { name: 'insert', items: [ 'Image', 'Table', 'HorizontalRule', 'Smiley', 'SpecialChar', 'PageBreak', 'Iframe' ] },
                { name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi' ], items: [ 'NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote', 'CreateDiv', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '-', 'BidiLtr', 'BidiRtl', 'Language' ] },
                { name: 'links', items: [ 'Link', 'Unlink', 'Anchor' ] },
                { name: 'colors', items: [ 'TextColor', 'BGColor' ] },
                { name: 'tools', items: [ 'Maximize', 'ShowBlocks' ] },
                '/'
            ],
            removeButtons : 'Underline, Subscript, Superscript,Save,Preview,Print',
            format_tags : 'p;h1;h2;h3;pre',
            resize_dir : 'both',
            removeDialogTabs : 'image:advanced;link:advanced',
            enterMode : CKEDITOR.ENTER_BR,
            toolbarCanCollapse : false,
            allowedContent : true,
            removePlugins : 'newpage, exportpdf, elementspath',
            docType : "<!DOCTYPE html>",
            //htmlEncodeOutput : true,
            autoParagraph : false
        });
        var ckeditor = CKEDITOR.instances.noti_body;

        ckeditor.on( 'fileUploadResponse', function( evt ) {
            var data = evt.data,
                xhr = data.fileLoader.xhr,
                response = xhr.responseText.split( '|' );

            if ( response[ 1 ] ) {
                // An error occurred during upload.
                data.message = response[ 1 ];
                evt.cancel();
            } else {
                data.url = response[ 0 ];
                var jsonData = JSON.parse(data.url);
                ckFileNm = jsonData['file_nm'];
            }

        });
        //시작일 달력 팝업
        $('#noti_bgn_dttm').datepicker({
            onSelect: function (selected) {
                $("#noti_end_dttm").datepicker("option", "minDate", selected)
            }
        });
        CKEDITOR.instances.noti_body.on('blur', function() {
            let noti_body = CKEDITOR.instances.noti_body.getData();
            CKEDITOR.instances.noti_body.setData(noti_body);
        });
        //종료일 달력 팝업
        $('#noti_end_dttm').datepicker({
            onSelect: function (selected) {
                $("#noti_bgn_dttm").datepicker("option", "maxDate", selected)
            }
        });

    });

    // Table 리스트 삭제
    let deleteEl;

    function deleteAlert(el, popYn, nowPageNo) {
        if(popYn === 'Y'){
            popup.popAlert("ON 상태의 공지사항은 삭제하실 수 없습니다.");
            return false;
        }
        let pageNo = nowPageNo;
        deleteEl = el;
        let html = '';
        html +=
            '<div class="layer_pop alert active">' +
            '<div class="pop_container popup_size3">' +
            '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
            '<div class="pop_title">공지사항 삭제</div>' +
            '<div class="pop_inner">' +
            '<div class="alert_txt">선택된 공지사항을 삭제하시겠습니까?</div>' +
            '<div class="btn_row">' +
            '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="deleteRow('+deleteEl+','+ pageNo+');" value="확인" />' +
            '<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소" />' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';
        $('body .layer_pop.alert').remove();
        $('body').append(html);
        return false;
    }

    function deleteRow(row, nowPageNo) {
        var res = function (response) {
            $('.alert').removeClass('active');
            if(response.message > 0){
                popup.popAlert("삭제되었습니다.");
                getNoticeList(nowPageNo);
            }
        };
        var param = {seq : row};
        com_ajax.ajax('post', '${baseURL}/sys/setting/deleteNotice.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
        return false;
    }

    // 공지사항 작성 오늘 이창을 열지 않음 표시
    let today = document.getElementById('noti_chk');

    today.addEventListener('click', function () {
        let todayVal = today.checked;
        if (todayVal == true) {
            document.querySelector('#check1 img').style.display = 'block';
        } else {
            document.querySelector('#check1 img').style.display = 'none';
        }
    });

    // 공지사항 추가 팝업
    function noticeCrtPopup() {
        $('#saveNoticeForm')[0].reset();
        document.querySelector('#check1 img').style.display = 'none';
        CKEDITOR.instances.noti_body.setData();
        $('.noticeCrtPopup').addClass('active');
    }

    // 공지사항 미리보기 팝업
    function previewPopup() {
        let title = document.getElementById('noti_sub').value;
        let noti_body = CKEDITOR.instances.noti_body.getData();
        $("#preview_sub").html(title);
        $("#preview_body").html(noti_body);
        let checkValue = $("input:checkbox[name=noti_chk]").is(":checked");
        if(checkValue == false){
            $("#preview_check").hide();
        }else{
            $("#preview_check").show();
        }
        $('.previewPopup').addClass('active');
    }

    $(function(){
        $('#searchOption .option li').click(function(){
            let optionVal = $(this).attr('data');
            if(optionVal == 'noti_popyn'){
                $('.input_append').html(
                    '<div class="select style1 left-border right-border" id="viewState">' +
                    '<input type="hidden" name="searchValue" id="searchValue"/>' +
                    '<div class="value searchSelect" id="selectData" data="Y">ON</div>' +
                    '<ul class="option">' +
                    '<li data="Y">ON</li>' +
                    '<li data="N">OFF</li>' +
                    '</ul>' +
                    '</div>'
                );
            }else{
                $('.input_append').html(
                    '<input type="text" class="searchInp left-border searchWord" name="searchValue" id="searchValue" placeholder="검색어입력"'+
                           'onkeyup="enterSubmit();"/>'
                );
            }
        });
    });

</script>



