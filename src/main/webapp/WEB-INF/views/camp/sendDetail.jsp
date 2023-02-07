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
<sec:authentication var="user" property="details" />
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
                    <li>발송 현황</li>
                    <li>${dto.pro_nm}</li>
                </ul>
            </div>
        </div>
        <!-- row 영역 끝 -->
        <!-- row 영역 시작 -->
        <div class="row bottom-border cf">
            <div class="left">
                <a href="#" class="btn_basic ico_result left right-border"
                   onclick="location.href='/report/proDt.mi?pro_id=${dto.pro_id}'"> 결과</a>
                <a href="#" class="btn_basic down left right-border" onclick="detailDown();"> 결과 다운로드</a>
            </div>
        </div>
        <!-- row 영역 끝 -->
        <ul class="tab_row">
            <li class="on"><a href="javascript:void(0);">캠페인 상세로 보기</a></li>
            <!-- <li><a href="javascript:void(0);">캠페인 플로우로 보기</a></li> -->
        </ul>
        <!--
           발송 상태에 따라 현재 진행 중인 ('article'클래스) 영역에
          'active'클래스 적용
          -->
        <!-- section 영역 시작 -->
        <div class="section">
            <div class="status_wrap">
                <div class="article active">
                    <div class="top">
                        <span <c:if test="${dto.pro_st eq '01'}">class="on"</c:if>>발송대기</span>
                        <span class="slash">/</span>
                        <span <c:if test="${dto.pro_st eq '03'}">class="on"</c:if>>발송중</span>
                        <span class="slash">/</span>
                        <span <c:if test="${dto.pro_st eq '04'}">class="on"</c:if>>발송완료</span>
                        <span class="slash">/</span>
                        <span <c:if test="${dto.pro_st eq '99'}">class="fail on"</c:if>>발송실패</span>
                    </div>
                    <div class="area">
                        <!-- 리스트 1단위 영역 시작 -->
                        <c:forEach var="g" items="${campLst}" varStatus="st">
                            <c:set var="camp_id">${g.seq}</c:set>
                            <c:set var="startDt">${g.start_dt}</c:set>
                            <c:set var="tar_cnt">${!empty g.tar_cnt ? g.tar_cnt :'0' }</c:set>
                            <dl>
                                <dt class="bottom-border">
                                    <span class="number en_font">${st.count}</span>
                                    <div class="info_row">
                                        <h3 class="ellipsis">${g.camp_nm}</h3>
                                        <span class="en_font">(<fmt:formatNumber
                                                value="${dto.pro_st eq '03' ? tar_cnt : g.send_cnt}"
                                                pattern="#,###"/>명)</span><br>
                                        <c:if test="${!empty g.avo_nm}">
                                            <span class="half-ellipsis">(${g.avo_nm})</span>
                                            <span class="bar">|</span>
                                        </c:if>
                                        <div class="icon">
                                            <c:if test="${g.camp_ch eq 'CH01'}"><img src="/image/ico_edm.png"
                                                                                     alt=""/></c:if>
                                            <c:if test="${g.camp_ch eq 'CH02'}"><img src="/image/ico_mobile.png"
                                                                                     alt=""/></c:if>
                                        </div>
                                        <c:if test="${!empty g.team_nm}">
                                            <span>팀 명 : ${g.team_nm}</span>
                                        </c:if>
                                    </div>
                                </dt>
                                <dd>
                                    <div class="cf">
                                        <div class="row_graph cf">
                                            <div class="th">대기</div>
                                            <div class="td cf">
                                                <c:choose>
                                                    <c:when test="${dto.pro_st eq '03' or dto.pro_st eq '04'}">
                                                        <div class="chart" name="progress1"
                                                             data="${sendCnt[camp_id].w_cnt/sendCnt[camp_id].t_cnt}"></div>
                                                        <div class="detail">
                                                            <span class="number en_font"><fmt:formatNumber
                                                                    value="${sendCnt[camp_id].w_cnt}"
                                                                    pattern="#,###"/></span>
                                                            <span class="percents en_font">(<fmt:formatNumber
                                                                    type="percent" pattern="0.00%"
                                                                    value="${sendCnt[camp_id].w_cnt/sendCnt[camp_id].t_cnt}"/>)</span>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="chart" name="progress1" data="1"></div>
                                                        <div class="detail">
                                                            <span class="number en_font"><fmt:formatNumber
                                                                    value="${sendCnt[camp_id].w_cnt}"
                                                                    pattern="#,###"/></span>
                                                            <span class="percents en_font">(100%)</span>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="cf">
                                        <div class="row_graph cf">
                                            <div class="th">성공</div>
                                            <div class="td cf">
                                                <c:choose>
                                                    <c:when test="${dto.pro_st eq '03'}">
                                                        <div class="chart" name="progress2"
                                                             data="${sendCnt[camp_id].s_cnt/sendCnt[camp_id].t_cnt}"></div>
                                                        <div class="detail">
                                                            <span class="number en_font"><fmt:formatNumber
                                                                    value="${sendCnt[camp_id].s_cnt}"
                                                                    pattern="#,###"/></span>
                                                            <span class="percents en_font">(<fmt:formatNumber
                                                                    type="percent" pattern="0.00%"
                                                                    value="${sendCnt[camp_id].s_cnt/sendCnt[camp_id].t_cnt}"/>)</span>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="chart" name="progress2" data="0"></div>
                                                        <div class="detail">
                                                            <span class="number en_font">0</span>
                                                            <span class="percents en_font">(0.00%)</span>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="row_graph cf">
                                            <div class="th">실패</div>
                                            <div class="td cf">
                                                <c:choose>
                                                    <c:when test="${dto.pro_st eq '03'}">
                                                        <div class="chart" name="progress3"
                                                             data="${sendCnt[camp_id].f_cnt/sendCnt[camp_id].t_cnt}"></div>
                                                        <div class="detail">
                                                            <span class="number en_font"><fmt:formatNumber
                                                                    value="${sendCnt[camp_id].f_cnt}"
                                                                    pattern="#,###"/></span>
                                                            <span class="percents en_font">(<fmt:formatNumber
                                                                    type="percent" pattern="0.00%"
                                                                    value="${sendCnt[camp_id].f_cnt/sendCnt[camp_id].t_cnt}"/>)</span>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="chart" name="progress3" data="0"></div>
                                                        <div class="detail">
                                                            <span class="number en_font">0</span>
                                                            <span class="percents en_font">(0.00%)</span>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="cf">
                                        <div class="row_graph cf">
                                            <div class="th">오픈</div>
                                            <div class="td cf">
                                                <!-- progress 영역 -->
                                                <div class="chart" name="progress4" data="${openCnt[camp_id].cnt/g.send_cnt}"></div>
                                                <div class="detail">
                                                   <span class="number en_font">
                                                   <c:choose>
                                                       <c:when test="${empty openCnt[camp_id]}">0</c:when>
                                                       <c:otherwise><fmt:formatNumber value="${openCnt[camp_id].cnt}" pattern="#,###" /></c:otherwise>
                                                   </c:choose>
                                                   </span>
                                                    <span class="percents en_font">(<fmt:formatNumber type="percent" pattern="0.00%" value="${openCnt[camp_id].cnt/g.send_cnt}" />)</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row_graph cf">
                                            <div class="th">클릭</div>
                                            <div class="td cf">
                                                <div class="chart" name="progress5" data="${trackCnt[camp_id].cnt/g.send_cnt}"></div>
                                                <div class="detail">
                                                     <span class="number en_font">
                                                     <c:choose>
                                                         <c:when test="${empty trackCnt[camp_id]}">0</c:when>
                                                         <c:otherwise><fmt:formatNumber value="${trackCnt[camp_id].cnt}" pattern="#,###" /></c:otherwise>
                                                     </c:choose>
                                                     </span>
                                                    <span class="percents en_font">(<fmt:formatNumber type="percent" pattern="0.00%" value="${trackCnt[camp_id].cnt/g.send_cnt}" />)</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </dd>
                            </dl>
                        </c:forEach>
                        <div class="bottom">
                            <c:if test="${dto.pro_st eq '03'}">
                                <div class="bottom_notice on cf" id="timerNotice">
                                    <p>*발송 시작 시간 전까지만 취소가 가능합니다.</p>
                                    <div class="timer en_font" id="timer"></div>
                                    <div class="close">닫기</div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>

                <div class="article">
                    <div class="top">
                        <span class="slash">캠페인 상세 정보</span>
                    </div>
                    <div class="area">
                        <div class="left" style="width: 95%">
                            <!-- 발송단가 영역 시작 -->
                            <div class="price">
                                <input type="button" class="btn_sm_line size" value="발송단가 확인하기" onclick="isShowPrice(true)">
                                <div class="price_detail" id="price_detail_div" hidden>
                                    <input type="button" value="닫기" class="btn_pop_close sm" onclick="isShowPrice(false)">
                                    <div class="cf">
                                        <table class="pop_table_type2 width1 margin">
                                            <thead>
                                            <tr>
                                                <th class="en_font">Email</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <tr>
                                                <td><span class="en_font">${priceLst[0].cd_desc}</span>원</td>
                                            </tr>
                                            </tbody>
                                        </table>
                                        <table class="pop_table_type2 width2 margin">
                                            <thead>
                                            <tr>
                                                <th class="en_font">알림톡</th>
                                                <th class="en_font">친구톡(txt)</th>
                                                <th class="en_font">친구톡(img)</th>
                                                <th class="en_font">친구톡(wid)</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <tr>
                                                <td><span class="en_font">${priceLst[1].cd_desc}</span>원</td>
                                                <td><span class="en_font">${priceLst[2].cd_desc}</span>원</td>
                                                <td><span class="en_font">${priceLst[3].cd_desc}</span>원</td>
                                                <td><span class="en_font">${priceLst[4].cd_desc}</span>원</td>
                                            </tr>
                                            </tbody>
                                        </table>
                                        <table class="pop_table_type2">
                                            <colgroup>
                                                <col width="25%"/>
                                                <col width="25%"/>
                                                <col width="25%"/>
                                                <col width="25%"/>
                                            </colgroup>
                                            <thead>
                                            <tr>
                                                <th class="en_font">SMS/RCS SMS</th>
                                                <th class="en_font">LMS/RCS LMS</th>
                                                <th class="en_font">MMS/RCS MMS</th>
                                                <th><span class="en_font">RCS</span> 템플릿</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <tr>
                                                <td><span class="en_font">${priceLst[5].cd_desc}</span>원</td>
                                                <td><span class="en_font">${priceLst[7].cd_desc}</span>원</td>
                                                <td><span class="en_font">${priceLst[9].cd_desc}</span>원</td>
                                                <td><span class="en_font">${priceLst[11].cd_desc}</span>원</td>
                                            </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="sub_text">
                                        ※ RCS/카카오/문자 비용은 타겟 수의 1:3:6 비율로 측정됩니다.<br/>
                                        ※ 실제 발송 비용과 다를 수 있습니다.
                                    </div>
                                </div>
                            </div>
                            <!-- 발송단가 영역 끝 -->

                            <table class="pop_table_type3">
                                <colgroup>
                                    <col width="1"/>
                                    <col width="80"/>
                                    <col width="100"/>
                                    <col width="100"/>
                                    <col width="*"/>
                                </colgroup>
                                <thead>
                                <tr>
                                    <th class="en_font">NO</th>
                                    <th>타겟 설정</th>
                                    <th>컨텐츠 설정</th>
                                    <th>시간 설정</th>
                                    <th>예상 발송 비용</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="g" items="${campLst}" varStatus="st">
                                    <c:set var="camp_id">${g.seq}</c:set>
                                    <c:set var="cont_id">${g.cont_id}</c:set>
                                    <tr>
                                        <td class="en_font">${st.count}</td>
                                        <td>
                                            <div><span class="ellipsis name">${g.camp_nm}</span> <span style="text-align: center; display: block;">(<fmt:formatNumber value="${g.send_cnt}" pattern="#,###" />명)</span></div>
                                            <c:choose>
                                                <c:when test="${empty targetDto}"><div><span class="th">계산일 : </span><span class="en_font">${cutil:getDateTimeNow()}</span></div></c:when>
                                                <c:otherwise><div><span class="th">계산일 : </span><span class="en_font">${cutil:stringDatetimeParse(targetDto.reg_dt)}</span></div></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div>
                                                <span class="ellipsis conts_name bar">${contLst[cont_id].cont_nm}</span>
                                                <span>
                                            <c:if test="${g.camp_ch eq 'CH01'}"><img src="/image/ico_edm.png" alt=""/></c:if>
                                            <c:if test="${g.camp_ch eq 'CH02'}"><img src="/image/ico_mobile.png" alt=""/></c:if>
                                        </span>
                                            </div>
                                            <div>
                                                <input type="button" value="컨텐츠 미리보기" class="btn_sm_line size" onclick="preView('${g.cont_id}')"/>
                                            </div>
                                        </td>
                                        <td>
                                            <div style="width: 130px;">
                                        <span class="bar">
                                        <c:choose>
                                            <c:when test="${g.sto eq '02'}">시간 최적화</c:when>
                                            <c:when test="${g.sto eq '03'}">요일 최적화</c:when>
                                            <c:otherwise>일괄 발송
                                            </c:otherwise>
                                        </c:choose>
                                        </span>
                                                <c:choose>
                                                    <c:when test="${g.send_st_tp eq '0'}"><span class="bar">예약발송</span></c:when>
                                                    <c:otherwise><span class="bar">즉시발송</span></c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div>
                                                <span class="en_font">${cutil:stringDatetimeParse(g.start_dt)}</span>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="en_font">0</span>원
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>

                    </div>
                </div>
                <div class="article">
                    <div class="top">
                        <span class="slash">컨텐츠 미리보기</span>
                    </div>
                    <div class="area">
                        <div class="view" id="tpreview"></div>
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

<!-- 상세 조건 보기 팝업 영역 시작 -->
<%--<div class="layer_pop" id="detailPopup">
    <div class="pop_container popup_size8">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
        <div class="pop_title">캠페인 상세 조건 보기 <span class="bar">|</span>
            <span class="ellipsis">${dto.pro_nm}</span></div>
        <div class="pop_inner padding_none">
            <div class="condition_area cf">
                <div class="left">
                    <table class="pop_table_type3">
                        <colgroup>
                            <col width="50"/>
                            <col width="195"/>
                            <col width="245"/>
                            <col width="195"/>
                            <col width="*"/>
                        </colgroup>
                        <thead>
                            <tr>
                                <th class="en_font">NO</th>
                                <th>타겟 설정</th>
                                <th>컨텐츠 설정</th>
                                <th>시간 설정</th>
                                <th>예상 발송 비용</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="g" items="${campLst}" varStatus="st">
                                <c:set var="camp_id">${g.seq}</c:set>
                                <c:set var="cont_id">${g.cont_id}</c:set>
                            <tr>
                                <td class="en_font">${st.count}</td>
                                <td>
                                    <div><span class="ellipsis name">${g.camp_nm}</span> <span>(<fmt:formatNumber value="${g.send_cnt}" pattern="#,###" />명)</span></div>
                                    <c:choose>
                                        <c:when test="${empty targetDto}"><div><span class="th">계산일 : </span><span class="en_font">${cutil:getDateTimeNow()}</span></div></c:when>
                                        <c:otherwise><div><span class="th">계산일 : </span><span class="en_font">${cutil:stringDatetimeParse(targetDto.reg_dt)}</span></div></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div>
                                        <span class="ellipsis conts_name bar">${contLst[cont_id].cont_nm}</span>
                                        <span>
                                            <c:if test="${g.camp_ch eq 'CH01'}"><img src="/image/ico_edm.png" alt=""/></c:if>
                                            <c:if test="${g.camp_ch eq 'CH02'}"><img src="/image/ico_mobile.png" alt=""/></c:if>
                                        </span>
                                    </div>
                                    <div>
                                        <input type="button" value="컨텐츠 미리보기" class="btn_sm_line size" onclick="preView('${g.cont_id}')"/>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <span class="bar">
                                        <c:choose>
                                            <c:when test="${g.sto eq '02'}">시간 최적화</c:when>
                                            <c:when test="${g.sto eq '03'}">요일 최적화</c:when>
                                            <c:otherwise>일괄 발송
                                            </c:otherwise>
                                        </c:choose>
                                        </span>
                                        <c:choose>
                                            <c:when test="${g.send_st_tp eq '0'}"><span class="bar">예약발송</span></c:when>
                                            <c:otherwise><span class="bar">즉시발송</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div>
                                        <span class="en_font">${cutil:stringDatetimeParse(g.start_dt)}</span>
                                    </div>
                                </td>
                                <td>
                                    <span class="en_font">0</span>원
                                </td>
                            </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <!-- 발송단가 영역 시작 -->
                    <div class="price">
                        <input type="button" class="btn_sm_line size" value="발송단가 확인하기" id="btn_price">
                        <div class="price_detail">
                            <h4>발송단가</h4>
                            <div class="cf">
                                <table class="pop_table_type2 width1 margin">
                                    <thead>
                                    <tr>
                                        <th class="en_font">Email</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td><span class="en_font">0</span>원</td>
                                    </tr>
                                    </tbody>
                                </table>
                                <table class="pop_table_type2 width2 margin">
                                    <thead>
                                    <tr>
                                        <th class="en_font">Kakao(img)</th>
                                        <th class="en_font">MMS</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td><span class="en_font">0</span>원</td>
                                        <td><span class="en_font">0</span>원</td>
                                    </tr>
                                    </tbody>
                                </table>
                                <table class="pop_table_type2 width2">
                                    <thead>
                                    <tr>
                                        <th class="en_font">Kakao</th>
                                        <th class="en_font">LMS</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td><span class="en_font">0</span>원</td>
                                        <td><span class="en_font">0</span>원</td>
                                    </tr>
                                    </tbody>
                                </table>
                                <table class="pop_table_type2">
                                    <colgroup>
                                        <col width="25%"/>
                                        <col width="25%"/>
                                        <col width="25%"/>
                                        <col width="25%"/>
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th class="en_font">SMS/RCS SMS</th>
                                        <th class="en_font">LMS/RCS LMS</th>
                                        <th class="en_font">MMS/RCS MMS</th>
                                        <th><span class="en_font">RCS</span> 템플릿</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td><span class="en_font">0</span>원</td>
                                        <td><span class="en_font">0</span>원</td>
                                        <td><span class="en_font">0</span>원</td>
                                        <td><span class="en_font">0</span>원</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <!-- 발송단가 영역 끝 -->
                    <div class="sub_text">
                        ※ RCS/카카오/문자 비용은 타겟 수의 1:3:6 비율로 측정됩니다.<br/>
                        ※ 실제 발송 비용과 다를 수 있습니다.
                    </div>
                    <!-- 버튼 영역 -->
                    <div class="btn_row">
                        <input type="button" class="btn_bg btn_size2 btn_center" value="확인" onclick="popupClose(this);"/>
                    </div>
                </div>
                <div class="right">
                    <div class="row">
                        <span class="ellipsis">${dto.pro_nm} </span>미리보기
                    </div>
                    <div class="view" id="tpreview"></div>
                </div>
            </div>
        </div>
    </div>
</div>--%>
<!-- 상세 조건 보기 팝업 영역 끝 -->

<!-- 캠페인 발송실패 문의 팝업 영역 시작 -->
<div class="layer_pop" id="sendFailPopup">
    <div class="pop_container popup_size1">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
        <div class="pop_title">캠페인 발송실패 문의</div>
        <form:form id="mailForm" method="post" action="/camp/inquirySend.service">
        <input type="hidden" name="pro_id" value="${dto.pro_id}"/>
        <div class="pop_inner">
            <table class="pop_table_type1">
                <colgroup>
                    <col width="102"/>
                    <col width="*"/>
                </colgroup>
                <tbody>
                <tr>
                    <th>캠페인명</th>
                    <td>${dto.pro_nm}</td>
                </tr>
                <tr>
                    <th>제목</th>
                    <td><input type="text" id="failSubject" name="subject"/></td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td><textarea id="failMsg" name="msg" cols="30" rows="10"></textarea></td>
                </tr>
                </tbody>
            </table>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_inline" id="mailSend" value="보내기"/>
                <input type="button" class="btn_bg2 btn_size2 btn_inline" id="mailCancel" value="취소"/>
            </div>
        </div>
        </form:form>
    </div>
</div>
<!-- 캠페인 발송실패 문의 팝업 영역 끝 -->

<!-- alert 팝업 Type1 -->
<div class="layer_pop alert" id="type1">
    <div class="pop_container popup_size3">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
        <div class="pop_title"></div>
        <div class="pop_inner">
            <div class="alert_txt">
                문구 영역
            </div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_center" onclick="popupClose(this);" value="확인" />
            </div>
        </div>
    </div>
</div>

<!-- alert 팝업 Type2 -->
<div class="layer_pop alert" id="type2">
    <div class="pop_container popup_size3">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
        <div class="pop_title"></div>
        <div class="pop_inner">
            <div class="alert_txt">
                문구 영역
            </div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_inline" onclick="popupClose(this);" value="확인" />
                <input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소" />
            </div>
        </div>
    </div>
</div>

<script>
    let check = false;
    let isProcess = true;
    let isDelProcess = true;
    let barArr = new Array();
    let curArr;
    let index,prg1,prg2,prg3,prg4,prg5;
    <c:forEach var="cammp" items="${campLst}" varStatus="st">
    index = ${st.index}
    barArr[index] = new Array();
    curArr = barArr[index];

    // 대기 progress.js
    prg1 = $(`[name="progress1"]`)[index]
    curArr[0] = new ProgressBar.Line(prg1, {
        strokeWidth: 4,
        easing: 'easeInOut',
        duration: 1400,
        color: '#b0e1dc',
        trailColor: '#f4f4f4',
        trailWidth: 4,
        svgStyle: { width: '100%', height: '7px' }
    });

    // 성공 progress.js
    prg2 = $(`[name="progress2"]`)[index]
    curArr[1] = new ProgressBar.Line(prg2, {
        strokeWidth: 4,
        easing: 'easeInOut',
        duration: 1400,
        color: '#87a8e1',
        trailColor: '#f4f4f4',
        trailWidth: 4,
        svgStyle: { width: '100%', height: '7px' }
    });

    // 실패 progress.js
    prg3 = $(`[name="progress3"]`)[index]
    curArr[2]  = new ProgressBar.Line(prg3, {
        strokeWidth: 4,
        easing: 'easeInOut',
        duration: 1400,
        color: '#eda7b3',
        trailColor: '#f4f4f4',
        trailWidth: 4,
        svgStyle: { width: '100%', height: '7px' }
    });
    // 오픈 progress.js
    prg4 = $(`[name="progress4"]`)[index]
    curArr[3]  = new ProgressBar.Line(prg4, {
        strokeWidth: 4,
        easing: 'easeInOut',
        duration: 1400,
        color: '#b7d9a7',
        trailColor: '#f4f4f4',
        trailWidth: 4,
        svgStyle: { width: '100%', height: '7px' }
    });
    // 클릭 progress.js
    prg5 = $(`[name="progress5"]`)[index]
    curArr[4] = new ProgressBar.Line(prg5, {
        strokeWidth: 4,
        easing: 'easeInOut',
        duration: 1400,
        color: '#aecff1',
        trailColor: '#f4f4f4',
        trailWidth: 4,
        svgStyle: { width: '100%', height: '7px' }
    });
    </c:forEach>

    <c:if test="${dto.pro_st eq '01' or dto.pro_st eq '03'}">
    <c:set var="tt" value="${cutil:stringDatetimeMap(startDt)}" />
    //발송 취소 가능 시간 Timer
        let countDate = new Date(${tt['year']}, ${tt['month']}, ${tt['day']}, ${tt['h']}, ${tt['m']}, ${tt['s']}).getTime();
        let x = setInterval(function() {
        // 오늘 날짜
        let now = new Date().getTime();
        // 종료일자에서 현재일자를 뺀 시간
        let distance = countDate - now;
        // 각 변수에 일, 시, 분, 초를 등록
        let d = Math.floor(distance / (1000 * 60 * 60 * 24));
        let h = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        let m = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        let s = Math.floor((distance % (1000 * 60)) / 1000);
        //HTML코드에 내용 삽입
        if(distance <= 0){
            document.getElementById("timer").innerHTML = "00:00:00";
        } else{
            if(d != 0){
                document.getElementById("timer").innerHTML = d + "일&nbsp;" + h +":"+ m +":"+ s;
            }else{
                document.getElementById("timer").innerHTML = h +":"+ m +":"+ s;
            }
        }
    },1000);
    </c:if>

    $(function(){
        // 발송대기, 타겟추출 안내 영역 닫기 동작
        $('.bottom_notice .close').on('click',function(){
            $(this).parents().removeClass('on');
        });
        // 발송 단가 확인 버튼
        $('#btn_price').on('click',function(){
            $('.price_detail').toggleClass('on');
        });

        $("#rejectSend").click(function(){
            if($('#message').val().trim().length > 0){
                $("#rejectForm").submit();
            }else {
                popup.popAlert("승인반려 사유를 작성해 주세요.");
            }
        });

        $("#mailSend").click(function(){
            if(!$("#failSubject").val()){
                popup.popAlert("문의 메일 제목을 입력해주세요.");
                return;
            }
            if($("#failMsg").val().trim().length < 1){
                popup.popAlert("문의 메일 내용을 입력해주세요.");
                return;
            }
            $("#mailForm").submit();
        });

        $("#mailCancel").click(function(){
            popup.confirmAlertCallback("입력하신 문의 내용이 관리자에게 전송되지 않으며, 입력하신 내용은 저장되지 않습니다.", "mailCancelOk(this)");
        });


        <c:if test="${dto.pro_st eq '01' or dto.pro_st eq '02' or dto.pro_st eq '03'}">
        for(tempIdx in barArr){
            campBarArr = barArr[tempIdx];
            for(idx in campBarArr){
                idx =parseInt(idx);
                let bar = $(`[name='progress`+(idx+1)+`']`)[tempIdx]
                campBarArr[idx].animate(Number($(bar).attr('data')));
            }
        }
        </c:if>

        <c:if test="${dto.pro_st eq '04' or dto.pro_st eq '99'}">

        for(tempIdx in barArr){
            campBarArr = barArr[tempIdx];
            for(idx in campBarArr){
                idx =parseInt(idx);
                let bar = $(`[name='progress`+(idx+1)+`']`)[tempIdx]
                campBarArr[idx].animate(Number($(bar).attr('data')));
            }
        }

        </c:if>
    });

    //조건보기 팝업 open
    function detailPopup(){
        check = true;
        $('#detailPopup').addClass('active');
    }

    //승인반려 팝업 open
    function failPopup(){
        $('#failPopup').addClass('active');
    }

    //캠페인 발송실패 문의 팝업
    function sendFailPopup(){
        $('#sendFailPopup').addClass('active');
    }

    function preView(cont_id){
        const res = function(response){
            const $doc = new DOMParser().parseFromString(response, "text/html");
            $("#tpreview").html($("#preview", $doc).html());
            new Swiper("#preview_slideSwiper", {
                direction: 'horizontal',
                pagination: {
                    el: '#preview_rcs_paging',
                    type: 'fraction',
                },
                navigation: {
                    nextEl: '#preview_rcs_next',
                    prevEl: '#preview_rcs_prev',
                },
            });
        };
        let data = [];
        data.push({name : "cont_id" , value : cont_id});
        com_ajax.ajax('post', '/camp/sendCampContPreview.ajax', data, res);
    }

    function chagneCamp(pro_id){
        popup.confirmAlertCallback("승인요청 상태의 캠페인을 변경하시겠습니까?<br/>요청 시 승인 담당자에게 캠페인 변경으로 인한 승인요청 취소 안내 메일이 발송됩니다.", "chagneCampOk('"+ pro_id +"')");
    }

    function chagneCampOk(pro_id){
        if(isProcess){
            isProcess = false;
            const res = function(response){
                if(response){
                    location.href = '/camp/sendSetting.mi?pid=' + pro_id;
                }else{
                    popup.popAlert("시스템 오류로 인해 캠페인 변경이 불가 합니다.<br/>관리자에게 문의 바랍니다.");
                    isProcess = true;
                }
            };
            let data = [];
            data.push({name : "pro_id" , value : pro_id});
            com_ajax.ajax('post', '/camp/changeCamp.ajax', data, res);
        }
    }

    function approved(pro_id){
        if(check){
            popup.confirmAlertCallback("캠페인 발송 조건을 모두 확인하셨습니까?<br/>승인 시 캠페인이 발송대기 상태로 변경됩니다", "approvedOk('"+ pro_id +"')");
        }else{
            popup.popAlert("캠페인 발송 조건보기 후 승인이 가능합니다.");
        }
    }

    function approvedOk(pro_id){
        if(isProcess){
            isProcess = false;
            const res = function(response){
                if(response){
                    popup.popAlertCallback("승인 되었습니다.", "window.location.reload();");
                }else{
                    popup.popAlert("시스템 오류로 인해 캠페인 승인 불가 합니다.<br/>관리자에게 문의 바랍니다.");
                    isProcess = true;
                }
            };
            let data = [];
            data.push({name : "pro_id" , value : pro_id});
            com_ajax.ajax('post', '/camp/apprCamp.ajax', data, res);
        }
    }

    <c:if test="${dto.reg_id eq user.usr_id or dto.appr_id eq user.usr_id}">
    function campCancel(pro_id){
        <c:if test="${dto.reg_id eq user.usr_id}">
        popup.confirmAlertCallback("승인 완료된 캠페인을 승인 취소 하시겠습니까?<br/>취소 시 승인 담당자에게 승인 취소 이메일이 발송되며, 승인대기 상태로 전환됩니다.", "campCancelOk('"+ pro_id +"', '0', this)");
        </c:if>
        <c:if test="${dto.appr_id eq user.usr_id}">
        popup.confirmAlertCallback("승인 완료된 캠페인을 승인 취소 하시겠습니까?<br/>취소 시 캠페인 담당자에게 승인 취소 이메일이 발송되며, 승인대기 상태로 전환됩니다.", "campCancelOk('"+ pro_id +"', '1', this)");
        </c:if>
    }

    function campCancelOk(pro_id, gbn, e){
        if(isProcess){
            isProcess = false;
            const res = function(response){
                if(response.status){
                    popup.popAlertCallback("캠페인이 취소 되었습니다.", "window.location.reload();");
                }else{
                    popup.popAlert(response.message);
                    isProcess = true;
                }
            };
            let data = [];
            data.push({name : "pro_id" , value : pro_id});
            data.push({name : "gbn" , value : gbn});
            com_ajax.ajax('post', '/camp/cancelCamp.ajax', data, res);
            popupClose(e);
        }
    }
    </c:if>

    <c:if test="${dto.pro_st eq '98'}">
    function campDel(pro_id){
        popup.confirmAlertCallback("해당 캠페인을 삭제 하시겠습니까?<br/>삭제 시 다시 복구가 불가능 합니다.", "campDelOk('"+ pro_id +"', this)");
    }

    function campDelOk(pro_id){
        if(isDelProcess){
            isDelProcess = false;
            const res = function(response){
                if(response.status){
                    popup.popAlertCallback("캠페인이 삭제 되었습니다.", "location.href = '/camp/st/sendStatus.mi';");
                }
            }
            let data = [];
            data.push({name : "pro_id" , value : pro_id});
            com_ajax.ajax('post', '/camp/delCamp.ajax', data, res);
        }
    }
    </c:if>

    <c:if test="${dto.pro_st eq '03' or dto.pro_st eq '04'}">
    function detailDown() {
        let frm = common.create_form('dummy', 'POST', '/camp/getSendHstDown.service', 'popup_down');
        common.add_input(frm, "pid", '${dto.pro_id}');
        let message = '<!DOCTYPE html><html lang="ko"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><meta http-equiv="X-UA-Compatible" content="ie=edge"><title>miCRM</title></head><body><img src="/image/excelDown.jpg" alt="" style="width:100%;"></body></html>';
        common.popview('', 'popup_down', '661', '423', message);
        document.body.insertBefore(frm, null);
        frm.submit();
        frm.remove();
    }
     </c:if>

    function mailCancelOk(e){
        $("#failSubject").val("");
        $("#failMsg").val("");
        popupClose(e);
        $("#sendFailPopup").removeClass('active');
    }

    function isShowPrice(show){
        if(show){
            $('#price_detail_div').show();
        } else {
            $('#price_detail_div').hide();
        }
    }
</script>