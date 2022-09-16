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
<span id="mobileLstDom">
<c:choose>
    <c:when test="${not empty list}">
        <c:forEach var="content" items="${list}">
            <c:if test="${content.use_yn eq 'Y'}">
                <div class="column" style="border-bottom: none;">
            </c:if>
            <c:if test="${content.use_yn eq 'N'}">
                <div class="column off">
            </c:if>
                <!-- 비활성화 cover -->
                <div class="hidden_cover"></div>
                <div class="sms_head bg_color cf">
                    <!-- 체크박스 -->
                    <label class="custom_check1">
                        <input type="radio" name="list" value="${content.seq}"/><span></span></label>
                    <ul class="sms_type cf">
                        <c:forEach items="${fn:split(content.msg_tp_lst,',')}" var="title">
                            <c:if test="${title eq 'DMCH205' || title eq 'DMCH206'}">
                                <li>RCS 텍스트형</li>
                            </c:if>
                            <c:if test="${title eq 'DMCH207'}">
                                <li>RCS 세로형 Tall</li>
                            </c:if>
                            <c:if test="${title eq 'DMCH208'}">
                                <li>RCS 세로형 Medium</li>
                            </c:if>
                            <c:if test="${title eq 'DMCH209'}">
                                <li>RCS 가로형 Left</li>
                            </c:if>
                            <c:if test="${title eq 'DMCH210'}">
                                <li>RCS 가로형 Right</li>
                            </c:if>
                            <c:if test="${title eq 'DMCH211'}">
                                <li>RCS 슬라이드 Small</li>
                            </c:if>
                            <c:if test="${title eq 'DMCH212'}">
                                <li>RCS 슬라이드 Medium</li>
                            </c:if>
                            <c:if test="${title eq 'DMCH204'}">
                                <li>카카오</li>
                            </c:if>
                            <c:if test="${title eq 'DMCH201' || title eq 'DMCH202' || title eq 'DMCH203'}">
                                <li>모바일</li>
                            </c:if>
                        </c:forEach>
                    </ul>
                </div>
                <div class="sms_head cf">
                    <!-- 템플릿명 -->
                    <h3>${content.cont_nm}</h3>
                    <%--
                    <div class="remove_info">
                        <input type="button" value="${content.use_yn}" class="en_font useState" onclick="updateUseState('${content.seq}', this);"/>
                        <a href="/cont/mdmDetail/${content.seq}.mi">수정</a>
                    </div>
                    --%>
                </div>
                <div class="row_top cf">
                    <!-- 컨텐츠 type -->
                    <c:if test="${content.send_tp eq 'SENDTP01'}">
                        <div class="contents_type">광고</div>
                    </c:if>
                    <c:if test="${content.send_tp eq 'SENDTP02'}">
                        <div class="contents_type">안내</div>
                    </c:if>
                    <!-- 제목 -->
                    <%--<h4>${content.cont_sub}</h4>--%>
                    <c:choose>
                        <c:when test="${content.msg_tp eq 'DMCH211' || content.msg_tp eq 'DMCH212'}">
                            <h4>${content.slideTitle[0]}</h4>
                        </c:when>
                        <c:otherwise>
                            <h4>${content.cont_sub}</h4>
                        </c:otherwise>
                    </c:choose>
                </div>
                    <!-- 카카오톡  -->
                <c:if test="${content.cont_tp eq 'DMTP03'}">
                    <c:if test="${not empty content.kko_image_url}">
                        <div class="row_body">
                            <div class="round_box">
                                <div class="sms">
                                    <img src="${filePath}${content.kko_image_url}"
                                         onerror="this.src = '/image/bg_none.png'" alt="">
                                </div>
                                <p class="sms_txt">
                                    ${content.cont_sub}<br/><br>
                                    ${cutil:replaceBr(content.cont_body)}
                                </p>
                                <a href="${content.kko_btn_url}" target="_blank"
                                   class="sms_btn">${content.kko_btn_nm}</a>
                            </div>
                    </div>
                    </c:if>
                    <c:if test="${empty content.kko_image_url}">
                      <div class="row_body">
                        <div class="round_box">
                            <div class="sms_txt">
                                ${content.cont_sub}<br/><br/>
                                ${cutil:replaceBr(content.cont_body)}
                            </div>
                        </div>
                      </div>
                    </c:if>
                </c:if>
                    <!-- 모바일 (문자) 이면서 MMS 형태 -->
                <c:if test="${content.cont_tp eq 'DMTP02' && content.msg_tp eq 'DMCH203'}">
                    <div class="row_body">
                        <div class="sms_box">
                            <div class="sms_title" id="sms_title">${content.cont_sub}</div>
                            <div class="sms_img">
                                <img src="${filePath}${fn:split(content.img_lst,',')[0]}" alt="" onerror="this.src = '/image/bg_none.png'">
                            </div>
                            <div class="sms_txt">${cutil:replaceBr(content.cont_body)}</div>
                        </div>
                    </div>
                </c:if>
                    <!-- 모바일 (문자) 면서 SMS 형태 -->
                <c:if test="${content.cont_tp eq 'DMTP02' && content.msg_tp eq 'DMCH201'}">
                    <div class="row_body">
                        <div class="sms_box">
                            <div class="sms_txt">
                                ${cutil:replaceBr(content.cont_body)}<br/><br/>
                            </div>
                        </div>
                      </div>
                </c:if>
                    <!-- 모바일 (문자) 면서 LMS 형태 -->
                <c:if test="${content.cont_tp eq 'DMTP02' && content.msg_tp eq 'DMCH202'}">
                    <div class="row_body">
                        <div class="sms_box">
                            <div class="sms_title" id="sms_title">${content.cont_sub}</div>
                            <div class="sms_txt">
                                ${cutil:replaceBr(content.cont_body)}<br/><br/>
                            </div>
                        </div>
                      </div>
                </c:if>
                    <!-- RCS TEXT -->
                <c:if test="${content.msg_tp eq 'DMCH205' || content.msg_tp eq 'DMCH206'}">
                    <div class="row_body">
                        <div class="rcs_txt_type">
                            <h3>${content.cont_sub}</h3>
                            <p>${cutil:replaceBr(content.cont_body)}</p>
                            <c:forEach var="btn" items="${content.cont_btn_json[0]['suggestions']}">
                                <div class="rcs_action">
                                    ${btn['action']['displayText']}
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
                    <!-- RCS 세로형 Tall -->
                <c:if test="${content.msg_tp eq 'DMCH207'}">
                    <div class="row_body">
                        <div class="rcs_vertical tall cf">
                            <div class="img_area">
                                <%--<c:if test="${not empty content.img_lst}">
                                    <img src="${baseURL}${content.img_lst}" alt="" onerror="this.src = '/image/bg_none.png'">
                                </c:if>--%>
                                <c:if test="${not empty fn:split(content.img_lst,',')[0]}">
                                    <img src="${filePath}${fn:split(content.img_lst,',')[0]}" onerror="this.src = '/image/bg_none.png'"/>
                                </c:if>
                            </div>
                            <div class="txt_area">
                                <h3>${content.cont_sub}</h3>
                                <p>${cutil:replaceBr(content.cont_body_json[0]['description'])}</p>
                                <c:forEach var="btn" items="${content.cont_btn_json[0]['suggestions']}">
                                    <div class="rcs_action">
                                        ${btn['action']['displayText']}
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </c:if>
                    <!-- RCS 세로형 Medium -->
                <c:if test="${content.msg_tp eq 'DMCH208'}">
                    <div class="row_body">
                        <div class="rcs_vertical medium cf">
                            <div class="img_area">
                                <%--<c:if test="${not empty content.img_lst}">
                                    <img src="${baseURL}${content.img_lst}" alt="" onerror="this.src = '/image/bg_none.png'">
                                </c:if>--%>
                                <c:if test="${not empty fn:split(content.img_lst,',')[0]}">
                                    <img src="${filePath}${fn:split(content.img_lst,',')[0]}" onerror="this.src = '/image/bg_none.png'"/>
                                </c:if>
                            </div>
                            <div class="txt_area">
                                <h3>${content.cont_sub}</h3>
                                <p>${cutil:replaceBr(content.cont_body_json[0]['description'])}</p>
                                <c:forEach var="btn" items="${content.cont_btn_json[0]['suggestions']}">
                                    <div class="rcs_action">
                                        ${btn['action']['displayText']}
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </c:if>
                    <!-- RCS 슬라이드 Small -->
                <c:if test="${content.msg_tp eq 'DMCH211'}">
                    <div class="row_body">
                        <div class="rcs_slide_wrap">
                                <div class="rcs_slide_inner">
                                    <div class="slide small cf">
                                        <div class="img_area">
                                            <c:if test="${not empty fn:split(content.img_lst,',')[0]}">
                                                <img src="${filePath}${fn:split(content.img_lst,',')[0]}" onerror="this.src = '/image/bg_none.png'"/>
                                            </c:if>
                                        </div>
                                        <div class="txt_area">
                                            <h3>${cutil:replaceBr(content.cont_body_json[0]['title1'])}</h3>
                                            <p>${cutil:replaceBr(content.cont_body_json[0]['description1'])}</p>
                                            <c:forEach var="btn" items="${content.cont_btn_json[0]['suggestions']}">
                                                <div class="rcs_action">${btn['action']['displayText']}</div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <div class="slide small cf">
                                        <div class="img_area">
                                         <c:if test="${not empty fn:split(content.img_lst,',')[1]}">
                                             <img src="${filePath}${fn:split(content.img_lst,',')[1]}" onerror="this.src = '/image/bg_none.png'"/>
                                         </c:if>
                                        </div>
                                        <div class="txt_area">
                                            <h3>${cutil:replaceBr(content.cont_body_json[0]['title2'])}</h3>
                                            <p>${cutil:replaceBr(content.cont_body_json[0]['description2'])}</p>
                                        </div>
                                    </div>
                                </div>
                        </div>
                    </div>
                </c:if>
                    <!-- RCS 슬라이드 Medium -->
                <c:if test="${content.msg_tp eq 'DMCH212'}">
                    <div class="row_body">
                        <div class="rcs_slide_wrap">
                            <div class="rcs_slide_inner">
                                <div class="slide medium cf">
                                    <div class="img_area">
                                     <c:if test="${not empty fn:split(content.img_lst,',')[0]}">
                                         <img src="${filePath}${fn:split(content.img_lst,',')[0]}" onerror="this.src = '/image/bg_none.png'"/>
                                     </c:if>
                                    </div>
                                    <div class="txt_area">
                                        <h3>${cutil:replaceBr(content.cont_body_json[0]['title1'])}</h3>
                                        <p>${cutil:replaceBr(content.cont_body_json[0]['description1'])}</p>
                                        <c:forEach var="btn" items="${content.cont_btn_json[0]['suggestions']}">
                                            <div class="rcs_action">
                                                ${btn['action']['displayText']}
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                                <div class="slide medium cf">
                                    <div class="img_area">
                                        <c:if test="${not empty fn:split(content.img_lst,',')[1]}">
                                            <img src="${filePath}${fn:split(content.img_lst,',')[1]}" onerror="this.src = '/image/bg_none.png'"/>
                                        </c:if>
                                    </div>
                                    <div class="txt_area">
                                       <h3>${cutil:replaceBr(content.cont_body_json[0]['title2'])}</h3>
                                       <p>${cutil:replaceBr(content.cont_body_json[0]['description2'])}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
                <div class="row_footer">
                    <!-- 수정일 -->
                    <div class="date">수정일&nbsp;&nbsp;
                        <span>
                            ${cutil:stringDateParse(content.upd_dt)}
                        </span>
                    </div>
                    <!-- 등록일 -->
                    <div class="date">등록일&nbsp;&nbsp;
                        <span>
                            ${cutil:stringDateParse(content.reg_dt)}
                        </span>
                    </div>
                </div>
            </div>
        </c:forEach>
        <input type="hidden" id="nowPageNo" name="nowPageNo" value="${pageNo}"/>
    </c:when>
    <c:otherwise>
        <div class="none list_ht bottom-border">
            조회된 결과가 없습니다.
        </div>
    </c:otherwise>
</c:choose>
</span>

<span id="mobileLstpagingDom">
     <ui:pagination paginationInfo="${page}" type="image" jsFunction="mobileListPaging"/>
    <input type="hidden" id="nowPageNo" name="nowPageNo" value="${pageNo}"/>
    <input type="hidden" id="totCnt" name="totCnt" value="${listCnt}"/>
</span>
