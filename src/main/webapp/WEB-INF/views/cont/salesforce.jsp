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
<!-- salesforce js -->
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/require.js/2.3.6/require.min.js"></script>
<script type="text/javascript" src="/js/postmonger.js"></script>
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
                    <li>모바일 컨텐츠 생성</li>
                </ul>
                <!-- tooltip box 영역 끝 -->
            </div>
            <div class="right">
                <span class="btn_sm_line" style="width: 75px; margin: 7px 7px 0 0;" id="contLoad">불러오기</span>
            </div>
        </div>
        <!-- row 영역 끝 -->
        <!-- section 영역 시작 -->
        <div class="section">
            <form:form id="form" action="#" method="post">
            <input type="hidden" id="seq" name="mst_seq" value=""/>
            <input type="hidden" id="usr_grp_cd" name="usr_grp_cd"/>
            <input type="hidden" id="cont_grp_cd" name="cont_grp_cd"/>
            <div class="create_sms cf">
                <div class="row head bottom-border">
                    <div class="th">프로그램 명</div>
                    <div class="td right-border">
                        <input type="text" name="pro_nm" class="txt_input " placeholder="프로그램 명을 입력하세요.">
                    </div>
                    <div class="th">캠페인 명</div>
                    <div class="td right-border">
                        <input type="text" class="txt_input template_name" name="cont_nm" placeholder="템플릿 명을 입력하세요."/>
                    </div>
                    <div class="th">팀 명</div>
                    <div class="td right-border" style="width: 190px;">
                        <div class="select">
                            <!-- selected value -->
                            <div class="value" name="team_cd" data="">팀명</div>
                            <ul class="option">
                                <c:forEach var="team" items="${teamLst}">
                                    <li data="${team.cd_val}">${team.cd_desc}</li>
                                </c:forEach>
                            </ul>
                        </div>
                    </div>

                    <div class="th">컨텐츠 포맷</div>
                    <div class="td flex_row">
                        <div class="sms_option cf">
                            <label class="custom_check2 kakao">
                                <c:if test="${kakaoCnt ne 0}">
                                    <input name="formatType" type="checkbox" value="kakao" class="formatType"/>
                                </c:if>
                                <c:if test="${kakaoCnt eq 0}">
                                    <input name="formatType" type="checkbox" value="kakao" class="formatType" disabled/>
                                </c:if>
                                <span>카카오톡</span>
                            </label>
                            <label class="custom_check2 sms">
                                <c:if test="${smsCnt ne 0}">
                                    <input name="formatType" type="checkbox" value="sms" class="formatType"/>
                                </c:if>
                                <c:if test="${smsCnt eq 0}">
                                    <input name="formatType" type="checkbox" value="sms" class="formatType" disabled/>
                                </c:if>
                                <span>문자</span>
                            </label>
                            <label class="custom_check2 rcs">
                                <c:if test="${rcsCnt ne 0}">
                                    <input name="formatType" type="checkbox" value="rcs" class="formatType"/>
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
                                    <input type="radio" name="commonType" class="js-ad" value="ad" checked/>
                                    <span>광고</span>
                                </label>
                                <label class="block_radio">
                                    <input type="radio" name="commonType" class="js-ad" value="guide"/>
                                    <span>안내</span>
                                </label>
                                <input type="hidden" name="kko_option" class="kakaoOption" value="ad"/>
                                <input type="hidden" name="sms_option" class="smsOption" value="ad"/>
                                <input type="hidden" name="rcs_option" class="radioAd" value="ad"/>
                            </div>
                        </div>
                        <div class="th left-border">수신 번호</div>
                        <div class="inner_option area2">
                            <div class="td cf" style="width: 100%;">
                                <div class="select" id="recv_phone_to" name="edmDB">
                                    <!-- selected value -->
                                    <div class="value" data="0">개인화 변수</div>
                                    <ul class="option mappingLst"></ul>
                                </div>
                                <input type="hidden" id="recv_phone" name="from_to"/>
                            </div>
                        </div>
                    </div>
                </div><!-- //row end -->
                <!-- no-data -->
                <div class="no_data" id="sms_no_data">
                    컨텐츠 포맷을 선택해 주세요.
                </div>
                <!-- Tab menu -->
                <ul class="tab_row" id="js-smsTab">
                    <li><span>카카오톡</span></li>
                    <li><span>문자</span></li>
                    <li><span>RCS</span></li>
                </ul>
                <div class="tab_contents">
                    <div class="sms_form right-border cover cf" id="kakao">
                        <input type="hidden" name="list_seq" value=""/>
                        <h2>카카오톡</h2>
                        <div class="flex_box">
                            <div class="left_area">
                                <div class="row body">
                                    <div class="th">문자 제목</div>
                                    <div class="column_1">
                                        <input type="text" class="title kakaoTitle" name="cont_sub_list"
                                               value="(광고)"
                                               placeholder="문자 제목을 입력하세요."/>
                                        <span class="ex_txt">※ 실제 발송에는 반영되지 않습니다.</span>
                                    </div>
                                </div>
                                <div class="row body">
                                    <div class="th">타입</div>
                                    <div class="column_2">
                                        <label class="type_check"><input type="radio" name="kko_format_type"
                                                                         class="kkoType"
                                                                         value="kko_ft"
                                                                         checked/><span>친구톡</span></label>
                                        <label class="type_check"><input type="radio" name="kko_format_type"
                                                                         class="kkoType"
                                                                         value="kko_at"/><span>알림톡</span></label>
                                    </div>
                                </div>
                                <div class="row body">
                                    <div class="th">발신 프로필</div>
                                    <div class="column_1">
                                        <input type="text" class="sms_number smsNumber smsNumber_kko" id="send_to" placeholder ="발신 프로필을 선택해주세요"
                                               readonly/>
                                        <input type="hidden" name="send_key" id="send_key"/>
                                        <input type="hidden" name="send_to_list" id="kakao_send_to_num" />
                                        <span class="btn_sm_line" onclick="mobileSenderPopup('1','kko')">변경</span>
                                    </div>
                                </div>
                                <div class="input_area kko_area" id="kko_ft">
                                    <div class="block">
                                        <div class="row">
                                            <div class="th">이미지 선택</div>
                                            <div class="td">
                                                <div class="delete_img" data="kakao"><img
                                                        src="${baseURL}/image/btn_delete1.png" alt="삭제">
                                                </div>
                                                <input type="text" class="txt_input en_font" name="" id="kakaoImage"
                                                       placeholder="이미지를 선택해 주세요." readonly/>
                                                <span class="btn_sm_line" data="kakaoImage"
                                                      onclick="imageListPopUp('1','kakaoImage')">선택</span>
                                                <input type="hidden" id="kakao_img_cd" name="kko_img_cd" value="">
                                                <!--임시 히든값 -->
                                                <input type="hidden" id="kko_view_img_url" name="kko_view_img_url"
                                                       value=""> <!-- 프리뷰를 위한 이미지 URL -->
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="th top-border">이미지 링크 주소</div>
                                            <div class="td top-border">
                                                <input type="text" class="txt_input en_font width kakaoImgLink"
                                                       name="kko_img_url" onblur="smsCreate.imageLinkAdd(this);"
                                                       placeholder="URL 입력 (http:// 또는 https://필수입력)"/>
                                            </div>
                                        </div>
                                        <div class="row flex_row">
                                            <div class="th top-border">이미지 미리보기</div>
                                            <div class="td top-border">
                                                <div class="col_img" id="js-kakao-img"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="block">
                                        <div class="row flex_row">
                                            <div class="row flex_row input-img on">
                                                <div class="th bottom-border">개인화 변수</div>
                                                <div class="td bottom-border">
                                                    <span style="font-size: 9px">※ 아래 박스에서 개인화 변수를 드래그한 후, 텍스트 상자에 넣거나 클릭하여 추가할 수 있습니다.</span>
                                                    <div id="kakaoValue"
                                                         style="width: 100%; max-height: 173px; overflow: auto; padding-top: 10px;"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row" style="height:150px;">
                                            <div class="th bottom-border">내용</div>
                                            <div class="td bottom-border">  <textarea name="kakao_body" class="kakao_txt textarea" cols="30" rows="10" style="width: 100%;height: 100%; resize: none;"
                                                                        onkeyup="onchangePrevKkoTxt(this)"></textarea></div>
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
                                                <input type="text"
                                                       class="txt_input width kakao_btn_name"
                                                       placeholder="버튼 링크 제목을 입력해주세요."
                                                       onkeyup="smsCreate.titleCount(this,'kakao')"/>
                                                <input type="hidden" name="kko_btn_nm" id="kko_btn_nm"/>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="th bottom-border">버튼 링크 주소</div>
                                            <div class="td bottom-border">
                                                <input type="text"
                                                       class="txt_input en_font kakao_btn_link"
                                                       placeholder="URL 입력 (http:// 또는 https://필수입력)"/>
                                                <input type="hidden" name="kko_btn_url" id="kko_btn_url" />
                                                <input type="button" class="btn_sm_line kakaoLinkBtn" value="생성"/>
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
                                <div class="input_area kko_area" id="kko_at" hidden>
                                    <div class="block">
                                        <div class="row">
                                            <div class="th">템플릿 선택</div>
                                            <div class="td">
                                                <div class="delete_tmpl" data="kakao"><img
                                                        src="${baseURL}/image/btn_delete1.png" alt="삭제">
                                                </div>
                                                <input type="text" class="txt_input en_font at_tmpl_data" name="tmpl_nm"
                                                       id="tmplNm"
                                                       placeholder="템플릿을 선택해 주세요." readonly/>
                                                <input type="text" name="key_id" id="templateCode" class="at_tmpl_data"
                                                       readonly hidden/>
                                                <span class="btn_sm_line" data="kakaoImage"
                                                      onclick="tmplListPopUp('1')">선택</span>
                                                <!--임시 히든값 -->
                                                <input type="hidden" name="kko_img_cd" value="">
                                                <input type="hidden" name="kko_view_img_url" value="">
                                                <input type="hidden" name="kko_btn_obj" id="kko_btn_obj" value="">
                                                <!-- 프리뷰를 위한 이미지 URL -->
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="viewer_area" id="kakao_ft_viewer">
                                <div class="top">친구톡 미리보기</div>
                                <div class="inner">
                                    <div class="row_body">
                                        <div class="round_box">
                                            <div class="kakao_ft" id="prev_ft_img">
                                            </div>
                                            <p class="kakao_txt" id="prev_ft_txt"></p>
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
                                                <div class="at_tmpl_data" ></div>
                                                <input type="hidden" class="kakao_txt" name="kakao_body" value="">
                                                <a href="" class="sms_btn">버튼</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div><!-- kakao end-->
                <div class="tab_contents">
                    <div class="sms_form cover" id="sms">
                        <input type="hidden" name="list_seq" value=""/>
                        <h2>문자</h2>
                        <div class="flex_box">
                            <div class="left_area">
                                <div class="row body">
                                    <div class="th">문자 제목</div>
                                    <div class="column_1">
                                        <div class="column_5">
                                                <%--<input type="text" class="title type1 smsTitle" name="cont_sub"
                                                       onkeyup="smsCreate.titleCount(this);" placeholder="문자 제목을 입력하세요." />--%>
                                            <input type="text" class="title type1 smsTitle" name="cont_sub_list" id="sms_title"
                                                   onkeyup="onchangePrevSmsTitle(this)"
                                                   value="(광고)"
                                                   placeholder="문자 제목을 입력하세요."/>
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
                                               placeholder="발신 번호를 선택 해주세요." readonly/>
                                        <input type="hidden" name="send_to_list" id="sms_send_to_num" value=""/>
                                        <span class="btn_sm_line" onclick="mobileSenderPopup('1','sms')">변경</span>
                                    </div>
                                </div>
                                <div class="input_area left">
                                    <div class="block">
                                        <div class="row">
                                            <div class="th">문자 종류</div>
                                            <div class="td">
                                                <label class="custom_radio">LMS<input class="smsType" name="sms_msg_tp"
                                                                                      type="radio"
                                                                                      value="LMS"
                                                                                      checked/><span></span></label>
                                                <label class="custom_radio">MMS<input class="smsType" name="sms_msg_tp"
                                                                                      type="radio"
                                                                                      value="MMS"/><span></span></label>
                                                <label class="custom_radio">SMS<input class="smsType" name="sms_msg_tp"
                                                                                      type="radio"
                                                                                      value="SMS"/><span></span></label>
                                            </div>
                                            <input type="hidden" name="mms_imgurl"/>
                                        </div>
                                        <div class="row input-img">
                                            <div class="th top-border">이미지 선택</div>
                                            <div class="td top-border">
                                                <div class="delete_img" data="mms">
                                                    <!--<img src="../../image/btn_delete1.png" alt="삭제">-->
                                                    <img src="${baseURL}/image/btn_delete1.png" alt="삭제">
                                                </div>
                                                <input type="text" class="txt_input" name="" id="smsImage"
                                                       placeholder="이미지를 선택해 주세요." readonly/>
                                                <input type="hidden" id="mds_img_cd" name="mds_img_cd" value=""/>
                                                <span class="btn_sm_line" data="smsImage"
                                                      onclick="imageListPopUp('1', 'smsImage');">선택</span>
                                            </div>
                                        </div>
                                        <div class="row flex_row input-img">
                                            <div class="th top-border">이미지 미리보기</div>
                                            <div class="td top-border">
                                                <div class="col_img" id="js-sms-img"></div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="block">
                                        <div class="row flex_row input-img on">
                                            <div class="th bottom-border">개인화 변수</div>
                                            <div class="td bottom-border">
                                                <span style="font-size: 9px">※ 아래 박스에서 개인화 변수를 드래그한 후, 텍스트 상자에 넣거나 클릭하여 추가할 수 있습니다.</span>
                                                <div id="smsContsVal"
                                                     style="width: 100%; max-height: 173px; overflow: auto; padding-top: 10px;"></div>
                                            </div>
                                        </div>
                                        <div class="row"  style="height:150px;">
                                            <div class="th bottom-border">내용</div>
                                            <div class="td bottom-border"> <textarea name="sms_body" class="sms_body textarea" id="sms_txt_area" cols="30" rows="10" style="width: 100%;height: 100%; resize: none;"
                                                                       onkeyup="onchangePrevSmsTxt(this)"></textarea></div>
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
                                                <input type="text" class="txt_input" id="smsTracking"
                                                       placeholder="URL 입력 (http:// 또는 https://필수입력)"/>
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
                                    <div class="sms_title" id="prev_sms_title">제목</div>
                                        <%--                                        <div class="sms_img"></div>--%>
                                    <div class="sms_img_box" id="sms_img_box"></div>
                                    <div class="text_box"><p class="scroll_txt_area" id="smsTextArea">내용 영역</p></div>
                                </div>
                                <div class="byte"  style="width: 270px">
                                    <span class="en_font sms_byte">0</span><span class="en_font">byte</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="tab_contents">
                    <!-- RCS -->
                    <div class="sms_form right-border cover" id="rcs">
                        <input type="hidden" name="list_seq" value=""/>
                        <h2>RCS</h2>
                        <div class="row body">
                            <div class="th">포맷카드</div>
                            <div class="column_2 right-border">
                                <label class="type_check">
                                    <input type="radio" name="rcs_format_type" class="rcsType" value="text" checked/>
                                    <span>텍스트형</span>
                                </label>
                                    <%--<label class="type_check"><input type="radio" name="rcs_format_type" class="rcsType" value="horizontal" /><span>가로형</span></label>--%>
                                <label class="type_check">
                                    <input type="radio" name="rcs_format_type" class="rcsType" value="vertical"/>
                                    <span>세로형</span>
                                </label>
                                <label class="type_check">
                                    <input type="radio" name="rcs_format_type" class="rcsType" value="slide"/>
                                    <span>슬라이드형</span>
                                </label>
                            </div>
                            <div class="view_title left">미리보기</div>
                        </div>
                        <div class="rcs_layout" id="js-replace">
                            <div class="flex_box">
                                <div class="left_area">
                                    <!-- start -->
                                    <div class="row body">
                                        <div class="th">카드 양식</div>
                                        <div class="column_1">
                                            <label class="custom_radio en_font">SMS<input name="rcs_msg_tp"
                                                                                          class="lowType"
                                                                                          type="radio" value="sms"
                                                                                          checked
                                            /><span></span></label>
                                            <label class="custom_radio en_font">LMS<input name="rcs_msg_tp"
                                                                                          class="lowType"
                                                                                          type="radio" value="lms"
                                            /><span></span></label>
                                        </div>
                                    </div>
                                    <span id="js-title-area"></span>
                                    <div class="row body">
                                        <div class="th">발신 번호</div>
                                        <div class="column_1" id="send_text_column">
                                            <input type="text" class="sms_number smsNumber" id="send_text_rcs"
                                                   placeholder="발신 번호를 선택 해주세요." readonly/>
                                            <input type="hidden" name="send_to_list" id="text_send_num" value=""/>
                                            <span class="btn_sm_line"
                                                  onclick="mobileSenderPopup('1','textrcs')">변경</span>
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
                                                </div>
                                            </div>
                                            <div class="row rcs_textarea">
                                                <div class="th top-border">내용</div>
                                                <div class="td top-border">
                                                    <textarea class="rcsContents" name="rcs_body" cols="30" rows="10"
                                                              placeholder="내용을 입력해주세요."
                                                              onkeyup="rcsCreate.rcsContents(this, 0);"></textarea>
                                                </div>
                                            </div>
                                        </div>
                                        <div id="btn-action-area">
                                            <div class="block">
                                                <div class="row">
                                                    <div class="th bottom-border">버튼 액션 선택</div>
                                                    <div class="td bottom-border">
                                                        <!-- select 영역 시작 -->
                                                        <div class="select action_select" data="1">
                                                            <!-- selected value -->
                                                            <div class="value" data="0">액션선택</div>
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
                                                        <input type="text" name="rcs_btn_1"
                                                               class="txt_input action_name" data="1"
                                                               onkeyup="rcsCreate.buttonCount(this, 'text');"
                                                               placeholder="버튼 명을 입력해주세요."/>
                                                        <span class="text-count en_font"><span>0</span>/17</span>
                                                    </div>
                                                </div>
                                                <div class="custom_box"></div>
                                            </div>
                                        </div>
                                        <input type="hidden" name="rcs_btn_tp_1" value=""/>
                                        <input type="hidden" name="rcs_btn_tp_2" value=""/>
                                        <input type="hidden" name="rcs_btn_tp_3" value=""/>
                                        <div class="block" id="rejection">
                                            <div class="row">
                                                <div class="th">무료수신거부</div>
                                                <div class="td">
                                                    <input type="text" name="rcs_footer"
                                                           class="txt_input rejection_num width"
                                                           oninput="rcsCreate.rejection(this);"
                                                           placeholder="수신거부 번호를 입력해주세요."/>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="viewer_area">
                                    <div class="rcs_inner text">
                                        <div class="rcs_head">[WEB발신]광고</div>
                                        <span id="js-txt-replace">
                                                    <div class="text_type">
                                                        <div class="scroll_txt">
                                                            <p class="rcs_area" id="textArea0">내용 영역</p>
                                                        </div>
                                                        <div class="rcs_btn_wrap">
                                                        </div>
                                                    </div>
                                                    <div class="rcs_register">무료 수신거부 : <span id="rejectionArea"></span></div>
                                                    <div class="text_count">
                                                        <span class="num en_font"><span
                                                                id="textByte0">0</span>/100</span>
                                                        <p>※ 본문내용 : <span class="en_font">100</span>글자 이내</p>
                                                    </div>
                                                </span>
                                    </div>
                                </div>
                                <!-- end -->
                            </div>
                        </div>
                        <!-- hidden 값 추가 --> <!-- 기본 Default시 추가하고 scrpit 클릭시 비활성화 -->
                            <%--<input type ="hidden" name ="cont_sub" value ="" id ="rcs_cont_sub">--%>
                        <input type="hidden" name="cont_sub_list" value="" id="rcs_cont_sub">
                    </div><!-- RCS end-->
                </div>
                    <%--                    </div>--%>
                </form:form>
                <div class="btn_row bottom-border" id="js-btn-area">
                    <input type="button" class="btn_save btn_bg btn_center btn_size1" id="previewBtn" value="저장"/>
                </div>
            </div>
        </div>
        <!-- section 영역 끝 -->
    </div>
    <!-- 컨텐츠 영역 끝 -->
    <!-- footer 영역 시작 -->
    <footer class="footer">
        &copy; Milvus Corp.
    </footer>
    <!-- footer 영역 끝 -->
</section>
<!-- container 영역 끝 -->
</div>
<!-- 새 이미지 파일 업로드 팝업 영역 시작 -->
<span id="imgListHtml"></span>
<!-- 새 이미지 파일 업로드 팝업 영역 끝 -->
<form:form id="tblmisetForm" name="tblmisetForm" onsubmit="return false">
    <span id="callPopUp"></span>
</form:form>

<!-- 새 이미지 파일 업로드 팝업 영역 끝 -->
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
                    <ul class="pager" id="pagingDom"></ul>
                    <input type="hidden" id="imgType" name="imgType" value=""/>
                </div>
                <div class="pop_error_txt blue_point_color"></div>
                <div class="btn_row">
                    <input type="button" class="btn_bg btn_size2 btn_center imageSave" value="저장"
                           onclick="imgSendSave();"/>
                </div>
            </div>
        </div>
    </div>
</span>
</form:form>
<!-- 새 이미지 파일 업로드 팝업 영역 끝 -->

<form:form id="mobileLst" name="mobileLst" onsubmit="return false">
    <div class="layer_pop mobileLstPopup">
        <div class="pop_container popup_size8">
            <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
            <div class="pop_title">리스트 선택</div>
            <div class="pop_inner">
                <div class="form_search">
                    <!-- 검색 영역 시작 -->
                    <div class="input_txt">
                        <input type="text" name='cont_nm' id="moblieLstSearch" placeholder="검색어 입력"/>
                        <input type="button" class="btn_search" onclick="mobileListPaging('1')" value="검색"/>
                    </div>
                    <!-- 검색 영역 끝 -->
                </div>
                <div class="image_container" id="mobileLstDom"></div>
                <div class="btn_row bottom-border left-border right-border">
                    <ul class="pager" id="mobileLstpagingDom"></ul>
                </div>
                <div class="pop_error_txt blue_point_color"></div>
                <div class="btn_row">
                    <input type="button" class="btn_bg btn_size2 btn_center imageSave" value="불러오기"
                           onclick="mobileListSave();"/>
                </div>
            </div>
        </div>
    </div>
</form:form>

<span id="tmplPopUp">
        <div class="layer_pop tmplPopUp">
    <div class="pop_container popup_size2">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
        <div class="pop_title">템플릿 선택</div>
        <div class="pop_inner">
            <form:form id="tmplSetForm" name="tmplSetForm" onsubmit="return false">
            <div class="form_search">
                <!-- 검색 영역 시작 -->
                <input type="text" class="calendar hasDatepicker" name="reg_dt" id="tmpl_from" placeholder="등록일 선택">
                <span class="hyphen"></span>
                <input type="text" class="calendar hasDatepicker" name="reg_dt_range" id="tmpl_to" placeholder="등록일 선택">
                <div class="input_txt left-border-none">
                    <input type="text" name="ex_tmpl_nm"
                           onkeyup="if (window.event.keyCode == 13) { tmplListPaging('1'); } return false;"
                           placeholder="템플릿명 입력">
                    <input type="button" class="btn_search" onclick="tmplListPaging('1')" value="검색">
                </div>
                <!-- 검색 영역 끝 -->
            </div>
            </form:form>
                <%--    템플릿 미리보기            --%>
                <div class="list_container sms cf">
                    <div class="row_grid">
                        <input type="hidden" id="nowPageNo" name="nowPageNo" value="1">
                    </div>
                </div>
                <span id="tmplPager"></span>
        <div class="pop_error_txt blue_point_color"></div>
        <div class="btn_row">
            <input type="button" class="btn_bg btn_size2 btn_center" onclick="tmplSendSave();" value="저장"/>
        </div>
    </div>
</div>

</div>
</span>

<form:form id="saveForm" name="saveForm" onsubmit="return false">
    <span id="preview"></span>
</form:form>
<script>
    let usr_cd = '${usr_cd}';
    let _connection;
    let beforeSub = $('input[name="rcs_msg_tp"]:checked').val();
    let slideData = $('.slide_type').find('.value').attr('data') == undefined ? '0' : $('.slide_type').find('.value').attr('data');
    let firstLoad = true;
    let mstSeq = null;
    let dropTarget = null;
    let bindList = [];

    $(function () {
        $('input[name="dbInfo"]').on('change', function () {
            mappingLst();
        });//end


        let config = {baseUrl: "/js/"};
        let dependencies = ["customActivity"];
        require(config, dependencies);

        //load 시 byte 계산
        let kakaoTxt = $('#kakao .textarea');
        let smsTxt = $('#sms .textarea');
        smsCreate.byteCount(kakaoTxt, 'kakao');
        smsCreate.byteCount(smsTxt, 'sms');

        let minInx = '';

        //load 시 컨텐츠 포맷 체크 후 주요 옵션 표시
        $('.formatType').each(function () {
            let checkLength = $('.formatType').filter(':checked').length;
            let state = $(this).is(':checked');

            if (state == true) {
                let tabInx = $('.formatType').index(this);
                $('#js-smsTab li').eq(tabInx).show();

                if (minInx === '' && minInx > tabInx) {
                    minInx = tabInx;
                }
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

        //컨텐츠 포맷 click event
        $(document).on('click', '.formatType', function () {
            let checkLength = $('.formatType').filter(':checked').length;
            let state = $(this).is(':checked');
            let tabInx = $('.formatType').index(this);

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

        //카카오 링크 버튼 생성 event
        $(document).on('click', '.kakaoLinkBtn', function () {
            let btnState = $(this).val();
            let link = $('.kakao_btn_link');
            let name = $('.kakao_btn_name');
            let btnLink = link.val();
            let btnName = name.val();

            if (btnState == '생성') {
                if (btnName != '') {
                    if (btnLink != '') {
                        if (btnLink.substring(0, 4) == 'http') {
                            // <a href="http://localhost:8083/cont/mdmCreate.mi" target="_blank" class="sms_btn">모바일 컨텐츠 생성</a>
                            $(this).parents('#kakao').find('.viewer_area .round_box').append('<a href="' + btnLink + '" class="kakao_link" target="_blank">' + btnName + '</a>');
                            //name.attr('disabled', true);
                            //link.attr('disabled', true);
                            $('#kko_btn_url').val(btnLink);
                            $('#kko_btn_nm').val(btnName);

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
                $(this).parents('#kakao').find('.viewer_area .inner a.kakao_link').remove();
                $(this).parents('#kakao_ft').find('.kakao_link').remove();

                $('#kko_btn_url').val('');
                $('#kko_btn_nm').val('');
                link.val('');
                name.val('');
                //name.attr('disabled', false);
                //link.attr('disabled', false);
                name.attr('readonly', false);
                link.attr('readonly', false);
            }
        });

        $(document).on('change', '.smsType', function () {
            let smsType = $(this).val();
            if (smsType != 'MMS') {
                $(this).parents('.row').siblings('.input-img').removeClass('on');
            } else {
                $(this).parents('.row').siblings('.input-img').addClass('on');
            }
        });

        // MMS, 카카오 이미지 삭제
        $(document).on('click', '.delete_img', function () {
            let imgElement = $(this).parents('.sms_form').find('.sms_img').children();
            let imgcount = imgElement.length;
            let imgUrl = $(this).next('.txt_input').val();
            let data = $(this).attr('data');

            if (imgcount > 0 || imgUrl != '') {
                if (data == "mms") {
                    // 문자 : 이미지 X버튼 누르면 초기화
                    $("input[name='mds_img_cd']").val('');
                    $("#smsImage").val('');
                    if ($("input[name='mms_imgurl']") != '') {
                        $("input[name='mms_imgurl']").val('')
                        $("#js-sms-img").empty();
                    }
                } else if (data == 'kakao') {
                    if ($('input[name="kko_img_cd"]').val() != '') {
                        // 카카오 : 이미지 X버튼 누르면 초기화
                        $("#kakaoImage").val('');
                        $("input[name='kko_img_cd']").val('');
                        $("input[name='kko_view_img_url']").val('');
                        $("#js-kakao-img").empty();
                    }
                }
            } else {
                return false;
            }
        });

        // 추적 링크 생성 동작
        $(document).on('click', '.trackingLinkBtn', function () {
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
                    let textarea = $(this).parents('.sms_form').find('.textarea')
                    $(textarea).val(text + '{{' + link + '}}');
                    $(this).prev('input').val('');

                    const targetNm = $(textarea).attr('name');
                    if(targetNm == 'kakao_body'){
                        onchangePrevKkoTxt(textarea);
                    } else if(targetNm == 'sms_body'){
                        onchangePrevSmsTxt(textarea);
                    }
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

            if (deleteInx == 0) {
                // 1번 이미지 카드 삭제
                $('input[name ="rcs_img_cd_1"]').val('');
            } else if (deleteInx == 1) {
                // 2번 이미지 카드 삭제
                $('input[name ="rcs_img_cd_2"]').val('');
            } else if (deleteInx == 2) {
                // 3번 이미지 카드 삭제
                $('input[name ="rcs_img_cd_3"]').val('');
            } else if (deleteInx == 3) {
                // 4번 이미지 카드 삭제
                $('input[name ="rcs_img_cd_4"]').val('');
            } else if (deleteInx == 4) {
                // 5번 이미지 카드 삭제
                $('input[name ="rcs_img_cd_5"]').val('');
            } else if (deleteInx == 5) {
                // 6번 이미지 카드 삭제
                $('input[name ="rcs_img_cd_6"]').val('');
            }

            if (imgcount > 0 || imgUrl != '') {
                $(this).next('.txt_input').val('');
                imgElement.remove();
            } else {
                return false;
            }
        });

        // 수신 번호 option click event
        $(document).on('click', '#recv_phone_to .option li', function () {
            let data = $(this).attr('data');
            if (data != 0) {
                $('#recv_phone').val(data);
            }
        });

        // 카카오 개인 변수 option click event
        $(document).on('click', '#kakaoValue input', function () {
            let data = $(this).attr('data');
            let txt = $('.kakao_txt').val();
            if (data != 0) {
                popup.popAlert("개인화 변수 입력 후 Byte 초과시 데이터가 미반영 될 수 있습니다. ");
                $('.kakao_txt').val(txt + data);
                $('.kakao_txt').keyup();
            }
        });

        // SMS 제목 개인화 변수 option click event
        $(document).on('click', '#smsTitleVal .option li', function () {
            let data = $(this).attr('data');
            let txt = $('#sms .title').val();
            if (data != 0) {
                popup.popAlert("개인화 변수 입력 후 Byte 초과시 데이터가 미반영 될 수 있습니다.");
                $('#sms .title').val(txt + '{{' + data + '}}');
                $('#sms .title').keyup();
            }
        });

        $(document).on('click', '#smsContsVal input', function () {
            let data = $(this).attr('data');
            let txt = $('#sms_txt_area').val();
            if (data != 0) {
                popup.popAlert("개인화 변수 입력 후 Byte 초과시 데이터가 미반영 될 수 있습니다.");
                $('#sms_txt_area').val(txt + data);
                $('#sms_txt_area').keyup();
            }
        });

        //RCS 제목 개인화 변수 option click event
        $(document).on('click', '.rcsTitleVal ul li', function () {
            let type = $('.type_check input[name="rcs_format_type"]:checked').val();
            let data = $(this).attr('data');
            if (type != 'slide') {
                let txt = $('.rcsTitle').val();
                let inputTitle = $('.rcsTitle');
                if (data != 0) {
                    popup.popAlert("개인화 변수 입력 후 Byte 초과시 데이터가 미반영 될 수 있습니다.");
                    $(inputTitle).val(txt + '{{' + data + '}}');
                    $(inputTitle).keyup();
                }
            } else {
                let txt = $(this).parents('.row').siblings().find('.rcsTitle').val();
                let inputTitle = $(this).parents('.row').siblings().find('.rcsTitle');
                if (data != 0) {
                    popup.popAlert("개인화 변수 입력 후 Byte 초과시 데이터가 미반영 될 수 있습니다.");
                    $(inputTitle).val(txt + '{{' + data + '}}');
                    $(inputTitle).keyup();
                }
            }
        });

        //RCS 내용 개인화 변수 option click event
        $(document).on('click', '.rcsContsVal ul li', function () {
            let type = $('.type_check input[name="rcs_format_type"]:checked').val();
            let data = $(this).attr('data');
            if (type != 'slide') {
                let txt = $('.rcsContents').val();
                let txtContents = $('.rcsContents');
                if (data != 0) {
                    popup.popAlert("개인화 변수 입력 후 Byte 초과시 데이터가 미반영 될 수 있습니다.");
                    $(txtContents).val(txt + '{{' + data + '}}');
                    $(txtContents).keyup();
                }
            } else {
                let txt = $(this).parents('.row').siblings().find('.rcsContents').val();
                let textContents = $(this).parents('.row').siblings().find('.rcsContents');
                if (data != 0) {
                    popup.popAlert("개인화 변수 입력 후 Byte 초과시 데이터가 미반영 될 수 있습니다.");
                    $(textContents).val(txt + data);

                    $(textContents).keyup();
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

        $(document).on('click', '.imageSave', function () {
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
        $(document).on('click', '.numberSave', function () {
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

        $(document).on('click', '.js-ad', function () {
            adTypeCheck();
        });

        // 버튼 셀렉트박스
        $(document).on('click', '.action_select ul li', function (e) {
            rcsBtnType(this);
        });

        // RCS 슬라이드형 카드 Tab click event
        $(document).on('click', '.slide_tab > div', function () {
            let nowIndex = $('.slide_tab > div').index(this);
            $(this).addClass('on').siblings().removeClass('on');
            $('.rcs_slide_conts').eq(nowIndex).addClass('on').siblings().removeClass('on');
        });

        $(document).on('click', '#previewBtn', function () {
            let tamplate = $('.template_name');
            let smsFormat = $('.formatType:checked').val();
            let smsFormatLength = $('.formatType:checked').length;

            $('.create_sms').find('.outline').removeClass('outline');

            if (tamplate.val() != '') {
                if ($('#recv_phone').val() == '' || $('#recv_phone').val() == null) {
                    popup.popAlert('수신 번호를 선택해 주세요.');
                    return false;
                }

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

        let beforeType = $('input[name="rcs_format_type"]:checked').val();

        // RCS 포맷카드 변경시 초기화 알림
        $(document).on('click', 'input[name="rcs_format_type"]', function (event) {
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

        // 포맷 Tab
        $(document).on('click', '#js-smsTab > li', function (event) {
            let tab = $('#js-smsTab > li').index(this);
            $(this).addClass('on').siblings().removeClass('on');
            $('.tab_contents').eq(tab).addClass('active').siblings().removeClass('active');
        });

        $(document).on("click", "#contLoad", function () {
            if (firstLoad) {
                firstLoad = false;
                mobileListPaging("1");
            } else {
                $('.mobileLstPopup').addClass('active');
            }
        });

        // sms_delete_img
        $(document).on("click", ".sms_delete_img", function () {
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
                    $('#sms_img_box').empty();
                }
                imgElement.remove();
            } else {
                return false;
            }
        });

        // 카카오 이미지 삭제
        $(document).on("click", ".kko_delete_img", function () {
            let imgElement = $(this).parents('.sms_form').find('.sms_img').children();
            let imgcount = imgElement.length;
            let imgUrl = $(this).next('.txt_input').val();

            if (imgcount > 0 || imgUrl != '') {
                $("#kakaoImage").val('');
                $("#kko_img_cd").val('');
                $("input[name='kko_view_img_url']").val('');
                // $("input[name='kko_img_url']").val(''); // 이미지 삭제시 링크 주소 삭제
                $("#js-kakao-img").empty();
                $('#prev_ft_img').empty();
            } else {
                return false;
            }
        });

        $(document).on('dragstart', function (ev) {
            ev.originalEvent.dataTransfer.setData("text", $(ev.target).attr("data"));
        });

        $(document).on('drop', function (ev) {
            dropTarget = $(ev.target);
        });

        $(document).on('dragend', function (ev) {
            let value = dropTarget.val();
            dropTarget.val("");
            dropTarget.val(value);
        });

    });

    // 정보 조회
    function mobileInfo(seq) {
        const res = function (response) {

            const $doc = new DOMParser().parseFromString(response, "text/html");
            if($(".nodataCheck", $doc).html() == "NULL"){
                alert("사용할 수 없는 컨텐츠입니다. 삭제 후 다시 생성해주세요.");
                _connection.trigger("destroy");
                return false;
            }

            $(".container").html($(".container", $doc).html());
            beforeKkoType = $('.kko_format_type:checked').val();

            //load 시 byte 계산
            let kakaoTxt = $('#kakao .textarea');
            let smsTxt = $('#sms .textarea');
            smsCreate.byteCount(kakaoTxt, 'kakao');
            smsCreate.byteCount(smsTxt, 'sms');

            const kakaoUseYn = $("input[name='formatType'][value='kakao']").is(":checked");
            const mailUseYn = $("input[name='formatType'][value='sms']").is(":checked");
            const rcsUseYn = $("input[name='formatType'][value='rcs']").is(":checked");

            let minInx;
            // 컨텐츠 USE_YN 값에 따른 minInx 변경
            if (kakaoUseYn) {
                minInx = 0;
            } else if (!kakaoUseYn && mailUseYn) {
                minInx = 1;
            } else if (!kakaoUseYn && !mailUseYn && rcsUseYn) {
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

            let rcsLength = $('.rcsContents').length;
            for (let c = 0; c < rcsLength; c++) {
                rcsObject = $('.rcsContents').eq(c)[0];
                rcsCreate.rcsContents(rcsObject, c);
            }

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

            $('.mobileLstPopup').removeClass('active');
            mappingLst();

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

        let param = {seq: seq}
        com_ajax.ajaxSync('post', '${baseURL}/sf/${usr_cd}/mobileInfo.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}',true)

    }

    // 카카오, SMS 유효성 검사
    function kakaoValidate() {
        let kakaoOption = $('input[name="kko_option"]').val();
        let kakaoTitle = $('.kakaoTitle');
        let kkoType = $("input[name='kko_format_type']:checked").val();
        let kakaoTxt = null;
        if(kkoType == "kko_ft"){
            kakaoTxt = $("textarea.kakao_txt");
        }else{
            kakaoTxt =  $("input.kakao_txt");
        }
        let kakaoSenderNo = $('.smsNumber_kko');

        if (kakaoSenderNo.val() == '' || kakaoSenderNo.val() == null) {
            popup.popAlert("카카오톡 발신 프로필을 선택해주세요");
            //kakaoSenderNo.parent('.column_2').addClass('outline');
            return false;
        }

        if (kakaoOption == 'ad') {
            if (kakaoTitle.val().indexOf('(광고)') != -1) {
                if (kakaoTxt.val() != '') {
                    let type = kakaoTypeValidate();
                    if (type == true) {
                        $('.kakao_txt').removeAttr("name");
                        $(kakaoTxt).attr("name",'kakao_body');
                        return true;
                    } else {
                        return false;
                    }
                } else {
                    if($('.kkoType:checked').val() == 'kko_at'){
                        popup.popAlert('템플릿을 선택해주세요.');
                        $('#tmplNm').focus();
                        return false;
                    }
                    popup.popAlert('카카오톡 메시지 내용을 입력해주세요.');
                    kakaoTxt.focus();
                    return false;
                }
            } else {
                kakaoTitle.parent('.column_1').addClass('outline');
                kakaoTitle.focus();
                popup.popAlert("카카오톡 광고성 메시지 제목에 '(광고)'입력이 필수 입니다.");
                return false;
            }
        }
        if (kakaoOption == 'guide') {
            if (kakaoTitle.val() != '') {
                if (kakaoTxt.val() != '') {
                    let type = kakaoTypeValidate();
                    if (type == true) {
                        $('.kakao_txt').removeAttr("name");
                        $(kakaoTxt).attr("name",'kakao_body');
                        return true;
                    } else {
                        return false;
                    }
                } else {
                    if($('.kkoType:checked').val() == 'kko_at'){
                        popup.popAlert('템플릿을 선택해주세요.');
                        $('#tmplNm').focus();
                        return false;
                    }
                    popup.popAlert('카카오톡 메시지 내용을 입력해주세요.');
                    $('.kakao_txt').focus();
                    return false;
                }
            } else {
                kakaoTitle.parent('.column_1').addClass('outline');
                kakaoTitle.focus();
                popup.popAlert("카카오톡 문자 제목을 입력해주세요.");
                return false;
            }
            /*if ($('.kakao_txt').val() != '') {
                let type = kakaoTypeValidate();
                if (type == true) {
                    return true;
                } else {
                    return false;
                }
            } else {
                popup.popAlert('카카오톡 메시지 내용을 입력해주세요.');
                $('.kakao_txt').focus();
                return false;
            }*/
        }
        return false;
    }

    //카카오 유효성 검사
    function kakaoTypeValidate() {
        // 카카오의 경우 이미지 필수 -> 이미지 선택으로 바뀜
        let kakaoByte = Number($('.kakao_byte').html());
        let kakaoImage = $('#kakaoImage');
        let kakaoTxt = $('.kakao_txt');

        // 본문 byte 체크
        if (kakaoImage.val() == '' || kakaoImage.val() == null) {
            if (kakaoByte > 2000) {
                kakaoTxt.focus();
                popup.popAlert("카카오톡 본문 내용이 2000byte를 초과할 수 없습니다.");
                return false;
            }
        } else if (kakaoImage.val() != '' || kakaoImage.val() != null) {
            if (kakaoByte > 400) {
                kakaoTxt.focus();
                popup.popAlert("카카오톡 본문 내용이 400byte를 초과할 수 없습니다.");
                return false;
            }
        }
        return true;
    }

    // 문자 유효성 검사
    function smsValidate() {
        let smsOption = $('input[name="sms_option"]').val();
        let smsTitle = $('.smsTitle');
        let smsTxt = $('#sms_txt_area');
        let smsNumber = $('.smsNumber')
        let smsNumberValue = $('#sms_send_to').val().trim();

        if (smsNumberValue == '' || smsNumberValue == null) {
            smsNumber.parent('.column_2').addClass('outline');
            popup.popAlert("문자 발신 번호를 입력해주세요.");
            return false;
        }

        if (smsOption == 'ad') {
            if (smsTitle.val().indexOf('(광고)') != -1) {
                if (smsNumber != '' || smsNumber != null) {
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
                } /*else {
                    smsNumber.parent('.column_2').addClass('outline');
                    popup.popAlert("발신 번호를 입력해주세요.");
                    return false;
                }*/
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
        let smsTxt = $('#sms_txt_area');

        if (smsType == 'LMS') {
            //$("#mds_img_cd").val('');
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
                    popup.popAlert('RCS 제목, 내용 중 하나 이상은 입력해야합니다.');
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
        } //text end

        // 가로형 end
        /*if (format == 'horizontal') {

            let smsNumber = $('.smsNumber')
            let smsNumberValue = $("#send_horizon_rcs").val()

            if(smsNumberValue == '' || smsNumberValue == null) {
                popup.popAlert("발신 번호를 입력해주세요.");
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
        }*/
        if (format == 'vertical') {

            let smsNumber = $('.smsNumber')
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

            let smsNumber = $('.smsNumber')
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
                                            popup.popAlert('RCS 카드' + (k + 1) + '에 이미지를 입력해 주세요.');
                                            return false;
                                        }
                                    }
                                }

                            }
                            if ($(section).find('.rcsTitle').val() == '' && $(section).find('.rcsContents').val() == '' && $(section).find('.rcsImage').val() == '') {
                                popup.popAlert('RCS 카드' + (s + 1) + ' 이미지, 제목, 내용 중 하나 이상은 입력해야합니다.');
                                return false;
                            }
                            if ($(section).find('.rcsImage').val() == '' && isCheckSlideType == 'small') {
                                popup.popAlert('RCS 슬라이드형 Small은 이미지가 필수 값 입니다.' + '<br/>' + '카드' + (s + 1) + '에 이미지를 등록해주세요.');
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
                                                popup.popAlert('RCS 카드' + (s + 1) + ' 버튼' + (i + 1) + ' 버튼명을 입력해주세요.');
                                                return false;
                                            }
                                            if (buttonName != '') {
                                                for (let a = 0; a < actionInput; a++) {
                                                    let detailValue = $(section).find('.action_select').eq(i).parents('.row').siblings('.custom_box').find('.td input').eq(a).val();
                                                    let detailName = $(section).find('.action_select').eq(i).parents('.row').siblings('.custom_box').find('.td input').eq(a).attr('data');
                                                    if (detailValue == '') {
                                                        popup.popAlert('RCS 카드' + (s + 1) + '버튼' + (i + 1) + ' 상세 내용을 입력해주세요.');
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
        if ($('input[name="rcs_option"]').val() == 'ad' && $('.rejection_num').val() == '') {
            popup.popAlert('RCS 수신거부 번호를 입력해주세요.');
            return false;
        }
        return true;
    }

    // 이미지, 제목, 내용 중 입력 값이 없는 경우 체크
    function commonCheck() {
        if ($('.rcsTitle').val() == '' && $('.rcsContents').val() == '' && $('.rcsImage').val() == '') {
            popup.popAlert('RCS 이미지, 제목, 내용 중 하나 이상은 입력해야합니다.');
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

    // 프리뷰 서비스 랜딩 하기
    function preview() {
        const res = function (response) {
            let $doc = new DOMParser().parseFromString(response, "text/html");
            let html = $("#js-area-popup", $doc).html();
            let dynamic = $("#preview").html(html);

            // 알림톡 미리보기
            if($("#preview").find("#at_tmpl_privew").length >0 ){
                $("#at_tmpl_privew").html($('.at_inner .row_body').html())
            }
            $("#smsContentsPopup").addClass("active");
            previewSlideLoad();
        }
        let data = $("#form").serializeArray();
        com_ajax.ajax('post', '${baseURL}/sf/${usr_cd}/preview.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}')
    }


    // 템플릿 명 유효성 검사 //salesforce에서는 이름 중복확인 안함
    function isCheckTemplateName() {
        let cont_nm = $("input[name='cont_nm']").val();
        let rcsType = $("input[name='rcs_format_type']:checked").val();

        if (rcsType === 'slide') {
            btnHiddenRcsSlide()
        } else {
            buttonHiddenAdd()
        }
        preview();

        /*const res = function (response) {
            if (response.status == "true") {
                // buttonHiddenAdd()
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
        let param = {cont_nm: cont_nm, cont_grp_cd: $('#cont_grp_cd').val(), seq: mstSeq}
        com_ajax.ajax('post', '${baseURL}/sf/${usr_cd}/isCheckTmplateNm.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}')*/
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

    function btnHiddenRcsSlide() {

        var rcsType = $("input[name='rcs_format_type']").val();
        var checkType = $("input[name='rcs_msg_tp']:checked").val();

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


        let valueArr = []
        for (var i = 0; i < 12; i++) {
            // 12번 반복문을 통해 hidden 값을 체크한다.
            var valueCheck = $("#slide_rcs_btn_tp_" + Number(i + 1)).val();
            if ((valueCheck == 0 || valueCheck == "" || valueCheck == null) && typeof valueCheck != "undefined") {
                $("#btnHidden" + Number(i + 1)).html(layout);
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
            param.push({name: 'use_yn', value: 'Y'});
        } else if (type == 'kko') {
            param.push({name: 'list_tp_id', value: 'CH02'});
            param.push({name: 'list_dt_id', value: 'DMTP03'});
            param.push({name: 'use_yn', value: 'Y'});
        } else {
            // 타입이 RCS 라면
            param.push({name: 'list_tp_id', value: 'CH02'});
            param.push({name: 'list_dt_id', value: 'DMTP04'});
            param.push({name: 'use_yn', value: 'Y'});
        }

        param.push({name: 'pageNo', value: nowPage, usr_grp_cd: $('#usr_grp_cd').val()})

        com_ajax.ajax('post', '${baseURL}/sf/${usr_cd}/senderMobileList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 수신거부 문구 리스트 불러오기
    function mobileRejectTextPopup(nowPage) {

        var res = function (response) {
            $("#callPopUp").html(response);
            $("#mSendType").val("아랑");
        };

        let param = $("#tblmisetForm").serializeArray();
        param.push({name: 'list_tp_id', value: 'CH04'});
        param.push({name: 'list_dt_id', value: 'REJT01'});
        param.push({name: 'pageNo', value: nowPage})

        com_ajax.ajax('post', '${baseURL}/sf/${usr_cd}/mobileRejectTextList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function changeMobileRejectText(){
        const checkedTr = $('.mobilePopup input[name="callNumber"]:checked').parents('tr');
        const text = $(checkedTr).children('td:last-child').html();

        $('input[name="rejectText"]:visible').val(text);

        $('.mobilePopup').removeClass('active');
    }


    // 발신자 번호 input 저장하기
    function mobileSendSave(type) {

        let send_to = $('input[name="callNumber"]:checked').parent('label').find('input[name="sendNumber"]').val();  // 보낼 번호
        let send_nm = $('input[name="callNumber"]:checked').parent('label').find('input[name="sendNm"]').val(); // 발신자 명
        let send_number = $('input[name="callNumber"]:checked').val();
        let send_to_type = $('#mSendType').val();
        let sender = send_nm + "(" + send_to + ")";

        if (send_to_type === 'sms') {
            $("#sms_send_to").val(sender);
            $("#sms_send_to_num").val(send_number);
        } else if (send_to_type === 'horizonrcs') {
            $("#send_horizon_rcs").val(sender);
            $("#horizon_send_num").val(send_number);
        } else if (send_to_type === 'textrcs') {
            $("#send_text_rcs").val(sender);
            $("#text_send_num").val(send_number);
        } else if (send_to_type === 'verticalrcs') {
            $("#send_vertical_rcs").val(sender);
            $("#vertical_send_num").val(send_number);
        } else if (send_to_type === 'slidercs') {
            $("#send_slice_rcs").val(sender);
            $("#slide_send_num").val(send_number);
        } else if (send_to_type === 'kko') {
            $('.smsNumber_kko').val(sender);
            $('#send_key').val(send_to);
            $('#kakao_send_to_num').val(send_number);
            if ($('.kkoType:checked').val() === "kko_at") {
                $('.delete_tmpl').trigger('click');
            }
        }

        $('.mobilePopup').removeClass('active');
    }

    function imageListPopUp(nowPage, type) {
        $('#imgType').val(type);
        imageListPaging(nowPage);
    }
    // 이미지 리스트 팝업
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
            // 이미지 타입 : Kakao Image
            param.push({name: 'ch_tp', value: 'IMGTP_FT'});
        } else if (type === 'smsImage') {
            // 이미지 타입 : 문자(MMS)
            param.push({name: 'ch_tp', value: 'IMGTP02'});
        } else if (type === 'horizontalImage') {
            // 이미지 타입 : RCS 가로형
            param.push({name: 'ch_tp', value: 'IMGTP04'});
        } else if (type === 'verticalImage') {
            let rcs_msg_tp = $('input[name="rcs_msg_tp"]').filter(':checked').val();
            if (rcs_msg_tp === 'tall') {
                // 이미지 타입 : RCS 세로형 Tall
                param.push({name: 'ch_tp', value: 'IMGTP05'});
            } else if (rcs_msg_tp === 'medium') {
                // 이미지 타입 : RCS 세로형 Medium
                param.push({name: 'ch_tp', value: 'IMGTP06'});
            }
        } else if (type === 'slideRcsImage') {
            let rcs_msg_tp = $('input[name="rcs_msg_tp"]').val();
            if (rcs_msg_tp === 'small') {
                // 이미지 타입 : RCS 슬라이드 small
                param.push({name: 'ch_tp', value: 'IMGTP07'})
            } else if (rcs_msg_tp === 'medium') {
                // 이미지 타입 : RCS 슬라이드 medium
                param.push({name: 'ch_tp', value: 'IMGTP08'});
            }
        }
        param.push({name: 'pageNo', value: nowPage, usr_grp_cd: $('#usr_grp_cd').val()});
        com_ajax.ajax('post', '${baseURL}/sf/${usr_cd}/mobileImgList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
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

    function imageCreate(type, imageUrl, ImgNm, imgCheck) {
        let imageType = imageUrl;
        let kakaoImgLink = $('.kakaoImgLink').val();

        if (imageType != '') {
            if (type == 'kakaoImage') {
                if (kakaoImgLink == '') {
                    $("input[name='kko_view_img_url']").val(imageUrl);
                    $("#kakaoImage").val(ImgNm);
                    $('input[name="kko_img_cd"]').val(imgCheck);
                    $('#kakaoImage').parent('.td').removeClass('outline');
                    // $('#kakao').find('.sms_img').html('<a href="' + imageType + '" target="_blank">' + '<img src="' + imageType + '" onerror="this.src=\'/image/bg_none_wide.png\'" />' + '</a>');
                    $('#js-kakao-img').html('<a href="' + imageType + '" target="_blank">' + '<img src="' + imageType + '" onerror="this.src=\'/image/bg_none.png\'" />' + '</a>');
                    $('#prev_ft_img').html('<img src="' + imageType + '" onerror="this.src=\'/image/bg_none.png\'" />');
                } else {
                    $("input[name='kko_view_img_url']").val(imageUrl);
                    $("#kakaoImage").val(ImgNm);
                    $('input[name="kko_img_cd"]').val(imgCheck);
                    $('#kakaoImage').parent('.td').removeClass('outline');
                    //$('#kakao').find('.sms_img').html('<a href="' + kakaoImgLink + '" target="_blank">' + '<img src="' + imageType + '" onerror="this.src=\'/image/bg_none_wide.png\'" />' + '</a>');
                    $('#js-kakao-img').html('<a href="' + kakaoImgLink + '" target="_blank">' + '<img src="' + imageType + '" onerror="this.src=\'/image/bg_none.png\'" />' + '</a>');
                }
            } else if (type == 'smsImage') {
                $("#smsImage").val(ImgNm);
                $('input[name="mds_img_cd"]').val(imgCheck);
                $('#smsImage').parent('.td').removeClass('outline');
                //$('#sms').find('.sms_img').html('<img src="' + imageType + '" onerror="this.src=\'/image/bg_none_wide.png\'"/>');
                $('#js-sms-img').html('<img src="' + imageType + '" onerror="this.src=\'/image/bg_none.png\'"/>');

                $('#sms_img_box').html('<img src="' + imageType + '" onerror="this.src=\'/image/bg_none.png\'"/>');
                $('input[name="mms_imgurl"]').val(imageType);
            } else if (type == 'horizontalImage') {
                $("#horizontalImage").val(ImgNm);
                $("#horizonImg").val(imgCheck);
                $('#horizontalImage').parent('.td').removeClass('outline');
                $('.horizontal').find('.img_area').html('<img src="' + imageType + '" onerror="this.src=\'/image/bg_none_wide.png\'"/>');
            } else if (type == 'verticalImage') {
                $("#verticalImage").val(ImgNm);
                $('input[name="rcs_img_url_1"]').val(imageUrl);
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
                $('#kakao_ft').find('.sms_img').children().remove();
            } else if (type == 'smsImage') {
                $('#sms').find('.sms_img').children().remove();
            }
        }
    }

    // RCS 포맷 카드 변경
    function rcsChangeFormat(type) {
        let checkType = $(type)[0].value;
        $(type).prop('checked', true);
        $('.layer_pop').removeClass('active');
        //rcsCreate.layout(checkType);

        type.value != 'slide' ? beforeSub = $('input[name="rcs_msg_tp"]:checked').val() : beforeSub = $('input[name="rcs_msg_tp"]:checked').val();

        if (checkType == 'text') {
            let res = function (response) {
                let $doc = new DOMParser().parseFromString(response, "text/html");
                let html = $("#textArea", $doc).html();
                let dynamic = $('#js-replace').html(html);
                mappingLst();
                adTypeCheck();
            }
            com_ajax.ajax('get', '/sf/${usr_cd}/rcsText.ajax', null, res, '${_csrf.headerName}', '${_csrf.token}' , true);
        }
        if (checkType == 'vertical') {
            let res = function (response) {
                let $doc = new DOMParser().parseFromString(response, "text/html");
                let html = $("#verticalArea", $doc).html();
                let dynamic = $('#js-replace').html(html);
                mappingLst();
                adTypeCheck();
            }
            com_ajax.ajax('get', '/sf/${usr_cd}/rcsVertical.ajax', null, res, '${_csrf.headerName}', '${_csrf.token}', true);
        }
        if (checkType == 'slide') {
            let res = function (response) {
                let $doc = new DOMParser().parseFromString(response, "text/html");
                let html = $("#slideArea", $doc).html();
                let dynamic = $('#js-replace').html(html);
                mappingLst();
                adTypeCheck();
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
            com_ajax.ajax('get', '/sf/${usr_cd}/rcsSlide.ajax', null, res, '${_csrf.headerName}', '${_csrf.token}',true);
        }
    }

    // RCS 카드 양식 변경
    function rcsLowTypeChange(type) {
        let checkType = $(type)[0];
        let radioVal = checkType.value;
        $(type).prop('checked', true);
        beforeSub = radioVal;
        $('.layer_pop').removeClass('active');
        let view = '';

        $('#rcs input[name="cont_sub_list"]').val(''); // RCS만 초기화
        $('textarea[name="rcs_body"]').val('');
        $('input[name="rcs_footer"]').val('');
        $('#rejectionArea').html('');
        $('.rcsContsVal[name="edmDB"] .value').attr('data', '0').text('개인화 변수').css('color', '#cccccc');
        $('.rcsTitle[name="edmDB"] .value').attr('data', '0').text('개인화 변수').css('color', '#cccccc');

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

            let kakaoTitle = $('.kakaoTitle[name="cont_sub_list"]');
            if($(kakaoTitle).val().indexOf('(광고)') != 0){
                $(kakaoTitle).val('(광고)' + $(kakaoTitle).val());
            }
            let smsTitle = $('.smsTitle[name="cont_sub_list"]');
            if($(smsTitle).val().indexOf('(광고)') != 0){
                $(smsTitle).val('(광고)' + $(smsTitle).val());
                onchangePrevSmsTitle(smsTitle);
            }

            $('.rcs_head').html('[WEB발신]광고');
        } else {
            kakao.val('guide');
            sms.val('guide');
            rcs.val('guide');

            let kakaoTitle = $('.kakaoTitle[name="cont_sub_list"]');
            if($(kakaoTitle).val().indexOf('(광고)') == 0){
                $(kakaoTitle).val($(kakaoTitle).val().substr(4));
            }
            let smsTitle = $('.smsTitle[name="cont_sub_list"]');
            if($(smsTitle).val().indexOf('(광고)') == 0){
                $(smsTitle).val($(smsTitle).val().substr(4));
                onchangePrevSmsTitle(smsTitle);
            }
            $('.rcs_head').html('[WEB발신]');
        }
    }


    // 2021-05-04 -> RCS 가로형 삭제 (이미지 업로드)
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
            '<label class="custom_radio">친구톡<input name="ch_tp" type="radio" value="IMGTP03" checked><span></span></label>' +
            '<label class="custom_radio">친구톡(와이드)<input name="ch_tp" type="radio" value="IMGTP11"><span></span></label>' +
            '<label class="custom_radio">알림톡<input name="ch_tp" type="radio" value="IMGTP09"><span></span></label>' +
            '<label class="custom_radio">알림톡(아이템)<input name="ch_tp" type="radio" value="IMGTP10"><span></span></label>' +
            '<label class="custom_radio">모바일<input name="ch_tp" type="radio" value="IMGTP02"><span></span></label>' +
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
            '<ul class="guide_txt guide_lst">' +
            '<li>※ 세로형 : ① Tall : 568 X 528 (1MB 이하), ② Medium : 568 X 336 (1MB 이하)</li>' +
            '<li>※ 슬라이드형 : ① Small : 360 X 336, ② Medium : 696 X 504, 최대 사이즈 360 X 1569 , 1MB 이하</li>' +
            '</ul>' +
            '<ul class="at_guide1 guide_lst" hidden>' +
            '<li>※ 이미지 파일은 용량이 500KB 이하인 jpg, png 파일만 등록 가능합니다.</li>' +
            '<li>※ 이미지 파일은 가로 500px 이상, 세로 250px 이상이며 가로:세로 비율이 2:1 이어야 합니다.</li>' +
            '</ul>' +
            '<ul class="at_guide2 guide_lst" hidden>' +
            '<li>※ 이미지 파일은 용량이 500KB 이하인 jpg, png 파일만 등록 가능합니다.</li>' +
            '<li>※ 이미지 파일은 가로 108px 이상이며 가로:세로 비율이 1:1 이어야 합니다.</li>' +
            '</ul>' +
            '<ul class="ft_guide1 guide_lst">' +
            '<li>※ 이미지 파일은 용량이 500KB 이하인 jpg, png 파일만 등록 가능합니다.</li>' +
            '<li>※ 이미지 파일은 가로 500px 이상이며 또는 가로:세로 비율이 2:1 또는 3:4 이어야 합니다.</li>' +
            '</ul>' +
            '<ul class="ft_guide2 guide_lst" hidden>' +
            '<li>※ 이미지 파일은 용량이 2MB 이하인 jpg, png 파일만 등록 가능합니다.</li>' +
            '<li>※ 이미지 파일은 가로 800px 세로 600px 파일만 등록 가능합니다.</li>' +
            '</ul>' +
            '<div class="left pop_error_txt other_guide guide_lst">※ 모바일 : Jpg, png(200KB 이하), 이메일 : jpg, png, gif</div>' +
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

    function saveContentImg() {
        let imgNm = $("#img_nmCk").val();
        if (imgNm == "" || imgNm == null) {
            popup.popAlert("이미지명을 입력해주세요.");
            return false;
        }
        if ($("#file").val() == "" || $("#file").val() == null) {
            popup.popAlert("업로드된 파일이 없습니다.");
            return false;
        }

        let res = function (response) {
            //TO-DO
            //리스트 새로 불러오기
            if (response.imgCheck == 0) {
                popup.popAlert(response.imgCheckErr);
                return false;
            }
            popup.popAlert(response.message);
            $('.uploadPopup').removeClass('active');
            //$("#form")[0].reset();
            $("#file").val();
            $(".img_viewer").children().remove();
            $(".img_view").addClass('noImg');
            imageListPaging('1');
        };

        let data = new FormData();
        data.append("file", $("#file")[0].files[0]);
        let ch_tp = $("input[name=ch_tp]:checked").val();
        if (ch_tp == 'RCS') {
            data.append("ch_tp", $('.rcs_select .value').attr('data'));
        } else {
            data.append("ch_tp", ch_tp);
        }
        data.append("img_nm", imgNm);
        data.append("usr_grp_cd", $('#usr-grp_cd').val());

        com_ajax.ajax_file('${baseURL}/sf/${usr_cd}/contentUpload.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function phoneFormatter(num) {
        let formatNum;
        if (num != null) {
            if (num.length == 11) {
                formatNum = num.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
            } else if (num.length == 8) {
                formatNum = num.replace(/(\d{4})(\d{4})/, '$1-$2');
            } else {
                if (num.indexOf('02') == 0) {
                    formatNum = num.replace(/(\d{2})(\d{4})(\d{4})/, '$1-$2-$3');
                } else {
                    formatNum = num.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3');
                }
            }
        }
        return formatNum;
    }

    function replaceBr(s) {
        if (s == null) {
            return null;
        } else {
            return s.replace(/(\r\n|\r|\n|\n\r|\\\\r\\\\n)/gi, "<br>");
        }
    }

    function tmplListPopUp(pageNo) {
        if($('#send_key').val() ==''){
            popup.popAlert("발신 프로필을 선택해주세요");
            return;
        }
        $('.tmplPopUp').addClass('active');
        tmplListPaging(1)
    }

    function tmplListPaging(pageNo) {
        let res = function (response) {
            let $doc = new DOMParser().parseFromString(response, "text/html");
            $('.row_grid').html($("#body", $doc).html());
            $("#tmplPager").html($("#pager", $doc).html());
        };
        let param = $("#tmplSetForm").serializeArray();
        param.push({name: 'pageNo', value: pageNo},{name : 'usr_grp_cd',value : $('#usr-grp_cd').val()},{name: 'kep_status', value: 'O'},{name:'send_key',value: $('#send_key').val()});

        com_ajax.ajax('post', '${baseURL}/sf/${usr_cd}/kko/atTmplLst.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    $(document).on('click', '.delete_tmpl', (e) => {
        $('.at_tmpl_data').val(''); // 템플릿 관련 데이터 삭제
        $('.at_tmpl_data').html('');
        $('.kakao_txt').val('');
    })

    function tmplSendSave() {
        const tmpl = $('#tmplPopUp input[name="tmpl_cd"]:checked');
        const tmplbody =$(tmpl).parents('.template_div').find('.template_body').html();

        $('#kakao_at_viewer .at_inner .row_body').html(tmplbody)
        $('#tmplNm').val($(tmpl).val());
        $('#templateCode').val($(tmpl).attr('data'));

        $('#tmplPopUp').siblings('.pop_error_txt').html('');
        $('#tmplSetForm input').val('');
        $('.tmplPopUp').removeClass('active');
    }


    function textAreaParsing(s) {
        if (s == null) {
            return null;
        } else {
            return s.replace(/(<br\/>)/gi, '&#10');
        }
    }

    function rcsBtnType(e) {
        let actionVal = $(e).attr('data');
        let area = $(e).parents('.row').siblings('.custom_box');
        let layout = '';
        let parentValue = $(e).parents('.action_select').attr('data');

        $(area).children().remove();

        let num = 0;
        let rcsType = $("input[name='rcs_format_type']:checked").val().trim();

        if (rcsType === "slide") {
            let dataValue = "slide_rcs_btn_" + parentValue;
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
                    $("#slide_rcs_btn_tp_11").val(actionVal);
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
                    $("#slide_rcs_btn_tp_12").val(actionVal);
                }
            }
        } else {
            let dataValue = "rcs_btn_tp_" + parentValue;
            if (parentValue == 1) {
                $("input[name='rcs_btn_tp_1']").val(actionVal);
            } else if (parentValue == 2) {
                $("input[name='rcs_btn_tp_2']").val(actionVal);
            } else if (parentValue == 3) {
                $("input[name='rcs_btn_tp_3']").val(actionVal);
            }
        }
        $(e).parents('.row').siblings('.row').find('.action_name').val('');
        $(e).parents('.row').siblings('.row').find('.text-count span').html('0');

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
                '<input type ="hidden" name ="fallback_url_04" value=" "/>' +
                '<input type ="hidden" name= "fallback_url_05" value =" "/>' +
                '<input type ="hidden" name ="location_value_04" value=" "/>' +
                '<input type ="hidden" name ="location_value_05" value =" "/>' +
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
        let typeSlide = $(e).parents('.rcs_slide_conts').length;

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
            let sectionInx = $(e).parents('.rcs_slide_conts').index() - 1;
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
    }

    // 모바일 리스트 팝업
    function mobileListPaging(nowPage) {
        const res = function (response) {
            $('.mobileLstPopup').addClass('active');
            let $doc = new DOMParser().parseFromString(response, "text/html");
            $("#mobileLstDom").html($("#mobileLstDom", $doc).html());
            $("#mobileLstpagingDom").html($("#mobileLstpagingDom", $doc).html());
        };
        let param = $("#mobileLst").serializeArray();
        param.push({name: 'pageNo', value: nowPage, usr_grp_cd: $('#usr_grp_cd').val()});
        com_ajax.ajax('post', '${baseURL}/sf/${usr_cd}/mobileList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 모바일 리스트 선택
    function mobileListSave() {
        let len = $('input[name="list"]:checked').length;
        let check = $('input[name="list"]:checked').val();
        if (len > 0) {
            mobileInfo(check);

            $('#recv_phone_to .value').attr('data','').html('개인화변수');
            $('#recv_phone').val('');
        } else {
            return false;
        }
    }


    // 카카오 타입 변경
    let beforeKkoType = "ft";
    $(document).on('click','input[name="kko_format_type"]', function (event) {
        event.preventDefault();
        check = $('input[name="kko_format_type"]:checked');
        let nowVal = $('input[name="kko_format_type"]:checked').val();

        if (beforeKkoType != nowVal) {
            let message = "메시지 타입을 변경 할 경우 입력한 내용이 초기화됩니다.<br/>변경 하시겠습니까?";
            let html = '';
            html +=
                '<div class="layer_pop alert active">' +
                '<div class="pop_container popup_size3">' +
                '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
                '<div class="pop_title">타입 변경</div>' +
                '<div class="pop_inner">' +
                '<div class="alert_txt">' + message + '</div>' +
                '<div class="btn_row">' +
                '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="popupClose(this); kkoChangeFormat(check);" value="확인" />' +
                '<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this); rollbackType(beforeKkoType)" value="취소" />' +
                '</div>' +
                '</div>' +
                '</div>' +
                '</div>';
            $('body .layer_pop.alert').remove();
            $('body').append(html);
        }
    });

    function kkoChangeFormat(check) {
        beforeKkoType = $(check).val();
        $(check).prop('checked', true);
        $('.kko_area').hide();
        $(`#` + beforeKkoType).show();

        if (check.val() == 'kko_at') {
            $('#kakao_at_viewer').show();
            $('#kakao_ft_viewer').hide();

            $('.kakao_txt').val("");
            $('.kakao_byte').html('0');
            $('#kko_ft input[type="text"]').val('');
            $('#prev_ft_img').html('');
            $('#prev_ft_txt').html('');

            $('#js-kakao-img').html('');
            $('.kakao_link').remove()

        } else {
            $('#kakao_ft_viewer').show();
            $('#kakao_at_viewer').hide();
            $('#kakao_at_viewer .at_tmpl_data').val('');
            $('#kakao_at_viewer .at_tmpl_data').html('');
            $('#tmplNm').val('');
            $('#templateCode').val('');
        }
    }

    //개인화 변수 드래그
    $(document).on('dragstart', function(ev){
        ev.originalEvent.dataTransfer.setData("text", $(ev.target).attr("data"));
    });

    $(document).on('drop', function(ev){
        dropTarget = $(ev.target);

    });

    $(document).on('dragend', function(ev){
        let value = dropTarget.val();
        dropTarget.val("");
        dropTarget.val(value);

        const targetNm = $(dropTarget).attr('name');
        if(targetNm == 'kakao_body'){
            onchangePrevKkoTxt(dropTarget);
        } else if(targetNm == 'sms_body'){
            onchangePrevSmsTxt(dropTarget);
        }
    });

    function onchangePrevSmsTitle(e) {
        smsCreate.titleCount(e, 'sms');
        $('#prev_sms_title').html($(e).val());
    }
    function onchangePrevSmsTxt(e){
        smsCreate.byteCount(e, 'kakao');
        let txt = $(e).val().replaceAll("\n", "<br/>");
        $('#smsTextArea').html(txt);
    }

    function onchangePrevKkoTxt(e){
        smsCreate.byteCount(e, 'kakao');
        $('#prev_ft_txt').html($(e).val().replaceAll("\n", "<br/>"));
    }

    function addRejectText(type){
        const rejectText = $('input[name="rejectText"]:visible');

        if(type == "sms"){
            const txtbox = $('#sms_txt_area');
            if($(rejectText).val() != ''){
                $(txtbox).val($(txtbox).val()+"\n\n"+$(rejectText).val());
                onchangePrevSmsTxt(txtbox);
            }
        }else if(type == "kko_ft"){
            const txtbox = $('textarea.kakao_txt');
            if($(rejectText).val() != ''){
                $(txtbox).val($(txtbox).val()+"\n\n"+$(rejectText).val());
                onchangePrevKkoTxt(txtbox);
            }
        }
    }

</script>



