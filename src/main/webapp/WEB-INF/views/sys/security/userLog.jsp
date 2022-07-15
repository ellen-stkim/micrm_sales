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
        <div class="row tooltip_area bottom-border cf">
            <div class="left">
                <!-- location 영역 -->
                <ul class="location">
                    <li>홈</li>
                    <li>시스템관리</li>
                    <li>보안</li>
                </ul>
                <!-- tooltip 버튼 영역  -->
                <div class="tooltip_icon">
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
                </div>
                <!-- tooltip box 영역 끝 -->
            </div>
            <form:form id="searchLogList" method="post"  onsubmit="return false">
                <div class="right">
                    <!-- select 영역 시작 -->
                    <div class="select style1 left-border">
                        <!-- selected value -->
                        <div class="value searchSelect" data="">기준선택</div>
                        <!-- option -->
                        <ul class="option">
                            <li data="usr_ip">IP</li>
                            <li data="usr_nm">사용자</li>
                            <li data="work_detail">로그</li>
                        </ul>
                    </div>
                    <!-- select 영역 끝 -->
                    <input type="text" class="searchInp left-border searchWord" id="searchWord" placeholder="검색어입력" onkeyup="enterSubmit();" />
                    <input type="button" class="searchBtn" value="검색" onclick="return searchUserLog();" />
                    <input type="hidden" id="searchType" value=""/>
                    <input type="hidden" id="searchValue" value=""/>
                </div>
            </form:form>
        </div>
        <!-- row 영역 끝 -->
        <div class="tab_row">
            <!-- Tab menu -->
            <sec:authorize access="hasRole('R10')">
                    <div><a href="/sys/security/adminIpBlockSecurity.mi">IP 차단</a></div>
                    <div><a href="/sys/security/adminIpSecurity.mi">IP 차단 해제 요청</a></div>
                  <%--  <div><a href="/sys/security/adminPermitSecurity.mi">IP 허용</a></div>--%>
                    <div class="on"><a href="/sys/security/adminUserLog.mi">사용자 로그</a></div>
            </sec:authorize>
            <sec:authorize access="hasAnyRole('R1','R2')">
                    <div><a href="/sys/security/ipSecurity.mi">IP 차단</a></div>
                    <div class="on"><a href="/sys/security/userLog.mi">사용자 로그</a></div>
            </sec:authorize>
            <div class="range_calendar">
                <input type="text" class="date" id="from" placeholder="시작날짜" />
                <input type="text" class="date" id="to" placeholder="종료날짜" />
            </div>
        </div>
        <!-- section 영역 시작 -->
        <span id="listHtml">
            <div class="section">
                <!-- 검색 결과 영역 시작 -->
                <div class="count border-bottom cf">
                    <span class="switch_label">일반 로그</span>
                    <label class="btn_switch">
                        <input type="checkbox" name="" onchange="" />
                        <span></span>
                    </label>
                    <span class="switch_label">개인정보 로그</span>
                </div>
                <!-- 검색 결과 영역 끝 -->
                <!-- table 영역 시작 -->
                <c:choose>
                    <c:when test="${not empty list}">
                        <table class="table">
                            <colgroup>
                                <col width="20%" />
                                <col width="20%" />
                                <col width="20%" />
                                <col width="40%" />
                            </colgroup>
                            <thead>
                            <tr>
                                <th>시간</th>
                                <th>IP</th>
                                <th>사용자</th>
                                <th>로그</th>
                            </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="n" items="${list}" varStatus="status">
                                    <tr>
                                        <td class="en_font"><c:if test="${!cutil:isEmptyObject(n.reg_dt)}"> ${cutil:stringDateParse(n.reg_dt)}</c:if></td>
                                        <td class="en_font">${n.usr_ip}</td>
                                        <td class="en_font">${n.usr_nm}</td>
                                        <td>${n.work_url} : ${n.work_detail}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        <div class="btn_row bottom-border">
                            <ul class="pager">
                                <ui:pagination paginationInfo="${page}" type="image" jsFunction="getUserLog"/>
                            </ul>
                        </div>
                    <!-- table 영역 끝 -->
                    </c:when>
                    <c:otherwise>
                        <table class="table">
                            <colgroup>
                                <col width="20%" />
                                <col width="20%" />
                                <col width="20%" />
                                <col width="40%" />
                            </colgroup>
                            <thead>
                            <tr>
                                <th>시간</th>
                                <th>IP</th>
                                <th>사용자</th>
                                <th>로그</th>
                            </tr>
                            </thead>
                            <tbody>
                                <tr class="no_data">
                                    <td colspan="4">조회된 결과가 없습니다.</td>
                                </tr>
                            </tbody>
                        </table>
                        <div class="btn_row bottom-border">
                            <ul class="pager">
                            </ul>
                        </div>
                    </c:otherwise>
                </c:choose>
                </div>
            <!-- section 영역 끝 -->
        </span>
    </div>
    <!-- 컨텐츠 영역 끝 -->
    <!-- footer 영역 시작 -->
    <footer class="footer">
        &copy; Milvus Corp.
    </footer>
    <!-- footer 영역 끝 -->
</section>
<!-- container 영역 끝 -->
<script>
    // 검색영역 enter key event
    function enterSubmit() {
        if (window.event.keyCode == 13) {
            searchUserLog();
        }
        return false;
    }

    $(document).ready(function () {
        // datepicker option
        $.datepicker.setDefaults({
            dateFormat: 'yy-mm-dd'
            , monthNames: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
            , showMonthAfterYear: true
            , yearSuffix: "."
        });

        $('#from').datepicker({
            onSelect: function (selected) {
                $('#to').datepicker("option", "minDate", selected);
            }
        });

        $('#to').datepicker({
            onSelect: function (selected) {
                $('#from').datepicker("option", "maxDate", selected);
            }
        });
    });

    function searchUserLog() {
        let standard = $('.searchSelect').attr('data');
        var searchWord =  $('#searchWord').val();
        var param = $("#searchLogList").serializeArray();
        param.push({name: standard, value: searchWord});
        if (standard == '') {
            popup.searchAlert("기준을 선택해 주세요.");
            return false;
        }
        $('#searchType').val(standard);
        $('#searchValue').val(searchWord);
        getUserLog('1');
    }
    function getUserLog(page) {
        var searchType =  $('#searchType').val();
        var searchValue =  $('#searchValue').val();
        var param = $("#searchLogList").serializeArray();
        param.push({name: searchType, value: searchValue});
        param.push({name: 'pageNo', value: page});
        var res = function (response) {
            $('#listHtml').html(response);
        };
        com_ajax.ajax('post', '${baseURL}/sys/security/getUserLog.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }
</script>