<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<c:set var="url">${pageContext.request.requestURL}</c:set>
<c:set var="baseURL" value="${fn:replace(url, pageContext.request.requestURI, pageContext.request.contextPath)}"/>

<%--<section id="tabSection">
    <div class="mainTabContents">
        <ul class="mainTab">
            <li id="mainReportTab" class="tab">
                <a href="${baseURL }/m04/campReportLst.mi" class="tab-button">리포트</a>
            </li>
            <li id="campReportTab" class="tab now">
                <a href="${baseURL }/m04/campResultLst.mi" class="tab-button">캠페인</a>
            </li>
        </ul>
        <div class="contents">
            <div class="reportDet bpadd">
                <div class="tom-btn-grp-left">
                    <a href="${baseURL }/m04/campResultLst.mi" class="report-common prev">캠페인 리스트</a>
                </div>
                <h2>${base_info.program_nm }</h2><!-- 캠페인 제목 -->

                <!-- 개별 캠페인 정보 요약  -->
                <div class="campReportTableCover">
                    <table class="reportSummaryTable">
                        <tbody>
                        <tr>
                            <th>캠페인 기간</th>
                            <td>${base_info.start_dt }</td>
                            <th>캠페인 타겟</th>
                            <td>
                                <fmt:formatNumber value="${base_info.total_tg }" pattern="#,##0"></fmt:formatNumber>명
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${base_info.camp_status == '0' }">
                                        <span class="reportStatus before">대기중</span>
                                    </c:when>
                                    <c:when test="${base_info.camp_status == '1' }">
                                        <span class="reportStatus going">진행중</span>
                                    </c:when>
                                    <c:when test="${base_info.camp_status == '2' }">
                                        <span class="reportStatus finish">종료</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="reportStatus">오류</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>

                <!-- 성과 요약 -->
                <h3>성과 요약</h3>
                <div class="campaign-report-list">
                    <table class="auto-sorting-table max100">
                        <thead>
                        <tr>
                            <th>보기</th>
                            <th>캠페인명</th>
                            <th>기간</th>
                            <th>발송타겟수</th>
                            <th>도달</th>
                            <th>오픈</th>
                            <th>클릭</th>
                            <th>구매</th>
                            <th>매출</th>
                            <th>ROI%</th>
                        </tr>
                        </thead>
                        <tbody id="">
                        <!-- 캠페인의 프로젝트 전체 성과 시작 ----------------------->
                        <tr>
                            <th colspan="2">${base_info.program_nm }</th>
                            <th>${base_info.start_dt }</th>
                            <th>
                                <fmt:formatNumber value="${base_info.total_tg }" pattern="#,##0"></fmt:formatNumber>
                                <br/>(<c:choose><c:when
                                    test="${base_info.total_tg eq '' }">0.0%</c:when><c:otherwise><fmt:formatNumber
                                    value="${base_info.total_tg / base_info.total_tg }"
                                    pattern="#,##0%"></fmt:formatNumber></c:otherwise></c:choose>)
                            </th>
                            <th>
                                <fmt:formatNumber value="${base_info.suc_cnt }" pattern="#,##0"></fmt:formatNumber>
                                <br/>(<c:choose><c:when
                                    test="${base_info.total_tg eq '' }">0.0%</c:when><c:otherwise><fmt:formatNumber
                                    value="${base_info.suc_cnt / base_info.total_tg }"
                                    pattern="#,##0%"></fmt:formatNumber></c:otherwise></c:choose>)
                            </th>
                            <th>
                                <fmt:formatNumber value="${base_info.open_cnt }" pattern="#,##0"></fmt:formatNumber>
                                <br/>(<c:choose><c:when
                                    test="${base_info.total_tg eq '' }">0.0%</c:when><c:otherwise><fmt:formatNumber
                                    value="${base_info.open_cnt / base_info.total_tg }"
                                    pattern="#,##0%"></fmt:formatNumber></c:otherwise></c:choose>)
                            </th>
                            <th>
                                <fmt:formatNumber value="${base_info.click_cnt }" pattern="#,##0"></fmt:formatNumber>
                                <br/>(<c:choose><c:when
                                    test="${base_info.total_tg eq '' }">0.0%</c:when><c:otherwise><fmt:formatNumber
                                    value="${base_info.click_cnt / base_info.total_tg }"
                                    pattern="#,##0%"></fmt:formatNumber></c:otherwise></c:choose>)
                            </th>
                            <th>
                                <fmt:formatNumber value="${base_info.sale_cnt }" pattern="#,##0"></fmt:formatNumber>
                                <br/>(<c:choose><c:when
                                    test="${base_info.total_tg eq '' }">0.0%</c:when><c:otherwise><fmt:formatNumber
                                    value="${base_info.sale_cnt / base_info.total_tg }"
                                    pattern="#,##0%"></fmt:formatNumber></c:otherwise></c:choose>)
                            </th>
                            <th><fmt:formatNumber value="${base_info.sale_amt }"
                                                  pattern="\\#,##0"></fmt:formatNumber></th>
                            <th>
                                <fmt:formatNumber value="${base_info.roi }" pattern="#,##0%"></fmt:formatNumber>
                            </th>
                        </tr>
                        <!-- 캠페인의 프로젝트 전체 성과 끝 ----------------------->
                        <!-- 캠페인의 프로젝트에 포함되어 있는 하위 발송 리스트 성과 Foreach -->
                        <c:forEach var="g" items="${camp_result }">
                            <tr>
                                <td>
                                    <c:forEach var="i" items="${contents_result }">
                                        <c:if test="${i.camp_id == g.camp_id }">
                                            <input type="button" class="reportMoveIconBtn det"
                                                   onclick="campContentsPreview('${i.program_id}', '${i.camp_id }', '${i.contents_seq }', '${i.ch_type }')">
                                            <input type="button" class="reportMoveIconBtn chart"
                                                   onclick="campContentsDataCall('${i.program_id}', '${i.camp_id }', '${i.contents_seq}')"/>
                                        </c:if>
                                    </c:forEach>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${g.camp_ch == 'EM' }">
                                            <span class="send-title em">${g.camp_name }</span>
                                        </c:when>
                                        <c:when test="${g.camp_ch == 'MM' }">
                                            <span class="send-title mm">${g.camp_name }</span>
                                        </c:when>
                                        <c:when test="${g.camp_ch == 'KK' }">
                                            <span class="send-title kk">${g.camp_name }</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="send-title em">${g.camp_name }</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${g.start_dt }</td>
                                <td>
                                    <fmt:formatNumber value="${g.total_tg }" pattern="#,##0"></fmt:formatNumber>
                                    <br/>(<c:choose><c:when
                                        test="${g.total_tg eq '' }">0.0%</c:when><c:otherwise><fmt:formatNumber
                                        value="${g.total_tg / g.total_tg }"
                                        pattern="#,##0%"></fmt:formatNumber></c:otherwise></c:choose>)
                                </td>
                                <td>
                                    <fmt:formatNumber value="${g.suc_cnt }" pattern="#,##0"></fmt:formatNumber>
                                    <br/>(<c:choose><c:when
                                        test="${g.total_tg eq '' }">0.0%</c:when><c:otherwise><fmt:formatNumber
                                        value="${g.suc_cnt / g.total_tg }"
                                        pattern="#,##0%"></fmt:formatNumber></c:otherwise></c:choose>)
                                </td>
                                <td>
                                    <fmt:formatNumber value="${g.open_cnt }" pattern="#,##0"></fmt:formatNumber>
                                    <br/>(<c:choose><c:when
                                        test="${g.total_tg eq '' }">0.0%</c:when><c:otherwise><fmt:formatNumber
                                        value="${g.open_cnt / g.total_tg }"
                                        pattern="#,##0%"></fmt:formatNumber></c:otherwise></c:choose>)
                                </td>
                                <td>
                                    <fmt:formatNumber value="${g.click_cnt }" pattern="#,##0"></fmt:formatNumber>
                                    <br/>(<c:choose><c:when
                                        test="${g.total_tg eq '' }">0.0%</c:when><c:otherwise><fmt:formatNumber
                                        value="${g.click_cnt / g.total_tg }"
                                        pattern="#,##0%"></fmt:formatNumber></c:otherwise></c:choose>)
                                </td>
                                <td>
                                    <fmt:formatNumber value="${g.sale_cnt }" pattern="#,##0"></fmt:formatNumber>
                                    <br/>(<c:choose><c:when
                                        test="${g.total_tg eq '' }">0.0%</c:when><c:otherwise><fmt:formatNumber
                                        value="${g.sale_cnt / g.total_tg }"
                                        pattern="#,##0%"></fmt:formatNumber></c:otherwise></c:choose>)
                                </td>
                                <td>
                                    <fmt:formatNumber value="${g.sale_amt }" pattern="\\#,##0"></fmt:formatNumber>
                                </td>
                                <td>
                                    <fmt:formatNumber value="${g.roi }" pattern="#,##0%"></fmt:formatNumber>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- 전체 단계 프레임 -->
                <h3>전환 단계별 분석</h3>
                <div class="campReportFrame">
                    <ul class="report-tab-cover">
                        <li class="report-tab" style="cursor: auto;">
                            <div class="tab-cover">
                                <div class="tab-head">
                                    <span class="title">발송</span>
                                </div>
                                <div class="tab-body">
											<span class="point">
												<fmt:formatNumber value="${base_info.total_tg }"
                                                                  pattern="#,##0"></fmt:formatNumber>
											</span>
                                </div>
                            </div>
                        </li>
                        <li class="report-tab" onclick="reportTabControl(this, 'sucTab')">
                            <div class="tab-cover">
                                <div class="tab-head">
                                    <span class="title">도달</span>
                                </div>
                                <div class="tab-body">
											<span class="point">
												<c:choose>
                                                    <c:when test="${base_info.total_tg eq '' }">0.0%</c:when>
                                                    <c:otherwise>
                                                        <fmt:formatNumber
                                                                value="${base_info.suc_cnt / base_info.total_tg }"
                                                                pattern="#,##0.00%"></fmt:formatNumber>
                                                    </c:otherwise>
                                                </c:choose>
											</span>
                                    <br/><span><fmt:formatNumber value="${base_info.suc_cnt }"
                                                                 pattern="#,##0"></fmt:formatNumber></span>
                                </div>
                            </div>
                        </li>
                        <li id="reportOpenTab" class="report-tab" onclick="reportTabControl(this, 'openTab')">
                            <div class="tab-cover">
                                <div class="tab-head">
                                    <span class="title">오픈</span>
                                </div>
                                <div class="tab-body">
											<span class="point">
												<c:choose>
                                                    <c:when test="${base_info.total_tg eq '' }">0.0%</c:when>
                                                    <c:otherwise>
                                                        <fmt:formatNumber
                                                                value="${base_info.open_cnt / base_info.total_tg }"
                                                                pattern="#,##0.00%"></fmt:formatNumber>
                                                    </c:otherwise>
                                                </c:choose>
											</span>
                                    <br/><span><fmt:formatNumber value="${base_info.open_cnt }"
                                                                 pattern="#,##0"></fmt:formatNumber></span>
                                </div>
                            </div>
                        </li>
                        <li id="reportClickTab" class="report-tab" onclick="reportTabControl(this, 'clickTab')">
                            <div class="tab-cover">
                                <div class="tab-head">
                                    <span class="title">클릭</span>
                                </div>
                                <div class="tab-body">
											<span class="point">
												<c:choose>
                                                    <c:when test="${base_info.total_tg eq '' }">0.0%</c:when>
                                                    <c:otherwise>
                                                        <fmt:formatNumber
                                                                value="${base_info.click_cnt / base_info.total_tg }"
                                                                pattern="#,##0.00%"></fmt:formatNumber>
                                                    </c:otherwise>
                                                </c:choose>
											</span>
                                    <br/><span><fmt:formatNumber value="${base_info.click_cnt }"
                                                                 pattern="#,##0"></fmt:formatNumber></span>
                                </div>
                            </div>
                        </li>
                        <li class="report-tab" onclick="reportTabControl(this, 'saleTab')">
                            <div class="tab-cover">
                                <div class="tab-head">
                                    <span class="title">구매</span>
                                </div>
                                <div class="tab-body">
											<span class="point">
												<c:choose>
                                                    <c:when test="${base_info.total_tg eq '' }">0.0%</c:when>
                                                    <c:otherwise>
                                                        <fmt:formatNumber
                                                                value="${base_info.sale_cnt / base_info.total_tg }"
                                                                pattern="#,##0.00%"></fmt:formatNumber>
                                                    </c:otherwise>
                                                </c:choose>
											</span>
                                    <br/><span><fmt:formatNumber value="${base_info.sale_cnt}"
                                                                 pattern="#,##0"></fmt:formatNumber></span>
                                </div>
                            </div>
                        </li>
                        <li class="report-tab" onclick="reportTabControl(this, 'roiTab')">
                            <div class="tab-cover">
                                <div class="tab-head">
                                    <span class="title">ROI%</span>
                                </div>
                                <div class="tab-body">
                                    <span class="point"><fmt:formatNumber value="${base_info.roi }"
                                                                          pattern="#,##0%"></fmt:formatNumber></span>
                                </div>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="report-contents-list-cover">
                <!-- 발송 리포트 ------------------------------------------------------------------------- ajax -->
                <div id="sendTab" class="report-tab-contents">

                </div>--%>
<!-- 도달 리포트 ------------------------------------------------------------------------- ajax -->
<div id="sucTab" class="report-tab-contents">
    <div class="half-grid">
        <table class="report-tab-table blue">
            <tr>
                <th>발송성공</th>
                <td>
										<span class="pointMid">
											90%
										</span>
                    <span class="text">(9,000)</span>
                </td>
                <%--<td>
                            <span class="pointMid">
                                <c:choose>
                                    <c:when test="${base_info.total_tg eq '' }">0%</c:when>
                                    <c:otherwise>
                                        <fmt:formatNumber
                                                value="${base_info.suc_cnt / base_info.total_tg }"
                                                pattern="#,##0%"></fmt:formatNumber>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                    <span class="text">(<fmt:formatNumber value="${base_info.suc_cnt }"
                                                          pattern="#,##0"></fmt:formatNumber>)</span>
                </td>--%>
            </tr>
        </table>
        <div class="grid-space"></div>
        <table class="report-tab-table max yellow">
            <tr>
                <th class="wid-40-p">사용자 계정문제</th>
                <td>
                    <span id="softTotalPortion" class="pointMid yellow"></span>
                    <span id="softTotalSpan" class="text"></span>
                </td>
            </tr>
            <tr>
                <td id="ll" class="no-padding" colspan="2">
                    <div class="chart-cover">
                        <canvas id="usrErrGraph"></canvas>
                    </div>
                    <div class="legend-cover">
                        <ul id="softList" class="legend-list"></ul>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <div class="half-grid">
        <table class="report-tab-table yellow">
            <tr>
                <th>발송실패</th>
                <td>
										<span class="pointMid">
											10%
										</span>
                    <span class="text">(1,000)</span>
                </td>
                <%--<td>
                            <span class="pointMid yellow">
                                <c:choose>
                                    <c:when test="${base_info.total_tg eq '' }">0%</c:when>
                                    <c:otherwise>
                                        <fmt:formatNumber
                                                value="${1 - base_info.suc_cnt / base_info.total_tg }"
                                                pattern="#,##0%"></fmt:formatNumber>
                                    </c:otherwise>
                                </c:choose>
                            </span>
                    (<c:choose><c:when test="${base_info.total_tg eq '' }">0</c:when><c:otherwise><span
                        class="text"><fmt:formatNumber
                        value="${base_info.total_tg - base_info.suc_cnt }"
                        pattern="#,##0"></fmt:formatNumber></span></c:otherwise></c:choose>)
                </td>--%>
            </tr>
        </table>
        <div class="grid-space">
            <div class="grid-line a"></div>
            <div class="grid-line b"></div>
            <div class="grid-line c"></div>
        </div>
        <table class="report-tab-table wid-100-p yellow">
            <tr>
                <th class="wid-40-p">시스템 문제</th>
                <td>
                    <span id="hardTotalPortion" class="pointMid yellow"></span>
                    <span id="hardTotalSpan" class="text"></span>
                </td>
            </tr>
            <tr>
                <td id="rr" class="no-padding" colspan="2">
                    <div class="chart-cover">
                        <canvas id="sysErrGraph"></canvas>
                    </div>
                    <div class="legend-cover">
                        <ul id="hardList" class="legend-list"></ul>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</div>


                <!-- 오픈 리포트 ------------------------------------------------------------------------- ajax -->
                <div id="openTab" class="report-tab-contents">
                    <div class="top-btn-grp">
                        <select class="customSelect" width="300" name="segment_value">
                            <option value="00">전체</option>
                            <option value="01">오픈시간대</option>
                            <option value="02">오픈일</option>
                            <option value="03">발송시간대</option>
                            <option value="04">발송일</option>
                        </select>
                        <input type="button"
                               onclick="reportTabControl(document.getElementById('reportOpenTab'), 'openTab');"
                               class="main-text-button" value="그래프 호출"/>
                    </div>
                    <h3>고객 특성별 오픈율 분석</h3>
                    <div class="open-chart-cover">
                        <div class="chart-cover">
                            <canvas id="openChart"></canvas>
                        </div>
                    </div>
                    <h3>오픈 시점 분석</h3>
                    <div id="openTimeResult" class="open-time-anal-cover"
                    ">
                </div>
            </div>
<%--
            <!-- 클릭 리포트  -->
            <div id="clickTab" class="report-tab-contents">
                <div class="top-btn-grp">
                    <select class="customSelect" width="300" name="segment_value_click">
                        <option value="00">전체</option>
                        <option value="01">콘텐츠별</option>
                        <option value="02">링크별</option>
                        <option value="03">클릭 환경</option>
                    </select>
                    <input type="button"
                           onclick="reportTabControl(document.getElementById('reportClickTab'), 'clickTab');"
                           class="main-text-button" value="그래프 호출"/>
                </div>
                <h3>고객 특성별 클릭률 분석</h3>
                <div class="open-chart-cover">
                    <div class="chart-cover">
                        <canvas id="clickChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- 구매 리포트  -->
            <div id="saleTab" class="report-tab-contents">
                <div class="top-btn-grp">
                    <select class="customSelect" width="300" name="segment_value_sale">
                        <option value="">세분화 기준 선택</option>
                        <c:forEach var="s" items="${table_map }">
                            <c:if test="${s.COL_ACT == 'GRP' }">
                                <option value="${s.COL_ID }" data="${s.COL_ACT }">${s.COL_NAME }</option>
                            </c:if>
                        </c:forEach>
                    </select>
                    <input type="button" class="main-text-button" value="그래프 호출"/>
                </div>
                <h3>고객 특성별 구매율 분석</h3>
                <div class="open-chart-cover">
                    <div class="chart-cover">
                        <canvas id="saleChart"></canvas>
                    </div>
                </div>
                <h3>구매 제품 및 매장 분석</h3>
                <div class="half-grid">
                    <h4>구매 매장 Top 10</h4>
                    <table class="auto-sorting-table">
                        <thead>
                        <tr>
                            <th class="wid-5-p">순위</th>
                            <th>매장명</th>
                            <th class="wid-10-p">구매자 수</th>
                        </tr>
                        </thead>
                        <tbody id="body">
                        <tr>
                            <td colspan="3">-</td>
                        </tr>

                        <!--
                        <tr>
                            <td>1</td>
                            <td>이마트상봉</td>
                            <td>39,015</td>
                        </tr>
                        <tr>
                            <td>2</td>
                            <td>이마트상봉</td>
                            <td>39,015</td>
                        </tr>
                        <tr>
                            <td>3</td>
                            <td>이마트상봉</td>
                            <td>39,015</td>
                        </tr>
                        <tr>
                            <td>4</td>
                            <td>이마트상봉</td>
                            <td>39,015</td>
                        </tr>
                        <tr>
                            <td>5</td>
                            <td>이마트상봉</td>
                            <td>39,015</td>
                        </tr>
                        <tr>
                            <td>6</td>
                            <td>이마트상봉</td>
                            <td>39,015</td>
                        </tr>
                        <tr>
                            <td>7</td>
                            <td>이마트상봉</td>
                            <td>39,015</td>
                        </tr>
                        <tr>
                            <td>8</td>
                            <td>이마트상봉</td>
                            <td>39,015</td>
                        </tr>
                        <tr>
                            <td>9</td>
                            <td>이마트상봉</td>
                            <td>39,015</td>
                        </tr>
                        <tr>
                            <td>10</td>
                            <td>이마트상봉</td>
                            <td>39,015</td>
                        </tr>
                         -->
                        </tbody>
                    </table>
                </div>
                <div class="half-grid">
                    <h4>구매 제품 Top 10</h4>
                    <table class="auto-sorting-table">
                        <thead>
                        <tr>
                            <th class="wid-5-p">순위</th>
                            <th>매장명</th>
                            <th class="wid-10-p">구매자 수</th>
                        </tr>
                        </thead>
                        <tbody id="body">
                        <tr>
                            <td colspan="3">-</td>
                        </tr>
                        <!--
                        <tr>
                            <td>1</td>
                            <td>이마트상봉</td>
                            <td>39,015</td>
                        </tr>
                        <tr>
                            <td>2</td>
                            <td>이마트상봉</td>
                            <td>39,015</td>
                        </tr>
                        <tr>
                            <td>3</td>
                            <td>이마트상봉</td>
                            <td>39,015</td>
                        </tr>
                        <tr>
                            <td>4</td>
                            <td>이마트상봉</td>
                            <td>39,015</td>
                        </tr>
                        <tr>
                            <td>5</td>
                            <td>이마트상봉</td>
                            <td>39,015</td>
                        </tr>
                        <tr>
                            <td>6</td>
                            <td>이마트상봉</td>
                            <td>39,015</td>
                        </tr>
                        <tr>
                            <td>7</td>
                            <td>이마트상봉</td>
                            <td>39,015</td>
                        </tr>
                        <tr>
                            <td>8</td>
                            <td>이마트상봉</td>
                            <td>39,015</td>
                        </tr>
                        <tr>
                            <td>9</td>
                            <td>이마트상봉</td>
                            <td>39,015</td>
                        </tr>
                        <tr>
                            <td>10</td>
                            <td>이마트상봉</td>
                            <td>39,015</td>
                        </tr>
                         -->
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- 도달 리포트  -->
            <div id="roiTab" class="report-tab-contents">
                <div class="full-grid">
                    <div class="il-block">
                        <table class="report-tab-table blue">
                            <tr>
                                <th>고객 특성별 ROI 분석(%)</th>
                                <td>
                                    <span class="pointMid">0%</span>
                                    <!-- <span class="pointMid">873%</span> -->
                                </td>
                            </tr>
                        </table>
                        <div class="grid-space">
                            <div class="grid-line a"></div>
                        </div>
                    </div>
                </div>

                <div class="half-grid">
                    <table class="report-tab-table blue wid-100-p">
                        <tr>
                            <th>추가 매출(원)</th>
                            <td>
                                <span class="pointMid">0</span>
                                <!-- <span class="pointMid">550,000,000</span> -->
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div class="roi-card-line">
                                    <div class="roi-card total">
                                        <div class="title">인원(명)</div>
                                        <div class="body">
                                            <span class="point">0</span>
                                            <!-- <span class="point">100,000</span> -->
                                        </div>
                                    </div>
                                </div>
                                <div class="roi-card-line">
                                    <div class="roi-card doing">
                                        <div class="title">진행 시</div>
                                        <div class="body">
                                            <span class="pointMid">10%</span>
                                            <br/>0구매
                                            <!--
                                            <span class="pointMid">10%</span>
                                            <br/>100,000구매
                                             -->
                                        </div>
                                    </div>
                                    <div class="roi-card undo">
                                        <div class="title">미 진행 시</div>
                                        <div class="body">
                                            <span class="pointMid yellow">10%</span>
                                            <br/>0구매
                                        </div>
                                        <!--
                                        <div class="body">
                                            <span class="pointMid yellow">10%</span>
                                            <br/>90,000구매
                                        </div>
                                         -->
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
                <div class="half-grid">
                    <table class="report-tab-table yellow wid-100-p">
                        <tr>
                            <th>캠페인 비용(원)</th>
                            <td>
                                <span class="pointMid yellow">0</span>
                                <!-- <span class="pointMid yellow">63,000,000</span> -->
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div class="roi-cost">
                                    <p>발송비 : <span class="yellow">0</span>원(0명 X 0원)</p>
                                    <p>오퍼비 : <span class="yellow">0</span>원(0명 X 0원)</p>
                                    <p>개발비 : <span class="yellow">0</span>원</p>
                                    <!--
                                    <p>발송비 : <span class="yellow">3,000,000</span>원(100,000명 X 30원)</p>
                                    <p>오퍼비 : <span class="yellow">30,000,000</span>원(10,000명 X 3,000원)</p>
                                    <p>개발비 : <span class="yellow">30,000,000</span>원</p>
                                     -->
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
    </div>
    </div>
</section>--%>
<script>
    /* 그래프 처리 모듬 ---------------------------------------------------------------- */
    function drawGraph(data) {// 도달 리포트 그래프
        var targetDiv1 = 'usrErrGraph';
        var targetDiv2 = 'sysErrGraph';
        var chartType = '02' // horizontalBarChart
        var inputData1 = [];
        var inputData2 = [];
        var dataSet1 = {};
        var dataSet2 = {};
        var column1 = [];
        var column2 = [];
        var data1 = [];
        var bgColor1 = [];
        var bgColor2 = [];
        var data2 = [];
        var html1 = '';
        var html2 = '';
        var softTotal = 0;
        var hardTotal = 0;
        for (var i = 0; i < data.length; i++) {
            if (data[i].bounce_category == 'SOFT') {
                data1.push(data[i].total_tg);
                softTotal += data[i].total_tg;
                var color = colorPicker(1, [70, 70, 90], 50, 150);
                bgColor1.push(color);
                column1.push(data[i].code_value);
                html1 += '<li>'
                    + '<label class="icon"><div class="pointer" style="background-color: ' + color + ';"></div>' + data[i].code_value + '</label>'
                    + '<div class="info">'
                    + '<span class="txt">?</span>'
                    + '<div class="info-box">'
                    + '<h6>' + data[i].code_value + '</h6>'
                    + '<p>' + data[i].code_name + '</p>'
                    + '</div>'
                    + '</div>'
                    + '</li>'
            } else if (data[i].bounce_category == 'HARD') {
                data2.push(data[i].total_tg);
                hardTotal += data[i].total_tg;
                var color = colorPicker(1, [70, 70, 90], 30, 150);
                bgColor2.push(color);
                column2.push(data[i].code_value);
                html2 += '<li>'
                    + '<label class="icon"><div class="pointer" style="background-color: ' + color + ';"></div>' + data[i].code_value + '</label>'
                    + '<div class="info">'
                    + '<span class="txt">?</span>'
                    + '<div class="info-box">'
                    + '<h6>' + data[i].code_value + '</h6>'
                    + '<p>' + data[i].code_name + '</p>'
                    + '</div>'
                    + '</div>'
                    + '</li>'
            }
        }
        dataSet1.data = data1;
        dataSet1.backgroundColor = bgColor1;
        dataSet1.label = "DataSet 1";
        inputData1.push(dataSet1);
        dataSet2.data = data2;
        dataSet2.backgroundColor = bgColor2;
        dataSet2.label = "DataSet 1";
        inputData2.push(dataSet2);
        var options = {
            legend: {display: false},
        }
        drawChart(targetDiv1, chartType, inputData1, column1, options);
        drawChart(targetDiv2, chartType, inputData2, column2, options);
        $('#softList').html(html1);
        $('#hardList').html(html2);
        var total = softTotal + hardTotal;
        var sfp = softTotal / total * 100;
        sfp = sfp.toFixed(1);
        var hfp = hardTotal / total * 100;
        hfp = hfp.toFixed(1);
        if (sfp != 'NaN') {
            $('#softTotalPortion').html(sfp + "%");
        } else {
            $('#softTotalPortion').html("0%");
        }
        if (hfp != 'NaN') {
            $('#hardTotalPortion').html(hfp + "%");
        } else {
            $('#hardTotalPortion').html("0%");
        }
        softTotal = "(" + setComma(softTotal) + ")";
        $('#softTotalSpan').html(softTotal)
        hardTotal = "(" + setComma(hardTotal) + ")";
        $('#hardTotalSpan').html(hardTotal)
    }

    /* 그래프 처리 모듬 ---------------------------------------------------------------- */
    function drawOpenGraph(data) {// 오픈 리포트 그래프
        var column = [];
        var data1 = [];
        var data2 = [];
        var data3 = [];
        var y1_max = 0;
        for (var i = 0; i < data.length; i++) {
            column.push(data[i].GBN);
            data1.push(data[i].SEG_MEM);
            data2.push(data[i].OPEN_MEM);
            var num = (data[i].OPEN_MEM / data[i].SEG_MEM) * 100;
            data3.push(num.toFixed(2));
        }

        var targetDiv = 'openChart';
        var chartData = {
            labels: column,
            datasets: [{
                type: 'line',
                label: '오픈 (%)',
                borderColor: '#6475de',
                borderWidth: 2,
                fill: false,
                data: data3,
                yAxisID: "y-axis-2"
            }, {
                type: 'bar',
                label: '전체 회원 수',
                backgroundColor: '#d1d1d1',
                data: data1,
                yAxisID: "y-axis-1",
                borderColor: 'white',
                borderWidth: 2
            }, {
                type: 'bar',
                label: '오픈 회원 수',
                backgroundColor: '#f9c426',
                data: data2,
                yAxisID: "y-axis-1",
            }]
        }
        drawComboChart(targetDiv, chartData);
    }

    /* 그래프 처리 모듬 ---------------------------------------------------------------- */
    function drawClickGraph(data) {// 클릭 리포트 그래프
        var column = [];
        var data1 = [];
        var data2 = [];
        var data3 = [];
        var y1_max = 0;
        for (var i = 0; i < data.length; i++) {
            column.push(data[i].gbn);
            data1.push(data[i].seg_mem);
            data2.push(data[i].click_mem);
            var num = (data[i].click_mem / data[i].seg_mem) * 100;
            data3.push(num.toFixed(2));
        }
        var targetDiv = 'clickChart';
        var chartData = {
            labels: column,
            datasets: [{
                type: 'line',
                label: '클릭 (%)',
                borderColor: '#6475de',
                borderWidth: 2,
                fill: false,
                data: data3,
                yAxisID: "y-axis-2"
            }, {
                type: 'bar',
                label: '전체 회원 수',
                backgroundColor: '#d1d1d1',
                data: data1,
                yAxisID: "y-axis-1",
                borderColor: 'white',
                borderWidth: 2
            }, {
                type: 'bar',
                label: '클릭 회원 수',
                backgroundColor: '#f9c426',
                data: data2,
                yAxisID: "y-axis-1",
            }]
        }
        drawComboChart(targetDiv, chartData);
    }

    /* 그래프 처리 모듬 ---------------------------------------------------------------- */
    function drawSaleGraph(data) {// 클릭 리포트 그래프
        var column = [];
        var data1 = [];
        var data2 = [];
        var data3 = [];
        var y1_max = 0;
        for (var i = 0; i < data.length; i++) {
            column.push(data[i].GBN);
            data1.push(data[i].OPEN_MEM);
            data2.push(data[i].SALE_MEM);
            var num = (data[i].SALE_MEM / data[i].OPEN_MEM) * 100;
            data3.push(num.toFixed(2));
        }

        var targetDiv = 'saleChart';
        var chartData = {
            labels: column,
            datasets: [{
                type: 'line',
                label: '구매 (%)',
                borderColor: '#6475de',
                borderWidth: 2,
                fill: false,
                data: data3,
                yAxisID: "y-axis-2"
            }, {
                type: 'bar',
                label: '전체 회원 수',
                backgroundColor: '#d1d1d1',
                data: data1,
                yAxisID: "y-axis-1",
                borderColor: 'white',
                borderWidth: 2
            }, {
                type: 'bar',
                label: '구매 회원 수',
                backgroundColor: '#f9c426',
                data: data2,
                yAxisID: "y-axis-1",
            }]
        }
        drawComboChart(targetDiv, chartData);
    }

    function getOpenTimeResult(data, total) {
        var target = $('#openTimeResult'); // 전체 프로젝트 총 발송 대상자 수
        /* 요일 및 시간대별 오픈한 사람 수 일단 0을 월요일로 시작 */
        var integ = [];
        var inner = {};
        for (var i = 0; i < data.length; i++) {
            if (i == 0 || data[i].WEEK_DAY != data[i - 1].WEEK_DAY) {
                if (i > 0) {
                    integ.push(inner)
                }
                inner = {};
                var key = data[i].WEEK_DAY;
                switch (key) {
                    case '0':
                        inner.WEEK_DAY = '월';
                        break;
                    case '1':
                        inner.WEEK_DAY = '화';
                        break;
                    case '2':
                        inner.WEEK_DAY = '수';
                        break;
                    case '3':
                        inner.WEEK_DAY = '목';
                        break;
                    case '4':
                        inner.WEEK_DAY = '금';
                        break;
                    case '5':
                        inner.WEEK_DAY = '토';
                        break;
                    case '6':
                        inner.WEEK_DAY = '일';
                        break;
                }
                var num = data[i].OPEN_CNT / total;
                num = num > 1 ? 1 : num;
                num = num.toFixed(4);
                inner[data[i].TIME_BAND] = num;
            } else if (i == data.length - 1) {
                var num = data[i].OPEN_CNT / total;
                num = num > 1 ? 1 : num;
                num = num.toFixed(4);
                inner[data[i].TIME_BAND] = num;
                integ.push(inner);
            } else {
                var num = data[i].OPEN_CNT / total;
                num = num > 1 ? 1 : num;
                num = num.toFixed(4);
                inner[data[i].TIME_BAND] = num;
            }

        }
        var html = '<ul class="row">'
            + '<li class="th"></li>'
            + '<li class="th">0</li>'
            + '<li class="th">1</li>'
            + '<li class="th">2</li>'
            + '<li class="th">3</li>'
            + '<li class="th">4</li>'
            + '<li class="th">5</li>'
            + '<li class="th">6</li>'
            + '<li class="th">7</li>'
            + '<li class="th">8</li>'
            + '<li class="th">9</li>'
            + '<li class="th">10</li>'
            + '<li class="th">11</li>'
            + '<li class="th">12</li>'
            + '<li class="th">13</li>'
            + '<li class="th">14</li>'
            + '<li class="th">15</li>'
            + '<li class="th">16</li>'
            + '<li class="th">17</li>'
            + '<li class="th">18</li>'
            + '<li class="th">19</li>'
            + '<li class="th">20</li>'
            + '<li class="th">21</li>'
            + '<li class="th">22</li>'
            + '<li class="th">23</li>'
            + '</ul>';
        var ulZindex = integ.length;
        for (var i = 0; i < integ.length; i++) {
            ulZindex = ulZindex - 1;
            html += '<ul class="row Nanum" style="z-index: ' + ulZindex + '"><li class="th">' + integ[i].WEEK_DAY + '</li>';
            var z = 23;
            for (var j = 0; j <= 23; j++) {
                var code = j < 10 ? '0' + j : j;
                for (key in integ[i]) {
                    if (key != 'WEEK_DAY' && key == code) {

                        var num = integ[i][key] * 100;
                        num = num.toFixed(2);
                        num = num + '%';
                        var op = parseFloat(integ[i][key]) + 0.1 > 1 ? 1 : parseFloat(integ[i][key]) * 8 + 0.1;
                        op = op.toFixed(2);
                        html += '<li class="td" style="z-index: ' + z + ';background-color: rgba(100, 117, 222, ' + op + ');"><label>' + num + '</label></li>'
                        z = z - 1;
                    }
                }
            }
            html += '</ul>';
        }
        target.html(html);
    }

    function campContentsDataCall(pid, cid, con) {
        var url = '${baseURL}/pop/campContentsDet.mi?pid=' + pid + '&cid=' + cid + '&con=' + con;
        popup(url, 'Campaign Contents Detail', 1680, 800);
    }

    function campContentsPreview(pid, cid, con, type) {
        var url = '${baseURL}/pop/contentsPreview.mi?pid=' + pid + '&cid=' + cid + '&con=' + con + '&type=' + type;
        var w = 0;
        var h = 0;
        switch (type) {
            case 'EM':
                w = 1024;
                h = 768;
                break;
            case 'MM':
                w = 480;
                h = 720;
                break;
            case 'KK':
                w = 480;
                h = 720;
                break;
        }
        popup(url, 'Campaign Contents Preview', w, h);
    }
</script>