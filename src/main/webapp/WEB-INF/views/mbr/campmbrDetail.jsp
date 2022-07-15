<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<!-- container 영역 시작 -->
<section class="container">
    <!-- 컨텐츠 영역 시작 -->
    <div class="contents">
        <!-- row 영역 시작 -->
        <div class="row tooltip_area bottom-border cf">
            <form id ="grpDetailForm" name = "grpDetailForm" onsubmit="return false">
                <div class="left">
                    <!-- location 영역 -->
                    <ul class="location">
                        <li>홈</li>
                        <li>회원관리</li>
                        <li>업로드 회원</li>
                        <li>${grpNm}</li>
                    </ul>
                    <!-- tooltip 버튼 영역  -->
<%--                    <div class="tooltip_icon">--%>
<%--                        <img src="/image/ico_tooltip.png" alt="Tooltip" />--%>
<%--                    </div>--%>
                    <!-- tooltip box 영역 시작 -->
<%--                    <div class="tooltip_box">--%>
<%--                        <!-- tooltip bullet 영역 -->--%>
<%--                        <div class="bullet"></div>--%>
<%--                        <span class="bold">2019년 12월 신규 취급액은 91.6억 중,<br />--%>
<%--                                    나오론이 52.4억(57.2%)으로 가장 많은 비중을--%>
<%--                                    차지합니다.</span>--%>
<%--                        스타일론 직장인이 26.69억(29.1%), <br />--%>
<%--                        스타일론 자영업자가 4.1억(4.47%)입니다.<br />--%>
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
                            <li data="usr_id">회원번호</li>
                            <li data="usr_nm">이름</li>
                            <li data="usr_mob">모바일</li>
                            <li data="usr_edm">이메일</li>
                            <li data="usr_gdr">성별</li>
                            <li data="usr_addr">주소</li>
                            <li data="usr_etc1">ETC1</li>
                            <li data="usr_etc2">ETC2</li>
                            <li data="usr_etc3">ETC3</li>
                            <li data="usr_etc4">ETC4</li>
                            <li data="usr_etc5">ETC5</li>
                            <li data="usr_etc6">ETC6</li>
                            <li data="usr_etc7">ETC7</li>
                            <li data="usr_etc8">ETC8</li>
                            <li data="usr_etc9">ETC9</li>
                            <li data="usr_etc10">ETC10</li>
                        </ul>
                    </div>
                    <!-- select 영역 끝 -->
                    <input type="text" class="searchInp left-border" name="searchValue" id ="searchValue" placeholder="검색어입력" />
                    <input type="submit" class="searchBtn" value="검색" onclick="return searchGrpUserList();" />
                    <input type="hidden" id="searchType" name="searchType"/>
                </div>
            </form>
        </div>
        <!-- row 영역 끝 -->
        <!-- row 영역 시작 -->
        <div class="row bottom-border cf">
            <div class="left">
                <a href="javascript:excelGrpUserListDownload()" class="btn_basic down left right-border">내려받기</a>
                <input type="button" class="btn_basic ico_mem_add left right-border" value="회원 추가"
                       onclick="individualPopup();"/>
                <input type="button" class="btn_basic checkDelete left right-border" value="선택삭제"
                       onclick="deleteCheck();" />
                <input type="button" class="btn_basic delete left right-border" value="전체삭제"
                       onclick="allDeletePopup();" />
                <a href="#" class="btn_basic rejection left right-border"></a>
                <div class="info_txt left">※ 내려받기 시, 검색된 리스트가 다운로드됩니다.</div>
                <form:form name="excelForm" id="excelForm" action="/mbr/excel/grpUserList.service" method="post">
                    <input type="hidden" name="searchType" id="excelSearchType"/>
                    <input type="hidden" name="searchValue" id="excelSearchValue"/>
                    <input type="hidden" name="grp_no" id="grp_no" value ="${currentNo}"/>
                </form:form>
            </div>
        </div>
        <span id="campMbrUserListBody"></span>
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

<!-- 삭제안내 팝업 영역 시작 -->
<div class="layer_pop deletePopup">
    <div class="pop_container popup_size3">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
        <div class="pop_title">삭제안내</div>
        <div class="pop_inner">
            <div class="alert_txt">
                <span class="length" id="deleteLength"></span>개의 회원을 삭제하시겠습니까?<br/>
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

<!-- 회원 추가 팝업 영역 시작 -->
<div class="layer_pop rejectionPopup" id="individual">
    <div class="pop_container popup_size1">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
        <div class="pop_title">회원 추가</div>
        <div class="pop_inner">
            <ul class="pop_tap_nav cf">
                <li class="on">개별 등록</li>
                <li>파일 업로드</li>
            </ul>
            <div class="tap_contents on">
                <form id="userForm" name="userForm" onsubmit="" >
                    <input type="hidden" name="grp_no" id ="form_grp_no" value ="${currentNo}"/>
                    <input type="hidden" name="grp_nm" id="grp_nm" value="${grpNm}"/>
                    <div class="vertical_scroll">
                        <table class="pop_table_type1">
                            <colgroup>
                                <col width="103"/>
                                <col width="*"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>회원번호</th>
                                    <td>
                                        <input type="text" placeholder="회원번호를 입력해주세요." name="usr_id" id="memberId" class="input_type1"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>이름</th>
                                    <td>
                                        <input type="text" placeholder="이름을 입력해주세요." name="usr_nm" id="memberNm" class="input_type1"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>모바일</th>
                                    <td>
                                        <input type="text" placeholder="모바일 번호를 입력해주세요." name="usr_mob" id="memberMobile" class="input_type1"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>이메일</th>
                                    <td>
                                        <input type="text" placeholder="이메일 주소를 입력해주세요." name="usr_edm" id="memberMail" class="input_type1"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>성별</th>
                                    <td>
                                        <input type="text" placeholder="성별을 입력해주세요." name="usr_gdr" id="memberGdr" class="input_type1"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>ETC1</th>
                                    <td>
                                        <input type="text" placeholder="ETC1" name ="usr_etc1" id="usr_etc1" class="input_type1"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>ETC2</th>
                                    <td>
                                        <input type="text" placeholder="ETC2" name ="usr_etc2" id="usr_etc2" class="input_type1"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>ETC3</th>
                                    <td>
                                        <input type="text" placeholder="ETC3" name ="usr_etc3" id="usr_etc3" class="input_type1"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>ETC4</th>
                                    <td>
                                        <input type="text" placeholder="ETC4" name ="usr_etc4" id="usr_etc4" class="input_type1"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>ETC5</th>
                                    <td>
                                        <input type="text" placeholder="ETC5" name ="usr_etc5" id="usr_etc5" class="input_type1"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>ETC6</th>
                                    <td>
                                        <input type="text" placeholder="ETC6" name ="usr_etc6" id="usr_etc6" class="input_type1"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>ETC7</th>
                                    <td>
                                        <input type="text" placeholder="ETC7" name ="usr_etc7" id="usr_etc7" class="input_type1"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>ETC8</th>
                                    <td>
                                        <input type="text" placeholder="ETC8" name ="usr_etc8" id="usr_etc8" class="input_type1"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>ETC9</th>
                                    <td>
                                        <input type="text" placeholder="ETC9" name ="usr_etc9" id="usr_etc9" class="input_type1"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th>ETC10</th>
                                    <td>
                                        <input type="text" placeholder="ETC10" name ="usr_etc10" id="usr_etc10" class="input_type1"/>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="pop_error_txt blue_point_color" id="individualError"></div>
                    <div class="btn_row">
                        <input type="button" class="btn_bg btn_size2 btn_center" value="저장" onclick="individualCheck();"/>
                    </div>
                </form>
            </div>
            <div class="tap_contents">
                <form id="" name="" onsubmit="" >
                    <article class="pop_section">
                        <div class="btn_form_down" onclick="formFileDown()">양식 파일 다운로드</div>
                        <div class="align_center">
                            <input type="text" id="fileName" class="input_file" placeholder="파일을 선택해주세요." readonly/>
                            <span class="btn_file">선택<input type="file" class="file" name="file" id="file" accept=".xls,.xlsx" onclick=""/></span>
                        </div>
                    </article>
                    <span>
                         <h3 class="popup_title">파일 업로드 결과</h3>
                        <table class="pop_table_type2 pop_margin_bttm">
                            <colgroup>
                                <col width="20%" />
                                <col width="20%" />
                                <col width="20%" />
                                <col width="20%" />
                                <col width="20%" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>회원번호</th>
                                    <th>이름</th>
                                    <th>모바일</th>
                                    <th>이메일</th>
                                    <th>합계</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="en_font" id="memberNoCnt">0</td>
                                    <td class="en_font" id="memberNmCnt">0</td>
                                    <td class="en_font" id="memberModCnt">0</td>
                                    <td class="en_font" id="memberEdmCnt">0</td>
                                    <td class="en_font" id="totalCnt">0</td>
                                </tr>
                            </tbody>
                        </table>
                        <span id ="excelImport">
                            <h3 class="popup_title">리스트 미리보기</h3>
                            <div class="scroll_tbl pop_margin_bttm">
                                <table class="pop_table_type3 dynamic_tbl list">
                                    <thead>
                                        <th>회원번호</th>
                                        <th>이름</th>
                                        <th>모바일</th>
                                        <th>이메일</th>
                                        <th>성별</th>
                                        <th>주소</th>
                                        <th>ETC1</th>
                                        <th>ETC2</th>
                                        <th>ETC3</th>
                                        <th>ETC4</th>
                                        <th>ETC5</th>
                                        <th>ETC6</th>
                                        <th>ETC7</th>
                                        <th>ETC8</th>
                                        <th>ETC9</th>
                                        <th>ETC10</th>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td></td>
                                            <td></td>
                                            <td class="en_font"></td>
                                            <td class="en_font"></td>
                                            <td class="en_font"></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                            <td></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </span>
                    </span>
                    <div class="btn_row">
                        <input type="button" class="btn_bg btn_size2 btn_center" value="저장" onclick="insertTargetGroup()"/>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- 회원 추가 팝업 영역 끝 -->

<script>

    $(function () {
        // 랜딩 페이지 가져오기
        getCampMbrDetailList(1)
        // 전체 체크/해제 동작
        $(document).on('click','.all input[name=checkAll]',function () {
            if ($(this).is(':checked') == true) {
                $('.custom_check1 input[name=checkEach]').not('.all input').prop('checked', true);
            } else {
                $('.custom_check1 input[name=checkEach]').not('.all input').prop('checked', false);
            }
        });

        $(document).on('click','.table tbody .custom_check1 input[name=checkEach]',function () {
            let total = $('.custom_check1 input[name=checkEach]').not('.all input').length;
            let checkTotal = $('.custom_check1 input[name=checkEach]:checked').not('.all input').length;
            if (total == checkTotal) {
                $('.all input[name=checkAll]').prop('checked', true);
            } else {
                $('.all input[name=checkAll]').prop('checked', false);
            }
        });
        //end

        //tab nav click event
        $('.pop_tap_nav li').on('click', function () {
            let tapIndex = $(this).index();
            $(this).addClass('on').siblings().removeClass('on');
            $('.tap_contents').eq(tapIndex).addClass('on').siblings().removeClass('on');
            //개별등록, 파일 업로드 초기화
            individualInit();
        });
    });

    //선택 삭제 팝업
    function deleteCheck() {
        let checkLength = $('.group_tbl .custom_check1').not('.all').find('input:checked').length;

        $('.deletePopup .length').html(checkLength);

        if (checkLength == 0) {
            popup.popAlert('삭제할 그룹을 선택해주세요.');
        } else {
            $('.deletePopup').addClass('active');
            $('#deleteSave').attr('data', 'list');
        }
    }

    //전체 삭제 팝업
    function allDeletePopup() {
        $('.deletePopup').addClass('active');
        $('#deleteLength').html($('#totCnt').html());
        $('#deleteSave').attr('data', 'all');
    }

    //삭제 동작
    function listDelete(password) {
        let status = $('#deleteSave').attr('data');

        if (password == '') {
            $('#errorArea1').html('비밀번호를 입력해주세요.');
        } else {
            var res = function (response) {
                if (response.status == true) {
                    $('#errorArea1').html('');
                    $(close).parents('.layer_pop').removeClass('active');
                    deleteGrpUserList(status);
                    $('.deletePopup').removeClass('active');
                } else {
                    $('#errorArea1').html('비밀번호를 확인해주세요.');
                }
            };
            var param = {"password": password};
            com_ajax.ajax('post', '${baseURL}/mcr/check/pw.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
        }
        return false;
    };

    // 그룹 유저 리스트 가져오기
    function getCampMbrDetailList(pageNo) {

        var currentPageNo = ${currentNo};

        var res = function (response) {
            $("#campMbrUserListBody").html(response);
        }
        var param = $("#grpDetailForm").serializeArray();
        param.push({name: 'pageNo', value: pageNo});
        param.push({name: 'grp_no', value : currentPageNo});

        com_ajax.ajax('post', '${baseURL}/mbr/grpUserList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 그룹 유저 리스트 검색
    function searchGrpUserList(){

        let standard = $('.searchSelect').attr('data');
        let searchValue = $("#searchValue").val().trim();

        if (standard == '' && searchValue!= '') {
            popup.searchAlert("기준을 선택해 주세요.");
            return false;
        }
        $("#searchType").val(standard); // 검색 Type 을 Form 으로 받을 수 없어 처리.
        getCampMbrDetailList(1);
    }

    // 엑셀 다운로드
    function excelGrpUserListDownload() {

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

        let standard = $('.searchSelect').attr('data');
        let searchValue = $("#searchValue").val();


        // 검색시 필요한 searchValue, searchType 추가
        $("#excelSearchType").attr("value", standard);
        $("#excelSearchValue").attr("value", searchValue);

        $("#excelForm").attr("target", "popup_down");
        $("#excelForm").submit();
    }

    //실제 삭제 AJAX function
    function deleteGrpUserList(data) {

        var res = function (response) {
            if (response.status == "success") {
                popup.popAlert("삭제되었습니다.");
                $('#errorArea1').html('');
                $('.password_input').val('');
                getCampMbrDetailList(nowPage);
            }
        };
        var nowPage;    // 현재 페이지 번호

        if(data == 'all'){
            // 전체 삭제
            nowPage = '1';
            var param = {
                'searchType': $('#resultSearchType').val(),
                'searchValue': $('#resultSearchValue').val(),
                'grp_no' : $('#grp_no').val()
            };
            com_ajax.ajax('post', '${baseURL}/mbr/delGrpUserListAll.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
        } else {
            // 선택 삭제
            nowPage = $('#nowPageNo').val();

            var checkList = [];
            var checkLength = $('.custom_check1 input[name=checkEach]:checked').length;

            for(var i=0; i<checkLength; i++){
                checkList.push($('.custom_check1 input[name=checkEach]:checked').eq(i).val());
            }

            var param = {checkList: checkList};
            com_ajax.ajax('post', '${baseURL}/mbr/delGrpUserList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
        }
    }

    // 팝업 닫기
    function popupClose(close) {
        $("#deletePassword").val('');
        $(close).parents('.layer_pop').removeClass('active');
    }

    //개별 등록 유효성 검사
    function individualCheck(){
        let pattern = special_pattern = /[~!@#$%^&*()_+|<>?:{}]/;
        let regPhone =  /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?[0-9]{3,4}-?[0-9]{4}$/;
       /* let member = $('#memberId').val()
        let name = $('#memberNm').val();
        let mobile = $('#memberMobile').val();
        let email = $('#memberMail').val();
        let gdr = $("#memberGdr").val();*/

        let member = $('#memberId').val().trim();
        let name = $('#memberNm').val().trim();
        let mobile = $('#memberMobile').val().trim();
        let email = $('#memberMail').val().trim();
        let gdr = $("#memberGdr").val();

        let errormessage = $('#individualError');

        if(member == ''){
            errormessage.html('회원번호를 입력해 주세요.');
            return false;
        }
        if(pattern.test(member)){
            errormessage.html('회원번호는 특수문자를 포함할 수 없습니다.');
            return false;
        }
        if(name == ''){
            errormessage.html('이름을 입력해 주세요.');
            return false;
        }
        // 이름 특수문자 허용
        /*if(pattern.test(name)){
            errormessage.html('이름은 특수문자를 포함할 수 없습니다.');
            return false;
        }*/
        if(mobile == '' && email == ''){
            errormessage.html('모바일, 이메일 중 입력해주세요.');
            return false;
        }
        if(mobile != '' && !regPhone.test(mobile)){
            errormessage.html('핸드폰 번호 형식에 맞게 입력해주세요.');
            return false;
        }
        if(email != '' && !common.emailcheck(email)){
            errormessage.html('이메일 형식에 맞게 입력해주세요.');
            return false;
        }

        if(gdr.search(/\s/) != -1) {
            errormessage.html('성별에 공백 값을 제거해주세요')
            return false;
        }

        if(gdr != '' && (gdr.trim() != 'M' && gdr.trim() != 'F')) {
            errormessage.html('성별에는 M,F 값만 입력해주세요');
            return false;
        }
        else{
            errormessage.html('');
            //return false;
        }

        const res = function(response) {
            if(response.status == true) {
                let nowPage = $('#nowPageNo').val();
                $("#usr_id").val('')
                $("#usr_nm").val('')
                $("#usr_mob").val('')
                $("#usr_edm").val('')
                $("#usr_gdr").val('')
                $("#usr_etc1").val('')
                $("#usr_etc2").val('')
                $("#usr_etc3").val('')
                $("#usr_etc4").val('')
                $("#usr_etc5").val('')
                $("#usr_etc6").val('')
                $("#usr_etc7").val('')
                $("#usr_etc8").val('')
                $("#usr_etc9").val('')
                $("#usr_etc10").val('')
                errormessage.html('');
                $('#individual').removeClass('active');
                getCampMbrDetailList(nowPage)
            }
        }
        let user_form = $("#userForm").serializeArray()
        com_ajax.ajax('post', '/mbr/insertOneTargetUser.ajax', user_form, res, '${_csrf.headerName}', '${_csrf.token}')
    }

    //회원 추가 팝업 open event
    function individualPopup(){
        $('#individual').addClass('active');
        individualInit();
    }

    function individualInit(){
        //개별등록 초기화
        $('#individual .pop_table_type1').find('input').val('');
        //파일 업로드 초기화
        $('#file').val('');
        $('#fileName').val('');
    }

    // 업로드 회원 양식 다운로드
    function formFileDown() {
        location.href = '${baseURL}/download/업로드회원등록양식2.xlsx';
        $('#commonLoading').removeClass('active');
    }

    // 재 클릭시 파일 초기화
    $('.file').on('click', function () {
        $("#file").val('');
    })

    // Import Detail 엑셀 서비스
    $('.file').on('change', function(){
        let fileName = $(this).val();
        let format = fileName.slice(fileName.lastIndexOf('.') + 1).toLowerCase();

        if (!(format == 'xlsx' || format == 'csv')) {
            popup.popAlert("'xlsx', 'csv' 파일 형식만 업로드 가능 합니다.");
        } else {
            $("#fileName").val(fileName)
            popup.popAlert("100개 미만의 타겟 수 데이터만 유효성 검사를<br/>진행합니다.");

            const res = function(response) {
                if(response.result) {
                    let text = "";
                    let list = response.list;

                    // 업로드 회원수 Cnt 값 변경
                    $("#memberNoCnt").text(response.memNoCnt)
                    $("#memberNmCnt").text(response.memNmCnt)
                    $("#memberModCnt").text(response.mdmCnt)
                    $("#memberEdmCnt").text(response.edmCnt)
                    $("#totalCnt").text(response.totalCnt)

                    text += '<h3 class="popup_title">리스트 미리보기</h3>'
                        + '<div class ="scroll_tbl pop_margin_bttm">'
                        + '<table class="pop_table_type3 dynamic_tbl list">'
                        + '<thead>'
                        + '<tr>'
                        + '<th>회원번호</th>'
                        + '<th>이름</th>'
                        + '<th>모바일</th>'
                        + '<th>이메일</th>'
                        + '<th>성별</th>'
                        + '<th>주소</th>'
                        + '<th>ETC1</th>'
                        + '<th>ETC2</th>'
                        + '<th>ETC3</th>'
                        + '<th>ETC4</th>'
                        + '<th>ETC5</th>'
                        + '<th>ETC6</th>'
                        + '<th>ETC7</th>'
                        + '<th>ETC8</th>'
                        + '<th>ETC9</th>'
                        + '<th>ETC10</th>'
                        + '</tr>'
                        + '</thead>'
                        + '<tbody>'

                    for(let i = 0; i<list.length; i++ ){
                        let value = list[i];

                        text += '<tr>';

                        text += '<td>' + getData(value.usr_id) + '</td>'
                            + '<td>' + getData(value.usr_nm) + '</td>'
                            + '<td class = "en_font">' + getData(value.usr_mob) + '</td>'
                            + '<td class = "en_font">' + getData(value.usr_edm) + '</td>'
                            + '<td class = "en_font">' + getData(value.usr_gdr) + '</td>'
                            + '<td>' + getData(value.usr_addr) + '</td>'
                            + '<td>' + getData(value.usr_etc1) + '</td>'
                            + '<td>' + getData(value.usr_etc2) + '</td>'
                            + '<td>' + getData(value.usr_etc3) + '</td>'
                            + '<td>' + getData(value.usr_etc4) + '</td>'
                            + '<td>' + getData(value.usr_etc5) + '</td>'
                            + '<td>' + getData(value.usr_etc6) + '</td>'
                            + '<td>' + getData(value.usr_etc7) + '</td>'
                            + '<td>' + getData(value.usr_etc8) + '</td>'
                            + '<td>' + getData(value.usr_etc9) + '</td>'
                            + '<td>' + getData(value.usr_etc10) + '</td>'

                        text += '</tr>'
                    }
                    text += '</tbody>'
                        + '</table>'
                        + '</div>'
                    $("#excelImport").html(text)

                } else{

                    // 업로드 회원수 0 으로 초기화
                    $("#memberNoCnt").text(0)
                    $("#memberNmCnt").text(0)
                    $("#memberModCnt").text(0)
                    $("#memberEdmCnt").text(0)
                    $("#totalCnt").text(0)

                    popup.popAlert(response.message);

                    let text = "";
                    text += '<h3 class="popup_title">리스트 미리보기</h3>'
                        + '<div class ="scroll_tbl pop_margin_bttm">'
                        + '<table class="pop_table_type3">'
                        + '<tbody>'
                        + '<tr class ="no_data">'
                        + '<td colspan="100%">' + "입력된 정보가 없습니다" + '</td>'
                        + '</tr>'
                        + '</tbody>'
                        + '</table>'
                        + '</div>'

                    $("#excelImport").html(text)
                    $("#fileName").val('');
                    $("#file").val('');
                }
            }
            let formData = new FormData()
            formData.append("grp_no", $("#form_grp_no").val()); // 그룹 번호
            formData.append("excelFile", $("#file")[0].files[0]);   // 엑셀 파일
            com_ajax.ajax_file('${baseURL}/mbr/importDetailExcelFile.ajax', formData, res, '${_csrf.headerName}', '${_csrf.token}');
        }
    })

    // 데이터 가져오기
    function getData(value) {
        return (value == null ? "" : value)
    }

    // 타겟 그룹 추가 등록
    function insertTargetGroup(){

        if ($('.file').val() == '') {
            $('#individualError').html('타겟 파일을 선택해주세요.');
            return false;
        }

        const res = function(response) {

            // 업로드 회원수 0 으로 초기화
            $("#memberNoCnt").text(0)
            $("#memberNmCnt").text(0)
            $("#memberModCnt").text(0)
            $("#memberEdmCnt").text(0)
            $("#totalCnt").text(0)

            popup.popAlert(response.message);

            let text = "";
            text += '<h3 class="popup_title">리스트 미리보기</h3>'
                + '<div class ="scroll_tbl pop_margin_bttm">'
                + '<table class="pop_table_type3">'
                + '<tbody>'
                + '<tr class ="no_data">'
                + '<td colspan="100%">' + "입력된 정보가 없습니다" + '</td>'
                + '</tr>'
                + '</tbody>'
                + '</table>'
                + '</div>'

            $("#excelImport").html(text)
            $("#fileName").val('');
            $("#file").val('');

            $('#individual').removeClass('active')
            popup.popAlert(response.message);

            let nowPage = $("#nowPageNo").val()
            getCampMbrDetailList(nowPage)

            $("#fileName").val('');
            $("#file").val('');

        }
        let grp_no = $("#form_grp_no").val()
        let grp_nm = $("#grp_nm").val()

        let formData = new FormData()
        formData.append("grp_no",grp_no)
        formData.append("grp_nm",grp_nm)
        if($('#file')[0].files[0] != null) {
            formData.append("file" , $('#file')[0].files[0]);
        }
        com_ajax.ajax_file('${baseURL}/mbr/targetInsert.ajax', formData, res, '${_csrf.headerName}', '${_csrf.token}');
    }


</script>
