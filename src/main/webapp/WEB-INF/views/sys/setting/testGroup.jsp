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
<%@ taglib prefix="ui" uri="tld/Page.tld" %>

<section class="container">
    <!-- 컨텐츠 영역 시작 -->
    <div class="contents">
        <!-- row 영역 시작 -->
        <form:form id ="searchForm" name="searchForm" action="${baseURL}/sys/setting/testGroup.mi" method="get">
            <div class="row tooltip_area bottom-border cf">
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
                            스타일론 자영업자가 4.1억(4.47%)입니다.<br />
                        </div>--%>
                        <!-- tooltip box 영역 끝 -->
                    </div>
                    <div class="right">
                        <!-- select 영역 시작 -->
                        <div class="select style1 left-border" id ="searchItems">
                            <!-- selected value -->
                            <div class="value searchSelect" data="${searchType}">
                                <c:choose>
                                    <c:when test="${searchType == 'grp_nm'}">그룹명</c:when>
                                    <c:when test="${searchType == 'use_yn'}">사용여부</c:when>
                                    <c:when test="${searchType == 'reg_dt'}">생성일</c:when>
                                    <c:when test="${searchType == 'upd_dt'}">수정일</c:when>
                                    <c:otherwise>
                                        기준선택
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <!-- option -->
                            <ul class="option">
                                <li data="grp_nm">그룹명</li>
                                <li data="use_yn">사용여부</li>
                                <li data="reg_dt">생성일</li>
                                <li data="upd_dt">수정일</li>
                            </ul>
                        </div>
                        <div class="left" id="typeArea"></div>
                        <input type="hidden" id="page_num" name="pageNo" value="${pageNo}"/>
                        <input type="hidden" name="searchType" id="searchType" value="${searchType}"/>
                        <input type="text" class="searchInp left-border searchWord" name="searchValue" id ="searchValue"
                              value="${searchValue}" placeholder="검색어입력" onkeyup="enterSubmit();" />
                        <input type="submit" class="searchBtn" value="검색" onclick="return searchTestGrpList();" />
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
                    <div class="total left">테스트 그룹 리스트</div>
                    <input type="button" class="btn_add right" value="추가" onclick="testGroupPopup();" />
                </div>
                <span id ="testGrpList">
                    <c:choose>
                        <c:when test = "${!cutil:isEmptyObject(list)}">
                        <table class="table">
                            <colgroup>
                                <col width="30%" />
                                <col width="10%" />
                                <col width="10%" />
                                <col width="10%" />
                                <col width="10%" />
                                <col width="10%" />
                                <col width="10%" />
                                <col width="10%" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>그룹명</th>
                                    <th>타겟 수</th>
                                    <th>이메일</th>
                                    <th>모바일</th>
                                    <th>사용여부</th>
                                    <th>생성일</th>
                                    <th>수정일</th>
                                    <th>보기/삭제</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="n" items="${list}" varStatus="status">
                                    <tr>
                                        <td>${n.grp_nm}</td>
                                        <td class="en_font">${n.grp_cnt}</td>
                                        <td class="en_font">${n.edm_cnt}</td>
                                        <td class="en_font">${n.mob_cnt}</td>
                                        <td class="en_font">
                                            <c:if test="${n.use_yn == 'Y'}">
                                                <input type="button" class="use_state en_font btn_state"
                                                       onclick="updateTestGrpYn('${n.seq}','${n.use_yn}')" value="Y" />
                                            </c:if>
                                            <c:if test="${n.use_yn == 'N'}">
                                                <input type="button" class="use_state en_font btn_state"
                                                       onclick="updateTestGrpYn('${n.seq}','${n.use_yn}')" value="N" />
                                            </c:if>
                                        </td>
                                        <td class="en_font">
                                            <c:if test="${!cutil:isEmptyObject(n.reg_dt)}">
                                                ${cutil:stringDateHourParse(n.reg_dt)}
                                            </c:if>
                                        </td>
                                        <td class="en_font">
                                            <c:if test="${!cutil:isEmptyObject(n.upd_dt)}">
                                                ${cutil:stringDateHourParse(n.upd_dt)}
                                            </c:if>
                                        </td>
                                        <td>
                                            <a href="/sys/setting/detailTestGrp/${n.seq}.mi" class="btn_sm_line btn_inline size">보기</a>
                                            <input type="button" class="btn_sm_line btn_inline size" value="삭제" onclick="deleteAlert(this ,'${n.seq}');"/>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                            <div class="btn_row bottom-border">
                                <ul class="pager">
                                    <ui:pagination paginationInfo="${page}" type="image" jsFunction="linkPage"/>
                                </ul>
                            </div>
                        </c:when>
                        <c:otherwise>
                        <table class="table">
                            <colgroup>
                                <col width="30%" />
                                <col width="10%" />
                                <col width="10%" />
                                <col width="10%" />
                                <col width="10%" />
                                <col width="10%" />
                                <col width="10%" />
                                <col width="10%" />
                            </colgroup>
                            <thead>
                            <tr>
                                <th>그룹명</th>
                                <th>타겟 수</th>
                                <th>이메일</th>
                                <th>모바일</th>
                                <th>사용여부</th>
                                <th>생성일</th>
                                <th>수정일</th>
                                <th>보기/삭제</th>
                            </tr>
                            </thead>
                            <tbody>
                            <!-- 검색 결과가 없는 경우 영역 시작 -->
                            <tr class="no_data">
                                <td colspan="11">조회된 결과가 없습니다.</td>
                            </tr>
                            </tbody>
                        </table>
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
        </form:form>
    </div>
    <!-- 컨텐츠 영역 끝 -->
    <!-- footer 영역 시작 -->
    <footer class="footer">
        &copy; Milvus Corp.
    </footer>
    <!-- footer 영역 끝 -->
</section>

<!-- 수신거부 추가 팝업 영역 시작 -->
<div class="layer_pop testGroupPopup">
    <div class="pop_container popup_size6">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
        <div class="pop_title">테스트 그룹 추가</div>
        <div class="pop_inner">
            <article class="pop_section">
                <a href="javascript:void(0);" onclick="formFileDown()" class="btn_form_down position" download>양식 파일 다운로드</a>
                <div class="align_center">
                    <input type="text" id="testGrpName" class="input_grpNm" placeholder="테스트 그룹 명을 입력해 주세요"/>
                </div>
                <div class="align_center">
                    <input type="text" id="fileName" class="input_file" placeholder="파일을 선택해주세요." readonly />
                    <span class="btn_file">선택<input type="file" id="excelFileData" name ="excelFileData" class="file" /></span>
                </div>
            </article>
            <h3 class="popup_title">양식 파일 결과</h3>
            <span id ="importFileCnt"></span>
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
                    <th>이메일</th>
                    <th>이메일 중복</th>
                    <th>모바일</th>
                    <th>모바일 중복</th>
                    <th>합계</th>
                </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="en_font" id="title_1"></td>
                        <td class="en_font blue_point_color" id="title_2"></td>
                        <td class="en_font" id="title_3"></td>
                        <td class="en_font" id="title_4"></td>
                        <td class="en_font" id="title_5"></td>
                    </tr>
                </tbody>
            </table>
            <span id ="importBody">
                <h3 class="popup_title">리스트 미리보기</h3>
                <div class="scroll_tbl pop_margin_bttm">
                    <table class="pop_table_type3 tbl_width1">
                        <thead>
                        <th>회원번호</th>
                        <th>이름</th>
                        <th>이메일</th>
                        <th>모바일</th>
                        <th>사용여부</th>
                        <th>ETC1</th>
                        <th>ETC2</th>
                        <th>ETC3</th>
                        <th>ETC4</th>
                        <th>ETC5</th>
                        </thead>
                        <tbody>
                        <!-- <tr class="no_data">
                            <td class="en_font" colspan="11">조회된 결과가 없습니다.</td>
                        </tr> -->
                        </tbody>
                    </table>
                </div>
            </span>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_center" value="저장" onclick="testGroupInsert();" />
            </div>
        </div>
    </div>
</div>
<!-- 수신거부 추가 팝업 영역 끝 -->

<script>

    function enterSubmit() {
        if (window.event.keyCode == 13) {
            searchTestGrpList();
        }
        return false;
    }

    // 페이지 이동
    function linkPage(s){
        $("#page_num").val(s);
        $("#searchForm").submit();
    }

    $(document).ready(function () {

        $('.file').on('change', function () {
            let fileName = $(this).val();
            let format = fileName.slice(fileName.lastIndexOf('.') + 1).toLowerCase();
            if (!(format == 'xlsx' || format == "csv")) {
                alert("'xlsx', 'csv' 파일 형식만 업로드 가능 합니다.");
            } else {
                $("#fileName").val(fileName);
            }
        });

        $('#searchItems ul li').on('click',function(){

            let searchItem = $(this).attr('data');

            if(searchItem == "grp_nm"){
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

            if(searchItem == 'reg_dt' || searchItem == 'upd_dt'){

                $('#searchValue').hide();

                if(searchItem == 'reg_dt') {
                    $('#typeArea').html(
                        '<input type="text" class="searchInp date left-border right-border" name="reg_dt" id="tg_from" placeholder="생성일 선택"/>' +
                        '<span class="hyphen"></span>' +
                        '<input type="text" class="searchInp date left-border right-border" name="reg_dt_range" id="tg_to" placeholder="생성일 선택"/>'
                    );
                } else if (searchItem == 'upd_dt') {
                    $('#typeArea').html(
                        '<input type="text" class="searchInp date left-border right-border" name="upd_dt" id="tg_from" placeholder="생성일 선택"/>' +
                        '<span class="hyphen"></span>' +
                        '<input type="text" class="searchInp date left-border right-border" name="upd_dt_range" id="tg_to" placeholder="생성일 선택"/>'
                    );
                }

                $.datepicker.setDefaults({
                    dateFormat: 'yy-mm-dd'
                    , monthNames: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
                    , showMonthAfterYear: true
                    , yearSuffix: "."
                });
                //[타겟 선택 팝업]시작일 달력
                $('#tg_from').datepicker({
                    onSelect: function (selected) {
                        $("#tg_to").datepicker("option", "minDate", selected)
                    }
                });
                //[타겟 선택 팝업]종료일 달력
                $('#tg_to').datepicker({
                    onSelect: function (selected) {
                        $("#tg_from").datepicker("option", "maxDate", selected)
                    }
                });
            }

            if(searchItem != 'reg_dt' && searchItem != 'upd_dt' && searchItem != 'use_yn'){
                $('#searchValue').show();
                $('#typeArea').children().remove();
            }
        });

    });

    let deleteEl;
    function deleteAlert(el,seq) {
        deleteEl = el;
        let html = '';
        html +=
            '<div class="layer_pop alert active">' +
            '<div class="pop_container popup_size3">' +
            '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
            '<div class="pop_title">테스트 그룹 삭제</div>' +
            '<div class="pop_inner">' +
            '<div class="alert_txt">선택된 테스트 그룹을 삭제하시겠습니까?</div>' +
            '<div class="btn_row">' +
            '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="deleteTestGrp(' + seq + ');" value="확인" />' +
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

    function testGroupPopup() {
        $('.testGroupPopup').addClass('active');
    }

    // 테스트 그룹 리스트 불러오기
    function selectTestGrpLst(pageNo) {
        const res = function(response){
            $("#testGrpList").html(response)
        }
        let param = $("#searchForm").serializeArray();
        param.push({name: 'pageNo', value: pageNo});
        com_ajax.ajax('post', '${baseURL}/sys/setting/testGrpList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 테스트 그룹 Y,N 변경하기
    function updateTestGrpYn(seq,use_yn) {
        const res = function(response) {
            let pageNo = $("#nowPageNo").val();
            if(response.status == true){
                selectTestGrpLst(pageNo)
            }
        }
        let data = []
        data.push({name : "seq" , value : seq })
        data.push({name : "use_yn" , value : use_yn})

        com_ajax.ajax('post', '${baseURL}/sys/setting/updateTestGrpYn.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 테스트 그룹 삭제 하기
    function deleteTestGrp(seq) {
        const res = function(response) {
            let pageNo = $("#nowPageNo").val();
            $('.alert').removeClass('active');
            if(response.status == true){
                popup.popAlert("삭제 완료 되었습니다");
                selectTestGrpLst(pageNo);
            }
        }
        let data = []
        data.push({name : "seq" , value : seq })
        com_ajax.ajax('post', '${baseURL}/sys/setting/deleteTestGrp.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 테스트 그룹 검색 처리 하기
    function searchTestGrpList() {
        let standard = $('.searchSelect').attr('data');
        let searchValue = $("#searchValue").val().trim();

        if(standard =='use_yn') {
            let yn_data = $("#yn_select").attr('data');
            $("#searchValue").val(yn_data)
        } else if(standard == 'reg_dt') {
            let reg_dt  = $("#searchDate").val();
            $("#searchValue").val(reg_dt)
        } else if (standard == 'upd_dt') {
            let upd_dt  = $("#searchDate").val();
            $("#searchValue").val(upd_dt)
        }
        if (standard == '' && searchValue != '') {
            popup.searchAlert("기준을 선택해 주세요.");
            return false;
        }
        $("#searchType").val(standard); // 검색 Type 을 Form 으로 받을 수 없어 처리.
        $("#page_num").val(1)   // GET 방식으로 변경해서 처리
        $("#searchForm").submit();
    }

    // 테스트 그룹 양식 다운로드 하기
    function formFileDown(){
        location.href = "${baseURL}/download/테스트그룹양식2.xlsx"
        $('#commonLoading').removeClass('active');
    }

    // 파일 변경시 값 바꾸기
    $('.file').on('click',function(){
        $("#excelFileData").val('');
    })

    // 테스트 그룹 Import 하기
    $('.file').on('change' , function() {
        let fileName = $(this).val();
        let format = fileName.slice(fileName.lastIndexOf('.') + 1).toLowerCase();

        if (!(format == 'xlsx' || format == 'csv')) {
            popup.popAlert("'xlsx', 'csv' 파일 형식만 업로드 가능 합니다.");
        } else {
            popup.popAlert("테스트 그룹은 100개 까지만 저장할 수 있습니다.");

            const res = function(response) {

                if (response.status) {

                    // 타이틀 값 채우기
                    $("#title_1").text(response.emailCnt);
                    $("#title_2").text(response.emailDupliCnt);
                    $("#title_3").text(response.mobileCnt);
                    $("#title_4").text(response.mobileDupliCnt);
                    $("#title_5").text(response.totalCnt);

                    // import 한 엑셀데이터 body 값 채우기
                    let list = response.list
                    let text = "";
                    text += '<h3 class="popup_title">리스트 미리보기</h3>'
                        + '<div class ="scroll_tbl pop_margin_bttm">'
                        + '<table class ="pop_table_type3 tbl_width1">'
                        + '<thead>'
                        + '<th>회원번호</th>'
                        + '<th>이름</th>'
                        + '<th>이메일</th>'
                        + '<th>모바일</th>'
                        + '<th>사용여부</th>'
                        + '<th>ETC1</th>'
                        + '<th>ETC2</th>'
                        + '<th>ETC3</th>'
                        + '<th>ETC4</th>'
                        + '<th>ETC5</th>'
                        + '</thead>'
                        + '<tbody>';

                    for (let i = 0; i < list.length; i++) {
                        let value = list[i]
                        text += "<tr>";

                        text += "<td class='en_font'>" + getData(value.usr_id) + "</td>"
                            + "<td>" + getData(value.usr_nm) + "</td>"
                            + "<td class='en_font'>" + getData(value.usr_edm) + "</td>"
                            + "<td class='en_font'>" + getData(value.usr_mob) + "</td>"
                            + "<td class='en_font'>" + getData(value.use_yn) + "</td>"
                            + "<td>" + getData(value.usr_etc1) + "</td>"
                            + "<td>" + getData(value.usr_etc2) + "</td>"
                            + "<td>" + getData(value.usr_etc3) + "</td>"
                            + "<td>" + getData(value.usr_etc4) + "</td>"
                            + "<td>" + getData(value.usr_etc5) + "</td>"
                    }
                    text += "</tr>";

                    text += '</tbody>'
                        + '</table>'
                        + '</div>';
                    $("#importBody").html(text);
                } else {

                    // 에러 상태인 경우
                    popup.popAlert(response.message)
                    let list = response.errorList
                    if(list == null) {
                        let text = "";
                        text += '<h3 class="popup_title">리스트 미리보기</h3>'
                            + '<div class ="scroll_tbl pop_margin_bttm">'
                            + '<table class ="pop_table_type3 tbl_width1">'
                            + '<thead>'
                            + '<th>회원번호</th>'
                            + '<th>이름</th>'
                            + '<th>이메일</th>'
                            + '<th>모바일</th>'
                            + '<th>사용여부</th>'
                            + '<th>ETC1</th>'
                            + '<th>ETC2</th>'
                            + '<th>ETC3</th>'
                            + '<th>ETC4</th>'
                            + '<th>ETC5</th>'
                            + '</thead>';

                        $("#importBody").html(text);

                    } else {
                        let text = "";
                        text += '<h3 class="popup_title">에러 리스트 미리보기</h3>'
                            + '<div class ="scroll_tbl pop_margin_bttm">'
                            + '<table class ="pop_table_type3 tbl_width1">'
                            + '<thead>'
                            + '<th>회원번호</th>'
                            + '<th>이름</th>'
                            + '<th>이메일</th>'
                            + '<th>모바일</th>'
                            + '<th>사용여부</th>'
                            + '<th>ETC1</th>'
                            + '<th>ETC2</th>'
                            + '<th>ETC3</th>'
                            + '<th>ETC4</th>'
                            + '<th>ETC5</th>'
                            + '</thead>'
                            + '<tbody>';

                        for (let i = 0; i < list.length; i++) {
                            let value = list[i]
                            text += "<tr>";

                            text += "<td class='en_font'>" + getData(value.usr_id) + "</td>"
                                + "<td>" + getData(value.usr_nm) + "</td>"
                                + "<td class='en_font'>" + getData(value.usr_edm) + "</td>"
                                + "<td class='en_font'>" + getData(value.usr_mob) + "</td>"
                                + "<td class='en_font'>" + getData(value.use_yn) + "</td>"
                                + "<td>" + getData(value.usr_etc1) + "</td>"
                                + "<td>" + getData(value.usr_etc2) + "</td>"
                                + "<td>" + getData(value.usr_etc3) + "</td>"
                                + "<td>" + getData(value.usr_etc4) + "</td>"
                                + "<td>" + getData(value.usr_etc5) + "</td>"
                        }
                        text += "</tr>";

                        text += '</tbody>'
                            + '</table>'
                            + '</div>';
                        $("#importBody").html(text);
                    }

                    $("#testGrpName").val('');
                    $("#fileName").val('');
                    $("#excelFileData").val('')

                    // Error 발생시 타이틀 값 초기화
                    $("#title_1").text('');
                    $("#title_2").text('');
                    $("#title_3").text('');
                    $("#title_4").text('');
                    $("#title_5").text('');
                }
            }
            let formData = new FormData()
            formData.append("excelFile" , $("#excelFileData")[0].files[0])
            com_ajax.ajax_file('${baseURL}/sys/setting/testTargetImport.ajax', formData , res,'${_csrf.headerName}', '${_csrf.token}');
        }
    });

    // 데이터 가져오기
    function getData(value){
        return (value == null ? "" : value)
    }

    // 테스트 그룹 저장 하기
    function testGroupInsert(){

        if($("#testGrpName").val() == '') {
            popup.popAlert("테스트 그룹 명을 입력해 주세요")
            return false;
        }

        if ($('.file').val() == '') {
            popup.popAlert("타겟 파일을 선택해 주세요")
            return false;
        }

        const res = function(response){

            $("#fileName").val('');
            $("#testGrpName").val('');
            $("#excelFileData").val('');

            $("#title_1").text('');
            $("#title_2").text('');
            $("#title_3").text('');
            $("#title_4").text('');
            $("#title_5").text('');

            let pageNo = $("#nowPageNo").val();
            selectTestGrpLst(pageNo)

            let text = "";
            text += '<h3 class="popup_title">리스트 미리보기</h3>'
                + '<div class ="scroll_tbl pop_margin_bttm">'
                + '<table class ="pop_table_type3 tbl_width1">'
                + '<thead>'
                + '<th>회원번호</th>'
                + '<th>이름</th>'
                + '<th>이메일</th>'
                + '<th>모바일</th>'
                + '<th>사용여부</th>'
                + '<th>ETC1</th>'
                + '<th>ETC2</th>'
                + '<th>ETC3</th>'
                + '<th>ETC4</th>'
                + '<th>ETC5</th>'
                + '</thead>'
                + '<tbody>';

            $("#importBody").html(text);
            $('.testGroupPopup').removeClass('active');
        }

        let formData = new FormData();
        if($("#excelFileData")[0].files[0] != null){    // 임시 파일 넘기기용
            formData.append("excelFile", $("#excelFileData")[0].files[0]);
            formData.append("grp_nm" , $("#testGrpName").val())
        }
        com_ajax.ajax_file('${baseURL}/sys/setting/testTargetInsert.ajax', formData , res,'${_csrf.headerName}', '${_csrf.token}');

    }

    // 초기 검색 값, 검색 타입 랜딩 하기
    function init(){

        let searchItem = '${searchType}'
        let searchValue = '${searchValue}'

        if(searchItem == "use_yn"){
            $('#searchValue').hide();
            $('#typeArea').html(
                '<div class="select style1 right-border left-border">' +
                '<div class="value searchSelect" id="yn_select" data="'+ searchValue +'">' + searchValue + '</div>' +
                '<ul class="option">' +
                '<li data="Y">Y</li>' +
                '<li data="N">N</li>' +
                '</ul>' +
                '</div> '
            );
        }

        if(searchItem == 'reg_dt' || searchItem == 'upd_dt'){

            $('#searchValue').hide();

            if(searchItem == 'reg_dt') {

                let reg_dt = '${reg_dt}'    // 등록일
                let reg_dt_range = '${reg_dt_range}'    // 등록일 범위

                $('#typeArea').html(
                    '<input type="text" class="searchInp date left-border right-border" name="reg_dt" id="tg_from" value="' + reg_dt + '"/>' +
                    '<span class="hyphen"></span>' +
                    '<input type="text" class="searchInp date left-border right-border" name="reg_dt_range" id="tg_to" value="' + reg_dt_range + '"/>'
                );
            } else if (searchItem == 'upd_dt') {

                let upd_dt = '${upd_dt}'    // 수정일
                let upd_dt_range = '${upd_dt_range}'    // 수정일 범위

                $('#typeArea').html(
                    '<input type="text" class="searchInp date left-border right-border" name="upd_dt" id="tg_from" value="' + upd_dt + '"/>' +
                    '<span class="hyphen"></span>' +
                    '<input type="text" class="searchInp date left-border right-border" name="upd_dt_range" id="tg_to" value="' + upd_dt_range + '"/>'
                );
            }

            $.datepicker.setDefaults({
                dateFormat: 'yy-mm-dd'
                , monthNames: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
                , showMonthAfterYear: true
                , yearSuffix: "."
            });
            //[타겟 선택 팝업]시작일 달력
            $('#tg_from').datepicker({
                onSelect: function (selected) {
                    $("#tg_to").datepicker("option", "minDate", selected)
                }
            });
            //[타겟 선택 팝업]종료일 달력
            $('#tg_to').datepicker({
                onSelect: function (selected) {
                    $("#tg_from").datepicker("option", "maxDate", selected)
                }
            });
        }

        if(searchItem != 'reg_dt' && searchItem != 'upd_dt' && searchItem != 'use_yn'){
            $('#searchValue').show();
            $('#typeArea').children().remove();
        }

        // color css 처리
        let searchBox = $('.searchSelect');
        for(let i=0; i<searchBox.length; i ++) {
            if(searchBox.eq(i).attr('data') != null && searchBox.eq(i).attr('data') != ""){
                searchBox.eq(i).css('color','#222222');
            }
        }
    }

    // form 태그 관련 검색 ,페이지 값 랜딩 하기
    init();

</script>