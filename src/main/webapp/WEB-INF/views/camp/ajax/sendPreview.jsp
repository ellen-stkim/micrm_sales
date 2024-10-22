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
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil" %>
<div class="click-chart-cover row-flex" id="content-analysis">
    <div class="content-box">
        <c:set var="list" value="${list}"/>
        <c:set var="cont_tp" value="${list[0].dto.cont_tp}"/>
        <ul class="tab_row ${cont_tp eq 'DMTP01'? "disnone" : ""} " id="smsTab"  style="float: inherit;">
            <li class="${cont_tp eq 'DMTP03' ? "on" : ""}" style="display: list-item;" id="DMTP03"><span>친구톡</span> </li>
            <li class="${cont_tp eq 'DMTP05' ? "on" : ""}" style="display: list-item;" id="DMTP05"><span>알림톡</span> </li>
            <li class="${cont_tp eq 'DMTP02' ? "on" : ""}" style="display: list-item;" id="DMTP02"><span>문자</span></li>
            <li class="${cont_tp eq 'DMTP04' ? "on" : ""}" style="display: list-item;" id="DMTP04"><span>RCS</span></li>
        </ul>
        <c:forEach var="listmap" items="${list}" varStatus="status">
            <c:set var="dto" value="${listmap.dto}"/>
            <c:set var="cont_tp" value="${dto.cont_tp}"/>
            <div class="prev_box ${status.count == 1 ? "" : "disnone"}" id="prev_${cont_tp}">
                <div class="camp-content">
                    <div class="preview-container">
                        <c:if test="${cont_tp eq 'DMTP01'}">
                            <iframe name="preview" id="preview" frameborder="0" title="viwer"></iframe>
                        </c:if>
                        <!-- 모바일 (문자) 이면서 MMS 형태 -->
                        <c:if test="${cont_tp eq 'DMTP02' && dto.msg_tp eq 'DMCH203'}">
                            <div class="scroll-box">
                                <div class="row_body">
                                    <div class="sms_box">
                                        <div class="sms_title" id="sms_title">${dto.cont_sub}</div>
                                        <div class="sms_img">
                                            <img src="${filePath}${fn:split(dto.img_lst,',')[0]}" alt="" onerror="this.src = '/image/bg_none.png'"></div>
                                        <div class="sms_txt">${cutil:replaceBr(dto.cont_body)}</div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        <!-- 모바일 (문자) 면서 SMS 형태 -->
                        <c:if test="${cont_tp eq 'DMTP02' && dto.msg_tp eq 'DMCH201'}">
                            <div class="scroll-box">
                                <div class="row_body">
                                    <div class="sms_box">
                                        <div class="sms_txt">
                                                ${cutil:replaceBr(dto.cont_body)}<br/><br/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        <!-- 모바일 (문자) 면서 LMS 형태 -->
                        <c:if test="${cont_tp eq 'DMTP02' && dto.msg_tp eq 'DMCH202'}">
                            <div class="scroll-box">
                                <div class="row_body">
                                    <div class="sms_box">
                                        <div class="sms_title" id="sms_title">${dto.cont_sub}</div>
                                        <div class="sms_txt">
                                                ${cutil:replaceBr(dto.cont_body)}<br/><br/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        <!-- 친구톡 -->
                        <c:if test="${cont_tp eq 'DMTP03'}">
                            <div class="scroll-box">
                                <div class="round_box">
                                    <c:if test="${!cutil:isEmptyObject(dto.kko_img_lst)}">
                                        <div class="sms">
                                            <img src="${filePath}${dto.kko_img_lst}" onerror="this.src = '/image/bg_none.png'" alt="kko">
                                        </div>
                                    </c:if>
                                    <c:set var="btnStyle" value="${empty content.kko_btn_url && !cutil:isEmptyObject(dto.kko_img_lst) ? 'max-height: 200px' : ''}" />
                                    <p class="sms_txt" style="${btnStyle}">${cutil:replaceBr(dto.cont_body)}</p>
                                    <c:if test="${!cutil:isEmptyObject(dto.kko_btn_url)}">
                                        <a href="${dto.kko_btn_url}" target="_blank" class="sms_btn" rel="noopener">${dto.kko_btn_nm}</a>
                                    </c:if>
                                </div>
                            </div>
                        </c:if>
                        <!-- 알림톡 -->
                        <c:if test="${cont_tp eq 'DMTP05'}">
                            <div class="scroll-box">
                                <div class="row_body">
                                    <div class="round_box ">
                                        <div class="round_box head">
                                            <p>알림톡 도착</p>
                                        </div>
                                        <c:if test="${!cutil:isEmptyObject(dto.kko_img_lst)}">
                                            <div class="sms">
                                                <img src="${filePath}${dto.kko_img_lst}" onerror="this.src = '/image/bg_none.png'" alt="kko">
                                            </div>
                                        </c:if>
                                        <p class="sms_txt">${cutil:replaceBr(dto.cont_body)}</p>
                                        <c:forEach var="btn" items="${dto.at_btn_json}">
                                            <div>
                                                <a href="${btn.get('linkPc')}" target="_blank" class="sms_btn" rel="noopener">${btn.get('name')}</a>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        <!-- RCS TEXT -->
                        <c:if test="${dto.msg_tp eq 'DMCH205' || dto.msg_tp eq 'DMCH206'}">
                            <div class="scroll-box">
                                <div class="row_body">
                                    <div class="rcs_txt_type">
                                        <h3>${dto.cont_sub}</h3>
                                        <p>${cutil:replaceBr(dto.cont_body)}</p>
                                        <c:forEach var="btn" items="${dto.cont_btn_json[0]['suggestions']}">
                                            <div class="rcs_action">
                                                    ${btn['action']['displayText']}
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${dto.msg_tp eq 'DMCH207'}">
                            <div class="scroll-box">
                                <div class="row_body">
                                    <div class="rcs_vertical tall cf">
                                        <div class="img_area">
                                            <c:if test="${not empty fn:split(dto.img_lst,',')[0]}">
                                                <img src="${filePath}${fn:split(dto.img_lst,',')[0]}" onerror="this.src = '/image/bg_none.png'" alt="img"/>
                                            </c:if>
                                        </div>
                                        <div class="txt_area">
                                            <h3>${dto.cont_sub}</h3>
                                            <p>${cutil:replaceBr(dto.cont_body)}</p>
                                            <c:forEach var="btn" items="${dto.cont_btn_json[0]['suggestions']}">
                                                <div class="rcs_action">
                                                        ${btn['action']['displayText']}
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        <!-- RCS 세로형 Medium -->
                        <c:if test="${dto.msg_tp eq 'DMCH208'}">
                            <div class="scroll-box">
                                <div class="row_body">
                                    <div class="rcs_vertical medium cf">
                                        <div class="img_area">
                                            <c:if test="${not empty fn:split(dto.img_lst,',')[0]}">
                                                <img src="${filePath}${fn:split(dto.img_lst,',')[0]}" onerror="this.src = '/image/bg_none.png'" alt="img" />
                                            </c:if>
                                        </div>
                                        <div class="txt_area">
                                            <h3>${dto.cont_sub}</h3>
                                            <p>${cutil:replaceBr(dto.cont_body)}</p>
                                            <c:forEach var="btn" items="${dto.cont_btn_json[0]['suggestions']}">
                                                <div class="rcs_action">
                                                        ${btn['action']['displayText']}
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${dto.msg_tp eq 'DMCH211' || dto.msg_tp eq 'DMCH212'}">
                            <div class="rcs_inner rcs_slide" id="rcs_inner">
                                <div class="slide_area">
                                    <div class="rcs_prev" id="rcs_prev">
                                        <img src="${baseURL}/image/ico_rcs_prev.png" alt="">
                                    </div>
                                    <div class="rcs_next" id="rcs_next">
                                        <img src="${baseURL}/image/ico_rcs_next.png" alt="">
                                    </div>
                                    <div class="swiper-container slideSwiper ${dto.msg_tp eq 'DMCH211'? 'small' : 'medium' } ">
                                        <div class="swiper-wrapper">
                                            <c:forEach var="idx" begin="0" end="${dto.cardSize-1}">
                                                <div class="swiper-slide slide${idx}">
                                                    <div class="rcs_head">[WEB발신]광고</div>
                                                    <section>
                                                        <c:set var="imgNm"
                                                               value="${fn:split(dto.img_lst,',')[idx]}"/>
                                                        <div class="img_area">
                                                            <c:if test="${fn:trim(imgNm) != '' && fn:trim(imgNm) != null}">
                                                                <img src="${filePath}${imgNm}" alt="img" onerror="this.src = '/image/bg_none.png'"/>
                                                            </c:if>
                                                        </div>
                                                        <c:set var="imgIdx" value="${idx+1}"/>
                                                        <input type="hidden"
                                                               name="rcs_img_url_${imgIdx}"
                                                                <c:if test="${fn:trim(imgNm) != '' && fn:trim(imgNm) != null}">
                                                                    value="${filePath}${imgNm}"
                                                                </c:if>/>
                                                        <div class="txt_area">
                                                            <h3 id="titleArea${idx}" name="titleArea">
                                                                <c:if test="${fn:trim(dto.slideTitle[idx]) != ''}">
                                                                    ${dto.slideTitle[idx]}
                                                                </c:if>
                                                            </h3>
                                                            <p id="textArea${idx}">
                                                                <c:if test="${fn:trim(dto.slideBody[idx]) != ''}">
                                                                    ${dto.slideBody[idx]}
                                                                </c:if>
                                                            </p>
                                                            <div class="rcs_btn_wrap">
                                                                <c:set var="btn"
                                                                       value="${dto.cont_btn_json[idx]['suggestions'][0]}"/>
                                                                <div class="rcs_btn"
                                                                     data="1">${btn['action']['displayText']}</div>
                                                                <c:set var="btn"
                                                                       value="${dto.cont_btn_json[idx]['suggestions'][1]}"/>
                                                                <div class="rcs_btn"
                                                                     data="2">${btn['action']['displayText']}</div>
                                                            </div>
                                                        </div>
                                                    </section>
                                                </div>
                                            </c:forEach>

                                        </div>
                                        <div class="rcs_paging en_font">1/3</div>
                                        <input type="hidden" name="cont_sub_list" value=""/>
                                        <c:if test="${dto.msg_tp eq 'DMCH211'}">
                                            <input type="hidden" name="rcs_msg_tp" value="small"/>
                                        </c:if>
                                        <c:if test="${dto.msg_tp eq 'DMCH212'}">
                                            <input type="hidden" name="rcs_msg_tp" value="medium"/>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>