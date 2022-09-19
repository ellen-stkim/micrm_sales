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
            <c:if test="${tmpl.use_yn eq 'Y'}">
                <div class="column size2">
            </c:if>
            <c:if test="${tmpl.use_yn eq 'N'}">
                <div class="column off size2">
            </c:if>
                    <!-- 비활성화 cover -->
                <div class="hidden_cover"></div>
                <div class="sms_head bg_color cf">
                    <!-- 체크박스 -->
                    <label class="custom_check1">
                        <input type="checkbox" name="list" value="${tmpl.seq}"/><span></span></label>
                    <ul class="sms_type cf">
                        <li>검수 승인</li>
                    </ul>
                </div>
                <div class="row_top cf">
                    <!-- 컨텐츠 type -->
                    <div class="contents_type">광고</div>
                    <!-- 제목 -->
                    <%--<h4>${content.cont_sub}</h4>--%>
                    <h4>${tmpl.tmpl_nm}</h4>
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
                    <c:if test="${not empty tmpl.tmpl_img_url}">
                        <div class="row_body">
                            <div class="round_box">
                                <div class="sms">
                                    <img src="${filePath}${tmpl.kko_image_url}"
                                         onerror="this.src = '/image/bg_none.png'" alt="">
                                </div>
                                <p class="sms_txt">${tmpl.tmpl_cont}</p>
                                <a href="https://milvus.co.kr" target="_blank" class="sms_btn">milvus</a>
                            </div>
                    </div>
                    </c:if>
                    <c:if test="${empty tmpl.tmpl_img_url}">
                      <div class="row_body">
                        <div class="round_box">
                            <div class="sms_txt">
                                    ${tmpl.tmpl_cont}
                            </div>
                            <a href="https://milvus.co.kr" target="_blank" class="sms_btn">milvus</a>
                        </div>
                      </div>
                    </c:if>
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
                                <ui:pagination paginationInfo="${page}" type="image" jsFunction="linkPage"/>
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
