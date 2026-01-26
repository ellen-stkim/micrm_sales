<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
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
                                <li>브랜드톡</li>
                            </c:if>
                            <c:if test="${title eq 'DMCH217'}">
                                <li>브랜드톡 이미지</li>
                            </c:if>
                            <c:if test="${title eq 'DMCH218'}">
                                <li>브랜드톡 와이드 이미지</li>
                            </c:if>
                            <c:if test="${title eq 'DMCH216'}">
                                <li>알림톡</li>
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
                    <div class="remove_info">
                        <input type="button" value="${content.use_yn}" class="en_font useState right-border" onclick="updateUseState('${content.seq}', this);"/>
<%--                        <a href="/cont/mdmDetail/${content.seq}.mi">수정</a>--%>
                    </div>
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
                    <c:choose>
                        <c:when test="${content.msg_tp eq 'DMCH211' || content.msg_tp eq 'DMCH212'}">
                            <h4>${content.slideTitle[0]}</h4>
                        </c:when>
                        <c:otherwise>
                            <h4>${content.cont_sub}</h4>
                        </c:otherwise>
                    </c:choose>
                </div>
                <!-- 카카오톡 브랜드톡 -->
                <c:if test="${content.cont_tp eq 'DMTP03'}">
                    <div class="row_body">
                        <div class="round_box">
                            <c:if test="${not empty content.kko_image_url}">
                            <div class="sms">
                                <img src="${filePath}${content.kko_image_url}" onerror="this.src = '/image/bg_none.png'" alt="">
                            </div>
                            </c:if>
                            <p class="sms_txt">
                                ${cutil:replaceBr(content.cont_body)}
                            </p>
                            <c:if test="${not empty content.kko_btn_url}">
                                <a href="${content.kko_btn_url}" target="_blank" rel="noopener" class="sms_btn">${content.kko_btn_nm}</a>
                            </c:if>
                            <c:if test="${not empty content.kko_btn_url2}">
                                <a href="${content.kko_btn_url2}" target="_blank" rel="noopener" class="sms_btn">${content.kko_btn_nm2}</a>
                            </c:if>
                            <c:if test="${not empty content.kko_btn_url3}">
                                <a href="${content.kko_btn_url3}" target="_blank" rel="noopener" class="sms_btn">${content.kko_btn_nm3}</a>
                            </c:if>
                            <c:if test="${not empty content.kko_btn_url4}">
                                <a href="${content.kko_btn_url4}" target="_blank" rel="noopener" class="sms_btn">${content.kko_btn_nm4}</a>
                            </c:if>
                            <c:if test="${not empty content.kko_btn_url5}">
                                <a href="${content.kko_btn_url5}" target="_blank" rel="noopener" class="sms_btn">${content.kko_btn_nm5}</a>
                            </c:if>
                        </div>
                    </div>
                </c:if>
                <!-- 카카오톡 알림톡 -->
                <c:if test="${content.cont_tp eq 'DMTP05'}">
                    <div class="row_body template_body">
                        <div class="round_box">
                            <div class="round_box head">
                               <p>알림톡 도착</p>
                            </div>
                            <div class="at_tmpl_data">
                            <!-- 이미지형  아이템리스트형 -->
                                <c:if test="${content.tmpl_empsize_tp eq 'ITEM_LIST'  || content.tmpl_empsize_tp eq 'IMAGE'}">
                                    <c:if test="${!empty content.kko_img_cd}">
                                        <div class="kko_img_box">
                                            <img src="${content.kko_img_url}" style="max-height: 135px;" onerror="this.src = '/image/bg_none.png'" alt="">
                                        </div>
                                    </c:if>
                                </c:if>
                                 <div class="at_msg_cont">
                                    <%--  강조유형 강조표기형 --%>
                                    <c:if test="${content.tmpl_empsize_tp eq 'TEXT'}">
                                        <div class="tmpl_subtit">${content.tmpl_subtit}</div>
                                        <div class="tmpl_tit">${content.tmpl_tit}</div>
                                    </c:if>
                                    <%--  강조유형 아이템리스트형 --%>
                                    <c:if test="${content.tmpl_empsize_tp eq 'ITEM_LIST'}">
                                        <c:if test="${!empty content.item_highlight_json}">
                                            <c:set var="highlight" value="${content.highlight_json}"/>
                                            <div class="tmpl_header">${content.tmpl_header}</div>
                                            <div class="item_high_div">
                                                <div class="tmpl_high">
                                                    <div>${highlight.title}</div>
                                                    <div class="tmpl_subtit">${highlight.description}</div>
                                                </div>
                                                <c:if test="${fn:contains(content.item_highlight_json,'\"imageUrl\"')}">
                                                    <div class="right_img_box">
                                                        <img src="${highlight.imageUrl}" onerror="this.src = '/image/bg_none.png'" alt="">
                                                    </div>
                                                </c:if>
                                            <div>
                                        </c:if>
                                        <c:if test="${fn:contains(content.item_json,'\"list\"') ||fn:contains(content.item_json,'\"summary\"')}">
                                        <div class="item_div">
                                            <c:if test="${fn:contains(content.item_json,'\"list\"')}">
                                                <div class="item_table">
                                                    <c:forEach var="item" items="${content.item_list_json.list}">
                                                        <div>
                                                            <span class="th">${item.title}</span>
                                                            <span class="td">${item.description}</span>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:if>
                                            <c:if test="${fn:contains(content.item_json,'\"summary\"')}">
                                                 <div class="item_summary">
                                                      <span class="th">${content.item_list_json.summary.title}</span>
                                                      <span class="td">${content.item_list_json.summary.description}</span>
                                                 </div>
                                            </c:if>
                                        </div>
                                        </c:if>
                                    </c:if>
                                    <div class="cont">
                                        ${cutil:replaceBr(content.cont_body)}
                                    </div>
                                        <%--     부가 정보--%>
                                    <c:if test="${content.tmpl_msg_tp eq 'EX'}">
                                        <div class="etx">${content.tmpl_ext}</div>
                                    </c:if>
                                    <c:if test="${content.tmpl_msg_tp eq 'AD'}">
                                         <div class="ad">${content.tmpl_ad}</div>
                                    </c:if>
                                 </div>
                                 <c:if test="${!empty content.button_json}">
                                     <c:forEach var="btn" items="${content.btn_json}">
                                         <c:if test="${btn.linkType eq 'AC'}">
                                             <a class="sms_btn kakao_yellow">${btn.name}</a>
                                         </c:if>
                                         <c:if test="${btn.linkType ne 'AC'}">
                                             <a href="${btn.linkPc}" target="_blank" class="sms_btn" rel="noopener">${btn.name}</a></c:if>
                                     </c:forEach>
                                 </c:if>
                            </div>
                        </div>
                    </div>
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
                                    <img src="${filePath}${fn:split(content.img_lst,',')[0]}" onerror="this.src = '/image/bg_none.png'"  alt="" />
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
                                    <img src="${filePath}${fn:split(content.img_lst,',')[0]}" onerror="this.src='/image/bg_none.png'" alt=""/>
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
                                                <img src="${filePath}${fn:split(content.img_lst,',')[0]}" onerror="this.src = '/image/bg_none.png'" alt=""/>
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
                                             <img src="${filePath}${fn:split(content.img_lst,',')[1]}" onerror="this.src = '/image/bg_none.png'" alt=""/>
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
                                         <img src="${filePath}${fn:split(content.img_lst,',')[0]}" onerror="this.src = '/image/bg_none.png'" alt=""/>
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
                                            <img src="${filePath}${fn:split(content.img_lst,',')[1]}" onerror="this.src = '/image/bg_none.png'" alt=""/>
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
        <div class="bottom-border" style="display: flex; justify-content: center; align-items: center; width: 100%; height: 300px;">
            조회된 결과가 없습니다.
        </div>
    </c:otherwise>
</c:choose>
</span>

<span id="mobileLstpagingDom">
     <ui:pagination paginationInfo="${page}" type="image" jsFunction="mobileListPage"/>
    <input type="hidden" id="nowPageNo" name="nowPageNo" value="${pageNo}"/>
    <input type="hidden" id="totCnt" name="totCnt" value="${listCnt}"/>
</span>
