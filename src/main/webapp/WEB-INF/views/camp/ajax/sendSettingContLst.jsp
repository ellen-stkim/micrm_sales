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
<div id="send_ct_tbody">
    <c:if test="${empty list}">
        <div class="none_data">조회된 결과가 없습니다.</div>
    </c:if>
    <c:forEach var="g" items="${list}">
        <c:choose>
            <c:when test="${g.cont_tp eq 'DMTP01'}">
                <div class="image_column">
                    <input type="hidden" name="send_to" value="${g.send_to}" />
                    <input type="hidden" name="send_nm" value="${g.send_nm}" />
                    <input type="hidden" name="cont_sub" value="${cutil:escapeTextToHtml(g.cont_sub)}" />
                    <div class="top">
                        <!-- 체크박스 -->
                        <label class="custom_radio">
                            <input type="radio" name="cont_id" value="${g.seq}" />
                            <span></span>
                        </label>
                        <!-- 이미지명 -->
                        <span class="title">${cutil:escapeTextToHtml(g.cont_nm)}</span>
                    </div>
                    <div class="row_top cf">
                        <!-- 컨텐츠 type -->
                        <div class="contents_type">${g.send_tp_nm}</div>
                        <!-- 제목 -->
                        <h4>${cutil:escapeTextToHtml(g.cont_sub)}</h4>
                    </div>
                    <div class="body">
                        <!-- 이미지 썸네일 -->
                        <div class="thumbnail">
                            <img src="${filePath}${g.thm_url}" onerror="this.src = '/image/bg_none_wide.png'">
                        </div>
                    </div>
                    <div class="row_footer">
                        <!-- 수정일 -->
                        <div class="date">수정일&nbsp;&nbsp;<span>${cutil:stringDateParse(g.upd_dt)}</span></div>
                        <!-- 등록일 -->
                        <div class="date">등록일&nbsp;&nbsp;<span>${cutil:stringDateParse(g.reg_dt)}</span></div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="image_column">
                    <input type="hidden" name="send_to" value="${g.send_to}" />
                    <input type="hidden" name="send_nm" value="${g.send_nm}" />
                    <c:choose>
                      <c:when test="${g.cont_tp eq 'DMTP04' and (g.msg_tp ne 'DMCH205' and g.msg_tp ne 'DMCH206')}">
                          <input type="hidden" name="cont_sub" value="${cutil:escapeTextToHtml(g.cont_body_json[0]['title'])}"/>
                      </c:when>
                        <c:otherwise>
                            <input type="hidden" name="cont_sub" value="${cutil:escapeTextToHtml(g.cont_sub)}"/>
                        </c:otherwise>
                    </c:choose>
                    <div class="top">
                        <!-- 체크박스 -->
                        <label class="custom_radio">
                            <input type="radio" name="cont_id" value="${g.seq}" />
                            <span></span>
                        </label>
                        <ul class="sms_type cf">
                        <c:forEach var="cont_tp_lst_nm" items="${fn:split(g.cont_tp_lst_nm,',')}">
                            <c:choose>
                                <c:when test="${cont_tp_lst_nm eq 'RCS'}"><li>${g.msg_tp_nm}</li></c:when>
                                <c:otherwise><li>${cont_tp_lst_nm}</li></c:otherwise>
                            </c:choose>
                        </c:forEach>
                        </ul>
                    </div>
                    <div class="top bg_none">
                        <!-- 템플릿 명 -->
                        <span class="title">${cutil:escapeTextToHtml(g.cont_nm)}</span>
                    </div>
                    <div class="row_top cf">
                        <!-- 컨텐츠 type -->
                        <div class="contents_type">${g.send_tp_nm}</div>
                        <!-- 제목 -->
                        <c:choose>
                            <c:when test="${g.cont_tp eq 'DMTP04' and (g.msg_tp ne 'DMCH205' and g.msg_tp ne 'DMCH206')}">
                                <h4>${g.cont_body_json[0]['title']}</h4>
                            </c:when>
                            <c:otherwise><h4>${g.cont_sub}</h4></c:otherwise>
                        </c:choose>
                    </div>
                    <div class="body sms_height">
                    <c:choose>
                        <c:when test="${g.cont_tp eq 'DMTP02'}"> <%-- 문자 --%>
                        <div class="sms_box">
                            <c:if test="${!cutil:isEmptyObject(g.cont_sub)}">
                                <div class="sms_title" id="sms_title">${g.cont_sub}</div>
                            </c:if>
                            <c:if test="${!cutil:isEmptyObject(g.img_lst)}">
                                <div class="sms_img">
                                <c:forEach var="img_lst" items="${fn:split(g.img_lst,',')}">
                                    <img src="${filePath}${img_lst}" onerror="this.src = '/image/bg_none.png'">
                                </c:forEach>
                                </div>
                            </c:if>
                            <div class="sms_txt">${cutil:replaceBr(g.cont_body)}</div>
                       </div>
                        </c:when>
                        <c:when test="${g.cont_tp eq 'DMTP03'}"> <%-- 카카오 --%>
                        <div class="round_box">
                            <!-- 이미지 영역 -->
                            <c:if test="${!cutil:isEmptyObject(g.kko_image_url)}">
                            <div class="sms">
                                <img src="${filePath}${g.kko_image_url}" onerror="this.src = '/image/bg_none.png'">
                            </div>
                            </c:if>
                            <!-- 텍스트 영역 -->
                            <p class="sms_txt">${cutil:replaceBr(g.cont_body)}</p>
                            <!-- 카카오 링크 버튼 영역 -->
                            <c:if test="${!cutil:isEmptyObject(g.kko_btn_url)}">
                                <a href="${g.kko_btn_url}" target="_blank" class="sms_btn" rel="noopener">${g.kko_btn_nm}</a>
                            </c:if>
                        </div>
                        </c:when>
                        <c:otherwise>
                            <c:choose>
                                <c:when test="${g.msg_tp eq 'DMCH207'}"> <%--RCS 세로형 Tall--%>
                                <div class="rcs_vertical tall cf">
                                    <div class="img_area">
                                    <c:forEach var="img_lst" items="${fn:split(g.img_lst,',')}">
                                        <img src="${filePath}${img_lst}" onerror="this.src = '/image/bg_none.png'">
                                    </c:forEach>
                                    </div>
                                    <div class="txt_area">
                                       <h3>${g.cont_body_json[0]['title']}</h3>
                                       <p>${cutil:replaceBr(g.cont_body_json[0]['description'])}</p>
                                       <c:if test="${fn:length(g.cont_btn_json) > st.index}">
                                           <c:if test="${!cutil:isEmptyObject(g.cont_btn_json[st.index]['suggestions'])}">
                                               <c:forEach var="btn" items="${g.cont_btn_json[st.index]['suggestions']}">
                                               <div class="rcs_action">
                                                   ${btn['action']['displayText']}
                                               </div>
                                               </c:forEach>
                                           </c:if>
                                       </c:if>
                                   </div>
                                </div>
                                </c:when>
                                <c:when test="${g.msg_tp eq 'DMCH208'}"> <%--RCS 세로형 Medium--%>
                                <div class="rcs_vertical medium cf">
                                    <div class="img_area">
                                        <c:forEach var="img_lst" items="${fn:split(g.img_lst,',')}">
                                            <img src="${filePath}${img_lst}" onerror="this.src = '/image/bg_none.png'">
                                        </c:forEach>
                                    </div>
                                    <div class="txt_area">
                                       <h3>${g.cont_body_json[0]['title']}</h3>
                                       <p>${cutil:replaceBr(g.cont_body_json[0]['description'])}</p>
                                       <c:if test="${fn:length(g.cont_btn_json) > st.index}">
                                           <c:if test="${!cutil:isEmptyObject(g.cont_btn_json[st.index]['suggestions'])}">
                                               <c:forEach var="btn" items="${g.cont_btn_json[st.index]['suggestions']}">
                                               <div class="rcs_action">
                                                   ${btn['action']['displayText']}
                                               </div>
                                               </c:forEach>
                                           </c:if>
                                       </c:if>
                                   </div>
                                </div>
                                </c:when>
                                <c:when test="${g.msg_tp eq 'DMCH209'}"> <%--RCS 가로형 LFET--%>
                                <div class="rcs_horizontal cf">
                                    <div class="img_area">
                                        <c:forEach var="img_lst" items="${fn:split(g.img_lst,',')}">
                                            <img src="${filePath}${img_lst}" onerror="this.src = '/image/bg_none.png'">
                                        </c:forEach>
                                    </div>
                                    <div class="txt_area">
                                        <h3>${g.cont_body_json[0]['title']}</h3>
                                        <p>${cutil:replaceBr(g.cont_body_json[0]['description'])}</p>
                                        <c:if test="${fn:length(g.cont_btn_json) > st.index}">
                                            <c:if test="${!cutil:isEmptyObject(g.cont_btn_json[st.index]['suggestions'])}">
                                                <c:forEach var="btn" items="${g.cont_btn_json[st.index]['suggestions']}">
                                                    <div class="rcs_action">
                                                            ${btn['action']['displayText']}
                                                    </div>
                                                </c:forEach>
                                            </c:if>
                                        </c:if>
                                    </div>
                                </div>
                                </c:when>
                                <c:when test="${g.msg_tp eq 'DMCH210'}"> <%--RCS 가로형 RIGHT--%>
                                <div class="rcs_horizontal cf">
                                    <div class="txt_area">
                                        <h3>${g.cont_body_json[0]['title']}</h3>
                                        <p>${cutil:replaceBr(g.cont_body_json[0]['description'])}</p>
                                        <c:if test="${fn:length(g.cont_btn_json) > st.index}">
                                            <c:if test="${!cutil:isEmptyObject(g.cont_btn_json[st.index]['suggestions'])}">
                                                <c:forEach var="btn" items="${g.cont_btn_json[st.index]['suggestions']}">
                                                    <div class="rcs_action">
                                                            ${btn['action']['displayText']}
                                                    </div>
                                                </c:forEach>
                                            </c:if>
                                        </c:if>
                                    </div>
                                    <c:forEach var="img_lst" items="${fn:split(g.img_lst,',')}">
                                        <img src="${filePath}${img_lst}" onerror="this.src = '/image/bg_none.png'">
                                    </c:forEach>
                                </div>
                                </c:when>
                                <c:when test="${g.msg_tp eq 'DMCH211'}"> <%--RCS 슬라이드형 small--%>
                                <div class="rcs_slide_wrap">
                                    <div class="rcs_slide_inner">
                                       <c:set var="img_lst" value="${fn:split(g.img_lst,',')}" />
                                       <!-- RCS Array 가 아닌 RCS Object Type으로 넘어오기에 수정 -->
                                       <!-- Lucas가 작성한 Server 로직과 관련될 수 있기에 임시 주석처리 -->
                                       <%--<c:forEach var="rcsLst" items="${g.cont_body_json}" varStatus="st">
                                       <div class="slide small cf">
                                           <c:if test="${fn:length(img_lst) > st.index}">
                                           <div class="img_area">
                                               <img src="${img_lst[st.index]}" onerror="this.src = '/image/bg_none.png'">
                                           </div>
                                           </c:if>
                                           <div class="txt_area">
                                               <h3>${rcsLst['title']}</h3>
                                               <p>${cutil:replaceBr(rcsLst['description'])}</p>
                                               <c:if test="${fn:length(g.cont_btn_json) > st.index}">
                                                   <c:if test="${!cutil:isEmptyObject(g.cont_btn_json[st.index]['suggestions'])}">
                                                       <c:forEach var="btn" items="${g.cont_btn_json[st.index]['suggestions']}">
                                                       <div class="rcs_action">
                                                           ${btn['action']['displayText']}
                                                       </div>
                                                       </c:forEach>
                                                   </c:if>
                                               </c:if>
                                           </div>
                                       </div>
                                       </c:forEach>--%>
                                       <!-- 슬라이드 형태는 뷰에 최대 2개까지만 뿌려준다 -->
                                       <div class="slide small cf">
                                           <div class="img_area">
                                               <img src="${baseURL}${img_lst[0]}" onerror="this.src = '/image/bg_none.png'">
                                           </div>
                                           <div class="txt_area">
                                               <h3>${cutil:replaceBr(g.cont_body_json[0]['title1'])}</h3>
                                               <p>${cutil:replaceBr(g.cont_body_json[0]['description1'])}</p>
                                               <c:if test ="${!cutil:isEmptyObject(g.cont_btn_json[0]['suggestions'])}">
                                                   <c:forEach var="btn" items="${g.cont_btn_json[0]['suggestions']}">
                                                       <div class="rcs_action">
                                                           ${btn['action']['displayText']}
                                                       </div>
                                                   </c:forEach>
                                               </c:if>
                                           </div>
                                       </div>
                                       <div class="slide small cf">
                                           <div class="img_area">
                                               <img src="${baseURL}${img_lst[1]}" onerror="this.src = '/image/bg_none.png'">
                                           </div>
                                           <div class="txt_area">
                                               <h3>${cutil:replaceBr(g.cont_body_json[0]['title2'])}</h3>
                                               <p>${cutil:replaceBr(g.cont_body_json[0]['description2'])}</p>
                                               <c:if test ="${!cutil:isEmptyObject(g.cont_btn_json[1]['suggestions'])}">
                                                   <c:forEach var="btn" items="${g.cont_btn_json[1]['suggestions']}">
                                                       <div class="rcs_action">
                                                           ${btn['action']['displayText']}
                                                       </div>
                                                   </c:forEach>
                                               </c:if>
                                           </div>
                                       </div>
                                    </div>
                                </div>
                                </c:when>
                                <c:when test="${g.msg_tp eq 'DMCH212'}"> <%--RCS 슬라이드형 Medium--%>
                                <div class="rcs_slide_wrap">
                                    <div class="rcs_slide_inner">
                                        <c:set var="img_lst" value="${fn:split(g.img_lst,',')}" />
                                        <%--<c:forEach var="rcsLst" items="${g.cont_body_json}" varStatus="st">
                                        <div class="slide medium cf">
                                            <c:if test="${fn:length(img_lst) > st.index}">
                                                <div class="img_area">
                                                    <img src="${img_lst[st.index]}" onerror="this.src = '/image/bg_none.png'">
                                                </div>
                                            </c:if>
                                            <div class="txt_area">
                                                <h3>${rcsLst['title']}</h3>
                                                <p>${cutil:replaceBr(rcsLst['description'])}</p>
                                                <c:if test="${fn:length(g.cont_btn_json) > st.index}">
                                                    <c:if test="${!cutil:isEmptyObject(g.cont_btn_json[st.index]['suggestions'])}">
                                                        <c:forEach var="btn" items="${g.cont_btn_json[st.index]['suggestions']}">
                                                            <div class="rcs_action">
                                                                    ${btn['action']['displayText']}
                                                            </div>
                                                        </c:forEach>
                                                    </c:if>
                                                </c:if>
                                            </div>
                                        </div>
                                        </c:forEach>--%>
                                        <div class="slide medium cf">
                                            <div class="img_area">
                                                <img src="${baseURL}${img_lst[0]}" onerror="this.src = '/image/bg_none.png'">
                                            </div>
                                            <div class="txt_area">
                                                <h3>${cutil:replaceBr(g.cont_body_json[0]['title1'])}</h3>
                                                <p>${cutil:replaceBr(g.cont_body_json[0]['description1'])}</p>
                                                <c:if test ="${!cutil:isEmptyObject(g.cont_btn_json[0]['suggestions'])}">
                                                    <c:forEach var="btn" items="${g.cont_btn_json[0]['suggestions']}">
                                                        <div class="rcs_action">
                                                                ${btn['action']['displayText']}
                                                        </div>
                                                    </c:forEach>
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="slide medium cf">
                                            <div class="img_area">
                                                <img src="${baseURL}${img_lst[1]}" onerror="this.src = '/image/bg_none.png'">
                                            </div>
                                            <div class="txt_area">
                                                <h3>${cutil:replaceBr(g.cont_body_json[0]['title2'])}</h3>
                                                <p>${cutil:replaceBr(g.cont_body_json[0]['description2'])}</p>
                                                <c:if test ="${!cutil:isEmptyObject(g.cont_btn_json[1]['suggestions'])}">
                                                    <c:forEach var="btn" items="${g.cont_btn_json[1]['suggestions']}">
                                                        <div class="rcs_action">
                                                                ${btn['action']['displayText']}
                                                        </div>
                                                    </c:forEach>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                </c:when>
                                <c:otherwise>
                                <div class="rcs_txt_type">
                                    <p>${cutil:replaceBr(g.cont_body)}</p>
                                    <c:if test="${!cutil:isEmptyObject(g.rcs_btn_1)}">
                                        <div class="rcs_action">${g.rcs_btn_1}</div>
                                    </c:if>
                                </div>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                    </div>
                    <div class="row_footer">
                        <!-- 수정일 -->
                        <div class="date">수정일&nbsp;&nbsp;<span>${cutil:stringDateParse(g.upd_dt)}</span></div>
                        <!-- 등록일 -->
                        <div class="date">등록일&nbsp;&nbsp;<span>${cutil:stringDateParse(g.reg_dt)}</span></div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </c:forEach>
</div>
<div id="send_ct_pager">
    <ui:pagination paginationInfo="${page}" type="image" jsFunction="fn_page_ct"/>
</div>
