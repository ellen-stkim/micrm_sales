<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil" %>
<!-- smsCreste.js -->
<script src="/js/smsCreate.js"></script>
<!-- image upload js -->
<script src="/js/imageUpload.js"></script>
<!-- container 영역 시작 -->
<section class="container">
    <!-- 컨텐츠 영역 시작 -->
    <div class="contents">
        <!-- row 영역 시작 -->
        <div class="row tooltip_area bottom-border min-width cf">
            <div class="left">
                <!-- location 영역 -->
                <ul class="location">
                    <li>홈</li>
                    <li>메세지</li>
                    <li>모바일</li>
                    <li>모바일 컨텐츠 수정</li>
                </ul>
            </div>
            <div class="right">
                <span class="btn_sm_line" style="width: 75px; margin: 7px 7px 0 0;" id="contLoad">불러오기</span>
            </div>
        </div>
        <!-- row 영역 끝 -->
        <!-- section 영역 시작 -->
        <div class="section">
            <form:form id="form" action="#" method="post">
            <div class="create_sms cf">
                <div class="row head bottom-border">
                    <input type="hidden" id="seq" name="mst_seq" value="${list[0].seq}"/>
                    <input type="hidden" id="usr_grp_cd" name="usr_grp_cd" value="${list[0].cont_grp_cd}"/>
                    <input type="hidden" id="cont_grp_cd" name="cont_grp_cd" value="${list[0].cont_grp_cd}"/>
                    <div class="th">템플릿 명</div>
                    <div class="td right-border">
                        <input type="text" class="txt_input template_name" name="cont_nm" value="${list[0].cont_nm}"/>
                    </div>
                    <div class="th">컨텐츠 포맷</div>
                    <div class="td flex_row">
                        <div class="sms_option cf">
                            <label class="custom_check2 kakao">
                                <c:if test="${kakaoCnt ne 0}">
                                    <input name="formatType" type="checkbox" value="kakao" class="formatType" <c:if test="${list[0].list_use_yn eq 'Y'}">checked</c:if>/>
                                </c:if>
                                <c:if test="${kakaoCnt eq 0}">
                                    <input name="formatType" type="checkbox" value="kakao" class="formatType" disabled/>
                                </c:if>
                                <span>카카오톡</span>
                            </label>
                            <label class="custom_check2 sms">
                                <c:if test="${smsCnt ne 0}">
                                    <input name="formatType" type="checkbox" value="sms" class="formatType" <c:if test="${list[1].list_use_yn eq 'Y'}">checked</c:if>/>
                                </c:if>
                                <c:if test="${smsCnt eq 0}">
                                    <input name="formatType" type="checkbox" value="sms" class="formatType" disabled/>
                                </c:if>
                                <span>문자</span>
                            </label>
                            <label class="custom_check2 rcs">
                                <c:if test="${rcsCnt ne 0}">
                                    <input name="formatType" type="checkbox" value="rcs" class="formatType" <c:if test="${list[2].list_use_yn eq 'Y'}">checked</c:if>/>
                                </c:if>
                                <c:if test="${rcsCnt eq 0}">
                                    <input name="formatType" type="checkbox" value="rcs" class="formatType" disabled/>
                                </c:if>
                                <span class="en_font">RCS</span>
                            </label>
                        </div>
                        <div class="inner_option area2">
                            <div class="th left-border">유형선택</div>
                            <div class="td cf">
                                <label class="block_radio on">
                                    <input type="radio" name="commonType" class="js-ad" value="ad" <c:if test="${list[0].send_tp eq 'SENDTP01' }">checked</c:if>/>
                                    <span>광고</span>
                                </label>
                                <label class="block_radio">
                                    <input type="radio" name="commonType" class="js-ad" value="guide" <c:if test="${list[0].send_tp eq 'SENDTP02'}">checked</c:if>/>
                                    <span>안내</span>
                                </label>
                                <input type="hidden" name="kko_option" class="kakaoOption" value="${list[0].send_tp eq 'SENDTP01' ? 'ad' : 'guide'}"/>
                                <input type="hidden" name="sms_option" class="smsOption" value="${list[0].send_tp eq 'SENDTP01' ? 'ad' : 'guide'}"/>
                                <input type="hidden" name="rcs_option" class="radioAd" value="${list[0].send_tp eq 'SENDTP01' ? 'ad' : 'guide'}"/>
                            </div>
                        </div>
                        <div class="th left-border">수신 번호</div>
                        <div class="inner_option area2">
                            <div class="td cf" style="width: 100%;">
                                <div class="select" id="recv_phone_to" name="edmDB">
                                    <!-- selected value -->
                                    <div class="value" data="${list[0].from_to}">${list[0].from_to}</div>
                                    <ul class="option mappingLst"></ul>
                                </div>
                                <input type="hidden" id="recv_phone" name="from_to" value="${list[0].from_to}"/>
                            </div>
                        </div>
                    </div>
                </div><!-- //row end -->
                <!-- no data -->
                <div class="no_data" id="sms_no_data">
                    컨텐츠 포맷을 선택해 주세요.
                </div>
                <!-- Tab menu -->
                <ul class="tab_row" id="js-smsTab">
                    <li<c:if test="${list[0].list_use_yn eq 'Y'}"> class="on"</c:if>>
                        <span>카카오톡</span>
                    </li>
                    <li<c:if test="${list[0].list_use_yn eq 'N' && list[1].list_use_yn eq 'Y'}"> class="on"</c:if>>
                        <span>문자</span>
                    </li>
                    <li<c:if test="${list[2].list_use_yn eq 'Y'}"> class="on"</c:if>>
                        <span>RCS</span>
                    </li>
                </ul>
                <c:if test="${list[0].list_use_yn eq 'Y'}">
                <div class="tab_contents active">
                </c:if>
                    <c:if test="${list[0].list_use_yn eq 'N'}">
                    <div class="tab_contents">
                    </c:if>
                        <c:set var="cont_tp" value="${list[0].cont_tp}"/>
                        <div class="sms_form right-border cover" id="kakao">
                            <h2>카카오톡</h2>
                            <div class="flex_box">
                                <div class="left_area">
                                    <div class="row body">
                                        <input type="hidden" name="list_seq" value="${list[0].list_seq}"/>
                                        <div class="th">문자 제목</div>
                                        <div class="column_1">
                                            <input type="text" class="title kakaoTitle" name="cont_sub_list" value="${list[0].cont_sub}"/>
                                            <span class="ex_txt">※ 실제 발송에는 반영되지 않습니다.</span>
                                        </div>
                                    </div>
                                    <div class="row body">
                                        <div class="th">타입</div>
                                        <div class="column_2">
                                            <label class="type_check"><input type="radio" name="kko_format_type"
                                                                             class="kkoType"
                                                                             value="kko_ft" ${cont_tp eq "DMTP03"?'checked': '' }
                                                                             /><span>친구톡</span></label>
                                            <label class="type_check"><input type="radio" name="kko_format_type"
                                                                             class="kkoType" ${cont_tp eq "DMTP05"?'checked': '' }
                                                                             value="kko_at"/><span>알림톡</span></label>
                                        </div>
                                    </div>
                                    <div class="row body">
                                        <div class="th">발신 프로필</div>
                                        <div class="column_1">
                                            <!-- 발신 번호 후에 세팅한 값으로 변경 필요 -->
                                            <input type="text" class="sms_number smsNumber_kko" id="send_to"
                                                    <c:if test="${fn:trim(list[0].send_num) != ''}">
                                                        value="${list[0].sender}(${cutil:numberToPhone(list[0].send_num)})" readonly
                                                    </c:if>
                                                    <c:if test="${fn:trim(list[0].send_num) == ''}">
                                                        placeholder="발신 프로필을 입력해주세요"
                                                    </c:if>
                                            />
                                            <input type="hidden" name="send_key" id="send_key" value="${list[0].send_num}"/>
                                            <input type="hidden" name="send_to_list" id="kakao_send_to_num" value="${list[0].send_to}"/>
                                            <span class="btn_sm_line" onclick="mobileSenderPopup('1','kko')">변경</span>

                                        </div>
                                    </div>
                                    <div class="input_area kko_area" id="kko_ft" ${cont_tp eq "DMTP03"?'': 'hidden' }>
                                        <div class="block">
                                            <div class="row">
                                                <div class="th">이미지 선택</div>
                                                <div class="td">
                                                    <div class="kko_delete_img" data="kakao">
                                                        <img src="${baseURL}/image/btn_delete1.png" alt="삭제" onerror="this.src = '/image/btn_delete1.png'">
                                                    </div>
                                                    <input type="text" class="txt_input en_font" name="" id="kakaoImage" value="${cont_tp eq "DMTP03" ? list[0].kko_img_nm : ''}" readonly/>
                                                    <span class="btn_sm_line" data="kakaoImage" onclick="imageListPopUp('1','kakaoImage')">선택</span>
                                                    <!-- 카카오 이미지 저장 넘버 -->
                                                    <input type="hidden" name="kko_img_cd" value="${cont_tp eq "DMTP03" ? list[0].kko_img_cd: ''}"/>
                                                    <!-- 프리뷰를 위한 이미지 URL -->
                                                    <input type="hidden" name="kko_view_img_url"
                                                    <c:if test="${cont_tp eq 'DMTP03'  &&list[0].kko_img_lst ne null}">
                                                           value="${filePath}${list[0].kko_img_lst}"
                                                    </c:if>
                                                    >
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="th top-border">이미지 링크 주소</div>
                                                <div class="td top-border">
                                                    <input type="text" class="txt_input en_font width kakaoImgLink" name="kko_img_url" onblur="smsCreate.imageLinkAdd(this);" value="${cont_tp eq 'DMTP03'? list[0].kko_img_url : ''}" placehorder="URL 입력 (http:// 또는 https://필수입력)"/>
                                                </div>
                                            </div>
                                            <div class="row flex_row">
                                                <div class="th top-border">이미지 미리보기</div>
                                                <div class="td top-border">
                                                    <div class="col_img" id="js-kakao-img">
                                                        <!-- 이미지는 있고, 이미지 링크는 없을때 -->
                                                        <c:if test="${cont_tp eq 'DMTP03'}">
                                                            <c:if test="${fn:trim(list[0].kko_img_lst) != '' && fn:trim(list[0].kko_img_url) == ''}">
                                                                <a href="${list[0].kko_img_lst}" target="_blank">
                                                                    <img src="${filePath}${list[0].kko_img_lst}" onerror="this.src = '/image/bg_none.png'"/>
                                                                </a>
                                                            </c:if>
                                                            <!-- 이미지는 있고, 이미지 링크도 있을때 -->
                                                            <c:if test="${fn:trim(list[0].kko_img_lst) != '' && fn:trim(list[0].kko_img_url) != ''}">
                                                                <a href="${list[0].kko_img_url}" target="_blank">
                                                                    <img src="${filePath}${list[0].kko_img_lst}" onerror="this.src = '/image/bg_none.png'"/>
                                                                </a>
                                                            </c:if>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block">
                                            <div class="row flex_row">
                                                <div class="row flex_row input-img on">
                                                    <div class="th bottom-border">개인화 변수</div>
                                                    <div class="td bottom-border">
                                                        <span style="font-size: 9px">※ 아래 박스에서 개인화 변수를 드래그한 후, 텍스트 상자에 넣거나 클릭하여 추가할 수 있습니다.</span>
                                                        <div id="kakaoValue" style="width: 100%; max-height: 173px; overflow: auto; padding-top: 10px;"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row" style="height:150px;">
                                                <div class="th bottom-border">내용</div>
                                                <div class="td bottom-border">  <textarea name="kakao_body" class="kakao_txt textarea" cols="30" rows="10" style="width: 100%;height: 100%; resize: none;"
                                                                            onkeyup="onchangePrevKkoTxt(this)">${cont_tp eq 'DMTP03' ? list[0].cont_body :''}</textarea></div>
                                            </div>
                                            <div class="row">
                                                <div class="th">수신거부 문구</div>
                                                <div class="td">
                                                    <input type="text" class="txt_input" name="rejectText" style="width: calc(100% - 110px);"
                                                            <c:if test="${fn:trim(rejectText[0].list_nm) != ''}">
                                                                value="${rejectText[0].list_nm}(${cutil:numberToPhone(rejectText[0].list_val)})"
                                                            </c:if>
                                                            <c:if test="${fn:trim(rejectText[0].list_nm) == ''}">
                                                                placeholder="기본 수신거부 문구가 설정되어 있지 않습니다."
                                                            </c:if>
                                                    />
                                                    <div style="display: flex; width: 110px">
                                                        <span class="btn_sm_line btn_inline" onclick="addRejectText('kko_ft')">사용</span>
                                                        <span class="btn_sm_line btn_inline" onclick="mobileRejectTextPopup(1)">변경</span>
                                                    </div>
                                                    <input type="hidden" name="sms_trackinglink"/>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block">
                                            <div class="row">
                                                <div class="th bottom-border">버튼 링크 제목</div>
                                                <div class="td bottom-border">
                                                    <c:if test="${fn:trim(list[0].kko_btn_nm) != ''}">
                                                        <input type="text" name="kko_btn_nm"
                                                               class="txt_input width kakao_btn_name"
                                                               value="${list[0].kko_btn_nm}" readonly
                                                               onkeyup="smsCreate.titleCount(this,'kakao')"/>
                                                    </c:if>
                                                    <c:if test="${fn:trim(list[0].kko_btn_nm) == ''}">
                                                        <input type="text" name="kko_btn_nm"
                                                               class="txt_input width kakao_btn_name"
                                                               placeholder="버튼 링크 제목을 입력해주세요."
                                                               onkeyup="smsCreate.titleCount(this,'kakao')"
                                                        />
                                                    </c:if>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="th bottom-border">버튼 링크 주소</div>
                                                <div class="td bottom-border">
                                                    <input type="text" name="kko_btn_url"
                                                           class="txt_input en_font kakao_btn_link"
                                                            <c:if test="${fn:trim(list[0].kko_btn_nm) != ''}">
                                                                readonly
                                                            </c:if>
                                                           value="${list[0].kko_btn_url}"
                                                           placehorder="URL 입력 (http:// 또는 https://필수입력)"/>
                                                    <input type="button" class="btn_sm_line kakaoLinkBtn"
                                                            <c:if test="${fn:trim(list[0].kko_btn_url) == ''}">
                                                                value ="생성"
                                                            </c:if>
                                                            <c:if test="${fn:trim(list[0].kko_btn_url) != ''}">
                                                                value="삭제"
                                                            </c:if>
                                                    />
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="th">추적 링크 생성</div>
                                                <div class="td">
                                                    <input type="text" class="txt_input en_font" id="kakaoTracking"
                                                           placeholder="URL 입력 (http:// 또는 https://필수입력)"/>
                                                    <span class="btn_sm_line trackingLinkBtn">생성</span>
                                                    <input type="hidden" name="kko_trackinglink"/>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="input_area kko_area" id="kko_at" ${cont_tp eq "DMTP05"?'': 'hidden'}>
                                        <div class="block">
                                            <div class="row">
                                                <div class="th">템플릿 선택</div>
                                                <div class="td">
                                                    <div class="delete_tmpl" data="kakao">
                                                        <img src="${baseURL}/image/btn_delete1.png" alt="삭제" >
                                                    </div>
                                                    <input type="text" class="txt_input en_font at_tmpl_data" name="tmpl_nm" id="tmplNm" value="${list[0].tmpl_nm}" placeholder="템플릿을 선택해 주세요." readonly/>
                                                    <input type="text" name="key_id" id="templateCode" class="at_tmpl_data" value="${list[0].tmpl_cd}" readonly hidden/>
                                                    <span class="btn_sm_line" data="kakaoImage" onclick="tmplListPopUp('1')">선택</span>
                                                    <!-- 프리뷰를 위한 이미지 URL -->
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <c:if test="${cont_tp eq 'DMTP03'}">
                                    <div class="viewer_area" id="kakao_ft_viewer" >
                                        <div class="top">친구톡 미리보기</div>
                                        <div class="inner">
                                            <div class="row_body">
                                                <div class="round_box">
                                                    <div class="kakao_ft sms_img_box" id="prev_ft_img">
                                                        <!-- 이미지는 있고, 이미지 링크는 없을때 -->
                                                        <c:if test="${cont_tp eq 'DMTP03'}">
                                                            <c:if test="${fn:trim(list[0].kko_img_lst) != '' && fn:trim(list[0].kko_img_url) == ''}">
                                                                <a href="${list[0].kko_img_lst}" target="_blank">
                                                                    <img src="${filePath}${list[0].kko_img_lst}"  onerror="this.src = '/image/bg_none.png'"/>
                                                                </a>
                                                            </c:if>
                                                            <!-- 이미지는 있고, 이미지 링크도 있을때 -->
                                                            <c:if test="${fn:trim(list[0].kko_img_lst) != '' && fn:trim(list[0].kko_img_url) != ''}">
                                                                <a href="${list[0].kko_img_url}" target="_blank">
                                                                    <img src="${filePath}${list[0].kko_img_lst}" onerror="this.src = '/image/bg_none.png'"/>
                                                                </a>
                                                            </c:if>
                                                        </c:if>
                                                    </div>
                                                    <p class="kakao_txt" id="prev_ft_txt">${cutil:replaceBr(list[0].cont_body)}</p>
                                                    <c:if test="${fn:trim(list[0].kko_btn_nm) != ''}">
                                                        <a href="${list[0].kko_btn_url}" class="kakao_link"
                                                           target="_blank">${list[0].kko_btn_nm}</a>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="byte">
                                            <span class="en_font kakao_byte">0</span><span class="en_font">byte</span>(버튼제외)
                                        </div>
                                    </div>
                                    <div class="viewer_area" id="kakao_at_viewer" hidden>
                                        <div class="top">미리보기</div>
                                        <div class="at_inner template_body">
                                            <div class="text">
                                                <div class="row_body">
                                                    <div class="round_box">
                                                        <div class="round_box head">
                                                            <p>알림톡 도착</p>
                                                        </div>
                                                        <div class="at_tmpl_data">
                                                        <div class="at_tmpl_data"></div>
                                                        <input type="hidden" class="kakao_txt" name="kakao_body"
                                                               value="">
                                                        <a href="" class="sms_btn"></a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                                <c:if test="${cont_tp eq 'DMTP05'}">
                                    <div class="viewer_area" id="kakao_ft_viewer" hidden>
                                        <div class="top">친구톡 미리보기</div>
                                        <div class="inner">
                                            <div class="row_body">
                                                <div class="round_box">
                                                    <div class="kakao_ft sms_img_box" id="prev_ft_img">
                                                    </div>
                                                    <p class="kakao_txt" id="prev_ft_txt"></p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="byte">
                                            <span class="en_font kakao_byte">0</span><span class="en_font">byte</span>(버튼제외)
                                        </div>
                                    </div>
                                    <div class="viewer_area" id="kakao_at_viewer">
                                        <div class="top">미리보기</div>
                                        <div class="at_inner template_body">
                                            <div class="text">
                                                <div class="row_body">
                                                    <div class="round_box" >
                                                        <div class="round_box head">
                                                            <p>알림톡 도착</p>
                                                        </div>
                                                        <div class="at_tmpl_data">
                                                            <!-- 이미지형  아이템리스트형 -->
                                                            <c:set var="tmpl" value="${list[0]}"/>
                                                            <c:if test="${tmpl.tmpl_empsize_tp eq 'ITEM_LIST'  || tmpl.tmpl_empsize_tp eq 'IMAGE'}">
                                                                <c:if test="${!empty tmpl.kko_img_cd}">
                                                                    <div class="kko_img_box">
                                                                        <img src="${tmpl.kko_img_url}" style="max-height: 135px;"
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
                                                                        <div class="item_high_div">
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
                                                                    <c:if test="${fn:contains(tmpl.item_json,'\"list\"') ||fn:contains(tmpl.item_json,'\"summary\"')}">
                                                                        <div class="item_div">
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
                                                                            <c:if test="${fn:contains(tmpl.item_json,'\"summary\"')}">
                                                                                <div class="item_summary">
                                                                                    <span class="th">${tmpl.item_list_json.summary.title}</span>
                                                                                    <span class="td">${tmpl.item_list_json.summary.description}</span>
                                                                                </div>
                                                                            </c:if>
                                                                        </div>
                                                                    </c:if>
                                                                </c:if>
                                                                <div class="cont">${tmpl.cont_body}</div>
                                                                    <%--     부가 정보--%>
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
                                                            <input type="hidden" class="kakao_txt" name="kakao_body" value="${list[0].cont_body}">
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div><!-- sms_form end-->
                    <c:if test="${list[1].list_use_yn eq 'Y'}">
                    <div class="tab_contents active">
                        </c:if>
                        <c:if test="${list[1].list_use_yn eq 'N'}">
                        <div class="tab_contents">
                            </c:if>
                            <div class="sms_form cover" id="sms">
                                <h2>문자</h2>
                                <div class="flex_box">
                                    <div class="left_area">
                                        <div class="row body">
                                            <input type="hidden" name="list_seq" value="${list[1].list_seq}"/>
                                            <div class="th">문자 제목</div>
                                            <div class="column_1">
                                                <div class="column_5">
                                                    <input type="text" class="title type1 smsTitle" name="cont_sub_list" onkeyup="onchangePrevSmsTitle(this)" value="${list[1].cont_sub}"/>
                                                    <span class="title_byte en_font">(40byte)</span>
                                                </div>
                                                <!-- select 영역 시작 -->
                                                <div class="select column_4 left-border" id="smsTitleVal" name="edmDB">
                                                    <!-- selected value -->
                                                    <div class="value" data="0">제목 개인화 변수</div>
                                                    <ul class="option mappingLst">
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row body">
                                            <div class="th">발신 번호</div>
                                            <div class="column_1">
                                                <input type="text" class="sms_number smsNumber" id="sms_send_to"
                                                        <c:if test="${fn:trim(list[1].send_to) != ''}">
                                                            value="${list[1].sender}(${cutil:numberToPhone(list[1].send_num)})"
                                                        </c:if>
                                                        <c:if test="${fn:trim(list[1].send_to) == ''}">
                                                            placeholder = "발신 번호를 입력해주세요"
                                                        </c:if>
                                                       readonly/>
                                                <input type="hidden" id="sms_send_to_num" name="send_to_list" value="${list[1].send_to}"/>
                                                <span class="btn_sm_line" onclick="mobileSenderPopup('1','sms')">변경</span>
                                            </div>
                                        </div>
                                        <div class="input_area left">
                                            <div class="block">
                                                <div class="row">
                                                    <div class="th">문자 종류</div>
                                                    <div class="td">
                                                        <label class="custom_radio">LMS
                                                            <input class="smsType" name="sms_msg_tp" type="radio" value="LMS" <c:if test="${fn:trim(list[1].msg_tp) eq 'DMCH202'}">checked</c:if>/>
                                                            <span></span>
                                                        </label>
                                                        <label class="custom_radio">MMS
                                                            <input class="smsType" name="sms_msg_tp" type="radio" value="MMS" <c:if test="${fn:trim(list[1].msg_tp) eq 'DMCH203'}">checked</c:if>/>
                                                            <span></span>
                                                        </label>
                                                        <label class="custom_radio">SMS
                                                            <input class="smsType" name="sms_msg_tp" type="radio" value="SMS" <c:if test="${fn:trim(list[1].msg_tp) eq 'DMCH201'}">checked</c:if>/>
                                                            <span></span>
                                                        </label>
                                                    </div>
                                                </div>
                                                <div class="row input-img <c:if test="${fn:trim(list[1].msg_tp) eq 'DMCH203'}">on</c:if>">
                                                    <div class="th top-border <c:if test="${fn:trim(list[1].msg_tp) eq 'DMCH203'}">on</c:if>">이미지 선택</div>
                                                    <div class="td top-border">
                                                        <div class="sms_delete_img">
                                                            <img src="${baseURL}/image/btn_delete1.png" alt="삭제" onerror="this.src = '/image/bg_none.png'">
                                                        </div>
                                                        <input type="text" class="txt_input" name="" id="smsImage" value="${fn:split(list[1].img_nm_lst,",")[0]}" readonly/>
                                                        <input type="hidden" id="mds_img_cd" name="mds_img_cd" value="${list[1].img_cd_1}"/>
                                                        <span class="btn_sm_line" data="smsImage" onclick="imageListPopUp('1','smsImage');">선택</span>
                                                    </div>
                                                    <input type="hidden" name="mms_imgurl" value="${fn:split(list[1].img_lst,",")[0]}"/>
                                                </div>
                                                <div class="row flex_row input-img <c:if test="${fn:trim(list[1].msg_tp) eq 'DMCH203'}">on</c:if>">
                                                    <div class="th top-border">이미지 미리보기</div>
                                                    <div class="td top-border">
                                                        <div class="col_img" id="js-sms-img">
                                                            <c:if test="${fn:trim(list[1].msg_tp) eq 'DMCH203'}">
                                                            <a href="${fn:split(list[1].img_lst,",")[0]}" target="_blank">
                                                                <img src="${filePath}${fn:split(list[1].img_lst,",")[0]}"  onerror="this.src = '/image/bg_none.png'" />
                                                            </a>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="block">
                                                <div class="row flex_row input-img on">
                                                    <div class="th bottom-border">개인화 변수</div>
                                                    <div class="td bottom-border">
                                                        <span style="font-size: 9px">※ 아래 박스에서 개인화 변수를 드래그한 후, 텍스트 상자에 넣거나 클릭하여 추가할 수 있습니다.</span>
                                                        <div id="smsContsVal" style="width: 100%; max-height: 173px; overflow: auto; padding-top: 10px;"></div>
                                                    </div>
                                                </div>
                                                <div class="row"  style="height:150px;">
                                                    <div class="th bottom-border">내용</div>
                                                    <div class="td bottom-border"> <textarea name="sms_body" class="sms_body textarea" id="sms_txt_area" cols="30" rows="10" style="width: 100%;height: 100%; resize: none;"
                                                                               onkeyup="onchangePrevSmsTxt(this)">${list[1].cont_body}</textarea></div>
                                                </div>
                                                <div class="row">
                                                    <div class="th">수신거부 문구</div>
                                                    <div class="td">
                                                        <input type="text" class="txt_input" name="rejectText" style="width: calc(100% - 110px);"
                                                                <c:if test="${fn:trim(rejectText[0].list_nm) != ''}">
                                                                    value="${rejectText[0].list_nm}(${cutil:numberToPhone(rejectText[0].list_val)})"
                                                                </c:if>
                                                                <c:if test="${fn:trim(rejectText[0].list_nm) == ''}">
                                                                    placeholder="기본 수신거부 문구가 설정되어 있지 않습니다."
                                                                </c:if>
                                                        />
                                                        <div style="display: flex; width: 110px">
                                                            <span class="btn_sm_line btn_inline" onclick="addRejectText('sms')">사용</span>
                                                            <span class="btn_sm_line btn_inline" onclick="mobileRejectTextPopup(1)">변경</span>
                                                        </div>
                                                        <input type="hidden" name="sms_trackinglink"/>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="block">
                                                <div class="row">
                                                    <div class="th">추적 링크 생성</div>
                                                    <div class="td">
                                                        <input type="text" class="txt_input" id="smsTracking" placeholder="URL 입력 (http:// 또는 https://필수입력)"/>
                                                        <span class="btn_sm_line trackingLinkBtn">생성</span>
                                                        <input type="hidden" name="sms_trackinglink"/>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="viewer_area">
                                        <div class="top">문자 미리보기</div>
                                        <div class="inner" style="width: 270px">
                                            <div class="sms_title" id="prev_sms_title">${list[1].cont_sub}</div>
                                                <%--                                        <div class="sms_img"></div>--%>
                                            <div class="sms_img_box" id="sms_img_box"><c:if
                                                    test="${fn:trim(list[1].msg_tp) eq 'DMCH203'}">
                                                <a href="${fn:split(list[1].img_lst,",")[0]}" target="_blank">
                                                    <img src="${filePath}${fn:split(list[1].img_lst,",")[0]}"  onerror="this.src = '/image/bg_none.png'"/>
                                                </a>
                                            </c:if></div>
                                            <div class="text_box"><p class="scroll_txt_area" id="smsTextArea">${cutil:replaceBr(list[1].cont_body)}</p></div>
                                        </div>
                                        <div class="byte"  style="width: 270px">
                                            <span class="en_font sms_byte">0</span><span class="en_font">byte</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- RCS Contents 시작 -->
                        <c:if test="${list[2].list_use_yn eq 'Y'}">
                        <div class="tab_contents active">
                            </c:if>
                            <c:if test="${list[2].list_use_yn eq 'N'}">
                            <div class="tab_contents">
                                </c:if>
                                <div class="sms_form right-border cover" id="rcs">
                                    <h2>RCS</h2>
                                    <div class="row body">
                                        <input type="hidden" name="list_seq" value="${list[2].list_seq}"/>
                                        <div class="th">포맷카드</div>
                                        <div class="column_2 right-border">
                                            <!-- 텍스트형 check -->
                                            <label class="type_check">
                                                <input type="radio" name="rcs_format_type" class="rcsType" value="text" <c:if test="${list[2].msg_tp eq 'DMCH205' || list[2].msg_tp eq 'DMCH206' }">checked</c:if>/>
                                                <span>텍스트형</span>
                                            </label>
                                            <label class="type_check">
                                                <input type="radio" name="rcs_format_type" class="rcsType" value="vertical" <c:if test="${list[2].msg_tp eq 'DMCH207' || list[2].msg_tp eq 'DMCH208'}">checked</c:if>/>
                                                <span>세로형</span>
                                            </label>
                                            <label class="type_check">
                                                <input type="radio" name="rcs_format_type" class="rcsType" value="slide" <c:if test="${list[2].msg_tp eq 'DMCH211' || list[2].msg_tp eq 'DMCH212'}">checked</c:if>/>
                                                <span>슬라이드형</span>
                                            </label>
                                        </div>
                                        <div class="view_title left">미리보기</div>
                                    </div>
                                    <!-- rcs layout 시작 -->
                                    <c:if test="${list[2].msg_tp eq 'DMCH205'}">
                                        <!-- 기본 RCS TEXT 타입일 경우만 인덱스 순설르 위해 cont_sub_list 추가 -->
                                        <input type="hidden" name="cont_sub_list" value="" id="rcs_cont_sub">
                                    </c:if>
                                    <div class="rcs_layout" id="js-replace">
                                        <div class="flex_box" <c:if test="${list[2].msg_tp eq 'DMCH211' || list[2].msg_tp eq 'DMCH212'}">id="js-rcs-area"</c:if>>
                                            <div class="left_area">
                                                <!-- RCS TEXT형 Layout -->
                                                <c:if test="${list[2].msg_tp eq 'DMCH205' || list[2].msg_tp eq 'DMCH206'}">
                                                <!-- start -->
                                                <div class="row body">
                                                    <div class="th">카드 양식</div>
                                                    <div class="column_1">
                                                        <label class="custom_radio en_font">SMS
                                                            <input name="rcs_msg_tp"
                                                                   class="lowType"
                                                                   type="radio"
                                                                   value="sms"
                                                                    <c:if test="${list[2].msg_tp eq 'DMCH205'}">
                                                                        checked
                                                                    </c:if>
                                                            />
                                                            <span></span>
                                                        </label>
                                                        <label class="custom_radio en_font">LMS
                                                            <input name="rcs_msg_tp"
                                                                   class="lowType"
                                                                   type="radio"
                                                                   value="lms"
                                                                    <c:if test="${list[2].msg_tp eq 'DMCH206'}">
                                                                        checked
                                                                    </c:if>
                                                            />
                                                            <span></span>
                                                        </label>
                                                    </div>
                                                </div>
                                                <c:if test="${list[2].msg_tp eq 'DMCH206'}">
                                                    <div class="row body">
                                                        <div class="th">문자 제목</div>
                                                        <div class="column_3">
                                                            <c:if test="${fn:trim(list[2].cont_sub) == ''}">
                                                                <input type="text" name="cont_sub_list" class="title rcsTitle" placeholder="최대 30자 이내 입력" onkeyup="rcsCreate.rcsTitle(this, 0);"/>
                                                            </c:if>
                                                            <c:if test="${fn:trim(list[2].cont_sub) != ''}">
                                                                <input type="text" name="cont_sub_list" class="title rcsTitle" value="${list[2].cont_sub}" onkeyup="rcsCreate.rcsTitle(this, 0);"/>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </c:if>
                                                <div class="row body">
                                                    <div class="th">발신 번호</div>
                                                    <div class="column_1" id="send_text_column">
                                                        <c:if test="${fn:trim(list[2].send_to) == ''}">
                                                            <input type="text" class="sms_number" id="send_text_rcs" placeholder="발신 번호를 입력해주세요." readonly/>
                                                        </c:if>
                                                        <c:if test="${fn:trim(list[2].send_to) != ''}">
                                                            <input type="text" class="sms_number" id="send_text_rcs" value="${list[2].sender}(${list[2].send_num})" readonly/>
                                                        </c:if>
                                                        <input type="hidden" name="send_to_list" id="text_send_num" value="${list[2].send_to}"/>
                                                        <span class="btn_sm_line" onclick="mobileSenderPopup('1','textrcs')">변경</span>
                                                    </div>
                                                </div>
                                                <div class="input_area left">
                                                    <div class="block">
                                                        <div class="row">
                                                            <div class="th">개인화 변수</div>
                                                            <div class="td">
                                                                <!-- select 영역 시작 -->
                                                                <div class="select rcsContsVal" name="edmDB">
                                                                    <!-- selected value -->
                                                                    <div class="value" data="0">개인화 변수</div>
                                                                    <ul class="option mappingLst">
                                                                    </ul>
                                                                </div>
                                                                <!-- select 영역 끝 -->
                                                            </div>
                                                        </div>
                                                        <div class="row rcs_textarea">
                                                            <div class="th top-border">내용</div>
                                                            <div class="td top-border">
                                                                <textarea class="rcsContents" name="rcs_body" id="" cols="30" rows="10" placeholder="내용을 입력해주세요." onkeyup="rcsCreate.rcsContents(this, 0);">${list[2].cont_body}</textarea>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <c:if test="${list[2].msg_tp eq 'DMCH205'}">
                                                        <!-- RCS SMS 타입인 경우 버튼은 한 개만 존재한다-->
                                                        <div id="btn-action-area">
                                                            <div class="block">
                                                                <div class="row">
                                                                    <div class="th bottom-border">버튼 액션 선택</div>
                                                                    <div class="td bottom-border">
                                                                        <!-- select 영역 시작 -->
                                                                        <!-- 초기 rcs_btn_tp_1 값 랜딩, 밑에 같이 선언하면 html로 다시 씌어져 작동안함 -->
                                                                        <c:choose>
                                                                            <c:when test="${list[2].btnType[0] eq 'clipboardAction'}">
                                                                                <input type="hidden" name="rcs_btn_tp_1" value="RBTN01"/>
                                                                            </c:when>
                                                                            <c:when test="${list[2].btnType[0] eq 'urlAction'}">
                                                                                <input type="hidden" name="rcs_btn_tp_1" value="RBTN02"/>
                                                                            </c:when>
                                                                            <c:when test="${list[2].btnType[0] eq 'dialerAction'}">
                                                                                <input type="hidden" name="rcs_btn_tp_1" value="RBTN03"/>
                                                                            </c:when>
                                                                            <c:when test="${list[2].btnType[0] eq 'latitude'}">
                                                                                <input type="hidden" name="rcs_btn_tp_1" value="RBTN04"/>
                                                                            </c:when>
                                                                            <c:when test="${list[2].btnType[0] eq 'query'}">
                                                                                <input type="hidden" name="rcs_btn_tp_1" value="RBTN05"/>
                                                                            </c:when>
                                                                            <c:when test="${list[2].btnType[0] eq 'requestLocationPush'}">
                                                                                <input type="hidden" name="rcs_btn_tp_1" value="RBTN06"/>
                                                                            </c:when>
                                                                            <c:when test="${list[2].btnType[0] eq 'calendarAction'}">
                                                                                <input type="hidden" name="rcs_btn_tp_1" value="RBTN07"/>
                                                                            </c:when>
                                                                            <c:when test="${list[2].btnType[0] eq 'composeAction'}">
                                                                                <input type="hidden" name="rcs_btn_tp_1" value="RBTN08"/>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <input type="hidden" name="rcs_btn_tp_1" value=""/>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                        <input type="hidden" name="rcs_btn_tp_2" value=""/>
                                                                        <input type="hidden" name="rcs_btn_tp_3" value=""/>
                                                                        <div class="select action_select" data="1">
                                                                            <!-- SMS 는 버튼 타입 1개 이므로 알맞게 기존 값 매칭해 준다 -->
                                                                            <c:choose>
                                                                                <c:when test="${list[2].btnType[0] eq 'clipboardAction'}">
                                                                                    <div class="value" data="RBTN01" style="color: rgb(34, 34, 34);">
                                                                                        복사하기
                                                                                    </div>
                                                                                </c:when>
                                                                                <c:when test="${list[2].btnType[0] eq 'urlAction'}">
                                                                                    <div class="value" data="RBTN02" style="color: rgb(34, 34, 34);">
                                                                                        URL연결
                                                                                    </div>
                                                                                </c:when>
                                                                                <c:when test="${list[2].btnType[0] eq 'dialerAction'}">
                                                                                    <div class="value" data="RBTN03" style="color: rgb(34, 34, 34);">
                                                                                        전화걸기
                                                                                    </div>
                                                                                </c:when>
                                                                                <c:when test="${list[2].btnType[0] eq 'latitude'}">
                                                                                    <div class="value" data="RBTN04" style="color: rgb(34, 34, 34);">
                                                                                        지도보여주기(좌표)
                                                                                    </div>
                                                                                </c:when>
                                                                                <c:when test="${list[2].btnType[0] eq 'query'}">
                                                                                    <div class="value" data="RBTN05" style="color: rgb(34, 34, 34);">
                                                                                        지도보여주기(쿼리)
                                                                                    </div>
                                                                                </c:when>
                                                                                <c:when test="${list[2].btnType[0] eq 'requestLocationPush'}">
                                                                                    <div class="value" data="RBTN06" style="color: rgb(34, 34, 34);">
                                                                                        현재위치공유
                                                                                    </div>
                                                                                </c:when>
                                                                                <c:when test="${list[2].btnType[0] eq 'calendarAction'}">
                                                                                    <div class="value" data="RBTN07" style="color: rgb(34, 34, 34);">
                                                                                        캘린더등록
                                                                                    </div>
                                                                                </c:when>
                                                                                <c:when test="${list[2].btnType[0] eq 'composeAction'}">
                                                                                    <div class="value" data="RBTN08" style="color: rgb(34, 34, 34);">
                                                                                        메세지전송
                                                                                    </div>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <div class="value" data="0">액션선택
                                                                                    </div>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                            <!-- option -->
                                                                            <ul class="option">
                                                                                <li data="0">액션선택</li>
                                                                                <li data="RBTN01">복사하기</li>
                                                                                <li data="RBTN02">URL연결</li>
                                                                                <li data="RBTN03">전화걸기</li>
                                                                                <li data="RBTN04">지도보여주기(좌표)</li>
                                                                                <li data="RBTN05">지도보여주기(쿼리)</li>
                                                                                <li data="RBTN06">현재위치공유</li>
                                                                                <li data="RBTN07">캘린더등록</li>
                                                                                <li data="RBTN08">메시지전송</li>
                                                                            </ul>
                                                                        </div>
                                                                        <!-- select 영역 끝 -->
                                                                    </div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="th">버튼 명</div>
                                                                    <div class="td button-name">
                                                                        <!-- 버튼명이 존재할 경우 -->
                                                                        <c:if test="${fn:trim(list[2].btnText[0]) != ''}">
                                                                            <input type="text" name="rcs_btn_1"
                                                                                   class="txt_input action_name" data="1"
                                                                                   onkeyup="rcsCreate.buttonCount(this, 'text');"
                                                                                   value="${list[2].btnText[0]}"/>
                                                                        </c:if>
                                                                        <!-- 버튼명이 없을 경우 -->
                                                                        <c:if test="${fn:trim(list[2].btnText[0]) == ''}">
                                                                            <input type="text" name="rcs_btn_1"
                                                                                   class="txt_input action_name" data="1"
                                                                                   onkeyup="rcsCreate.buttonCount(this, 'text');"
                                                                                   placeholder="버튼 명을 입력해주세요"
                                                                            />
                                                                        </c:if>
                                                                        <span class="text-count en_font">
                                                                <span>
                                                                <c:if test="${list[2].btnText[0] != ''}">
                                                                    ${fn:length(list[2].btnText[0])}
                                                                </c:if>
                                                                <c:if test="${list[2].btnText[0] == ''}">
                                                                    0
                                                                </c:if>
                                                                </span>/17</span>
                                                                    </div>
                                                                </div>
                                                                <div class="custom_box">
                                                                    <!-- 초기 버튼 selectBox 랜딩 서비스 -->
                                                                    <c:if test="${list[2].btnType[0] eq 'clipboardAction'}">
                                                                        <div class="row">
                                                                            <div class="th top-border">복사할 값</div>
                                                                            <div class="td top-border">
                                                                                <input type="text" name="copy_value"
                                                                                       class="txt_input width"
                                                                                       value="${list[2].btnData[0][0]}"/>
                                                                            </div>
                                                                        </div>
                                                                        <input type="hidden" name="url_value" value=" "/>
                                                                        <input type="hidden" name="phone_value_03" value=" "/>
                                                                        <input type="hidden" name="latitude_value" value=" "/>
                                                                        <input type="hidden" name="longitude_value" value=" "/>
                                                                        <input type="hidden" name="location_value_04" value=" "/>
                                                                        <input type="hidden" name="fallback_url_04" value=" "/>
                                                                        <input type="hidden" name="location_value_05" value=" "/>
                                                                        <input type="hidden" name="fallback_url_05" value=" "/>
                                                                        <input type="hidden" name="start_date" value=" "/>
                                                                        <input type="hidden" name="end_date" value=" "/>
                                                                        <input type="hidden" name="calendar_title" value=" "/>
                                                                        <input type="hidden" name="calendar_body" value=" "/>
                                                                        <input type="hidden" name="phone_value_08" value=" "/>
                                                                        <input type="hidden" name="message_value" value=" "/>
                                                                    </c:if>
                                                                    <c:if test="${list[2].btnType[0] eq 'urlAction'}">
                                                                        <div class="row">
                                                                            <div class="th top-border">URL</div>
                                                                            <div class="td top-border">
                                                                                <input type="text" name="url_value" class="txt_input width" data="url" value="${list[2].btnData[0][0]}"/>
                                                                            </div>
                                                                        </div>
                                                                        <input type="hidden" name="copy_value" value=" "/>
                                                                        <input type="hidden" name="phone_value_03" value=" "/>
                                                                        <input type="hidden" name="latitude_value" value=" "/>
                                                                        <input type="hidden" name="longitude_value" value=" "/>
                                                                        <input type="hidden" name="location_value_04" value=" "/>
                                                                        <input type="hidden" name="fallback_url_04" value=" "/>
                                                                        <input type="hidden" name="location_value_05" value=" "/>
                                                                        <input type="hidden" name="fallback_url_05" value=" "/>
                                                                        <input type="hidden" name="start_date" value=" "/>
                                                                        <input type="hidden" name="end_date" value=" "/>
                                                                        <input type="hidden" name="calendar_title" value=" "/>
                                                                        <input type="hidden" name="calendar_body" value=" "/>
                                                                        <input type="hidden" name="phone_value_08" value=" "/>
                                                                        <input type="hidden" name="message_value" value=" "/>
                                                                    </c:if>
                                                                    <c:if test="${list[2].btnType[0] eq 'dialerAction'}">
                                                                        <div class="row">
                                                                            <div class="th top-border">전화번호</div>
                                                                            <div class="td top-border">
                                                                                <input type="text" name="phone_value_03" class="txt_input width" value="${list[2].btnData[0][0]}"/>
                                                                            </div>
                                                                        </div>
                                                                        <input type="hidden" name="copy_value" value=" "/>
                                                                        <input type="hidden" name="url_value" value=" "/>
                                                                        <input type="hidden" name="latitude_value" value=" "/>
                                                                        <input type="hidden" name="longitude_value" value=" "/>
                                                                        <input type="hidden" name="location_value_04" value=" "/>
                                                                        <input type="hidden" name="fallback_url_04" value=" "/>
                                                                        <input type="hidden" name="location_value_05" value=" "/>
                                                                        <input type="hidden" name="fallback_url_05" value=" "/>
                                                                        <input type="hidden" name="start_date" value=" "/>
                                                                        <input type="hidden" name="end_date" value=" "/>
                                                                        <input type="hidden" name="calendar_title" value=" "/>
                                                                        <input type="hidden" name="calendar_body" value=" "/>
                                                                        <input type="hidden" name="phone_value_08" value=" "/>
                                                                        <input type="hidden" name="message_value" value=" "/>
                                                                    </c:if>
                                                                    <c:if test="${list[2].btnType[0] eq 'latitude'}">
                                                                        <div class="row">
                                                                            <div class="th bottom-border top-border">
                                                                                위도/경도
                                                                            </div>
                                                                            <div class="td bottom-border top-border">
                                                                                <input type="text" name="latitude_value" class="txt_input en_font half right-border" value="${list[2].btnData[0][0]}"/>
                                                                                <input type="text" name="longitude_value" class="txt_input en_font half" value="${list[2].btnData[0][1]}"/>
                                                                            </div>
                                                                        </div>
                                                                        <div class="row">
                                                                            <div class="th bottom-border">위치 이름</div>
                                                                            <div class="td bottom-border">
                                                                                <input type="text" name="location_value_04" class="txt_input width" value="${list[2].btnData[0][2]}"/>
                                                                            </div>
                                                                        </div>
                                                                        <div class="row">
                                                                            <div class="th">Fallback URL</div>
                                                                            <div class="td">
                                                                                <input type="text" name="fallback_url_04" class="txt_input width en_font url_link" data="url" value="${list[2].btnData[0][3]}"/>
                                                                            </div>
                                                                        </div>
                                                                        <input type="hidden" name="copy_value" value=" "/>
                                                                        <input type="hidden" name="url_value" value=" "/>
                                                                        <input type="hidden" name="phone_value_03" value=" "/>
                                                                        <input type="hidden" name="location_value_05" value=" "/>
                                                                        <input type="hidden" name="fallback_url_05" value=" "/>
                                                                        <input type="hidden" name="start_date" value=" "/>
                                                                        <input type="hidden" name="end_date" value=" "/>
                                                                        <input type="hidden" name="calendar_title" value=" "/>
                                                                        <input type="hidden" name="calendar_body" value=" "/>
                                                                        <input type="hidden" name="phone_value_08" value=" "/>
                                                                        <input type="hidden" name="message_value" value=" "/>
                                                                    </c:if>
                                                                    <c:if test="${list[2].btnType[0] eq 'query'}">
                                                                        <div class="row">
                                                                            <div class="th bottom-border top-border">위치
                                                                                이름
                                                                            </div>
                                                                            <div class="td bottom-border top-border">
                                                                                <input type="text" name="location_value_05" class="txt_input width" value="${list[2].btnData[0][0]}"/>
                                                                            </div>
                                                                        </div>
                                                                        <div class="row">
                                                                            <div class="th">Fallback URL</div>
                                                                            <div class="td">
                                                                                <input type="text" name="fallback_url_05" class="txt_input width en_font url_link" data="url" value="${list[2].btnData[0][1]}"/>
                                                                            </div>
                                                                        </div>
                                                                        <input type="hidden" name="copy_value" value=" "/>
                                                                        <input type="hidden" name="url_value" value=" "/>
                                                                        <input type="hidden" name="phone_value_03" value=" "/>
                                                                        <input type="hidden" name="latitude_value" value=" "/>
                                                                        <input type="hidden" name="longitude_value" value=" "/>
                                                                        <input type="hidden" name="location_value_04" value=" "/>
                                                                        <input type="hidden" name="fallback_url_04" value=" "/>
                                                                        <input type="hidden" name="start_date" value=" "/>
                                                                        <input type="hidden" name="end_date" value=" "/>
                                                                        <input type="hidden" name="calendar_title" value=" "/>
                                                                        <input type="hidden" name="calendar_body" value=" "/>
                                                                        <input type="hidden" name="phone_value_08" value=" "/>
                                                                        <input type="hidden" name="message_value" value=" "/>
                                                                    </c:if>
                                                                    <c:if test="${list[2].btnType[0] eq 'requestLocationPush'}">
                                                                        <input type="hidden" name="copy_value" value=" "/>
                                                                        <input type="hidden" name="url_value" value=" "/>
                                                                        <input type="hidden" name="phone_value_03" value=" "/>
                                                                        <input type="hidden" name="latitude_value" value=" "/>
                                                                        <input type="hidden" name="longitude_value" value=" "/>
                                                                        <input type="hidden" name="location_value_04" value=" "/>
                                                                        <input type="hidden" name="location_value_05" value=" "/>
                                                                        <input type="hidden" name="fallback_url_04" value=" "/>
                                                                        <input type="hidden" name="fallback_url_05" value=" "/>
                                                                        <input type="hidden" name="start_date" value=" "/>
                                                                        <input type="hidden" name="end_date" value=" "/>
                                                                        <input type="hidden" name="calendar_title" value=" "/>
                                                                        <input type="hidden" name="calendar_body" value=" "/>
                                                                        <input type="hidden" name="phone_value_08" value=" "/>
                                                                        <input type="hidden" name="message_value" value=" "/>
                                                                    </c:if>
                                                                    <c:if test="${list[2].btnType[0] eq 'calendarAction'}">
                                                                        <div class="row">
                                                                            <div class="th bottom-border top-border">시작일
                                                                                / 종료일
                                                                            </div>
                                                                            <div class="td bottom-border top-border">
                                                                                <input type="text" name="start_date" class="start_date txt_input en_font calendar right-border" value="${list[2].btnData[0][0]}"/>
                                                                                <input type="text" name="end_date" class="end_date txt_input en_font calendar" value="${list[2].btnData[0][1]}"/>
                                                                            </div>
                                                                        </div>
                                                                        <div class="row">
                                                                            <div class="th bottom-border">제목</div>
                                                                            <div class="td bottom-border">
                                                                                <input type="text" name="calendar_title" class="txt_input width" value="${list[2].btnData[0][2]}"/>
                                                                            </div>
                                                                        </div>
                                                                        <div class="row">
                                                                            <div class="th">내용</div>
                                                                            <div class="td">
                                                                                <input type="text" name="calendar_body" class="txt_input width" value="${list[2].btnData[0][3]}"/>
                                                                            </div>
                                                                        </div>
                                                                        <input type="hidden" name="copy_value" value=" "/>
                                                                        <input type="hidden" name="url_value" value=" "/>
                                                                        <input type="hidden" name="phone_value_03" value=" "/>
                                                                        <input type="hidden" name="latitude_value" value=" "/>
                                                                        <input type="hidden" name="longitude_value" value=" "/>
                                                                        <input type="hidden" name="location_value_04" value=" "/>
                                                                        <input type="hidden" name="fallback_url_04" value=" "/>
                                                                        <input type="hidden" name="location_value_05" value=" "/>
                                                                        <input type="hidden" name="fallback_url_05" value=" "/>
                                                                        <input type="hidden" name="phone_value_08" value=" "/>
                                                                        <input type="hidden" name="message_value" value=" "/>
                                                                    </c:if>
                                                                    <c:if test="${list[2].btnType[0] eq 'composeAction'}">
                                                                        <div class="row">
                                                                            <div class="th bottom-border top-border">
                                                                                전화번호
                                                                            </div>
                                                                            <div class="td bottom-border top-border">
                                                                                <input type="text" name="phone_value_08" class="txt_input width en_font" value="${list[2].btnData[0][0]}"/>
                                                                            </div>
                                                                        </div>
                                                                        <div class="row">
                                                                            <div class="th">문자메시지 내용</div>
                                                                            <div class="td">
                                                                                <input type="text" name="message_value" class="txt_input width" value="${list[2].btnData[0][1]}"/>
                                                                            </div>
                                                                        </div>
                                                                        <input type="hidden" name="copy_value" value=" "/>
                                                                        <input type="hidden" name="url_value" value=" "/>
                                                                        <input type="hidden" name="phone_value_03" value=" "/>
                                                                        <input type="hidden" name="latitude_value" value=" "/>
                                                                        <input type="hidden" name="longitude_value" value=" "/>
                                                                        <input type="hidden" name="location_value_04" value=" "/>
                                                                        <input type="hidden" name="fallback_url_04" value=" "/>
                                                                        <input type="hidden" name="location_value_05" value=" "/>
                                                                        <input type="hidden" name="fallback_url_05" value=" "/>
                                                                        <input type="hidden" name="start_date" value=" "/>
                                                                        <input type="hidden" name="end_date" value=" "/>
                                                                        <input type="hidden" name="calendar_title" value=" "/>
                                                                        <input type="hidden" name="calendar_body" value=" "/>
                                                                    </c:if>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${list[2].msg_tp eq 'DMCH206'}">
                                                        <!--RCS LMS 타입인 경우 버튼은 3개 존재한다 -->
                                                        <c:forEach var="idx" begin="0" end="2">
                                                            <div id="btn-action-area">
                                                                <div class="block">
                                                                    <div class="row">
                                                                        <div class="th bottom-border">버튼 액션 선택</div>
                                                                        <div class="td bottom-border">
                                                                            <!-- select 영역 시작 -->
                                                                            <div class="select action_select" data="${idx+1}">
                                                                                <!-- selected value -->
                                                                                <span id="btnHidden${idx+1}"></span>
                                                                                <c:choose>
                                                                                    <c:when test="${list[2].btnType[idx] eq 'clipboardAction'}">
                                                                                        <div class="value" data="RBTN01" style="color: rgb(34, 34, 34);">
                                                                                            복사하기
                                                                                        </div>
                                                                                    </c:when>
                                                                                    <c:when test="${list[2].btnType[idx] eq 'urlAction'}">
                                                                                        <div class="value" data="RBTN02" style="color: rgb(34, 34, 34);">
                                                                                            URL연결
                                                                                        </div>
                                                                                    </c:when>
                                                                                    <c:when test="${list[2].btnType[idx] eq 'dialerAction'}">
                                                                                        <div class="value" data="RBTN03" style="color: rgb(34, 34, 34);">
                                                                                            전화걸기
                                                                                        </div>
                                                                                    </c:when>
                                                                                    <c:when test="${list[2].btnType[idx] eq 'latitude'}">
                                                                                        <div class="value" data="RBTN04" style="color: rgb(34, 34, 34);">
                                                                                            지도보여주기(좌표)
                                                                                        </div>
                                                                                    </c:when>
                                                                                    <c:when test="${list[2].btnType[idx] eq 'query'}">
                                                                                        <div class="value" data="RBTN05" style="color: rgb(34, 34, 34);">
                                                                                            지도보여주기(쿼리)
                                                                                        </div>
                                                                                    </c:when>
                                                                                    <c:when test="${list[2].btnType[idx] eq 'requestLocationPush'}">
                                                                                        <div class="value" data="RBTN06" style="color: rgb(34, 34, 34);">
                                                                                            현재위치공유
                                                                                        </div>
                                                                                    </c:when>
                                                                                    <c:when test="${list[2].btnType[idx] eq 'calendarAction'}">
                                                                                        <div class="value" data="RBTN07" style="color: rgb(34, 34, 34);">
                                                                                            캘린더등록
                                                                                        </div>
                                                                                    </c:when>
                                                                                    <c:when test="${list[2].btnType[idx] eq 'composeAction'}">
                                                                                        <div class="value" data="RBTN08" style="color: rgb(34, 34, 34);">
                                                                                            메세지전송
                                                                                        </div>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <div class="value" data="0">액션선택
                                                                                        </div>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                                <ul class="option">
                                                                                    <li data="0">액션선택</li>
                                                                                    <li data="RBTN01">복사하기</li>
                                                                                    <li data="RBTN02">URL연결</li>
                                                                                    <li data="RBTN03">전화걸기</li>
                                                                                    <li data="RBTN04">지도보여주기(좌표)</li>
                                                                                    <li data="RBTN05">지도보여주기(쿼리)</li>
                                                                                    <li data="RBTN06">현재위치공유</li>
                                                                                    <li data="RBTN07">캘린더등록</li>
                                                                                    <li data="RBTN08">메시지전송</li>
                                                                                </ul>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="row">
                                                                        <div class="th">버튼 명</div>
                                                                        <div class="td button-name">
                                                                            <!-- 버튼명이 존재할 경우 -->
                                                                            <c:if test="${fn:trim(list[2].btnText[idx]) != ''}">
                                                                                <input type="text" name="rcs_btn_${idx+1}" class="txt_input action_name" data="${idx+1}" onkeyup="rcsCreate.buttonCount(this, 'text');" value="${list[2].btnText[idx]}"/>
                                                                            </c:if>
                                                                            <!-- 버튼명이 없을 경우 -->
                                                                            <c:if test="${fn:trim(list[2].btnText[idx]) == ''}">
                                                                                <input type="text" name="rcs_btn_${idx+1}" class="txt_input action_name" data="${idx+1}" onkeyup="rcsCreate.buttonCount(this, 'text');" placeholder="버튼 명을 입력해주세요"/>
                                                                            </c:if>
                                                                            <span class="text-count en_font"><span>
                                                                    <c:if test="${list[2].btnText[idx] != ''}">
                                                                        ${fn:length(list[2].btnText[idx])}
                                                                    </c:if>
                                                                    <c:if test="${list[2].btnText[idx] == ''}">
                                                                        0
                                                                    </c:if>
                                                                </span>/17</span>
                                                                        </div>
                                                                    </div>
                                                                    <div class="custom_box">
                                                                        <!-- LMS 초기 selectBox 랜딩 서비스 -->
                                                                        <c:if test="${list[2].btnType[idx] eq 'clipboardAction'}">
                                                                            <div class="row">
                                                                                <div class="th top-border">복사할 값</div>
                                                                                <div class="td top-border">
                                                                                    <input type="text" name="copy_value" class="txt_input width" value="${list[2].btnData[idx][0]}"/>
                                                                                </div>
                                                                            </div>
                                                                            <input type="hidden" name="url_value" value=" "/>
                                                                            <input type="hidden" name="phone_value_03" value=" "/>
                                                                            <input type="hidden" name="latitude_value" value=" "/>
                                                                            <input type="hidden" name="longitude_value" value=" "/>
                                                                            <input type="hidden" name="location_value_04" value=" "/>
                                                                            <input type="hidden" name="fallback_url_04" value=" "/>
                                                                            <input type="hidden" name="location_value_05" value=" "/>
                                                                            <input type="hidden" name="fallback_url_05" value=" "/>
                                                                            <input type="hidden" name="start_date" value=" "/>
                                                                            <input type="hidden" name="end_date" value=" "/>
                                                                            <input type="hidden" name="calendar_title" value=" "/>
                                                                            <input type="hidden" name="calendar_body" value=" "/>
                                                                            <input type="hidden" name="phone_value_08" value=" "/>
                                                                            <input type="hidden" name="message_value" value=" "/>
                                                                        </c:if>
                                                                        <c:if test="${list[2].btnType[idx] eq 'urlAction'}">
                                                                            <div class="row">
                                                                                <div class="th top-border">URL</div>
                                                                                <div class="td top-border">
                                                                                    <input type="text" name="url_value" class="txt_input width" data="url" value="${list[2].btnData[idx][0]}"/>
                                                                                </div>
                                                                            </div>
                                                                            <input type="hidden" name="copy_value" value=" "/>
                                                                            <input type="hidden" name="phone_value_03" value=" "/>
                                                                            <input type="hidden" name="latitude_value" value=" "/>
                                                                            <input type="hidden" name="longitude_value" value=" "/>
                                                                            <input type="hidden" name="location_value_04" value=" "/>
                                                                            <input type="hidden" name="fallback_url_04" value=" "/>
                                                                            <input type="hidden" name="location_value_05" value=" "/>
                                                                            <input type="hidden" name="fallback_url_05" value=" "/>
                                                                            <input type="hidden" name="start_date" value=" "/>
                                                                            <input type="hidden" name="end_date" value=" "/>
                                                                            <input type="hidden" name="calendar_title" value=" "/>
                                                                            <input type="hidden" name="calendar_body" value=" "/>
                                                                            <input type="hidden" name="phone_value_08" value=" "/>
                                                                            <input type="hidden" name="message_value" value=" "/>
                                                                        </c:if>
                                                                        <c:if test="${list[2].btnType[idx] eq 'dialerAction'}">
                                                                            <div class="row">
                                                                                <div class="th top-border">전화번호</div>
                                                                                <div class="td top-border">
                                                                                    <input type="text" name="phone_value_03" class="txt_input width" value="${list[2].btnData[idx][0]}"/>
                                                                                </div>
                                                                            </div>
                                                                            <input type="hidden" name="copy_value" value=" "/>
                                                                            <input type="hidden" name="url_value" value=" "/>
                                                                            <input type="hidden" name="latitude_value" value=" "/>
                                                                            <input type="hidden" name="longitude_value" value=" "/>
                                                                            <input type="hidden" name="location_value_04" value=" "/>
                                                                            <input type="hidden" name="fallback_url_04" value=" "/>
                                                                            <input type="hidden" name="location_value_05" value=" "/>
                                                                            <input type="hidden" name="fallback_url_05" value=" "/>
                                                                            <input type="hidden" name="start_date" value=" "/>
                                                                            <input type="hidden" name="end_date" value=" "/>
                                                                            <input type="hidden" name="calendar_title" value=" "/>
                                                                            <input type="hidden" name="calendar_body" value=" "/>
                                                                            <input type="hidden" name="phone_value_08" value=" "/>
                                                                            <input type="hidden" name="message_value" value=" "/>
                                                                        </c:if>
                                                                        <c:if test="${list[2].btnType[idx] eq 'latitude'}">
                                                                            <div class="row">
                                                                                <div class="th bottom-border top-border">
                                                                                    위도/경도
                                                                                </div>
                                                                                <div class="td bottom-border top-border">
                                                                                    <input type="text" name="latitude_value" class="txt_input en_font half right-border" value="${list[2].btnData[idx][0]}"/>
                                                                                    <input type="text" name="longitude_value" class="txt_input en_font half" value="${list[2].btnData[idx][1]}"/>
                                                                                </div>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="th bottom-border">위치 이름
                                                                                </div>
                                                                                <div class="td bottom-border">
                                                                                    <input type="text" name="location_value_04" class="txt_input width" value="${list[2].btnData[idx][2]}"/>
                                                                                </div>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="th">Fallback URL</div>
                                                                                <div class="td">
                                                                                    <input type="text" name="fallback_url_04" class="txt_input width en_font url_link" data="url" value="${list[2].btnData[idx][3]}"/>
                                                                                </div>
                                                                            </div>
                                                                            <input type="hidden" name="copy_value" value=" "/>
                                                                            <input type="hidden" name="url_value" value=" "/>
                                                                            <input type="hidden" name="phone_value_03" value=" "/>
                                                                            <input type="hidden" name="location_value_05" value=" "/>
                                                                            <input type="hidden" name="fallback_url_05" value=" "/>
                                                                            <input type="hidden" name="start_date" value=" "/>
                                                                            <input type="hidden" name="end_date" value=" "/>
                                                                            <input type="hidden" name="calendar_title" value=" "/>
                                                                            <input type="hidden" name="calendar_body" value=" "/>
                                                                            <input type="hidden" name="phone_value_08" value=" "/>
                                                                            <input type="hidden" name="message_value" value=" "/>
                                                                        </c:if>
                                                                        <c:if test="${list[2].btnType[idx] eq 'query'}">
                                                                            <div class="row">
                                                                                <div class="th bottom-border top-border">
                                                                                    위치 이름
                                                                                </div>
                                                                                <div class="td bottom-border top-border">
                                                                                    <input type="text" name="location_value_05" class="txt_input width" value="${list[2].btnData[idx][0]}"/>
                                                                                </div>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="th">Fallback URL</div>
                                                                                <div class="td">
                                                                                    <input type="text" name="fallback_url_05" class="txt_input width en_font url_link" data="url" value="${list[2].btnData[idx][1]}"/>
                                                                                </div>
                                                                            </div>
                                                                            <input type="hidden" name="copy_value" value=" "/>
                                                                            <input type="hidden" name="url_value" value=" "/>
                                                                            <input type="hidden" name="phone_value_03" value=" "/>
                                                                            <input type="hidden" name="latitude_value" value=" "/>
                                                                            <input type="hidden" name="longitude_value" value=" "/>
                                                                            <input type="hidden" name="location_value_04" value=" "/>
                                                                            <input type="hidden" name="fallback_url_04" value=" "/>
                                                                            <input type="hidden" name="start_date" value=" "/>
                                                                            <input type="hidden" name="end_date" value=" "/>
                                                                            <input type="hidden" name="calendar_title" value=" "/>
                                                                            <input type="hidden" name="calendar_body" value=" "/>
                                                                            <input type="hidden" name="phone_value_08" value=" "/>
                                                                            <input type="hidden" name="message_value" value=" "/>
                                                                        </c:if>
                                                                        <c:if test="${list[2].btnType[idx] eq 'requestLocationPush'}">
                                                                            <input type="hidden" name="copy_value" value=" "/>
                                                                            <input type="hidden" name="url_value" value=" "/>
                                                                            <input type="hidden" name="phone_value_03"
                                                                                   value=" "/>
                                                                            <input type="hidden" name="latitude_value"
                                                                                   value=" "/>
                                                                            <input type="hidden" name="longitude_value"
                                                                                   value=" "/>
                                                                            <input type="hidden" name="location_value_04"
                                                                                   value=" "/>
                                                                            <input type="hidden" name="location_value_05"
                                                                                   value=" "/>
                                                                            <input type="hidden" name="fallback_url_04"
                                                                                   value=" "/>
                                                                            <input type="hidden" name="fallback_url_05"
                                                                                   value=" "/>
                                                                            <input type="hidden" name="start_date" value=" "/>
                                                                            <input type="hidden" name="end_date" value=" "/>
                                                                            <input type="hidden" name="calendar_title"
                                                                                   value=" "/>
                                                                            <input type="hidden" name="calendar_body"
                                                                                   value=" "/>
                                                                            <input type="hidden" name="phone_value_08"
                                                                                   value=" "/>
                                                                            <input type="hidden" name="message_value"
                                                                                   value=" "/>
                                                                        </c:if>
                                                                        <c:if test="${list[2].btnType[idx] eq 'calendarAction'}">
                                                                            <div class="row">
                                                                                <div class="th bottom-border top-border">
                                                                                    시작일 / 종료일
                                                                                </div>
                                                                                <div class="td bottom-border top-border">
                                                                                    <input type="text" name="start_date" class="start_date txt_input en_font calendar right-border" value="${list[2].btnData[idx][0]}"/>
                                                                                    <input type="text" name="end_date" class="end_date txt_input en_font calendar" value="${list[2].btnData[idx][1]}"/>
                                                                                </div>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="th bottom-border">제목</div>
                                                                                <div class="td bottom-border">
                                                                                    <input type="text" name="calendar_title" class="txt_input width" value="${list[2].btnData[idx][2]}"/>
                                                                                </div>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="th">내용</div>
                                                                                <div class="td">
                                                                                    <input type="text" name="calendar_body" class="txt_input width" value="${list[2].btnData[idx][3]}"/>
                                                                                </div>
                                                                            </div>
                                                                            <input type="hidden" name="copy_value" value=" "/>
                                                                            <input type="hidden" name="url_value" value=" "/>
                                                                            <input type="hidden" name="phone_value_03" value=" "/>
                                                                            <input type="hidden" name="latitude_value" value=" "/>
                                                                            <input type="hidden" name="longitude_value" value=" "/>
                                                                            <input type="hidden" name="location_value_04" value=" "/>
                                                                            <input type="hidden" name="fallback_url_04" value=" "/>
                                                                            <input type="hidden" name="location_value_05" value=" "/>
                                                                            <input type="hidden" name="fallback_url_05" value=" "/>
                                                                            <input type="hidden" name="phone_value_08" value=" "/>
                                                                            <input type="hidden" name="message_value" value=" "/>
                                                                        </c:if>
                                                                        <c:if test="${list[2].btnType[idx] eq 'composeAction'}">
                                                                            <div class="row">
                                                                                <div class="th bottom-border top-border">
                                                                                    전화번호
                                                                                </div>
                                                                                <div class="td bottom-border top-border">
                                                                                    <input type="text" name="phone_value_08" class="txt_input width en_font" value="${list[2].btnData[idx][0]}"/>
                                                                                </div>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="th">문자메시지 내용</div>
                                                                                <div class="td">
                                                                                    <input type="text" name="message_value" class="txt_input width" value="${list[2].btnData[idx][1]}"/>
                                                                                </div>
                                                                            </div>
                                                                            <input type="hidden" name="copy_value" value=" "/>
                                                                            <input type="hidden" name="url_value" value=" "/>
                                                                            <input type="hidden" name="phone_value_03" value=" "/>
                                                                            <input type="hidden" name="latitude_value" value=" "/>
                                                                            <input type="hidden" name="longitude_value" value=" "/>
                                                                            <input type="hidden" name="location_value_04" value=" "/>
                                                                            <input type="hidden" name="fallback_url_04" value=" "/>
                                                                            <input type="hidden" name="location_value_05" value=" "/>
                                                                            <input type="hidden" name="fallback_url_05" value=" "/>
                                                                            <input type="hidden" name="start_date" value=" "/>
                                                                            <input type="hidden" name="end_date" value=" "/>
                                                                            <input type="hidden" name="calendar_title" value=" "/>
                                                                            <input type="hidden" name="calendar_body" value=" "/>
                                                                        </c:if>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </c:if>
                                                    <div class="block" id="rejection">
                                                        <div class="row">
                                                            <div class="th">무료수신거부</div>
                                                            <div class="td">
                                                                <input type="text" name="rcs_footer" class="txt_input rejection_num width" oninput="rcsCreate.rejection(this);" value="${list[2].rcs_footer}"/>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="viewer_area">
                                                <div class="rcs_inner text">
                                                    <div class="rcs_head">
                                                        <c:if test="${list[2].send_tp eq 'SENDTP01'}">
                                                            [WEB발신]광고
                                                        </c:if>
                                                        <c:if test="${list[2].send_tp eq 'SENDTP02'}">
                                                            [WEB발신]
                                                        </c:if>
                                                    </div>
                                                    <span id="js-txt-replace">
                                            <div class="text_type">
                                                <div class="scroll_txt">
                                                    <p class="rcs_area" id="textArea0">${cutil:replaceBr(list[2].cont_body)}</p>
                                                </div>
                                                <div class="rcs_btn_wrap">
                                                    <!-- 버튼 1개 -->
                                                    <c:if test="${list[2].msg_tp eq 'DMCH205'}">
                                                        <c:if test="${fn.trim(list[2].btnText[0]) != ''}">
                                                            <div class="rcs_btn" data="1">${list[2].btnText[0]}</div>
                                                        </c:if>
                                                    </c:if>
                                                    <!-- 버튼 여러개 -->
                                                    <c:if test="${list[2].msg_tp eq 'DMCH206'}">
                                                        <c:forEach var="k" begin="0" end="2">
                                                            <c:if test="${fn.trim(list[2].btnText[k])!= ''}">
                                                                <div class="rcs_btn" data="${k+1}">${list[2].btnText[k]}</div>
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:if>
                                                </div>
                                            </div>
                                            <div class="rcs_register">무료 수신거부 : <span id="rejectionArea"></span>
                                            </div>
                                            <div class="text_count">
                                                <span class="num en_font">
                                                    <span id="textByte0">0</span>
                                                    /100
                                                </span>
                                                <p>※ 본문내용 : <span class="en_font">100</span>글자 이내</p>
                                            </div>
                                        </span>
                                                </div>
                                            </div>
                                            <c:if test="${list[2].msg_tp eq 'DMCH206'}">
                                                <!-- RCS LMS 버튼 초기화 -->
                                                <c:forEach var="i" begin="0" end="2">
                                                    <c:if test="${list[2].btnType[i] eq 'clipboardAction'}">
                                                        <input type="hidden" name="rcs_btn_tp_${i+1}"
                                                               value="RBTN01"/>
                                                    </c:if>
                                                    <c:if test="${list[2].btnType[i] eq 'urlAction'}">
                                                        <input type="hidden" name="rcs_btn_tp_${i+1}"
                                                               value="RBTN02"/>
                                                    </c:if>
                                                    <c:if test="${list[2].btnType[i] eq 'dialerAction'}">
                                                        <input type="hidden" name="rcs_btn_tp_${i+1}"
                                                               value="RBTN03"/>
                                                    </c:if>
                                                    <c:if test="${list[2].btnType[i] eq 'latitude'}">
                                                        <input type="hidden" name="rcs_btn_tp_${i+1}"
                                                               value="RBTN04"/>
                                                    </c:if>
                                                    <c:if test="${list[2].btnType[i] eq 'query'}">
                                                        <input type="hidden" name="rcs_btn_tp_${i+1}"
                                                               value="RBTN05"/>
                                                    </c:if>
                                                    <c:if test="${list[2].btnType[i] eq 'requestLocationPush'}">
                                                        <input type="hidden" name="rcs_btn_tp_${i+1}"
                                                               value="RBTN06"/>
                                                    </c:if>
                                                    <c:if test="${list[2].btnType[i] eq 'calendarAction'}">
                                                        <input type="hidden" name="rcs_btn_tp_${i+1}"
                                                               value="RBTN07"/>
                                                    </c:if>
                                                    <c:if test="${list[2].btnType[i] eq 'composeAction'}">
                                                        <input type="hidden" name="rcs_btn_tp_${i+1}"
                                                               value="RBTN08"/>
                                                    </c:if>
                                                    <c:if test="${fn:trim(list[2].btnType[i]) == ''}">
                                                        <input type="hidden" name="rcs_btn_tp_${i+1}" value=""/>
                                                    </c:if>
                                                </c:forEach>
                                            </c:if>
                                        </div>
                                        </c:if>
                                        <!-- RCS 세로형 -->
                                        <c:if test="${list[2].msg_tp eq 'DMCH207' || list[2].msg_tp eq 'DMCH208'}">
                                        <div class="row body">
                                            <div class="th">카드 양식</div>
                                            <div class="column_1">
                                                <label class="custom_radio en_font">Tall
                                                    <input name="rcs_msg_tp"
                                                           class="lowType"
                                                           type="radio"
                                                           value="tall"
                                                        <%--onclick="rcsCreate.vertical(this)"--%>
                                                    <c:if test="${list[2].msg_tp eq 'DMCH207'}">
                                                           checked
                                                    </c:if>>
                                                    <span></span>
                                                </label>
                                                <label class="custom_radio en_font">Medium
                                                    <input name="rcs_msg_tp"
                                                           class="lowType"
                                                           type="radio"
                                                           value="medium"
                                                        <%--onclick="rcsCreate.vertical(this)"--%>
                                                    <c:if test="${list[2].msg_tp eq 'DMCH208'}">
                                                           checked
                                                    </c:if>
                                                    >
                                                    <span></span>
                                                </label>
                                            </div>
                                        </div>
                                        <span id="js-title-area"></span>
                                        <div class="row body">
                                            <div class="th">문자 제목</div>
                                            <div class="column_1">
                                                <input type="text" class="title rcsTitle" name="cont_sub_list" value="${list[2].cont_sub}"
                                                       onkeyup="rcsCreate.rcsTitle(this, 0);">
                                                <div class="select column_4 left-border rcsTitleVal" name="edmDB">
                                                    <div class="value" data="0">개인화 변수</div>
                                                    <ul class="option mappingLst"></ul>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row body">
                                            <div class="th">발신 번호</div>
                                            <div class="column_1">
                                                <c:if test="${fn:trim(list[2].send_to) == ''}">
                                                    <input type="text" class="sms_number" id="send_vertical_rcs"
                                                           placeholder="발신 번호를 입력해주세요." readonly/>
                                                </c:if>
                                                <c:if test="${fn:trim(list[2].send_to) != ''}">
                                                    <input type="text" class="sms_number" id="send_vertical_rcs"
                                                           value="${list[2].sender}(${list[2].send_num})" readonly/>
                                                </c:if>
                                                <input type="hidden" name="send_to_list" id="vertical_send_num"
                                                       value="${list[2].send_to}"/>
                                                <span class="btn_sm_line"
                                                      onclick="mobileSenderPopup('1','verticalrcs')">변경</span>
                                            </div>
                                        </div>
                                        <div class="input_area left">
                                            <div class="block">
                                                <div class="row">
                                                    <div class="th">이미지 선택</div>
                                                    <div class="td">
                                                        <div class="vertical_delete_img">
                                                            <img
                                                                    src="${baseURL}/image/btn_delete1.png"
                                                                    alt="삭제">
                                                        </div>
                                                        <c:if test="${fn:trim(fn:split(list[2].img_nm_lst,',')[0]) == ''}">
                                                            <input type="text" class="txt_input en_font" name=""
                                                                   id="verticalImage"
                                                                   placeholder="이미지를 선택해 주세요." readonly="">
                                                        </c:if>
                                                        <c:if test="${fn:trim(fn:split(list[2].img_nm_lst,',')[0]) != ''}">
                                                            <input type="text" class="txt_input en_font" name=""
                                                                   id="verticalImage"
                                                                   value="${fn:split(list[2].img_nm_lst,',')[0]}"
                                                                   readonly="">
                                                        </c:if>
                                                        <input type="hidden" name="verticalImg" id="verticalImg"
                                                               value="${list[2].img_cd_1}">
                                                        <span
                                                                class="btn_sm_line" data="verticalImage"
                                                                onclick="imageListPopUp('1','verticalImage')">선택</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="block">
                                                <div class="row">
                                                    <div class="th">개인화 변수</div>
                                                    <div class="td">
                                                        <!-- select 영역 시작 -->
                                                        <div class="select rcsContsVal" name="edmDB">
                                                            <!-- selected value -->
                                                            <div class="value" data="0">개인화 변수</div>
                                                            <ul class="option mappingLst">
                                                            </ul>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row rcs_textarea">
                                                    <div class="th top-border">내용</div>
                                                    <div class="td top-border">
                                                    <textarea class="rcsContents" name="rcs_body" id="" cols="30" rows="10" placeholder="내용을 입력해주세요." onkeyup="rcsCreate.rcsContents(this, 0);">${cutil:textAreaParsing(list[2].cont_body)}</textarea>
                                                </div>
                                                </div>
                                            </div>
                                            <div id="btn-action-area">
                                                <div class="block">
                                                    <div class="row">
                                                        <div class="th bottom-border">버튼 액션 선택</div>
                                                        <div class="td bottom-border">
                                                            <div class="select action_select" data="1">
                                                                <span id="btnHidden1"></span>
                                                                <c:choose>
                                                                    <c:when test="${list[2].btnType[0] eq 'clipboardAction'}">
                                                                        <div class="value" data="RBTN01"
                                                                             style="color: rgb(34, 34, 34);">
                                                                            복사하기
                                                                        </div>
                                                                    </c:when>
                                                                    <c:when test="${list[2].btnType[0] eq 'urlAction'}">
                                                                        <div class="value" data="RBTN02"
                                                                             style="color: rgb(34, 34, 34);">
                                                                            URL연결
                                                                        </div>
                                                                    </c:when>
                                                                    <c:when test="${list[2].btnType[0] eq 'dialerAction'}">
                                                                        <div class="value" data="RBTN03"
                                                                             style="color: rgb(34, 34, 34);">
                                                                            전화걸기
                                                                        </div>
                                                                    </c:when>
                                                                    <c:when test="${list[2].btnType[0] eq 'latitude'}">
                                                                        <div class="value" data="RBTN04"
                                                                             style="color: rgb(34, 34, 34);">
                                                                            지도보여주기(좌표)
                                                                        </div>
                                                                    </c:when>
                                                                    <c:when test="${list[2].btnType[0] eq 'query'}">
                                                                        <div class="value" data="RBTN05"
                                                                             style="color: rgb(34, 34, 34);">
                                                                            지도보여주기(쿼리)
                                                                        </div>
                                                                    </c:when>
                                                                    <c:when test="${list[2].btnType[0] eq 'requestLocationPush'}">
                                                                        <div class="value" data="RBTN06"
                                                                             style="color: rgb(34, 34, 34);">
                                                                            현재위치공유
                                                                        </div>
                                                                    </c:when>
                                                                    <c:when test="${list[2].btnType[0] eq 'calendarAction'}">
                                                                        <div class="value" data="RBTN07"
                                                                             style="color: rgb(34, 34, 34);">
                                                                            캘린더등록
                                                                        </div>
                                                                    </c:when>
                                                                    <c:when test="${list[2].btnType[0] eq 'composeAction'}">
                                                                        <div class="value" data="RBTN08"
                                                                             style="color: rgb(34, 34, 34);">
                                                                            메세지전송
                                                                        </div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <div class="value" data="0">
                                                                            액션선택
                                                                        </div>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                                <ul class="option">
                                                                    <li data="0">액션선택</li>
                                                                    <li data="RBTN01">복사하기</li>
                                                                    <li data="RBTN02">URL연결</li>
                                                                    <li data="RBTN03">전화걸기</li>
                                                                    <li data="RBTN04">지도보여주기(좌표)</li>
                                                                    <li data="RBTN05">지도보여주기(쿼리)</li>
                                                                    <li data="RBTN06">현재위치공유</li>
                                                                    <li data="RBTN07">캘린더등록</li>
                                                                    <li data="RBTN08">메시지전송</li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="th">버튼 명</div>
                                                        <div class="td button-name">
                                                            <!-- 버튼명이 존재할 경우 -->
                                                            <c:if test="${fn:trim(list[2].btnText[0]) != ''}">
                                                                <input type="text" name="rcs_btn_1"
                                                                       class="txt_input action_name" data="1"
                                                                       onkeyup="rcsCreate.buttonCount(this, 'vertical');"
                                                                       value="${list[2].btnText[0]}"/>
                                                            </c:if>
                                                            <!-- 버튼명이 없을 경우 -->
                                                            <c:if test="${fn:trim(list[2].btnText[0]) == ''}">
                                                                <input type="text" name="rcs_btn_1"
                                                                       class="txt_input action_name" data="1"
                                                                       onkeyup="rcsCreate.buttonCount(this, 'vertical');"
                                                                       placeholder="버튼 명을 입력해주세요"
                                                                />
                                                            </c:if>
                                                            <span class="text-count en_font">
                                                                <span>
                                                                <c:if test="${list[2].btnText[0] != ''}">
                                                                    ${fn:length(list[2].btnText[0])}
                                                                </c:if>
                                                                <c:if test="${list[2].btnText[0] == ''}">
                                                                    0
                                                                </c:if>
                                                                </span>/17</span>
                                                        </div>
                                                    </div>
                                                    <div class="custom_box">
                                                        <!-- 초기 버튼 selectBox 랜딩 서비스 -->
                                                        <c:if test="${list[2].btnType[0] eq 'clipboardAction'}">
                                                            <div class="row">
                                                                <div class="th top-border">복사할 값</div>
                                                                <div class="td top-border">
                                                                    <input type="text" name="copy_value"
                                                                           class="txt_input width"
                                                                           value="${list[2].btnData[0][0]}"/>
                                                                </div>
                                                            </div>
                                                            <input type="hidden" name="url_value" value=" "/>
                                                            <input type="hidden" name="phone_value_03" value=" "/>
                                                            <input type="hidden" name="latitude_value" value=" "/>
                                                            <input type="hidden" name="longitude_value" value=" "/>
                                                            <input type="hidden" name="location_value_04" value=" "/>
                                                            <input type="hidden" name="fallback_url_04" value=" "/>
                                                            <input type="hidden" name="location_value_05" value=" "/>
                                                            <input type="hidden" name="fallback_url_05" value=" "/>
                                                            <input type="hidden" name="start_date" value=" "/>
                                                            <input type="hidden" name="end_date" value=" "/>
                                                            <input type="hidden" name="calendar_title" value=" "/>
                                                            <input type="hidden" name="calendar_body" value=" "/>
                                                            <input type="hidden" name="phone_value_08" value=" "/>
                                                            <input type="hidden" name="message_value" value=" "/>
                                                        </c:if>
                                                        <c:if test="${list[2].btnType[0] eq 'urlAction'}">
                                                            <div class="row">
                                                                <div class="th top-border">URL</div>
                                                                <div class="td top-border">
                                                                    <input type="text" name="url_value"
                                                                           class="txt_input width" data="url"
                                                                           value="${list[2].btnData[0][0]}"/>
                                                                </div>
                                                            </div>
                                                            <input type="hidden" name="copy_value" value=" "/>
                                                            <input type="hidden" name="phone_value_03" value=" "/>
                                                            <input type="hidden" name="latitude_value" value=" "/>
                                                            <input type="hidden" name="longitude_value" value=" "/>
                                                            <input type="hidden" name="location_value_04" value=" "/>
                                                            <input type="hidden" name="fallback_url_04" value=" "/>
                                                            <input type="hidden" name="location_value_05" value=" "/>
                                                            <input type="hidden" name="fallback_url_05" value=" "/>
                                                            <input type="hidden" name="start_date" value=" "/>
                                                            <input type="hidden" name="end_date" value=" "/>
                                                            <input type="hidden" name="calendar_title" value=" "/>
                                                            <input type="hidden" name="calendar_body" value=" "/>
                                                            <input type="hidden" name="phone_value_08" value=" "/>
                                                            <input type="hidden" name="message_value" value=" "/>
                                                        </c:if>
                                                        <c:if test="${list[2].btnType[0] eq 'dialerAction'}">
                                                            <div class="row">
                                                                <div class="th top-border">전화번호</div>
                                                                <div class="td top-border">
                                                                    <input type="text" name="phone_value_03"
                                                                           class="txt_input width"
                                                                           value="${list[2].btnData[0][0]}"
                                                                    />
                                                                </div>
                                                            </div>
                                                            <input type="hidden" name="copy_value" value=" "/>
                                                            <input type="hidden" name="url_value" value=" "/>
                                                            <input type="hidden" name="latitude_value" value=" "/>
                                                            <input type="hidden" name="longitude_value" value=" "/>
                                                            <input type="hidden" name="location_value_04" value=" "/>
                                                            <input type="hidden" name="fallback_url_04" value=" "/>
                                                            <input type="hidden" name="location_value_05" value=" "/>
                                                            <input type="hidden" name="fallback_url_05" value=" "/>
                                                            <input type="hidden" name="start_date" value=" "/>
                                                            <input type="hidden" name="end_date" value=" "/>
                                                            <input type="hidden" name="calendar_title" value=" "/>
                                                            <input type="hidden" name="calendar_body" value=" "/>
                                                            <input type="hidden" name="phone_value_08" value=" "/>
                                                            <input type="hidden" name="message_value" value=" "/>
                                                        </c:if>
                                                        <c:if test="${list[2].btnType[0] eq 'latitude'}">
                                                            <div class="row">
                                                                <div class="th bottom-border top-border">위도/경도</div>
                                                                <div class="td bottom-border top-border">
                                                                    <input type="text" name="latitude_value"
                                                                           class="txt_input en_font half right-border"
                                                                           value="${list[2].btnData[0][0]}"/>
                                                                    <input type="text" name="longitude_value"
                                                                           class="txt_input en_font half"
                                                                           value="${list[2].btnData[0][1]}"/>
                                                                </div>
                                                            </div>
                                                            <div class="row">
                                                                <div class="th bottom-border">위치 이름</div>
                                                                <div class="td bottom-border">
                                                                    <input type="text" name="location_value_04"
                                                                           class="txt_input width"
                                                                           value="${list[2].btnData[0][2]}"/>
                                                                </div>
                                                            </div>
                                                            <div class="row">
                                                                <div class="th">Fallback URL</div>
                                                                <div class="td">
                                                                    <input type="text" name="fallback_url_04"
                                                                           class="txt_input width en_font url_link"
                                                                           data="url" value="${list[2].btnData[0][3]}"/>
                                                                </div>
                                                            </div>
                                                            <input type="hidden" name="copy_value" value=" "/>
                                                            <input type="hidden" name="url_value" value=" "/>
                                                            <input type="hidden" name="phone_value_03" value=" "/>
                                                            <input type="hidden" name="location_value_05" value=" "/>
                                                            <input type="hidden" name="fallback_url_05" value=" "/>
                                                            <input type="hidden" name="start_date" value=" "/>
                                                            <input type="hidden" name="end_date" value=" "/>
                                                            <input type="hidden" name="calendar_title" value=" "/>
                                                            <input type="hidden" name="calendar_body" value=" "/>
                                                            <input type="hidden" name="phone_value_08" value=" "/>
                                                            <input type="hidden" name="message_value" value=" "/>
                                                        </c:if>
                                                        <c:if test="${list[2].btnType[0] eq 'query'}">
                                                            <div class="row">
                                                                <div class="th bottom-border top-border">위치 이름</div>
                                                                <div class="td bottom-border top-border">
                                                                    <input type="text" name="location_value_05"
                                                                           class="txt_input width"
                                                                           value="${list[2].btnData[0][0]}"/>
                                                                </div>
                                                            </div>
                                                            <div class="row">
                                                                <div class="th">Fallback URL</div>
                                                                <div class="td">
                                                                    <input type="text" name="fallback_url_05"
                                                                           class="txt_input width en_font url_link"
                                                                           data="url" value="${list[2].btnData[0][1]}"/>
                                                                </div>
                                                            </div>
                                                            <input type="hidden" name="copy_value" value=" "/>
                                                            <input type="hidden" name="url_value" value=" "/>
                                                            <input type="hidden" name="phone_value_03" value=" "/>
                                                            <input type="hidden" name="latitude_value" value=" "/>
                                                            <input type="hidden" name="longitude_value" value=" "/>
                                                            <input type="hidden" name="location_value_04" value=" "/>
                                                            <input type="hidden" name="fallback_url_04" value=" "/>
                                                            <input type="hidden" name="start_date" value=" "/>
                                                            <input type="hidden" name="end_date" value=" "/>
                                                            <input type="hidden" name="calendar_title" value=" "/>
                                                            <input type="hidden" name="calendar_body" value=" "/>
                                                            <input type="hidden" name="phone_value_08" value=" "/>
                                                            <input type="hidden" name="message_value" value=" "/>
                                                        </c:if>
                                                        <c:if test="${list[2].btnType[0] eq 'requestLocationPush'}">
                                                            <input type="hidden" name="copy_value" value=" "/>
                                                            <input type="hidden" name="url_value" value=" "/>
                                                            <input type="hidden" name="phone_value_03" value=" "/>
                                                            <input type="hidden" name="latitude_value" value=" "/>
                                                            <input type="hidden" name="longitude_value" value=" "/>
                                                            <input type="hidden" name="location_value_04" value=" "/>
                                                            <input type="hidden" name="location_value_05" value=" "/>
                                                            <input type="hidden" name="fallback_url_04" value=" "/>
                                                            <input type="hidden" name="fallback_url_05" value=" "/>
                                                            <input type="hidden" name="start_date" value=" "/>
                                                            <input type="hidden" name="end_date" value=" "/>
                                                            <input type="hidden" name="calendar_title" value=" "/>
                                                            <input type="hidden" name="calendar_body" value=" "/>
                                                            <input type="hidden" name="phone_value_08" value=" "/>
                                                            <input type="hidden" name="message_value" value=" "/>
                                                        </c:if>
                                                        <c:if test="${list[2].btnType[0] eq 'calendarAction'}">
                                                            <div class="row">
                                                                <div class="th bottom-border top-border">시작일 / 종료일</div>
                                                                <div class="td bottom-border top-border">
                                                                    <input type="text" name="start_date"
                                                                           class="start_date txt_input en_font calendar right-border"
                                                                           value="${list[2].btnData[0][0]}"/>
                                                                    <input type="text" name="end_date"
                                                                           class="end_date txt_input en_font calendar"
                                                                           value="${list[2].btnData[0][1]}"/>
                                                                </div>
                                                            </div>
                                                            <div class="row">
                                                                <div class="th bottom-border">제목</div>
                                                                <div class="td bottom-border">
                                                                    <input type="text" name="calendar_title"
                                                                           class="txt_input width"
                                                                           value="${list[2].btnData[0][2]}"/>
                                                                </div>
                                                            </div>
                                                            <div class="row">
                                                                <div class="th">내용</div>
                                                                <div class="td">
                                                                    <input type="text" name="calendar_body"
                                                                           class="txt_input width"
                                                                           value="${list[2].btnData[0][3]}"/>
                                                                </div>
                                                            </div>
                                                            <input type="hidden" name="copy_value" value=" "/>
                                                            <input type="hidden" name="url_value" value=" "/>
                                                            <input type="hidden" name="phone_value_03" value=" "/>
                                                            <input type="hidden" name="latitude_value" value=" "/>
                                                            <input type="hidden" name="longitude_value" value=" "/>
                                                            <input type="hidden" name="location_value_04" value=" "/>
                                                            <input type="hidden" name="fallback_url_04" value=" "/>
                                                            <input type="hidden" name="location_value_05" value=" "/>
                                                            <input type="hidden" name="fallback_url_05" value=" "/>
                                                            <input type="hidden" name="phone_value_08" value=" "/>
                                                            <input type="hidden" name="message_value" value=" "/>
                                                        </c:if>
                                                        <c:if test="${list[2].btnType[0] eq 'composeAction'}">
                                                            <div class="row">
                                                                <div class="th bottom-border top-border">전화번호</div>
                                                                <div class="td bottom-border top-border">
                                                                    <input type="text" name="phone_value_08"
                                                                           class="txt_input width en_font"
                                                                           value="${list[2].btnData[0][0]}"/>
                                                                </div>
                                                            </div>
                                                            <div class="row">
                                                                <div class="th">문자메시지 내용</div>
                                                                <div class="td">
                                                                    <input type="text" name="message_value"
                                                                           class="txt_input width"
                                                                           value="${list[2].btnData[0][1]}"/>
                                                                </div>
                                                            </div>
                                                            <input type="hidden" name="copy_value" value=" "/>
                                                            <input type="hidden" name="url_value" value=" "/>
                                                            <input type="hidden" name="phone_value_03" value=" "/>
                                                            <input type="hidden" name="latitude_value" value=" "/>
                                                            <input type="hidden" name="longitude_value" value=" "/>
                                                            <input type="hidden" name="location_value_04" value=" "/>
                                                            <input type="hidden" name="fallback_url_04" value=" "/>
                                                            <input type="hidden" name="location_value_05" value=" "/>
                                                            <input type="hidden" name="fallback_url_05" value=" "/>
                                                            <input type="hidden" name="start_date" value=" "/>
                                                            <input type="hidden" name="end_date" value=" "/>
                                                            <input type="hidden" name="calendar_title" value=" "/>
                                                            <input type="hidden" name="calendar_body" value=" "/>
                                                        </c:if>
                                                    </div>
                                                </div>
                                                <div class="block">
                                                    <div class="row">
                                                        <div class="th bottom-border">버튼 액션 선택</div>
                                                        <div class="td bottom-border">
                                                            <div class="select action_select" data="2">
                                                                <span id="btnHidden2"></span>
                                                                <c:choose>
                                                                    <c:when test="${list[2].btnType[1] eq 'clipboardAction'}">
                                                                        <div class="value" data="RBTN01"
                                                                             style="color: rgb(34, 34, 34);">
                                                                            복사하기
                                                                        </div>
                                                                    </c:when>
                                                                    <c:when test="${list[2].btnType[1] eq 'urlAction'}">
                                                                        <div class="value" data="RBTN02"
                                                                             style="color: rgb(34, 34, 34);">
                                                                            URL연결
                                                                        </div>
                                                                    </c:when>
                                                                    <c:when test="${list[2].btnType[1] eq 'dialerAction'}">
                                                                        <div class="value" data="RBTN03"
                                                                             style="color: rgb(34, 34, 34);">
                                                                            전화걸기
                                                                        </div>
                                                                    </c:when>
                                                                    <c:when test="${list[2].btnType[1] eq 'latitude'}">
                                                                        <div class="value" data="RBTN04"
                                                                             style="color: rgb(34, 34, 34);">
                                                                            지도보여주기(좌표)
                                                                        </div>
                                                                    </c:when>
                                                                    <c:when test="${list[2].btnType[1] eq 'query'}">
                                                                        <div class="value" data="RBTN05"
                                                                             style="color: rgb(34, 34, 34);">
                                                                            지도보여주기(쿼리)
                                                                        </div>
                                                                    </c:when>
                                                                    <c:when test="${list[2].btnType[1] eq 'requestLocationPush'}">
                                                                        <div class="value" data="RBTN06"
                                                                             style="color: rgb(34, 34, 34);">
                                                                            현재위치공유
                                                                        </div>
                                                                    </c:when>
                                                                    <c:when test="${list[2].btnType[1] eq 'calendarAction'}">
                                                                        <div class="value" data="RBTN07"
                                                                             style="color: rgb(34, 34, 34);">
                                                                            캘린더등록
                                                                        </div>
                                                                    </c:when>
                                                                    <c:when test="${list[2].btnType[1] eq 'composeAction'}">
                                                                        <div class="value" data="RBTN08"
                                                                             style="color: rgb(34, 34, 34);">
                                                                            메세지전송
                                                                        </div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <div class="value" data="0">
                                                                            액션선택
                                                                        </div>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                                <ul class="option">
                                                                    <li data="0">액션선택</li>
                                                                    <li data="RBTN01">복사하기</li>
                                                                    <li data="RBTN02">URL연결</li>
                                                                    <li data="RBTN03">전화걸기</li>
                                                                    <li data="RBTN04">지도보여주기(좌표)</li>
                                                                    <li data="RBTN05">지도보여주기(쿼리)</li>
                                                                    <li data="RBTN06">현재위치공유</li>
                                                                    <li data="RBTN07">캘린더등록</li>
                                                                    <li data="RBTN08">메시지전송</li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="th">버튼 명</div>
                                                        <div class="td button-name">
                                                            <!-- 버튼명이 존재할 경우 -->
                                                            <c:if test="${fn:trim(list[2].btnText[1]) != ''}">
                                                                <input type="text" name="rcs_btn_2"
                                                                       class="txt_input action_name" data="2"
                                                                       onkeyup="rcsCreate.buttonCount(this, 'vertical');"
                                                                       value="${list[2].btnText[1]}"/>
                                                            </c:if>
                                                            <!-- 버튼명이 없을 경우 -->
                                                            <c:if test="${fn:trim(list[2].btnText[1]) == ''}">
                                                                <input type="text" name="rcs_btn_2"
                                                                       class="txt_input action_name" data="2"
                                                                       onkeyup="rcsCreate.buttonCount(this, 'vertical');"
                                                                       placeholder="버튼 명을 입력해주세요"
                                                                />
                                                            </c:if>
                                                            <span class="text-count en_font">
                                                                <span>
                                                                <c:if test="${list[2].btnText[1] != ''}">
                                                                    ${fn:length(list[2].btnText[1])}
                                                                </c:if>
                                                                <c:if test="${list[2].btnText[1] == ''}">
                                                                    0
                                                                </c:if>
                                                                </span>/17</span>
                                                        </div>
                                                    </div>
                                                    <div class="custom_box">
                                                        <!-- 초기 버튼 selectBox 랜딩 서비스 -->
                                                        <c:if test="${list[2].btnType[1] eq 'clipboardAction'}">
                                                            <div class="row">
                                                                <div class="th top-border">복사할 값</div>
                                                                <div class="td top-border">
                                                                    <input type="text" name="copy_value"
                                                                           class="txt_input width"
                                                                           value="${list[2].btnData[1][0]}"/>
                                                                </div>
                                                            </div>
                                                            <input type="hidden" name="url_value" value=" "/>
                                                            <input type="hidden" name="phone_value_03" value=" "/>
                                                            <input type="hidden" name="latitude_value" value=" "/>
                                                            <input type="hidden" name="longitude_value" value=" "/>
                                                            <input type="hidden" name="location_value_04" value=" "/>
                                                            <input type="hidden" name="fallback_url_04" value=" "/>
                                                            <input type="hidden" name="location_value_05" value=" "/>
                                                            <input type="hidden" name="fallback_url_05" value=" "/>
                                                            <input type="hidden" name="start_date" value=" "/>
                                                            <input type="hidden" name="end_date" value=" "/>
                                                            <input type="hidden" name="calendar_title" value=" "/>
                                                            <input type="hidden" name="calendar_body" value=" "/>
                                                            <input type="hidden" name="phone_value_08" value=" "/>
                                                            <input type="hidden" name="message_value" value=" "/>
                                                        </c:if>
                                                        <c:if test="${list[2].btnType[1] eq 'urlAction'}">
                                                            <div class="row">
                                                                <div class="th top-border">URL</div>
                                                                <div class="td top-border">
                                                                    <input type="text" name="url_value"
                                                                           class="txt_input width" data="url"
                                                                           value="${list[2].btnData[1][0]}"/>
                                                                </div>
                                                            </div>
                                                            <input type="hidden" name="copy_value" value=" "/>
                                                            <input type="hidden" name="phone_value_03" value=" "/>
                                                            <input type="hidden" name="latitude_value" value=" "/>
                                                            <input type="hidden" name="longitude_value" value=" "/>
                                                            <input type="hidden" name="location_value_04" value=" "/>
                                                            <input type="hidden" name="fallback_url_04" value=" "/>
                                                            <input type="hidden" name="location_value_05" value=" "/>
                                                            <input type="hidden" name="fallback_url_05" value=" "/>
                                                            <input type="hidden" name="start_date" value=" "/>
                                                            <input type="hidden" name="end_date" value=" "/>
                                                            <input type="hidden" name="calendar_title" value=" "/>
                                                            <input type="hidden" name="calendar_body" value=" "/>
                                                            <input type="hidden" name="phone_value_08" value=" "/>
                                                            <input type="hidden" name="message_value" value=" "/>
                                                        </c:if>
                                                        <c:if test="${list[2].btnType[1] eq 'dialerAction'}">
                                                            <div class="row">
                                                                <div class="th top-border">전화번호</div>
                                                                <div class="td top-border">
                                                                    <input type="text" name="phone_value_03"
                                                                           class="txt_input width"
                                                                           value="${list[2].btnData[1][0]}"
                                                                    />
                                                                </div>
                                                            </div>
                                                            <input type="hidden" name="copy_value" value=" "/>
                                                            <input type="hidden" name="url_value" value=" "/>
                                                            <input type="hidden" name="latitude_value" value=" "/>
                                                            <input type="hidden" name="longitude_value" value=" "/>
                                                            <input type="hidden" name="location_value_04" value=" "/>
                                                            <input type="hidden" name="fallback_url_04" value=" "/>
                                                            <input type="hidden" name="location_value_05" value=" "/>
                                                            <input type="hidden" name="fallback_url_05" value=" "/>
                                                            <input type="hidden" name="start_date" value=" "/>
                                                            <input type="hidden" name="end_date" value=" "/>
                                                            <input type="hidden" name="calendar_title" value=" "/>
                                                            <input type="hidden" name="calendar_body" value=" "/>
                                                            <input type="hidden" name="phone_value_08" value=" "/>
                                                            <input type="hidden" name="message_value" value=" "/>
                                                        </c:if>
                                                        <c:if test="${list[2].btnType[1] eq 'latitude'}">
                                                            <div class="row">
                                                                <div class="th bottom-border top-border">위도/경도</div>
                                                                <div class="td bottom-border top-border">
                                                                    <input type="text" name="latitude_value"
                                                                           class="txt_input en_font half right-border"
                                                                           value="${list[2].btnData[1][0]}"/>
                                                                    <input type="text" name="longitude_value"
                                                                           class="txt_input en_font half"
                                                                           value="${list[2].btnData[1][1]}"/>
                                                                </div>
                                                            </div>
                                                            <div class="row">
                                                                <div class="th bottom-border">위치 이름</div>
                                                                <div class="td bottom-border">
                                                                    <input type="text" name="location_value_04"
                                                                           class="txt_input width"
                                                                           value="${list[2].btnData[1][2]}"/>
                                                                </div>
                                                            </div>
                                                            <div class="row">
                                                                <div class="th">Fallback URL</div>
                                                                <div class="td">
                                                                    <input type="text" name="fallback_url_04"
                                                                           class="txt_input width en_font url_link"
                                                                           data="url" value="${list[2].btnData[1][3]}"/>
                                                                </div>
                                                            </div>
                                                            <input type="hidden" name="copy_value" value=" "/>
                                                            <input type="hidden" name="url_value" value=" "/>
                                                            <input type="hidden" name="phone_value_03" value=" "/>
                                                            <input type="hidden" name="location_value_05" value=" "/>
                                                            <input type="hidden" name="fallback_url_05" value=" "/>
                                                            <input type="hidden" name="start_date" value=" "/>
                                                            <input type="hidden" name="end_date" value=" "/>
                                                            <input type="hidden" name="calendar_title" value=" "/>
                                                            <input type="hidden" name="calendar_body" value=" "/>
                                                            <input type="hidden" name="phone_value_08" value=" "/>
                                                            <input type="hidden" name="message_value" value=" "/>
                                                        </c:if>
                                                        <c:if test="${list[2].btnType[1] eq 'query'}">
                                                            <div class="row">
                                                                <div class="th bottom-border top-border">위치 이름</div>
                                                                <div class="td bottom-border top-border">
                                                                    <input type="text" name="location_value_05"
                                                                           class="txt_input width"
                                                                           value="${list[2].btnData[1][0]}"/>
                                                                </div>
                                                            </div>
                                                            <div class="row">
                                                                <div class="th">Fallback URL</div>
                                                                <div class="td">
                                                                    <input type="text" name="fallback_url_05"
                                                                           class="txt_input width en_font url_link"
                                                                           data="url" value="${list[2].btnData[1][1]}"/>
                                                                </div>
                                                            </div>
                                                            <input type="hidden" name="copy_value" value=" "/>
                                                            <input type="hidden" name="url_value" value=" "/>
                                                            <input type="hidden" name="phone_value_03" value=" "/>
                                                            <input type="hidden" name="latitude_value" value=" "/>
                                                            <input type="hidden" name="longitude_value" value=" "/>
                                                            <input type="hidden" name="location_value_04" value=" "/>
                                                            <input type="hidden" name="fallback_url_04" value=" "/>
                                                            <input type="hidden" name="start_date" value=" "/>
                                                            <input type="hidden" name="end_date" value=" "/>
                                                            <input type="hidden" name="calendar_title" value=" "/>
                                                            <input type="hidden" name="calendar_body" value=" "/>
                                                            <input type="hidden" name="phone_value_08" value=" "/>
                                                            <input type="hidden" name="message_value" value=" "/>
                                                        </c:if>
                                                        <c:if test="${list[2].btnType[1] eq 'requestLocationPush'}">
                                                            <input type="hidden" name="copy_value" value=" "/>
                                                            <input type="hidden" name="url_value" value=" "/>
                                                            <input type="hidden" name="phone_value_03" value=" "/>
                                                            <input type="hidden" name="latitude_value" value=" "/>
                                                            <input type="hidden" name="longitude_value" value=" "/>
                                                            <input type="hidden" name="location_value_04" value=" "/>
                                                            <input type="hidden" name="location_value_05" value=" "/>
                                                            <input type="hidden" name="fallback_url_04" value=" "/>
                                                            <input type="hidden" name="fallback_url_05" value=" "/>
                                                            <input type="hidden" name="start_date" value=" "/>
                                                            <input type="hidden" name="end_date" value=" "/>
                                                            <input type="hidden" name="calendar_title" value=" "/>
                                                            <input type="hidden" name="calendar_body" value=" "/>
                                                            <input type="hidden" name="phone_value_08" value=" "/>
                                                            <input type="hidden" name="message_value" value=" "/>
                                                        </c:if>
                                                        <c:if test="${list[2].btnType[1] eq 'calendarAction'}">
                                                            <div class="row">
                                                                <div class="th bottom-border top-border">시작일 / 종료일</div>
                                                                <div class="td bottom-border top-border">
                                                                    <input type="text" name="start_date"
                                                                           class="start_date txt_input en_font calendar right-border"
                                                                           value="${list[2].btnData[1][0]}"/>
                                                                    <input type="text" name="end_date"
                                                                           class="end_date txt_input en_font calendar"
                                                                           value="${list[2].btnData[1][1]}"/>
                                                                </div>
                                                            </div>
                                                            <div class="row">
                                                                <div class="th bottom-border">제목</div>
                                                                <div class="td bottom-border">
                                                                    <input type="text" name="calendar_title"
                                                                           class="txt_input width"
                                                                           value="${list[2].btnData[1][2]}"/>
                                                                </div>
                                                            </div>
                                                            <div class="row">
                                                                <div class="th">내용</div>
                                                                <div class="td">
                                                                    <input type="text" name="calendar_body"
                                                                           class="txt_input width"
                                                                           value="${list[2].btnData[1][3]}"/>
                                                                </div>
                                                            </div>
                                                            <input type="hidden" name="copy_value" value=" "/>
                                                            <input type="hidden" name="url_value" value=" "/>
                                                            <input type="hidden" name="phone_value_03" value=" "/>
                                                            <input type="hidden" name="latitude_value" value=" "/>
                                                            <input type="hidden" name="longitude_value" value=" "/>
                                                            <input type="hidden" name="location_value_04" value=" "/>
                                                            <input type="hidden" name="fallback_url_04" value=" "/>
                                                            <input type="hidden" name="location_value_05" value=" "/>
                                                            <input type="hidden" name="fallback_url_05" value=" "/>
                                                            <input type="hidden" name="phone_value_08" value=" "/>
                                                            <input type="hidden" name="message_value" value=" "/>
                                                        </c:if>
                                                        <c:if test="${list[2].btnType[1] eq 'composeAction'}">
                                                            <div class="row">
                                                                <div class="th bottom-border top-border">전화번호</div>
                                                                <div class="td bottom-border top-border">
                                                                    <input type="text" name="phone_value_08"
                                                                           class="txt_input width en_font"
                                                                           value="${list[2].btnData[1][0]}"/>
                                                                </div>
                                                            </div>
                                                            <div class="row">
                                                                <div class="th">문자메시지 내용</div>
                                                                <div class="td">
                                                                    <input type="text" name="message_value"
                                                                           class="txt_input width"
                                                                           value="${list[2].btnData[1][1]}"/>
                                                                </div>
                                                            </div>
                                                            <input type="hidden" name="copy_value" value=" "/>
                                                            <input type="hidden" name="url_value" value=" "/>
                                                            <input type="hidden" name="phone_value_03" value=" "/>
                                                            <input type="hidden" name="latitude_value" value=" "/>
                                                            <input type="hidden" name="longitude_value" value=" "/>
                                                            <input type="hidden" name="location_value_04" value=" "/>
                                                            <input type="hidden" name="fallback_url_04" value=" "/>
                                                            <input type="hidden" name="location_value_05" value=" "/>
                                                            <input type="hidden" name="fallback_url_05" value=" "/>
                                                            <input type="hidden" name="start_date" value=" "/>
                                                            <input type="hidden" name="end_date" value=" "/>
                                                            <input type="hidden" name="calendar_title" value=" "/>
                                                            <input type="hidden" name="calendar_body" value=" "/>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="block" id="rejection">
                                                <div class="row">
                                                    <div class="th">무료수신거부</div>
                                                    <div class="td">
                                                        <input type="text" name="rcs_footer" class="txt_input rejection_num width" value="${list[2].rcs_footer}"
                                                               oninput="rcsCreate.rejection(this);">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="viewer_area" id="vertical">
                                        <div class="rcs_inner vertical">
                                            <div class="rcs_head">[WEB발신]</div>
                                            <span id="js-vt-replace">
                                            <!-- 세로형 Tall -->
                                            <c:if test="${list[2].msg_tp eq 'DMCH207'}">
                                                <div class="rcs_vertical tall cf">
                                                    <div class="img_area">
                                                        <c:if test="${fn:trim(fn:split(list[2].img_lst,',')[0]) != ''}">
                                                            <img src="${filePath}${fn:split(list[2].img_lst,',')[0]}"
                                                                 onerror="this.src = '/image/bg_none.png'"/>
                                                        </c:if>
                                                    </div>
                                                    <input type="hidden" name="rcs_img_url_1"
                                                            <c:if test="${fn:trim(fn:split(list[2].img_lst,',')[0]) != ''}">
                                                                value="${fn:split(list[2].img_lst,',')[0]}"
                                                            </c:if>/>
                                                    <div class="txt_area"><h3
                                                            id="titleArea0">${list[2].cont_sub}</h3>
                                                        <p id="textArea0">${list[2].cont_body}</p>
                                                        <div class="rcs_btn_wrap">
                                                            <c:if test="${fn.trim(list[2].btnText[0]) != ''}">
                                                                <div class="rcs_btn"
                                                                     data="1">${list[2].btnText[0]}</div>
                                                            </c:if>
                                                            <c:if test="${fn.trim(list[2].btnText[1]) != ''}">
                                                                <div class="rcs_btn"
                                                                     data="2">${list[2].btnText[1]}</div>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>
                                                <!-- 세로형 Medium -->
                                            <c:if test="${list[2].msg_tp eq 'DMCH208'}">
                                                <div class="rcs_vertical medium cf">
                                                    <div class="img_area">
                                                        <c:if test="${fn:trim(fn:split(list[2].img_lst,',')[0]) != ''}">
                                                            <img src="${filePath}${fn:split(list[2].img_lst,',')[0]}"
                                                                 onerror="this.src = '/image/bg_none.png'"/>
                                                        </c:if>
                                                    </div>
                                                    <input type="hidden" name="rcs_img_url_1"
                                                            <c:if test="${fn:trim(fn:split(list[2].img_lst,',')[0]) != ''}">
                                                                value="${fn:split(list[2].img_lst,',')[0]}"
                                                            </c:if>
                                                    />
                                                    <div class="txt_area">
                                                        <h3 id="titleArea0">${list[2].cont_sub}</h3>
                                                        <p id="textArea0">${list[2].cont_body}</p>
                                                        <div class="rcs_btn_wrap">
                                                            <c:if test="${fn.trim(list[2].btnText[0]) != ''}">
                                                                <div class="rcs_btn"
                                                                     data="1">${list[2].btnText[0]}</div>
                                                            </c:if>
                                                            <c:if test="${fn.trim(list[2].btnText[1]) != ''}">
                                                                <div class="rcs_btn"
                                                                     data="2">${list[2].btnText[1]}</div>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>
                                                <div class="rcs_register">무료 수신거부 : <span id="rejectionArea"></span></div>
                                                        <div class="text_count">
                                                            <span class="num en_font"><span id="textByte0">0</span>/1300</span>
                                                            <p>※ 본문내용 : <span class="en_font">1300</span>글자 이내<br>본문길이 : 최대
                                                                96줄
                                                            </p>
                                                        </div>
                                                    </span>
                                        </div>
                                    </div>
                                </div>
                                <c:forEach var="i" begin="0" end="2">
                                    <c:if test="${list[2].btnType[i] eq 'clipboardAction'}">
                                        <input type="hidden" name="rcs_btn_tp_${i+1}" value="RBTN01"/>
                                    </c:if>
                                    <c:if test="${list[2].btnType[i] eq 'urlAction'}">
                                        <input type="hidden" name="rcs_btn_tp_${i+1}" value="RBTN02"/>
                                    </c:if>
                                    <c:if test="${list[2].btnType[i] eq 'dialerAction'}">
                                        <input type="hidden" name="rcs_btn_tp_${i+1}" value="RBTN03"/>
                                    </c:if>
                                    <c:if test="${list[2].btnType[i] eq 'latitude'}">
                                        <input type="hidden" name="rcs_btn_tp_${i+1}" value="RBTN04"/>
                                    </c:if>
                                    <c:if test="${list[2].btnType[i] eq 'query'}">
                                        <input type="hidden" name="rcs_btn_tp_${i+1}" value="RBTN05"/>
                                    </c:if>
                                    <c:if test="${list[2].btnType[i] eq 'requestLocationPush'}">
                                        <input type="hidden" name="rcs_btn_tp_${i+1}" value="RBTN06"/>
                                    </c:if>
                                    <c:if test="${list[2].btnType[i] eq 'calendarAction'}">
                                        <input type="hidden" name="rcs_btn_tp_${i+1}" value="RBTN07"/>
                                    </c:if>
                                    <c:if test="${list[2].btnType[i] eq 'composeAction'}">
                                        <input type="hidden" name="rcs_btn_tp_${i+1}" value="RBTN08"/>
                                    </c:if>
                                    <c:if test="${fn:trim(list[2].btnType[i]) == ''}">
                                        <input type="hidden" name="rcs_btn_tp_${i+1}" value=""/>
                                    </c:if>
                                </c:forEach>
                                </c:if>
                                <!-- RCS 슬라이드 형 2021-->
                                <c:set var="cnt" value="0"></c:set>
                                <c:set var="btnCnt1" value="1"></c:set>
                                <c:set var="btnCnt2" value="2"></c:set>
                                <c:if test="${list[2].msg_tp eq 'DMCH211' || list[2].msg_tp eq 'DMCH212'}">
                                    <%--<div id="slideArea">
                                <div class="flex_box" id="js-rcs-area">--%>
                                    <%--<div class="left_area">--%>
                                <div class="row body">
                                    <div class="th">카드 양식</div>
                                    <div class="column_1">
                                        <div class="select slide_type">
                                            <c:if test="${list[2].msg_tp eq 'DMCH211' && list[2].cardSize eq 3}">
                                                <div class="value" data="0">
                                                    Small / 3장
                                                </div>
                                            </c:if>
                                            <c:if test="${list[2].msg_tp eq 'DMCH211' && list[2].cardSize eq 4}">
                                                <div class="value" data="1">
                                                    Small / 4장
                                                </div>
                                            </c:if>
                                            <c:if test="${list[2].msg_tp eq 'DMCH211' && list[2].cardSize eq 5}">
                                                <div class="value" data="2">
                                                    Small / 5장
                                                </div>
                                            </c:if>
                                            <c:if test="${list[2].msg_tp eq 'DMCH211' && list[2].cardSize eq 6}">
                                                <div class="value" data="3">
                                                    Small / 6장
                                                </div>
                                            </c:if>
                                            <c:if test="${list[2].msg_tp eq 'DMCH212' && list[2].cardSize eq 3}">
                                                <div class="value" data="4">
                                                    Medium / 3장
                                                </div>
                                            </c:if>
                                            <c:if test="${list[2].msg_tp eq 'DMCH212' && list[2].cardSize eq 4}">
                                                <div class="value" data="5">
                                                    Medium / 4장
                                                </div>
                                            </c:if>
                                            <c:if test="${list[2].msg_tp eq 'DMCH212' && list[2].cardSize eq 5}">
                                                <div class="value" data="6">
                                                    Medium / 5장
                                                </div>
                                            </c:if>
                                            <c:if test="${list[2].msg_tp eq 'DMCH212' && list[2].cardSize eq 6}">
                                                <div class="value" data="7">
                                                    Medium / 6장
                                                </div>
                                            </c:if>
                                            <ul class="option">
                                                <li data="0">Small / 3장</li>
                                                <li data="1">Small / 4장</li>
                                                <li data="2">Small / 5장</li>
                                                <li data="3">Small / 6장</li>
                                                <li data="4">Medium / 3장</li>
                                                <li data="5">Medium / 4장</li>
                                                <li data="6">Medium / 5장</li>
                                                <li data="7">Medium / 6장</li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                                <div class="row body">
                                    <div class="th">발신 번호</div>
                                    <div class="column_1">
                                        <c:if test="${fn:trim(list[2].send_to) == ''}">
                                            <input type="text" class="sms_number smsNumber" id="send_slice_rcs"
                                                   placeholder="발신 번호를 입력해주세요." readonly="">
                                        </c:if>
                                        <c:if test="${fn:trim(list[2].send_to) != ''}">
                                            <input type="text" class="sms_number smsNumber" id="send_slice_rcs"
                                                   value="${list[2].sender}(${list[2].send_num})"/>
                                        </c:if>
                                        <input type="hidden" name="send_to_list" id="slide_send_num"
                                               value="${list[2].send_to}"/>
                                        <span class="btn_sm_line"
                                              onclick="mobileSenderPopup('1','slidercs')">변경</span>
                                    </div>
                                </div>

                                <div class="input_area left">
                                    <div class="block line_none">
                                        <div class="slide_tab cf">
                                            <c:forEach var="i" begin="1" end="${list[2].cardSize}">
                                                <c:if test="${i eq 1}">
                                                    <div id="cardOn" class="cardOn on" data="${i}">
                                                        카드${i}</div>
                                                </c:if>
                                                <c:if test="${i ne 1}">
                                                    <div id="cardOn" class="cardOn" data="${i}">카드${i}</div>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <c:forEach var="idx" begin="0" end="${list[2].cardSize-1}"
                                               varStatus="st">
                                    <!-- 카드 사이즈 만큼 반복하며 카드 그리기 -->
                                    <c:if test="${idx eq 0}">
                                    <div class="rcs_slide_conts on">
                                        </c:if>
                                        <c:if test="${idx ne 0}">
                                        <div class="rcs_slide_conts">
                                            </c:if>
                                            <div class="block">
                                                <div class="row">
                                                    <div class="th">이미지 선택</div>
                                                    <div class="td">
                                                        <div class="delete_img">
                                                            <img
                                                                    src="${baseURL}/image/btn_delete1.png"
                                                                    alt="삭제">
                                                        </div>
                                                        <c:set var="imgNm"
                                                               value="${fn:split(list[2].img_nm_lst,',')[idx]}"/>
                                                        <!-- 이미지가 존재할 경우 -->
                                                        <c:if test="${fn:trim(imgNm) != ''}">
                                                            <input type="text" name=""
                                                                   class="txt_input en_font rcsImage"
                                                                   id="slide${idx}"
                                                                   value="${imgNm}"/>
                                                        </c:if>
                                                        <!-- 이미지가 존재하지 않을 경우 -->
                                                        <c:if test="${fn:trim(imgNm) == ''}">
                                                            <input type="text" name=""
                                                                   class="txt_input en_font rcsImage"
                                                                   id="slide${idx}"
                                                                   readonly="이미지를 등록해 주세요">
                                                        </c:if>
                                                        <input type="hidden" name="rcs_img_cd_${idx+1}"
                                                               class="txt_input en_font rcsImage"
                                                                <c:if test="${!cutil:isEmptyObject(list[2].img_cd_1) && idx == 0}">
                                                                    value="${list[2].img_cd_1}"
                                                                </c:if>
                                                                <c:if test="${!cutil:isEmptyObject(list[2].img_cd_2) && idx == 1}">
                                                                    value="${list[2].img_cd_2}"
                                                                </c:if>
                                                                <c:if test="${!cutil:isEmptyObject(list[2].img_cd_3) && idx == 2}">
                                                                    value="${list[2].img_cd_3}"
                                                                </c:if>
                                                                <c:if test="${!cutil:isEmptyObject(list[2].img_cd_4) && idx == 3}">
                                                                    value="${list[2].img_cd_4}"
                                                                </c:if>
                                                                <c:if test="${!cutil:isEmptyObject(list[2].img_cd_5) && idx == 4}">
                                                                    value="${list[2].img_cd_5}"
                                                                </c:if>
                                                                <c:if test="${!cutil:isEmptyObject(list[2].img_cd_6) && idx == 5}">
                                                                    value="${list[2].img_cd_6}"
                                                                </c:if>
                                                        />
                                                        <span class="btn_sm_line" data="slide${idx}"
                                                              onclick="imageListPopUp('1','slideRcsImage')">선택</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="block">
                                                <div class="row">
                                                    <div class="th">개인화 변수</div>
                                                    <div class="td">
                                                        <div class="select rcsTitleVal" name="edmDB">
                                                            <div class="value" data="0">개인화 변수</div>
                                                            <ul class="option mappingLst">
                                                            </ul>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="th top-border">문자 제목</div>
                                                    <div class="td top-border">
                                                        <c:if test="${fn:trim(list[2].slideTitle[idx]) != ''}">
                                                            <input type="text" name="slide_cont_sub"
                                                                   class="txt_input width rcsTitle"
                                                                   value="${list[2].slideTitle[idx]}"
                                                                   onkeyup="rcsCreate.rcsTitle(this,${idx});">
                                                        </c:if>
                                                        <c:if test="${fn:trim(list[2].slideTitle[idx]) == ''}">
                                                            <input type="text" name="slide_cont_sub"
                                                                   class="txt_input width rcsTitle"
                                                                   placeholder="문자 제목을 입력해주세요"
                                                                   onkeyup="rcsCreate.rcsTitle(this,${idx});">
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="block">
                                                <div class="row">
                                                    <div class="th">개인화 변수</div>
                                                    <div class="td">
                                                        <div class="select column_4 rcsContsVal"
                                                             name="edmDB">
                                                            <div class="value" data="0">개인화 변수</div>
                                                            <ul class="option mappingLst">
                                                            </ul>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row rcs_textarea">
                                                    <div class="th top-border">내용</div>
                                                    <div class="td top-border">
                                                        <c:if test="${fn:trim(list[2].slideBody[idx]) == ''}">
                                                                    <textarea class="rcsContents" name="slide_cont_body"
                                                                              id="" cols="30"
                                                                              rows="10" placeholder="내용을 입력해주세요."
                                                                              onkeyup="rcsCreate.rcsContents(this,${idx});">
                                                                    </textarea>
                                                        </c:if>
                                                        <c:if test="${fn:trim(list[2].slideBody[idx]) != ''}">
                                                                    <textarea class="rcsContents" name="slide_cont_body"
                                                                              id="" cols="30" rows="10"
                                                                              onkeyup="rcsCreate.rcsContents(this,${idx});">${cutil:textAreaParsing(list[2].slideBody[idx])}</textarea>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="block">
                                                <div class="row">
                                                    <div class="th bottom-border">버튼 액션 선택</div>
                                                    <div class="td bottom-border">
                                                        <div class="select action_select" data="1">
                                                            <span id="btnHidden${btnCnt1}"></span>
                                                            <c:set var="btnCnt1"
                                                                   value="${btnCnt1+2}"></c:set>
                                                            <c:set var="btn"
                                                                   value="${list[2].cont_btn_json[idx]['suggestions'][0]}"/>
                                                            <c:choose>
                                                                <c:when test="${!cutil:isEmptyObject(btn['action']['clipboardAction']['copyToClipboard'])}">
                                                                    <div class="value" data="RBTN01"
                                                                         style="color: rgb(34, 34, 34);">
                                                                        복사하기
                                                                    </div>
                                                                </c:when>
                                                                <c:when test="${!cutil:isEmptyObject(btn['action']['urlAction']['openUrl'])}">
                                                                    <div class="value" data="RBTN02"
                                                                         style="color: rgb(34, 34, 34);">
                                                                        URL연결
                                                                    </div>
                                                                </c:when>
                                                                <c:when test="${!cutil:isEmptyObject(btn['action']['dialerAction'])}">
                                                                    <div class="value" data="RBTN03"
                                                                         style="color: rgb(34, 34, 34);">
                                                                        전화걸기
                                                                    </div>
                                                                </c:when>
                                                                <c:when test="${!cutil:isEmptyObject(btn['action']['mapAction']['showLocation']['location']['latitude'])}">
                                                                    <div class="value" data="RBTN04"
                                                                         style="color: rgb(34, 34, 34);">
                                                                        지도보여주기(좌표)
                                                                    </div>
                                                                </c:when>
                                                                <c:when test="${!cutil:isEmptyObject(btn['action']['mapAction']['showLocation']['location']['query'])}">
                                                                    <div class="value" data="RBTN05"
                                                                         style="color: rgb(34, 34, 34);">
                                                                        지도보여주기(쿼리)
                                                                    </div>
                                                                </c:when>
                                                                <c:when test="${!cutil:isEmptyObject(btn['action']['mapAction'])}">
                                                                    <c:choose>
                                                                        <c:when test="${cutil:isEmptyObject(btn['action']['mapAction']['showLocation'])}">
                                                                            <div class="value" data="RBTN06"
                                                                                 style="color: rgb(34, 34, 34);">
                                                                                현재위치공유
                                                                            </div>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </c:when>
                                                                <c:when test="${!cutil:isEmptyObject(btn['action']['calendarAction'])}">
                                                                    <div class="value" data="RBTN07"
                                                                         style="color: rgb(34, 34, 34);">
                                                                        캘린더등록
                                                                    </div>
                                                                </c:when>
                                                                <c:when test="${!cutil:isEmptyObject(btn['action']['composeAction'])}">
                                                                    <div class="value" data="RBTN08"
                                                                         style="color: rgb(34, 34, 34);">
                                                                        메세지전송
                                                                    </div>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="value" data="0">
                                                                        액션선택
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <ul class="option">
                                                                <li data="0">액션선택</li>
                                                                <li data="RBTN01">복사하기</li>
                                                                <li data="RBTN02">URL연결</li>
                                                                <li data="RBTN03">전화걸기</li>
                                                                <li data="RBTN04">지도보여주기(좌표)</li>
                                                                <li data="RBTN05">지도보여주기(쿼리)</li>
                                                                <li data="RBTN06">현재위치공유</li>
                                                                <li data="RBTN07">캘린더등록</li>
                                                                <li data="RBTN08">메시지전송</li>
                                                            </ul>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="th">버튼 명</div>
                                                    <div class="td button-name">
                                                        <c:if test="${list[2].msg_tp eq 'DMCH211'}">
                                                        <c:set var="btn"
                                                               value="${list[2].cont_btn_json[idx]['suggestions'][0]}"/>
                                                        <c:if test="${fn:trim(btn['action']['displayText']) != ''}">
                                                            <input type="text" name="slide_rcs_btn_1"
                                                                   class="txt_input action_name" data="1"
                                                                   onkeyup="rcsCreate.buttonCount(this, 'slideSmall');"
                                                                   value="${btn['action']['displayText']}"/>
                                                        </c:if>
                                                        <c:if test="${fn:trim(btn['action']['displayText']) == ''}">
                                                            <input type="text" name="slide_rcs_btn_1"
                                                                   class="txt_input action_name" data="1"
                                                                   onkeyup="rcsCreate.buttonCount(this, 'slideSmall');"
                                                                   placeholder="버튼 명을 입력해주세요"/>
                                                        </c:if>
                                                        <span class="text-count en_font">
                                                                        <span>
                                                                            <c:if test="${fn:trim(btn['action']['displayText']) != ''}">
                                                                                ${fn:length(btn['action']['displayText'])}
                                                                            </c:if>
                                                                            <c:if test="${fn:trim(btn['action']['displayText']) == ''}">
                                                                                0
                                                                            </c:if>
                                                                        </span>/5</span>
                                                    </div>
                                                    </c:if>
                                                    <c:if test="${list[2].msg_tp eq 'DMCH212'}">
                                                    <c:set var="btn"
                                                           value="${list[2].cont_btn_json[idx]['suggestions'][0]}"/>
                                                    <c:if test="${fn:trim(btn['action']['displayText']) != ''}">
                                                        <input type="text" name="slide_rcs_btn_1"
                                                               class="txt_input action_name" data="1"
                                                               onkeyup="rcsCreate.buttonCount(this, 'slideMedium');"
                                                               value="${btn['action']['displayText']}"/>
                                                    </c:if>
                                                    <c:if test="${fn:trim(btn['action']['displayText']) == ''}">
                                                        <input type="text" name="slide_rcs_btn_1"
                                                               class="txt_input action_name" data="1"
                                                               onkeyup="rcsCreate.buttonCount(this, 'slideMedium');"
                                                               placeholder="버튼 명을 입력해주세요"/>
                                                    </c:if>
                                                    <span class="text-count en_font">
                                                                            <span>
                                                                                <c:if test="${fn:trim(btn['action']['displayText']) != ''}">
                                                                                    ${fn:length(btn['action']['displayText'])}
                                                                                </c:if>
                                                                                <c:if test="${fn:trim(btn['action']['displayText']) == ''}">
                                                                                    0
                                                                                </c:if>
                                                                            </span>/17</span>
                                                </div>
                                                </c:if>
                                            </div>
                                            <div class="custom_box">
                                                <!-- 초기 버튼 selectBox 랜딩 서비스 -->
                                                <c:set var="btn"
                                                       value="${list[2].cont_btn_json[idx]['suggestions'][0]}"/>
                                                <c:if test="${!cutil:isEmptyObject(btn['action']['clipboardAction']['copyToClipboard'])}">
                                                    <%--<c:if test = "${list[2].slideBtnType[idx][0] eq 'clipboardAction'}">--%>
                                                    <div class="row">
                                                        <div class="th top-border">복사할 값</div>
                                                        <div class="td top-border">
                                                            <c:set var="btn"
                                                                   value="${list[2].cont_btn_json[idx]['suggestions'][0]}"/>
                                                            <input type="text" name="copy_value"
                                                                   class="txt_input width"
                                                                   value="${btn['action']['clipboardAction']['copyToClipboard']['text']}"
                                                            />
                                                        </div>
                                                    </div>
                                                    <input type="hidden" name="url_value" value=" "/>
                                                    <input type="hidden" name="phone_value_03" value=" "/>
                                                    <input type="hidden" name="latitude_value" value=" "/>
                                                    <input type="hidden" name="longitude_value" value=" "/>
                                                    <input type="hidden" name="location_value_04"
                                                           value=" "/>
                                                    <input type="hidden" name="fallback_url_04" value=" "/>
                                                    <input type="hidden" name="location_value_05"
                                                           value=" "/>
                                                    <input type="hidden" name="fallback_url_05" value=" "/>
                                                    <input type="hidden" name="start_date" value=" "/>
                                                    <input type="hidden" name="end_date" value=" "/>
                                                    <input type="hidden" name="calendar_title" value=" "/>
                                                    <input type="hidden" name="calendar_body" value=" "/>
                                                    <input type="hidden" name="phone_value_08" value=" "/>
                                                    <input type="hidden" name="message_value" value=" "/>
                                                </c:if>
                                                <c:if test="${!cutil:isEmptyObject(btn['action']['urlAction']['openUrl'])}">
                                                    <%--<c:if test = "${list[2].slideBtnType[idx][0] eq 'urlAction'}">--%>
                                                    <div class="row">
                                                        <div class="th top-border">URL</div>
                                                        <div class="td top-border">
                                                            <c:set var="btn"
                                                                   value="${list[2].cont_btn_json[idx]['suggestions'][0]}"/>
                                                            <input type="text" name="url_value"
                                                                   class="txt_input width" data="url"
                                                                   value="${btn['action']['urlAction']['openUrl']['url']}"
                                                            />
                                                        </div>
                                                    </div>
                                                    <input type="hidden" name="copy_value" value=" "/>
                                                    <input type="hidden" name="phone_value_03" value=" "/>
                                                    <input type="hidden" name="latitude_value" value=" "/>
                                                    <input type="hidden" name="longitude_value" value=" "/>
                                                    <input type="hidden" name="location_value_04"
                                                           value=" "/>
                                                    <input type="hidden" name="fallback_url_04" value=" "/>
                                                    <input type="hidden" name="location_value_05"
                                                           value=" "/>
                                                    <input type="hidden" name="fallback_url_05" value=" "/>
                                                    <input type="hidden" name="start_date" value=" "/>
                                                    <input type="hidden" name="end_date" value=" "/>
                                                    <input type="hidden" name="calendar_title" value=" "/>
                                                    <input type="hidden" name="calendar_body" value=" "/>
                                                    <input type="hidden" name="phone_value_08" value=" "/>
                                                    <input type="hidden" name="message_value" value=" "/>
                                                </c:if>
                                                <c:if test="${!cutil:isEmptyObject(btn['action']['dialerAction'])}">
                                                    <%--<c:if test = "${list[2].slideBtnType[idx][0] eq 'dialerAction'}">--%>
                                                    <div class="row">
                                                        <div class="th top-border">전화번호</div>
                                                        <div class="td top-border">
                                                            <c:set var="btn"
                                                                   value="${list[2].cont_btn_json[idx]['suggestions'][0]}"/>
                                                            <input type="text" name="phone_value_03"
                                                                   class="txt_input width"
                                                                   value="${btn['action']['dialerAction']['dialPhoneNumber']['phoneNumber']}"
                                                            />
                                                        </div>
                                                    </div>
                                                    <input type="hidden" name="copy_value" value=" "/>
                                                    <input type="hidden" name="url_value" value=" "/>
                                                    <input type="hidden" name="latitude_value" value=" "/>
                                                    <input type="hidden" name="longitude_value" value=" "/>
                                                    <input type="hidden" name="location_value_04"
                                                           value=" "/>
                                                    <input type="hidden" name="fallback_url_04" value=" "/>
                                                    <input type="hidden" name="location_value_05"
                                                           value=" "/>
                                                    <input type="hidden" name="fallback_url_05" value=" "/>
                                                    <input type="hidden" name="start_date" value=" "/>
                                                    <input type="hidden" name="end_date" value=" "/>
                                                    <input type="hidden" name="calendar_title" value=" "/>
                                                    <input type="hidden" name="calendar_body" value=" "/>
                                                    <input type="hidden" name="phone_value_08" value=" "/>
                                                    <input type="hidden" name="message_value" value=" "/>
                                                </c:if>
                                                <c:if test="${!cutil:isEmptyObject(btn['action']['mapAction']['showLocation']['location']['latitude'])}">
                                                    <%--<c:if test = "${list[2].slideBtnType[idx][0] eq 'latitude'}">--%>
                                                    <div class="row">
                                                        <div class="th bottom-border top-border">위도/경도</div>
                                                        <div class="td bottom-border top-border">
                                                            <c:set var="btn"
                                                                   value="${list[2].cont_btn_json[idx]['suggestions'][0]}"/>
                                                            <input type="text" name="latitude_value"
                                                                   class="txt_input en_font half right-border"
                                                                   value="${btn['action']['mapAction']['showLocation']['location']['latitude']}"
                                                            />
                                                            <input type="text" name="longitude_value"
                                                                   class="txt_input en_font half"
                                                                   value="${btn['action']['mapAction']['showLocation']['location']['longitude']}"
                                                            />
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="th bottom-border">위치 이름</div>
                                                        <div class="td bottom-border">
                                                            <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][0]}"/>
                                                            <input type="text" name="location_value_04" class="txt_input width" value="${btn['action']['mapAction']['showLocation']['location']['label']}"/>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="th">Fallback URL</div>
                                                        <div class="td">
                                                            <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][0]}"/>
                                                            <input type="text" name="fallback_url_04" class="txt_input width en_font url_link" data="url" value="${btn['action']['mapAction']['showLocation']['fallbackUrl']}"/>
                                                        </div>
                                                    </div>
                                                    <input type="hidden" name="copy_value" value=" "/>
                                                    <input type="hidden" name="url_value" value=" "/>
                                                    <input type="hidden" name="phone_value_03" value=" "/>
                                                    <input type="hidden" name="location_value_05" value=" "/>
                                                    <input type="hidden" name="fallback_url_05" value=" "/>
                                                    <input type="hidden" name="start_date" value=" "/>
                                                    <input type="hidden" name="end_date" value=" "/>
                                                    <input type="hidden" name="calendar_title" value=" "/>
                                                    <input type="hidden" name="calendar_body" value=" "/>
                                                    <input type="hidden" name="phone_value_08" value=" "/>
                                                    <input type="hidden" name="message_value" value=" "/>
                                                </c:if>
                                                <c:if test="${!cutil:isEmptyObject(btn['action']['mapAction']['showLocation']['location']['query'])}">
                                                    <div class="row">
                                                        <div class="th bottom-border top-border">위치 이름</div>
                                                        <div class="td bottom-border top-border">
                                                            <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][0]}"/>
                                                            <input type="text" name="location_value_05" class="txt_input width" value="${btn['action']['mapAction']['showLocation']['location']['query']}"/>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="th">Fallback URL</div>
                                                        <div class="td">
                                                            <input type="text" name="fallback_url_05" class="txt_input width en_font url_link" data="url" value="${btn['action']['mapAction']['showLocation']['fallbackUrl']}"/>
                                                        </div>
                                                    </div>
                                                    <input type="hidden" name="copy_value" value=" "/>
                                                    <input type="hidden" name="url_value" value=" "/>
                                                    <input type="hidden" name="phone_value_03" value=" "/>
                                                    <input type="hidden" name="latitude_value" value=" "/>
                                                    <input type="hidden" name="longitude_value" value=" "/>
                                                    <input type="hidden" name="location_value_04" value=" "/>
                                                    <input type="hidden" name="fallback_url_04" value=" "/>
                                                    <input type="hidden" name="start_date" value=" "/>
                                                    <input type="hidden" name="end_date" value=" "/>
                                                    <input type="hidden" name="calendar_title" value=" "/>
                                                    <input type="hidden" name="calendar_body" value=" "/>
                                                    <input type="hidden" name="phone_value_08" value=" "/>
                                                    <input type="hidden" name="message_value" value=" "/>
                                                </c:if>
                                                <c:if test="${cutil:isEmptyObject(btn['action']['mapAction']['showLocation'])}">
                                                    <c:if test="${!cutil:isEmptyObject(btn['action']['mapAction'])}">
                                                        <input type="hidden" name="copy_value" value=" "/>
                                                        <input type="hidden" name="url_value" value=" "/>
                                                        <input type="hidden" name="phone_value_03" value=" "/>
                                                        <input type="hidden" name="latitude_value" value=" "/>
                                                        <input type="hidden" name="longitude_value" value=" "/>
                                                        <input type="hidden" name="location_value_04" value=" "/>
                                                        <input type="hidden" name="location_value_05" value=" "/>
                                                        <input type="hidden" name="fallback_url_04" value=" "/>
                                                        <input type="hidden" name="fallback_url_05" value=" "/>
                                                        <input type="hidden" name="start_date" value=" "/>
                                                        <input type="hidden" name="end_date" value=" "/>
                                                        <input type="hidden" name="calendar_title" value=" "/>
                                                        <input type="hidden" name="calendar_body" value=" "/>
                                                        <input type="hidden" name="phone_value_08" value=" "/>
                                                        <input type="hidden" name="message_value" value=" "/>
                                                    </c:if>
                                                </c:if>
                                                <c:if test="${!cutil:isEmptyObject(btn['action']['calendarAction'])}">
                                                    <div class="row">
                                                        <div class="th bottom-border top-border">시작일 / 종료일
                                                        </div>
                                                        <div class="td bottom-border top-border">
                                                            <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][0]}"/>
                                                            <input type="text" name="start_date" class="start_date txt_input en_font calendar right-border" value="${fn:split(btn['action']['calendarAction']['createCalendarEvent']['startTime'],'T')[0]}"/>
                                                            <input type="text" name="end_date" class="end_date txt_input en_font calendar" value="${fn:split(btn['action']['calendarAction']['createCalendarEvent']['endTime'],'T')[0]}"/>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="th bottom-border">제목</div>
                                                        <div class="td bottom-border">
                                                            <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][0]}"/>
                                                            <input type="text" name="calendar_title" class="txt_input width" value="${btn['action']['calendarAction']['createCalendarEvent']['title']}"/>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="th">내용</div>
                                                        <div class="td">
                                                            <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][0]}"/>
                                                            <input type="text" name="calendar_body" class="txt_input width" value="${btn['action']['calendarAction']['createCalendarEvent']['description']}"/>
                                                        </div>
                                                    </div>
                                                    <input type="hidden" name="copy_value" value=" "/>
                                                    <input type="hidden" name="url_value" value=" "/>
                                                    <input type="hidden" name="phone_value_03" value=" "/>
                                                    <input type="hidden" name="latitude_value" value=" "/>
                                                    <input type="hidden" name="longitude_value" value=" "/>
                                                    <input type="hidden" name="location_value_04" value=" "/>
                                                    <input type="hidden" name="fallback_url_04" value=" "/>
                                                    <input type="hidden" name="location_value_05" value=" "/>
                                                    <input type="hidden" name="fallback_url_05" value=" "/>
                                                    <input type="hidden" name="phone_value_08" value=" "/>
                                                    <input type="hidden" name="message_value" value=" "/>
                                                </c:if>
                                                <c:if test="${!cutil:isEmptyObject(btn['action']['composeAction'])}">
                                                    <div class="row">
                                                        <div class="th bottom-border top-border">전화번호</div>
                                                        <div class="td bottom-border top-border">
                                                            <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][0]}"/>
                                                            <input type="text" name="phone_value_08" class="txt_input width en_font" value="${btn['action']['composeAction']['composeTextMessage']['phoneNumber']}"/>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="th">문자메시지 내용</div>
                                                        <div class="td">
                                                            <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][0]}"/>
                                                            <input type="text" name="message_value" class="txt_input width" value="${btn['action']['composeAction']['composeTextMessage']['text']}"/>
                                                        </div>
                                                    </div>
                                                    <input type="hidden" name="copy_value" value=" "/>
                                                    <input type="hidden" name="url_value" value=" "/>
                                                    <input type="hidden" name="phone_value_03" value=" "/>
                                                    <input type="hidden" name="latitude_value" value=" "/>
                                                    <input type="hidden" name="longitude_value" value=" "/>
                                                    <input type="hidden" name="location_value_04" value=" "/>
                                                    <input type="hidden" name="fallback_url_04" value=" "/>
                                                    <input type="hidden" name="location_value_05" value=" "/>
                                                    <input type="hidden" name="fallback_url_05" value=" "/>
                                                    <input type="hidden" name="start_date" value=" "/>
                                                    <input type="hidden" name="end_date" value=" "/>
                                                    <input type="hidden" name="calendar_title" value=" "/>
                                                    <input type="hidden" name="calendar_body" value=" "/>
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="block">
                                            <div class="row">
                                                <div class="th bottom-border">버튼 액션 선택</div>
                                                <div class="td bottom-border">
                                                    <div class="select action_select" data="2">
                                                        <span id="btnHidden${btnCnt2}"></span>
                                                        <c:set var="btnCnt2" value="${btnCnt2+2}"></c:set>
                                                        <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][1]}"/>
                                                        <c:choose>
                                                            <c:when test="${!cutil:isEmptyObject(btn['action']['clipboardAction']['copyToClipboard'])}">
                                                                <div class="value" data="RBTN01" style="color: rgb(34, 34, 34);">
                                                                    복사하기
                                                                </div>
                                                            </c:when>
                                                            <c:when test="${!cutil:isEmptyObject(btn['action']['urlAction']['openUrl'])}">
                                                                <div class="value" data="RBTN02" style="color: rgb(34, 34, 34);">
                                                                    URL연결
                                                                </div>
                                                            </c:when>
                                                            <c:when test="${!cutil:isEmptyObject(btn['action']['dialerAction'])}">
                                                                <div class="value" data="RBTN03" style="color: rgb(34, 34, 34);">
                                                                    전화걸기
                                                                </div>
                                                            </c:when>
                                                            <c:when test="${!cutil:isEmptyObject(btn['action']['mapAction']['showLocation']['location']['latitude'])}">
                                                                <div class="value" data="RBTN04"
                                                                     style="color: rgb(34, 34, 34);">지도보여주기(좌표)
                                                                </div>
                                                            </c:when>
                                                            <c:when test="${!cutil:isEmptyObject(btn['action']['mapAction']['showLocation']['location']['query'])}">
                                                                <div class="value" data="RBTN05" style="color: rgb(34, 34, 34);">
                                                                    지도보여주기(쿼리)
                                                                </div>
                                                            </c:when>
                                                            <c:when test="${!cutil:isEmptyObject(btn['action']['mapAction'])}">
                                                                <c:choose>
                                                                    <c:when test="${cutil:isEmptyObject(btn['action']['mapAction']['showLocation'])}">
                                                                        <div class="value" data="RBTN06" style="color: rgb(34, 34, 34);">
                                                                            현재위치공유
                                                                        </div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:when>
                                                            <c:when test="${!cutil:isEmptyObject(btn['action']['calendarAction'])}">
                                                                <div class="value" data="RBTN07"
                                                                     style="color: rgb(34, 34, 34);">
                                                                    캘린더등록
                                                                </div>
                                                            </c:when>
                                                            <c:when test="${!cutil:isEmptyObject(btn['action']['composeAction'])}">
                                                                <div class="value" data="RBTN08"
                                                                     style="color: rgb(34, 34, 34);">
                                                                    메세지전송
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="value" data="0">
                                                                    액션선택
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <ul class="option">
                                                            <li data="0">액션선택</li>
                                                            <li data="RBTN01">복사하기</li>
                                                            <li data="RBTN02">URL연결</li>
                                                            <li data="RBTN03">전화걸기</li>
                                                            <li data="RBTN04">지도보여주기(좌표)</li>
                                                            <li data="RBTN05">지도보여주기(쿼리)</li>
                                                            <li data="RBTN06">현재위치공유</li>
                                                            <li data="RBTN07">캘린더등록</li>
                                                            <li data="RBTN08">메시지전송</li>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="th">버튼 명</div>
                                                <div class="td button-name">
                                                    <c:if test="${list[2].msg_tp eq 'DMCH211'}">
                                                    <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][1]}"/>
                                                    <c:if test="${fn:trim(btn['action']['displayText']) != ''}">
                                                        <input type="text" name="slide_rcs_btn_2" class="txt_input action_name" data="2" onkeyup="rcsCreate.buttonCount(this, 'slideSmall');" value="${btn['action']['displayText']}"/>
                                                    </c:if>
                                                    <c:if test="${fn:trim(btn['action']['displayText']) == ''}">
                                                        <input type="text" name="slide_rcs_btn_2" class="txt_input action_name" data="2" placeholder="버튼 명을 입력해주세요." onkeyup="rcsCreate.buttonCount(this,'slideSmall');">
                                                    </c:if>
                                                    <span class="text-count en_font">
                                                        <span>
                                                            <c:if test="${fn:trim(btn['action']['displayText']) != ''}">
                                                                ${fn:length(btn['action']['displayText'])}
                                                            </c:if>
                                                            <c:if test="${fn:trim(btn['action']['displayText']) == ''}">
                                                                0
                                                            </c:if>
                                                        </span>/5
                                                    </span>
                                                </div>
                                                </c:if>
                                                <c:if test="${list[2].msg_tp eq 'DMCH212'}">
                                                <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][1]}"/>
                                                <c:if test="${fn:trim(btn['action']['displayText']) != ''}">
                                                    <input type="text" name="slide_rcs_btn_2" class="txt_input action_name" data="2" onkeyup="rcsCreate.buttonCount(this, 'slideMedium');" value="${btn['action']['displayText']}"/>
                                                </c:if>
                                                <c:if test="${fn:trim(btn['action']['displayText']) == ''}">
                                                    <input type="text" name="slide_rcs_btn_2" class="txt_input action_name" data="2" placeholder="버튼 명을 입력해주세요." onkeyup="rcsCreate.buttonCount(this,'slideMedium');">
                                                </c:if>
                                                <span class="text-count en_font">
                                                    <span>
                                                        <c:if test="${fn:trim(btn['action']['displayText']) != ''}">
                                                            ${fn:length(btn['action']['displayText'])}
                                                        </c:if>
                                                        <c:if test="${fn:trim(btn['action']['displayText']) == ''}">
                                                            0
                                                        </c:if>
                                                    </span>/17
                                                </span>
                                            </div>
                                            </c:if>
                                        </div>
                                        <div class="custom_box">
                                            <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][1]}"/>
                                            <c:if test="${!cutil:isEmptyObject(btn['action']['clipboardAction']['copyToClipboard'])}">
                                                <div class="row">
                                                    <div class="th top-border">복사할 값</div>
                                                    <div class="td top-border">
                                                        <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][1]}"/>
                                                        <input type="text" name="copy_value" class="txt_input width" value="${btn['action']['clipboardAction']['copyToClipboard']['text']}"/>
                                                    </div>
                                                </div>
                                                <input type="hidden" name="url_value" value=" "/>
                                                <input type="hidden" name="phone_value_03" value=" "/>
                                                <input type="hidden" name="latitude_value" value=" "/>
                                                <input type="hidden" name="longitude_value" value=" "/>
                                                <input type="hidden" name="location_value_04" value=" "/>
                                                <input type="hidden" name="fallback_url_04" value=" "/>
                                                <input type="hidden" name="location_value_05" value=" "/>
                                                <input type="hidden" name="fallback_url_05" value=" "/>
                                                <input type="hidden" name="start_date" value=" "/>
                                                <input type="hidden" name="end_date" value=" "/>
                                                <input type="hidden" name="calendar_title" value=" "/>
                                                <input type="hidden" name="calendar_body" value=" "/>
                                                <input type="hidden" name="phone_value_08" value=" "/>
                                                <input type="hidden" name="message_value" value=" "/>
                                            </c:if>
                                            <c:if test="${!cutil:isEmptyObject(btn['action']['urlAction']['openUrl'])}">
                                                <div class="row">
                                                    <div class="th top-border">URL</div>
                                                    <div class="td top-border">
                                                        <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][1]}"/>
                                                        <input type="text" name="url_value" class="txt_input width" data="url" value="${btn['action']['urlAction']['openUrl']['url']}"/>
                                                    </div>
                                                </div>
                                                <input type="hidden" name="copy_value" value=" "/>
                                                <input type="hidden" name="phone_value_03" value=" "/>
                                                <input type="hidden" name="latitude_value" value=" "/>
                                                <input type="hidden" name="longitude_value" value=" "/>
                                                <input type="hidden" name="location_value_04" value=" "/>
                                                <input type="hidden" name="fallback_url_04" value=" "/>
                                                <input type="hidden" name="location_value_05" value=" "/>
                                                <input type="hidden" name="fallback_url_05" value=" "/>
                                                <input type="hidden" name="start_date" value=" "/>
                                                <input type="hidden" name="end_date" value=" "/>
                                                <input type="hidden" name="calendar_title" value=" "/>
                                                <input type="hidden" name="calendar_body" value=" "/>
                                                <input type="hidden" name="phone_value_08" value=" "/>
                                                <input type="hidden" name="message_value" value=" "/>
                                            </c:if>
                                            <c:if test="${!cutil:isEmptyObject(btn['action']['dialerAction'])}">
                                                <div class="row">
                                                    <div class="th top-border">전화번호</div>
                                                    <div class="td top-border">
                                                        <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][1]}"/>
                                                        <input type="text" name="phone_value_03" class="txt_input width" value="${btn['action']['dialerAction']['dialPhoneNumber']['phoneNumber']}"/>
                                                    </div>
                                                </div>
                                                <input type="hidden" name="copy_value" value=" "/>
                                                <input type="hidden" name="url_value" value=" "/>
                                                <input type="hidden" name="latitude_value" value=" "/>
                                                <input type="hidden" name="longitude_value" value=" "/>
                                                <input type="hidden" name="location_value_04" value=" "/>
                                                <input type="hidden" name="fallback_url_04" value=" "/>
                                                <input type="hidden" name="location_value_05" value=" "/>
                                                <input type="hidden" name="fallback_url_05" value=" "/>
                                                <input type="hidden" name="start_date" value=" "/>
                                                <input type="hidden" name="end_date" value=" "/>
                                                <input type="hidden" name="calendar_title" value=" "/>
                                                <input type="hidden" name="calendar_body" value=" "/>
                                                <input type="hidden" name="phone_value_08" value=" "/>
                                                <input type="hidden" name="message_value" value=" "/>
                                            </c:if>
                                            <c:if test="${!cutil:isEmptyObject(btn['action']['mapAction']['showLocation']['location']['latitude'])}">
                                                <div class="row">
                                                    <div class="th bottom-border top-border">위도/경도</div>
                                                    <div class="td bottom-border top-border">
                                                        <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][1]}"/>
                                                        <input type="text" name="latitude_value" class="txt_input en_font half right-border" value="${btn['action']['mapAction']['showLocation']['location']['latitude']}"/>
                                                        <input type="text" name="longitude_value" class="txt_input en_font half" value="${btn['action']['mapAction']['showLocation']['location']['longitude']}"/>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="th bottom-border">위치 이름</div>
                                                    <div class="td bottom-border">
                                                        <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][1]}"/>
                                                        <input type="text" name="location_value_04" class="txt_input width" value="${btn['action']['mapAction']['showLocation']['location']['label']}"/>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="th">Fallback URL</div>
                                                    <div class="td">
                                                        <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][1]}"/>
                                                        <input type="text" name="fallback_url_04" class="txt_input width en_font url_link" data="url" value="${btn['action']['mapAction']['showLocation']['fallbackUrl']}"/>
                                                    </div>
                                                </div>
                                                <input type="hidden" name="copy_value" value=" "/>
                                                <input type="hidden" name="url_value" value=" "/>
                                                <input type="hidden" name="phone_value_03" value=" "/>
                                                <input type="hidden" name="location_value_05" value=" "/>
                                                <input type="hidden" name="fallback_url_05" value=" "/>
                                                <input type="hidden" name="start_date" value=" "/>
                                                <input type="hidden" name="end_date" value=" "/>
                                                <input type="hidden" name="calendar_title" value=" "/>
                                                <input type="hidden" name="calendar_body" value=" "/>
                                                <input type="hidden" name="phone_value_08" value=" "/>
                                                <input type="hidden" name="message_value" value=" "/>
                                            </c:if>
                                            <c:if test="${!cutil:isEmptyObject(btn['action']['mapAction']['showLocation']['location']['query'])}">
                                                <div class="row">
                                                    <div class="th bottom-border top-border">위치 이름</div>
                                                    <div class="td bottom-border top-border">
                                                        <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][1]}"/>
                                                        <input type="text" name="location_value_05" class="txt_input width" value="${btn['action']['mapAction']['showLocation']['location']['query']}"/>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="th">Fallback URL</div>
                                                    <div class="td">
                                                        <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][1]}"/>
                                                        <input type="text" name="fallback_url_05" class="txt_input width en_font url_link" data="url" value="${btn['action']['mapAction']['showLocation']['fallbackUrl']}"/>
                                                    </div>
                                                </div>
                                                <input type="hidden" name="copy_value" value=" "/>
                                                <input type="hidden" name="url_value" value=" "/>
                                                <input type="hidden" name="phone_value_03" value=" "/>
                                                <input type="hidden" name="latitude_value" value=" "/>
                                                <input type="hidden" name="longitude_value" value=" "/>
                                                <input type="hidden" name="location_value_04" value=" "/>
                                                <input type="hidden" name="fallback_url_04" value=" "/>
                                                <input type="hidden" name="start_date" value=" "/>
                                                <input type="hidden" name="end_date" value=" "/>
                                                <input type="hidden" name="calendar_title" value=" "/>
                                                <input type="hidden" name="calendar_body" value=" "/>
                                                <input type="hidden" name="phone_value_08" value=" "/>
                                                <input type="hidden" name="message_value" value=" "/>
                                            </c:if>
                                            <c:if test="${cutil:isEmptyObject(btn['action']['mapAction']['showLocation'])}">
                                                <c:if test="${!cutil:isEmptyObject(btn['action']['mapAction'])}">
                                                    <input type="hidden" name="copy_value" value=" "/>
                                                    <input type="hidden" name="url_value" value=" "/>
                                                    <input type="hidden" name="phone_value_03" value=" "/>
                                                    <input type="hidden" name="latitude_value" value=" "/>
                                                    <input type="hidden" name="longitude_value" value=" "/>
                                                    <input type="hidden" name="location_value_04" value=" "/>
                                                    <input type="hidden" name="location_value_05" value=" "/>
                                                    <input type="hidden" name="fallback_url_04" value=" "/>
                                                    <input type="hidden" name="fallback_url_05" value=" "/>
                                                    <input type="hidden" name="start_date" value=" "/>
                                                    <input type="hidden" name="end_date" value=" "/>
                                                    <input type="hidden" name="calendar_title" value=" "/>
                                                    <input type="hidden" name="calendar_body" value=" "/>
                                                    <input type="hidden" name="phone_value_08" value=" "/>
                                                    <input type="hidden" name="message_value" value=" "/>
                                                </c:if>
                                            </c:if>
                                            <c:if test="${!cutil:isEmptyObject(btn['action']['calendarAction'])}">
                                                <div class="row">
                                                    <div class="th bottom-border top-border">시작일 / 종료일</div>
                                                    <div class="td bottom-border top-border">
                                                        <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][1]}"/>
                                                        <input type="text" name="start_date" class="start_date txt_input en_font calendar right-border" value="${fn:split(btn['action']['calendarAction']['createCalendarEvent']['startTime'],'T')[0]}"/>
                                                        <input type="text" name="end_date" class="end_date txt_input en_font calendar" value="${fn:split(btn['action']['calendarAction']['createCalendarEvent']['endTime'],'T')[0]}"/>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="th bottom-border">제목</div>
                                                    <div class="td bottom-border">
                                                        <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][1]}"/>
                                                        <input type="text" name="calendar_title" class="txt_input width" value="${btn['action']['calendarAction']['createCalendarEvent']['title']}"/>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="th">내용</div>
                                                    <div class="td">
                                                        <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][1]}"/>
                                                        <input type="text" name="calendar_body" class="txt_input width" value="${btn['action']['calendarAction']['createCalendarEvent']['description']}"/>
                                                    </div>
                                                </div>
                                                <input type="hidden" name="copy_value" value=" "/>
                                                <input type="hidden" name="url_value" value=" "/>
                                                <input type="hidden" name="phone_value_03" value=" "/>
                                                <input type="hidden" name="latitude_value" value=" "/>
                                                <input type="hidden" name="longitude_value" value=" "/>
                                                <input type="hidden" name="location_value_04" value=" "/>
                                                <input type="hidden" name="fallback_url_04" value=" "/>
                                                <input type="hidden" name="location_value_05" value=" "/>
                                                <input type="hidden" name="fallback_url_05" value=" "/>
                                                <input type="hidden" name="phone_value_08" value=" "/>
                                                <input type="hidden" name="message_value" value=" "/>
                                            </c:if>
                                            <c:if test="${!cutil:isEmptyObject(btn['action']['composeAction'])}">
                                                <div class="row">
                                                    <div class="th bottom-border top-border">전화번호</div>
                                                    <div class="td bottom-border top-border">
                                                        <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][1]}"/>
                                                        <input type="text" name="phone_value_08" class="txt_input width en_font" value="${btn['action']['composeAction']['composeTextMessage']['phoneNumber']}"/>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="th">문자메시지 내용</div>
                                                    <div class="td">
                                                        <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][1]}"/>
                                                        <input type="text" name="message_value" class="txt_input width" value="${btn['action']['composeAction']['composeTextMessage']['text']}"/>
                                                    </div>
                                                </div>
                                                <input type="hidden" name="copy_value" value=" "/>
                                                <input type="hidden" name="url_value" value=" "/>
                                                <input type="hidden" name="phone_value_03" value=" "/>
                                                <input type="hidden" name="latitude_value" value=" "/>
                                                <input type="hidden" name="longitude_value" value=" "/>
                                                <input type="hidden" name="location_value_04" value=" "/>
                                                <input type="hidden" name="fallback_url_04" value=" "/>
                                                <input type="hidden" name="location_value_05" value=" "/>
                                                <input type="hidden" name="fallback_url_05" value=" "/>
                                                <input type="hidden" name="start_date" value=" "/>
                                                <input type="hidden" name="end_date" value=" "/>
                                                <input type="hidden" name="calendar_title" value=" "/>
                                                <input type="hidden" name="calendar_body" value=" "/>
                                            </c:if>
                                        </div>
                                    </div>
                                    <c:set var="cnt1" value="${cnt+1}"></c:set>
                                    <c:set var="cnt2" value="${cnt+2}"></c:set>
                                    <!-- 초기 값 랜딩 -->
                                    <c:set var="btn"
                                           value="${list[2].cont_btn_json[idx]['suggestions'][0]}"/>
                                    <c:choose>
                                        <c:when test="${!cutil:isEmptyObject(btn['action']['clipboardAction']['copyToClipboard'])}">
                                            <input type="hidden" name="slide_rcs_btn_tp_1" value="RBTN01" id="slide_rcs_btn_tp_${cnt1}"/>
                                        </c:when>
                                        <c:when test="${!cutil:isEmptyObject(btn['action']['urlAction']['openUrl'])}">
                                            <input type="hidden" name="slide_rcs_btn_tp_1" value="RBTN02" id="slide_rcs_btn_tp_${cnt1}"/>
                                        </c:when>
                                        <c:when test="${!cutil:isEmptyObject(btn['action']['dialerAction'])}">
                                            <input type="hidden" name="slide_rcs_btn_tp_1" value="RBTN03" id="slide_rcs_btn_tp_${cnt1}"/>
                                        </c:when>
                                        <c:when test="${!cutil:isEmptyObject(btn['action']['mapAction']['showLocation']['location']['latitude'])}">
                                            <input type="hidden" name="slide_rcs_btn_tp_1" value="RBTN04" id="slide_rcs_btn_tp_${cnt1}"/>
                                        </c:when>
                                        <c:when test="${!cutil:isEmptyObject(btn['action']['mapAction']['showLocation']['location']['query'])}">
                                            <input type="hidden" name="slide_rcs_btn_tp_1" value="RBTN05" id="slide_rcs_btn_tp_${cnt1}"/>
                                        </c:when>
                                        <c:when test="${!cutil:isEmptyObject(btn['action']['mapAction'])}">
                                            <c:choose>
                                                <c:when test="${cutil:isEmptyObject(btn['action']['mapAction']['showLocation'])}">
                                                    <input type="hidden" name="slide_rcs_btn_tp_1" value="RBTN06" id="slide_rcs_btn_tp_${cnt1}"/>
                                                </c:when>
                                                <c:otherwise>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:when test="${!cutil:isEmptyObject(btn['action']['calendarAction'])}">
                                            <input type="hidden" name="slide_rcs_btn_tp_1" value="RBTN07" id="slide_rcs_btn_tp_${cnt1}"/>
                                        </c:when>
                                        <c:when test="${!cutil:isEmptyObject(btn['action']['composeAction'])}">
                                            <input type="hidden" name="slide_rcs_btn_tp_1" value="RBTN08" id="slide_rcs_btn_tp_${cnt1}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <input type="hidden" name="slide_rcs_btn_tp_1" value="" id="slide_rcs_btn_tp_${cnt1}"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <c:set var="btn"
                                           value="${list[2].cont_btn_json[idx]['suggestions'][1]}"></c:set>
                                    <c:choose>
                                        <c:when test="${!cutil:isEmptyObject(btn['action']['clipboardAction']['copyToClipboard'])}">
                                            <input type="hidden" name="slide_rcs_btn_tp_2" value="RBTN01" id="slide_rcs_btn_tp_${cnt2}"/>
                                        </c:when>
                                        <c:when test="${!cutil:isEmptyObject(btn['action']['urlAction']['openUrl'])}">
                                            <input type="hidden" name="slide_rcs_btn_tp_2" value="RBTN02" id="slide_rcs_btn_tp_${cnt2}"/>
                                        </c:when>
                                        <c:when test="${!cutil:isEmptyObject(btn['action']['dialerAction'])}">
                                            <input type="hidden" name="slide_rcs_btn_tp_2" value="RBTN03" id="slide_rcs_btn_tp_${cnt2}"/>
                                        </c:when>
                                        <c:when test="${!cutil:isEmptyObject(btn['action']['mapAction']['showLocation']['location']['latitude'])}">
                                            <input type="hidden" name="slide_rcs_btn_tp_2" value="RBTN04" id="slide_rcs_btn_tp_${cnt2}"/>
                                        </c:when>
                                        <c:when test="${!cutil:isEmptyObject(btn['action']['mapAction']['showLocation']['location']['query'])}">
                                            <input type="hidden" name="slide_rcs_btn_tp_2" value="RBTN05" id="slide_rcs_btn_tp_${cnt2}"/>
                                        </c:when>
                                        <c:when test="${!cutil:isEmptyObject(btn['action']['mapAction'])}">
                                            <c:choose>
                                                <c:when test="${cutil:isEmptyObject(btn['action']['mapAction']['showLocation'])}">
                                                    <input type="hidden" name="slide_rcs_btn_tp_2" value="RBTN06" id="slide_rcs_btn_tp_${cnt2}"/>
                                                </c:when>
                                                <c:otherwise>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:when test="${!cutil:isEmptyObject(btn['action']['calendarAction'])}">
                                            <input type="hidden" name="slide_rcs_btn_tp_2" value="RBTN07" id="slide_rcs_btn_tp_${cnt2}"/>
                                        </c:when>
                                        <c:when test="${!cutil:isEmptyObject(btn['action']['composeAction'])}">
                                            <input type="hidden" name="slide_rcs_btn_tp_2" value="RBTN08" id="slide_rcs_btn_tp_${cnt2}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <input type="hidden" name="slide_rcs_btn_tp_2" value="" id="slide_rcs_btn_tp_${cnt2}"/>
                                        </c:otherwise>
                                    </c:choose>
                                    <c:set var="cnt" value="${cnt2}"></c:set>
                                </div>
                                </c:forEach>
                                <div class="block" id="rejection">
                                    <div class="row">
                                        <div class="th">무료수신거부</div>
                                        <div class="td">
                                            <input type="text" name="rcs_footer"
                                                   class="txt_input rejection_num width"
                                                   value="${list[2].rcs_footer}"
                                                   oninput="rcsCreate.rejection(this);">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="viewer_area" id="">
                            <div class="rcs_inner rcs_slide">
                                <div class="slide_area">
                                    <div class="rcs_prev">
                                        <img src="${baseURL}/image/ico_rcs_prev.png" alt="">
                                    </div>
                                    <div class="rcs_next">
                                        <img src="${baseURL}/image/ico_rcs_next.png" alt="">
                                    </div>
                                    <c:if test="${list[2].msg_tp eq 'DMCH211'}">
                                    <div class="swiper-container slideSwiper small">
                                        </c:if>
                                        <c:if test="${list[2].msg_tp eq 'DMCH212'}">
                                        <div class="swiper-container slideSwiper medium">
                                            </c:if>
                                            <div class="swiper-wrapper">
                                                <c:forEach var="idx" begin="0"
                                                           end="${list[2].cardSize-1}">
                                                    <div class="swiper-slide slide${idx}">
                                                        <div class="rcs_head">[WEB발신]광고</div>
                                                        <section>
                                                            <c:set var="imgNm" value="${fn:split(list[2].img_lst,',')[idx]}"/>
                                                            <div class="img_area">
                                                                <c:if test="${fn:trim(imgNm) != '' && fn:trim(imgNm) != null}">
                                                                    <img src="${filePath}${imgNm}" onerror="this.src = '/image/bg_none.png'"/>
                                                                </c:if>
                                                            </div>
                                                            <c:set var="imgIdx" value="${idx+1}"/>
                                                            <input type="hidden" name="rcs_img_url_${imgIdx}"
                                                                    <c:if test="${fn:trim(imgNm) != '' && fn:trim(imgNm) != null}">
                                                                        value="${filePath}${imgNm}"
                                                                    </c:if>
                                                            />
                                                            <div class="txt_area">
                                                                <h3 id="titleArea${idx}">
                                                                    <c:if test="${fn:trim(list[2].slideTitle[idx]) != ''}">
                                                                        ${list[2].slideTitle[idx]}
                                                                    </c:if>
                                                                </h3>
                                                                <p id="textArea${idx}">
                                                                    <c:if test="${fn:trim(list[2].slideBody[idx]) != ''}">
                                                                        ${list[2].slideBody[idx]}
                                                                    </c:if>
                                                                </p>
                                                                <div class="rcs_btn_wrap">
                                                                    <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][0]}"/>
                                                                    <div class="rcs_btn" data="1">${btn['action']['displayText']}</div>
                                                                    <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][1]}"/>
                                                                    <div class="rcs_btn" data="2">${btn['action']['displayText']}</div>
                                                                </div>
                                                            </div>
                                                        </section>
                                                        <div class="text_count">
                                                            <c:if test="${list[2].msg_tp eq 'DMCH211'}">
                                                                <span class="num en_font">
                                                                    <span id="textByte${idx}">0</span>/30
                                                                </span>
                                                            </c:if>
                                                            <c:if test="${list[2].msg_tp eq 'DMCH212'}">
                                                                <span class="num en_font">
                                                                    <span id="textByte${idx}">0</span>/60
                                                                </span>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                            <div class="rcs_paging en_font">1/3</div>
                                            <div class="rcs_register">무료 수신거부 :
                                                <span id="rejectionArea"></span>
                                            </div>
                                            <div class="text_count">
                                                <c:if test="${list[2].msg_tp eq 'DMCH211'}">
                                                    <p>※ 본문내용 : 카드 당
                                                        <span class="en_font">30</span>
                                                        글자 이내
                                                        <br>
                                                        본문길이 : 최대 4줄
                                                        <br>
                                                        모든 카드내용의 총합 : 1300글자
                                                    </p>
                                                </c:if>
                                                <c:if test="${list[2].msg_tp eq 'DMCH212'}">
                                                    <p>※ 본문내용 : 카드 당
                                                        <span class="en_font">60</span>
                                                        글자 이내
                                                        <br>
                                                        본문길이 : 최대 4줄
                                                        <br>
                                                        모든 카드내용의 총합 : 1300글자
                                                    </p>
                                                </c:if>
                                            </div>
                                        </div>
                                        <input type="hidden" name="cont_sub_list" value=""/>
                                        <c:if test="${list[2].msg_tp eq 'DMCH211'}">
                                            <input type="hidden" name="rcs_msg_tp" value="small"/>
                                        </c:if>
                                        <c:if test="${list[2].msg_tp eq 'DMCH212'}">
                                            <input type="hidden" name="rcs_msg_tp" value="medium"/>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                        </c:if>

                    </div> <!-- RCS end-->
                </div>
            </div>
            <div class="btn_row bottom-border" id="js-btn-area">
                <input type="button" class="btn_save btn_bg btn_center btn_size1" id="previewBtn"
                       value="저장"/>
            </div>
        </div>
    </div>
    </form:form>
    </div>
    <footer class="footer">
        &copy; Milvus Corp.
    </footer>
    <!-- section 영역 끝 -->
    </div>
    <!-- 컨텐츠 영역 끝 -->
    <!-- footer 영역 시작 -->

    <!-- footer 영역 끝 -->
</section>
<!-- container 영역 끝 -->
</div>


<!-- 새 이미지 파일 업로드 팝업 영역 시작 -->
<span id="imgListHtml"></span>
<!-- 새 이미지 파일 업로드 팝업 영역 끝 -->

<form:form id="tblmisetForm" name="tblmisetForm" onsubmit="return false">
    <span id="callPopUp">
    </span>
</form:form>

<form:form id="imgSetForm" name="imgSetForm" onsubmit="return false">
<span id="imgPopUp">
    <div class="layer_pop imagePopup">
        <div class="pop_container popup_size2">
            <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
            <div class="pop_title">이미지 선택</div>
            <div class="pop_inner">
                <div class="form_search">
                    <!-- 검색 영역 시작 -->
                    <input type="text" class="calendar" name="reg_dt" id="from" placeholder="등록일 선택"/>
                    <span class="hyphen"></span>
                    <input type="text" class="calendar" name="reg_dt_range" id="to" placeholder="등록일 선택"/>
                    <div class="input_txt left-border-none">
                        <input type="text" name='img_nm' placeholder="이미지 명 입력"/>
                        <input type="button" class="btn_search" onclick="imageListPaging('1')" value="검색"/>
                    </div>
                    <!-- 검색 영역 끝 -->

                    <!-- 새 이미지 등록 버튼 -->
                    <div class="btn_new_image" onclick="imgUploadPop();">새 이미지 등록</div>
                </div>
                <form action="" id="imagePop">
                    <div class="image_container" id="bodyDom">
                    </div>
            </form>
            <div class="btn_row bottom-border left-border right-border">
                <ul class="pager" id="pagingDom">
                </ul>
                <input type="hidden" id="imgType" name="imgType" value=""/>
            </div>
            <div class="pop_error_txt blue_point_color"></div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_center imageSave" id="" value="저장"
                       onclick="imgSendSave();"/>
            </div>
        </div>
    </div>
    </div>
</span>
</form:form>

<form:form id="saveForm" name="saveForm" onsubmit="return false">
    <span id="preview"></span>
</form:form>


<script>
    let beforeSub = $('input[name="rcs_msg_tp"]:checked').val();
    let slideData = $('.slide_type').find('.value').attr('data') == undefined ? '0' : $('.slide_type').find('.value').attr('data');

    function mdmLoad() {
        //load 시 byte 계산
        let kakaoTxt = $('#kakao .textarea');
        let smsTxt = $('#sms .textarea');
        smsCreate.byteCount(kakaoTxt, 'kakao');
        smsCreate.byteCount(smsTxt, 'sms');

        const kakaoUseYn = '${list[0].list_use_yn}';
        const mailUseYn = '${list[1].list_use_yn}';
        const rcsUseYn = '${list[2].list_use_yn}';

        let minIx = "";

        // 컨텐츠 USE_YN 값에 따른 minInx 변경

        if (kakaoUseYn == "Y") {
            minInx = 0;
        } else if (kakaoUseYn == "N" && mailUseYn == "Y") {
            minInx = 1;
        } else if (kakaoUseYn == "N" && mailUseYn == "N" && rcsUseYn == "Y") {
            minInx = 2;
        }

        // load 시 컨텐츠 포맷 체크 후 주요 옵션 표시
        // 초기 랜딩시 on,off 여부
        $('.formatType').each(function () {

            let checkLength = $('.formatType').filter(':checked').length;
            let state = $(this).is(':checked');

            if (state == true) {
                let tabInx = $('.formatType').index(this);
                $('#js-smsTab li').eq(tabInx).show();

                /*if (minInx === '' && minInx >= tabInx) {
                    minInx = tabInx;
                }*/
                //minInx = 1;

                // console.log("tbaInx : " + tabInx);
                // console.log("minInx : " + minInx);

                // $('#js-smsTab li').eq(minInx).addClass('on');
                //$('#js-smsTab li').eq(1).addClass('on').siblings().removeClass('on');

                $('#js-smsTab li').eq(minInx).addClass('on').siblings().removeClass('on');
                $('.tab_contents').eq(minInx).addClass('active').siblings().removeClass('active');
            }
            if (checkLength > 0) {
                $('.no_data').hide();
                $('#js-btn-area').show();
            } else {
                $('.no_data').show();
                $('#js-btn-area').hide();
            }
        });

        rcsSlideInit();
    }

    function rcsSlideInit() {

        let rcsLength = $('.rcsContents').length;

        for (let c = 0; c < rcsLength; c++) {
            rcsObject = $('.rcsContents').eq(c)[0];
            rcsCreate.rcsContents(rcsObject, c);
        }

        let swiperEl = $('.slideSwiper').length;
        if (swiperEl > 0) {
            var mySwiper = new Swiper('.slideSwiper', {
                direction: 'horizontal',
                pagination: {
                    el: '.rcs_paging',
                    type: 'fraction',
                },
                // Navigation arrows
                navigation: {
                    nextEl: '.rcs_next',
                    prevEl: '.rcs_prev',
                },
            });
        }
    }


    $(function () {
        //컨텐츠 포맷 click event
        $('.formatType').on('click', function () {
            let checkLength = $('.formatType').filter(':checked').length;
            let state = $(this).is(':checked');
            let tabInx = $('.formatType').index(this);

            //console.log("js-smsTab : " + tabInx);
            //console.log("checkLength : " + checkLength);

            if (state == true) {
                $('#js-smsTab li').eq(tabInx).show().addClass('on').siblings().removeClass('on');
                $('.tab_contents').eq(tabInx).addClass('active').siblings().removeClass('active');
            } else {
                $('.formatType').each(function () {
                    let eachCheck = $(this).is(':checked');
                    if (eachCheck == true) {
                        let tabInx1 = $('.formatType').index(this);
                        $('#js-smsTab li').eq(tabInx1).show().addClass('on').siblings().removeClass('on');
                        $('.tab_contents').eq(tabInx1).addClass('active').siblings().removeClass('active');
                    } else {
                        let tabInx2 = $('.formatType').index(this);
                        $('#js-smsTab li').eq(tabInx2).hide().removeClass('on');
                        $('.tab_contents').eq(tabInx2).removeClass('active');
                    }
                });
            }
            if (checkLength > 0) {
                $('.no_data').hide();
                $('#js-btn-area').show();

            } else {
                $('.no_data').show();
                $('#js-btn-area').hide();
            }
        });

        // 포맷 Tab
        $('#js-smsTab > li').on('click', function () {
            let tab = $('#js-smsTab > li').index(this);
            //console.log("tab : " + tab);
            $(this).addClass('on').siblings().removeClass('on');
            $('.tab_contents').eq(tab).addClass('active').siblings().removeClass('active');
            rcsSlideInit();
        });

        //카카오 링크 버튼 생성 event
        $('.kakaoLinkBtn').on('click', function () {
            let btnState = $(this).val();
            let link = $('.kakao_btn_link');
            let name = $('.kakao_btn_name');
            let btnLink = link.val();
            let btnName = name.val();

            if (btnState == '생성') {
                if (btnName != '') {
                    if (btnLink != '') {
                        if (btnLink.substring(0, 4) == 'http') {
                            $(this).parents('#kakao').find('.viewer_area .inner').append('<a href="' + btnLink + '" class="kakao_link" target="_blank">' + btnName + '</a>');
                            //name.attr('disabled', true);
                            //link.attr('disabled', true);
                            name.attr('readonly', true);
                            link.attr('readonly', true);
                            $(this).val('삭제');
                        } else {
                            popup.popAlert('정확한 링크 URL을 입력해주세요.');
                            return false;
                        }
                    } else {
                        popup.popAlert('버튼 클릭시 이동할 URL을 입력해주세요.');
                        return false;
                    }
                } else {
                    popup.popAlert('메시지에 노출될 링크 버튼의 이름을 입력해주세요!');
                    return false;
                }
            } else {
                $(this).val('생성');
                $(this).parents('#kakao').find('.kakao_link').remove();
                link.val('');
                name.val('');
                //name.attr('disabled', false);
                //link.attr('disabled', false);
                name.attr('readonly', false);
                link.attr('readonly', false);
            }
        });

        $('.smsType').on('change', function () {
            let smsType = $(this).val();
            if (smsType != 'MMS') {
                $(this).parents('.row').siblings('.input-img').removeClass('on');
            } else {
                $(this).parents('.row').siblings('.input-img').addClass('on');
            }
        });

        // 카카오 이미지 삭제
        $('.kko_delete_img').on('click', function () {
            let imgElement = $(this).parents('.sms_form').find('.sms_img').children();
            let imgcount = imgElement.length;
            let imgUrl = $(this).next('.txt_input').val();

            if (imgcount > 0 || imgUrl != '') {
                $("#kakaoImage").val('');
                $("#kko_img_cd").val('');
                $("input[name='kko_view_img_url']").val('');
                // $("input[name='kko_img_url']").val(''); // 이미지 삭제시 링크 주소 삭제
                $("#js-kakao-img").empty();
            } else {
                return false;
            }
        });

        // sms_delete_img
        $('.sms_delete_img').on('click', function () {
            //console.log("delete sms image")
            let imgElement = $(this).parents('.sms_form').find('.sms_img').children();
            let imgcount = imgElement.length;
            let imgUrl = $(this).next('.txt_input').val();
            if (imgcount > 0 || imgUrl != '') {
                $(this).next('.txt_input').val('');
                $("#mds_img_cd").val('');
                if ($("input[name='mms_imgurl']") != '') {
                    // mms_imgurl 초기화
                    $("input[name='mms_imgurl']").val('');
                    $("input[name='mds_img_cd']").val('');
                    $("#js-sms-img").empty();
                }
                imgElement.remove();
            } else {
                return false;
            }
        });

        // 추적 링크 생성 동작
        $('.trackingLinkBtn').on('click', function () {
            let link = $(this).prev('input').val();
            let text = $(this).parents('.sms_form').find('.textarea').val();
            let type = $(this).parent().find('.txt_input').attr('id');

            if (type == 'kakaoTracking') {
                $('input[name="kko_trackinglink"]').val('')
                $('input[name="kko_trackinglink"]').val(link)
            } else if (type == 'smsTracking') {
                $('input[name="sms_trackinglink"]').val('')
                $('input[name="sms_trackinglink"]').val(link)
            }

            if (link != '') {
                if (link.substring(0, 4) == 'http') {
                    $(this).parents('.sms_form').find('.textarea').val(text + '{{' + link + '}}');
                    $(this).prev('input').val('');
                } else {
                    popup.popAlert('정확한 링크 URL을 입력해주세요.');
                }
            } else {
                popup.popAlert('추적 링크를 입력해주세요.');
            }
        });


        $(document).on('click', '#rcs .vertical_delete_img', function () {
            let deleteInx = $('#rcs .vertical_delete_img').index(this);
            let imgElement = $('.img_area').eq(deleteInx).children();
            let imgcount = imgElement.length;
            let imgUrl = $(this).next('.txt_input').val();
            $("#verticalImg").val('')


            if (imgcount > 0 || imgUrl != '') {
                $(this).next('.txt_input').val('');
                imgElement.remove();
            } else {
                return false;
            }
        });

        // RCS 선택 이미지 삭제
        $(document).on('click', '#rcs .delete_img', function () {
            let deleteInx = $('#rcs .delete_img').index(this);
            let imgElement = $('.img_area').eq(deleteInx).children();
            let imgcount = imgElement.length;
            let imgUrl = $(this).next('.txt_input').val();
            //console.log("deleteIndex : " + deleteInx)

            if (deleteInx == 0) {
                // 1번 이미지 카드 삭제
                $('input[name ="rcs_img_cd_1"]').val('');
            } else if (deleteInx == 1) {
                // 2번 이미지 카드 삭제
                $('input[name ="rcs_img_cd_2"]').val('');
            } else if (deleteInx == 2) {
                // 2번 이미지 카드 삭제
                $('input[name ="rcs_img_cd_3"]').val('');
            } else if (deleteInx == 3) {
                // 2번 이미지 카드 삭제
                $('input[name ="rcs_img_cd_4"]').val('');
            } else if (deleteInx == 4) {
                // 2번 이미지 카드 삭제
                $('input[name ="rcs_img_cd_5"]').val('');
            } else if (deleteInx == 5) {
                // 2번 이미지 카드 삭제
                $('input[name ="rcs_img_cd_6"]').val('');
            }

            if (imgcount > 0 || imgUrl != '') {
                $(this).next('.txt_input').val('');
                imgElement.remove();
            } else {
                return false;
            }
        });

        // 카카오 개인 변수 option click event
        $('#kakaoValue .option li').on('click', function () {
            let data = $(this).attr('data');
            let txt = $('.kakao_txt').val();
            if (data != 0) {
                popup.popAlert("개인화 변수 입력 후 Byte 초과시 데이터가 미반영 될 수 있습니다.");
                $('.kakao_txt').val(txt + data);
            }
        });

        // SMS 제목 개인화 변수 option click event
        $('#smsTitleVal .option li').on('click', function () {
            let data = $(this).attr('data');
            let txt = $('#sms .title').val();
            if (data != 0) {
                popup.popAlert("개인화 변수 입력 후 Byte 초과시 데이터가 미반영 될 수 있습니다.");
                $('#sms .title').val(txt + data);
            }
        });

        // SMS 개인화 변수 option click event
        $('#smsContsVal .option li').on('click', function () {
            let data = $(this).attr('data');
            let txt = $('.sms_txt').val();
            if (data != 0) {
                popup.popAlert("개인화 변수 입력 후 Byte 초과시 데이터가 미반영 될 수 있습니다.");
                $('.sms_txt').val(txt + data);
            }
        });

        //RCS 제목 개인화 변수 option click event
        $(document).on('click', '.rcsTitleVal ul li', function () {
            let type = $('.type_check input:checked').val();
            let data = $(this).attr('data');
            if (type != 'slide') {
                let txt = $('.rcsTitle').val();
                let inputTitle = $('.rcsTitle');
                if (data != 0) {
                    popup.popAlert("개인화 변수 입력 후 Byte 초과시 데이터가 미반영 될 수 있습니다.");
                    $(inputTitle).val(txt + data);
                }
            } else {
                let txt = $(this).parents('.row').siblings().find('.rcsTitle').val();
                let inputTitle = $(this).parents('.row').siblings().find('.rcsTitle');
                if (data != 0) {
                    popup.popAlert("개인화 변수 입력 후 Byte 초과시 데이터가 미반영 될 수 있습니다.");
                    $(inputTitle).val(txt + data);
                }
            }
        });

        //RCS 내용 개인화 변수 option click event
        $(document).on('click', '.rcsContsVal ul li', function () {
            let type = $('.type_check input:checked').val();
            let data = $(this).attr('data');
            if (type != 'slide') {
                let txt = $('.rcsContents').val();
                let txtContents = $('.rcsContents');
                if (data != 0) {
                    popup.popAlert("개인화 변수 입력 후 Byte 초과시 데이터가 미반영 될 수 있습니다.");
                    $(txtContents).val(txt + data);
                }
            } else {
                let txt = $(this).parents('.row').siblings().find('.rcsContents').val();
                let textContents = $(this).parents('.row').siblings().find('.rcsContents');
                if (data != 0) {
                    popup.popAlert("개인화 변수 입력 후 Byte 초과시 데이터가 미반영 될 수 있습니다.");
                    $(textContents).val(txt + data);
                }
            }
        });

        //이미지 선택 팝업 검색 영역 달력 event
        $.datepicker.setDefaults({
            dateFormat: 'yy-mm-dd'
            , monthNames: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
            , showMonthAfterYear: true
            , yearSuffix: "."
        });

        //시작일 달력
        $('#from').datepicker({
            onSelect: function (selected) {
                $("#to").datepicker("option", "minDate", selected)
            }
        });

        //종료일 달력
        $('#to').datepicker({
            onSelect: function (selected) {
                $("#from").datepicker("option", "maxDate", selected)
            }
        });

        //이미지 선택 팝업 저장 event
        $('.imageSave').on('click', function () {
            $('#imagePop').submit();
        });

        //이미지 선택 팝업 유효성 검사
        $('#imagePop').validate({
            errorPlacement: $.noop
            , invalidHandler: function (form, validator) {
                let errors = validator.numberOfInvalids();
                if (errors) {
                    $('#imagePop').siblings('.pop_error_txt').html(validator.errorList[0].message);
                }
            }
            , submitHandler: function (form) {
                let imageCheck = $('input[name="contentsImg"]:checked').length;
                let imageUrl = $('input[name="contentsImg"]:checked').val();
                let image = $('input[name="contentsImg"]:checked');
                if (imageCheck > 0) {
                    let popParents = $(form).parents('.layer_pop').attr('data');
                    $('#' + popParents).val(imageUrl);
                    $(form).parents('.layer_pop').removeClass('active');
                    smsCreate.imageCreate(popParents, image);
                    $('#imagePop').siblings('.pop_error_txt').html('');
                } else {
                    return false;
                }
            }
            , rules: {
                contentsImg: {
                    required: true
                }
            }
            , messages: {
                contentsImg: {
                    required: "이미지를 선택해주세요."
                }
            }
        });

        //발신 번호 선택 팝업 event
        $('.numberSave').on('click', function () {
            let callCheck = $('.call:checked').length;
            let callNumber = $('.call:checked').val();
            if (callCheck > 0) {
                //$('input[name="send_to"]').val(callNumber);
                $('input[name="send_to_list"]').val(callNumber);
                $('.smsNumber').parent('.column_2').removeClass('outline');
                popupClose(this);
            } else {
                return false;
            }
        });

        $('.js-ad').on('click', function () {
            adTypeCheck();
        });


        //RCS 광고/안내 체크
        /*$(document).on('change', '.radioAd', function () {
            let valueAd = $(this).val();
            if (valueAd == 'ad') {
                $('.rcs_head').html('[WEB발신]광고');
            } else {
                $('.rcs_head').html('[WEB발신]');
            }
        });*/

        // 시작일,종료일
        $(document).find(".start_date").removeClass('hasDatepicker').datepicker({
            onSelect: function (selected) {
                $('.start_date').next('.end_date').datepicker("option", "minDate", selected);
            }
        });
        $(document).find(".end_date").removeClass('hasDatepicker').datepicker({
            onSelect: function (selected) {
                $('.end_date').prev('.start_date').datepicker("option", "maxDate", selected);
            }
        });

        // 버튼 셀렉트박스
        $(document).on('click', '.action_select ul li', function () {
            let actionVal = $(this).attr('data');
            let area = $(this).parents('.row').siblings('.custom_box');
            let layout = '';
            let parentValue = $(this).parents('.action_select').attr('data');

            $(area).children().remove();

            let rcsType = $("input[name='rcs_format_type']:checked").val().trim();

            if (rcsType === "slide") {
                let dataValue = "slide_rcs_btn_" + parentValue
                let index = $('.cardOn.on').index() + 1;

                if (parentValue == 1) {
                    // 첫번째 버튼 항목 클릭
                    if (index == 1) {
                        $("#slide_rcs_btn_tp_1").val(actionVal);
                    } else if (index == 2) {
                        $("#slide_rcs_btn_tp_3").val(actionVal);
                    } else if (index == 3) {
                        $("#slide_rcs_btn_tp_5").val(actionVal);
                    } else if (index == 4) {
                        $("#slide_rcs_btn_tp_7").val(actionVal);
                    } else if (index == 5) {
                        $("#slide_rcs_btn_tp_9").val(actionVal);
                    } else if (index == 6) {
                        $("#slide_rcs_btn_tp_11").val(actionVal)
                    }
                } else if (parentValue == 2) {
                    // 두번째 버튼 항목 클릭
                    if (index == 1) {
                        $("#slide_rcs_btn_tp_2").val(actionVal);
                    } else if (index == 2) {
                        $("#slide_rcs_btn_tp_4").val(actionVal);
                    } else if (index == 3) {
                        $("#slide_rcs_btn_tp_6").val(actionVal);
                    } else if (index == 4) {
                        $("#slide_rcs_btn_tp_8").val(actionVal);
                    } else if (index == 5) {
                        $("#slide_rcs_btn_tp_10").val(actionVal);
                    } else if (index == 6) {
                        $("#slide_rcs_btn_tp_12").val(actionVal)
                    }
                }
            } else {
                let dataValue = "rcs_btn_tp_" + parentValue
                if (parentValue == 1) {
                    $("input[name='rcs_btn_tp_1']").val(actionVal);
                } else if (parentValue == 2) {
                    $("input[name='rcs_btn_tp_2']").val(actionVal);
                } else if (parentValue == 3) {
                    $("input[name='rcs_btn_tp_3']").val(actionVal);
                }
            }
            $(this).parents('.row').siblings('.row').find('.action_name').val('');
            $(this).parents('.row').siblings('.row').find('.text-count span').html('0');

            if (actionVal == "RBTN01") {

                layout += '<div class="row">' +
                    '<div class="th top-border">복사할 값</div>' +
                    '<div class="td top-border">' +
                    '<input type="text" name="copy_value" class="txt_input width" placeholder="복사할 값을 입력해주세요." />' +
                    '</div>' +
                    '</div>' +
                    '<input type ="hidden" name ="url_value" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_03" value=" "/>' +
                    '<input type ="hidden" name ="latitude_value" value=" "/>' +
                    '<input type ="hidden" name ="longitude_value" value=" "/>' +
                    '<input type ="hidden" name ="location_value_04" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_04" value=" "/>' +
                    '<input type ="hidden" name ="location_value_05" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_05" value=" "/>' +
                    '<input type ="hidden" name ="start_date" value=" "/>' +
                    '<input type ="hidden" name ="end_date" value=" "/>' +
                    '<input type ="hidden" name ="calendar_title" value=" "/>' +
                    '<input type ="hidden" name ="calendar_body" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_08" value=" "/>' +
                    '<input type ="hidden" name ="message_value" value=" "/>';
                $(area).html(layout);
            }
            if (actionVal == "RBTN02") {

                layout += '<div class="row">' +
                    '<div class="th top-border">URL</div>' +
                    '<div class="td top-border">' +
                    '<input type="text" name="url_value" class="txt_input width en_font url_link" data="url" placeholder="URL 입력 (http:// 또는 https://필수입력)" />' +
                    '</div>' +
                    '</div>' +
                    '<input type ="hidden" name="copy_value" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_03" value=" "/>' +
                    '<input type ="hidden" name ="latitude_value" value=" "/>' +
                    '<input type ="hidden" name ="longitude_value" value=" "/>' +
                    '<input type ="hidden" name ="location_value_04" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_04" value=" "/>' +
                    '<input type ="hidden" name ="location_value_05" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_05" value=" "/>' +
                    '<input type ="hidden" name ="start_date" value=" "/>' +
                    '<input type ="hidden" name ="end_date" value=" "/>' +
                    '<input type ="hidden" name ="calendar_title" value=" "/>' +
                    '<input type ="hidden" name ="calendar_body" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_08" value=" "/>' +
                    '<input type ="hidden" name ="message_value" value=" "/>';
                $(area).html(layout);
            }
            if (actionVal == "RBTN03") {

                layout += '<div class="row">' +
                    '<div class="th top-border">전화번호</div>' +
                    '<div class="td top-border">' +
                    '<input type="text" name="phone_value_03" class="txt_input width en_font" placeholder="전화번호를 입력해주세요." />' +
                    '</div>' +
                    '</div>' +
                    '<input type ="hidden" name="copy_value" value=" "/>' +
                    '<input type="hidden" name="url_value" value=" "/>' +
                    '<input type ="hidden" name ="latitude_value" value=" "/>' +
                    '<input type ="hidden" name ="longitude_value" value=" "/>' +
                    '<input type ="hidden" name ="location_value_04" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_04" value=" "/>' +
                    '<input type ="hidden" name ="location_value_05" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_05" value=" "/>' +
                    '<input type ="hidden" name ="start_date" value=" "/>' +
                    '<input type ="hidden" name ="end_date" value=" "/>' +
                    '<input type ="hidden" name ="calendar_title" value=" "/>' +
                    '<input type ="hidden" name ="calendar_body" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_08" value=" "/>' +
                    '<input type ="hidden" name ="message_value" value=" "/>';
                $(area).html(layout);
            }
            if (actionVal == "RBTN04") {

                layout += '<div class="row">' +
                    '<div class="th bottom-border top-border">위도/경도</div>' +
                    '<div class="td bottom-border top-border">' +
                    '<input type="text" name="latitude_value" class="txt_input en_font half right-border" placeholder="위도를 입력해주세요." />' +
                    '<input type="text" name="longitude_value" class="txt_input en_font half" placeholder="경도를 입력해주세요." />' +
                    '</div>' +
                    '</div>' +
                    '<div class="row">' +
                    '<div class="th bottom-border">위치 이름</div>' +
                    '<div class="td bottom-border">' +
                    '<input type="text" name="location_value_04" class="txt_input width" placeholder="위치 이름을 입력해주세요." />' +
                    '</div>' +
                    '</div>' +
                    '<div class="row">' +
                    '<div class="th">Fallback URL</div>' +
                    '<div class="td">' +
                    '<input type="text" name="fallback_url_04" class="txt_input width en_font url_link" data="url" placeholder="Fallback URL 입력 (http:// 또는 https://필수입력)" />' +
                    '</div>' +
                    '</div>' +
                    '<input type ="hidden" name="copy_value" value=" "/>' +
                    '<input type="hidden" name="url_value" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_03" value=" "/>' +
                    '<input type ="hidden" name ="location_value_05" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_05" value=" "/>' +
                    '<input type ="hidden" name ="start_date" value=" "/>' +
                    '<input type ="hidden" name ="end_date" value=" "/>' +
                    '<input type ="hidden" name ="calendar_title" value=" "/>' +
                    '<input type ="hidden" name ="calendar_body" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_08" value=" "/>' +
                    '<input type ="hidden" name ="message_value" value=" "/>';
                $(area).html(layout);
            }
            if (actionVal == "RBTN05") {

                layout += '<div class="row">' +
                    '<div class="th bottom-border top-border">위치 이름</div>' +
                    '<div class="td bottom-border top-border">' +
                    '<input type="text" name="location_value_05" class="txt_input width" placeholder="위치 이름을 입력해주세요." />' +
                    '</div>' +
                    '</div>' +
                    '<div class="row">' +
                    '<div class="th">Fallback URL</div>' +
                    '<div class="td">' +
                    '<input type="text" name="fallback_url_05" class="txt_input width en_font url_link" data="url" placeholder="Fallback URL 입력 (http:// 또는 https://필수입력)" />' +
                    '</div>' +
                    '</div>' +
                    '<input type ="hidden" name="copy_value" value=" "/>' +
                    '<input type="hidden" name="url_value" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_03" value=" "/>' +
                    '<input type ="hidden" name ="latitude_value" value=" "/>' +
                    '<input type ="hidden" name ="longitude_value" value=" "/>' +
                    '<input type ="hidden" name ="location_value_04" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_04" value=" "/>' +
                    '<input type ="hidden" name ="start_date" value=" "/>' +
                    '<input type ="hidden" name ="end_date" value=" "/>' +
                    '<input type ="hidden" name ="calendar_title" value=" "/>' +
                    '<input type ="hidden" name ="calendar_body" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_08" value=" "/>' +
                    '<input type ="hidden" name ="message_value" value=" "/>';
                $(area).html(layout);
            }
            if (actionVal == "RBTN06") {
                layout +=
                    '<input type ="hidden" name="copy_value" value=" "/>' +
                    '<input type="hidden" name="url_value" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_03" value=" "/>' +
                    '<input type ="hidden" name ="latitude_value" value=" "/>' +
                    '<input type ="hidden" name ="longitude_value" value=" "/>' +
                    '<input type ="hidden" name ="location_value_04" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_04" value=" "/>' +
                    '<input type ="hidden" name ="location_value_05" value =" "/>' +
                    '<input type ="hidden" name= "fallback_url_05" value =" "/>' +
                    '<input type ="hidden" name ="start_date" value=" "/>' +
                    '<input type ="hidden" name ="end_date" value=" "/>' +
                    '<input type ="hidden" name ="calendar_title" value=" "/>' +
                    '<input type ="hidden" name ="calendar_body" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_08" value=" "/>' +
                    '<input type ="hidden" name ="message_value" value=" "/>';
                $(area).html(layout);
            }
            if (actionVal == "RBTN07") {

                layout += '<div class="row">' +
                    '<div class="th bottom-border top-border">시작일 / 종료일</div>' +
                    '<div class="td bottom-border top-border">' +
                    '<input type="text" name="start_date" class="start_date txt_input en_font calendar right-border" placeholder="시작일" />' +
                    '<input type="text" name="end_date" class="end_date txt_input en_font calendar" placeholder="종료일" />' +
                    '</div>' +
                    '</div>' +
                    '<div class="row">' +
                    '<div class="th bottom-border">제목</div>' +
                    '<div class="td bottom-border">' +
                    '<input type="text" name="calendar_title" class="txt_input width" placeholder="제목을 입력해주세요." />' +
                    '</div>' +
                    '</div>' +
                    '<div class="row">' +
                    '<div class="th">내용</div>' +
                    '<div class="td">' +
                    '<input type="text" name="calendar_body" class="txt_input width" placeholder="내용을 입력해주세요." />' +
                    '</div>' +
                    '</div>' +
                    '<input type ="hidden" name="copy_value" value=" "/>' +
                    '<input type="hidden" name="url_value" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_03" value=" "/>' +
                    '<input type ="hidden" name ="latitude_value" value=" "/>' +
                    '<input type ="hidden" name ="longitude_value" value=" "/>' +
                    '<input type ="hidden" name ="location_value_04" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_04" value=" "/>' +
                    '<input type ="hidden" name ="location_value_05" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_05" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_08" value=" "/>' +
                    '<input type ="hidden" name ="message_value" value=" "/>';
                $(area).html(layout);
                $(document).find(".start_date").removeClass('hasDatepicker').datepicker({
                    onSelect: function (selected) {
                        $('.start_date').next('.end_date').datepicker("option", "minDate", selected);
                    }
                });
                $(document).find(".end_date").removeClass('hasDatepicker').datepicker({
                    onSelect: function (selected) {
                        $('.end_date').prev('.start_date').datepicker("option", "maxDate", selected);
                    }
                });
            }
            if (actionVal == "RBTN08") {

                layout += '<div class="row">' +
                    '<div class="th bottom-border top-border">전화번호</div>' +
                    '<div class="td bottom-border top-border">' +
                    '<input type="text" name="phone_value_08" class="txt_input width en_font" placeholder="전화번호를 입력해주세요." />' +
                    '</div>' +
                    '</div>' +
                    '<div class="row">' +
                    '<div class="th">문자메시지 내용</div>' +
                    '<div class="td">' +
                    '<input type="text" name="message_value" class="txt_input width" placeholder="문자메시지 내용을 입력해주세요." />' +
                    '</div>' +
                    '</div>' +
                    '<input type ="hidden" name="copy_value" value=" "/>' +
                    '<input type="hidden" name="url_value" value=" "/>' +
                    '<input type ="hidden" name ="phone_value_03" value=" "/>' +
                    '<input type ="hidden" name ="latitude_value" value=" "/>' +
                    '<input type ="hidden" name ="longitude_value" value=" "/>' +
                    '<input type ="hidden" name ="location_value_04" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_04" value=" "/>' +
                    '<input type ="hidden" name ="location_value_05" value=" "/>' +
                    '<input type ="hidden" name ="fallback_url_05" value=" "/>' +
                    '<input type ="hidden" name ="start_date" value=" "/>' +
                    '<input type ="hidden" name ="end_date" value=" "/>' +
                    '<input type ="hidden" name ="calendar_title" value=" "/>' +
                    '<input type ="hidden" name ="calendar_body" value=" "/>';
                $(area).html(layout);
            }
            let actionButton = $('.rcs_btn_wrap').find('div[data="' + parentValue + '"]').length;
            let typeSlide = $(this).parents('.rcs_slide_conts').length;

            if (typeSlide == 0) {
                if (actionVal != 0 && actionButton == 0) {
                    $('.rcs_btn_wrap').append('<div class="rcs_btn" data="' + parentValue + '">버튼' + parentValue + '</div>');
                }
                if (actionVal != 0 && actionButton >= 1) {
                    $('.rcs_btn_wrap').find('div[data="' + parentValue + '"]').html('버튼' + parentValue);
                }
                if (actionVal == 0) {
                    $('.rcs_btn_wrap').find('div[data="' + parentValue + '"]').remove();
                }
            } else {
                let sectionInx = $(this).parents('.rcs_slide_conts.on').index() - 1;
                let buttonLength = $('.swiper-slide').eq(sectionInx).find('.rcs_btn_wrap div[data="' + parentValue + '"]').length;

                if (actionVal != 0 && buttonLength == 0) {
                    $('.swiper-slide').eq(sectionInx).find('.rcs_btn_wrap').append('<div class="rcs_btn" data="' + parentValue + '">버튼' + parentValue + '</div>');
                }
                if (actionVal != 0 && buttonLength >= 1) {
                    $('.swiper-slide').eq(sectionInx).find('.rcs_btn_wrap div[data="' + parentValue + '"]').html('버튼' + parentValue);
                }
                if (actionVal == 0) {
                    $('.swiper-slide').eq(sectionInx).find('.rcs_btn_wrap div[data="' + parentValue + '"]').remove();
                }
            }
        });


        //슬라이드형 카드 양식 선택 event
        $(document).on('click', '.slide_type .option li', function (event) {
            event.stopPropagation();
            typeValue = $(this).attr('data');

            if (slideData != typeValue) {
                let message = "카드양식을 이동하시면 내용이 초기화됩니다. 이동하시겠습니까?";
                let html = '';
                html +=
                    '<div class="layer_pop alert active">' +
                    '<div class="pop_container popup_size3">' +
                    '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
                    '<div class="pop_title">카드 양식 변경</div>' +
                    '<div class="pop_inner">' +
                    '<div class="alert_txt">' + message + '</div>' +
                    '<div class="btn_row">' +
                    '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="rcsSlideChange(typeValue);" value="확인" />' +
                    '<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소" />' +
                    '</div>' +
                    '</div>' +
                    '</div>' +
                    '</div>';
                $('body .layer_pop.alert').remove();
                $('body').append(html);
            }
            if (slideData == typeValue) {
                $('.slide_type .option').stop().slideUp();
            }
            let dataTest = $('.slide_type .option li[data="' + slideData + '"]').text();
            $('.slide_type').find('.value').attr('data', slideData);
            $('.slide_type').find('.value').text(dataTest);
        });


        // 컨텐츠 별 옵션 체크 및 표시
        $('.kakaoOption').on('change', function () {
            smsCreate.kakaoAdCheck();
        });

        /*$('.smsOption').on('change', function () {
            smsCreate.smsAdCheck();
        });*/

        $(document).on('change', '.radioAd', function () {
            rcsCreate.rcsAdCheck();
        });

        $('.smsType').on('change', function () {
            //smsCreate.smsTypeCheck();
            let smsType = $(this).val();
            if (smsType != 'MMS') {
                $(this).parents('.row').siblings('.input-img').removeClass('on');
            } else {
                $(this).parents('.row').siblings('.input-img').addClass('on');
            }
        });


        // RCS 슬라이드형 카드 Tab click event
        $(document).on('click', '.slide_tab > div', function () {
            let nowIndex = $('.slide_tab > div').index(this);
            $(this).addClass('on').siblings().removeClass('on');
            $('.rcs_slide_conts').eq(nowIndex).addClass('on').siblings().removeClass('on');
        });

        // RCS 카드양식 변경시 초기화 알림
        $(document).on('click', 'input[name="rcs_msg_tp"]', function (event) {
            event.preventDefault();
            check = $('input[name="rcs_msg_tp"]:checked');
            let nowSub = $('input[name="rcs_msg_tp"]:checked').val();

            if (beforeSub != nowSub) {
                let message = "카드양식을 변경 할 경우 입력한 내용이 초기화됩니다. 변경 하시겠습니까?";
                let html = '';
                html +=
                    '<div class="layer_pop alert active">' +
                    '<div class="pop_container popup_size3">' +
                    '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
                    '<div class="pop_title">카드 양식 변경</div>' +
                    '<div class="pop_inner">' +
                    '<div class="alert_txt">' + message + '</div>' +
                    '<div class="btn_row">' +
                    '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="rcsLowTypeChange(check);" value="확인" />' +
                    '<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소" />' +
                    '</div>' +
                    '</div>' +
                    '</div>' +
                    '</div>';
                $('body .layer_pop.alert').remove();
                $('body').append(html);
            }
        });
        let beforeType = $('input[name="rcs_format_type"]:checked').val();

        // RCS 포맷카드 변경시 초기화 알림
        $('input[name="rcs_format_type"]').on('click', function (event) {
            event.preventDefault();
            check = $('input[name="rcs_format_type"]:checked');
            let nowVal = $('input[name="rcs_format_type"]:checked').val();

            if (beforeType != nowVal) {
                let message = "포맷카드를 변경 할 경우 입력한 내용이 초기화됩니다.<br/>변경 하시겠습니까?";
                let html = '';
                html +=
                    '<div class="layer_pop alert active">' +
                    '<div class="pop_container popup_size3">' +
                    '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
                    '<div class="pop_title">포맷 카드 변경</div>' +
                    '<div class="pop_inner">' +
                    '<div class="alert_txt">' + message + '</div>' +
                    '<div class="btn_row">' +
                    '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="rcsChangeFormat(check);" value="확인" />' +
                    '<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소" />' +
                    '</div>' +
                    '</div>' +
                    '</div>' +
                    '</div>';
                $('body .layer_pop.alert').remove();
                $('body').append(html);
            }
            beforeType = nowVal;
        });

        // RCS 포맷카드 변경시 초기화 알림
        $('input[name="rcs_format_type"]').on('click', function (event) {
            event.preventDefault();
            check = $('input[name="rcs_format_type"]:checked');
            let nowVal = $('input[name="rcs_format_type"]:checked').val();

            if (beforeType != nowVal) {
                let message = "포맷카드를 변경 할 경우 입력한 내용이 초기화됩니다.<br/>변경 하시겠습니까?";
                let html = '';
                html +=
                    '<div class="layer_pop alert active">' +
                    '<div class="pop_container popup_size3">' +
                    '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
                    '<div class="pop_title">포맷 카드 변경</div>' +
                    '<div class="pop_inner">' +
                    '<div class="alert_txt">' + message + '</div>' +
                    '<div class="btn_row">' +
                    '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="rcsChangeFormat(check);" value="확인" />' +
                    '<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소" />' +
                    '</div>' +
                    '</div>' +
                    '</div>' +
                    '</div>';
                $('body .layer_pop.alert').remove();
                $('body').append(html);
            }
            beforeType = nowVal;
        });


        $("#previewBtn").on('click', function () {

            let tamplate = $('.template_name');
            let smsFormat = $('.formatType:checked').val();
            let smsFormatLength = $('.formatType:checked').length;

            $('.create_sms').find('.outline').removeClass('outline');

            //console.log("previeBtn click");
            //console.log("tamplate : " + tamplate.val());
            //console.log("smsFormat : " + smsFormat);
            //console.log("smsFormatLength : " + smsFormatLength);

            if (tamplate.val() != '') {
                if (smsFormatLength == 1) {
                    if (smsFormat == 'kakao') {
                        let kakaoSubmit = kakaoValidate();
                        if (kakaoSubmit == true) {
                            isCheckTemplateName();
                        } else {
                            return false;
                        }
                    } //kakao end
                    if (smsFormat == 'sms') {
                        let smsSubmit = smsValidate();
                        if (smsSubmit == true) {
                            isCheckTemplateName();
                        } else {
                            return false;
                        }
                    }
                    if (smsFormat == 'rcs') {
                        let rcsSubmit = rcsValidate();
                        if (rcsSubmit == true) {
                            isCheckTemplateName();
                        } else {
                            return false;
                        }
                    }
                } else if (smsFormatLength > 1) {
                    for (let a = 0; a < smsFormatLength; a++) {

                        let checkVal = $('.formatType:checked').eq(a).val();
                        if (checkVal == 'kakao') {
                            let kakaoSubmit = kakaoValidate();
                            if (kakaoSubmit == false) {
                                return false;
                            }
                        }
                        if (checkVal == 'sms') {
                            let smsSubmit = smsValidate();
                            if (smsSubmit == false) {
                                return false;
                            }
                        }
                        if (checkVal == 'rcs') {
                            let rcsSubmit = rcsValidate();
                            if (rcsSubmit == false) {
                                return false;
                            }
                        }
                    }
                    isCheckTemplateName();
                } else {
                    popup.popAlert('컨텐츠 포맷을 선택해주세요.');
                    return false;
                }
            } else {
                tamplate.focus().addClass('outline');
                popup.popAlert('템플릿 명을 입력해주세요.');
                return false;
            }
        });
    });


    /*$('.btn_save').on('click', function () {
            let tamplate = $('.template_name');
            let smsFormat = $('.formatType:checked').val();
            let smsFormatLength = $('.formatType:checked').length;

            $('.create_sms').find('.outline').removeClass('outline');

            if (tamplate.val() != '') {
                if (smsFormatLength == 1) {
                    if (smsFormat == 'kakao') {
                        let kakaoSubmit = kakaoValidate();
                        if (kakaoSubmit == true) {
                            //$('#form').submit();
                            isCheckTemplateName();
                        } else {
                            return false;
                        }
                    } //kakao end
                    if (smsFormat == 'sms') {
                        let smsSubmit = smsValidate();
                        if (smsSubmit == true) {
                            //$('#form').submit();
                            isCheckTemplateName()
                        } else {
                            return false;
                        }
                    }
                    if (smsFormat == 'rcs') {
                        let rcsSubmit = rcsValidate();
                        if (rcsSubmit == true) {
                            //$('#form').submit();
                            isCheckTemplateName()
                        } else {
                            return false;
                        }
                    }
                } else if (smsFormatLength > 1) {
                    for (let a = 0; a < smsFormatLength; a++) {
                        let checkVal = $('.formatType:checked').eq(a).val();
                        if (checkVal == 'kakao') {
                            let kakaoSubmit = kakaoValidate();
                            if (kakaoSubmit == false) {
                                return false;
                            }
                        }
                        if (checkVal == 'sms') {
                            let smsSubmit = smsValidate();
                            if (smsSubmit == false) {
                                return false;
                            }
                        }
                        if (checkVal == 'rcs') {
                            let rcsSubmit = rcsValidate();
                            if (rcsSubmit == false) {
                                return false;
                            }
                        }
                    }
                    isCheckTemplateName()
                    // $("#form").submit()
                } else {
                    popup.popAlert('컨텐츠 포맷을 선택해주세요.');
                    return false;
                }
            } else {
                tamplate.focus().addClass('outline');
                popup.popAlert('템플릿 명을 입력해주세요.');
                return false;
            }
        });

    });
*/

    // RCS 포맷카드 변경
    function rcsChangeFormat(type) {
        let checkType = $(type)[0];
        $(type).prop('checked', true);
        $('.layer_pop').removeClass('active');
        rcsCreate.layout(checkType);
        type.value != 'slide' ? beforeSub = $('input[name="rcs_msg_tp"]:checked').val() : beforeSub = $('input[name="rcs_msg_tp"]:checked').val();
        let formatType = rcsCreate.rcsTypeCheck();
        if (formatType != 'slide') {
            rcsCreate.rcsLowTypeCheck();
        } else {
            rcsCreate.rcsSlideTypeCheck();
        }
        rcsCreate.rcsAdCheck();
    }

    // RCS 카드양식 변경
    /*function rcsLowTypeChange(type) {
        let checkType = $(type)[0];
        let radioVal = checkType.value;
        $(type).prop('checked', true);
        beforeSub = radioVal;
        $('.layer_pop').removeClass('active');
        if (radioVal == 'sms' || radioVal == 'lms') {
            rcsCreate.text(checkType);
        } else if (radioVal == 'left' || radioVal == 'right') {
            rcsCreate.horizontal(checkType);
        } else if (radioVal == 'tall' || radioVal == 'medium') {
            rcsCreate.vertical(checkType);
        }
        rcsCreate.rcsLowTypeCheck();
        rcsCreate.rcsAdCheck();
    }*/

    // RCS 카드 양식 변경
    function rcsLowTypeChange(type) {
        let checkType = $(type)[0];
        let radioVal = checkType.value;
        $(type).prop('checked', true);
        beforeSub = radioVal;
        $('.layer_pop').removeClass('active');
        let view = '';

        $('#rcs input[name="cont_sub_list"]').val('');  // RCS만 초기화
        $('textarea[name="rcs_body"]').val('');
        $('input[name="rcs_footer"]').val('');
        $('#rejectionArea').html('');
        $('.rcsContsVal[name="edmDB"] .value').attr('data', '0').text('개인화 변수').css('color', '#cccccc');
        $('.rcsContsVal[name="defaultDB"] .value').attr('data', '0').text('개인화 변수').css('color', '#cccccc');
        $('.rcsTitle[name="edmDB"] .value').attr('data', '0').text('개인화 변수').css('color', '#cccccc');
        $('.rcsTitle[name="defaultDB"] .value').attr('data', '0').text('개인화 변수').css('color', '#cccccc');

        if (radioVal == 'sms') {
            buttonReplace('text', 1, 17);
            $('#js-txt-replace').html(
                '<div class="text_type">'
                + '<div class="scroll_txt">'
                + '<p class="rcs_area" id="textArea0">내용 영역</p>'
                + '</div>'
                + '<div class="rcs_btn_wrap"></div>'
                + '</div>'
                + '<div class="rcs_register">무료 수신거부 : <span id="rejectionArea"></span></div>'
                + '<div class="text_count">'
                + '<span class="num en_font"><span id="textByte0">0</span>/100</span>'
                + '<p>※ 본문내용 : <span class="en_font">100</span>글자 이내</p>'
                + '</div>'
            );
        }
        if (radioVal == 'lms') {

            buttonReplace('text', 3, 17);
            $('#js-title-area').html(
                '<div class="row body">'
                + '<div class="th">문자 제목</div>'
                + '<div class="column_1">'
                + '<input type="text" class="title rcsTitle" name="cont_sub_list" placeholder="최대 30자 이내 입력" onkeyup="rcsCreate.rcsTitle(this, 0);">'
                + '<div class="select column_4 left-border rcsTitleVal" name="edmDB">'
                + '<div class="value" data="0">개인화 변수</div>'
                + '<ul class="option mappingLst"></ul>'
                + '</div>'
                + '<div class="select column_4 left-border rcsTitleVal" name="defaultDB">'
                + '<div class="value" data="0">개인화 변수</div>'
                + '<ul class="option" id=""></ul>'
                + '</div>'
                + '</div>'
                + '</div>'
            );
            $('#js-txt-replace').html(
                '<div class="text_type">'
                + '<h3 class="rcs_title" id="titleArea0">제목 영역</h3>'
                + '<div class="scroll_txt">'
                + '<p class="rcs_area" id="textArea0">내용 영역</p>'
                + '</div>'
                + '<div class="rcs_btn_wrap"></div>'
                + '</div>'
                + '<div class="rcs_register">무료 수신거부 : <span id="rejectionArea"></span></div>'
                + '<div class="text_count">'
                + '<span class="num en_font"><span id="textByte0">0</span>/1300</span>'
                + '<p>※ 본문내용 : <span class="en_font">1300</span>글자 이내</p>'
                + '</div>'
            );
        }
        if (radioVal == 'tall' || radioVal == 'medium') {
            $('#verticalImage').val('');
            $('input[name="verticalImg"]').val('');

            buttonReplace('vertical', 2, 17);
            view += '<div class="img_area"></div>'
                + '<div class="txt_area">'
                + '<h3 id="titleArea0">제목 영역</h3>'
                + '<p id="textArea0">내용 영역</p>'
                + '<div class="rcs_btn_wrap"></div>'
                + '</div>';

            if (radioVal == 'tall') {
                $('#js-vt-replace').html(
                    '<div class="rcs_vertical tall cf">'
                    + view
                    + '</div>'
                    + '<div class="rcs_register">무료 수신거부 : <span id="rejectionArea"></span></div>'
                    + '<div class="text_count">'
                    + '<span class="num en_font"><span id="textByte0">0</span>/1300</span>'
                    + '<p>※ 본문내용 : <span class="en_font">1300</span>글자 이내<br>본문길이 : 최대 96줄</p>'
                    + '</div>'
                );
            } else {
                $('#js-vt-replace').html(
                    '<div class="rcs_vertical medium cf">'
                    + view
                    + '</div>'
                    + '<div class="rcs_register">무료 수신거부 : <span id="rejectionArea"></span></div>'
                    + '<div class="text_count">'
                    + '<span class="num en_font"><span id="textByte0">0</span>/1300</span>'
                    + '<p>※ 본문내용 : <span class="en_font">1300</span>글자 이내<br>본문길이 : 최대 96줄</p>'
                    + '</div>'
                );
            }
        }
        mappingLst()
        adTypeCheck();
    }


    // 카카오, SMS 유효성 검사
    function kakaoValidate() {
        //let kakaoOption = $('.kakaoOption:checked').val();

        let kakaoOption = $('input[name="kko_option"]').val();
        let kakaoTitle = $('.kakaoTitle');
        let kakaoTxt = $('.kakao_txt');
        let kakaoSenderNo = $('.smsNumber_kko');

        //console.log("kakaoOption : " + kakaoOption);

        if (kakaoSenderNo.val() == '' || kakaoSenderNo.val() == null) {
            popup.popAlert("카카오톡 발신 번호를 입력해주세요");
            //kakaoSenderNo.parent('.column_2').addClass('outline');
            return false;
        }

        if (kakaoOption == 'ad') {
            if (kakaoTitle.val().indexOf('(광고)') != -1) {
                if (kakaoTxt.val() != '') {
                    let type = kakaoTypeValidate();
                    if (type == true) {
                        return true;
                    } else {
                        return false;
                    }
                } else {
                    popup.popAlert('카카오톡 메시지 내용을 입력해주세요.');
                    kakaoTxt.focus();
                    return false;
                }
            } else {
                kakaoTitle.parent('.column_1').addClass('outline');
                kakaoTitle.focus();
                popup.popAlert("광고성 메시지 제목에 '(광고)'입력이 필수 입니다.");
                return false;
            }
        }
        if (kakaoOption == 'guide') {
            if (kakaoTitle.val() != '') {
                let type = kakaoTypeValidate();
                if (type == true) {
                    return true;
                } else {
                    return false;
                }
            } else {
                kakaoTitle.parent('.column_1').addClass('outline');
                kakaoTitle.focus();
                popup.popAlert("문자 제목을 입력해주세요.");
                return false;
            }
        }
        return false;
    }

    //카카오 유효성 검사
    function kakaoTypeValidate() {

        // 카카오의 경우 이미지 필수 -> 선택 값으로 바뀜
        let kakaoByte = Number($('.kakao_byte').html());
        let kakaoImage = $('#kakaoImage');
        let kakaoTxt = $('.kakao_txt')

        // 본문 byte 체크
        if (kakaoImage.val() == '' || kakaoImage.val() == null) {
            //console.log("카카오 lms 바이트 체크")
            if (kakaoByte > 2000) {
                kakaoTxt.focus();
                popup.popAlert("본문 내용이 2000byte를 초과할 수 없습니다.");
                return false;
            }
        } else if (kakaoImage.val() != '' || kakaoImage.val() != null) {
            //console.log("카카오 바이트 체크");
            if (kakaoByte > 400) {
                kakaoTxt.focus();
                popup.popAlert("본문 내용이 400byte를 초과할 수 없습니다.");
                return false;
            }
        }
        return true;
    }

    // 문자 유효성 검사
    function smsValidate() {

        let smsOption = $('input[name="sms_option"]').val();

        //let smsOption = $('.smsOption:checked').val();
        let smsTitle = $('.smsTitle');
        let smsTxt = $('.sms_txt');
        let smsNumber = $('.smsNumber')
        let smsNumberValue = $('#sms_send_to').val().trim();

        if (smsNumberValue == '' || smsNumberValue == null) {
            smsNumber.parent('.column_2').addClass('outline');
            popup.popAlert("발신 번호를 입력해주세요.");
            return false;
        }

        if (smsOption == 'ad') {
            if (smsTitle.val().indexOf('(광고)') != -1) {
                if (smsNumber.val() != '') {
                    if (smsTxt.val() != '') {
                        let type = smsTypeValidate();
                        if (type == true) {
                            return true;
                        } else {
                            return false;
                        }
                    } else {
                        smsTxt.focus().addClass('on');
                        popup.popAlert("문자 메시지 내용을 입력해주세요.");
                        return false;
                    }
                }
            } else {
                smsTitle.parent('.column_3').addClass('outline');
                smsTitle.focus();
                popup.popAlert("광고성 메시지 제목에 '(광고)'입력이 필수 입니다.");
                return false;
            }
        }
        if (smsOption == 'guide') {
            if (smsTitle.val() != '') {
                let type = smsTypeValidate();
                if (type == true) {
                    return true;
                } else {
                    return false;
                }
            } else {
                smsTitle.parent('.column_3').addClass('outline');
                smsTitle.focus();
                popup.popAlert("문자 제목을 입력해주세요.");
                return false;
            }
        }
        return true;
    }

    // 문자 종류별 유효성 체크
    function smsTypeValidate() {
        let smsType = $('.smsType:checked').val();
        let smsByte = Number($('.sms_byte').html());
        let smsImage = $('#smsImage');
        let smsTxt = $('.sms_txt');

        if (smsType == 'LMS') {
            if (smsByte > 2000) {
                smsTxt.focus();
                popup.popAlert("LMS의 경우 본문 내용이 2000byte를 초과할 수 없습니다.");
                return false;
            }
        }

        // 우선적으로 이미지 1개만 고려, 차후 이미지 멀티 저장 기능이 추가되면 수정 필요
        // MMS 테스트
        // 이미지 1개 : 2000 Byte 까지만 허용 , 이미지 여러개 : 1000 Byte 까지 허용
        if (smsType == 'MMS') {
            if (smsImage.val() != '') {
                if (smsByte > 2000) {
                    smsTxt.focus();
                    popup.popAlert("MMS의 경우 본문 내용이 2000byte를 초과할 수 없습니다.");
                    return false;
                }
            } else {
                smsImage.parent('.td').addClass('outline');
                smsImage.focus();
                popup.popAlert("MMS를 선택하셨습니다. 이미지를 선택해 주세요.");
                return false;
            }
        }
        if (smsType == 'SMS') {
            //$("#mds_img_cd").val('');
            if (smsByte > 90) {
                smsTxt.focus();
                popup.popAlert("SMS의 경우 본문 내용이 90byte를 초과할 수 없습니다.");
                return false;
            }
        }
        return true;
    }

    // blur 유효성 체크
    $(function () {
        $('.template_name').on('blur', function () {
            if ($(this).val() != '') {
                $(this).removeClass('outline');
            }
            return false;
        });

        $('.kakaoTitle').on('blur', function () {
            let kakaoSMS = $('.kakaoOption:checked').val();
            if (kakaoSMS == 'ad') {
                if ($(this).val().indexOf('(광고)') != -1 && $(this).val() != '') {
                    $(this).parent('.column_1').removeClass('outline');
                }
            }
            if (kakaoSMS == 'guide') {
                if ($(this).val() != '') {
                    $(this).parent('.column_1').removeClass('outline');
                }
            }
            return false;
        });

        $('.smsTitle').on('blur', function () {
            let kakaoSMS = $('.smsOption:checked').val();
            if (kakaoSMS == 'ad') {
                if ($(this).val().indexOf('(광고)') != -1 && $(this).val() != '') {
                    $(this).parent('.column_3').removeClass('outline');
                }
            }
            if (kakaoSMS == 'guide') {
                if ($(this).val() != '') {
                    $(this).parent('.column_3').removeClass('outline');
                }
            }
            return false;
        });
    });

    //RCS 유효성 체크
    function rcsValidate() {
        //1. 포맷카드 형식 체크
        let format = $('.rcsType:checked').val();
        let lowerType = $('.lowType:checked').val();

        if (format == 'text') {

            let smsNumber = $('.smsNumber')
            let smsNumberValue = $("#send_text_rcs").val()

            if (smsNumberValue == '' || smsNumberValue == null) {
                smsNumber.parent('#send_text_column').addClass('outline');
                popup.popAlert("RCS 발신 번호를 입력해주세요.");
                return false;
            }

            if (lowerType == "sms") {
                if ($('.rcsContents').val() == '') {
                    popup.popAlert('RCS 내용을 입력해주세요.');
                    return false;
                } else {
                    let ad = adCheck();
                    if (ad == true) {
                        let actionBtn = actionButton();
                        if (actionBtn == true) {
                            return true;
                        }
                        return false;
                    } else {
                        return false;
                    }
                }
            } else {
                if ($('.rcsTitle').val() == '' && $('.rcsContents').val() == '') {
                    popup.popAlert('제목, 내용 중 하나 이상은 입려해야합니다.');
                    return false;
                } else {
                    let ad = adCheck();
                    if (ad == true) {
                        let actionBtn = actionButton();
                        if (actionBtn == true) {
                            return true;
                        }
                        return false;
                    } else {
                        return false;
                    }
                }
            }
        }
        if (format == 'vertical') {

            let smsNumberValue = $("#send_vertical_rcs").val()
            if (smsNumberValue == '' || smsNumberValue == null) {
                popup.popAlert("RCS 발신 번호를 입력해주세요.");
                return false;
            }

            let verticalImg = $("#verticalImg").val();
            if (verticalImg == '' || verticalImg == null) {
                popup.popAlert("RCS 세로형 이미지를 선택해주세요");
                return false;
            }

            let common = commonCheck();
            if (common == true) {
                let ad = adCheck();
                if (ad == true) {
                    let actionBtn = actionButton();
                    if (actionBtn == true) {
                        return true;
                    }
                    return false;
                }
                return false;
            } else {
                return false;
            }
        }//vertical end
        if (format == 'slide') {
            let slideLength = $('.rcs_slide_conts').length;

            let smsNumberValue = $("#send_slice_rcs").val()

            if (smsNumberValue == '' || smsNumberValue == null) {
                popup.popAlert("RCS 발신 번호를 입력해주세요.");
                return false;
            }

            let ad = adCheck();

            let slideData = $('.slide_type').find('.value').attr('data') == undefined ? '0' : $('.slide_type').find('.value').attr('data');
            let isCheckSlideType = "";

            if (slideData == 0 || slideData == 1 || slideData == 2 || slideData == 3) {
                isCheckSlideType = "small"
            } else {
                isCheckSlideType = "medium"
            }

            if (ad == true) {
                for (let s = 0; s < slideLength; s++) {
                    let section = $('.rcs_slide_conts').eq(s);
                    for (let b = 0; b < slideLength; b++) {
                        if (s == b) {
                            if (isCheckSlideType == 'medium' && s >= 1) {
                                // 첫 번째 미디엄 슬라이드 경우 고려 X
                                let nowSection = $('.rcs_slide_conts').eq(s);
                                let nowImage = nowSection.find('.rcsImage').val();
                                if (nowImage != '') {
                                    // 이미지를 선택했을때 앞에 이미지가 비어있는 경우 에러 발생
                                    for (let k = 0; k <= s; k++) {
                                        let section = $('.rcs_slide_conts').eq(k);
                                        let rcsImage = $(section).find('.rcsImage').val();
                                        //console.log("rcsImage : " + k + " 번째 : " + rcsImage);
                                        if (rcsImage == '') {
                                            popup.popAlert('카드' + (k + 1) + '에 이미지를 입력해 주세요.');
                                            return false;
                                        }
                                    }
                                }

                            }
                            if ($(section).find('.rcsTitle').val() == '' && $(section).find('.rcsContents').val() == '' && $(section).find('.rcsImage').val() == '') {
                                popup.popAlert('카드' + (s + 1) + ' 이미지, 제목, 내용 중 하나 이상은 입력해야합니다.');
                                return false;
                            }
                            if ($(section).find('.rcsImage').val() == '' && isCheckSlideType == 'small') {
                                popup.popAlert('슬라이드형 Small은 이미지가 필수 값 입니다.' + '<br/>' + '카드' + (s + 1) + '에 이미지를 등록해주세요.');
                                return false;
                            }
                            if ($(section).find('.rcsTitle').val() != '' || $(section).find('.rcsContents').val() != '' || $(section).find('.rcsImage').val() != '') {
                                let btnLength = $(section).find('.action_select').length;
                                if (btnLength > 0) {
                                    for (let i = 0; i < btnLength; i++) {
                                        let action = $(section).find('.action_select').eq(i).find('.value').attr('data');
                                        let actionInput = $(section).find('.action_select').eq(i).parents('.row').siblings('.custom_box').find('.td input').length;
                                        let buttonName = $(section).find('.action_select').eq(i).parents('.row').siblings('.row').find('.action_name').val();

                                        if (action != '0') {
                                            if (buttonName == '') {
                                                popup.popAlert('카드' + (s + 1) + ' 버튼' + (i + 1) + ' 버튼명을 입력해주세요.');
                                                return false;
                                            }
                                            if (buttonName != '') {
                                                for (let a = 0; a < actionInput; a++) {
                                                    let detailValue = $(section).find('.action_select').eq(i).parents('.row').siblings('.custom_box').find('.td input').eq(a).val();
                                                    let detailName = $(section).find('.action_select').eq(i).parents('.row').siblings('.custom_box').find('.td input').eq(a).attr('data');
                                                    if (detailValue == '') {
                                                        popup.popAlert('카드' + (s + 1) + '버튼' + (i + 1) + ' 상세 내용을 입력해주세요.');
                                                        return false;
                                                    }
                                                    if (detailValue != '' && detailName == 'url_value') {
                                                        let url = $(section).find('.action_select').eq(i).parents('.row').siblings('.custom_box').find('.td .url_link').val();
                                                        if (url.substring(0, 4) != 'http') {
                                                            popup.popAlert('url 입력 시 http:// 또는 https:// 를 필수로 입력하세요.');
                                                            return false;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                return true;
            } else {
                return false;
            }
        }//slide end
    }

    //RCS 광고 유형의 경우 무료수신거부 번호 입력 여부 체크
    function adCheck() {
        //광고 체크
        /*if ($('.radioAd:checked').val() == 'ad' && $('.rejection_num').val() == '') {
            popup.popAlert('수신거부 번호를 입력해주세요.');
            return false;
        }*/
        if ($('input[name="rcs_option"]').val() == 'ad' && $('.rejection_num').val() == '') {
            popup.popAlert('RCS 수신거부 번호를 입력해주세요.');
            return false;
        }
        return true;
    }

    // 이미지, 제목, 내용 중 입력 값이 없는 경우 체크
    function commonCheck() {
        if ($('.rcsTitle').val() == '' && $('.rcsContents').val() == '' && $('.rcsImage').val() == '') {
            popup.popAlert('이미지, 제목, 내용 중 하나 이상은 입려해야합니다.');
            return false;
        }
        return true;
    }

    // 액션 버튼 입력 값 체크
    function actionButton() {
        let btnLength = $('.action_select').length;
        for (let i = 0; i < btnLength; i++) {
            let action = $('.action_select').eq(i).find('.value').attr('data');
            let actionInput = $('.action_select').eq(i).parents('.row').siblings('.custom_box').find('.td input').length;
            let buttonName = $('.action_select').eq(i).parents('.row').siblings('.row').find('.action_name').val();

            if (action != '0') {
                if (buttonName == '') {
                    popup.popAlert('RCS 버튼 명을 입력해주세요.');
                    return false;
                }
                if (buttonName != '') {
                    for (let a = 0; a < actionInput; a++) {
                        let detailValue = $('.action_select').eq(i).parents('.row').siblings('.custom_box').find('.td input').eq(a).val();
                        let detailName = $('.action_select').eq(i).parents('.row').siblings('.custom_box').find('.td input').eq(a).attr('name');
                        if (detailValue == '') {
                            popup.popAlert('RCS 버튼 상세 내용을 입력해주세요.');
                            return false;
                        }
                        if (detailValue != '' && detailName == 'url_value') {
                            let url = $('.action_select').eq(i).parents('.row').siblings('.custom_box').find('.td input[name="url_value"]').val();
                            if (url.substring(0, 4) != 'http') {
                                popup.popAlert('url 입력 시 http:// 또는 https:// 를 필수로 입력하세요.');
                                return false;
                            }
                        }
                    }
                }
            }
        }
        return true;
    }

    // 템플릿 명 유효성 검사
    function isCheckTemplateName() {
        let cont_nm = $("input[name='cont_nm']").val();
        let seq = $("input[name='mst_seq']").val();
        var rcsType = $("input[name='rcs_format_type']:checked").val();

        var res = function (response) {
            if (response.status == "true") {
                if (rcsType === 'slide') {
                    btnHiddenRcsSlide()
                } else {
                    buttonHiddenAdd()
                }
                preview();
                //$("#form").submit();
            } else {
                // 중복된 명칭 존재
                popup.popAlert(response.message)
            }
        }
        var param = {cont_nm: cont_nm, seq: seq}

        com_ajax.ajax('post', '${baseURL}/cont/isCheckTmplateNm.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}')
    }


    // 버튼 타입 Hidden 값 추가
    function buttonHiddenAdd() {
        var rcsType = $("input[name='rcs_format_type']:checked").val();
        var checkType = $("input[name='rcs_msg_tp']:checked").val();

        var valueCheck1 = $("input[name='rcs_btn_tp_1']").val();
        var valueCheck2 = $("input[name='rcs_btn_tp_2']").val();
        var valueCheck3 = $("input[name='rcs_btn_tp_3']").val();


        var layout = '<input type="hidden" name="phone_value_03"  value=" "/>' +
            '<input type ="hidden" name="copy_value" value=" "/>' +
            '<input type="hidden" name="url_value" value=" "/>' +
            '<input type ="hidden" name ="latitude_value" value=" "/>' +
            '<input type ="hidden" name ="longitude_value" value=" "/>' +
            '<input type ="hidden" name ="location_value_04" value=" "/>' +
            '<input type ="hidden" name ="fallback_url_04" value=" "/>' +
            '<input type ="hidden" name ="location_value_05" value=" "/>' +
            '<input type ="hidden" name ="fallback_url_05" value=" "/>' +
            '<input type ="hidden" name ="start_date" value=" "/>' +
            '<input type ="hidden" name ="end_date" value=" "/>' +
            '<input type ="hidden" name ="calendar_title" value=" "/>' +
            '<input type ="hidden" name ="calendar_body" value=" "/>' +
            '<input type ="hidden" name ="phone_value_08" value=" "/>' +
            '<input type ="hidden" name ="message_value" value=" "/>';

        if (checkType == 'lms') {
            // lms 버튼인경우 Hidden 값 추가
            if (valueCheck1 == 0 || valueCheck1 == "" || valueCheck1 == null) {
                $("#btnHidden1").html(layout);
            }
            if (valueCheck2 == 0 || valueCheck2 == "" || valueCheck2 == null) {
                $("#btnHidden2").html(layout);
            }
            if (valueCheck3 == 0 || valueCheck3 == "" || valueCheck3 == null) {
                $("#btnHidden3").html(layout);
            }
        } else if (checkType != "sms" && checkType != "lms") {
            // 체크타입이 sms,lms가 아니면 버튼이 두개이다
            if (valueCheck1 == 0 || valueCheck1 == "" || valueCheck1 == null) {
                $("#btnHidden1").html(layout);
            }
            if (valueCheck2 == 0 || valueCheck2 == "" || valueCheck2 == null) {
                $("#btnHidden2").html(layout);
            }
        }
    }

    // RCS 버튼 슬라이드 Hidden 값 처리
    function btnHiddenRcsSlide() {

        let rcsType = $("input[name='rcs_format_type']").val();
        let checkType = $("input[name='rcs_msg_tp']:checked").val();

        let layout = '<input type="hidden" name="phone_value_03"  value=" "/>' +
            '<input type ="hidden" name="copy_value" value=" "/>' +
            '<input type="hidden" name="url_value" value=" "/>' +
            '<input type ="hidden" name ="latitude_value" value=" "/>' +
            '<input type ="hidden" name ="longitude_value" value=" "/>' +
            '<input type ="hidden" name ="location_value_04" value=" "/>' +
            '<input type ="hidden" name ="fallback_url_04" value=" "/>' +
            '<input type ="hidden" name ="location_value_05" value=" "/>' +
            '<input type ="hidden" name ="fallback_url_05" value=" "/>' +
            '<input type ="hidden" name ="start_date" value=" "/>' +
            '<input type ="hidden" name ="end_date" value=" "/>' +
            '<input type ="hidden" name ="calendar_title" value=" "/>' +
            '<input type ="hidden" name ="calendar_body" value=" "/>' +
            '<input type ="hidden" name ="phone_value_08" value=" "/>' +
            '<input type ="hidden" name ="message_value" value=" "/>';


        let valueArr = []
        for (let i = 0; i < 12; i++) {
            // 12번 반복문을 통해 hidden 값을 체크한다.
            let valueCheck = $("#slide_rcs_btn_tp_" + Number(i + 1)).val();
            //console.log("valueCheck " + Number(i + 1) + valueCheck);
            if ((valueCheck == 0 || valueCheck == "" || valueCheck == null) && typeof valueCheck != "undefined") {
                //console.log("value is Not exist : " + valueCheck);
                $("#btnHidden" + Number(i + 1)).html(layout);
                //console.log(("#btnHidden" + Number(i + 1)));
            }
        }
    }


    // 발신자 리스트 불러오기
    function mobileSenderPopup(nowPage, type) {

        if (typeof type == "undefined") {
            // Type이 정의 되어 있지 않다면 페이징에서 넘겨주지 않았으므로 type 변경
            type = $("#mSendType").val();
        }
        var res = function (response) {
            $("#callPopUp").html(response);
            $("#mSendType").val(type);
        };

        var param = $("#tblmisetForm").serializeArray();

        if (type === 'sms') {
            // 타입이 SMS 라면 (모바일)
            param.push({name: 'list_tp_id', value: 'CH02'});
            param.push({name: 'list_dt_id', value: 'DMTP02'});
        } else {
            // 타입이 RCS 라면
            param.push({name: 'list_tp_id', value: 'CH02'});
            param.push({name: 'list_dt_id', value: 'DMTP04'});
        }

        param.push({name: 'pageNo', value: nowPage})

        com_ajax.ajax('post', '${baseURL}/cont/senderMobileList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 발신자 번호 input 저장하기
    function mobileSendSave(type) {

        let send_to = $('input[name="callNumber"]:checked').parent('label').find('input[name="sendNumber"]').val();  // 보낼 번호
        let send_nm = $('input[name="callNumber"]:checked').parent('label').find('input[name="sendNm"]').val(); // 발신자 명
        let send_number = $('input[name="callNumber"]:checked').val();
        let send_to_type = $('#mSendType').val();
        let sender = send_nm + "(" + send_to + ")";

        if (send_to_type === 'sms') {
            $("#sms_send_to").val(send_to);
            $("#sms_send_to_num").val(send_number);
        } else if (send_to_type === 'horizonrcs') {
            $("#send_horizon_rcs").val(send_to);
            $("#horizon_send_num").val(send_number);
        } else if (send_to_type === 'textrcs') {
            $("#send_text_rcs").val(send_to);
            $("#text_send_num").val(send_number);
        } else if (send_to_type === 'verticalrcs') {
            $("#send_vertical_rcs").val(send_to);
            $("#vertical_send_num").val(send_number);
        } else if (send_to_type === 'slidercs') {
            $("#send_slice_rcs").val(send_to);
            $("#slide_send_num").val(send_number);
        }
        $('.mobilePopup').removeClass('active');
    }

    // 이미지 리스트 팝업
    function imageListPopUp(nowPage, type) {
        $('#imgType').val(type);
        imageListPaging(nowPage);
    }

    // 이미지 리스트 페이징
    function imageListPaging(nowPage) {
        let type = $('#imgType').val();

        const res = function (response) {
            $('.imagePopup').addClass('active');
            let $doc = new DOMParser().parseFromString(response, "text/html");
            $("#bodyDom").html($("#bodyDom", $doc).html());
            $("#pagingDom").html($("#pagingDom", $doc).html());
            $('#imgType').val(type);
        };

        let param = $("#imgSetForm").serializeArray();

        if (type === 'kakaoImage') {
            param.push({name: 'ch_tp', value: 'IMGTP03'});
        } else if (type === 'smsImage') {
            param.push({name: 'ch_tp', value: 'IMGTP02'});
        } else if (type === 'horizontalImage') {
            param.push({name: 'ch_tp', value: 'IMGTP04'});
        } else if (type === 'verticalImage') {
            var rcs_msg_tp = $('input[name="rcs_msg_tp"]').filter(':checked').val();
            // console.log("rcs_msg_tp : " + rcs_msg_tp);
            if (rcs_msg_tp === 'tall') {
                // 세로형 Tall
                param.push({name: 'ch_tp', value: 'IMGTP05'});
            } else if (rcs_msg_tp === 'medium') {
                // 세로형 Medium
                param.push({name: 'ch_tp', value: 'IMGTP06'});
            }
        } else if (type === 'slideRcsImage') {
            var rcs_msg_tp = $('input[name="rcs_msg_tp"]').val();
            //console.log("rcs_msg_tp :" + rcs_msg_tp);
            if (rcs_msg_tp === 'small') {
                param.push({name: 'ch_tp', value: 'IMGTP07'})
            } else if (rcs_msg_tp === 'medium') {
                param.push({name: 'ch_tp', value: 'IMGTP08'});
            }
        }
        param.push({name: 'pageNo', value: nowPage});
        com_ajax.ajax('post', '${baseURL}/cont/mobileImgList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 이미지 리스트 Input 저장하기
    function imgSendSave(seq) {

        let imgType = $("#imgType").val();  // 이미지 파일 타입
        let imgLength = $('input[name="contentsImg"]:checked').length;
        let imgCheck = $('input[name="contentsImg"]:checked').val() // 이미지 파일 seq
        let ImgNm = $('input[name="contentsImg"]:checked').parent('label').find('input[name="ImgNm"]').val();    // 이미지 파일 본명
        let imgUrl = $('input[name="contentsImg"]:checked').parent('label').find('input[name="imgurl"]').val(); // 이미지 파일 url

        if (imgLength > 0) {
            let popParents = $(form).parents('.layer_pop').attr('data');
            $('#' + popParents).val(imgUrl);
            $(form).parents('.layer_pop').removeClass('active');
            imageCreate(imgType, imgUrl, ImgNm, imgCheck);
            $('#imagePop').siblings('.pop_error_txt').html('');
            $('.imagePopup').removeClass('active');
        } else {
            return false;
        }
    }

    // 이미지 생성 하기
    function imageCreate(type, imageUrl, ImgNm, imgCheck) {
        let imageType = imageUrl
        let kakaoImgLink = $('.kakaoImgLink').val();

        if (imageType != '') {
            if (type == 'kakaoImage') {
                if (kakaoImgLink == '') {
                    $("input[name='kko_view_img_url']").val(imageUrl);
                    $("#kakaoImage").val(ImgNm);
                    $('input[name="kko_img_cd"]').val(imgCheck);
                    $('#kakaoImage').parent('.td').removeClass('outline');
                    //$('#kakao').find('.sms_img').html('<a href="' + imageType + '" target="_blank">' + '<img src="' + imageType + '" onerror="this.src=\'/image/bg_none_wide.png\'"/>' + '</a>');
                    $('#js-kakao-img').html('<a href="' + imageType + '" target="_blank">' + '<img src="' + imageType + '" onerror="this.src=\'/image/bg_none.png\'" />' + '</a>');
                } else {
                    $("input[name='kko_view_img_url']").val(imageUrl);
                    $("#kakaoImage").val(ImgNm);
                    $('input[name="kko_img_cd"]').val(imgCheck);
                    $('#kakaoImage').parent('.td').removeClass('outline');
                    //$('#kakao').find('.sms_img').html('<a href="' + kakaoImgLink + '" target="_blank">' + '<img src="' + imageType + '" onerror="this.src=\'/image/bg_none_wide.png\'"/>' + '</a>');
                    $('#js-kakao-img').html('<a href="' + kakaoImgLink + '" target="_blank">' + '<img src="' + imageType + '" onerror="this.src=\'/image/bg_none.png\'" />' + '</a>');
                }
            } else if (type == 'smsImage') {
                $("#smsImage").val(ImgNm);
                $('input[name="mds_img_cd"]').val(imgCheck);
                $('#smsImage').parent('.td').removeClass('outline');
                //$('#sms').find('.sms_img').html('<img src="' + imageType + '" onerror="this.src=\'/image/bg_none_wide.png\'"/>');
                $('#js-sms-img').html('<img src="' + imageType + '" onerror="this.src=\'/image/bg_none.png\'"/>');
                $('input[name="mms_imgurl"]').val(imageType);
            } else if (type == 'horizontalImage') {
                $("#horizontalImage").val(ImgNm);
                $("#horizonImg").val(imgCheck);
                $('#horizontalImage').parent('.td').removeClass('outline');
                $('.horizontal').find('.img_area').html('<img src="' + imageType + '" onerror="this.src=\'/image/bg_none_wide.png\'"/>');
            } else if (type == 'verticalImage') {
                $('input[name="rcs_img_url_1"]').val(imageUrl);
                $("#verticalImage").val(ImgNm);
                $("#verticalImg").val(imgCheck);
                $('#verticalImage').parent('.td').removeClass('outline');
                $('#vertical').find('.img_area').html('<img src="' + imageType + '" onerror="this.src=\'/image/bg_none_wide.png\'"/>');
            } else {
                let index = $('.cardOn.on').index();
                $('.swiper-slide').eq(index).find('.img_area').html('<img src="' + imageType + '" onerror="this.src=\'/image/bg_none_wide.png\'"/>');
                if (index == 0) {
                    $("#slide0").val(ImgNm);
                    $('input[name="rcs_img_url_1"]').val(imageUrl);
                    $('input[name="rcs_img_cd_1"]').val(imgCheck);
                } else if (index == 1) {
                    $("#slide1").val(ImgNm);
                    $('input[name="rcs_img_url_2"]').val(imageUrl);
                    $('input[name="rcs_img_cd_2"]').val(imgCheck);
                } else if (index == 2) {
                    $("#slide2").val(ImgNm);
                    $('input[name="rcs_img_url_3"]').val(imageUrl);
                    $('input[name="rcs_img_cd_3"]').val(imgCheck);
                } else if (index == 3) {
                    $("#slide3").val(ImgNm);
                    $('input[name="rcs_img_url_4"]').val(imageUrl);
                    $('input[name="rcs_img_cd_4"]').val(imgCheck);
                } else if (index == 4) {
                    $("#slide4").val(ImgNm);
                    $('input[name="rcs_img_url_5"]').val(imageUrl);
                    $('input[name="rcs_img_cd_5"]').val(imgCheck);
                } else if (index == 5) {
                    $("#slide5").val(ImgNm);
                    $('input[name="rcs_img_url_6"]').val(imageUrl);
                    $('input[name="rcs_img_cd_6"]').val(imgCheck);
                }
            }
        } else {
            if (type == 'kakaoImage') {
                $('#kakao').find('.sms_img').children().remove();
            } else if (type == 'smsImage') {
                $('#sms').find('.sms_img').children().remove();
            }
        }
    }


    // RCS 카드양식 변경
    function rcsLowTypeChange(type) {
        let checkType = $(type)[0];
        let radioVal = checkType.value;
        $(type).prop('checked', true);
        beforeSub = radioVal;
        $('.layer_pop').removeClass('active');
        let view = '';

        $('input[name="cont_sub_list"]').val('');
        $('textarea[name="rcs_body"]').val('');
        $('input[name="rcs_footer"]').val('');
        $('#rejectionArea').html('');
        $('.rcsContsVal[name="edmDB"] .value').attr('data', '0').text('개인화 변수').css('color', '#cccccc');
        $('.rcsContsVal[name="defaultDB"] .value').attr('data', '0').text('개인화 변수').css('color', '#cccccc');
        $('.rcsTitle[name="edmDB"] .value').attr('data', '0').text('개인화 변수').css('color', '#cccccc');
        $('.rcsTitle[name="defaultDB"] .value').attr('data', '0').text('개인화 변수').css('color', '#cccccc');

        if (radioVal == 'sms') {
            buttonReplace('text', 1, 17);
            $('#js-txt-replace').html(
                '<div class="text_type">'
                + '<div class="scroll_txt">'
                + '<p class="rcs_area" id="textArea0">내용 영역</p>'
                + '</div>'
                + '<div class="rcs_btn_wrap"></div>'
                + '</div>'
                + '<div class="rcs_register">무료 수신거부 : <span id="rejectionArea"></span></div>'
                + '<div class="text_count">'
                + '<span class="num en_font"><span id="textByte0">0</span>/100</span>'
                + '<p>※ 본문내용 : <span class="en_font">100</span>글자 이내</p>'
                + '</div>'
            );
        }
        if (radioVal == 'lms') {
            buttonReplace('text', 3, 17);
            $('#js-title-area').html(
                '<div class="row body">'
                + '<div class="th">문자 제목</div>'
                + '<div class="column_1">'
                + '<input type="text" class="title rcsTitle" name="cont_sub_list" placeholder="최대 30자 이내 입력" onkeyup="rcsCreate.rcsTitle(this, 0);">'
                + '<div class="select column_4 left-border rcsTitleVal" name="edmDB">'
                + '<div class="value" data="0">개인화 변수</div>'
                + '<ul class="option mappingLst"></ul>'
                + '</div>'
                + '<div class="select column_4 left-border rcsTitleVal" name="defaultDB">'
                + '<div class="value" data="0">개인화 변수</div>'
                + '<ul class="option mappingLst" id=""></ul>'
                + '</div>'
                + '</div>'
                + '</div>'
            );
            $('#js-txt-replace').html(
                '<div class="text_type">'
                + '<h3 class="rcs_title" id="titleArea0">제목 영역</h3>'
                + '<div class="scroll_txt">'
                + '<p class="rcs_area" id="textArea0">내용 영역</p>'
                + '</div>'
                + '<div class="rcs_btn_wrap"></div>'
                + '</div>'
                + '<div class="rcs_register">무료 수신거부 : <span id="rejectionArea"></span></div>'
                + '<div class="text_count">'
                + '<span class="num en_font"><span id="textByte0">0</span>/1300</span>'
                + '<p>※ 본문내용 : <span class="en_font">1300</span>글자 이내</p>'
                + '</div>'
            );
        }
        if (radioVal == 'tall' || radioVal == 'medium') {
            $('#verticalImage').val('');
            $('input[name="verticalImg"]').val('');

            buttonReplace('vertical', 2, 17);
            view += '<div class="img_area"></div>'
                + '<div class="txt_area">'
                + '<h3 id="titleArea0">제목 영역</h3>'
                + '<p id="textArea0">내용 영역</p>'
                + '<div class="rcs_btn_wrap"></div>'
                + '</div>';

            if (radioVal == 'tall') {
                $('#js-vt-replace').html(
                    '<div class="rcs_vertical tall cf">'
                    + view
                    + '</div>'
                    + '<div class="rcs_register">무료 수신거부 : <span id="rejectionArea"></span></div>'
                    + '<div class="text_count">'
                    + '<span class="num en_font"><span id="textByte0">0</span>/1300</span>'
                    + '<p>※ 본문내용 : <span class="en_font">1300</span>글자 이내<br>본문길이 : 최대 96줄</p>'
                    + '</div>'
                );
            } else {
                $('#js-vt-replace').html(
                    '<div class="rcs_vertical medium cf">'
                    + view
                    + '</div>'
                    + '<div class="rcs_register">무료 수신거부 : <span id="rejectionArea"></span></div>'
                    + '<div class="text_count">'
                    + '<span class="num en_font"><span id="textByte0">0</span>/1300</span>'
                    + '<p>※ 본문내용 : <span class="en_font">1300</span>글자 이내<br>본문길이 : 최대 96줄</p>'
                    + '</div>'
                );
            }
        }
        mappingLst();
        adTypeCheck();
    }

    //RCS 버튼 Replace
    function buttonReplace(type, length, textCount) {
        let html = '';

        for (let a = 0; a < length; a++) {
            html += '<div class="block">'
                + '<div class="row">'
                + '<div class="th bottom-border">버튼 액션 선택</div>'
                + '<div class="td bottom-border">'
                + '<div class="select action_select" data="' + (a + 1) + '">'
                + '<div class="value" data="0">액션선택</div>'
                + '<ul class="option">'
                + '<li data="0">액션선택</li>'
                + '<li data="RBTN01">복사하기</li>'
                + '<li data="RBTN02">URL연결</li>'
                + '<li data="RBTN03">전화걸기</li>'
                + '<li data="RBTN04">지보보여주기(좌표)</li>'
                + '<li data="RBTN05">지도보여주기(쿼리)</li>'
                + '<li data="RBTN06">현재위치공유</li>'
                + '<li data="RBTN07">캘린더등록</li>'
                + '<li data="RBTN08">메시지전송</li>'
                + '</ul>'
                + '</div>'
                + '</div>'
                + '</div>'
                + '<div class="row">'
                + '<div class="th">버튼 명</div>'
                + '<div class="td button-name">'
                + '<input type="text" name="rcs_btn_' + Number(a + 1) + '" class="txt_input action_name" data="' + Number(a + 1) + '"'
                + 'placeholder="버튼 명을 입력해주세요." onkeyup="rcsCreate.buttonCount(this,' + '\'' + type + '\'' + ');">'
                + '<span class="text-count en_font"><span>0</span>/' + textCount + '</span>'
                + '</div>'
                + '</div>'
                + '<div class="custom_box"></div>'
                + '</div>';
        }
        $('#btn-action-area').html(html);
    }

    // RCS 슬라이드형 카드 양식 변경
    function rcsSlideChange(type) {

        $('.layer_pop').removeClass('active');
        slideData = type;
        let layout = slideLayout(type);
        $('#js-rcs-area').html(layout);

        if (typeValue <= 3) {
            $('input[name="rcs_msg_tp"]').val("small");
        } else {
            $('input[name="rcs_msg_tp"]').val("medium");
        }

        mappingLst();
        adTypeCheck();

        new Swiper('.slideSwiper', {
            direction: 'horizontal',
            pagination: {
                el: '.rcs_paging',
                type: 'fraction',
            },
            // Navigation arrows
            navigation: {
                nextEl: '.rcs_next',
                prevEl: '.rcs_prev',
            },
        });
    }

    // 광고/안내 체크
    function adTypeCheck() {
        let adType = $('.js-ad').filter(':checked').val();
        let kakao = $('input[name="kko_option"]');
        let sms = $('input[name="sms_option"]');
        let rcs = $('input[name="rcs_option"]');

        if (adType == 'ad') {
            kakao.val('ad');
            sms.val('ad');
            rcs.val('ad');
            $('.rcs_head').html('[WEB발신]광고');
        } else {
            kakao.val('guide');
            sms.val('guide');
            rcs.val('guide');
            $('.rcs_head').html('[WEB발신]');
        }
    }

    // 이미지 Upload popup
    function imgUploadPop() {
        var html = '<div class="layer_pop uploadPopup active" style="z-index:960;">' +
            '<div class="pop_container popup_size1">' +
            '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />' +
            '<div class="pop_title">새 이미지 파일 업로드</div>' +
            '<div class="pop_inner">' +
            '<table class="pop_table_type1">' +
            '<colgroup>' +
            '<col width="103" />' +
            '<col width="*" />' +
            '</colgroup>' +
            '<tbody>' +
            '<tr>' +
            '<th>채널</th>' +
            '<td>' +
            '<label class="custom_radio">모바일<input name="ch_tp" type="radio" value="IMGTP02" checked><span></span></label>' +
            '<label class="custom_radio">카카오<input name="ch_tp" type="radio" value="IMGTP03"><span></span></label>' +
            '<label class="custom_radio">RCS<input name="ch_tp" type="radio" value="RCS"><span></span></label>' +
            '</td>' +
            '</tr>' +
            '<tr class="rcsImgForm rcs_option">' +
            '<th>양식</th>' +
            '<td>' +
            '<div class="select style1 rcs_select">' +
            '<div class="value" data="">RCS 양식 선택</div>' +
            '<ul class="option">' +
            '<li data="0">RCS 양식 선택</li>' +
            '<li data="IMGTP05">세로형 / Tall</li>' +
            '<li data="IMGTP06">세로형 / Medium</li>' +
            '<li data="IMGTP07">슬라이드형 / Small</li>' +
            '<li data="IMGTP08">슬라이드형 / Medium</li>' +
            '</ul>' +
            '</div>' +
            '</td>' +
            '</tr>' +
            '<tr>' +
            '<th>이미지 명</th>' +
            '<td>' +
            '<input type="text" placeholder="이미지 명을 입력해주세요." id="img_nmCk" name="img_nm" class="input_type1" />' +
            '</td>' +
            '</tr>' +
            '<tr>' +
            '<th>이미지 파일</th>' +
            '<td>' +
            '<input type="text" id="fileName" name="fileName" class="input_file" placeholder="이미지 파일을 선택해주세요." readonly />' +
            '<span class="btn_file">파일 선택<input type="file" class="file" id="file"/></span>' +
            '</td>' +
            '</tr>' +
            '</tbody>' +
            '</table>' +
            '<ul class="guide_txt">' +
            '<li>※ 세로형 : ① Tall : 568 X 528 (1MB 이하), ② Medium : 568 X 336 (1MB 이하)</li>' +
            '<li>※ 슬라이드형 : ① Small : 360 X 336, ② Medium : 696 X 504, 최대 사이즈 360 X 1569 , 1MB 이하</li>' +
            '</ul>' +
            '<div class="left pop_error_txt other_guide">※ 모바일 : Jpg, png(200KB 이하), 이메일 : jpg, png, gif</div>' +
            '<div class="right pop_error_txt blue_point_color"></div>' +
            '<div class="img_viewer noImg"></div>' +
            '<div class="btn_row">' +
            '<input type="button" class="btn_bg btn_size2 btn_center uploadSave" onclick="saveContentImg();" value="저장" />' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';
        $("#imgListHtml").html(html);
    }

    // 이미지 컨텐츠 저장하기
    function saveContentImg() {
        var imgNm = $("#img_nmCk").val();
        if (imgNm == "" || imgNm == null) {
            popup.popAlert("이미지명을 입력해주세요.");
            return false;
        }
        if ($("#file").val() == "" || $("#file").val() == null) {
            popup.popAlert("업로드된 파일이 없습니다.");
            return false;
        }

        var res = function (response) {
            //TO-DO
            //리스트 새로 불러오기
            if (response.imgCheck == 0) {
                popup.popAlert(response.imgCheckErr);
                return false;
            }
            popup.popAlert(response.message);
            $('.uploadPopup').removeClass('active');
            $("#form")[0].reset();
            $("#file").val();
            $(".img_viewer").children().remove();
            $(".img_view").addClass('noImg');
            imageListPaging('1');
        };

        var data = new FormData();
        data.append("file", $("#file")[0].files[0]);
        var ch_tp = $("input[name=ch_tp]:checked").val();
        if (ch_tp == 'RCS') {
            data.append("ch_tp", $('.rcs_select .value').attr('data'));
        } else {
            data.append("ch_tp", ch_tp);
        }
        data.append("img_nm", imgNm);

        com_ajax.ajax_file('${baseURL}/cont/contentUpload.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 프리뷰 서비스 랜딩 하기
    function preview() {
        const res = function (response) {
            const $doc = new DOMParser().parseFromString(response, "text/html");
            let html = $("#js-area-popup", $doc).html();
            let dynamic = $("#preview").html(html);
            $("#smsContentsPopup").addClass("active");
            previewSlideLoad();
        }
        let data = $("#form").serializeArray();
        com_ajax.ajax('post', '${baseURL}/cont/preview.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}')
    }

    // 프리뷰 슬라이드 랜딩 하기
    function previewSlideLoad() {

        let swiperEl = $('.previewSlide').length;
        if (swiperEl > 0) {
            var mySwiper = new Swiper('.previewSlide', {
                direction: 'horizontal',
                pagination: {
                    el: '.rcs_paging',
                    type: 'fraction',
                },
                // Navigation arrows
                navigation: {
                    nextEl: '.rcs_next',
                    prevEl: '.rcs_prev',
                },
            });
        }
    }

    // 프리뷰에서 저장 버튼 누르기
    $(document).on('click', '#saveBtn', function () {
        $("#form").submit();
    });

</script>



