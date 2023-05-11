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
<div id="js-area-popup">
   <div class="layer_pop" id="smsContentsPopup">
      <div class="pop_container popup_size8">
         <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
         <div class="pop_title">모바일 컨텐츠 미리보기</div>
         <div class="pop_inner">
            <div class="sms_preview">
               <div class="list_container">
                  <div class="row_grid">
                     <!-- 카카오톡 영역 시작 -->
                     <c:if test="${fn:contains(content.formatType,'kakao')}">
                        <c:if test="${fn:contains(content.kko_format_type,'kko_at')}">
                           <div class="column">
                              <div class="sms_head bg_color cf">
                                 알림톡
                              </div>
                              <div class="row_top cf">
                                 <div class="contents_type">
                                    <c:if test="${content.kko_option eq 'ad'}">
                                       광고
                                    </c:if>
                                    <c:if test="${content.kko_option eq 'guide'}">
                                       안내
                                    </c:if>
                                 </div>
                                 <h4>${content.cont_sub_list[0]}</h4>
                              </div>
                              <div class="row_body template_body" id="at_tmpl_privew">
                              </div>
                           </div>
                        </c:if>
                        <c:if test="${!fn:contains(content.kko_format_type,'kko_at')}">
                        <div class="column">
                           <div class="sms_head bg_color cf">
                              친구톡
                           </div>
                           <div class="row_top cf">
                              <div class="contents_type">
                                 <c:if test="${content.kko_option eq 'ad'}">
                                    광고
                                 </c:if>
                                 <c:if test="${content.kko_option eq 'guide'}">
                                    안내
                                 </c:if>
                              </div>
                              <h4>${content.cont_sub_list[0]}</h4>
                           </div>
                              <div class="row_body">
                                 <div class="round_box">
                                    <c:if test="${not empty fn:trim(content.kko_view_img_url) and fn:trim(content.kko_view_img_url) ne ',' }">
                                    <div class="sms">
                                       <img src="${content.kko_view_img_url}" onerror="this.src = '/image/bg_none.png'" alt="">
                                    </div>
                                    </c:if>
                                    <p class="sms_txt">${cutil:replaceBr(content.kakao_body)}</p>
                                    <c:if test="${not empty content.kko_btn_url}">
                                    <a href="${content.kko_btn_url}" target="_blank" class="sms_btn" rel="noopener">${content.kko_btn_nm}</a>
                                    </c:if>
                                 </div>
                              </div>
                        </div>
                        </c:if>
                     </c:if>
                     <!-- 카카오톡 영역 끝 -->
                     <!-- 문자 영역 시작 -->
                     <c:if test="${fn:contains(content.formatType,'sms')}">
                        <div class="column">
                           <div class="sms_head bg_color cf">
                              문자
                           </div>
                           <div class="row_top cf">
                              <div class="contents_type">
                                 <c:if test="${content.sms_option eq 'ad'}">
                                    광고
                                 </c:if>
                                 <c:if test="${content.sms_option eq 'guide'}">
                                    안내
                                 </c:if>
                              </div>
                              <h4>${content.cont_sub_list[1]}</h4>
                           </div>
                           <!-- 문자 MMS  -->
                           <c:if test="${content.sms_msg_tp eq 'MMS'}">
                              <div class="row_body">
                                 <div class="sms_box">
                                    <div class="sms_title" id="sms_title">${content.cont_sub_list[1]}</div>
                                    <div class="sms_img"><img src="${filePath}${content.mms_imgurl}" alt="" onerror="this.src = '/image/bg_none.png'"></div>
                                    <div class="sms_txt">${cutil:replaceBr(content.sms_body)}</div>
                                 </div>
                              </div>
                           </c:if>
                           <!-- 문자 SMS -->
                           <c:if test="${content.sms_msg_tp eq 'SMS'}">
                              <div class="row_body">
                                 <div class="sms_box">
                                    <div class="sms_txt">
                                       ${cutil:replaceBr(content.sms_body)}<br/><br/>
                                    </div>
                                 </div>
                              </div>
                           </c:if>
                           <!-- 문자 LMS -->
                           <c:if test="${content.sms_msg_tp eq 'LMS'}">
                              <div class="row_body">
                                 <div class="sms_box">
                                    <div class="sms_title" id="sms_title">${content.cont_sub_list[1]}</div>
                                    <div class="sms_txt">
                                          ${cutil:replaceBr(content.sms_body)}<br/><br/>
                                    </div>
                                 </div>
                              </div>
                           </c:if>
                        </div>
                     </c:if>
                     <!-- 문자 영역 끝 -->
                     <!-- RCS 영역 시작 -->
                     <c:if test="${fn:contains(content.formatType,'rcs')}">
                        <div class="column">
                           <div class="sms_head bg_color cf">
                              RCS
                           </div>
                           <div class="row_top cf">
                              <div class="contents_type">
                                 <c:if test="${content.rcs_option eq 'ad'}">
                                    광고
                                 </c:if>
                                 <c:if test="${content.rcs_option eq 'guide'}">
                                    안내
                                 </c:if>
                              </div>
                              <h4>${content.cont_sub_list[2]}</h4>
                           </div>
                           <!-- RCS TEXT -->
                           <c:if test = "${content.rcs_msg_tp eq 'sms' || content.rcs_msg_tp eq 'lms'}">
                              <div class="row_body">
                                 <div class="rcs_txt_type">
                                    <h3>${content.cont_sub_list[2]}</h3>
                                    <p>${cutil:replaceBr(content.rcs_body)}</p>
                                    <c:forEach var="btn" items="${jsonContent.cont_btn_json[0]['suggestions']}">
                                       <div class="rcs_action">
                                             ${btn['action']['displayText']}
                                       </div>
                                    </c:forEach>
                                 </div>
                              </div>
                           </c:if>
                           <!-- RCS 세로형 Tall -->
                           <c:if test ="${content.rcs_format_type eq 'vertical' && content.rcs_msg_tp eq 'tall'}">
                              <div class="row_body">
                                 <div class="rcs_vertical tall cf">
                                    <div class="img_area">
                                       <c:if test="${not empty content.rcs_img_url_1}">
                                          <img src="${filePath}${content.rcs_img_url_1}" onerror="this.src = '/image/bg_none.png'" alt=""/>
                                       </c:if>
                                    </div>
                                    <div class="txt_area">
                                       <h3>${content.cont_sub_list[2]}</h3>
                                       <p>${cutil:replaceBr(jsonContent.cont_body_json[0]['description'])}</p>
                                       <c:forEach var="btn" items="${jsonContent.cont_btn_json[0]['suggestions']}">
                                          <div class="rcs_action">
                                                ${btn['action']['displayText']}
                                          </div>
                                       </c:forEach>
                                    </div>
                                 </div>
                              </div>
                           </c:if>
                           <!-- RCS 세로형 Medium -->
                           <c:if test ="${content.rcs_msg_tp eq 'medium' && content.rcs_format_type eq 'vertical'}">
                              <div class="row_body">
                                 <div class="rcs_vertical medium cf">
                                    <div class="img_area">
                                       <c:if test="${not empty content.rcs_img_url_1}">
                                          <img src="${filePath}${content.rcs_img_url_1}" onerror="this.src = '/image/bg_none.png'" alt=""/>
                                       </c:if>
                                    </div>
                                    <div class="txt_area">
                                       <h3>${content.cont_sub_list[2]}</h3>
                                       <p>${cutil:replaceBr(jsonContent.cont_body_json[0]['description'])}</p>
                                       <c:forEach var="btn" items="${jsonContent.cont_btn_json[0]['suggestions']}">
                                          <div class="rcs_action">
                                                ${btn['action']['displayText']}
                                          </div>
                                       </c:forEach>
                                    </div>
                                 </div>
                              </div>
                           </c:if>
                           <!-- RCS 슬라 이드 Small or Medium -->
                           <c:if test ="${content.rcs_format_type eq 'slide' && (content.rcs_msg_tp eq 'small' || content.rcs_msg_tp eq 'medium') }">
                              <div class="row_body">
                                 <div class="rcs_inner">
                                    <div class="slide_area">
                                       <div class="rcs_prev">
                                          <img src="/image/ico_rcs_prev.png" alt="">
                                       </div>
                                       <div class="rcs_next">
                                          <img src="/image/ico_rcs_next.png" alt="">
                                       </div>
                                       <c:if test="${content.rcs_msg_tp eq 'small'}">
                                          <!-- RCS Slide Small Preview -->
                                          <div class="swiper-container slideSwiper small previewSlide">
                                       </c:if>
                                       <c:if test="${content.rcs_msg_tp eq 'medium'}">
                                          <!-- RCS Slide Medium Preview -->
                                          <div class="swiper-container slideSwiper medium previewSlide">
                                       </c:if>
                                          <div class="swiper-wrapper">
                                             <c:set var="rcsLst" value="${jsonContent.cont_body_json}"/>
                                             <c:set var="index" value="${fn:length(fn:split(rcsLst,','))/2}"/>
                                             <c:forEach var="i" begin="0" end="${index-1}">
                                                <div class="swiper-slide slide${i}">
                                                   <div class="rcs_head">[WEB발신]
                                                      <c:if test="${content.rcs_option eq 'ad'}">
                                                         광고
                                                      </c:if>
                                                      <c:if test="${content.rcs_option eq 'guide'}">
                                                         안내
                                                      </c:if>
                                                   </div>
                                                   <section>
                                                      <div class="img_area">
                                                         <c:if test="${i eq 0}">
                                                            <c:if test="${not empty content.rcs_img_url_1}">
                                                               <img src="${content.rcs_img_url_1}" onerror="this.src = '/image/bg_none.png'" alt=""/>
                                                            </c:if>
                                                         </c:if>
                                                         <c:if test="${i eq 1}">
                                                            <c:if test="${not empty content.rcs_img_url_2}">
                                                               <img src="${content.rcs_img_url_2}" onerror="this.src = '/image/bg_none.png'" alt=""/>
                                                            </c:if>
                                                         </c:if>
                                                         <c:if test="${i eq 2}">
                                                            <c:if test="${not empty content.rcs_img_url_3}">
                                                               <img src="${content.rcs_img_url_3}" onerror="this.src = '/image/bg_none.png'" alt=""/>
                                                            </c:if>
                                                         </c:if>
                                                         <c:if test="${i eq 3}">
                                                            <c:if test="${not empty content.rcs_img_url_4}">
                                                               <img src="${content.rcs_img_url_4}" onerror="this.src = '/image/bg_none.png'" alt=""/>
                                                            </c:if>
                                                         </c:if>
                                                         <c:if test="${i eq 4}">
                                                            <c:if test="${not empty content.rcs_img_url_5}">
                                                               <img src="${content.rcs_img_url_5}" onerror="this.src = '/image/bg_none.png'" alt=""/>
                                                            </c:if>
                                                         </c:if>
                                                         <c:if test="${i eq 5}">
                                                            <c:if test="${not empty content.rcs_img_url_6}">
                                                               <img src="${content.rcs_img_url_6}" onerror="this.src = '/image/bg_none.png'" alt=""/>
                                                            </c:if>
                                                         </c:if>
                                                      </div>
                                                      <!-- idx 설정 -->
                                                      <c:set var="idx" value="${i+1}"/>
                                                      <c:set var="title" value="title${idx}"/>
                                                      <c:set var="description" value="description${idx}"/>
                                                      <!-- JsonArray 안의 첫번째 값 가져와서 파싱 -->
                                                      <div class="txt_area">
                                                         <h3>${rcsLst[0][title]}</h3>
                                                         <p>${cutil:replaceBr(rcsLst[0][description])}</p>
                                                      </div>
                                                      <div class="rcs_btn_wrap">
                                                         <c:forEach var="btn" items="${jsonContent.cont_btn_json[i]['suggestions']}">
                                                            <div class="rcs_action">
                                                                  ${btn['action']['displayText']}
                                                            </div>
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
                     <!-- RCS 영역 끝 -->
                     </c:if>
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