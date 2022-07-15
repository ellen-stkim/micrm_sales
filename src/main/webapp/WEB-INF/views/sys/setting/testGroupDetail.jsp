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

<section class="container">
    <!-- 컨텐츠 영역 시작 -->
    <div class="contents">
        <!-- row 영역 시작 -->
        <div class="row tooltip_area bottom-border cf">
           <form id ="testGrpDetailForm" name ="testGrpDetailForm" onsubmit="return false">
            <div class="left">
                <!-- location 영역 -->
                <ul class="location">
                    <li>홈</li>
                    <li>시스템관리</li>
                    <li>환경</li>
                </ul>
                <!-- tooltip 버튼 영역  -->
                <%--<div class="tooltip_icon">
                    <img src="../../image/ico_tooltip.png" alt="Tooltip" />
                </div>
                <!-- tooltip box 영역 시작 -->
                <div class="tooltip_box">
                    <!-- tooltip bullet 영역 -->
                    <div class="bullet"></div>
                    <span class="bold">2019년 12월 신규 취급액은 91.6억 중,<br />
                                나오론이 52.4억(57.2%)으로 가장 많은 비중을
                                차지합니다.</span>
                    스타일론 직장인이 26.69억(29.1%), <br />
                    스타일론 자영업자가 4.1억(4.47%)입니다.<br />--%>
                </div>
                <!-- tooltip box 영역 끝 -->
            </div>
            <div class="right">
                <!-- select 영역 시작 -->
                <div class="select style1 left-border" id ="searchItems">
                    <!-- selected value -->
                    <div class="value searchSelect" data="">기준선택</div>
                    <!-- option -->
                    <ul class="option">
                        <li data="usr_id">회원번호</li>
                        <li data="usr_nm">이름</li>
                        <li data="usr_edm">이메일</li>
                        <li data="usr_mob">모바일</li>
                        <li data="use_yn">사용여부</li>
                        <li data="usr_etc1">ETC1</li>
                        <li data="usr_etc2">ETC2</li>
                        <li data="usr_etc3">ETC3</li>
                        <li data="usr_etc4">ETC4</li>
                        <li data="usr_etc5">ETC5</li>
                    </ul>
                </div>
                <div class="left" id="typeArea"></div>
                <!-- select 영역 끝 -->
                <input type="text" class="searchInp left-border searchWord" name="searchValue" id ="searchValue" placeholder="검색어입력"  onkeyup="enterSubmit();" />
                <input type="submit" class="searchBtn" value="검색" onclick="return searchTargetUserList();" />
                <input type="hidden" id="searchType" name="searchType"/>
            </div>
            </form>
        </div>
        <!-- row 영역 끝 -->
        <ul class="tab_row">
            <!-- Tab menu -->
            <li<c:if test="${urlPath eq '/sys/setting/mailSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/mailSetting.mi">메일 정보 설정</a></li>
            <li<c:if test = "${urlPath eq '/sys/setting/smsSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/smsSetting.mi">문자 정보 설정</a></li>
            <li<c:if test = "${urlPath eq '/sys/setting/testGroup.mi'}"> class='on'</c:if>><a href="/sys/setting/testGroup.mi">테스트 그룹 설정</a></li>
            <li<c:if test="${urlPath eq '/sys/setting/noticeSetting.mi'}"> class='on'</c:if>><a href="/sys/setting/noticeSetting.mi">공지사항 설정</a></li>
            <%--<li><a href="approval.html">승인 절차 설정</a></li>--%>
        </ul>
        <!-- section 영역 시작 -->
        <div class="section">
            <div class="count border-bottom cf">
                <div class="total left">${grpNm}</div>
                <input type="hidden" id="grp_no" name= "grp_no" value="${grpNo}"/>
                <ol class="search_total cf">
                    <li>총&nbsp;<span class="en_font" id="totalCnt">${grpCnt}</span></li>
                    <li>이메일&nbsp;<span class="en_font" id="edmCnt">${edmCnt}</span></li>
                    <li>문자&nbsp;<span class="en_font" id="mobCnt">${mobCnt}</span></li>
                </ol>
                <input type="button" class="btn_add" value="추가" onclick="testMemberPopup();"/>
            </div>
            <span id="testTargetLst"></span>

            <!-- table 영역 끝 -->
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

<!-- 테스트 멤버 추가 팝업 영역 시작 -->
<div class="layer_pop testMemberPopup">
    <div class="pop_container popup_size1">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
        <div class="pop_title">테스트 멤버 추가</div>
        <div class="pop_inner">
            <form action="" id="testAddForm">
                <table class="pop_table_type1 test_tbl">
                    <colgroup>
                        <col width="102" />
                        <col width="*" />
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>회원번호</th>
                        <td><input type="text" name="memberNum" id="memberNoIns" class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th>이름</th>
                        <td><input type="text" name="name" id="memberNameIns" class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th>이메일</th>
                        <td><input type="text" name="mail" id="memberEmailIns" class="input_type1" /></td>
                    </tr>
                    <%--<tr>
                        <th>이메일 수신동의</th>
                        <td>
                            <label class="custom_radio en_font">Y<input name="mail_receive" type="radio" value="Y" /><span></span></label>
                            <label class="custom_radio en_font">N<input name="mail_receive" type="radio" value="N" /><span></span></label>
                        </td>
                    </tr>--%>
                    <tr>
                        <th>모바일</th>
                        <td><input type="text" name="mobile" id="memberMobileIns" class="input_type1" /></td>
                    </tr>
                    <%--<tr>
                        <th>모바일 수신동의</th>
                        <td>
                            <label class="custom_radio en_font">Y<input name="mobile_receive" type="radio" value="Y" /><span></span></label>
                            <label class="custom_radio en_font">N<input name="mobile_receive" type="radio" value="N" /><span></span></label>
                        </td>
                    </tr>--%>
                    <tr>
                        <th>사용 여부</th>
                        <td>
                            <label class="custom_radio en_font">Y<input name="ins_use_yn" type="radio" value="Y" /><span></span></label>
                            <label class="custom_radio en_font">N<input name="ins_use_yn" type="radio" value="N" /><span></span></label>
                        </td>
                    </tr>
                    <tr>
                        <th class="en_font">ETC1</th>
                        <td><input type="text" id="memberEtc1Ins" class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th class="en_font">ETC2</th>
                        <td><input type="text" id="memberEtc2Ins" class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th class="en_font">ETC3</th>
                        <td><input type="text" id="memberEtc3Ins" class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th class="en_font">ETC4</th>
                        <td><input type="text" id="memberEtc4Ins" class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th class="en_font">ETC5</th>
                        <td><input type="text" id="memberEtc5Ins" class="input_type1" /></td>
                    </tr>
                    </tbody>
                </table>
            </form>
            <div class="pop_error_txt blue_point_color" id="errorArea"></div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_center" value="저장" onclick="testAddSubmit();" />
            </div>
        </div>
    </div>
</div>
<!-- 테스트 멤버 추가 팝업 영역 끝 -->

<!-- 테스트 멤버 수정 팝업 영역 시작 -->
<div class="layer_pop testMemberRePopup">
    <div class="pop_container popup_size1">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
        <div class="pop_title">테스트 멤버 정보 수정</div>
        <div class="pop_inner">
            <form action="" id="testModifyForm">
                <table class="pop_table_type1 test_tbl">
                    <colgroup>
                        <col width="102" />
                        <col width="*" />
                    </colgroup>
                    <tbody>
                    <input type ="hidden" name="mem_no" id="memberSeq"/>
                    <tr>
                        <th>회원번호</th>
                        <td><input type="text" id="memberNoMod" name="memberNum1" class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th>이름</th>
                        <td><input type="text" id="memberNameMod" name="name1" class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th>이메일</th>
                        <td><input type="text" id="memberEmailMod" name="mail1" class="input_type1" /></td>
                    </tr>
                    <%--<tr>
                        <th>이메일 수신동의</th>
                        <td>
                            <label class="custom_radio en_font">Y<input name="mail_receive1" id="usr_eyn_yes" type="radio" value="Y" /><span></span></label>
                            <label class="custom_radio en_font">N<input name="mail_receive1" id="usr_eyn_no" type="radio" value="N" /><span></span></label>
                        </td>
                    </tr>--%>
                    <tr>
                        <th>모바일</th>
                        <td><input type="text" name="mobile1" id="memberMobileMod" class="input_type1" /></td>
                    </tr>
                    <%--<tr>
                        <th>모바일 수신동의</th>
                        <td>
                            <label class="custom_radio en_font">Y<input name="mobile_receive1" id="usr_myn_yes" type="radio" value="Y" /><span></span></label>
                            <label class="custom_radio en_font">N<input name="mobile_receive1" id="usr_myn_no" type="radio" value="N" /><span></span></label>
                        </td>
                    </tr>--%>
                    <tr>
                        <th>사용 여부</th>
                        <td>
                            <label class="custom_radio en_font">Y<input name="mod_use_yn" id="use_yn_yes" type="radio" value="Y" /><span></span></label>
                            <label class="custom_radio en_font">N<input name="mod_use_yn" id="use_yn_no" type="radio" value="N" /><span></span></label>
                        </td>
                    </tr>
                    <tr>
                        <th class="en_font">ETC1</th>
                        <td><input type="text" id="memberEtc1Mod" class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th class="en_font">ETC2</th>
                        <td><input type="text" id="memberEtc2Mod" class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th class="en_font">ETC3</th>
                        <td><input type="text" id="memberEtc3Mod" class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th class="en_font">ETC4</th>
                        <td><input type="text" id="memberEtc4Mod" class="input_type1" /></td>
                    </tr>
                    <tr>
                        <th class="en_font">ETC5</th>
                        <td><input type="text" id="memberEtc5Mod" class="input_type1" /></td>
                    </tr>
                    </tbody>
                </table>
            </form>
            <div class="pop_error_txt blue_point_color" id="errorArea1"></div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_center" value="저장" onclick="testModifySubmit();" />
            </div>
        </div>
    </div>
</div>

<script>

    selectTargetLst('1');

    // 검색영역 enter key event
    function enterSubmit() {
        if (window.event.keyCode == 13) {
            searchCheck();
        }
        return false;
    }

    $(document).ready(function () {

        $('#searchItems ul li').on('click',function(){
            let searchItem = $(this).attr('data');
            console.log("searchItem : " + searchItem)

            if(searchItem != "use_yn"){
                $("#searchValue").val('');
            }

            if(searchItem == "use_yn"){
                console.log("12345");
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

            if(searchItem != "use_yn"){
                console.log("67891");
                $('#searchValue').show();
                $('#typeArea').children().remove();
            }
        });


        // 테스트 타겟 추가 하기
        $('#testAddForm').validate({
            onfocusout: false
            , submitHandler: function () {

                let grp_no = $("#grp_no").val();
                let usr_id = $("#memberNoIns").val().trim();
                let usr_nm = $("#memberNameIns").val().trim();
                let usr_edm = $("#memberEmailIns").val().trim();
                let usr_mob = $("#memberMobileIns").val().trim();
                let use_yn = $('input[name="ins_use_yn"]:checked').val();
                let etc1 = $('#memberEtc1Ins').val().trim();
                let etc2 = $('#memberEtc2Ins').val().trim();
                let etc3 = $('#memberEtc3Ins').val().trim();
                let etc4 = $('#memberEtc4Ins').val().trim();
                let etc5 = $('#memberEtc5Ins').val().trim();

                const res = function(response) {
                    let pageNo = $("#nowPageNo").val();
                    if(response.status == true){
                        selectTargetLst(pageNo)
                        $("#memberNoIns").val('');
                        $("#memberNameIns").val('');
                        $("#memberEmailIns").val('');
                        $("#memberMobileIns").val('');
                        $('input[name="ins_use_yn"]').prop("checked",false);
                        $("#memberEtc1Ins").val('');
                        $("#memberEtc2Ins").val('');
                        $("#memberEtc3Ins").val('');
                        $("#memberEtc4Ins").val('');
                        $("#memberEtc5Ins").val('');
                        $("#totalCnt").text(response.totalCnt);
                        $("#edmCnt").text(response.edmCnt);
                        $("#mobCnt").text(response.mobCnt);

                        $('#errorArea').html('');
                        $('.testMemberPopup').removeClass('active');
                    }
                }
                let param = {grp_no : grp_no , usr_id : usr_id , usr_nm : usr_nm, use_yn : use_yn
                    , usr_edm : usr_edm , usr_mob : usr_mob , usr_etc1 : etc1 , usr_etc2 : etc2 , usr_etc3 : etc3,
                    usr_etc4 : etc4 , usr_etc5 : etc5
                }
                com_ajax.ajax('post','${baseURL}/sys/setting/insertTargetLstOne.ajax', param ,res,'${_csrf.headerName}','${_csrf.token}');

            }
            , errorPlacement: $.noop
            , invalidHandler: function (form, validator) {
                let errors = validator.numberOfInvalids();
                if (errors) {
                    $('#errorArea').html(validator.errorList[0].message);
                }
            }
            , rules: {
                memberNum: {
                    required: true
                }
                , name: {
                    required: true
                }
                , mail: {
                    required: true
                    , email: true
                }
                , mobile: {
                    required: true
                    , phone: true
                }
                , ins_use_yn : {
                    required : true
                }
            }
            , messages: {
                memberNum: {
                    required: "회원번호를 입력해주세요."
                }
                , name: {
                    required: "이름을 입력해주세요."
                }
                , mail: {
                    required: "이메일을 입력해주세요."
                    , email: "이메일 형식에 맞게 입력해주세요."
                }
                , mobile: {
                    required: "모바일 번호를 입력해주세요."
                }
                , ins_use_yn : {
                    required : "사용 여부를 입력해주세요"
                }

            }
        });
        jQuery.validator.addMethod('phone', function (value) {
            let regPhone = /(01[0|1|6|9|7])[-](\d{3}|\d{4})[-](\d{4}$)/g;
            if (!regPhone.test(value)) {
                return false;
            } else {
                return true;
            }
        }, "모바일 번호를 형식에 맞게 입력해주세요.");

        // 테스트 타겟 수정 하기
        $('#testModifyForm').validate({
            onfocusout: false
            , submitHandler: function () {

                let grp_no = $("#grp_no").val();
                let seq = $("#memberSeq").val();
                let usr_id = $("#memberNoMod").val().trim();
                let usr_nm = $("#memberNameMod").val().trim();
                let usr_edm = $("#memberEmailMod").val().trim();
                //let usr_eyn = $('input[name="mail_receive1"]:checked').val();
                let usr_mob = $("#memberMobileMod").val().trim();
                //let usr_myn = $('input[name="mobile_receive1"]:checked').val();
                let use_yn = $('input[name="mod_use_yn"]:checked').val();
                let etc1 = $('#memberEtc1Mod').val().trim();
                let etc2 = $('#memberEtc2Mod').val().trim();
                let etc3 = $('#memberEtc3Mod').val().trim();
                let etc4 = $('#memberEtc4Mod').val().trim();
                let etc5 = $('#memberEtc5Mod').val().trim();

                const res = function(response) {
                    let pageNo = $("#nowPageNo").val();
                    if(response.status == true) {
                        selectTargetLst(pageNo)
                        $("#memberSeq").val('');
                        $("#memberNoMod").val('');
                        $("#memberNameMod").val('');
                        $("#memberEmailMod").val('');
                        $("#memberMobileMod").val('');
                        $('input[name="mod_use_yn"]').prop("checked",false);
                        $("#memberEtc1Mod").val();
                        $("#memberEtc2Mod").val();
                        $("#memberEtc3Mod").val();
                        $("#memberEtc4Mod").val();
                        $("#memberEtc5Mod").val();
                        $('#errorArea1').html('');

                        $("#totalCnt").text(response.totalCnt);
                        $("#edmCnt").text(response.edmCnt);
                        $("#mobCnt").text(response.mobCnt);

                        $('.testMemberRePopup').removeClass('active');
                    }
                }
                let param = {grp_no: grp_no , seq  : seq,  usr_id : usr_id , usr_nm : usr_nm, use_yn : use_yn
                    , usr_edm : usr_edm , usr_mob : usr_mob , usr_etc1 : etc1 , usr_etc2 : etc2 , usr_etc3 : etc3, usr_etc4 : etc4
                    , usr_etc5 : etc5
                }
                com_ajax.ajax('post','${baseURL}/sys/setting/updateTestTargetLstOne.ajax', param ,res,'${_csrf.headerName}','${_csrf.token}');

            }
            , errorPlacement: $.noop
            , invalidHandler: function (form, validator) {
                let errors = validator.numberOfInvalids();
                if (errors) {
                    $('#errorArea1').html(validator.errorList[0].message);
                }
            }
            , rules: {
                memberNum1: {
                    required: true
                }
                , name1: {
                    required: true
                }
                , mail1: {
                    required: true
                    , email: true
                }
                , mod_use_yn : {
                    required: true
                }
                , mobile1: {
                    required: true
                    , phone: true
                }
            }
            , messages: {
                memberNum1: {
                    required: "회원번호를 입력해주세요."
                }
                , name1: {
                    required: "이름을 입력해주세요."
                }
                , mail1: {
                    required: "이메일을 입력해주세요."
                    , email: "이메일 형식에 맞게 입력해주세요."
                }
                , mobile1: {
                    required: "모바일 번호를 입력해주세요."
                }
                , mod_use_yn : {
                    required : "사용 여부를 선택해 주세요"
                }
            }
        });
        jQuery.validator.addMethod('phone', function (value) {
            let regPhone = /(01[0|1|6|9|7])[-](\d{3}|\d{4})[-](\d{4}$)/g;
            if (!regPhone.test(value)) {
                return false;
            } else {
                return true;
            }
        }, "모바일 번호를 형식에 맞게 입력해주세요.");
    });


    let deleteEl;
    function deleteAlert(el,seq) {
        deleteEl = el;
        let html = '';
        html +=
            '<div class="layer_pop alert active">' +
            '<div class="pop_container popup_size3">' +
            '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
            '<div class="pop_title">타겟 삭제</div>' +
            '<div class="pop_inner">' +
            '<div class="alert_txt">선택된 테스트 타겟을 삭제하시겠습니까?</div>' +
            '<div class="btn_row">' +
            '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="deleteTestTarget(' + seq + ');" value="확인" />' +
            '<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소" />' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';
        $('body .layer_pop.alert').remove();
        $('body').append(html);
        return false;
    }

    function deleteRow(row) {
        $(row).parents('tr').remove();
        $('.alert').removeClass('active');
        return false;
    }

    function testAddSubmit() {
        $('#testAddForm').submit();
    }

    function testModifySubmit(){
        $('#testModifyForm').submit();
    }

    function testMemberPopup() {
        $('.testMemberPopup').addClass('active');
    }

    // 테스트 멤버 그룹 조회 하기
    function testMemberRePopup(el,seq) {

        const res = function(response) {
            $("#memberSeq").val(seq)
            $("#memberNoMod").val(response.usr_id);
            $("#memberNameMod").val(response.usr_nm);
            $("#memberEmailMod").val(response.usr_edm);
            $("#memberMobileMod").val(phoneFormatter(response.usr_mob));

            console.log("use_yn : " + response.use_yn)

            if(response.use_yn == "Y") {
                $("#use_yn_yes").prop("checked",true)
            } else if(response.use_yn == "N") {
                $("#use_yn_no").prop("checked", true)
            }
            $("#memberEtc1Mod").val(getData(response.usr_etc1));
            $("#memberEtc2Mod").val(getData(response.usr_etc2));
            $("#memberEtc3Mod").val(getData(response.usr_etc3));
            $("#memberEtc4Mod").val(getData(response.usr_etc4));
            $("#memberEtc5Mod").val(getData(response.usr_etc5));

            $('.testMemberRePopup').addClass('active');
        }
        let data = []
        data.push({name : "seq" , value : seq});
        com_ajax.ajax('post', '${baseURL}/sys/setting/detailTestTarget.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 타겟 리스트 불러 오기
    function selectTargetLst(page){

        const res = function(response) {
            $("#testTargetLst").html(response)
            $("#totalCnt").text($("#targetGrpCnt").val());
            $("#edmCnt").text($("#targetEdmCnt").val());
            $("#mobCnt").text($("#targetMobCnt").val());
        }

        let grp_no = $("#grp_no").val();
        let param = $("#testGrpDetailForm").serializeArray();
        param.push({name: 'pageNo', value: page});
        param.push({name: 'grp_no', value :grp_no})

        com_ajax.ajax('post', '${baseURL}/sys/setting/testGrpTargetList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 테스트 타겟 삭제 하기
    function deleteTestTarget(seq) {
        const res = function(response) {
            let pageNo = $("#nowPageNo").val();
            $('alert').removeClass('active');
            if(response.status == true) {
                popup.popAlert("삭제 완료 되었습니다")
                selectTargetLst(pageNo)
            }
        }
        let data = []
        data.push({name : "seq" , value : seq})

        com_ajax.ajax('post', '${baseURL}/sys/setting/deleteTestTarget.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }


    // 타겟 그룹 리스트 Y,N 값 변경하기
    function updateTestTargetYn(seq , use_yn) {
        const res = function(response) {
            let pageNo = $("#nowPageNo").val();
            if(response.status == true) {
                selectTargetLst(pageNo)
            }
        }
        let data = []
        data.push({name : "seq" , value : seq })
        data.push({name : "use_yn" , value : use_yn})

        com_ajax.ajax('post', '${baseURL}/sys/setting/updateTestTargetYn.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 타겟 유저 리스트 검색 하기
    function searchTargetUserList(){

        let standard = $('.searchSelect').attr('data');
        let searchValue = $("#searchValue").val().trim();

        console.log("standard: " + standard);

        if(standard == "use_yn") {
            let yn_data = $("#yn_select").attr('data');
            $("#searchValue").val(yn_data)
        }
        if (standard == '' && searchValue!= '') {
            popup.searchAlert("기준을 선택해 주세요.");
            return false;
        }
        $("#searchType").val(standard); // 검색 Type 을 Form 으로 받을 수 없어 처리.
        selectTargetLst(1)
    }

    // 번호 format
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

    // 데이터 가져 오기
    function getData(value){
        if(value == null || value == "null"){
            return ""
        } else{
            return value;
        }
    }

    // 사용 여부 USE_YN 변경 하기


</script>

