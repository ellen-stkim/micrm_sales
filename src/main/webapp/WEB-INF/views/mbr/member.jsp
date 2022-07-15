<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<%@ taglib uri="/WEB-INF/tlds/Page.tld" prefix="ui" %>
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil"%>

<!-- container 영역 시작 -->
<section class="container">
    <!-- 컨텐츠 영역 시작 -->
    <div class="contents">
        <!-- row 영역 시작 -->
        <form id="tmlmiTbilistForm" name="tmlmiTbilistForm" onsubmit="return false">
            <div class="row tooltip_area bottom-border cf">
                <div class="left">
                    <!-- location 영역 -->
                    <ul class="location">
                        <li>홈</li>
                        <li>회원관리</li>
                        <li>DB회원</li>
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
<%--                                    나오론이 52.4억(57.2%)으로 가장 많은 비중을--%>
<%--                                    차지합니다.</span>--%>
<%--                        스타일론 직장인이 26.69억(29.1%), <br/>--%>
<%--                        스타일론 자영업자가 4.1억(4.47%)입니다.<br/>--%>
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
                            <c:forEach var="item" items="${columnNm}" varStatus="i">
                                <li data="${columnValue[i.count]}">${item}</li>
                            </c:forEach>
                        </ul>
                    </div>
                    <!-- select 영역 끝 -->
                    <input type="hidden" name="tbl_id" id="tbl_id" value="${tbl_id}"/>
                    <input type="hidden" name="searchType" id="searchType"/>
                    <input type="text" id="searchValue" name="searchValue" class="searchInp left-border searchWord" placeholder="검색어입력"
                           onkeyup="enterSubmit();"/>
                    <input type="hidden" id="columnNm" name ="columnNm" value="${columnNm}"/>
                    <input type="hidden" id="columnValue" name ="columnValue" value="${columnValue}"/>
                    <input type="button" class="searchBtn" value="검색" onclick="getTblmitblSearch('${pageNo}');"/>
                </div>
            </div>
        </form>
        <!-- row 영역 끝 -->
        <!-- row 영역 시작 -->
        <div class="row bottom-border cf">
            <div class="left">
                <input type="button" class="btn_basic down left right-border" value="내려받기"
                       onclick="downloadTblmiList();"/>
                <div class="info_txt left">※ 내려받기 시, 검색된 리스트가 다운로드됩니다.</div>
            </div>
        </div>
        <!-- row 영역 끝 -->
            <!-- section 영역 시작 -->
            <div class="section">
                <!-- 검색 결과 영역 시작 -->
                <div class="count border-bottom cf" id="memberMstAppend">
                    <div class="total left">전체 DB회원
                        <c:choose>
                            <c:when test="${!cutil:isEmptyObject(tblSum.total_cnt)}">
                                <span><fmt:formatNumber value="${tblSum.total_cnt}" pattern="#,###" /></span>
                            </c:when>
                            <c:otherwise><span>0</span></c:otherwise>
                        </c:choose>
                    </div>
                    <ol class="cf left">
                        <li>이메일
                            <c:choose>
                                <c:when test="${!cutil:isEmptyObject(tblSum.edm_agree_cnt)}">
                                    <span class="en_font"><fmt:formatNumber value="${tblSum.edm_agree_cnt}" pattern="#,###" /></span>
                                </c:when>
                                <c:otherwise><span class="en_font">0</span></c:otherwise>
                            </c:choose>
                        </li>
                        <li>문자&nbsp;
                            <c:choose>
                                <c:when test="${!cutil:isEmptyObject(tblSum.mdm_agree_cnt)}">
                                    <span class="en_font"><fmt:formatNumber value="${tblSum.mdm_agree_cnt}" pattern="#,###" /></span>
                                </c:when>
                                <c:otherwise><span class="en_font">0</span></c:otherwise>
                            </c:choose>
                        </li>
                    </ol>
                </div>
                <!-- 검색 결과 영역 끝 -->
                <div class="scroll_tbl">
                    <!-- table 영역 시작 -->
                    <table class="table member dynamic_tbl list">
                        <thead>
                        <tr>
                            <c:forEach var="item" items="${columnNm}">
                                <th>${item}</th>
                            </c:forEach>
                        </tr>
                        </thead>
                        <%--<span id="memberListAppend"></span>--%>
                        <!-- section 영역 시작 -->
                        <tbody id="body">
                        <c:choose>
                            <c:when test="${not empty list}">
                                <c:forEach var="item" items="${list}">
                                    <tr>
                                        <td>${item.usr_id}</td>
                                        <td>${item.usr_nm}</td>
                                        <td class="en_font">${item.usr_mob}</td>
                                        <td class="en_font">${item.usr_myn}</td>
                                        <td class="en_font">${item.usr_edm}</td>
                                        <td class="en_font">${item.usr_eyn}</td>
                                        <td>${item.usr_gdr}</td>
                                        <td>${item.usr_addr}</td>
                                        <td>${item.usr_etc1}</td>
                                        <td>${item.usr_etc2}</td>
                                        <td>${item.usr_etc3}</td>
                                        <td>${item.usr_etc4}</td>
                                        <td>${item.usr_etc5}</td>
                                        <td>${item.usr_etc6}</td>
                                        <td>${item.usr_etc7}</td>
                                        <td>${item.usr_etc8}</td>
                                        <td>${item.usr_etc9}</td>
                                        <td>${item.usr_etc10}</td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <!-- 검색 결과가 없는 경우 영역 시작 -->
                                <tr class="no_data">
                                <td colspan="100%">조회된 결과가 없습니다.</td>
                                </tr>
                                <!-- 검색 결과가 없는 경우 영역 시작 -->
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
                <div class="btn_row bottom-border" id="pagingBody">
                    <c:if test="${not empty list}">
                        <ul class="pager">
                            <ui:pagination paginationInfo="${page}" type="image" jsFunction="getTblmiList"/>
                        </ul>
                    </c:if>
                    <form:form id="downloadForm" name="downloadForm" action="/mbr/downloadTblmiList.mi" method="post">
                        <input type="hidden" id="resultSearchType" name="searchType" value="${searchType}"/>
                        <input type="hidden" id="resultSearchValue" name="searchValue" value="${searchValue}"/>
                        <input type="hidden" name="columnNm"/>
                        <input type="hidden" name="tbl_id"/>
                    </form:form>
                </div>
                <!-- table 영역 끝 -->
            </div>
            <!-- section 영역 끝 -->
        <!-- footer 영역 시작 -->
        <footer class="footer">
            &copy; Milvus Corp.
        </footer>
        <!-- footer 영역 끝 -->
</section>
<!-- container 영역 끝 -->
</div>
<!-- wrap end -->

<script>
    $('#commonLoading').removeClass('active');
    var columnNm = [];
    columnNm = $("#columnNm").val();
    var columnValue = [];
    var tbl_id = $("#tbl_id").val();
    $(function () {
        // 전체 체크/해제 동작
        $('.all input').click(function () {
            if ($(this).is(':checked') == true) {
                $('.custom_check1 input').not('.all input').prop('checked', true);
            } else {
                $('.custom_check1 input').not('.all input').prop('checked', false);
            }
        });

        $('.table tbody .custom_check1 input').click(function () {
            let total = $('.custom_check1 input').not('.all input').length;
            let checkTotal = $('.custom_check1 input:checked').not('.all input').length;
            if (total == checkTotal) {
                $('.all input').prop('checked', true);
            } else {
                $('.all input').prop('checked', false);
            }
        });
        //end
    });

    // 검색영역 enter key event
    function enterSubmit() {
        if (window.event.keyCode == 13) {
            getTblmitblSearch();
        }
        return false;
    }

    //검색 기준확인 function
    function getTblmitblSearch() {
        let standard = $('.searchSelect').attr('data');
        let searchValue = $('#searchValue').val().trim();

        if (standard == '' && searchValue != '') {
            popup.searchAlert("기준을 선택해 주세요.");
            return false;
        } else {
            $('#searchType').val(standard);
            getTblmiList('1')
        }
    }


    function getTblmiList(page) {
        var res = function (response) {
            var $doc = new DOMParser().parseFromString(response, "text/html");
            $("#body").html($("#body", $doc).html());
            $("#memberMstAppend").html($("#memberMstAppend", $doc).html());
            $("#pagingBody").html($("#pagingBody", $doc).html());
        };
        var param = $("#tmlmiTbilistForm").serializeArray();
        param.push({name: 'pageNo', value: page});
        com_ajax.ajax('post', '${baseURL}/mbr/getTblmitblSearch.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    //검색된 페이지 다운로드
    function downloadTblmiList() {
        var popupX = (document.body.offsetWidth / 2) - (200 / 2);
        var popupY= (window.screen.height / 2) - (300 / 2);
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
        $("input[name=columnNm]").val(columnNm);
        $("input[name=tbl_id]").val(tbl_id);
        $("#downloadForm").attr("target", "popup_down");
        $("#downloadForm").submit();
    }
</script>
