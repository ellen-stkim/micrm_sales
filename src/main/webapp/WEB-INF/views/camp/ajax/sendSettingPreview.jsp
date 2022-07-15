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
<div id="preview">
    <c:choose>
        <c:when test="${dto.cont_tp eq 'DMTP01'}">
            <div class="thumbnail">
                <img src="${filePath}${dto.thm_url}" onerror="this.src = '/image/bg_none_wide.png'">
            </div>
        </c:when>
        <c:otherwise>
            <c:choose>
                <c:when test="${dto.cont_tp eq 'DMTP02'}">
                <div class="sms_box">
                    <div class="sms_title" id="sms_title">${dto.cont_sub}</div>
                    <c:if test="${!cutil:isEmptyObject(dto.img_lst)}">
                        <div class="sms_img">
                            <c:forEach var="img_lst" items="${fn:split(dto.img_lst,',')}">
                                <img src="${filePath}${img_lst}" onerror="this.src = '/image/bg_none.png'" >
                            </c:forEach>
                        </div>
                    </c:if>
                    <div class="sms_txt">${cutil:replaceBr(dto.cont_body)}</div>
                </div>
                </c:when>
                <c:when test="${dto.cont_tp eq 'DMTP03'}">
                <div class="round_box">
                    <c:if test="${!cutil:isEmptyObject(dto.kko_image_url)}">
                    <div class="sms">
                        <img src="${filePath}${dto.kko_image_url}" onerror="this.src = '/image/bg_none.png'">
                    </div>
                    </c:if>
                    <p class="sms_txt">${cutil:replaceBr(dto.cont_body)}</p>
                    <c:if test="${!cutil:isEmptyObject(dto.kko_btn_url)}">
                        <a href="${dto.kko_btn_url}" target="_blank" class="sms_btn">${dto.kko_btn_nm}</a>
                    </c:if>
                </div>
                </c:when>
                <c:otherwise>
                    <c:choose>
                        <c:when test="${dto.msg_tp eq 'DMCH207'}"> <%--RCS 세로형 Tall--%>
                        <div class="rcs_vertical tall cf">
                            <div class="img_area">
                            <c:forEach var="img_lst" items="${fn:split(dto.img_lst,',')}">
                                  <img src="${filePath}${img_lst}" onerror="this.src = '/image/bg_none.png'">
                            </c:forEach>
                            </div>
                            <div class="txt_area">
                               <h3>${dto.cont_body_json[0]['title']}</h3>
                               <p>${cutil:replaceBr(dto.cont_body_json[0]['description'])}</p>
                               <c:if test="${fn:length(dto.cont_btn_json) > st.index}">
                                   <c:if test="${!cutil:isEmptyObject(dto.cont_btn_json[st.index]['suggestions'])}">
                                       <c:forEach var="btn" items="${dto.cont_btn_json[st.index]['suggestions']}">
                                       <div class="rcs_action">
                                           ${btn['action']['displayText']}
                                       </div>
                                       </c:forEach>
                                   </c:if>
                               </c:if>
                           </div>
                        </div>
                        </c:when>
                        <c:when test="${dto.msg_tp eq 'DMCH208'}"> <%--RCS 세로형 Medium--%>
                        <div class="rcs_vertical medium cf">
                            <div class="img_area">
                                <c:forEach var="img_lst" items="${fn:split(dto.img_lst,',')}">
                                    <img src="${filePath}${img_lst}" onerror="this.src = '/image/bg_none.png'">
                                </c:forEach>
                            </div>
                            <div class="txt_area">
                               <h3>${dto.cont_body_json[0]['title']}</h3>
                               <p>${cutil:replaceBr(dto.cont_body_json[0]['description'])}</p>
                               <c:if test="${fn:length(dto.cont_btn_json) > st.index}">
                                   <c:if test="${!cutil:isEmptyObject(dto.cont_btn_json[st.index]['suggestions'])}">
                                       <c:forEach var="btn" items="${dto.cont_btn_json[st.index]['suggestions']}">
                                       <div class="rcs_action">
                                           ${btn['action']['displayText']}
                                       </div>
                                       </c:forEach>
                                   </c:if>
                               </c:if>
                           </div>
                        </div>
                        </c:when>
                        <c:when test="${dto.msg_tp eq 'DMCH209'}"> <%--RCS 가로형 LFET--%>
                        <div class="rcs_horizontal cf">
                            <div class="img_area">
                                <c:forEach var="img_lst" items="${fn:split(dto.img_lst,',')}">
                                    <img src="${filePath}${img_lst}" onerror="this.src = '/image/bg_none.png'">
                                </c:forEach>
                            </div>
                            <div class="txt_area">
                                <h3>${dto.cont_body_json[0]['title']}</h3>
                                <p>${cutil:replaceBr(dto.cont_body_json[0]['description'])}</p>
                                <c:if test="${fn:length(dto.cont_btn_json) > st.index}">
                                    <c:if test="${!cutil:isEmptyObject(dto.cont_btn_json[st.index]['suggestions'])}">
                                        <c:forEach var="btn" items="${dto.cont_btn_json[st.index]['suggestions']}">
                                            <div class="rcs_action">
                                                    ${btn['action']['displayText']}
                                            </div>
                                        </c:forEach>
                                    </c:if>
                                </c:if>
                            </div>
                        </div>
                        </c:when>
                        <c:when test="${dto.msg_tp eq 'DMCH210'}"> <%--RCS 가로형 RIGHT--%>
                        <div class="rcs_horizontal cf">
                           <div class="txt_area">
                               <h3>${dto.cont_body_json[0]['title']}</h3>
                               <p>${cutil:replaceBr(dto.cont_body_json[0]['description'])}</p>
                               <c:if test="${fn:length(dto.cont_btn_json) > st.index}">
                                   <c:if test="${!cutil:isEmptyObject(dto.cont_btn_json[st.index]['suggestions'])}">
                                       <c:forEach var="btn" items="${dto.cont_btn_json[st.index]['suggestions']}">
                                           <div class="rcs_action">
                                                   ${btn['action']['displayText']}
                                           </div>
                                       </c:forEach>
                                   </c:if>
                               </c:if>
                           </div>
                           <c:forEach var="img_lst" items="${fn:split(dto.img_lst,',')}">
                               <img src="${filePath}${img_lst}" onerror="this.src = '/image/bg_none.png'">
                           </c:forEach>
                       </div>
                        <!-- [RCS 가로형 Right] 끝 -->
                        </c:when>
                        <c:when test="${dto.msg_tp eq 'DMCH211'}"> <%-- RCS 슬라이드형 small --%>
                        <div class="rcs_inner">
                            <div class="slide_area">
                                <c:set var="img_lst" value="${fn:split(dto.img_lst,',')}" />
                                <!-- slide prev/next 버튼 영역 -->
                                <div class="rcs_prev" id="preview_rcs_prev">
                                    <img src="/image/ico_rcs_prev.png" alt="">
                                </div>
                                <div class="rcs_next" id="preview_rcs_next">
                                    <img src="/image/ico_rcs_next.png" alt="">
                                </div>
                                <div class="swiper-container slideSwiper small" id="preview_slideSwiper">
                                    <div class="swiper-wrapper">
                                        <c:forEach var="rcsLst" items="${dto.cont_body_json}" varStatus="st">
                                        <div class="swiper-slide slide0">
                                            <div class="rcs_head">[Web발신] (${dto.send_tp_nm})</div>
                                            <section>
                                                <c:if test="${fn:length(dto.img_lst) > st.index}">
                                                <div class="img_area">
                                                    <img src="${filePath}${img_lst[st.index]}" onerror="this.src = '/image/bg_none.png'">
                                                </div>
                                                </c:if>
                                                <div class="txt_area">
                                                    <h3>${rcsLst['title']}</h3>
                                                    <p>${cutil:replaceBr(rcsLst['description'])}</p>
                                                    <c:if test="${fn:length(dto.cont_btn_json) > st.index}">
                                                       <c:if test="${!cutil:isEmptyObject(dto.cont_btn_json[st.index]['suggestions'])}">
                                                           <div class="rcs_btn_wrap">
                                                               <c:forEach var="btn" items="${dto.cont_btn_json[st.index]['suggestions']}">
                                                                   <div class="rcs_btn">${btn['action']['displayText']}</div>
                                                               </c:forEach>
                                                           </div>
                                                       </c:if>
                                                   </c:if>
                                                </div>
                                            </section>
                                        </div>
                                        </c:forEach>
                                    </div>
                                    <!--슬라이드 페이지 번호 영역-->
                                    <div class="rcs_paging en_font" id="preview_rcs_paging"></div>
                                    <!-- 수신거부 번호 표시 영역 -->
                                    <c:if test="${!cutil:isEmptyObject(dto.rcs_footer)}">
                                    <div class="rcs_register">
                                        무료 수신거부 : <span>${dto.rcs_footer}</span>
                                    </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                        </c:when>
                        <c:when test="${dto.msg_tp eq 'DMCH212'}"> <%--RCS 슬라이드형 Medium--%>
                        <div class="rcs_inner">
                            <div class="slide_area">
                                <div class="rcs_prev">
                                    <img src="/image/ico_rcs_prev.png" alt="">
                                </div>
                                <div class="rcs_next">
                                    <img src="/image/ico_rcs_next.png" alt="">
                                </div>
                                <div class="swiper-container slideSwiper medium">
                                    <div class="swiper-wrapper">
                                        <c:set var="img_lst" value="${fn:split(dto.img_lst,',')}" />
                                        <c:forEach var="rcsLst" items="${dto.cont_body_json}" varStatus="st">
                                        <div class="swiper-slide slide0">
                                            <div class="rcs_head">[Web발신] (${dto.send_tp_nm})</div>
                                            <section>
                                                <c:if test="${fn:length(dto.img_lst) > st.index}">
                                                <div class="img_area">
                                                    <img src="${filePath}${img_lst[st.index]}" onerror="this.src = '/image/bg_none.png'">
                                                </div>
                                                </c:if>
                                                <div class="txt_area">
                                                    <h3>${rcsLst['title']}</h3>
                                                    <p>${cutil:replaceBr(rcsLst['description'])}</p>
                                                    <c:if test="${fn:length(dto.cont_btn_json) > st.index}">
                                                       <c:if test="${!cutil:isEmptyObject(dto.cont_btn_json[st.index]['suggestions'])}">
                                                           <div class="rcs_btn_wrap">
                                                               <c:forEach var="btn" items="${dto.cont_btn_json[st.index]['suggestions']}">
                                                                   <div class="rcs_btn">${btn['action']['displayText']}</div>
                                                               </c:forEach>
                                                           </div>
                                                       </c:if>
                                                   </c:if>
                                                </div>
                                            </section>
                                        </div>
                                        </c:forEach>
                                    </div>
                                    <!--슬라이드 페이지 번호 영역-->
                                    <div class="rcs_paging en_font"></div>
                                    <!-- 수신거부 번호 표시 영역 -->
                                    <c:if test="${!cutil:isEmptyObject(dto.rcs_footer)}">
                                    <div class="rcs_register">
                                        무료 수신거부 : <span>${dto.rcs_footer}</span>
                                    </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                        </c:when>
                        <c:otherwise>
                        <div class="rcs_txt_type">
                            <p>${dto.cont_body}</p>
                            <c:if test="${!cutil:isEmptyObject(dto.rcs_btn_1)}">
                                <div class="rcs_action">${dto.rcs_btn_1}</div>
                            </c:if>
                       </div>
                        </c:otherwise>
                    </c:choose>
                </c:otherwise>
            </c:choose>
        </c:otherwise>
    </c:choose>
</div>
