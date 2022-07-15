<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<%@ taglib prefix="ui" uri="tld/Page.tld" %>
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil"%>

<!-- container 영역 시작 -->
<section class="container">
    <!-- 컨텐츠 영역 시작 -->
    <div class="contents">
        <div class="row tooltip_area bottom-border cf">
            <form id="searchForm" name="searchForm">
                <div class="left">
                    <!-- location 영역 -->
                    <ul class="location">
                        <li>홈</li>
                        <li>회원관리</li>
                        <li>업로드 회원</li>
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
                    <%--                                    나오론이 52.4억(57.2%)으로 가장 많은 비중을--%>
                    <%--                                    차지합니다.</span>--%>
                    <%--                        스타일론 직장인이 26.69억(29.1%), <br/>--%>
                    <%--                        스타일론 자영업자가 4.1억(4.47%)입니다.<br/>--%>
                    <%--                    </div>--%>
                    <!-- tooltip box 영역 끝 -->
                </div>
                <div class="right">
                    <!-- select 영역 시작 -->
                    <div class="select style1 left-border" id="searchItems">
                        <!-- selected value -->
                        <div class="value searchSelect" data="${searchType}">
                            <c:choose>
                                <c:when test="${searchType == 'grp_nm'}">그룹명</c:when>
                                <c:when test="${searchType == 'use_yn'}">사용여부</c:when>
                                <%--<c:when test="${searchType == 'grp_cnt'}">타겟수</c:when>--%>
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
                            <%--<li data="grp_cnt">타겟 수</li>--%>
                            <li data="use_yn">사용 여부</li>
                            <li data="reg_dt">생성일</li>
                            <li data="upd_dt">수정일</li>
                        </ul>
                    </div>
                    <div class="left" id="typeArea"></div>
                    <!-- 검색 및 페이지에 필요한 hidden 값 전송 -->
                    <input type="hidden" id="page_num" name="pageNo" value="${pageNo}"/>
                    <input type="hidden" name="searchType" id="searchType" value="${searchType}"/>
                    <input type="text" class="searchInp left-border" name="searchValue" id="searchValue"
                           value="${searchValue}"/>
                    <input type="submit" class="searchBtn" value="검색" onclick="return searchGrpList();"/>
                </div>
             </div>
            <!-- row 영역 끝 -->
            <!-- row 영역 시작 -->
            <div class="row bottom-border cf">
                <div class="left">
                    <input type="button" class="btn_basic group left right-border" value="그룹 추가"
                           onclick="groupPopup();"/>
                    <a href="javascript:void(0)" ; onclick="formFileDown()" class="btn_basic formFile left right-border"
                       download>양식파일</a>
                    <input type="button" class="btn_basic checkDelete left right-border" value="선택삭제"
                           onclick="deletePopup();"/>
                    <input type="button" class="btn_basic delete left right-border" value="전체삭제"
                           onclick="allDeletePopup();"/>
                    <a href="#" class="btn_basic rejection left right-border"></a>
                    <div class="info_txt left"><%--※ 내려받기 시, 검색된 리스트가 다운로드됩니다.--%></div>
                </div>
            </div>
            <span id="campMbrListBody">
                <div class="count border-bottom cf">
                    <div class="total left">그룹 리스트</div>
                </div>
                <c:choose>
                    <c:when test="${not empty list}">
                        <table class="table rejection_tbl">
                            <colgroup>
                                <col width="36"/>
                                <col width="*"/>
                                <col width="12%"/>
                                <col width="16%"/>
                                <col width="16%"/>
                                <col width="12%"/>
                                <col width="12%"/>
                            </colgroup>
                            <thead>
                            <tr>
                                <th><label class="custom_check1 all"><input type="checkbox" name="checkAll"
                                                                            id="checkAll"/><span></span></label>
                                </th>
                                <th>그룹명</th>
                                <th>타겟 수</th>
                                <th>생성일</th>
                                <th>수정일</th>
                                <th>사용여부</th>
                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="group" items="${list}">
                                <tr>
                                    <td><label class="custom_check1"><input type="checkbox" name="noArr" id="noArr"
                                                                            value="${group.seq}"/><span></span></label></td>
                                    <td>${group.grp_nm}</td>
                                    <td class="en_font"><fmt:formatNumber value="${group.grp_cnt}" pattern="#,###"/></td>
                                    <td class="en_font">
                                        <c:if test="${!cutil:isEmptyObject(group.reg_dt)}">
                                            ${cutil:stringDateHourParse(group.reg_dt)}
                                        </c:if>
                                    </td>
                                    <td class="en_font">
                                            <c:if test="${!cutil:isEmptyObject(group.upd_dt)}">
                                                ${cutil:stringDateHourParse(group.upd_dt)}
                                            </c:if>
                                    </td>
                                    <td><input type="button" class="use_state en_font btn_state"
                                            <c:if test="${group.use_yn eq 'Y'}"> value='Y'</c:if>
                                            <c:if test="${group.use_yn eq 'N'}"> value='N'</c:if>
                                               onclick="updateGrpYorN('${group.seq}','${group.use_yn}','${group.grp_nm}')"
                                    />
                                    </td>
                                    <td><a href="/mbr/campmbrDetail/${group.seq}.mi" class="btn_sm_line">수정</a></td>
                                </tr>
                            </c:forEach>
                                    </tbody>
                                </table>
                        <div class="btn_row bottom-border">
                            <ul class="pager">
                                <ui:pagination paginationInfo="${page}" type="image" jsFunction="linkPage"/>
                            </ul>
                        </div>
                        <%--<input type="hidden" id="nowPageNo" name="nowPageNo" value="${pageNo}"/>
                        <input type="hidden" id="totCnt" name="totCnt" value="${listCnt}"/>--%>
                        <input type="hidden" id="totCnt" name="totCnt" value="${listCnt}"/>
                    </c:when>
                    <c:otherwise>
                        <table class="table rejection_tbl">
                            <colgroup>
                                <col width="36"/>
                                <col width="*"/>
                                <col width="12%"/>
                                <col width="16%"/>
                                <col width="16%"/>
                                <col width="12%"/>
                                <col width="12%"/>
                            </colgroup>
                            <thead>
                            <tr>
                                <th><label class="custom_check1 all"><input type="checkbox"/><span></span></label></th>
                                <th>그룹명</th>
                                <th>타겟 수</th>
                                <th>생성일</th>
                                <th>수정일</th>
                                <th>사용여부</th>
                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody>
                            <!-- 검색 결과가 없는 경우 영역 시작 -->
                            <tr class="no_data">
                                <td colspan="7">입력된 정보가 없습니다.</td>
                            </tr>
                            <!-- 검색 결과가 없는 경우 영역 시작 -->
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
                </form>
            </span>
        <!-- ajax campmbr list -->
    </div>
    <!-- footer 영역 시작 -->
    <footer class="footer">
        &copy; Milvus Corp.
    </footer>
    <!-- footer 영역 끝 -->
</section>
<!-- 영역 끝 -->
</div>
<!-- wrap end -->
<!-- 그룹추가 팝업 영역 시작 -->
<div class="layer_pop groupPopup">
    <div class="pop_container popup_size5">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
        <div class="pop_title">그룹 추가</div>
        <form id="groupForm" name="groupForm" method="post" enctype="multipart/form-data">
            <div class="pop_inner">
                <div class="pop_section">
                    <table class="pop_table_type1">
                        <colgroup>
                            <col width="103"/>
                            <col width="*"/>
                        </colgroup>
                        <tbody>
                        <tr>
                            <th>그룹명</th>
                            <td>
                                <input type="text" placeholder="그룹명을 입력해주세요." name="grp_nm" class="input_type1"
                                       id="groupName"/>
                            </td>
                        </tr>
                        <tr>
                            <th>타겟 파일</th>
                            <td>
                                <input type="text" id="targetFile" class="input_file" placeholder="파일을 선택해주세요."
                                       readonly/>
                                <span class="btn_file">파일 선택<input type="file" id="excelFileData" name="excelFileData"
                                                                   class="target_btn file"/></span>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                    <div class="pop_error_txt blue_point_color" id="error"></div>
                    <div class="target_total">
                        <%--타겟 총 명수 <span id ="targetNum">0</span>--%>
                    </div>
                </div>
                <span id="excelImport">
                <h3 class="popup_title">리스트 미리보기</h3>
                <div class="scroll_tbl pop_margin_bttm">
                    <table class="pop_table_type3 dynamic_tbl varible_width">
                        <colgroup>
                            <col width="114"/>
                            <col width="92"/>
                            <col width="124"/>
                            <col width="167"/>
                            <col width="65"/>
                            <col width="65"/>
                            <col width="65"/>
                            <col width="65"/>
                            <col width="65"/>
                        </colgroup>
                        <thead>
                        <tr>
                            <th>회원번호</th>
                            <th>이름</th>
                            <th>모바일</th>
                            <th>이메일</th>
                            <th>ETC1</th>
                            <th>ETC2</th>
                            <th>ETC3</th>
                            <th>ETC4</th>
                            <th>ETC5</th>
                        </tr>
                        </thead>
                        <tbody>
                            <tr class="no_data">
                                <td colspan="9">입력된 정보가 없습니다.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                </span>
                <div class="btn_row">
                    <%--<input type="button" class="btn_bg btn_size2 btn_center" value="저장" onclick="groupSave();"/>--%>
                    <input type="button" class="btn_bg btn_size2 btn_center" value="저장" onclick="groupNameCheck();"/>
                </div>
            </div>
        </form>
    </div>
</div>
<!-- 그룹추가 팝업 영역 끝 -->

<!-- 삭제안내 팝업 영역 시작 -->
<div class="layer_pop deletePopup">
    <div class="pop_container popup_size3">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
        <div class="pop_title">삭제안내</div>
        <div class="pop_inner">
            <div class="alert_txt">
                <span id="title"></span>
                그룹 리스트 <span class="length"></span>
                개의 그룹을 삭제하시겠습니까?<br/>
                복원이 불가합니다.
            </div>
            <input type="password" placeholder="비밀번호입력" name="password" class="password_input border"
                   id="deletePassword"/>
            <div class="pop_error_txt blue_point_color" id="errorArea1"></div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_inline" id="deleteSave"
                       onclick="passwordReturn(document.getElementById('deletePassword').value);" value="확인">
                <input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소">
            </div>
        </div>
    </div>
</div>


<script>

    /*$(document).ready(function () {
        getCampMbrList(1);
    })*/

    // GET 방식 페이지 이동
    function linkPage(s) {
        $("#page_num").val(s);
        $("#searchForm").submit();
    }

    $(function () {
        // 전체 체크/해제 동작
        $(document).on('click', '.all input', function () {
            if ($(this).is(':checked') == true) {
                $('.custom_check1 input').not('.all input').prop('checked', true);
            } else {
                $('.custom_check1 input').not('.all input').prop('checked', false);
            }
        });

        $(document).on('click', '.table tbody .custom_check1 input', function () {
            let total = $('.custom_check1 input').not('.all input').length;
            let checkTotal = $('.custom_check1 input:checked').not('.all input').length;
            if (total == checkTotal) {
                $('.all input').prop('checked', true);
            } else {
                $('.all input').prop('checked', false);
            }
        });
        //end

        $('.file').on('click', function () {
            $("#excelFileData").val('');
        })

        $('.file').on('change', function () {
            let fileName = $(this).val();
            let format = fileName.slice(fileName.lastIndexOf('.') + 1).toLowerCase();

            if (!(format == 'xlsx' || format == 'csv')) {
                popup.popAlert("'xlsx', 'csv' 파일 형식만 업로드 가능 합니다.");
            } else {
                // 타겟 생성 후 엑셀 임시 리스트 그려주기
                $("#targetFile").val(fileName);

                popup.popAlert("100개 미만의 타겟 수 데이터만 유효성 검사를<br/>진행합니다.");

                const res = function (response) {
                    if (response.isExist === 1) {
                        $('#error').html('중복된 그룹명입니다');
                        return false;
                    }
                    if (response.result) {

                        let text = "";
                        let list = response.list;

                        text += '<h3 class="popup_title">리스트 미리보기</h3>'
                            + '<div class="scroll_tbl pop_margin_bttm">'
                            + '<table class="pop_table_type3 dynamic_tbl varible_width">'
                            + '<colgroup>'
                            + '<col width="114"/>'
                            + '<col width="92"/>'
                            + '<col width="124"/>'
                            + '<col width="167"/>'
                            + '<col width="65"/>'
                            + '<col width="65"/>'
                            + '<col width="65"/>'
                            + '<col width="65"/>'
                            + '<col width="65"/>'
                            + '</colgroup>'
                            + '<thead>'
                            + '<tr>'
                            + '<th>회원번호</th>'
                            + '<th>이름</th>'
                            + '<th>모바일</th>'
                            + '<th>이메일</th>'
                            + '<th>ETC1</th>'
                            + '<th>ETC2</th>'
                            + '<th>ETC3</th>'
                            + '<th>ETC4</th>'
                            + '<th>ETC5</th>'
                            + '</tr>'
                            + '</thead>'
                            + '<tbody>';

                        for (var i = 0; i < list.length; i++) {
                            let value = list[i];
                            text += "<tr>";

                            text += "<td class='en_font'>" + getData(value.usr_id) + "</td>"
                                + "<td>" + getData(value.usr_nm) + "</td>"
                                + "<td class ='en_font'>" + getData(value.usr_mob) + "</td>"
                                + "<td class ='en_font'>" + getData(value.usr_edm) + "</td>"
                                + "<td>" + getData(value.usr_etc1) + "</td>"
                                + "<td>" + getData(value.usr_etc2) + "</td>"
                                + "<td>" + getData(value.usr_etc3) + "</td>"
                                + "<td>" + getData(value.usr_etc4) + "</td>"
                                + "<td>" + getData(value.usr_etc5) + "</td>"

                            text += "</tr>";
                        }
                        text += '</tbody>'
                            + '</table>'
                            + '</div>'
                        $("#excelImport").html(text);


                        //$("#groupName").val('');
                        //$("#targetFile").val('');
                        //$("#excelFileData").val('');
                        //$("#targetNum").text(response.cnt)

                        return false;
                    } else {
                        popup.popAlert(response.message)

                        let text = "";
                        text += '<h3 class="popup_title">리스트 미리보기</h3>'
                            + '<div class="scroll_tbl pop_margin_bttm">'
                            + '<table class="pop_table_type3 dynamic_tbl varible_width">'
                            + '<colgroup>'
                            + '<col width="114"/>'
                            + '<col width="92"/>'
                            + '<col width="124"/>'
                            + '<col width="167"/>'
                            + '<col width="65"/>'
                            + '<col width="65"/>'
                            + '<col width="65"/>'
                            + '<col width="65"/>'
                            + '<col width="65"/>'
                            + '</colgroup>'
                            + '<thead>'
                            + '<tr>'
                            + '<th>회원번호</th>'
                            + '<th>이름</th>'
                            + '<th>모바일</th>'
                            + '<th>이메일</th>'
                            + '<th>ETC1</th>'
                            + '<th>ETC2</th>'
                            + '<th>ETC3</th>'
                            + '<th>ETC4</th>'
                            + '<th>ETC5</th>'
                            + '</tr>'
                            + '</thead>'
                            + '<tbody>'
                            + '<tr class="no_data">'
                            + '<td colspan ="9">' + "입력된 정보가 없습니다." + '</td>'
                            + '</tr>'
                            + '</tbody>';

                        $("#excelImport").html(text);
                        $("#targetFile").val('');
                        $("#excelFileData").val('');
                    }
                }
                let formData = new FormData();
                formData.append("grp_nm", $("#groupName").val());
                formData.append("excelFile", $("#excelFileData")[0].files[0]);
                com_ajax.ajax_file('${baseURL}/mbr/importExcelFile.ajax', formData, res, '${_csrf.headerName}', '${_csrf.token}');
            }
        });


        $('#searchItems ul li').on('click', function () {
            let searchItem = $(this).attr('data');

            if (searchItem == "grp_nm" || searchItem == "grp_cnt") {
                $("#searchValue").val('');
            }

            if (searchItem == "use_yn") {
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
            if (searchItem == 'reg_dt' || searchItem == 'upd_dt') {

                $('#searchValue').hide();

                if (searchItem == 'reg_dt') {
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

            if (searchItem != 'reg_dt' && searchItem != 'upd_dt' && searchItem != 'use_yn') {
                $('#searchValue').show();
                $('#typeArea').children().remove();
            }
        });


    });

    // 그룹 리스트 가져 오기
    function getCampMbrList(pageNo) {

        const res = function (response) {
            $("#campMbrListBody").html(response);
        }

        let param = $("#searchForm").serializeArray();
        param.push({name: 'pageNo', value: pageNo});

        com_ajax.ajax('post', '${baseURL}/mbr/grpList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 그룹 팝업 활성화
    function groupPopup() {
        $('.groupPopup').addClass('active');
    }

    // BackEnd 패스 워드 확인 처리 (password)
    function passwordReturn(password) {

        let param = {"password": password}

        if (password == '') {
            $('#errorArea1').html('비밀번호를 입력해주세요.');
        }

        const res = function (response) {
            if (response.status != null) {
                listDelete(response.status)
            }
        }
        com_ajax.ajax('post', '${baseURL}/mcr/check/pw.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    //삭제 동작
    function listDelete(check) {

        let isPwStatus = check;
        let status = $('#deleteSave').attr('data');

        if (isPwStatus === true) {
            if (status === "checkDel") {
                // 선택 삭제
                deleteCheck();
            } else {
                // 전체 삭제
                deleteAllGrp();
            }
            $('#errorArea1').html('');
            $('.password_input').val('');
            $('.deletePopup').removeClass('active');
        } else {
            $('#errorArea1').html('비밀번호를 확인해주세요.');
        }
    };

    // 페이지 네이션 적용
    /*function fn_page(page) {

        const res = function (response) {
            $("#campMbrListBody").html(response);
        }

        let param = $("#searchForm").serializeArray();
        param.push({name: 'pageNo', value: page});
        com_ajax.ajax('post', '${baseURL}/mbr/grpList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }*/

    // 검색 처리
    function searchGrpList() {

        let standard = $('.searchSelect').attr('data');
        let searchValue = $("#searchValue").val().trim();

        if (standard == 'use_yn') {
            let yn_data = $("#yn_select").attr('data');
            $("#searchValue").val(yn_data)
        } else if (standard == 'reg_dt') {
            let reg_dt = $("#searchDate").val();
            $("#searchValue").val(reg_dt)
        } else if (standard == 'upd_dt') {
            let upd_dt = $("#searchDate").val();
            $("#searchValue").val(upd_dt)
        }

        if (standard == '' && searchValue != '') {
            popup.searchAlert("기준을 선택해 주세요.");
            return false;
        }

        $("#searchType").val(standard); // 검색 Type 을 Form 으로 받을 수 없어 처리.
        $("#page_num").val(1); // 초기 검색 page : 1
        $("#searchForm").submit();
        //getCampMbrList(1);
    }

    // 팝업 닫기
    function popupClose(close) {
        $("#deletePassword").val('');
        $("#errorArea1").html('');
        $(close).parents('.layer_pop').removeClass('active');
    }

    // 데이터 가져오기
    function getData(value) {
        return (value == null ? "" : value)
    }

    //업로드 회원 양식 다운로드
    function formFileDown() {
        location.href = '${baseURL}/download/업로드회원등록양식2.xlsx';
        $('#commonLoading').removeClass('active');
    }

    let isCheckGrpNm = true

    // 그룹명 검사
    function groupNameCheck() {

        const res = function (response) {
            if (response.isExist >= 1) {
                $('#error').html('중복된 그룹명입니다');
                return false;
            } else {
                // 그룹 저장
                groupSave()
            }
        }

        let data = [];
        data.push({name: "grp_nm", value: $("#groupName").val()});
        com_ajax.ajax('post', '${baseURL}/mbr/isExistGrpNm.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }


    // 그룹 추가 groupSave()
    function groupSave() {

        if ($('#groupName').val() == '') {
            $('#error').html('그룹명을 입력해주세요.');
            return false;
        }
        if ($('.file').val() == '') {
            $('#error').html('타겟 파일을 선택해주세요.');
            return false;
        }

        const res = function (response) {

            $('.groupPopup').removeClass('active');
            popup.popAlert(response.message);

            var nowPage = $("#nowPageNo").val();

            if (typeof nowPage == 'undefined') {
                nowPage = 1
            }
            getCampMbrList(nowPage);

            $("#groupName").val('');
            $("#targetFile").val('');
            $("#targetNum").text(0);

            // 엑셀 리스트 초기화 후 다시 그려주기
            let text = "";
            text += '<h3 class="popup_title">리스트 미리보기</h3>'
                + '<div class="scroll_wrap">'
                + '<table class="pop_table_type3 pop_margin_bttm">'
                + '<colgroup>'
                + '<col width="114"/>'
                + '<col width="92"/>'
                + '<col width="124"/>'
                + '<col width="167"/>'
                + '<col width="65"/>'
                + '<col width="65"/>'
                + '<col width="65"/>'
                + '<col width="65"/>'
                + '<col width="65"/>'
                + '</colgroup>'
                + '<thead>'
                + '<tr>'
                + '<th>회원번호</th>'
                + '<th>이름</th>'
                + '<th>모바일</th>'
                + '<th>이메일</th>'
                + '<th>ETC1</th>'
                + '<th>ETC2</th>'
                + '<th>ETC3</th>'
                + '<th>ETC4</th>'
                + '<th>ETC5</th>'
                + '</tr>'
                + '</thead>'
                + '<tbody>'
                + '<tr class="no_data">'
                + '<td colspan ="9">' + "입력된 정보가 없습니다." + '</td>'
                + '</tr>'
                + '</tbody>';

            $("#excelImport").html(text);
            $("#groupName").val('');
            $("#targetFile").val('');
            $("#excelFileData").val('');
        }

        // grp_nm 값과 fileData 값을 같이 넘겨주기 위해 formData 사용
        let formData = new FormData();
        formData.append("grp_nm", $("#groupName").val());
        if ($("#excelFileData")[0].files[0] != null) {    // 임시 파일 넘기기용
            formData.append("excelFileData", $("#excelFileData")[0].files[0]);
        }
        com_ajax.ajax_file('${baseURL}/mbr/grpInsert.ajax', formData, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 그룹 Y,N 상태 변경
    function updateGrpYorN(seq, use_yn, grp_nm) {

        const res = function (response) {
            if (response.status === "success") {
                let nowPage = $("#nowPageNo").val();
                getCampMbrList(nowPage);
            }
        }
        let param = {seq: seq, use_yn: use_yn}
        com_ajax.ajax('post', '${baseURL}/mbr/updGrpState.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 체크 삭제 기능
    function deleteCheck() {

        let checkNoList = [];

        $("input[name='noArr']:checked").each(function () {
            checkNoList.push($(this).val());
        })

        const res = function (response) {
            let nowPage = $("#nowPageNo").val();
            getCampMbrList(nowPage)
        }

        let param = {checkNoList: checkNoList}
        com_ajax.ajax('post', '${baseURL}/mbr/delGrpList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');

    }

    // 그룹 전체 삭제
    function deleteAllGrp() {

        const res = function (response) {
            if (response.status === "success") {
                popup.popAlert("그룹 리스트가 전부 삭제되었습니다.");
                getCampMbrList(1);
            }
        }

        let param = $("#searchForm").serializeArray();
        com_ajax.ajax('post', '${baseURL}/mbr/delGrpListAll.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 삭제 팝업
    function deletePopup() {

        let checkLength = $('.rejection_tbl .custom_check1').not('.all').find('input:checked').length;

        $('#title').text("선택된");
        $('.length').text(checkLength); // 체크된 게시글 카운트 구하기

        if (checkLength === 0) {
            popup.popAlert('삭제할 그룹을 선택해주세요.');
            return false;
        }

        $('.deletePopup').addClass('active');
        $('#deleteSave').attr('data', 'checkDel');
    }

    function allDeletePopup() {

        $('#title').text("전체");
        $('.length').text($('#totCnt').val());

        $('.deletePopup').addClass('active');
        //$('#deleteSaveAll').attr('data', 'all');
        $('#deleteSave').attr('data', 'all');
    }

    // 검색에 필요한 초기 검색 값 , 검색 타입 랜딩 하기
    function init(){

        let searchItem = '${searchType}'
        let searchValue = '${searchValue}'

        console.log("searchItem : "  + searchItem);
        console.log("searchValue : "  + searchValue);

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
