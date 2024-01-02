<%@ page import="java.util.Date" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil" %>
<%@ taglib uri="/WEB-INF/tlds/Page.tld" prefix="ui" %>
<sec:authentication var="user" property="details"/>
<section class="container">
    <!-- 컨텐츠 영역 시작 -->
    <div class="contents">
        <!-- row 영역 시작 -->
        <div class="row tooltip_area bottom-border cf">
            <div class="left">
                <!-- location 영역 -->
                <ul class="location">
                    <li>홈</li>
                    <li>캠페인</li>
                    <li>발송 비용</li>
<%--                    <li>${dto.pro_nm}</li>--%>
                </ul>
            </div>
        </div>
        <!-- row 영역 끝 -->
        <div class="row bottom-border cf">
            <div class="left">
                <input type="button" class="btn_basic delete left right-border" onclick="excelDown();" value="엑셀 다운로드">
            </div>
        </div>
        <!--
           발송 상태에 따라 현재 진행 중인 ('article'클래스) 영역에
          'active'클래스 적용
          -->
        <!-- section 영역 시작 -->
        <div class="contents">
            <div class="contentsDet">
                <div class="settingDet">
                    <div class="chart-cover">
                        <canvas id="chartCover" style="width:90%; height:100%; margin-top:40px"></canvas>
                    </div>
                    <!-- 발송건수 테이블 -->
                    <div class="display-table float-clear active" id="graph-table">
                        <div class="thead">
                            <div class="title1">기간</div>
                            <div class="cont-wrap float-clear">
                                <div class="title2">발송건수</div>
                                <div class="sub-title-wrap">
                                    <div class="li">알림톡</div>
                                    <div class="li">친구톡(txt)</div>
                                    <div class="li">친구톡(img)</div>
                                    <div class="li">친구톡(wid)</div>
                                    <div class="li">RCS SMS</div>
                                    <div class="li">RCS LMS</div>
                                    <div class="li">RCS MMS</div>
                                    <div class="li">RCS 템플릿</div>
                                    <div class="li">SMS</div>
                                    <div class="li">LMS</div>
                                    <div class="li">MMS</div>
                                </div>
                            </div>
                        </div>
                        <div class="tbody float-clear">
                            <c:forEach var="send"  items="${sendMap}" >
                            <c:set var="val" value="${send.value}"/>
                            <div class="col_data">
                                <div class="title">${send.key}</div>
                                <div class="data-wrap">
                                    <div class="li"><fmt:formatNumber value="${!empty val.KKO_AT.total_cnt? val.KKO_AT.total_cnt : 0 }" pattern="#,###" /></div>
                                    <div class="li"><fmt:formatNumber value="${!empty val.KKO_FT_TXT.total_cnt? val.KKO_FT_TXT.total_cnt : 0 }" pattern="#,###" /></div>
                                    <div class="li"><fmt:formatNumber value="${!empty val.KKO_FT_IMG.total_cnt? val.KKO_FT_IMG.total_cnt : 0 }" pattern="#,###" /></div>
                                    <div class="li"><fmt:formatNumber value="${!empty val.KKO_FT_WID.total_cnt? val.KKO_FT_WID.total_cnt : 0 }" pattern="#,###" /></div>
                                    <div class="li"><fmt:formatNumber value="${!empty val.RCS_SMS.total_cnt? val.RCS_SMS.total_cnt : 0 }" pattern="#,###" /></div>
                                    <div class="li"><fmt:formatNumber value="${!empty val.RCS_LMS.total_cnt? val.RCS_LMS.total_cnt : 0 }" pattern="#,###" /></div>
                                    <div class="li"><fmt:formatNumber value="${!empty val.RCS_MMS.total_cnt? val.RCS_MMS.total_cnt : 0 }" pattern="#,###" /></div>
                                    <div class="li"><fmt:formatNumber value="${!empty val.RCS_TEPLATE.total_cnt? val.RCS_TEPLATE.total_cnt : 0 }" pattern="#,###" /></div>
                                    <div class="li"><fmt:formatNumber value="${!empty val.SMS.total_cnt? val.SMS.total_cnt : 0 }" pattern="#,###" /></div>
                                    <div class="li"><fmt:formatNumber value="${!empty val.LMS.total_cnt? val.LMS.total_cnt : 0 }" pattern="#,###" /></div>
                                    <div class="li"><fmt:formatNumber value="${!empty val.MMS.total_cnt? val.MMS.total_cnt : 0 }" pattern="#,###" /></div>
                                </div>
                            </div>
                            </c:forEach>
                        </div>
                        <div class="tfoot">
                            <div class="title">Total</div>
                            <div class="total-wrap">
                                <div class="li"><fmt:formatNumber value="${!empty typeTotalMap.KKO_AT.total_cnt? typeTotalMap.KKO_AT.total_cnt : 0 }" pattern="#,###" /></div>
                                <div class="li"><fmt:formatNumber value="${!empty typeTotalMap.KKO_FT_TXT.total_cnt? typeTotalMap.KKO_FT_TXT.total_cnt : 0 }" pattern="#,###" /></div>
                                <div class="li"><fmt:formatNumber value="${!empty typeTotalMap.KKO_FT_IMG.total_cnt? typeTotalMap.KKO_AT.KKO_FT_IMG : 0 }" pattern="#,###" /></div>
                                <div class="li"><fmt:formatNumber value="${!empty typeTotalMap.KKO_FT_WID.total_cnt? typeTotalMap.KKO_FT_WID.total_cnt : 0 }" pattern="#,###" /></div>
                                <div class="li"><fmt:formatNumber value="${!empty typeTotalMap.RCS_SMS.total_cnt? typeTotalMap.RCS_SMS.total_cnt : 0 }" pattern="#,###" /></div>
                                <div class="li"><fmt:formatNumber value="${!empty typeTotalMap.RCS_LMS.total_cnt? typeTotalMap.RCS_LMS.total_cnt : 0 }" pattern="#,###" /></div>
                                <div class="li"><fmt:formatNumber value="${!empty typeTotalMap.RCS_MMS.total_cnt? typeTotalMap.RCS_MMS.total_cnt : 0 }" pattern="#,###" /></div>
                                <div class="li"><fmt:formatNumber value="${!empty typeTotalMap.RCS_TEPLATE.total_cnt? typeTotalMap.RCS_TEPLATE.total_cnt : 0 }" pattern="#,###" /></div>
                                <div class="li"><fmt:formatNumber value="${!empty typeTotalMap.SMS.total_cnt? typeTotalMap.SMS.total_cnt : 0 }" pattern="#,###" /></div>
                                <div class="li"><fmt:formatNumber value="${!empty typeTotalMap.LMS.total_cnt? typeTotalMap.LMS.total_cnt : 0 }" pattern="#,###" /></div>
                                <div class="li"><fmt:formatNumber value="${!empty typeTotalMap.MMS.total_cnt? typeTotalMap.MMS.total_cnt : 0 }" pattern="#,###" /></div>
                            </div>
                        </div>

                        <div class="bfoot float-clear">
                            <div class="title1">Total</div>
                            <div class="bTotal-wrap float-clear">
                                <c:forEach var="send" items="${sendMap}">
                                    <div class="li"><fmt:formatNumber value="${totalMap[send.key].totalCnt}" pattern="#,###" /></div>
                                </c:forEach>
                            </div>
                            <div class="all-sum"><fmt:formatNumber value="${typeTotalMap.ALL.total_cnt}" pattern="#,###" /></div>
                        </div>
                    </div>
                    <!-- 발송금액 테이블 -->
                    <div class="display-table float-clear no-top-b active" id="graph-table2">
                        <div class="thead">
                            <div class="cont-wrap float-clear">
                                <div class="title2">발송금액</div>
                                <div class="sub-title-wrap">
                                    <div class="li">알림톡</div>
                                    <div class="li">친구톡(txt)</div>
                                    <div class="li">친구톡(img)</div>
                                    <div class="li">친구톡(wid)</div>
                                    <div class="li">RCS SMS</div>
                                    <div class="li">RCS LMS</div>
                                    <div class="li">RCS MMS</div>
                                    <div class="li">RCS 템플릿</div>
                                    <div class="li">SMS</div>
                                    <div class="li">LMS</div>
                                    <div class="li">MMS</div>
                                </div>
                            </div>
                        </div>
                        <div class="tbody float-clear">
                        <c:forEach var="send"  items="${sendMap}">
                            <c:set var="val" value="${send.value}"/>
                            <div class="col_data">
                                <div class="data-wrap">
                                    <div class="li"><fmt:formatNumber value="${!empty val.KKO_AT.total_cost? val.KKO_AT.total_cost : 0 }" pattern="#,###.#" /></div>
                                    <div class="li"><fmt:formatNumber value="${!empty val.KKO_FT_TXT.total_cost? val.KKO_FT_TXT.total_cost : 0 }" pattern="#,###.#" /></div>
                                    <div class="li"><fmt:formatNumber value="${!empty val.KKO_FT_IMG.total_cost? val.KKO_FT_IMG.total_cost : 0 }" pattern="#,###.#" /></div>
                                    <div class="li"><fmt:formatNumber value="${!empty val.KKO_FT_WID.total_cost? val.KKO_FT_WID.total_cost : 0 }" pattern="#,###.#" /></div>
                                    <div class="li"><fmt:formatNumber value="${!empty val.RCS_SMS.total_cost? val.RCS_SMS.total_cost : 0 }" pattern="#,###.#" /></div>
                                    <div class="li"><fmt:formatNumber value="${!empty val.RCS_LMS.total_cost? val.RCS_LMS.total_cost : 0 }" pattern="#,###.#" /></div>
                                    <div class="li"><fmt:formatNumber value="${!empty val.RCS_MMS.total_cost? val.RCS_MMS.total_cost : 0 }" pattern="#,###.#" /></div>
                                    <div class="li"><fmt:formatNumber value="${!empty val.RCS_TEPLATE.total_cost? val.RCS_TEPLATE.total_cost : 0 }" pattern="#,###.#" /></div>
                                    <div class="li"><fmt:formatNumber value="${!empty val.SMS.total_cost? val.SMS.total_cost : 0 }" pattern="#,###.#" /></div>
                                    <div class="li"><fmt:formatNumber value="${!empty val.LMS.total_cost? val.LMS.total_cost : 0 }" pattern="#,###.#" /></div>
                                    <div class="li"><fmt:formatNumber value="${!empty val.MMS.total_cost? val.MMS.total_cost : 0 }" pattern="#,###.#" /></div>
                                </div>
                            </div>
                        </c:forEach>
                        </div>

                        <div class="tfoot">
                            <div class="total-wrap">
                                <div class="li"><fmt:formatNumber value="${!empty typeTotalMap.KKO_AT.total_cost? typeTotalMap.KKO_AT.total_cost : 0 }" pattern="#,###.#" /></div>
                                <div class="li"><fmt:formatNumber value="${!empty typeTotalMap.KKO_FT_TXT.total_cost? typeTotalMap.KKO_FT_TXT.total_cost : 0 }" pattern="#,###.#" /></div>
                                <div class="li"><fmt:formatNumber value="${!empty typeTotalMap.KKO_FT_IMG.total_cost? typeTotalMap.KKO_FT_IMG.total_cost : 0 }" pattern="#,###.#" /></div>
                                <div class="li"><fmt:formatNumber value="${!empty typeTotalMap.KKO_FT_WID.total_cost? typeTotalMap.KKO_FT_WID.total_cost : 0 }" pattern="#,###.#" /></div>
                                <div class="li"><fmt:formatNumber value="${!empty typeTotalMap.RCS_SMS.total_cost? typeTotalMap.RCS_SMS.total_cost : 0 }" pattern="#,###.#" /></div>
                                <div class="li"><fmt:formatNumber value="${!empty typeTotalMap.RCS_LMS.total_cost? typeTotalMap.RCS_LMS.total_cost : 0 }" pattern="#,###.#" /></div>
                                <div class="li"><fmt:formatNumber value="${!empty typeTotalMap.RCS_MMS.total_cost? typeTotalMap.RCS_MMS.total_cost : 0 }" pattern="#,###.#" /></div>
                                <div class="li"><fmt:formatNumber value="${!empty typeTotalMap.RCS_TEPLATE.total_cost? typeTotalMap.RCS_TEPLATE.total_cost : 0 }" pattern="#,###.#" /></div>
                                <div class="li"><fmt:formatNumber value="${!empty typeTotalMap.SMS.total_cost? typeTotalMap.SMS.total_cost : 0 }" pattern="#,###.#" /></div>
                                <div class="li"><fmt:formatNumber value="${!empty typeTotalMap.LMS.total_cost? typeTotalMap.LMS.total_cost : 0 }" pattern="#,###.#" /></div>
                                <div class="li"><fmt:formatNumber value="${!empty typeTotalMap.MMS.total_cost? typeTotalMap.MMS.total_cost : 0 }" pattern="#,###.#" /></div>
                            </div>
                        </div>

                        <div class="bfoot float-clear">
                            <div class="title1">Total</div>
                            <div class="bTotal-wrap float-clear">
                                <c:forEach var="send" items="${sendMap}">
                                    <div class="li"><fmt:formatNumber value="${totalMap[send.key].totalCost}" pattern="#,###.#" /></div>
                                </c:forEach>
                            </div>
                            <div class="all-sum"><fmt:formatNumber value="${typeTotalMap.ALL.total_cost}" pattern="#,###.#" /></div>
                        </div>
                    </div>

                    <div class="table-tab" id="table-tab">
                        <div class="open none">
                            <span>표 열기</span>
                            <img src="/image/ico_pager_next1.png" alt="">
                        </div>
                        <div class="close">
                            <span>표 닫기</span>
                            <img src="/image/ico_pager_next1.png" alt="">
                        </div>
                    </div>
                    <!-- SEARCH AREA START-->
                    <form:form id="searchForm" method="get" action="./costDetail.mi">
                        <div class="simple-search-wrap">
                            <div>
                                <div class="option_month2">
                                    <input type="button" class="btn_basic3 left border right-border-none ${empty startDt and empty endDt ? '' : 'clickBtn'}" value="Period" onclick="selPeriodOption('D',this)">
                                    <input type="button" class="btn_basic3 left border ${empty startDt and empty endDt ? 'clickBtn' : ''}" value="Monthly" onclick="selPeriodOption('M', this)">
                                </div>
                            </div>
                            <div id="dailyOption" name="day-option" ${empty startDt and empty endDt ? "style=\"display:none;\"" : ''}>
                                <input type="text" name="start_dt" class="date-pick-box date" id="from" placeholder="발송시작일"
                                       value="${startDt}" autocomplete="off"/>
                                <span class="hyphen">-</span>
                                <input type="text" name="end_dt" class="date-pick-box date" id="to" placeholder="발송종료일"
                                       value="${endDt}" autocomplete="off"/>
                            </div>
                            <div class="control-block center" id="monthlyOption"  name="day-option" style="line-height: 1.2; ${empty startDt and empty endDt ? '' : 'display:none;'}">
                                <div class="month_prev" onclick="prePeriodControl()">
                                    <img src="${baseURL}/image/ico_rcs_prev.png" alt="">
                                </div>
                                <c:set var="monthDt" value="${empty startDt and empty endDt ? monthlyDt : ''}"/>
                                <span class="curentDate"><fmt:formatDate value="${monthDt}" pattern="yyyy-MM"/></span>
                                <input type="hidden" name="monthly_dt" id="monthlyDt" value="<fmt:formatDate value="${monthDt}" pattern="yyyy-MM"/>">
<%--                                <input type="button" class="report-icon-btn calendar" onclick="dateOptionCall(this)">--%>
                                <div class="month_next" onclick="nextPeriodControl()">
                                    <img src="${baseURL}/image/ico_rcs_next.png" alt="">
                                </div>
                                <%--<div class="dateOption" style="display: none">
                                    <input type="button" class="dateOptionBtn" value="2017.08" onclick="periodControl('201708')">
                                </div>--%>
                            </div>
                            <div class="select-wrap" id="customSelectWrap">
                                <div class="customSelect" id="customSelect">
                                    <div class="value">
                                        <c:choose>
                                            <c:when test="${!empty param.pro_nm}">
                                                캠페인명
                                            </c:when>
                                            <c:when test="${!empty param.team_nm}">
                                                팀명
                                            </c:when>
                                            <c:otherwise>
                                                기준선택
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <ul class="option">
                                    <li data="pro_nm" class="${!empty param.pro_nm ? 'selected' : ''}">캠페인명</li>
                                    <li data="team_nm" class="${!empty param.team_nm ? 'selected' : ''}">팀명</li>
                                </ul>
                            </div>
                            <input type="text" class="search-text-box" name="${!empty param.pro_nm ? 'pro_nm':''} ${!empty param.team_nm ? 'team_nm':''}"
                                   value="${!empty param.pro_nm ? param.pro_nm:''} ${!empty param.team_nm ? param.team_nm:''}" id="searchkey"
                                   placeholder="검색어입력" onkeyup="javascript:if (window.event.keyCode == 13){searchCostReport()}" />
                            <input type="hidden" name="pageNo" id="pageNo" value="${param.pageNo}">
                            <input type="button" class="gray-search-btn" onclick="searchCostReport()"></input>
                        </div>
                    </form:form>
                    <!-- SEARCH AREA END-->
                    <div class="single-table-cover" id="programView">
                        <table class="single-table" summary="table">
                            <colgroup>
                                <col width="20%">
                                <col width="10%">
                                <col width="35%">
                                <col width="35%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th scope="col">캠페인 명</th>
                                <th scope="col">캠페인 시작일</th>
<%--                                <th scope="col">발송자</th>--%>
                                <th scope="col">발송건수</th>
                                <th scope="col">발송비용</th>
                            </tr>
                            </thead>
                            <tbody id="listBody">
                            <c:forEach var="programLst" items="${programMap}">
                                <c:set var="prg" value="${programLst.value}" />
                                <c:set var = "totalCnt" value = "0" />
                                <c:set var = "totalCost" value = "0" />
                                <c:forEach var="tempPrg" items="${prg}">
                                    <c:set var= "totalCnt" value="${totalCnt + tempPrg.value.total_cnt}"/>
                                    <c:set var= "totalCost" value="${totalCost + tempPrg.value.total_cost}"/>
                                </c:forEach>
                                <tr>
                                <c:forEach begin="0" end="${prg.size}" var="_program" items="${prg}">
                                    <c:set var="program" value="${_program.value}" />
                                    <td>${program.pro_nm}<br><br>
                                    ${!empty program.team_nm ? '('+=program.team_nm+=')' : ''}</td>
                                    <td>${program.prg_start_dt}</td>
<%--                                    <td>${program.req_id}</td>--%>
                                </c:forEach>
                                    <td class="table-inner">
                                        <div class="flex-div">
                                            <div>
                                                <p>알림톡 : <fmt:formatNumber value="${!empty prg.KKO_AT.total_cnt ? prg.KKO_AT.total_cnt : 0 }" pattern="#,##0" /></p>
                                                <p>친구톡(txt) : <fmt:formatNumber value="${!empty prg.KKO_FT_TXT.total_cnt? prg.KKO_FT_TXT.total_cnt : 0 }" pattern="#,##0" /></p>
                                                <p>친구톡(img) : <fmt:formatNumber value="${!empty prg.KKO_FT_IMG.total_cnt? prg.KKO_FT_IMG.total_cnt : 0 }" pattern="#,##0" /></p>
                                                <p>친구톡(wid) : <fmt:formatNumber value="${!empty prg.KKO_FT_WID.total_cnt? prg.KKO_FT_WID.total_cnt : 0 }" pattern="#,##0" /></p>
                                            </div>
                                            <div>
                                                <p>RCS SMS : <fmt:formatNumber value="${!empty prg.RCS_SMS.total_cnt? prg.RCS_SMS.total_cnt : 0 }" pattern="#,##0" /></p>
                                                <p>RCS LMS : <fmt:formatNumber value="${!empty prg.RCS_LMS.total_cnt? prg.RCS_LMS.total_cnt : 0 }" pattern="#,##0" /></p>
                                                <p>RCS MMS : <fmt:formatNumber value="${!empty prg.RCS_MMS.total_cnt? prg.RCS_MMS.total_cnt : 0 }" pattern="#,##0" /></p>
                                                <p>RCS 템플릿 : <fmt:formatNumber value="${!empty prg.RCS_TEPLATE.total_cnt? prg.RCS_TEPLATE.total_cnt : 0 }" pattern="#,##0" /></p>
                                            </div>
                                            <div>
                                                <p>SMS : <fmt:formatNumber value="${!empty prg.SMS.total_cnt? prg.SMS.total_cnt : 0 }" pattern="#,##0" /></p>
                                                <p>LMS : <fmt:formatNumber value="${!empty prg.LMS.total_cnt? prg.LMS.total_cnt : 0 }" pattern="#,##0" /></p>
                                                <p>MMS : <fmt:formatNumber value="${!empty prg.MMS.total_cnt? prg.MMS.total_cnt : 0 }" pattern="#,##0" /></p>
                                            </div>
                                        </div>
                                        <p class="sms-result total">Total : <fmt:formatNumber value="${totalCnt}" pattern="#,###" /> 건</p>
                                    </td>
                                    <td class="table-inner">
                                        <div class="flex-div">
                                            <div>
                                                <p>알림톡 : <fmt:formatNumber value="${!empty prg.KKO_AT.total_cost? prg.KKO_AT.total_cost : 0 }" pattern="#,###.#" /></p>
                                                <p>친구톡(txt) : <fmt:formatNumber value="${!empty prg.KKO_FT_TXT.total_cost? prg.KKO_FT_TXT.total_cost : 0 }" pattern="#,###.#" /></p>
                                                <p>친구톡(img) : <fmt:formatNumber value="${!empty prg.KKO_FT_IMG.total_cost? prg.KKO_FT_IMG.total_cost : 0 }" pattern="#,###.#" /></p>
                                                <p>친구톡(wid) : <fmt:formatNumber value="${!empty prg.KKO_FT_WID.total_cost? prg.KKO_FT_WID.total_cost : 0 }" pattern="#,###.#" /></p>
                                            </div>
                                            <div>
                                                <p>RCS SMS : <fmt:formatNumber value="${!empty prg.RCS_SMS.total_cost? prg.RCS_SMS.total_cost : 0 }" pattern="#,###.#" /></p>
                                                <p>RCS LMS : <fmt:formatNumber value="${!empty prg.RCS_LMS.total_cost? prg.RCS_LMS.total_cost : 0 }" pattern="#,###.#" /></p>
                                                <p>RCS MMS : <fmt:formatNumber value="${!empty prg.RCS_MMS.total_cost? prg.RCS_MMS.total_cost : 0 }" pattern="#,###.#" /></p>
                                                <p>RCS 템플릿 : <fmt:formatNumber value="${!empty prg.RCS_TEPLATE.total_cost? prg.RCS_TEPLATE.total_cost : 0 }" pattern="#,###.#" /></p>
                                            </div>
                                            <div>
                                                <p>SMS : <fmt:formatNumber value="${!empty prg.SMS.total_cost? prg.SMS.total_cost : 0 }" pattern="#,###.#" /></p>
                                                <p>LMS : <fmt:formatNumber value="${!empty prg.LMS.total_cost? prg.LMS.total_cost : 0 }" pattern="#,###.#" /></p>
                                                <p>MMS : <fmt:formatNumber value="${!empty prg.MMS.total_cost? prg.MMS.total_cost : 0 }" pattern="#,###.#" /></p>
                                            </div>
                                        </div>
                                        <p class="sms-result total">Total : <fmt:formatNumber value="${totalCost}" pattern="#,###.#" /> 원</p>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                        <div class="btn_row bottom-border">
                            <ul class="pager">
                                <ui:pagination paginationInfo="${page}" type="image" jsFunction="getCostList"/>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
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
<!-- container 영역 끝 -->
</div>
<!-- wrap end -->
<content tag="script">
    <script src="/js/Chart.min.js"></script>
<%--        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>--%>
    <script type="text/javascript">
        $(function(){
            /* 테이블 크기 동적 구성 */
            let table = document.getElementById('graph-table');
            let table2 = document.getElementById('graph-table2');

            // 테이블 높이
            let liLen = table.querySelectorAll(".sub-title-wrap .li").length;
            table.style.height = 72 + (36 * liLen) + 'px';

            let liLen2 = table2.querySelectorAll(".sub-title-wrap .li").length;
            table2.style.height = 36 + (36 * liLen2) + 'px';

            // 발송건수/발송금액 타이틀 높이
            let ttl = table.querySelector(".title2");
            let ttl2 = table2.querySelector(".title2");

            ttl.style.height = (36 * liLen) + 'px';
            ttl.style.lineHeight = (36 * liLen) + 'px';
            ttl2.style.height = (36 * liLen2) + 'px';
            ttl2.style.lineHeight = (36 * liLen2) + 'px';

            // 라벨 개수만큼 데이터 칸 넓이
            let dtWrap = table.querySelectorAll(".tbody .col_data");
            let ttList = table.querySelectorAll(".bfoot .li");
            for(let i = 0; i < dtWrap.length; i++){
                dtWrap[i].style.width = (100 / dtWrap.length) + '%';
                ttList[i].style.width = (100 / dtWrap.length) + '%';
            }

            let dtWrap2 = table2.querySelectorAll(".tbody .col_data");
            let ttList2 = table2.querySelectorAll(".bfoot .li");
            for(let i = 0; i < dtWrap2.length; i++){
                dtWrap2[i].style.width = (100 / dtWrap2.length) + '%';
                ttList2[i].style.width = (100 / dtWrap2.length) + '%';
            }


            $.datepicker.setDefaults({
                dateFormat: 'yy-mm-dd'
                , monthNames: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
                , showMonthAfterYear: true
                , yearSuffix: "."
            });

            //기간 검색 시작일
            $('#from').datepicker({
                onSelect: function (selected) {
                    const end  =$('#to').val();
                    if(end == '' || end == null ){
                        $('#to').datepicker("option", "minDate", selected);
                    } else{
                        const startDt = new Date($('#from').val());
                        const endDt = new Date(end);
                        startDt.setFullYear(startDt.getFullYear()+1);
                        if (startDt < endDt) {
                            alert("최대 검색 기간은 1년입니다.");
                            $('#from').val('')
                            return false;
                        } else {
                            $('#to').datepicker("option", "minDate", selected);
                        }
                    }
                }
            });
            //기간 검색 종료일
            $('#to').datepicker({
                onSelect: function (selected) {
                    const start  =$('#from').val();
                    if(start == '' || start == null ){
                        $('#from').datepicker("option", "maxDate", selected);
                    } else{
                        const startDt = new Date(start);
                        const endDt = new Date($('#to').val());
                        endDt.setFullYear(endDt.getFullYear()-1);
                        if (startDt < endDt) {
                            alert("최대 검색 기간은 1년입니다.");
                            $('#to').val('')
                            return false;
                        } else {
                            $('#from').datepicker("option", "maxDate", selected);
                        }
                    }
                }
            });

            // custom Select Box
            $("#customSelect").on('click', function(){
                $("#customSelectWrap ul").slideDown();
            });

            $("#customSelectWrap ul li").on('click',function(){
                $("#customSelectWrap ul li").removeClass("selected");
                $(this).addClass("selected");

                let thisData = $(this).attr('col_data');
                let thisVal = $(this).text();
                $("#customSelect .value").text(thisVal);
                $("#customSelect .value").css("color", "#222");
                $("#customSelectWrap ul").slideUp();
            });

            // hide table
            let tab = document.getElementById('table-tab').children;
            Array.from(tab).forEach((item, idx) => {
                item.addEventListener('click', () => {
                    for(let i = 0; i < tab.length; i++){
                        tab[i].classList.remove('none');
                    }
                    tab[idx].classList.add('none');

                    if(idx == 0){
                        table.classList.add('active');
                        table2.classList.add('active');
                    } else if(idx == 1){
                        table.classList.remove('active');
                        table2.classList.remove('active');
                    }
                })
            })


            let data = ${jsonMap};
            let atData = [];
            let ftTextData = [];
            let ftImgData = [];
            let ftWideData = [];
            let rcsSmsData = [];
            let rcsLmsData = [];
            let rcsMmsData = [];
            let rcsTempData = [];
            let smsData = [];
            let lmsData = [];
            let mmsData = [];

            for(key in data){
                let map = data[key]

                let at = map.KKO_AT
                let ftTxt =map.KKO_FT_TXT
                let ftImg =map.KKO_FT_IMG
                let ftWid =map.KKO_FT_WID
                let rcsSms =map.RCS_SMS
                let rcsLms =map.RCS_LMS
                let rcsMms =map.RCS_MMS
                let rcsTemp =map.RCS_TEPLATE
                let sms =map.SMS
                let lms =map.LMS
                let mms =map.MMS

                atData.push(at == undefined || at ==null? 0 : at.total_cnt)
                ftTextData.push(ftTxt == undefined || ftTxt ==null? 0 : ftTxt.total_cnt)
                ftImgData.push(ftImg == undefined || ftImg ==null? 0 : ftImg.total_cnt)
                ftWideData.push(ftWid == undefined || ftWid ==null? 0 : ftWid.total_cnt)
                rcsSmsData.push(rcsSms == undefined || rcsSms ==null? 0 : rcsSms.total_cnt)
                rcsLmsData.push(rcsLms == undefined || rcsLms ==null? 0 : rcsLms.total_cnt)
                rcsMmsData.push(rcsMms == undefined || rcsMms ==null? 0 : rcsMms.total_cnt)
                rcsTempData.push(rcsTemp == undefined || rcsTemp ==null? 0 : rcsTemp.total_cnt)
                smsData.push(sms == undefined || sms ==null? 0 : sms.total_cnt)
                lmsData.push(lms == undefined || lms ==null? 0 : lms.total_cnt)
                mmsData.push(mms == undefined || mms ==null? 0 : mms.total_cnt)

            }

            var chartArea = document.getElementById('chartCover').getContext('2d');
            var myChart = new Chart(chartArea, {
                type: 'bar',
                data: {
                    labels: Object.keys(data),
                    datasets: [
                        {
                            label: '알림톡',
                            data: atData,
                            backgroundColor: 'rgba(29, 33, 132, 1)'
                        },
                        {
                            label: '친구톡(txt)',
                            data: ftTextData,
                            backgroundColor: 'rgba(40, 69, 156, 1)'
                        },
                        {
                            label: '친구톡(img)',
                            data: ftImgData,
                            backgroundColor: 'rgba(97, 140, 211, 1)'
                        },
                        {
                            label: '친구톡(wid)',
                            data: ftWideData,
                            backgroundColor: 'rgba(118, 177, 225, 1)'
                        },
                        {
                            label: 'RCS SMS',
                            data: rcsSmsData,
                            backgroundColor: 'rgba(118, 215, 221, 1)'
                        },
                        {
                            label: 'RCS LMS',
                            data: rcsLmsData,
                            backgroundColor: 'rgba(79, 212, 191, 1)'
                        },
                        {
                            label: 'RCS MMS',
                            data: rcsMmsData,
                            backgroundColor: 'rgba(123, 214, 157, 1)'
                        },
                        {
                            label: 'RCS 템플릿',
                            data: rcsTempData,
                            backgroundColor: 'rgba(191, 211, 129, 1)'
                        },
                        {
                            label: 'SMS',
                            data: smsData,
                            backgroundColor: 'rgba(248, 170, 77, 1)'
                        },
                        {
                            label: 'LMS',
                            data: lmsData,
                            backgroundColor: 'rgba(245, 133, 34, 1)'
                        },
                        {
                            label: 'MMS',
                            data: mmsData,
                            backgroundColor: 'rgba(242, 89, 33, 1)'
                        },
                    ]
                },
                options: {
                    responsive: false,
                    scales: {
                        x: {
                            stacked: true,
                            grid: {
                                color: 'rgba(244, 244, 244, 1)'
                            }
                        },
                        y: {
                            stacked: true,
                            beginAtZero: true,
                            grid: {
                                display: false
                            }
                        }
                    }
                }
            });
        });

        function searchCostReport() {
            let searchType = $('#customSelectWrap .option li.selected').attr("data");
            $('#searchForm #searchkey').attr("name",searchType);
            $('#searchForm #pageNo').val(1);

            $('#searchForm').submit();
        }

        function getCostList(page){
            $('#searchForm #pageNo').val(page);
            $('#searchForm').serializeArray();

            let res = function(response){
                const $doc = new DOMParser().parseFromString(response, "text/html");
                $("#programView").html($("#programView", $doc).html());
            };

            com_ajax.ajax('get', './programList.ajax', $('#searchForm').serializeArray(), res);
        }


        function excelDown(){
            let frm = common.create_form('dummy', 'POST', '/cost/costReportDown.service', 'popup_down');
            common.add_input(frm, "start_dt", '${param.start_dt}');
            common.add_input(frm, "end_dt", '${param.end_dt}');
            common.add_input(frm, "pro_nm", '${param.pro_nm}');
            common.add_input(frm, "team_nm", '${param.team_nm}');
            let message = '<!DOCTYPE html><html lang="ko"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><meta http-equiv="X-UA-Compatible" content="ie=edge"><title>miCRM</title></head><body><img src="/image/excelDown.jpg" alt="" style="width:100%;"></body></html>';
            common.popview('', 'popup_down', '661', '423', message);
            document.body.insertBefore(frm, null);
            frm.submit();
            frm.remove();
        }

        function selPeriodOption(type ,el){
            $('.clickBtn').removeClass("clickBtn")
            $(el).addClass("clickBtn");

            $('div[name="day-option"]').hide();
            if(type == 'D'){
                $('#monthlyOption input').val('');
                $('#dailyOption').show();
            } else if ('M'){
                // 현재 날짜 기준 지난달 한달 적용
                const date = new Date();
                const monthly = date.getFullYear() +"-"+date.getMonth();

                $('#monthlyOption .curentDate').html(monthly);
                $('#monthlyDt').val(monthly);
                $('#dailyOption input').val('');
                $('#monthlyOption').show();
            }
        }

        function prePeriodControl(){
            const monDt = $('#monthlyDt').val();
            const date = new Date(monDt);
            date.addMonths(-1);
            $('#monthlyDt').val(date.getFullYear() + "-" + (date.getMonth() + 1));
            searchCostReport();
        }

        function nextPeriodControl(){
            const monDt = $('#monthlyDt').val();
            const date = new Date(monDt);
            date.addMonths(1);
            $('#monthlyDt').val(date.getFullYear() + "-" + (date.getMonth() + 1));
            searchCostReport();
        }
    </script>
</content>