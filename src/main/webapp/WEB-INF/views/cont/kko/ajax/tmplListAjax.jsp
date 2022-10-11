<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<%@ taglib prefix="cutil" uri="tld/Commonutils.tld" %>
<%@ taglib uri="/WEB-INF/tlds/Page.tld" prefix="ui" %>

<span id="body">
<c:choose>
    <c:when test="${not empty list}">
        <c:forEach var="tmpl" items="${list}">
            <c:if test="${tmpl.use_yn eq 'Y'}" >
                <div class="column template_div" style="height: 632px;" >
            </c:if>
            <c:if test="${tmpl.use_yn eq 'N'}">
                <div class="column template_div off" style="height: 632px;">
            </c:if>
                    <!-- 비활성화 cover -->
                <div class="hidden_cover"></div>
                <div class="sms_head bg_color cf">
                    <!-- 체크박스 -->
                    <label class="custom_check1">
                        <input type="checkbox" name="tmpl_cd" value="${tmpl.tmpl_nm}" data="${tmpl.tmpl_cd}"/>
                        <span></span>
                    </label>
                    <ul class="sms_type cf">
                        <li>${tmpl.kep_status_nm}</li>
                    </ul>
                </div>
                <div class="row_top cf sms_head">
                    <!-- 제목 -->
                    <%--<h4>${content.cont_sub}</h4>--%>
                    <h4 style="width: 65%;">${tmpl.tmpl_nm}</h4>
                    <div class="remove_info">
                            <input type="button" value="${tmpl.use_yn}" class="en_font useState" onclick="updateUseState(${tmpl.seq}, this);">
                        <a href="/cont/kko/tmplDetail.mi?seq=${tmpl.seq}">수정</a>
                    </div>
                   <%-- <c:choose>
                        <c:when test="${content.msg_tp eq 'DMCH211' || content.msg_tp eq 'DMCH212'}">
                            <h4>${content.slideTitle[0]}</h4>
                        </c:when>
                        <c:otherwise>
                            <h4>${content.cont_sub}</h4>
                        </c:otherwise>
                    </c:choose>--%>
                </div>
                <!-- 카카오톡  -->
                    <div class="row_body template_body">
                        <input type="text" name="tmpl_seq" value="${tmpl.seq}"  hidden/>
                        <div class="round_box" >
                            <div class="round_box head">
                                <p>알림톡 도착</p>
                            </div>
                            <div class="at_tmpl_data">
                                <!-- 이미지형  아이템리스트형 -->
                                <c:if test="${tmpl.tmpl_empsize_tp eq 'ITEM_LIST'  || tmpl.tmpl_empsize_tp eq 'IMAGE'}">
                                    <c:if test="${!empty tmpl.img_seq}">
                                        <div class="kko_img_box">
                                            <img src="${tmpl.kko_img_url}"
                                                 onerror="this.src = '/image/bg_none.png'" alt="">
                                        </div>
                                    </c:if>
                                </c:if>
                                 <div class="at_msg_cont">
                                    <%--  강조유형 강조표기형 --%>
                                    <c:if test="${tmpl.tmpl_empsize_tp eq 'TEXT'}">
                                        <div class="tmpl_subtit">${tmpl.tmpl_subtit}</div>
                                        <div class="tmpl_tit">${tmpl.tmpl_tit}</div>

                                    </c:if>
                                    <%--  강조유형 아이템리스트형 --%>
                                    <c:if test="${tmpl.tmpl_empsize_tp eq 'ITEM_LIST'}">
                                        <c:if test="${!empty tmpl.item_highlight_json}">
                                            <c:set var="highlight" value="${tmpl.highlight_json}"/>
                                            <div class="tmpl_header">${tmpl.tmpl_header}</div>
                                            <div>
                                                    <div class="tmpl_high">
                                                        <div>${highlight.title}</div>
                                                        <div class="tmpl_subtit">${highlight.description}</div>
                                                    </div>
                                                    <c:if test="${fn:contains(tmpl.item_highlight_json,'\"imageUrl\"')}">
                                                        <div class="right_img_box"><img src="${highlight.imageUrl}"
                                                                                        onerror="this.src = '/image/bg_none.png'"
                                                                                        alt=""></div>
                                                    </c:if>
                                                   </div>
                                        </c:if>
                                        <c:if test="${fn:contains(tmpl.item_json,'\"list\"')}">
                                                <div class="item_table">
                                                    <c:forEach var="item" items="${tmpl.item_list_json.list}">
                                                        <div>
                                                            <span class="th">${item.title}</span>
                                                            <span class="td">${item.description}</span>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                        </c:if>

                                    </c:if>
                                     <div class="cont">${tmpl.tmpl_cont}</div>
<%--                                         부가 정보--%>
                                        <c:if test="${tmpl.tmpl_msg_tp eq 'EX'}">
                                            <div class="etx">${tmpl.tmpl_ext}</div>
                                        </c:if>
                                         <c:if test="${tmpl.tmpl_msg_tp eq 'AD'}">
                                             <div class="ad">${tmpl.tmpl_ad}</div>
                                         </c:if>

                                 </div>
                                 <c:if test="${!empty tmpl.button_json}">
                                     <c:forEach var="btn" items="${tmpl.btn_json}">
                                         <c:if test="${btn.linkType eq 'AC'}">
                                             <a class="sms_btn kakao_yellow">${btn.name}</a>
                                         </c:if>
                                         <c:if test="${btn.linkType ne 'AC'}">
                                             <a href="${btn.linkPc}" target="_blank" class="sms_btn">${btn.name}</a></c:if>
                                     </c:forEach>
                                 </c:if>
                            </div>
<%--                            <input type="hidden" class="kakao_txt" name="kakao_body" value="${tmpl.tmpl_cont}">--%>

                        </div>
                    </div>
                <div class="row_footer">
                    <!-- 수정일 -->
                    <div class="date">수정일&nbsp;&nbsp;
                        <span>
                                ${cutil:stringDateParse(tmpl.upd_dt)}
                        </span>
                    </div>
                    <!-- 등록일 -->
                    <div class="date">등록일&nbsp;&nbsp;
                        <span>
                                ${cutil:stringDateParse(tmpl.reg_dt)}
                        </span>
                    </div>
                </div>
            </div>
        </c:forEach>
        <input type="hidden" id="nowPageNo" name="nowPageNo" value="${pageNo}"/>
    </c:when>
    <c:otherwise>

    </c:otherwise>
</c:choose>
</span>
<span id="pager">
<div class="btn_row bottom-border">
                            <ul class="pager" id="pagingDom">
                                <ui:pagination paginationInfo="${page}" type="image" jsFunction="tmplListPaging"/>
                            </ul>
                        </div>
</span>

<span id="pageHtml">
    <c:choose>
        <c:when test="${nextCk eq true}">
        <div class="btn_more" onclick="getMobileListAdd('${pageNo}');"><img src="/image/bullet_arrw1.png"
                                                                            alt=""/>더보기</div>
        </c:when>
        <c:otherwise>
            <c:if test="${empty list}">
                <div class="none list_ht bottom-border">
                    조회된 결과가 없습니다.
            </div>
            </c:if>
        </c:otherwise>
    </c:choose>
</span>
