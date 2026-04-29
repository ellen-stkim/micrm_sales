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
            <div class="right">
                <!-- select 영역 시작 -->
                <div class="select style1 left-border" id="searchItems">
                    <!-- selected value -->
                    <div class="value searchSelect" data="">기준선택</div>
                    <!-- option -->
                    <ul class="option">
                        <li data="list_nm">발신자명</li>
                        <li data="list_val">발신키</li>
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
                <div class="total left">기본 발신번호</div>
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
                        <th>발신자명</th>
                        <td>
                            <span class="en_font" id="sendDefaultNm">
                                <c:if test="${list[0].def_yn == 'Y'}">
                                    ${list[0].list_nm}
                                </c:if>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <th>발신키</th>
                        <td>
                            <span class="en_font" id="sendDefaultAddress">
                                <c:if test="${list[0].def_yn == 'Y'}">
                                    ${list[0].list_val}
                                </c:if>
                            </span>
                        </td>
                    </tr>
                    <tr>
                        <th>브랜드톡 사용 가능 여부</th>
                        <td>
                            <span class="en_font" id="brandYn">
                                <c:if test="${list[0].def_yn == 'Y'}">
                                    ${list[0].addl_use_yn}
                                </c:if>
                            </span>
                        </td>
                    </tr>
                </tbody>
            </table>
            <div class="count border-bottom cf">
                <div class="total left">발신프로필 리스트</div>
                <div class="btn_col right">
                    <input type="button" value="추가" class="btn_sm_line" onclick="numberAddPopup();" />
                    <input type="button" value="기본 발신프로필 지정" class="btn_sm_line" onclick="callingNumPopup();" />
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

<!-- 발신번호 추가 팝업 영역 시작 -->
<div class="layer_pop numberAddPopup">
    <div class="pop_container popup_size1">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
        <div class="pop_title">발신번호 추가</div>
        <div class="pop_inner">
            <form action="" id="sendKeyForm">
                <table class="pop_table_type1" summary="발신번호 추가">
                    <colgroup>
                        <col width="103" />
                        <col width="*" />
                    </colgroup>
                    <tbody>
                    <tr>
                        <th scope="row">채널명</th>
                        <td><input type="text" name="yellowId" id="yellowId" placeholder="'@'+채널명을 입력해주세요." class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th rowspan="2" scope="row">카테고리</th>
                        <td style="padding: 0"><div class="select" id="sendCateSel">
                            <!-- selected value -->
                            <div class="value" data="">카테고리를 선택해주세요</div>
                            <ol class="option" style="display: none;">
                                <c:forEach var="cate" items="${cateLst}">
                                <li data="${cate.cd_val}" >${cate.cd_desc}</li>
                                </c:forEach>
                            </ol>
                        </div></td>
                    </tr>
                    <tr>
                        <td style="padding: 0"><div class="select" id="sendMidCateSel" style="width: 50%">
                            <!-- selected value -->
                            <div class="value" data="">중분류</div>
                            <ol class="option" style="display: none;">
                                <c:forEach var="cateMid" items="${cateMidLst}">
                                    <li data="${cateMid.cd_val}" data_par_val="${cateMid.par_nm}" style="display: none">${cateMid.cd_desc}</li>
                                </c:forEach>
                            </ol>
                        </div>
                            <div class="select" id="sendSubCateSel" style="width: 50%">
                                <!-- selected value -->
                                <div class="value" data="">소분류</div>
                                <ol class="option" style="display: none;">
                                    <c:forEach var="cateSub" items="${cateSubLst}">
                                        <li data="${cateSub.cd_val}" data_par_val="${cateSub.par_nm}" style="display: none" >${cateSub.cd_desc}</li>
                                    </c:forEach>
                                </ol>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">고객명</th>
                        <td><input type="text" name="bizName" id="bizName" placeholder="고객명을 입력해주세요." class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th scope="row">사업자번호</th>
                        <td><input type="text" name="bizNo" id="bizNo" placeholder="사업자번호를 입력해주세요." class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th scope="row">담당자명</th>
                        <td><input type="text" name="managerName" id="managerName" placeholder="담당자명을 입력해주세요." class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th scope="row">휴대폰 번호</th>
                        <td><input type="text" name="phoneNumber" id="phoneNumber" style="width: 87%;display: inline-block;" placeholder="채널 관리자 휴대폰 번호를 입력해주세요." class="input_type1" />
                            <input type="button" class="btn_sm_line btn_inline size" value="인증" onclick="checkToken()"></td>
                    </tr>
                    <tr class="check_token_tr">
                        <th scope="row">인증번호</th>
                        <td><input type="text" id="senderkey_token" name="token" class="input_type1" placeholder="인증번호를 입력해주세요."></td>
                    </tr>
                    <tr>
                        <th scope="row">오픈희망일</th>
                        <td><input type="text" name="openDate" id="openDate" placeholder="오픈희망일을 입력해주세요. (ex: 2023-01-01 )" class="input_type1" /></td>
                    </tr>
                    </tbody>
                </table>
            </form>
            <div class="pop_error_txt blue_point_color" id="errorArea1"></div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_inline" onclick="checkKkoAddress();" value="저장" />
            </div>
        </div>
    </div>
</div>
<!-- 발신번호 추가 팝업 영역 끝 -->

<!-- 발신번호 수정 팝업 영역 수정 -->
<div class="layer_pop numberRePopup">
    <div class="pop_container popup_size1">
        <input type="button" value="닫기" class="btn_pop_close" onclick="modifyPopupClose(this);" />
        <div class="pop_title">발신번호 수정</div>
        <div class="pop_inner">
            <form action="" id="postForm2">
                <table class="pop_table_type1" summary="발신번호 수정">
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
                        <th>발신번호</th>
                        <td><input type="text" name="list_val_mod" id ="list_val_mod" placeholder="발신번호를 입력해주세요." class="input_type1" /></td>
                    </tr>
                    </tbody>
                </table>
            </form>
            <div class="pop_error_txt blue_point_color" id="errorArea2"></div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_inline" onclick="checkKkoAddressModify($('#seq_mod').val());" value="저장" />
            </div>
        </div>
    </div>
</div>
<script>
    $(function(){
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

        $(document).on('click','#sendCateSel .option',(e)=>{
            const val = $(e.target).attr('data');
            $('#sendMidCateSel .option li').hide();
            $('#sendSubCateSel .option li').hide();
            $('#sendMidCateSel .option li[data_par_val="'+val+'"]').show();
            $('#sendMidCateSel .value').attr("data","").css('color','#cccccc').html('중분류');
            $('#sendSubCateSel .value').attr("data","").css('color','#cccccc').html('소분류');
            $("#errorArea1").html('');
            $('.layer_pop .select.on').removeClass('on');
        });

        $(document).on('click','#sendMidCateSel .option',(e)=>{
            if($('#sendCateSel .value').attr('data') ==''){
                $("#errorArea1").html("카테고리 대분류를 먼저 선택해주세요.");
                return false;
            }
            $("#errorArea1").html('');
            const val = $(e.target).attr('data');
            $('#sendSubCateSel .option li').hide();
            $('#sendSubCateSel .option li[data_par_val="'+val+'"]').show();
            $('#sendSubCateSel .value').attr("data","").css('color','#cccccc').html('소분류');
            $('.layer_pop .select.on').removeClass('on');
        });
        $(document).on('click','#sendSubCateSel',(e)=>{
            if($('#sendMidCateSel .value').attr('data') ==''){
                $("#errorArea1").html("카테고리 대/중분류를 먼저 선택해주세요.")
                return false;
            }
            $("#errorArea1").html('');
        });


    })

    getSmsSettingList('1');

    // 문자 저장 팝업 띄우기
    function numberAddPopup() {

        $('.numberAddPopup').addClass('active');
        $('.check_token_tr').addClass("disnone");
        $('#senderkey_token').val('');
        hasRequstToken=false;  // 인증요청 초기화
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

    let hasRequstToken;
    function checkToken(){
        const res = function(response){
            if(response.status == 200){
                $('#senderkey_token').val('').focus();
                $('.check_token_tr').removeClass("disnone");
                hasRequstToken = true;
            }else {
                $('.check_token_tr').addClass("disnone");
                alert(response.msg)
                hasRequstToken = false;
            }
        }

        let data = {
            "channelId": $("#yellowId").val().trim()
            , "phoneNum": $("#phoneNumber").val().trim()
        }

        com_ajax.ajax_json('post', '${baseURL}/sys/setting/requestKkoToken.ajax', JSON.stringify(data), res, '${_csrf.headerName}', '${_csrf.token}');

    }

    // SMS 저장하기
    function saveSms() {
        const res = function(response){
            if(response.status == 200){
                alert("등록되었습니다.");
                let nowPageNo = $("#nowPageNo").val();
                $("#yellowId").val('');
                $("#phoneNumber").val('');
                $("#errorArea1").html('');
                $('.numberAddPopup').removeClass('active')
                getSmsSettingList(nowPageNo);
                hasRequstToken=false;
            }else {
                alert(response.msg);
                hasRequstToken=false;
            }
        }

        let data = $('#sendKeyForm').serializeArray().map(function (x) {
            this[x.name] = x.value;
            return this;
        }.bind({}))[0];

        data.token = $('#senderkey_token').val().trim();
        data.cateCd = $('#sendSubCateSel .value').attr('data').trim();

        com_ajax.ajax_json('post', '${baseURL}/sys/setting/insertKkoSenderKey.ajax', JSON.stringify(data), res, '${_csrf.headerName}', '${_csrf.token}');
    }


    // 중복 채널 체크하기
    function checkKkoAddress() {

         let senderName = $("#yellowId").val().trim();
         let senderNumber = $("#phoneNumber").val().trim();

        if(!$('#sendKeyForm').valid()){
            return
        }

         if($('#sendSubCateSel .value').attr('data') == ''){
             alert("카테고리를 선택해주세요.");
             return false;
         }

        const res = function(response) {
             if(response.status == true){
                 saveSms();
             }  else {
                 $("#errorArea1").html('중복된 채널 입니다.')
                 return false;
             }
         }

         let data = []
         data.push({name : "list_nm" , value : senderName})
         com_ajax.ajax('post', '${baseURL}/sys/setting/isExistKkoAddress.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');

    }


    $('#sendKeyForm').validate({
        onfocusout: false
        , submitHandler: function () {
            $('#errorArea1').html('');
            $('.numberAddPopup').removeClass('active');
            return false;
        }
        , errorPlacement: $.noop
        , invalidHandler: function (form, validator) {
            let errors = validator.numberOfInvalids();
            if (errors) {
                $('#errorArea1').html(validator.errorList[0].message);
            }
        }
        , rules: {
            yellowId: {
                required: true
                ,vali_chen: true
            },bizName:{
                required: true
            }, bizNo: {
                required: true
                ,vali_biz_no: true
            }, managerName: {
                required: true
            }, phoneNumber: {
                required: true
                , vali_phone : true
            }, token: {
                required: true
            }, openDate: {
                required: true
                ,vali_open_dt: true
            }
        }
        , messages: {
            yellowId: {
                required: "채널명을 입력해주세요."
                ,vali_chen: "@ + 채널명을 입력해주세요"
            }
            , bizName: {
                required: "고객명을 입력해주세요."
            }, bizNo: {
                required: "사업자번호를 입력해주세요."
                ,vali_biz_no: "사업자번호 형식 오류입니다."
            }, managerName: {
                required: "담당자명을 입력해주세요."
            }, phoneNumber: {
                required: "휴대폰번호를 입력해주세요."
                ,vali_phone : "휴대폰 번호는 00-000-0000 또는 000-0000-0000 형식으로 입력해주세요."
            }, token: {
                required: "인증번호를 입력해주세요."
            }, openDate: {
                required: "오픈희망일을 입력해주세요."
                ,vali_open_dt: "오픈희망일을 YYYY-mm-dd 형식에 맞춰 입력해주세요."
            }
        }

    });

    $.validator.addMethod("vali_chen", function (value) {
        return /^\@/.test(value) || value === "";
    });
    $.validator.addMethod("vali_biz_no", function (value) {
        return /^[0-9]{3}-[0-9]{2}-[0-9]{5}$/.test(value) || value === "";
    });
    $.validator.addMethod("vali_phone", function (value) {
        return /^[0-9]{2,3}-[0-9]{3,4}-[0-9]{4}$/.test(value) || value === "";
    });
    $.validator.addMethod("vali_open_dt", function (value) {
        return /^\d{4}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$/.test(value) || value === "";
    });

    // 중복 메일 수정 체크하기
    function checkKkoAddressModify(seq) {

        let senderName = $("#list_nm_mod").val().trim();
        let senderNumber = $("#list_val_mod").val().trim();

        if(senderName == '') {
            $("#errorArea2").html("발신자명을 입력해 주세요.")
            return false;
        }
        if(senderNumber == '') {
            $("#errorArea2").html('발신번호를 입력해 주세요.')
            return false;
        }
        if(!chkNumber(senderNumber)){
            $("#errorArea2").html("숫자만 입력해 주세요");
            return false;
        }
        if(senderNumber.length < 10 || senderNumber.length > 12 ){
            $("#errorArea2").html("핸드폰 번호는 10 ~ 11자리 이내로 입력해 주세요.");
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
        data.push({name : "list_val" , value : senderNumber} )
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
            '<div class="pop_title">발신번호 삭제</div>' +
            '<div class="pop_inner">' +
            '<div class="alert_txt">선택된 발신번호를 삭제하시겠습니까?</div>' +
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
                '<div class="pop_title">기본 발신번호 변경</div>' +
                '<div class="pop_inner">' +
                '<table class="pop_table_type1">' +
                '<colgroup>' +
                '<col width="103"/>' +
                '<col width="*"/>' +
                '</colgroup>' +
                '<tbody>' +
                '<tr>' +
                '<th>기존 발신번호</th>' +
                '<td><span>' + defaultSendNumber + '</span></td>' +
                '</tr>' +
                '<tr>' +
                '<th>변경 발신번호</th>' +
                '<td><span>' + changeSendNumber + '</span></td>' +
                '</tr>' +
                '</tbody>' +
                '</table>' +
                '<div class="btn_row">' +
                '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="modifyDefaultAddress(\''+changeNumber+'\',\''+changeSendNumber+'\',\''+changeSender+'\')" value="확인" />' +
                '<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소" />' +
                '</div>' +
                '</div>' +
                '</div>' +
                '</div>';
            $('body .layer_pop.callingNumPopup').remove();
            $('body').append(html);
            return false;
        } if (changeNumber == undefined || changeNumber == '') {
            popup.popAlert("변경할 발신번호를 선택해주세요.");
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
        com_ajax.ajax('post', '${baseURL}/sys/setting/getKkoSettingList.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function enterSearch() {
        if(window.event.keyCode == 13){
            searchSmsSetting()
        }
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


    // changeSendNo : 고유 발신 번호 값 , changeSenderNumber : 발신번호 , changeSender : 발신자
    // 기본 메일 값 변경 하기
    function modifyDefaultAddress(changeSendNo,changeSenderNumber,changeSender){

        let nowPage = $("#nowPageNo").val();
        //let changeFormatNumber = phoneFormatter(changeSenderNumber)
        let defaultMailNo = $("#sendDefaultNo").val();

        const res = function(response){
            $('.callingNumPopup').removeClass('active');
            if(response.status == true){
                popup.popAlert("기본 발신번호 변경 완료 되었습니다");
                // 메일 값 설정해 주기
                $("#sendDefaultNo").val(changeSendNo)
                $("#sendDefaultNm").text(changeSender)
                $("#sendDefaultAddress").text(changeSenderNumber)
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
        let senderNumber = $("#list_val_mod").val().trim();
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
        data.push({name: 'list_val', value: senderNumber});

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
    
    <%--
    function updateBrandYn(key){
        const res = function (response) {
            console.log(response)
        }

        let data = [];
        data.push({name: 'key', value: key});
        com_ajax.ajax('post', '${baseURL}/sys/setting/getBrandyn.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }
    --%>
</script>