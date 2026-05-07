<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
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
            <form:form id="form" action="#" method="post" onsubmit="return false;">
            <input type="hidden" id="seq" name="mst_seq" value=""/>
            <input type="hidden" id="usr_grp_cd" name="usr_grp_cd"/>
            <input type="hidden" id="cont_grp_cd" name="cont_grp_cd"/>
            <input type="hidden" id="coupon_seq" name="coupon_seq"/>
            <div class="create_sms cf">
                <div class="row head bottom-border">
                    <div class="th">템플릿 명</div>
                    <div class="td right-border">
                        <input type="text" class="txt_input template_name" name="cont_nm" placeholder="템플릿 명을 입력하세요."/>
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
                    </div>
                </div><!-- //row end -->
                <div class="row head bottom-border">
                    <div class="th">캠페인 명</div>
                    <div class="td right-border">
                        <input type="text" name="camp_nm" class="txt_input " placeholder="캠페인 명을 입력하세요.">
                    </div>
                    <div class="left_flex">
                        <div class="th">팀 명</div>
                        <div class="td">
                            <div class="select">
                                <!-- selected value -->
                                <div class="value" id="team_cd_sel" data="">팀명</div>
                                <ul class="option">
                                    <c:forEach var="team" items="${teamLst}">
                                        <li data="${team.list_val}">${team.list_nm}</li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                        <%--           grp_cd 05일 경우 기본값 설정 후 변경x               --%>
                        <div class="th left-border">회원 번호</div>
                        <div class="td cf" style="width: 100%;">
                            <c:if test="${fn:length(usrKeyLst) <= 0}">
                                <div class="select non_def" id="recv_usr_cd" name="edmDB">
                                    <!-- selected value -->
                                    <div class="value" data="">회원 번호</div>
                                    <ul class="option mappingLst"></ul>
                                </div>
                            </c:if>
                            <c:if test="${fn:length(usrKeyLst) > 0 and usr_cd ne '05'}">
                                <div class="select" id="recv_usr_cd" name="edmDB">
                                    <!-- selected value -->
                                    <div class="value" data="${usrKeyLst[0].list_val}">${usrKeyLst[0].list_val}</div>
                                    <ul class="option mappingLst"></ul>
                                </div>
                            </c:if>
                            <c:if test="${fn:length(usrKeyLst) > 0 and usr_cd eq '05'}">
                                <div class="select" id="recv_usr_cd">
                                    <!-- selected value -->
                                    <div class="value hidden-drop" data="${usrKeyLst[0].list_val}">${usrKeyLst[0].list_val}</div>
                                </div>
                            </c:if>
                        </div>
                        <div class="th left-border">수신 번호</div>
                        <div class="td cf" style="width: 100%;">
                            <c:if test="${fn:length(fromToLst) <= 0}">
                                <div class="select non_def" id="recv_phone_to" name="edmDB">
                                    <!-- selected value -->
                                    <div class="value" data="">개인화 변수</div>
                                    <ul class="option mappingLst">
                                        <%-- 임시 주석 --%>
                                        <%--<li data="phone">phone</li>--%>
                                    </ul>
                                </div>
                                <input type="hidden" id="recv_phone" class="sel_value" name="from_to"/>
                            </c:if>
                            <c:if test="${fn:length(fromToLst) > 0 and usr_cd ne '05'}">
                                <div class="select" id="recv_phone_to" name="edmDB">
                                    <!-- selected value -->
                                    <div class="value" data="${fromToLst[0].list_val}">${fromToLst[0].list_val}</div>
                                    <ul class="option mappingLst"></ul>
                                </div>
                                <input type="hidden" id="recv_phone" name="from_to" value="${fromToLst[0].list_val}"/>
                            </c:if>
                            <c:if test="${fn:length(fromToLst) > 0 and usr_cd eq '05'}">
                                <div class="select" id="recv_phone_to">
                                    <!-- selected value -->
                                    <div class="value hidden-drop" data="${fromToLst[0].list_val}">${fromToLst[0].list_val}</div>
                                </div>
                                <input type="hidden" id="recv_phone" name="from_to" value="${fromToLst[0].list_val}"/>
                            </c:if>
                        </div>
                    </div>
                </div>
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
                                        <input type="text" class="title kakaoTitle" name="cont_sub_list" value="(광고)" placeholder="문자 제목을 입력하세요." maxlength="20"/>
                                        <span class="ex_txt">※ 와이드 리스트형을 제외한 발송에는 반영되지 않습니다.</span>
                                    </div>
                                </div>
                                <div class="row body">
                                    <div class="th">타입</div>
                                    <div class="column_2">
                                        <label class="type_check">
                                            <input type="radio" name="kko_format_type" class="kkoType" value="kko_ft" checked/>
                                            <span>브랜드톡</span>
                                        </label>
                                        <label class="type_check">
                                            <input type="radio" name="kko_format_type" class="kkoType" value="kko_at"/>
                                            <span>알림톡</span>
                                        </label>
                                    </div>
                                </div>
                                <div class="row body">
                                    <div class="th">발신 프로필</div>
                                    <div class="column_1">
                                        <input type="text" class="sms_number smsNumber smsNumber_kko" id="send_to" placeholder ="발신 프로필을 선택해주세요" readonly/>
                                        <input type="hidden" name="send_key" id="send_key"/>
                                        <input type="hidden" name="send_to_list" id="kakao_send_to_num" />
                                        <span class="btn_sm_line" onclick="mobileSenderPopup('1','kko')">변경</span>
                                    </div>
                                </div>
                                <div class="row body" id="brandType">
                                    <div class="th">브랜드톡 양식</div>
                                    <div class="column_1">
                                        <label class="custom_radio en_font">
                                            텍스트/이미지/와이드이미지
                                            <input name="kko_msg_tp" class="lowType" type="radio" value="0" checked />
                                            <span></span>
                                        </label>
                                        <label class="custom_radio en_font">
                                            와이드 리스트형
                                            <input name="kko_msg_tp" class="lowType" type="radio" value="1" />
                                            <span></span>
                                        </label>
                                        <label class="custom_radio en_font">
                                            캐러셀 커머스형
                                            <input name="kko_msg_tp" class="lowType" type="radio" value="2" />
                                            <span></span>
                                        </label>
                                        <label class="custom_radio en_font">
                                            캐러셀 피드형
                                            <input name="kko_msg_tp" class="lowType" type="radio" value="3" />
                                            <span></span>
                                        </label>
                                        <label class="custom_radio en_font">
                                            프리미엄 동영상형
                                            <input name="kko_msg_tp" class="lowType" type="radio" value="4" />
                                            <span></span>
                                        </label>
                                    </div>
                                </div>
                                <div class="row body" id="brandTarget">
                                    <div class="th">브랜드톡 타겟</div>
                                    <div class="column_1">
                                        <label class="custom_radio en_font">
                                            친구톡
                                            <input name="kko_tar_tp" class="lowType" type="radio" value="-" checked />
                                            <span></span>
                                        </label>
                                        <label class="custom_radio en_font" style="display: none" name="kko_target_tp_label" >
                                            M (마케팅 수신동의 전체)
                                            <input name="kko_tar_tp" class="lowType" type="radio" value="M" />
                                            <span></span>
                                        </label>
                                        <label class="custom_radio en_font" style="display: none" name="kko_target_tp_label" >
                                            N (마케팅 수신동의 고객 중 비친구)
                                            <input name="kko_tar_tp" class="lowType" type="radio" value="N" />
                                            <span></span>
                                        </label>
                                        <label class="custom_radio en_font" style="display: none" name="kko_target_tp_label" >
                                            I (채널 친구 - 기존 친구톡)
                                            <input name="kko_tar_tp" class="lowType" type="radio" value="I" />
                                            <span></span>
                                        </label>
                                    </div>
                                </div>
                                <div class="input_area kko_area" id="kko_ft">
                                    <div class="block">
                                        <div class="row">
                                            <div class="th">이미지 선택</div>
                                            <div class="td">
                                                <div class="delete_img" data="kakao">
                                                    <img src="${baseURL}/image/btn_delete1.png" alt="삭제">
                                                </div>
                                                <input type="text" class="txt_input en_font" name="" id="kakaoImage" placeholder="이미지를 선택해 주세요." readonly/>
                                                <span class="btn_sm_line" data="kakaoImage" onclick="imageListPopUp('1','kakaoImage')">선택</span>
                                                <input type="hidden" id="kakao_img_cd" name="kko_img_cd" value="">
                                                <input type="hidden" id="kko_view_img_url" name="kko_view_img_url" maxlength="" value="">
                                                <!-- 프리뷰를 위한 이미지 URL -->
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="th top-border">이미지 링크 주소</div>
                                            <div class="td top-border">
                                                <input type="text" class="txt_input en_font width kakaoImgLink" name="kko_img_url" onblur="smsCreate.imageLinkAdd(this);" placeholder="URL 입력 (http:// 또는 https://필수입력)"/>
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
                                                    <div id="kakaoValue" style="width: 100%; max-height: 173px; overflow: auto; padding-top: 10px;"></div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row" style="height:150px;">
                                            <div class="th bottom-border">내용</div>
                                            <div class="td bottom-border">
                                                <textarea name="kakao_body" class="kakao_txt textarea" cols="30" rows="10" style="width: 100%;height: 100%; resize: none;" onkeyup="onchangePrevKkoTxt(this)"></textarea>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="th">수신거부 문구</div>
                                            <div class="td">
                                                <input type="text" class="txt_input" name="rejectText" style="width: calc(100% - 110px);"
                                                    <c:if test="${fn:trim(rejectText[0].list_nm) != ''}">
                                                        value="${cutil:numberToPhone(rejectText[0].list_val)}"
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
                                            <div class="th">추적 링크 생성</div>
                                            <div class="td">
                                                <input type="text" class="txt_input en_font" id="kakaoTracking" placeholder="URL 입력 (http:// 또는 https://필수입력)"/>
                                                <span class="btn_sm_line trackingLinkBtn">생성</span>
                                                <input type="hidden" name="kko_trackinglink"/>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="block" id="addKakaoLink" style="margin-bottom: 10px;">
                                        <div class="row flex_box double">
                                            <div class="th" style="line-height: 72px;">버튼명</div>
                                            <div class="td first-td right-border">
                                                <input type="text" class="txt_input width kakao_btn_name" name="kkoBtnLst" maxlength="14" placeholder="버튼 링크 제목을 입력해주세요." onkeyup="smsCreate.titleCount(this,'kakao')"/>
                                            </div>
                                            <div class="th" style="line-height: 72px;">버튼 링크 주소</div>
                                            <div class="td flex_box" style="flex-direction: column;">
                                                <div class="row flex_box" style="width: 100%;">
                                                    <div class="th">Pc 링크</div>
                                                    <div class="td flex_box">
                                                        <input type="text" name="kkoBtnUrlLstPc" class="txt_input en_font kakao_btn_linkPc" placeholder="URL 입력 (http:// 또는 https://필수입력)"/>
                                                    </div>
                                                </div>
                                                <div class="row flex_box" style="width: 100%;">
                                                    <div class="th">Mobile 링크</div>
                                                    <div class="td flex_box">
                                                        <input type="text" name="kkoBtnUrlLstMo" class="txt_input en_font kakao_btn_linkMo" placeholder="URL 입력 (http:// 또는 https://필수입력)"/>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="td flex_box" style="width: 273px; align-items: center;">
                                                <div class="arrow arrow-down kakaoLinkArrow" style="width: 44px; height: 37px;"></div>
                                                <div class="arrow arrow-up kakaoLinkArrow" style="width: 44px; height: 37px;"></div>
                                                <input type="button" class="btn_sm_line kakaoLinkBtn" value="생성"/>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="flex_box" style="justify-content: right;">
                                        <input type="button" class="btn_sm_line addKakaoLinkRow" value="추가"/>
                                    </div>
                                </div>
                                <div class="input_area kko_area" id="kko_at" hidden>
                                    <div class="block">
                                        <div class="row">
                                            <div class="th">템플릿 선택</div>
                                            <div class="td">
                                                <div class="delete_tmpl" data="kakao">
                                                    <img src="${baseURL}/image/btn_delete1.png" alt="삭제">
                                                </div>
                                                <input type="text" class="txt_input en_font at_tmpl_data" name="tmpl_nm" id="tmplNm" placeholder="템플릿을 선택해 주세요." readonly/>
                                                <input type="text" name="key_id" id="templateCode" class="at_tmpl_data" readonly hidden/>
                                                <span class="btn_sm_line" data="kakaoImage" onclick="tmplListPopUp('1')">선택</span>
                                                <%--
                                                <!--임시 히든값 -->
                                                <input type="hidden" name="kko_img_cd" value="">
                                                <input type="hidden" name="kko_view_img_url" value="">
                                                --%>
                                                <input type="hidden" name="kko_btn_obj" id="kko_btn_obj" value="">
                                                <!-- 프리뷰를 위한 이미지 URL -->
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%--미리 보기--%>
                            <div class="viewer_area" id="kakao_ft_viewer">
                                <div class="top">브랜드톡 미리보기</div>
                                    <div class="inner">
                                        <div class="row_body">
                                            <div class="round_box">
                                                <div class="kakao_ft" id="prev_ft_img"></div>
                                                <div class="kakao_ft" id="prev_ft_video"></div>
                                                <p class="kakao_txt" id="prev_ft_txt"></p>
                                                <div class="kakao_wide_lst" id="prev_ft_wide_lst">
                                                    <strong class="kakao_wide_lst_strong">
                                                        <span class="kakao_wide_lst_title" id="prev_ft_wide_lst_title">(광고)</span>
                                                    </strong>
                                                    <div class="kakao_wide_lst_main_div">
                                                        <ul class="kakao_wide_lst_ul">
                                                            <li class="kakao_wide_lst_li_first">
                                                                <div class="kakao_wide_lst_li_first_div">
                                                                    <a href="#none" target="_blank" class="kakao_wide_lst_li_first_a" id="prev_ft_wide_lst_img_url1">
                                                                        <img id="prev_ft_wide_lst_img1" src="" alt="" role="presentation" style="min-height: 41px;">
                                                                    </a>
                                                                </div>
                                                                <p class="kakao_wide_lst_li_first_p">
                                                                    <span class="kakao_wide_lst_li_first_span" id="prev_ft_wide_lst_txt1" >리스트 항목 1 내용</span>
                                                                </p>
                                                            </li>
                                                            <li class="kakao_wide_lst_li">
                                                                <div class="kakao_wide_lst_li_div">
                                                                    <a href="#none" target="_blank" class="kakao_wide_lst_li_a" id="prev_ft_wide_lst_img_url2">
                                                                        <img id="prev_ft_wide_lst_img2" src="" alt="" role="presentation" style="min-height: 41px;">
                                                                    </a>
                                                                </div>
                                                                <p class="kakao_wide_lst_li_p">
                                                                    <span class="kakao_wide_lst_li_span" id="prev_ft_wide_lst_txt2">리스트 항목 2 내용</span>
                                                                </p>
                                                            </li>
                                                            <li class="kakao_wide_lst_li">
                                                                <div class="kakao_wide_lst_li_div">
                                                                    <a href="#none" target="_blank" class="kakao_wide_lst_li_a" id="prev_ft_wide_lst_img_url3">
                                                                        <img id="prev_ft_wide_lst_img3" src="" alt="" role="presentation" style="min-height: 41px;">
                                                                    </a>
                                                                </div>
                                                                <p class="kakao_wide_lst_li_p">
                                                                    <span class="kakao_wide_lst_li_span" id="prev_ft_wide_lst_txt3">리스트 항목 3 내용</span>
                                                                </p>
                                                            </li>
                                                            <li class="kakao_wide_lst_li">
                                                                <div class="kakao_wide_lst_li_div">
                                                                    <a href="#none" target="_blank" class="kakao_wide_lst_li_a" id="prev_ft_wide_lst_img_url4">
                                                                        <img id="prev_ft_wide_lst_img4" src="" alt="" role="presentation" style="min-height: 41px;">
                                                                    </a>
                                                                </div>
                                                                <p class="kakao_wide_lst_li_p">
                                                                    <span class="kakao_wide_lst_li_span" id="prev_ft_wide_lst_txt4">리스트 항목 4 내용</span>
                                                                </p>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                <div class="byte">
                                    <span class="en_font kakao_byte">0</span>
                                    <span class="en_font">자</span>(버튼제외)<br><br>
                                    <span class="en_font">※ 텍스트 유형 최대 1000자</span><br>
                                    <span class="en_font">※ 이미지 유형 최대 400자</span><br>
                                    <span class="en_font">※ 와이드 이미지 유형 최대 76자</span>
                                </div>
                            </div>
                            <div class="viewer_area" id="kakao_at_viewer" hidden>
                                <div class="top">알림톡 미리보기</div>
                                <div class="at_inner template_body">
                                    <div class="text">
                                        <div class="row_body">
                                            <div class="round_box">
                                                <div class="round_box head">
                                                    <p>알림톡 도착</p>
                                                </div>
                                                <div class="at_tmpl_data" ></div>
                                                <%--<input type="hidden" class="kakao_txt" name="kakao_body" value="">--%>
                                                <a href="#" class="sms_btn">버튼</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="viewer_area" id="kakao_brand_viewer" hidden="hidden">
                                <div class="top">브랜드톡 미리보기</div>
                                <div class="rcs_inner kko_slide">
                                    <div class="slide_area">
                                        <div class="kko_prev">
                                            <img src="/image/ico_rcs_prev.png" alt="">
                                        </div>
                                        <div class="kko_next">
                                            <img src="/image/ico_rcs_next.png" alt="">
                                        </div>
                                        <div class="swiper-container medium kkoBrandFaSwiper" hidden="hidden">
                                            <div class="swiper-wrapper">
                                                <c:forEach var="idx" begin="0" end="6">
                                                    <div class="swiper-slide slide${idx}">
                                                        <section>
                                                            <div class="img_area">
                                                                <img id="brandFaImgArea${idx}" src="" onerror="this.src = '/image/bg_none.png'" alt=""/>
                                                            </div>
                                                            <c:set var="imgIdx" value="${idx+1}"/>
                                                            <div class="txt_area">
                                                                <h3 id="brandFatitleArea${idx}">
                                                                    타이틀을 입력해주세요.
                                                                </h3>
                                                                <dl class="list_price" >
                                                                    <dd class="dc_price" id="brandFaDiscount${idx}"></dd>
                                                                    <dd class="normal_price" id="brandFaPrice${idx}"></dd>
                                                                    <dd class="sale_percent" id="brandFaPercent${idx}"></dd>
                                                                </dl>
                                                                <div style=" display: block; width: 100%; height: 1px; margin: 8px 1px; background-color: rgba(0, 0, 0, 0.08);"></div>
                                                                <p id="brandFatextArea${idx}" style="padding-top: 10px; overflow-wrap: anywhere; word-break: break-word; white-space: normal;">
                                                                    내용을 입력해주세요.
                                                                </p>
                                                                <c:if test="idx ne 0">
                                                                    <div id="brandFaBtn${idx}" style="display: flex; gap: 12px; align-items: center;">
                                                                        <div class="kakao_link" id="brandFaBtn${idx}_1" data="1" style="display: none"></div>
                                                                        <div class="kakao_link" id="brandFaBtn${idx}_2" data="2" style="display: none"></div>
                                                                    </div>
                                                                </c:if>
                                                            </div>
                                                        </section>
                                                        <div class="text_count">
                                                            <span class="num en_font">
                                                                <span id="brandFatextByte${idx}">0</span>/${idx eq 0 ? '50' : '34'}
                                                            </span>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                            <div class="kko_paging en_font">1/6</div>
                                            <div class="kko_register">수신거부 | 홈 > 친구차단</div>
                                            <div class="text_count">
                                                <p>※ 본문내용 : 카드 당
                                                    <span class="en_font">180</span>
                                                    글자 이내
                                                    <br>
                                                    본문길이 : 최대 3줄
                                                    <br>
                                                </p>
                                            </div>
                                        </div>
                                        <div class="swiper-container medium kkoBrandFcSwiper" hidden="hidden">
                                            <div class="swiper-wrapper">
                                                <c:forEach var="idx" begin="1" end="6">
                                                    <div class="swiper-slide slide${idx}">
                                                        <section>
                                                            <div class="img_area">
                                                                <img id="brandFcImgArea${idx}" src="" onerror="this.src = '/image/bg_none.png'" alt=""/>
                                                            </div>
                                                            <c:set var="imgIdx" value="${idx+1}"/>
                                                            <div class="txt_area">
                                                                <h3 id="brandFctitleArea${idx}">
                                                                    타이틀을 입력해주세요.
                                                                </h3>
                                                                <div style=" display: block; width: 100%; height: 1px; margin: 8px 1px; background-color: rgba(0, 0, 0, 0.08);"></div>
                                                                <p id="brandFctextArea${idx}" style="padding-top: 10px; overflow-wrap: anywhere; word-break: break-word; white-space: normal;">
                                                                    내용을 입력해주세요.
                                                                </p>
                                                                <div id="brandFcBtn${idx}" style="display: flex; gap: 12px; align-items: center;">
                                                                    <div class="kakao_link" id="brandFcBtn${idx}_1" data="1" style="display: none"></div>
                                                                    <div class="kakao_link" id="brandFcBtn${idx}_2" data="2" style="display: none"></div>
                                                                </div>
                                                            </div>
                                                        </section>
                                                        <div class="text_count">
                                                            <span class="num en_font">
                                                                <span id="brandFctextByte${idx}">0</span>/180
                                                            </span>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                            <div class="kko_paging en_font">1/6</div>
                                            <div class="kko_register">수신거부 | 홈 > 친구차단</div>
                                            <div class="text_count">
                                                <p>※ 본문내용 : 카드 당
                                                    <span class="en_font">180</span>
                                                    글자 이내
                                                    <br>
                                                    본문길이 : 최대 3줄
                                                    <br>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- kakao end-->
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
                                            <input type="text" class="title type1 smsTitle" name="cont_sub_list" id="sms_title" onkeyup="onchangePrevSmsTitle(this)" value="(광고)" placeholder="문자 제목을 입력하세요."/>
                                            <span class="title_byte en_font">(최대 40byte)</span>
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
                                        <input type="text" class="sms_number smsNumber" id="sms_send_to" placeholder="발신 번호를 선택 해주세요." readonly/>
                                        <input type="hidden" name="send_to_list" id="sms_send_to_num" value=""/>
                                        <span class="btn_sm_line" onclick="mobileSenderPopup('1','sms')">변경</span>
                                    </div>
                                </div>
                                <div class="input_area left">
                                    <div class="block">
                                        <div class="row">
                                            <div class="th">문자 종류</div>
                                            <div class="td">
                                                <label class="custom_radio">LMS
                                                    <input class="smsType" name="sms_msg_tp" type="radio" value="LMS" checked/>
                                                    <span></span>
                                                </label>
                                                <label class="custom_radio">MMS
                                                    <input class="smsType" name="sms_msg_tp" type="radio" value="MMS"/>
                                                    <span></span>
                                                </label>
                                                <label class="custom_radio">SMS
                                                    <input class="smsType" name="sms_msg_tp" type="radio" value="SMS"/>
                                                    <span></span>
                                                </label>
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
                                                <input type="text" class="txt_input" name="" id="smsImage" placeholder="이미지를 선택해 주세요." readonly/>
                                                <input type="hidden" id="mds_img_cd" name="mds_img_cd" value=""/>
                                                <span class="btn_sm_line" data="smsImage" onclick="imageListPopUp('1', 'smsImage');">선택</span>
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
                                                <div id="smsContsVal" style="width: 100%; max-height: 173px; overflow: auto; padding-top: 10px;"></div>
                                            </div>
                                        </div>
                                        <div class="row"  style="height:150px;">
                                            <div class="th bottom-border">내용</div>
                                            <div class="td bottom-border">
                                                <textarea name="sms_body" class="sms_body textarea" id="sms_txt_area" cols="30" rows="10" style="width: 100%;height: 100%; resize: none;" onkeyup="onchangePrevSmsTxt(this)"></textarea>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="th">수신거부 문구</div>
                                            <div class="td">
                                                <input type="text" class="txt_input" name="rejectText" style="width: calc(100% - 110px);"
                                                    <c:if test="${fn:trim(rejectText[0].list_nm) != ''}">
                                                        value="${cutil:numberToPhone(rejectText[0].list_val)}"
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
                                    <div class="block">
                                        <div class="row send">
                                            <div class="th bottom-border">쿠폰 발송</div>
                                            <div class="td bottom-border">
                                                <button type="button" class="btn list" onclick="couponListPop()">리스트</button>
                                                <div style="flex-grow: 1; display: flex">
                                                    <input type="text" name="" id="couponNameInput" style="max-width: 540px;" placeholder="" readonly/>
                                                    <button type="button" class="close" id="couponCancelBtn" data-dismiss="modal" aria-hidden="true" style="display: none;" onclick="couponCancel();">×</button>
                                                </div>
                                                <button type="button" class="btn apply" onclick="applyCoupon();">사용</button>
                                                <!-- 쿠폰 활성화 시 -->
                                                <button type="button" class="btn preview" onclick="couponPreview('able');">미리보기</button>
                                                <!-- 쿠폰 비활성화 시 -->
                                                <!-- <button type="button" class="btn preview" onclick="couponPreview('disable');">미리보기</button> -->
                                            </div>
                                        </div>
                                        <%--
                                        <div class="row">
                                            <div class="th">Short URL 사용</div>
                                            <div class="td">
                                                <label class="custom_radio">사용함<input class="" name="short_url_yn" type="radio" value="Y" onclick="checkNaverApi();"/><span></span></label>
                                                <label class="custom_radio">사용안함<input class="" name="short_url_yn" type="radio" value="N" checked/><span></span></label>
                                            </div>
                                        </div>
                                        --%>
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
                                    <span class="en_font sms_byte">0</span><span class="en_font">자</span>
                                    <br> <br>
                                    <span class="en_font">※ LMS 유형 최대 2000자</span> <br>
                                    <span class="en_font">※ MMS 유형 최대 1000자</span> <br>
                                    <span class="en_font">※ SMS 유형 최대 90자</span>
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
                                            <label class="custom_radio en_font">
                                                SMS
                                                <input name="rcs_msg_tp" class="lowType" type="radio" value="sms" checked />
                                                <span></span>
                                            </label>
                                            <label class="custom_radio en_font">
                                                LMS
                                                <input name="rcs_msg_tp" class="lowType" type="radio" value="lms" />
                                                <span></span>
                                            </label>
                                        </div>
                                    </div>
                                    <span id="js-title-area">
                                        <input type="hidden" class="title rcsTitle" name="cont_sub_list" readonly ></span>
                                    <div class="row body">
                                        <div class="th">발신 번호</div>
                                        <div class="column_1" id="send_text_column">
                                            <input type="text" class="sms_number smsNumber" id="send_text_rcs" placeholder="발신 번호를 선택 해주세요." readonly/>
                                            <input type="hidden" name="send_to_list" id="text_send_num" value=""/>
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
                                                </div>
                                            </div>
                                            <div class="row rcs_textarea">
                                                <div class="th top-border">내용</div>
                                                <div class="td top-border">
                                                    <textarea class="rcsContents" name="rcs_body" cols="30" rows="10" placeholder="내용을 입력해주세요." onkeyup="rcsCreate.rcsContents(this, 0);"></textarea>
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
                                                    <input type="text" name="rcs_footer" class="txt_input rejection_num width" oninput="rcsCreate.rejection(this);" placeholder="수신거부 번호를 입력해주세요."/>
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
                                                <span class="num en_font">
                                                    <span id="textByte0">0</span>/100</span>
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
                    </div>
                    <!-- RCS end-->
                </div>
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

<div class="layer_pop couponListPop" id="couponListPop">
    <div class="pop_container popup_size1">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
        <div class="pop_title">COUPON</div>
        <div class="pop_inner">
            <form:form id="searchCouponListForm" name="searchCouponListForm" onsubmit="return false">
                <div class="form_search">
                    <div class="radio_type">
                        <label class="block_radio" for="month1">
                            <input type="radio" name="Cperiod" value="12000" id="month1" onclick="checkClicked()" checked/>
                            <span>전체</span>
                        </label>
                        <label class="block_radio" for="month3">
                            <input type="radio" name="Cperiod" value="3" id="month3" onclick="checkClicked()" />
                            <span>3개월</span>
                        </label>
                        <label class="block_radio" for="month6">
                            <input type="radio" name="Cperiod" value="6" id="month6" onclick="checkClicked()" />
                            <span>6개월</span>
                        </label>
                        <label class="block_radio" for="month9">
                            <input type="radio" name="Cperiod" value="9" id="month9" onclick="checkClicked()" />
                            <span>9개월</span>
                        </label>
                        <label class="block_radio" for="month12">
                            <input type="radio" name="Cperiod" value="12" id="month12" onclick="checkClicked()" />
                            <span>12개월</span>
                        </label>
                    </div>
                    <div class="input_txt">
                        <input type="text" name="nm" placeholder="쿠폰 명 검색" onkeyup="if (window.event.keyCode == 13) { getCouponListAtSales('1'); } return false;"  />
                        <input type="button" class="btn_search" id="" value="검색" onclick="getCouponListAtSales('1');" />
                    </div>
                </div>
            </form:form>
            <div id="couponListTable">

            </div>
            <!-- 오류 메시지 영역 -->
            <div class="pop_error_txt blue_point_color" id="targetError"></div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_center" id="couponListOk" onclick="targetCheck(this);" value="확인" />
            </div>
        </div>
    </div>
</div>

<!-- 쿠폰 미리보기 팝업 시작 -->
<div class="layer_pop couponPreview" id="couponPreview">

</div>
<!-- 쿠폰 미리보기 팝업 끝 -->

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
                <h1 class="pop_msg"><span></span> 양식에 맞는 이미지만 보여집니다.</h1>
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
                    <input type="button" class="btn_bg btn_size2 btn_center imageSave" value="저장" onclick="imgSendSave();"/>
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
                        <input type="button" class="btn_search" onclick="mobileListPage('1')" value="검색"/>
                        <input type="hidden" name="pageNo" id="pageNo" value="1"/>
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
        <div class="right">
            <span class="btn_sm_line" onclick="openCreateAt()">알림톡 템플릿 생성</span>
        </div>
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

<form:form id="extentionForm" method="post" target="_blank">
    <input type="hidden" id="extId" name="extId" value="" />
</form:form>

<script>
    let usr_cd = '${usr_cd}';
    let _connection;
    let kakaoBeforeSub = $('input[name="kko_msg_tp"]:checked').val();
    let beforeSub = $('input[name="rcs_msg_tp"]:checked').val();
    let slideData = $('.slide_type').find('.value').attr('data') == undefined ? '0' : $('.slide_type').find('.value').attr('data');
    let firstLoad = true;
    let mstSeq = null;
    let dropTarget = null;
    let bindList = [];
    let kkoBrandFcSwiper, kkoBrandFaSwiper;

    $(function () {
        $('#commonLoading').addClass('active');
        //임시 주석
        <%--mobileInfo(2669);--%>

        $('input[name="dbInfo"]').on('change', function () {
            mappingLst();
        });

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

            if(state == true){
                let tabInx = $('.formatType').index(this);
                $('#js-smsTab li').eq(tabInx).show();

                if(minInx === '' && minInx > tabInx){
                    minInx = tabInx;
                }
                $('#js-smsTab li').eq(minInx).addClass('on').siblings().removeClass('on');
                $('.tab_contents').eq(minInx).addClass('active').siblings().removeClass('active');
            }

            if(checkLength > 0){
                $('.no_data').hide();
                $('#js-btn-area').show();
            }else{
                $('.no_data').show();
                $('#js-btn-area').hide();
            }
        });

        //컨텐츠 포맷 click event
        $(document).on('click', '.formatType', function () {

            let checkLength = $('.formatType').filter(':checked').length;
            let state = $(this).is(':checked');
            let tabInx = $('.formatType').index(this);

            if ((tabInx == 0 || tabInx == 2) && couponSelectSeq != '') {
                popup.popAlert('쿠폰 발송은 문자에서만 사용 가능합니다.');
                return false;
            }

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
            if(checkLength > 0){
                $('.no_data').hide();
                $('#js-btn-area').show();

            }else{
                $('.no_data').show();
                $('#js-btn-area').hide();
            }
        });

        //카카오 링크 버튼 생성 event
        $(document).on('click', '.kakaoLinkBtn', function () {
            const $btn = $(this);
            const btnState = $btn.val(); // '생성' | '삭제'
            const type = $('input[name="kko_msg_tp"]:checked').val();

            if (type === "2" || type === "3") {
                const btnPrefix = (type === "2") ? "brandFaBtn" : "brandFcBtn";
                const buttonPrefix = (type === "2") ? "kkoBtnUrlFa" : "kkoBtnUrlFc";
                const id = this.id;

                const re = new RegExp("^" + buttonPrefix + "(\\d+)_(1|2)$");
                const m = id.match(re);
                if (!m) return;

                const groupNo = Number(m[1]);
                const kind = Number(m[2]);

                const $btn1 = $("#" + btnPrefix + groupNo + "_1");
                const $btn2 = $("#" + btnPrefix + groupNo + "_2");
                const $targetBtn = $("#" + btnPrefix + groupNo + "_" + kind);

                const $name = $("input[name=kkoBtnLst" + groupNo + "_" + kind + "]");
                const $pc = $("input[name=kkoBtnUrlLstPc" + groupNo + "_" + kind + "]");
                const $mo = $("input[name=kkoBtnUrlLstMo" + groupNo + "_" + kind + "]");

                const label = ($name.val() || "").trim();
                const btnPc = ($pc.val() || "").trim();
                const btnMo = ($mo.val() || "").trim();

                const isHttp = (v) => /^https?:\/\//i.test(v);
                if (btnState === "생성") {
                    if (!label) {
                        popup.popAlert('메시지에 노출될 버튼의 이름을 입력해주세요!');
                        return false;
                    }
                    if (!btnPc || !btnMo) {
                        popup.popAlert('버튼 클릭시 이동할 URL을 입력해주세요.');
                        return false;
                    }
                    if (!isHttp(btnPc) || !isHttp(btnMo)) {
                        popup.popAlert('정확한 링크 URL을 입력해주세요.');
                        return false;
                    }

                    $btn1.hide();
                    $btn2.hide();

                    if (kind === 2 && (($btn1.html() || "") === "")) {
                        popup.popAlert('첫번째 버튼이 생성 되지 않았습니다.');
                        return false;
                    } else if (kind === 1) {
                        if (($btn2.html() || "") !== "") $btn2.show();
                    } else {
                        $btn1.show();
                    }

                    $targetBtn.html(label).show();
                    $btn.val('삭제');
                } else { // 삭제
                    $name.val("");
                    $pc.val("");
                    $mo.val("");
                    $btn.val('생성');
                    if(kind === 1){
                        $("#" + btnPrefix + groupNo + "_1").html("");
                        $("#" + btnPrefix + groupNo + "_1").hide();

                        $("#" + btnPrefix + groupNo + "_2").html("");
                        $("#" + btnPrefix + groupNo + "_2").html("");
                        $("#" + btnPrefix + groupNo + "_2").hide();
                    }else {
                        $("#" + btnPrefix + groupNo + "_2").html("");
                        $("#" + btnPrefix + groupNo + "_2").hide();
                    }
                }
            } else {
                const $container = $("#addKakaoLink");
                const totalLen = $container.children().length;
                const thisIdx = $btn.closest(".row.flex_box").index();

                const $name = $('.kakao_btn_name').eq(thisIdx);
                const $pc = $('.kakao_btn_linkPc').eq(thisIdx);
                const $mo = $('.kakao_btn_linkMo').eq(thisIdx);

                const btnName = ($name.val() || "").trim();
                const btnPc = ($pc.val() || "").trim();
                const btnMo = ($mo.val() || "").trim();

                const isHttp = (v) => v && v.substring(0, 4) === 'http';

                if (btnState === '생성') {
                    if (!btnName) {
                        popup.popAlert('메시지에 노출될 버튼의 이름을 입력해주세요!');
                        return false;
                    } else if (!btnPc || !btnMo) {
                        popup.popAlert('버튼 클릭시 이동할 URL을 입력해주세요.');
                        return false;
                    } else if (!isHttp(btnPc) || !isHttp(btnMo)) {
                        popup.popAlert('정확한 링크 URL을 입력해주세요.');
                        return false;
                    }
                    const $viewerBox = $('#kakao_ft_viewer').find('.inner .round_box');
                    $viewerBox.children('a').remove();
                    const rmLst = [];
                    for (let i = 0; i < totalLen; i++) {
                        const $nm = $('.kakao_btn_name').eq(i);
                        const $pcI = $('.kakao_btn_linkPc').eq(i);
                        const $moI = $('.kakao_btn_linkMo').eq(i);
                        const $row = $container.children().eq(i);
                        const nm = ($nm.val() || "").trim();
                        const pc = ($pcI.val() || "").trim();
                        const mo = ($moI.val() || "").trim();
                        if (nm && pc && mo && isHttp(pc) && isHttp(mo)) {
                            const $a = $("<a/>", {href: mo, class: "kakao_link", target: "_blank", rel: "noopener"}).text(nm);
                            $viewerBox.append($a);
                            $nm.prop('readonly', true);
                            $pcI.prop('readonly', true);
                            $moI.prop('readonly', true);
                            $('.kakaoLinkBtn').eq(i).val('삭제');
                        } else {
                            rmLst.push($row);
                        }
                    }
                    rmLst.forEach($r => $r.remove());
                } else { // 삭제
                    const $viewerBox = $('#kakao_ft_viewer').find('.inner .round_box');
                    $viewerBox.children('a.kakao_link').eq(thisIdx).remove();
                    if ($container.children().length === 1) {
                        $btn.val('생성');
                        $name.val('').prop('readonly', false);
                        $pc.val('').prop('readonly', false);
                        $mo.val('').prop('readonly', false);
                    } else {
                        $container.children().eq(thisIdx).remove();
                    }
                }
            }
        });

        // 카카오 행 이동 event
        $(document).on('click', '.kakaoLinkArrow', function(){
            let thisIdx = $(this).closest(".row.flex_box").index();
            let totalLen = $("#addKakaoLink").children().length;
            let row = $(this).closest(".row.flex_box");
            let btnRow = $('#kakao_ft_viewer').find('.inner .round_box').children('a.kakao_link').eq(thisIdx);
            if($(this).hasClass("arrow-up")){
                if(thisIdx !== 0){
                    row.prev().before(row);
                    btnRow.prev().before(btnRow);
                }
            } else if ($(this).hasClass("arrow-down")){
                if(thisIdx !== totalLen-1){
                    row.next().after(row);
                    btnRow.next().after(btnRow);
                }
            }
        });

        $(document).on('click', '.addKakaoLinkRow', function(){
            let totalLen = $("#addKakaoLink").children().length;
            if(totalLen < 5){
                let layout = '<div class="row flex_box double">'
                    + '<div class="th" style="line-height: 72px;">버튼명</div>'
                    + '<div class="td first-td right-border">'
                    + '<input type="text" class="txt_input width kakao_btn_name" name="kkoBtnLst" maxlength="14" placeholder="버튼 링크 제목을 입력해주세요." onkeyup="smsCreate.titleCount(this,\'kakao\')"/>'
                    + '</div>'
                    + '<div class="th" style="line-height: 72px;">버튼 링크 주소</div>'
                    + '<div class="td flex_box" style="flex-direction: column;">'
                    + '<div class="row flex_box" style="width: 100%;">'
                    + '<div class="th">Pc 링크</div>'
                    + '<div class="td flex_box">'
                    + '<input type="text" name="kkoBtnUrlLstPc" class="txt_input en_font kakao_btn_linkPc" placeholder="URL 입력 (http:// 또는 https://필수입력)"/>'
                    + '</div>'
                    + '</div>'
                    + '<div class="row flex_box" style="width: 100%;">'
                    + '<div class="th">Mobile 링크</div>'
                    + '<div class="td flex_box">'
                    + '<input type="text" name="kkoBtnUrlLstMo" class="txt_input en_font kakao_btn_linkMo" placeholder="URL 입력 (http:// 또는 https://필수입력)"/>'
                    + '</div>'
                    + '</div>'
                    + '</div>'
                    + '<div class="td flex_box" style="width: 273px; align-items: center;">'
                    + '<div class="arrow arrow-down kakaoLinkArrow" style="width: 44px; height: 37px;"></div>'
                    + '<div class="arrow arrow-up kakaoLinkArrow" style="width: 44px; height: 37px;"></div>'
                    + '<input type="button" class="btn_sm_line kakaoLinkBtn" value="생성"/>'
                    + '</div>'
                    + '</div>';
                $("#addKakaoLink").append(layout);
            }
        });

        $(document).on('change', '.smsType', function () {
            let smsType = $(this).val();
            if (smsType != 'MMS') {
                $(this).parents('.row').siblings('.input-img').removeClass('on');
                $('#sms_img_box').hide();
            } else {
                $(this).parents('.row').siblings('.input-img').addClass('on');
                $('#sms_img_box').show();
            }
            onchangePrevSmsTxt($('#sms_txt_area'));
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

                    if ($('input[name="kko_thumbnail_img_cd"]').val() != '') {
                        $("#kakaoVideoImg").val('');
                        $("input[name='kko_thumbnail_img_cd']").val('');
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

        $(document).on('click', 'input[name="kko_msg_tp"]', function (event) {
            event.preventDefault();
            check = $('input[name="kko_msg_tp"]:checked');
            let nowSub = $('input[name="kko_msg_tp"]:checked').val();

            if (kakaoBeforeSub != nowSub) {
                let message = "브랜드 톡 양식을 변경할 경우 입력한 내용이 초기화됩니다.";
                let html = '';
                html +=
                    '<div class="layer_pop alert active">' +
                    '<div class="pop_container popup_size3">' +
                    '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
                    '<div class="pop_title">브랜드톡 양식 변경</div>' +
                    '<div class="pop_inner">' +
                    '<div class="alert_txt">' + message + '</div>' +
                    '<div class="btn_row">' +
                    '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="kkoLowTypeChange(check);" value="확인" />' +
                    '<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소" />' +
                    '</div>' +
                    '</div>' +
                    '</div>' +
                    '</div>';
                $('body .layer_pop.alert').remove();
                $('body').append(html);
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
                    $(textContents).val(txt + '{{' + data + '}}');

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
            $('.brandFcContent').eq(nowIndex).addClass('on').siblings().removeClass('on');
            kkoBrandFcSwiper.slideTo(nowIndex);
            $('.brandFaContent').eq(nowIndex).addClass('on').siblings().removeClass('on');
            kkoBrandFaSwiper.slideTo(nowIndex);

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
                mobileListPage("1");
            } else {
                $('.mobileLstPopup').addClass('active');
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

        $(document).on('input', '.kakaoTitle[name="cont_sub_list"]', function (ev) {
            $("#prev_ft_wide_lst_title").html($(this).val());
        });

        kkoBrandFcSwiper = new Swiper('.kkoBrandFcSwiper', {
            direction: 'horizontal',
            centeredSlides: true,
            slidesPerView: 1.2,
            pagination: {
                el: '.kko_paging',
                type: 'fraction',
            },
            navigation: {
                nextEl: '.kko_next',
                prevEl: '.kko_prev',
            },
        });


        kkoBrandFaSwiper = new Swiper('.kkoBrandFaSwiper', {
            initialSlide: 1,
            direction: 'horizontal',
            centeredSlides: true,
            slidesPerView: 1.2,
            pagination: { el: '.kko_paging', type: 'fraction' },
            navigation: { nextEl: '.kko_next', prevEl: '.kko_prev' },
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
            kakaoBeforeSub = $('input[name="kko_msg_tp"]:checked').val();

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
            new Swiper('.slideSwiper', {
                direction: 'horizontal',
                pagination: {
                    el: '.rcs_paging',
                    type: 'fraction',
                },
                navigation: {
                    nextEl: '.rcs_next',
                    prevEl: '.rcs_prev',
                },
            });
            kkoBrandFcSwiper = new Swiper('.kkoBrandFcSwiper', {
                direction: 'horizontal',
                centeredSlides: true,
                slidesPerView: 1.2,
                pagination: {
                    el: '.kko_paging',
                    type: 'fraction',
                },
                navigation: {
                    nextEl: '.kko_next',
                    prevEl: '.kko_prev',
                },
            });
            couponSeq = $("#savedCouponSeq").val();
            couponSelectSeq = $("#savedCouponSeq").val();
            couponNm = $("#savedCouponNm").val();
        }
        let param = {seq: seq}
        com_ajax.ajaxSync('post', '${baseURL}/sf/${usr_cd}/mobileInfo.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}',true)
    }

    $(document).on('blur', 'input[name="kko_video_url"]', function () {
        const input = $.trim($(this).val());
        if (input != '' && input.indexOf('https://tv.kakao.com') !== 0) {
            alert('동영상 URL 은 https://tv.kakao.com 으로 시작 하는 URL만 입력 가능합니다.');
            $(this).val('');
            return false;
        } else {
            if(input != ''){
                const id = input.split('/').pop();
                let vUrl = 'https://play-tv.kakao.com/embed/player/cliplink/'+ id +'?service=player_share';
                let videoHtml = '<iframe src="'+ vUrl +'" width="100%" >';
                $("#prev_ft_video").html(videoHtml);
            }
        }
    });

    // 카카오, SMS 유효성 검사
    function kakaoValidate() {
        let kakaoOption = $('input[name="kko_option"]').val();
        let kakaoTitle = $('.kakaoTitle');
        let kkoType = $("input[name='kko_format_type']:checked").val();
        let kakaoTxt, kakaoFtType;
        if(kkoType == "kko_ft"){
            kakaoTxt = $("textarea.kakao_txt");
            kakaoFtType = $("input[name='kko_msg_tp']:checked").val();
        }else{
            kakaoTxt =  $("input.kakao_txt");
        }
        let kakaoSenderNo = $('.smsNumber_kko');

        if (kakaoSenderNo.val() == '' || kakaoSenderNo.val() == null) {
            popup.popAlert("카카오톡 발신 프로필을 선택해주세요");
            return false;
        }
        if (kakaoOption == 'ad') {
            if (kakaoTitle.val().indexOf('(광고)') != -1) {
                if (kakaoTxt.val() != '' || kakaoFtType == "2") {
                    let type = kakaoTypeValidate(kakaoFtType);
                    if (type == true) {
                        /*
                        $('.kakao_txt').removeAttr("name");
                        $(kakaoTxt).attr("name",'kakao_body');
                        */
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
        }
        return false;
    }

    //카카오 유효성 검사
    function kakaoTypeValidate(kakaoFtType) {
        if (kakaoFtType === "1") {
            const REQUIRED_IDX = [1, 2, 3];

            const mainTitle = $('.kakaoTitle').val() || "";
            if (mainTitle.length > 20) {
                popup.popAlert("와이드 리스트형 제목은 띄어쓰기 포함 20자 이내여야 합니다.");
                return false;
            }
            if (mainTitle.includes("\n") || mainTitle.includes("\r")) {
                popup.popAlert("와이드 리스트형 제목은 줄바꿈이 불가능합니다.");
                return false;
            }
            for (const i of REQUIRED_IDX) {
                const item = $("input[name='kkoItemLst" + i + "']").val();
                const img = $("#kakao_item_img_cd_" + i).val();
                const pcUrl = $("input[name='kkoItemUrlLstPc" + i + "']").val();
                const moUrl = $("input[name='kkoItemUrlLstMo" + i + "']").val();
                if (!item) {
                    popup.popAlert('리스트 ' + i + '번 리스트 항목명을(를) 입력해 주세요.');
                    return false;
                } else if (!img) {
                    popup.popAlert('리스트 ' + i + '번 이미지를(를) 입력해 주세요.');
                    return false;
                } else if (!pcUrl) {
                    popup.popAlert('리스트 ' + i + '번 PC 링크 URL을(를) 입력해 주세요.');
                    return false;
                } else if (!moUrl) {
                    popup.popAlert('리스트 ' + i + '번 모바일 링크 URL을(를) 입력해 주세요.');
                    return false;
                }
            }
            return true;
        } else if(kakaoFtType === "2"){
            const cards = [];
            for (let i = 0; i <= 6; i++) {
                const imageVal = document.getElementById('kakaoImageFa' + i).value.trim();
                const titleVal = document.querySelector('input[name="kkoHeader' + i + '"]').value.trim();
                const bodyVal = document.querySelector('textarea[name="kkoBody' + i + '"]').value.trim();
                let btnNameVal = "";
                if (i > 0) {
                    btnNameVal = document.querySelector('input[name="kkoBtnLst' + i + '_1"]').value.trim();
                }
                cards.push({
                    index: i,
                    image: imageVal,
                    title: titleVal,
                    body: bodyVal,
                    btnName: btnNameVal
                });
            }

            const intro = cards[0];
            const isIntroStarted = (intro.image !== "" || intro.title !== "" || intro.body !== "");

            if (isIntroStarted) {
                if (intro.image === "" || intro.title === "" || intro.body === "") {
                    popup.popAlert("Intro를 작성하시려면 이미지, 타이틀, 내용을 모두 입력해야 합니다.");
                    return false;
                }
                // 인트로 제약 조건
                if (intro.title.length > 20 || intro.title.indexOf('\n') !== -1) {
                    popup.popAlert("Intro 타이틀은 20자 이내이며 줄바꿈이 불가합니다.");
                    return false;
                }
                var introBodyLines = (intro.body.match(/\n/g) || []).length;
                if (intro.body.length > 50 || introBodyLines > 2) {
                    popup.popAlert("Intro 내용은 50자 이내이며 줄바꿈은 최대 2회까지 가능합니다.");
                    return false;
                }
            }

            var activeCardCount = 0;
            for (var j = 1; j <= 6; j++) {
                var card = cards[j];
                var isStarted = (card.image !== "" || card.title !== "" || card.body !== "" || card.btnName !== "");
                if (isStarted) {
                    // 순서 검사: 이전 카드가 비어있는데 현재 카드가 입력된 경우
                    if (activeCardCount < j - 1) {
                        popup.popAlert("카드" + (j - 1) + "을 먼저 작성해야 합니다. 순서대로 입력해주세요.");
                        return false;
                    }
                    // 필수 항목 검사
                    if (card.image === "" || card.title === "" || card.body === "" || card.btnName === "") {
                        popup.popAlert("카드" + j + "의 이미지, 상품명, 내용, 버튼을 모두 입력해주세요.");
                        return false;
                    }

                    // 카드 제약 조건 검사
                    if (card.title.length > 30) {
                        popup.popAlert("카드" + j + " 상품명은 30자 이내여야 합니다.");
                        return false;
                    }
                    var cardBodyLines = (card.body.match(/\n/g) || []).length;
                    if (card.body.length > 34 || cardBodyLines > 1) {
                        popup.popAlert("카드" + j + " 내용은 34자 이내이며 줄바꿈은 1회만 가능합니다.");
                        return false;
                    }
                    if (card.btnName.length > 8) {
                        popup.popAlert("카드" + j + " 버튼명은 8자 이내여야 합니다.");
                        return false;
                    }
                    activeCardCount++;
                }
            }
            // 최소 2개 카드 작성 검사
            if (activeCardCount < 2) {
                popup.popAlert("인트로를 제외하고 최소 2개 이상의 카드를 작성해야 합니다.");
                return false;
            }
            return true;
        }
        else if(kakaoFtType === "3") {
            const MAX_CARD = 6;
            const filled = new Array(MAX_CARD + 1).fill(false);

            for (let n = 1; n <= MAX_CARD; n++) {
                const $card = $("#kakao_item_img_cd_" + n).closest(".brandFcContent");
                if ($card.length > 0) {
                    const imgCd = ($("#kakao_item_img_cd_" + n).val() || "").trim();
                    const title = ($('input[name="kkoHeader' + n + '"]').val() || "").trim();
                    const body = ($('textarea[name="kkoBody' + n + '"]').val() || "").trim();
                    const btn1Nm = ($('input[name="kkoBtnLst' + n + '_1"]').val() || "").trim();
                    const btn2Nm = ($('input[name="kkoBtnLst' + n + '_2"]').val() || "").trim();

                    if (imgCd || title || body || btn1Nm || btn2Nm) {
                        filled[n] = true;
                        if (title.length > 20) {
                            popup.popAlert("카드 " + n + "의 타이틀은 띄어쓰기 포함 20자 이내여야 합니다.");
                            return false;
                        }
                        if (body.length > 180) {
                            popup.popAlert("카드 " + n + "의 내용은 띄어쓰기 포함 180자 이내여야 합니다.");
                            return false;
                        }
                        const brCount = (body.match(/\n/g) || []).length;
                        if (brCount > 10) {
                            popup.popAlert("카드 " + n + "의 내용은 줄바꿈을 최대 10회까지 허용합니다.");
                            return false;
                        }
                        // 버튼명: 8자 제한
                        if (btn1Nm.length > 8 || btn2Nm.length > 8) {
                            popup.popAlert("카드 " + n + "의 버튼명은 띄어쓰기 포함 8자 이내여야 합니다.");
                            return false;
                        }
                    }
                }
            }


            for (let n = 1; n <= 2; n++) {
                const $card = $("#kakao_item_img_cd_" + n).closest(".brandFcContent");
                if ($card.length === 0) {
                    popup.popAlert("카드" + n + " 영역을 찾을 수 없습니다.");
                    return false;
                } else {
                    const imgCd = (($card.find("#kakao_item_img_cd_" + n).val()) || "").trim();
                    const title = (($card.find('input[name="kkoHeader' + n + '"]').val()) || "").trim();
                    const body = (($card.find('textarea[name="kkoBody' + n + '"]').val()) || "").trim();
                    const btn1State = (($card.find("#kkoBtnUrlFc" + n + "_1").val()) || "").trim();
                    const btn2State = (($card.find("#kkoBtnUrlFc" + n + "_2").val()) || "").trim();
                    const createdBtnCnt = (btn1State === "삭제" ? 1 : 0) + (btn2State === "삭제" ? 1 : 0);
                    if (btn2State === "삭제" && btn1State !== "삭제") {
                        popup.popAlert("카드" + n + "는 버튼2를 생성하려면 버튼1을 먼저 생성해야 합니다.");
                        return false;
                    } else if (!imgCd) {
                        popup.popAlert("카드" + n + " 이미지는 필수입니다.");
                        return false;
                    } else if (!title) {
                        popup.popAlert("카드" + n + " 타이틀은 필수입니다.");
                        return false;
                    } else if (!body) {
                        popup.popAlert("카드" + n + " 내용은 필수입니다.");
                        return false;
                    } else if (createdBtnCnt < 1) {
                        popup.popAlert("카드" + n + " 버튼은 최소 1개 이상 생성해야 합니다.");
                        return false;
                    } else {
                        // ok
                    }
                }
            }
            let maxFilled = 0;
            for (let n = 1; n <= MAX_CARD; n++) {
                if (filled[n]) maxFilled = n;
            }
            if (maxFilled <= 2) {
                return true;
            } else {
                const missing = [];
                for (let n = 1; n <= maxFilled; n++) {
                    if (!filled[n]) missing.push(n);
                }
                if (missing.length > 0) {
                    popup.popAlert("카드 " + missing.join(", ") + "를 작성해 주세요.");
                    return false;
                } else {
                    for (let n = 3; n <= maxFilled; n++) {
                        const $card = $("#kakao_item_img_cd_" + n).closest(".brandFcContent");
                        if ($card.length === 0) {
                            popup.popAlert("카드" + n + " 영역을 찾을 수 없습니다.");
                            return false;
                        } else {
                            const imgCd = (($card.find("#kakao_item_img_cd_" + n).val()) || "").trim();
                            const title = (($card.find('input[name="kkoHeader' + n + '"]').val()) || "").trim();
                            const body = (($card.find('textarea[name="kkoBody' + n + '"]').val()) || "").trim();
                            const btn1State = (($card.find("#kkoBtnUrlFc" + n + "_1").val()) || "").trim();
                            const btn2State = (($card.find("#kkoBtnUrlFc" + n + "_2").val()) || "").trim();
                            const createdBtnCnt = (btn1State === "삭제" ? 1 : 0) + (btn2State === "삭제" ? 1 : 0);
                            if (btn2State === "삭제" && btn1State !== "삭제") {
                                popup.popAlert("카드" + n + "는 버튼2를 생성하려면 버튼1을 먼저 생성해야 합니다.");
                                return false;
                            } else if (!imgCd) {
                                popup.popAlert("카드" + n + " 이미지는 필수입니다.");
                                return false;
                            } else if (!title) {
                                popup.popAlert("카드" + n + " 타이틀은 필수입니다.");
                                return false;
                            } else if (!body) {
                                popup.popAlert("카드" + n + " 내용은 필수입니다.");
                                return false;
                            } else if (createdBtnCnt < 1) {
                                popup.popAlert("카드" + n + " 버튼은 최소 1개 이상 생성해야 합니다.");
                                return false;
                            } else {
                                // ok
                            }
                        }
                    }
                    return true;
                }
            }
        } else if (kakaoFtType === "4") {
            const txtRaw = ($("textarea[name='kakao_body']").val() || "");
            const txt = txtRaw.replace(/\r\n/g, "\n").replace(/\r/g, "\n"); // 개행 통일

            const len = Array.from(txt).length; // 유니코드 안전 length
            if (len > 76) {
                $('.kakao_txt').focus();
                popup.popAlert("텍스트 문구는 띄어쓰기 포함 76자를 초과할 수 없습니다.");
                return false;
            }
            const brCount = (txt.match(/\n/g) || []).length;
            if (brCount > 5) {
                $('.kakao_txt').focus();
                popup.popAlert("텍스트 문구는 줄바꿈을 최대 5회까지 허용합니다.");
                return false;
            }
            return true;
        } else {
            const txt = $("textarea[name='kakao_body']").val() || "";
            const kakaoLen = Array.from(txt).length;
            const $kakaoImage = $('#kakaoImage');
            const $kakaoTxt = $('.kakao_txt');
            const hasImage = !!($kakaoImage.val());
            if (!hasImage) {
                if (kakaoLen > 1000) {
                    $kakaoTxt.focus();
                    popup.popAlert("카카오톡 본문 내용은 1000자를 초과할 수 없습니다.");
                    return false;
                } else {
                    return true;
                }
            } else {
                if (kakaoLen > 400) {
                    $kakaoTxt.focus();
                    popup.popAlert("카카오톡 본문 내용이 400자를 초과할 수 없습니다.");
                    return false;
                } else {
                    return true;
                }
            }
            let btnValid = true;
            $("input[name='kkoBtnLst']").each(function(idx) {
                const btnNm = ($(this).val() || "").trim();
                if (btnNm.length > 14) {
                    popup.popAlert((idx + 1) + "번째 버튼명이 14자를 초과했습니다. (띄어쓰기 포함 14자 제한)");
                    $(this).focus();
                    btnValid = false;
                    return false;
                }
            });
        }
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
                        let coupon = couponValidate();
                        if (type == true && coupon == true) {
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
                let coupon = couponValidate();

                if (type == true && coupon == true) {
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

    function couponValidate() {
        if (couponSelectSeq == undefined) {
            return true;
        }
        if (couponSelectSeq.length == 0) {
            return true;
        }
        let smsTxt = $('#sms_txt_area');
        if (smsTxt.val().indexOf("{쿠폰링크}") === -1) {
            popup.popAlert("사용 버튼을 클릭하여 {쿠폰링크}를 입력해주세요");
            return false;
        } else {
            return true;
        }
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
            new Swiper('.previewSlide', {
                direction: 'horizontal',
                pagination: {
                    el: '.rcs_paging',
                    type: 'fraction',
                },
                navigation: {
                    nextEl: '.rcs_next',
                    prevEl: '.rcs_prev',
                },
            });
        }

        swiperEl = $('.previewBrandSlide').length;
        if (swiperEl > 0) {
            new Swiper('.previewBrandSlide', {
                direction: 'horizontal',
                centeredSlides: true,
                slidesPerView: 1.2,
                pagination: {
                    el: '.previewBrandSlidePagign',
                    type: 'fraction',
                },
            });
        }
    }

    // 프리뷰 서비스 랜딩 하기
    function preview() {
        let stop = false;
        const selectedValue = $('input[name="kko_format_type"]:checked').val();
        if(selectedValue == "kko_ft"){
            let kakaoFtType = $("input[name='kko_msg_tp']:checked").val();
            if(kakaoFtType == "0"){
                $('#addKakaoLink .row.flex_box.double').each(function () {
                    const $row = $(this);
                    const $name = $row.find('input.kakaoLinkBtn');
                    const btnName = $row.find('input[name=kkoBtnLst]').val();
                    const pcUrl = $row.find('input[name=kkoBtnUrlLstPc]').val();
                    const moUrl = $row.find('input[name=kkoBtnUrlLstMo]').val();
                    if ((btnName != '' || pcUrl != '' || moUrl != '') && $($name).val() === "생성") {
                        stop = true;
                        popup.popAlert('카카오톡 버튼 생성이 완료 되지 않았습니다!');
                        return false;
                    }
                });
            }
        }
        if (stop) {
          return;
        }

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


    // 템플릿 명 유효성 검사
    function isCheckTemplateName() {
        let cont_nm = $("input[name='cont_nm']").val();
        let rcsType = $("input[name='rcs_format_type']:checked").val();

        if (rcsType === 'slide') {
            btnHiddenRcsSlide()
        } else {
            buttonHiddenAdd()
        }
        preview();
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
        let send_to = $('input[name="callNumber"]:checked').parent('label').find('input[name="sendNumber"]').val();
        let send_nm = $('input[name="callNumber"]:checked').parent('label').find('input[name="sendNm"]').val();
        let addlUseYn = $('input[name="callNumber"]:checked').parent('label').find('input[name="addlUseYn"]').val();
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
        
        if(addlUseYn == "Y"){
            $('label[name="kko_target_tp_label"]').show();
        }else{
            $('label[name="kko_target_tp_label"]').hide();
            $('input[name="kko_target_tp"][value="-"]').prop('checked', true);
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
        let msg;

        const res = function (response) {
            $('.imagePopup').addClass('active');
            $('#imgSetForm .pop_msg span').html(msg);
            let $doc = new DOMParser().parseFromString(response, "text/html");
            $("#bodyDom").html($("#bodyDom", $doc).html());
            $("#pagingDom").html($("#pagingDom", $doc).html());
            $('#imgType').val(type);
        };

        let param = $("#imgSetForm").serializeArray();
        if (type === 'kakaoImage' || type === 'kakaoVideoImg') {
            // 이미지 타입 : Kakao Image
            param.push({name: 'ch_tp', value: 'IMGTP_FT'});
            msg = "브랜드톡"
        } else if (type === 'kakaoImageItemFirst') {
            param.push({name: 'ch_tp', value: 'IMGTP12'});
            msg = "브랜드톡 와이드 리스트(첫번째)"
        } else if (type.startsWith('kakaoImageItem')) {
            param.push({name: 'ch_tp', value: 'IMGTP13'});
            msg = "브랜드톡 와이드 리스트"
        } else if (type.startsWith('kakaoImageFa')) {
            param.push({name: 'ch_tp', value: 'IMGTP14'});
            msg = "캐러셀 커머스형"
        } else if (type.startsWith('kakaoImageFc')) {
            param.push({name: 'ch_tp', value: 'IMGTP15'});
            msg = "캐러셀 피드형"
        } else if (type === 'smsImage') {
            // 이미지 타입 : 문자(MMS)
            param.push({name: 'ch_tp', value: 'IMGTP02'});
            msg = "모바일"
        } else if (type === 'horizontalImage') {
            // 이미지 타입 : RCS 가로형
            param.push({name: 'ch_tp', value: 'IMGTP04'});
            msg = "RCS 가로형"
        } else if (type === 'verticalImage') {
            let rcs_msg_tp = $('input[name="rcs_msg_tp"]').filter(':checked').val();
            if (rcs_msg_tp === 'tall') {
                // 이미지 타입 : RCS 세로형 Tall
                param.push({name: 'ch_tp', value: 'IMGTP05'});
                msg = "RCS 세로형 Tall"
            } else if (rcs_msg_tp === 'medium') {
                // 이미지 타입 : RCS 세로형 Medium
                param.push({name: 'ch_tp', value: 'IMGTP06'});
                msg = "RCS 세로형 Medium"
            }
        } else if (type === 'slideRcsImage') {
            let rcs_msg_tp = $('input[name="rcs_msg_tp"]').val();
            if (rcs_msg_tp === 'small') {
                // 이미지 타입 : RCS 슬라이드 small
                param.push({name: 'ch_tp', value: 'IMGTP07'})
                msg = "RCS 슬라이드 small"
            } else if (rcs_msg_tp === 'medium') {
                // 이미지 타입 : RCS 슬라이드 medium
                param.push({name: 'ch_tp', value: 'IMGTP08'});
                msg = "RCS 슬라이드 medium"
            }
        } else{
            param.push({name: 'ch_tp', value: '-'})
            msg = "-"
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
        let kkoImgurl = $('input[name="contentsImg"]:checked').parent('label').find('input[name="kkoImgurl"]').val(); // 이미지 파일 url

        if (imgLength > 0) {
            imageCreate(imgType, imgUrl, ImgNm, imgCheck, kkoImgurl);
            $('#imagePop').siblings('.pop_error_txt').html('');
            $('.imagePopup').removeClass('active');
        } else {
            return false;
        }
    }

    function imageCreate(type, imageUrl, ImgNm, imgCheck, kkoImgurl) {
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
            } else if(type == 'kakaoVideoImg'){
                $("#kakaoVideoImg").val(ImgNm);
                $('input[name="kko_thumbnail_img_cd"]').val(imgCheck);
                $('#kakaoVideoImg').parent('.td').removeClass('outline');
            } else if(type == 'kakaoImageItemFirst'){
                $("#kakaoImageItemFirst").val(ImgNm);
                $('input[name="kakao_item_img_cd_1"]').val(imgCheck);
                $('input[name="kko_view_item_img_url_1"]').val(kkoImgurl);
                $('#kakaoImageItemFirst').parent('.td').removeClass('outline');
                $("#prev_ft_wide_lst_img1").attr("src", kkoImgurl);
            } else if (type.startsWith('kakaoImageItem')) {
                const idx = type.replace('kakaoImageItem', '');
                $('#' + type).val(ImgNm);
                $('input[name="kakao_item_img_cd_' + idx + '"]').val(imgCheck);
                $('input[name="kko_view_item_img_url_' + idx + '"]').val(kkoImgurl);
                $('#' + type).parent('.td').removeClass('outline');
                $("#prev_ft_wide_lst_img" + idx).attr("src", kkoImgurl);
            } else if (type.startsWith('kakaoImageFa')) {
                const idx = type.replace('kakaoImageFa', '');
                $('#' + type).val(ImgNm);
                $('input[name="kakao_item_img_cd_' + idx + '"]').val(imgCheck);
                $('input[name="kko_view_item_img_url_' + idx + '"]').val(kkoImgurl);
                $('#' + type).parent('.td').removeClass('outline');
                $("#brandFaImgArea" + idx).attr("src", kkoImgurl);
            } else if (type.startsWith('kakaoImageFc')) {
                const idx = type.replace('kakaoImageFc', '');
                $('#' + type).val(ImgNm);
                $('input[name="kakao_item_img_cd_' + idx + '"]').val(imgCheck);
                $('input[name="kko_view_item_img_url_' + idx + '"]').val(kkoImgurl);
                $('#' + type).parent('.td').removeClass('outline');
                $("#brandFcImgArea" + idx).attr("src", kkoImgurl);
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
                new Swiper('.slideSwiper', {
                    direction: 'horizontal',
                    pagination: {
                        el: '.rcs_paging',
                        type: 'fraction',
                    },
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
            '<label class="custom_radio">브랜드톡<input name="ch_tp" type="radio" value="FT" checked><span></span></label>'+
            '<label class="custom_radio">알림톡<input name="ch_tp" type="radio" value="IMGTP09"><span></span></label>'+
            '<label class="custom_radio">알림톡(아이템)<input name="ch_tp" type="radio" value="IMGTP10"><span></span></label>' +
            '<label class="custom_radio">모바일<input name="ch_tp" type="radio" value="IMGTP02"><span></span></label>'+
            '<label class="custom_radio">RCS<input name="ch_tp" type="radio" value="RCS"><span></span></label><br>'+
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
            '<tr class="rcsImgForm ft_option">'+
            '<th>양식</th>'+
            '<td>'+
            '<div class="select style1 ft_select">'+
            '<div class="value" data="IMGTP03">일반</div>'+
            '<ul class="option">'+
            '<li data="IMGTP03">일반</li>'+
            '<li data="IMGTP11">와이드 이미지</li>'+
            '<li data="IMGTP12">와이드 리스트 (첫번째 이미지)</li>'+
            '<li data="IMGTP13">와이드 리스트</li>'+
            '<li data="IMGTP14">캐러셀 커머스</li>'+
            '<li data="IMGTP15">캐러셀 피드</li>'+
            '</ul>'+
            '</div>'+
            '</td>'+
            '</tr>'+
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
            '<ul class="guide_txt guide_lst">'+
                '<li>※ 세로형 : ① Tall : 568 X 528 (1MB 이하), ② Medium : 568 X 336 (1MB 이하)</li>'+
                '<li>※ 슬라이드형 : ① Small : 360 X 336, ② Medium : 696 X 504, 최대 사이즈 360 X 1569 , 1MB 이하</li>'+
            '</ul>'+
            '<ul class="at_guide1 guide_lst" hidden>'+
                '<li style="color: #666666;">※ 이미지 파일은 용량이 500KB 이하인 jpg, png 파일만 등록 가능합니다.</li>'+
                '<li style="color: #666666;">※ 이미지 파일은 가로 500px 이상, 세로 250px 이상이며 가로:세로 비율이 2:1 이어야 합니다.</li>'+
            '</ul>'+
            '<ul class="at_guide2 guide_lst" hidden>'+
                '<li style="color: #666666;">※ 이미지 파일은 용량이 500KB 이하인 jpg, png 파일만 등록 가능합니다.</li>'+
                '<li style="color: #666666;">※ 이미지 파일은 가로 108px 이상이며 가로:세로 비율이 1:1 이어야 합니다.</li>'+
            '</ul>'+
            '<ul class="ft_guide1 guide_lst">'+
                '<li style="color: #666666;">※ 이미지 파일은 용량이 500KB 이하인 jpg, png 파일만 등록 가능합니다.</li>'+
                '<li style="color: #666666;">※ 이미지 파일은 가로 500px 이상이며 </li>'+
                '<li style="color: #666666;">   가로:세로 비율이 2:1 ~ 3:4 또는 세로:가로 비율이 1:2 ~ 4:3 이어야 합니다.</li>'+
            '</ul>'+
            '<ul class="ft_guide2 guide_lst" hidden>'+
                '<li style="color: #666666;">※ 이미지 파일은 용량이 2MB 이하인 jpg, png 파일만 등록 가능합니다.</li>'+
                '<li style="color: #666666;">※ 이미지 파일은 가로 800px(500px 이상) 세로 600px 파일만 등록 가능합니다.</li>'+
            '</ul>'+
            '<ul class="ft_guide3 guide_lst" hidden>'+
                '<li style="color: #666666;">※ 이미지 파일은 용량이 2MB 이하인 jpg, png 파일만 등록 가능합니다.</li>'+
                '<li style="color: #666666;">※ 이미지 파일은 가로 500px 이상 이며 가로:세로 비율이 2:1 이어야 합니다.</li>'+
            '</ul>'+
            '<ul class="ft_guide4 guide_lst" hidden>'+
                '<li style="color: #666666;">※ 이미지 파일은 용량이 2MB 이하인 jpg, png 파일만 등록 가능합니다.</li>'+
                '<li style="color: #666666;">※ 이미지 파일은 가로 500px 이상 이며 가로:세로 비율이 1:1 이어야 합니다.</li>'+
            '</ul>'+
            '<ul class="ft_guide5 guide_lst" hidden>'+
                '<li style="color: #666666;">※ 이미지 파일은 용량이 2MB 이하인 jpg, png 파일만 등록 가능합니다.</li>'+
                '<li style="color: #666666;">※ 이미지 파일은 가로 500px 이상이며 또는 가로:세로 비율이 2:1 또는 3:4 이어야 합니다.</li>'+
                '<li style="color: #666666;">※ 권장사이즈 800x600px 또는 800x400px.</li>'+
            '</ul>'+
            '<div class="left pop_error_txt other_guide guide_lst" hidden>※ 모바일 : Jpg(200KB 이하), 이메일 : jpg, png, gif</div>'+
            '<div class="right pop_error_txt blue_point_color"></div>'+
            '<div class="img_viewer noImg"></div>'+
            '<div class="btn_row">'+
            '<input type="button" class="btn_bg btn_size2 btn_center uploadSave" onclick="saveContentImg();" value="저장" />' +
            '</div>' +
            '</div>' +
            '</div>' +
            '</div>';
        $("#imgListHtml").html(html);
    }
    let isSubmitting = false;

    function saveContentImg() {
        if (isSubmitting) {
            return false;
        }

        let imgNm = $("#img_nmCk").val();
        if (imgNm == "" || imgNm == null) {
            popup.popAlert("이미지명을 입력해주세요.");
            return false;
        }
        if ($("#file").val() == "" || $("#file").val() == null) {
            popup.popAlert("업로드된 파일이 없습니다.");
            return false;
        }

        isSubmitting = true;

        let res = function (response) {
            isSubmitting = false;
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
        if(ch_tp == 'RCS') {
            data.append("ch_tp", $('.rcs_select .value').attr('data'));
        } else if(ch_tp == 'FT') {
            data.append("ch_tp", $('.ft_select .value').attr('data'));
        } else{
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
        $('.at_tmpl_data').val('');  // 템플릿 관련 데이터 삭제
        $('.at_tmpl_data').html('');
        $('.kakao_txt').val('');
    })

    function tmplSendSave() {
        const tmpl = $('#tmplPopUp input[name="tmpl_cd"]:checked');
        const tmplbody =$(tmpl).parents('.template_div').find('.template_body').html();

        $('#kakao_at_viewer .at_inner .row_body').html(tmplbody)
        $('#tmplNm').val($(tmpl).attr('data'));
        $('#templateCode').val($(tmpl).val());

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
    function mobileListPage(nowPage) {
       $('#pageNo').val(nowPage);
        mobileListPaging();
    }

    function mobileListPaging() {
        const res = function (response) {
            $('.mobileLstPopup').addClass('active');
            let $doc = new DOMParser().parseFromString(response, "text/html");
            $("#mobileLstDom").html($("#mobileLstDom", $doc).html());
            $("#mobileLstpagingDom").html($("#mobileLstpagingDom", $doc).html());
        };
        let param = $("#mobileLst").serializeArray();
        param.push({usr_grp_cd: $('#usr_grp_cd').val()});
        com_ajax.ajax('post', '${baseURL}/sf/${usr_cd}/mobileList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    // 모바일 리스트 선택
    function mobileListSave() {
        let len = $('input[name="list"]:checked').length;
        let check = $('input[name="list"]:checked').val();
        if (len > 0) {
            mobileInfo(check);

            $('#recv_usr_cd.non_def  .value').attr('data','').html('회원 번호');
            $('#recv_phone_to.non_def .value').attr('data','').html('개인화 변수');
            $('#recv_phone.sel_value').val('');
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
            $("#brandType").hide();
        } else {
            $('#kakao_ft_viewer').show();
            $('#kakao_at_viewer').hide();

            $('#kakao_at_viewer .at_tmpl_data').val('');
            $('#kakao_at_viewer .at_tmpl_data').html('');
            $('#tmplNm').val('');
            $('#templateCode').val('');
            $("#brandType").show();
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
        smsCreate.byteCount(e, 'sms');
        let txt = $(e).val().replaceAll("\n", "<br/>");
        $('#smsTextArea').html(txt);
    }

    function onchangePrevKkoTxt(e){
        if(kakaoBeforeSub == '4'){
            if ($(e).val().length > 76) {
              alert('최대 76글자까지 입력 가능합니다.');
              $(e).val($(e).val().substring(0, 76));
            }
        }
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

    function openCreateAt(){
        $('#extId').val(dataExtensionId)
        $("#extentionForm").attr("action", "/cont/kko/tmplCreate.mi");
        $('#extentionForm').submit();
    }

    function updAtTmpl(seq){
        $('#extId').val(dataExtensionId)
        $("#extentionForm").attr("action", "/cont/kko/tmplDetail.mi?seq="+seq);
        $('#extentionForm').submit();
    }

    // 컨텐츠 사용여부 변경 event
    function updateUseState(seq, thisVal){
        var state = $(thisVal).val();
        var useValue = "";
        if(state == "Y"){
            useValue = "N";
        }else{
            useValue = "Y";
        }
        let res = function (response) {
            if(response.result == "success"){
                mobileListPaging();
            }
        };
        var param = {seq : seq, use_yn : useValue};
        com_ajax.ajax('post', '${baseURL}/cont/updateMobileUseYn.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    //쿠폰 리스트
    let couponNm = "";
    let couponSelectSeq = "";
    let couponSeq = "";
    const couponListPop = () => {
        getCouponListAtSales('1');
    };

    function getCouponListAtSales(pageNo) {
        const kakaoUseYn = $("input[name='formatType'][value='kakao']").is(":checked");
        const rcsUseYn = $("input[name='formatType'][value='rcs']").is(":checked");
        if (kakaoUseYn || rcsUseYn) {
            popup.popAlert("쿠폰 발송은 문자에서만 사용 가능합니다..");
            return false;
        }

        var data = $('#searchCouponListForm').serializeArray();
        data.push({name: "pageNo", value: pageNo});
        if (selectedExpireMonth != 0) {
            var expireDate = moment().add(Number($('input[name="Cperiod"]:checked').val()), 'months').format('YYYY-MM-DD HH:mm:ss');
            data.push({name: "expire_dt", value: expireDate});
        }
        const res = function (response) {
            var $doc = new DOMParser().parseFromString(response, "text/html");
            $('#couponListTable').html($("#body", $doc).html());

            const couponLayerPop = document.querySelector(".layer_pop.couponListPop");
            couponLayerPop.classList.add("active");
        }

        com_ajax.ajax('post', '${baseURL}/sf/${usr_cd}/coupon/getCouponListAtSales.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    //쿠폰 리스트 선택 시
    const chkCoupon = (seq, nm, item) => {
        if (item.classList.contains('selected') || couponSelectSeq == seq) {
            item.classList.remove('selected');
            showModal({title: '알림', body: '쿠폰 선택이 취소되었습니다.', showCancel: false, onConfirm: function () { couponCancel(); } });
        } else {
            $('#send_tg_tbody .couponClickBtn').each(function () {
                $(this).removeClass('selected');
            });
            item.classList.add('selected');
            couponNm = nm;
            couponSelectSeq = seq;
            targetCheck($("#couponListOk")[0]);
        }
    };

    //쿠폰 리스트 확인 클릭 시
    const targetCheck = (value) => {
        if (couponSelectSeq.length != 0) {
            const couponURLEl = document.querySelector(".input_area .row.send .td input[type='text']");
            couponURLEl.value =  '{' + couponNm +' 쿠폰링크}';
            couponURLEl.style.width = ( (couponURLEl.value.length + 2)  * 9 ) + 'px';
            $("#couponCancelBtn").css("display","flex");

            couponSeq = couponSelectSeq;
            $('#coupon_seq').val(couponSeq);
        }
        popupClose(value);
    };

    //쿠폰 URL 사용(적용)
    const applyCoupon = () => {
        if (couponSeq == "") {
            popup.popAlert("리스트에서 쿠폰을 먼저 선택해주세요.");
            return false;
        }
        const preview = document.querySelector(".viewer_area .inner .text_box .scroll_txt_area");
        //입력된 URL 미리보기에 추가
        preview.innerHTML += '<br/>' + '{쿠폰링크}';
        let smsContent = $('#sms_txt_area').val();
        $('#sms_txt_area').val(smsContent + '\n{쿠폰링크}');
        onchangePrevSmsTxt($('#sms_txt_area'));
    };

    //쿠폰 미리보기
    const couponPreview = (status) => {
        if (couponSeq == "") {
            popup.popAlert("리스트에서 쿠폰을 먼저 선택해주세요.");
            return false;
        }

        const res = function (response) {
            var $doc = new DOMParser().parseFromString(response, "text/html");
            $('#couponPreview').html($("#body", $doc).html());

            const layerPop = document.querySelector(".layer_pop.couponPreview");
            layerPop.classList.add("active");
        }
        var data = {};
        com_ajax.ajax('post', '${baseURL}/sf/${usr_cd}/coupon/getCouponAtSales.ajax?seq='+ couponSeq, data, res, '${_csrf.headerName}', '${_csrf.token}');
    };

    var selectedExpireMonth = 1;
    function checkClicked() {
        var clickNumber = Number($('input[name="Cperiod"]:checked').val());

        if (selectedExpireMonth == clickNumber) {
            $('input[name="Cperiod"]').each(function() {
                $(this).prop('checked', false);
            });
            selectedExpireMonth = 0;
        } else {
            selectedExpireMonth = clickNumber;
        }
        getCouponListAtSales('1');
    }

    function couponCancel() {
        var text = document.getElementById("sms_txt_area").value;
        document.getElementById("sms_txt_area").value = text.replace(/\n\{쿠폰링크\}/gi, '');
        document.getElementById("sms_txt_area").value = text.replace(/\{쿠폰링크\}/gi, '');
        onchangePrevSmsTxt($('#sms_txt_area'));
        $("#couponCancelBtn").css("display","none");
        couponSeq = "";
        couponSelectSeq = "";
        $('#coupon_seq').val('');
        const couponURLEl = document.querySelector(".input_area .row.send .td input[type='text']");
        couponURLEl.value =  '';
    }

    function checkNaverApi() {
        const res = function (response) {
            if (!response.status) {
                $("input:radio[name='short_url_yn']:radio[value='Y']").prop('checked', false); // 선택하기
                $("input:radio[name='short_url_yn']:radio[value='N']").prop('checked', true);
                popup.popAlert('MiCRM 시스템 관리 환경에서 네이버 Short URL 설정이 필요합니다.');
            }
        }
        var data = {};
        com_ajax.ajax('post', '${baseURL}/sf/${usr_cd}/coupon/checkNaverApi.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    const openInnerModal = (name) => {
        const modalName = document.querySelector('.inner_modal.' + name);
        modalName.classList.add("open");
    };
    const closeInnerModal = (el) => {
        el.closest(".inner_modal").classList.remove("open");
    };

    function kkoLowTypeChange(type) {
        let checkType = $(type)[0];
        let radioVal = checkType.value;
        $(type).prop('checked', true);
        $('.layer_pop').removeClass('active');

        let res = function (response) {
            let $doc = new DOMParser().parseFromString(response, "text/html");
            let html = $("html", $doc).prop("outerHTML");
            $('#kko_ft').html(html);

            $("#prev_ft_txt").html("");
            $("#prev_ft_img").html("");
            $("#prev_ft_video").html("");
            $(".kakao_byte").html("0");
            $('#kakao_ft_viewer').find('.inner .round_box a.kakao_link').remove();

            $("#prev_ft_wide_lst_title").html("(광고)");
            for(let i=1; i<=4; i++) {
                $('#prev_ft_wide_lst_img' + i).attr("src", "");
                $('#prev_ft_wide_lst_txt' + i).html("리스트 항목 " + i + " 내용");
            }
            for(let i=1; i<=7; i++) {
                $('#brandFaImgArea' + i).attr("src", "");
                $('#brandFatitleArea' + i).html("타이틀을 입력해주세요.");
                $('#brandFatextArea' + i).html("내용을 입력해주세요.");
                $('#brandFaBtn' + i + '_1').hide().html("");
            }
            for(let i=1; i<=6; i++) {
                $('#brandFcImgArea' + i).attr("src", "");
                $('#brandFctitleArea' + i).html("타이틀을 입력해주세요.");
                $('#brandFctextArea' + i).html("내용을 입력해주세요.");
                $('#brandFcBtn' + i + '_1, #brandFcBtn' + i + '_2').hide().html("");
            }
            if(radioVal === "1"){
                $("#kakao_ft_viewer").show();
                $("#kakao_brand_viewer").hide();
                $("#prev_ft_img").hide();
                $("#prev_ft_video").hide();
                $("#prev_ft_txt").hide();
                $("#prev_ft_wide_lst").show();
            } else if(radioVal === "2"){
                if(kkoBrandFaSwiper) kkoBrandFaSwiper.destroy();
                kkoBrandFaSwiper = new Swiper('.kkoBrandFaSwiper', {
                    initialSlide: 1,
                    direction: 'horizontal',
                    centeredSlides: true,
                    slidesPerView: 1.2,
                    pagination: { el: '.kko_paging', type: 'fraction' },
                    navigation: { nextEl: '.kko_next', prevEl: '.kko_prev' },
                });
                $("#kakao_ft_viewer").hide();
                $("#kakao_brand_viewer").show();
                $(".kkoBrandFaSwiper").show();
                $(".kkoBrandFcSwiper").hide();
            } else if(radioVal === "3"){
                if(kkoBrandFcSwiper) kkoBrandFcSwiper.destroy();
                kkoBrandFcSwiper = new Swiper('.kkoBrandFcSwiper', {
                    direction: 'horizontal',
                    centeredSlides: true,
                    slidesPerView: 1.2,
                    pagination: { el: '.kko_paging', type: 'fraction' },
                    navigation: { nextEl: '.kko_next', prevEl: '.kko_prev' },
                });
                $("#kakao_ft_viewer").hide();
                $("#kakao_brand_viewer").show();
                $(".kkoBrandFaSwiper").hide();
                $(".kkoBrandFcSwiper").show();
            } else {
                $("#kakao_ft_viewer").show();
                $("#kakao_brand_viewer").hide();
                $("#prev_ft_img").show();
                $("#prev_ft_video").show();
                $("#prev_ft_txt").show();
                $("#prev_ft_wide_lst").hide();
            }
        }
        if(radioVal === "1"){
            com_ajax.ajax('get', '/sf/${usr_cd}/brandWideLst.ajax', null, res, '${_csrf.headerName}', '${_csrf.token}', true);
        }else if(radioVal === "2"){
            com_ajax.ajax('get', '/sf/${usr_cd}/brandFa.ajax', null, res, '${_csrf.headerName}', '${_csrf.token}', true);
        }else if(radioVal === "3"){
            com_ajax.ajax('get', '/sf/${usr_cd}/brandFc.ajax', null, res, '${_csrf.headerName}', '${_csrf.token}', true);
        }else if(radioVal === "4"){
            com_ajax.ajax('get', '/sf/${usr_cd}/brandVideo.ajax', null, res, '${_csrf.headerName}', '${_csrf.token}', true);
        }else {
            com_ajax.ajax('get', '/sf/${usr_cd}/brandNormal.ajax', null, res, '${_csrf.headerName}', '${_csrf.token}', true);
        }
        kakaoBeforeSub = radioVal;
        mappingLst();
        adTypeCheck();
    }
</script>

