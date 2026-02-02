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

<div id="js-area-popup">
    <div class="layer_pop" id="smsContentsPopup">
        <div class="pop_container popup_size8">
            <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
            <div class="pop_title">모바일 컨텐츠 미리보기</div>
            <div class="pop_inner">
                <div class="sms_preview">
                    <div class="list_container">
                        <div class="row_grid">
                            <c:if test="${fn:contains(content.formatType,'kakao')}">
                                <c:set var="kkoOptionLabel">
                                    <c:choose>
                                        <c:when test="${content.kko_option eq 'ad'}">광고</c:when>
                                        <c:otherwise>안내</c:otherwise>
                                    </c:choose>
                                </c:set>
                                <!-- 알림톡(kko_at) -->
                                <c:if test="${fn:contains(content.kko_format_type,'kko_at')}">
                                    <div class="column">
                                        <div class="sms_head bg_color cf">알림톡</div>
                                        <div class="row_top cf">
                                            <div class="contents_type">${kkoOptionLabel}</div>
                                            <h4>${content.cont_sub_list[0]}</h4>
                                        </div>
                                        <div class="row_body template_body" id="at_tmpl_privew"></div>
                                    </div>
                                </c:if>
                                <!-- 브랜드톡(kko_ft) -->
                                <c:if test="${!fn:contains(content.kko_format_type,'kko_at')}">
                                    <div class="column">
                                        <div class="sms_head bg_color cf">브랜드톡</div>
                                        <div class="row_top cf">
                                            <div class="contents_type">${kkoOptionLabel}</div>
                                            <h4>${content.cont_sub_list[0]}</h4>
                                        </div>
                                        <div class="row_body">
                                            <c:choose>
                                                <c:when test="${content.kko_msg_tp eq '2'}">
                                                    <div class="slide_area">
                                                        <div class="swiper-container medium previewBrandSlide">
                                                            <div class="swiper-wrapper">
                                                                <c:forEach var="idx" begin="0" end="6">
                                                                    <c:set var="headerKey" value="${'kkoHeader' += idx}"/>
                                                                    <c:set var="bodyKey" value="${'kkoBody' += idx}"/>
                                                                    <c:set var="imgKey" value="${'kko_view_item_img_url_' += idx}"/>
                                                                    <c:if test="${idx ne 0}">
                                                                        <c:set var="btn1Key" value="${'kkoBtnLst' += idx += '_1'}"/>
                                                                        <c:set var="btn2Key" value="${'kkoBtnLst' += idx += '_2'}"/>
                                                                    </c:if>
                                                                    <c:if test="${not empty content[headerKey]}">
                                                                        <div class="swiper-slide slide${idx}">
                                                                            <section>
                                                                                <div class="img_area">
                                                                                    <img src="${content[imgKey]}" onerror="this.src='/image/bg_none.png'" alt=""/>
                                                                                </div>
                                                                                <div class="txt_area">
                                                                                    <h3>${content[headerKey]}</h3>
                                                                                    <div style="display:block;width:100%;height:1px;margin:8px 1px;background-color:rgba(0,0,0,0.08);"></div>
                                                                                    <p style="padding-top:10px;overflow-wrap:anywhere;word-break:break-word;white-space:normal;">
                                                                                        ${content[bodyKey]}
                                                                                    </p>
                                                                                    <div style="display:flex;gap:12px;align-items:center;">
                                                                                        <c:if test="${not empty content[btn1Key]}">
                                                                                            <div class="kakao_link" style="display:block;width:100%;height:37px;line-height:35px;background:#f2f2f2;font-size:12px;text-align:center;margin:15px auto;outline:none;border-radius:5px;">
                                                                                                ${content[btn1Key]}
                                                                                            </div>
                                                                                        </c:if>
                                                                                        <c:if test="${not empty content[btn2Key]}">
                                                                                            <div class="kakao_link" style="display:block;width:100%;height:37px;line-height:35px;background:#f2f2f2;font-size:12px;text-align:center;margin:15px auto;outline:none;border-radius:5px;">
                                                                                                ${content[btn2Key]}
                                                                                            </div>
                                                                                        </c:if>
                                                                                    </div>
                                                                                </div>
                                                                            </section>
                                                                        </div>
                                                                    </c:if>
                                                                </c:forEach>
                                                            </div>
                                                            <div class="previewBrandSlidePagign" style="text-align:center;padding-top:20px;">1/7</div>
                                                        </div>
                                                    </div>
                                                </c:when>
                                                <c:when test="${content.kko_msg_tp eq '3'}">
                                                    <div class="slide_area">
                                                        <div class="swiper-container medium previewBrandSlide">
                                                            <div class="swiper-wrapper">
                                                                <c:forEach var="idx" begin="1" end="6">
                                                                    <c:set var="headerKey" value="${'kkoHeader' += idx}"/>
                                                                    <c:set var="bodyKey" value="${'kkoBody' += idx}"/>
                                                                    <c:set var="imgKey" value="${'kko_view_item_img_url_' += idx}"/>
                                                                    <c:set var="btn1Key" value="${'kkoBtnLst' += idx += '_1'}"/>
                                                                    <c:set var="btn2Key" value="${'kkoBtnLst' += idx += '_2'}"/>
                                                                    <c:if test="${not empty content[headerKey]}">
                                                                        <div class="swiper-slide slide${idx}">
                                                                            <section>
                                                                                <div class="img_area">
                                                                                    <img src="${content[imgKey]}" onerror="this.src='/image/bg_none.png'" alt=""/>
                                                                                </div>
                                                                                <div class="txt_area">
                                                                                    <h3>${content[headerKey]}</h3>
                                                                                    <div style="display:block;width:100%;height:1px;margin:8px 1px;background-color:rgba(0,0,0,0.08);"></div>
                                                                                    <p style="padding-top:10px;overflow-wrap:anywhere;word-break:break-word;white-space:normal;">
                                                                                        ${content[bodyKey]}
                                                                                    </p>
                                                                                    <div style="display:flex;gap:12px;align-items:center;">
                                                                                        <c:if test="${not empty content[btn1Key]}">
                                                                                            <div class="kakao_link" style="display:block;width:100%;height:37px;line-height:35px;background:#f2f2f2;font-size:12px;text-align:center;margin:15px auto;outline:none;border-radius:5px;">
                                                                                                ${content[btn1Key]}
                                                                                            </div>
                                                                                        </c:if>
                                                                                        <c:if test="${not empty content[btn2Key]}">
                                                                                            <div class="kakao_link" style="display:block;width:100%;height:37px;line-height:35px;background:#f2f2f2;font-size:12px;text-align:center;margin:15px auto;outline:none;border-radius:5px;">
                                                                                                ${content[btn2Key]}
                                                                                            </div>
                                                                                        </c:if>
                                                                                    </div>
                                                                                </div>
                                                                            </section>
                                                                        </div>
                                                                    </c:if>
                                                                </c:forEach>
                                                            </div>
                                                            <div class="previewBrandSlidePagign" style="text-align:center;padding-top:20px;">1/6</div>
                                                        </div>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="round_box">
                                                        <c:choose>
                                                            <c:when test="${content.kko_msg_tp eq '1'}">
                                                                <div class="kakao_wide_lst" style="display:block">
                                                                    <strong class="kakao_wide_lst_strong">
                                                                        <span class="kakao_wide_lst_title">${content.cont_sub_list[0]}</span>
                                                                    </strong>
                                                                    <div class="kakao_wide_lst_main_div">
                                                                        <ul class="kakao_wide_lst_ul">
                                                                            <li class="kakao_wide_lst_li_first">
                                                                                <div class="kakao_wide_lst_li_first_div">
                                                                                    <a href="${content.kkoItemUrlLstMo1}" target="_blank" class="kakao_wide_lst_li_first_a">
                                                                                        <img src="${content.kko_view_item_img_url_1}" alt="" role="presentation" style="min-height:41px;">
                                                                                    </a>
                                                                                </div>
                                                                                <p class="kakao_wide_lst_li_first_p">
                                                                                    <span class="kakao_wide_lst_li_first_span">${content.kkoItemLst1}</span>
                                                                                </p>
                                                                            </li>
                                                                            <li class="kakao_wide_lst_li">
                                                                                <div class="kakao_wide_lst_li_div">
                                                                                    <a href="${content.kkoItemUrlLstMo2}" target="_blank" class="kakao_wide_lst_li_a">
                                                                                        <img src="${content.kko_view_item_img_url_2}" alt="" role="presentation" style="min-height:41px;">
                                                                                    </a>
                                                                                </div>
                                                                                <p class="kakao_wide_lst_li_p">
                                                                                    <span class="kakao_wide_lst_li_span">${content.kkoItemLst2}</span>
                                                                                </p>
                                                                            </li>
                                                                            <li class="kakao_wide_lst_li">
                                                                                <div class="kakao_wide_lst_li_div">
                                                                                    <a href="${content.kkoItemUrlLstMo3}" target="_blank" class="kakao_wide_lst_li_a">
                                                                                        <img src="${content.kko_view_item_img_url_3}" alt="" role="presentation" style="min-height:41px;">
                                                                                    </a>
                                                                                </div>
                                                                                <p class="kakao_wide_lst_li_p">
                                                                                    <span class="kakao_wide_lst_li_span">${content.kkoItemLst3}</span>
                                                                                </p>
                                                                            </li>
                                                                            <c:if test="${!cutil:isEmptyObject(content.kkoItemLst4)}">
                                                                                <li class="kakao_wide_lst_li">
                                                                                    <div class="kakao_wide_lst_li_div">
                                                                                        <a href="${content.kkoItemUrlLstMo4}" target="_blank" class="kakao_wide_lst_li_a">
                                                                                            <img src="${content.kko_view_item_img_url_4}" alt="" role="presentation" style="min-height:41px;">
                                                                                        </a>
                                                                                    </div>
                                                                                    <p class="kakao_wide_lst_li_p">
                                                                                        <span class="kakao_wide_lst_li_span">${content.kkoItemLst4}</span>
                                                                                    </p>
                                                                                </li>
                                                                            </c:if>
                                                                        </ul>
                                                                    </div>
                                                                </div>
                                                            </c:when>
                                                            <c:when test="${content.kko_msg_tp eq '4'}">
                                                                <c:set var="parts" value="${fn:split(content.kko_video_url, '/')}"/>
                                                                <c:set var="videoId" value="${parts[fn:length(parts) - 1]}"/>
                                                                <c:set var="convertedUrl" value="${'https://play-tv.kakao.com/embed/player/cliplink/' += videoId += '?service=player_share'}"/>
                                                                <div>
                                                                    <iframe src="${convertedUrl}" width="100%"></iframe>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:choose>
                                                                    <c:when test="${not empty fn:trim(content.kko_view_img_url) and fn:contains(content.kko_view_img_url, ',')}">
                                                                        <div class="sms">
                                                                            <img src="${fn:split(content.kko_view_img_url, ',')[0]}" onerror="this.src='/image/bg_none.png'" alt="">
                                                                        </div>
                                                                    </c:when>
                                                                    <c:when test="${not empty fn:trim(content.kko_view_img_url) and fn:trim(content.kko_view_img_url) ne ','}">
                                                                        <div class="sms">
                                                                            <img src="${content.kko_view_img_url}" onerror="this.src='/image/bg_none.png'" alt="">
                                                                        </div>
                                                                    </c:when>
                                                                    <c:otherwise></c:otherwise>
                                                                </c:choose>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <p class="sms_txt">${cutil:replaceBr(content.kakao_body)}</p>
                                                        <c:forEach var="i" begin="1" end="5">
                                                            <c:choose>
                                                                <c:when test="${i eq 1}">
                                                                    <c:if test="${not empty content.kko_btn_url}">
                                                                        <a href="${content.kko_btn_url}" target="_blank" class="sms_btn" rel="noopener">${content.kko_btn_nm}</a>
                                                                    </c:if>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <c:set var="urlKey" value="${'kko_btn_url' += i}"/>
                                                                    <c:set var="nmKey" value="${'kko_btn_nm' += i}"/>
                                                                    <c:if test="${not empty content[urlKey]}">
                                                                        <a href="${content[urlKey]}" target="_blank" rel="noopener" class="sms_btn">${content[nmKey]}</a>
                                                                    </c:if>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:if>
                            </c:if>
                            <!-- ===================== 카카오톡 영역 끝 ===================== -->
                            <!-- ===================== 문자 영역 시작 ===================== -->
                            <c:if test="${fn:contains(content.formatType,'sms')}">
                                <div class="column">
                                    <div class="sms_head bg_color cf">문자</div>
                                    <div class="row_top cf">
                                        <div class="contents_type">
                                            <c:choose>
                                                <c:when test="${content.sms_option eq 'ad'}">광고</c:when>
                                                <c:otherwise>안내</c:otherwise>
                                            </c:choose>
                                        </div>
                                        <h4>${content.cont_sub_list[1]}</h4>
                                    </div>
                                    <!-- SMS -->
                                    <c:if test="${content.sms_msg_tp eq 'SMS'}">
                                        <div class="row_body">
                                            <div class="sms_box">
                                                <div class="sms_txt">
                                                        ${cutil:replaceBr(content.sms_body)}
                                                    <br/>
                                                    <br/>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                    <!-- LMS -->
                                    <c:if test="${content.sms_msg_tp eq 'LMS'}">
                                        <div class="row_body">
                                            <div class="sms_box">
                                                <div class="sms_title">${content.cont_sub_list[1]}</div>
                                                <div class="sms_txt">
                                                        ${cutil:replaceBr(content.sms_body)}
                                                    <br/>
                                                    <br/>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                    <c:if test="${content.sms_msg_tp eq 'MMS'}">
                                        <div class="row_body">
                                            <div class="sms_box">
                                                <div class="sms_title" id="sms_title">${content.cont_sub_list[1]}</div>
                                                <div class="sms_img">
                                                    <img src="${filePath}${content.mms_imgurl}" alt="" onerror="this.src='/image/bg_none.png'">
                                                </div>
                                                <div class="sms_txt">${cutil:replaceBr(content.sms_body)}</div>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </c:if>
                            <!-- ===================== 문자 영역 끝 ===================== -->
                            <!-- ===================== RCS 영역 시작 ===================== -->
                            <c:if test="${fn:contains(content.formatType,'rcs')}">
                            <div class="column">
                                <div class="sms_head bg_color cf">RCS</div>

                                <div class="row_top cf">
                                    <div class="contents_type">
                                        <c:choose>
                                            <c:when test="${content.rcs_option eq 'ad'}">광고</c:when>
                                            <c:otherwise>안내</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <h4>${content.cont_sub_list[2]}</h4>
                                </div>
                                <!-- RCS TEXT -->
                                <c:if test="${content.rcs_msg_tp eq 'sms' || content.rcs_msg_tp eq 'lms'}">
                                    <div class="row_body">
                                        <div class="rcs_txt_type">
                                            <h3>${content.cont_sub_list[2]}</h3>
                                            <p>${cutil:replaceBr(content.rcs_body)}</p>
                                            <c:forEach var="btn" items="${jsonContent.cont_btn_json[0]['suggestions']}">
                                                <div class="rcs_action">${btn['action']['displayText']}</div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:if>
                                <!-- RCS 세로형 Tall -->
                                <c:if test="${content.rcs_format_type eq 'vertical' && content.rcs_msg_tp eq 'tall'}">
                                    <div class="row_body">
                                        <div class="rcs_vertical tall cf">
                                            <div class="img_area">
                                                <c:if test="${not empty content.rcs_img_url_1}">
                                                    <img src="${filePath}${content.rcs_img_url_1}" onerror="this.src='/image/bg_none.png'" alt=""/>
                                                </c:if>
                                            </div>
                                            <div class="txt_area">
                                                <h3>${content.cont_sub_list[2]}</h3>
                                                <p>${cutil:replaceBr(jsonContent.cont_body_json[0]['description'])}</p>
                                                <c:forEach var="btn" items="${jsonContent.cont_btn_json[0]['suggestions']}">
                                                    <div class="rcs_action">${btn['action']['displayText']}</div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                                <!-- RCS 세로형 Medium -->
                                <c:if test="${content.rcs_msg_tp eq 'medium' && content.rcs_format_type eq 'vertical'}">
                                    <div class="row_body">
                                        <div class="rcs_vertical medium cf">
                                            <div class="img_area">
                                                <c:if test="${not empty content.rcs_img_url_1}">
                                                    <img src="${filePath}${content.rcs_img_url_1}" onerror="this.src='/image/bg_none.png'" alt=""/>
                                                </c:if>
                                            </div>
                                            <div class="txt_area">
                                                <h3>${content.cont_sub_list[2]}</h3>
                                                <p>${cutil:replaceBr(jsonContent.cont_body_json[0]['description'])}</p>
                                                <c:forEach var="btn" items="${jsonContent.cont_btn_json[0]['suggestions']}">
                                                    <div class="rcs_action">${btn['action']['displayText']}</div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                                <!-- RCS 슬라이드 Small/Medium -->
                                <c:if test="${content.rcs_format_type eq 'slide' && (content.rcs_msg_tp eq 'small' || content.rcs_msg_tp eq 'medium')}">
                                <div class="row_body">
                                    <div class="rcs_inner">
                                        <div class="slide_area">
                                            <div class="rcs_prev">
                                                <img src="/image/ico_rcs_prev.png" alt="">
                                            </div>
                                            <div class="rcs_next">
                                                <img src="/image/ico_rcs_next.png" alt="">
                                            </div>
                                           <c:choose>
                                             <c:when test="${content.rcs_msg_tp eq 'small'}">
                                                <div class="swiper-container slideSwiper small previewSlide">
                                             </c:when>
                                             <c:otherwise>
                                                <div class="swiper-container slideSwiper medium previewSlide">
                                             </c:otherwise>
                                           </c:choose>
                                                 <div class="swiper-wrapper">
                                                    <c:set var="rcsLst" value="${jsonContent.cont_body_json}"/>
                                                    <c:set var="index" value="${fn:length(fn:split(rcsLst,','))/2}"/>
                                                    <c:forEach var="i" begin="0" end="${index-1}">
                                                       <div class="swiper-slide slide${i}">
                                                          <div class="rcs_head">[WEB발신] ${content.rcs_option eq 'ad' ? '광고' : '안내'}</div>
                                                          <section>
                                                             <div class="img_area">
                                                                <c:choose>
                                                                   <c:when test="${i eq 0 && not empty content.rcs_img_url_1}">
                                                                      <img src="${content.rcs_img_url_1}" onerror="this.src='/image/bg_none.png'" alt=""/>
                                                                   </c:when>
                                                                   <c:when test="${i eq 1 && not empty content.rcs_img_url_2}">
                                                                      <img src="${content.rcs_img_url_2}" onerror="this.src='/image/bg_none.png'" alt=""/>
                                                                   </c:when>
                                                                   <c:when test="${i eq 2 && not empty content.rcs_img_url_3}">
                                                                      <img src="${content.rcs_img_url_3}" onerror="this.src='/image/bg_none.png'" alt=""/>
                                                                   </c:when>
                                                                   <c:when test="${i eq 3 && not empty content.rcs_img_url_4}">
                                                                      <img src="${content.rcs_img_url_4}" onerror="this.src='/image/bg_none.png'" alt=""/>
                                                                   </c:when>
                                                                   <c:when test="${i eq 4 && not empty content.rcs_img_url_5}">
                                                                      <img src="${content.rcs_img_url_5}" onerror="this.src='/image/bg_none.png'" alt=""/>
                                                                   </c:when>
                                                                   <c:when test="${i eq 5 && not empty content.rcs_img_url_6}">
                                                                      <img src="${content.rcs_img_url_6}" onerror="this.src='/image/bg_none.png'" alt=""/>
                                                                   </c:when>
                                                                   <c:otherwise></c:otherwise>
                                                                </c:choose>
                                                             </div>
                                                             <c:set var="idx" value="${i+1}"/>
                                                             <c:set var="title" value="${'title' += idx}"/>
                                                             <c:set var="description" value="${'description' += idx}"/>
                                                             <div class="txt_area">
                                                                <h3>${rcsLst[0][title]}</h3>
                                                                <p>${cutil:replaceBr(rcsLst[0][description])}</p>
                                                             </div>
                                                             <div class="rcs_btn_wrap">
                                                                <c:forEach var="btn" items="${jsonContent.cont_btn_json[i]['suggestions']}">
                                                                   <div class="rcs_action">${btn['action']['displayText']}</div>
                                                                </c:forEach>
                                                             </div>
                                                          </section>
                                                       </div>
                                                    </c:forEach>
                                                 </div>
                                                 <div class="rcs_paging en_font"></div>
                                                 <c:if test="${!cutil:isEmptyObject(content.rcs_footer)}">
                                                    <div class="rcs_register">
                                                       무료 수신거부 :
                                                       <span id="rejectionArea">${content.rcs_footer}</span>
                                                    </div>
                                                 </c:if>
                                              </div>
                                           </div>
                                        </div>
                                    </div>
                                   </c:if>
                                </div>
                               </c:if>
                                <!-- ===================== RCS 영역 끝 ===================== -->
                            </div>
                        </div>
                    </div>
                    <div class="btn_row">
                        <input type="button" class="btn_bg btn_size2 btn_center" id="saveBtn" value="저장"/>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>