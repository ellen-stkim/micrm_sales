<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil"%>

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
                                    <c:if test = "${smsCnt ne 0}">
                                        <input name="formatType" type="checkbox" value="sms" class="formatType" />
                                    </c:if>
                                    <c:if test = "${smsCnt eq 0}">
                                        <input name="formatType" type="checkbox" value="sms" class="formatType" disabled/>
                                    </c:if>
                                    <span>문자</span>
                                </label>
                                <label class="custom_check2 rcs">
                                    <c:if test ="${rcsCnt ne 0}">
                                        <input name="formatType" type="checkbox" value="rcs" class="formatType"/>
                                    </c:if>
                                    <c:if test ="${rcsCnt eq 0}">
                                        <input name="formatType" type="checkbox" value="rcs" class="formatType" disabled/>
                                    </c:if>
                                    <span class="en_font">RCS</span>
                                </label>
                            </div>
                            <div class="inner_option area2">
                                <div class="th left-border">유형선택</div>
                                <div class="td cf">
                                    <label class="block_radio on">
                                        <input type="radio" name="commonType"  class="js-ad" value="ad" checked/>
                                        <span>광고</span>
                                    </label>
                                    <label class="block_radio">
                                        <input type="radio" name="commonType" class="js-ad" value="guide" />
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
                                                   placeholder="문자 제목을 입력하세요."/>
                                            <span class="ex_txt">※ 실제 발송에는 반영되지 않습니다.</span>
                                        </div>
                                    </div>
                                    <div class="row body">
                                        <div class="th">발신 번호</div>
                                        <div class="column_1">
                                            <input type="text" class="sms_number smsNumber_kko" id="send_to" placeholder ="발신 번호를 선택 해주세요" readonly/>
                                            <input type="hidden" name="send_to_list" id="kakao_send_to_num" value=""/>
                                        </div>
                                    </div>
                                    <div class="input_area">
                                        <div class="block">
                                            <div class="row">
                                                <div class="th">이미지 선택</div>
                                                <div class="td">
                                                    <div class="delete_img" data="kakao"><img src="${baseURL}/image/btn_delete1.png" alt="삭제">
                                                    </div>
                                                    <input type="text" class="txt_input en_font" name="" id="kakaoImage" placeholder="이미지를 선택해 주세요." readonly/>
                                                    <span class="btn_sm_line" data="kakaoImage" onclick="imageListPopUp('1','kakaoImage')">선택</span>
                                                    <input type="hidden" id="kakao_img_cd" name="kko_img_cd" value=""> <!--임시 히든값 -->
                                                    <input type="hidden" id="kko_view_img_url" name="kko_view_img_url" value=""> <!-- 프리뷰를 위한 이미지 URL -->
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="th top-border">이미지 링크 주소</div>
                                                <div class="td top-border">
                                                    <input type="text" class="txt_input en_font width kakaoImgLink" id="kko_img_url" name="kko_img_url" onblur="smsCreate.imageLinkAdd(this);" placeholder="URL 입력 (http:// 또는 https://필수입력)"/>
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
                                            <div class="row">
                                                <div class="th">개인화 변수</div>
                                                <div class="td">
                                                    <!-- select 영역 시작 -->
                                                    <div class="select" id="kakaoValue" name="edmDB">
                                                        <!-- selected value -->
                                                        <div class="value" data="0">개인화 변수</div>
                                                        <ul class="option mappingLst"></ul>
                                                    </div>
                                                    <!-- select 영역 끝 -->
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block">
                                            <div class="row">
                                                <div class="th bottom-border">버튼 링크 제목</div>
                                                <div class="td bottom-border">
                                                    <input type="text" name="kko_btn_nm" class="txt_input width kakao_btn_name"
                                                           placeholder="버튼 링크 제목을 입력해주세요." onkeyup="smsCreate.titleCount(this,'kakao')"/>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="th bottom-border">버튼 링크 주소</div>
                                                <div class="td bottom-border">
                                                    <input type="text" name="kko_btn_url"
                                                           class="txt_input en_font kakao_btn_link"
                                                           placeholder="URL 입력 (http:// 또는 https://필수입력)"/>
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
                                </div>
                                <div class="viewer_area">
                                    <div class="top">카카오톡 본문 입력창</div>
                                    <div class="inner">
                                        <textarea name="kakao_body" class="kakao_txt textarea" cols="30" rows="10"
                                                  onkeyup="smsCreate.byteCount(this, 'kakao');"></textarea>
                                    </div>
                                    <div class="byte">
                                        <span class="en_font kakao_byte">0</span><span class="en_font">byte</span>(버튼제외)
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
                                                <input type="text" class="title type1 smsTitle" name="cont_sub_list"
                                                       onkeyup="smsCreate.titleCount(this,'sms');" placeholder="문자 제목을 입력하세요."/>
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
                                            <div class="row">
                                                <div class="th">개인화 변수</div>
                                                <div class="td">
                                                    <!-- select 영역 시작 -->
                                                    <div class="select" id="smsContsVal" name="edmDB">
                                                        <!-- selected value -->
                                                        <div class="value" data="0">개인화 변수</div>
                                                        <ul class="option mappingLst">
                                                        </ul>
                                                    </div>
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
                                    <div class="top">문자 본문 입력창</div>
                                    <div class="inner">
<%--                                        <div class="sms_title" id="sms_title"></div>--%>
<%--                                        <div class="sms_img"></div>--%>
                                        <textarea name="sms_body" id="" class="sms_txt textarea" cols="30" rows="10" onkeyup="smsCreate.byteCount(this, 'sms');"></textarea>
                                    </div>
                                    <div class="byte">
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
                                        <input type="radio" name="rcs_format_type" class="rcsType" value="text" checked />
                                        <span>텍스트형</span>
                                    </label>
                                    <%--<label class="type_check"><input type="radio" name="rcs_format_type" class="rcsType" value="horizontal" /><span>가로형</span></label>--%>
                                    <label class="type_check">
                                        <input type="radio" name="rcs_format_type" class="rcsType" value="vertical" />
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
                                            <label class="custom_radio en_font">SMS
                                                <input name="rcs_msg_tp" class="lowType" type="radio" value="sms" checked />
                                                <span></span>
                                            </label>
                                            <label class="custom_radio en_font">LMS
                                                <input name="rcs_msg_tp" class="lowType" type="radio" value="lms"/>
                                                <span></span>
                                            </label>
                                        </div>
                                    </div>
                                    <span id="js-title-area"></span>
                                    <div class="row body">
                                        <div class="th">발신 번호</div>
                                        <div class="column_1" id ="send_text_column">
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
                                                                <input type="text" name="rcs_btn_1" class="txt_input action_name" data="1" onkeyup="rcsCreate.buttonCount(this, 'text');" placeholder="버튼 명을 입력해주세요."/>
                                                                <span class="text-count en_font"><span>0</span>/17</span>
                                                            </div>
                                                        </div>
                                                        <div class="custom_box"></div>
                                                    </div>
                                                </div>
                                                <input type ="hidden" name ="rcs_btn_tp_1" value =""/>
                                                <input type ="hidden" name ="rcs_btn_tp_2" value =""/>
                                                <input type ="hidden" name ="rcs_btn_tp_3" value =""/>
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
                                                        <span class="num en_font"><span id="textByte0">0</span>/100</span>
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
                        <input type="text"  name='img_nm' placeholder="이미지 명 입력"/>
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
                    <input type="button" class="btn_bg btn_size2 btn_center imageSave" value="저장" onclick="imgSendSave();"/>
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
    let usr_cd = '${usr_cd}';
    let beforeSub = $('input[name="rcs_msg_tp"]:checked').val();
    let slideData = $('.slide_type').find('.value').attr('data') == undefined ? '0' : $('.slide_type').find('.value').attr('data');

    function getDBValue() {
        let edmDB = $('#smsContsVal[name="edmDB"] .option').html();
        let defaultDB = $('#smsContsVal[name="defaultDB"] .option').html();

        $('.rcsTitleVal[name="edmDB"] .option').html(edmDB);
        $('.rcsContsVal[name="edmDB"] .option').html(edmDB);
        $('.rcsTitleVal[name="defaultDB"] .option').html(defaultDB);
        $('.rcsContsVal[name="defaultDB"] .option').html(defaultDB);

        $('div[name="edmDB"]').show();
        $('div[name="defaultDB"]').hide();
    }

    // 개인화 변수 조회 - 로컬 테스트용
    function mappingLst() {
        const res = function(response) {
            let list = response.mappingLst;
            let html = '';

            for(let i=0; i<list.length; i++) {
                let item = list[i];
                html += '<li data="' + item.list_val + '">' + item.list_nm + '</li>';
            }
            $('.mappingLst').html(html);
        }
        let param = {usr_grp_cd: $('#usr_grp_cd').val()}
        com_ajax.ajax('post', '/sf/${usr_cd}/mappingLst.ajax', param, res, null, null)
    }

    $(function () {
        $('input[name="dbInfo"]').on('change', function () { getDBValue(); });//end
        getDBValue();

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
        $('.formatType').on('click', function () {
            let checkLength = $('.formatType').filter(':checked').length;
            let state = $(this).is(':checked');
            let tabInx = $('.formatType').index(this);

            if(state == true){
                $('#js-smsTab li').eq(tabInx).show().addClass('on').siblings().removeClass('on');
                $('.tab_contents').eq(tabInx).addClass('active').siblings().removeClass('active');
            }else{
                $('.formatType').each(function(){
                    let eachCheck = $(this).is(':checked');
                    if(eachCheck == true){
                        let tabInx1 = $('.formatType').index(this);
                        $('#js-smsTab li').eq(tabInx1).show().addClass('on').siblings().removeClass('on');
                        $('.tab_contents').eq(tabInx1).addClass('active').siblings().removeClass('active');

                    }else{
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

        // MMS, 카카오 이미지 삭제
        $('.delete_img').on('click', function () {
            let imgElement = $(this).parents('.sms_form').find('.sms_img').children();
            let imgcount = imgElement.length;
            let imgUrl = $(this).next('.txt_input').val();
            let data = $(this).attr('data');

            if (imgcount > 0 || imgUrl != '') {
                if(data == "mms") {
                    // 문자 : 이미지 X버튼 누르면 초기화
                    $("input[name='mds_img_cd']").val('');
                    $("#smsImage").val('');
                    if($("input[name='mms_imgurl']") != '') {
                        $("input[name='mms_imgurl']").val('')
                        $("#js-sms-img").empty();
                    }
                } else if(data == 'kakao') {
                    if($('input[name="kko_img_cd"]').val() != '') {
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

            if(deleteInx == 0) {
                // 1번 이미지 카드 삭제
                $('input[name ="rcs_img_cd_1"]').val('');
            } else if(deleteInx == 1) {
                // 2번 이미지 카드 삭제
                $('input[name ="rcs_img_cd_2"]').val('');
            } else if(deleteInx == 2) {
                // 3번 이미지 카드 삭제
                $('input[name ="rcs_img_cd_3"]').val('');
            } else if(deleteInx == 3) {
                // 4번 이미지 카드 삭제
                $('input[name ="rcs_img_cd_4"]').val('');
            } else if(deleteInx == 4) {
                // 5번 이미지 카드 삭제
                $('input[name ="rcs_img_cd_5"]').val('');
            } else if(deleteInx == 5) {
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
        $(document).on('click', '#recv_phone_to .option li', function() {
            let data = $(this).attr('data');
            if (data != 0) {
                $('#recv_phone').val(data);
            }
        });

        // 카카오 개인 변수 option click event
        $(document).on('click', '#kakaoValue .option li', function() {
            let data = $(this).attr('data');
            let txt = $('.kakao_txt').val();
            if (data != 0) {
                popup.popAlert("개인화 변수 입력 후 Byte 초과시 데이터가 미반영 될 수 있습니다. ");
                $('.kakao_txt').val(txt + '{{' + data + '}}');
            }
        });

        // SMS 제목 개인화 변수 option click event
        $(document).on('click', '#smsTitleVal .option li', function() {
            let data = $(this).attr('data');
            let txt = $('#sms .title').val();
            if (data != 0) {
                popup.popAlert("개인화 변수 입력 후 Byte 초과시 데이터가 미반영 될 수 있습니다.");
                $('#sms .title').val(txt + '{{' + data + '}}');
            }
        });

        // SMS 개인화 변수 option click event
        $(document).on('click', '#smsContsVal .option li', function() {
            let data = $(this).attr('data');
            let txt = $('.sms_txt').val();
            if (data != 0) {
                popup.popAlert("개인화 변수 입력 후 Byte 초과시 데이터가 미반영 될 수 있습니다.");
                $('.sms_txt').val(txt + '{{' + data + '}}');
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
                    $(inputTitle).val(txt + '{{' + data + '}}');
                }
            } else {
                let txt = $(this).parents('.row').siblings().find('.rcsTitle').val();
                let inputTitle = $(this).parents('.row').siblings().find('.rcsTitle');
                if (data != 0) {
                    popup.popAlert("개인화 변수 입력 후 Byte 초과시 데이터가 미반영 될 수 있습니다.");
                    $(inputTitle).val(txt + '{{' + data + '}}');
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
                    $(txtContents).val(txt + '{{' + data + '}}');
                }
            } else {
                let txt = $(this).parents('.row').siblings().find('.rcsContents').val();
                let textContents = $(this).parents('.row').siblings().find('.rcsContents');
                if (data != 0) {
                    popup.popAlert("개인화 변수 입력 후 Byte 초과시 데이터가 미반영 될 수 있습니다.");
                    $(textContents).val(txt + '{{' + data + '}}');
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

        $('.js-ad').on('click',function(){
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

        $('#previewBtn').on('click', function () {
            let tamplate = $('.template_name');
            let smsFormat = $('.formatType:checked').val();
            let smsFormatLength = $('.formatType:checked').length;

            $('.create_sms').find('.outline').removeClass('outline');

            if (tamplate.val() != '') {
                if($('#recv_phone').val() == '' || $('#recv_phone').val() == null) {
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
                    for(let a = 0; a < smsFormatLength; a++){

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
        $('input[name="rcs_format_type"]').on('click', function (event) {
            event.preventDefault();
            check = $('input[name="rcs_format_type"]:checked');
            let nowVal = $('input[name="rcs_format_type"]:checked').val();

            if(beforeType != nowVal){
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
        $(document).on('click','input[name="rcs_msg_tp"]', function (event) {
            event.preventDefault();
            check = $('input[name="rcs_msg_tp"]:checked');
            let nowSub = $('input[name="rcs_msg_tp"]:checked').val();

            if(beforeSub != nowSub){
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
        $(document).on('click','.slide_type .option li',function (event) {
            event.stopPropagation();
            typeValue = $(this).attr('data');

           // console.log("slideData: " + slideData);

            if(slideData  != typeValue){
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
            }if(slideData  == typeValue){
                $('.slide_type .option').stop().slideUp();
            }
            let dataTest = $('.slide_type .option li[data="'+slideData+'"]').text();
            $('.slide_type').find('.value').attr('data',slideData);
            $('.slide_type').find('.value').text(dataTest);
        });

        // 포맷 Tab
        $('#js-smsTab > li').on('click',function(){
            let tab = $('#js-smsTab > li').index(this);
            $(this).addClass('on').siblings().removeClass('on');
            $('.tab_contents').eq(tab).addClass('active').siblings().removeClass('active');
        });
    });

    // 정보 조회
    function mobileInfo() {
        const res = function(response) {
            let list = response.list;
            let filePath = response.filePath;

            if(list == null) {
                $('#seq').val('');
                return false;
            }

            // 템플릿 명
            $('.template_name').val(list[0].cont_nm);

            // 수신 번호
            $('#recv_phone_to .value').data(list[0].from_to);
            $('#recv_phone_to .value').text($('#recv_phone_to li[data="' + list[0].from_to + '"]').text());
            $('#recv_phone_to .value').css('color', 'rgb(34, 34, 34)');
            $("#recv_phone").val(list[0].from_to)

            let a = [];
            // 컨텐츠 포맷
            $('.formatType').each(function() {
                if($(this).val() === 'kakao' && list[0].list_use_yn === 'Y') {
                    $(this).trigger('click');
                } else if($(this).val() === 'sms' && list[1].list_use_yn === 'Y') {
                    $(this).trigger('click');
                } else if($(this).val() === 'rcs' && list[2].list_use_yn === 'Y') {
                    $(this).trigger('click');
                }
            });

            $('#js-smsTab li:visible:first').click();

            // 유형선택
            if(list[0].send_tp == 'SENDTP01') {
                $('input[name="commonType"][value=ad]').trigger('click');
                $('input[name="kko_option"]').val('ad');
                $('input[name="sms_option"]').val('ad');
                $('input[name="rcs_option"]').val('ad');
            } else if(list[0].send_tp == 'SENDTP02') {
                $('input[name="commonType"][value=guide]').trigger('click');
                $('input[name="kko_option"]').val('guide');
                $('input[name="sms_option"]').val('guide');
                $('input[name="rcs_option"]').val('guide');
            }

            // seq
            $('#kakao input[name="list_seq"]').val(list[0].list_seq);
            $('#sms input[name="list_seq"]').val(list[1].list_seq);
            $('#rcs input[name="list_seq"]').val(list[2].list_seq);

            // 카카오톡 시작
            if(list[0].list_use_yn == 'Y') {
                // 문자 제목
                $('.kakaoTitle').val(list[0].cont_sub);

                // 발신 번호
                if(list[0].send_to != null) {
                    $('#send_to').val(list[0].sender + '(' + phoneFormatter(list[0].send_num) + ')');
                    $('#kakao_send_to_num').val(list[0].send_to);
                }

                // 이미지 선택
                $('#kakaoImage').val(list[0].kko_img_nm);
                $('#kakao_img_cd').val(list[0].kko_img_cd);
                if(list[0].kko_img_lst != null) {
                    $('input[name="kko_view_img_url"]').val(filePath + list[0].kko_img_lst);
                }

                // 이미지 링크 주소
                $('input[name="kko_img_url"]').val(list[0].kko_img_url);

                // 이미지 미리보기
                if(list[0].kko_img_lst != null && list[0].kko_img_url == null) {
                    $('#js-kakao-img').html('<a href="' + list[0].kko_img_lst + '" target="_blank"><img src="' + filePath + list[0].kko_img_lst + '"/></a>');
                } else if(list[0].kko_img_lst != null && list[0].kko_img_url != null) {
                    $('#js-kakao-img').html('<a href="' + list[0].kko_img_url + '" target="_blank"><img src="' + filePath + list[0].kko_img_lst + '"/></a>');
                }

                // 버튼 링크 제목
                $('input[name="kko_btn_nm"]').val(list[0].kko_btn_nm);

                // 버튼 링크 주소
                $('input[name="kko_btn_url"]').val(list[0].kko_btn_url);
                if(list[0].kko_btn_url == null) {
                    $('.kakaoLinkBtn').val('생성');
                } else {
                    $('.kakaoLinkBtn').val('삭제');
                }

                // 카카오톡 본문 입력창
                $('textarea[name="kakao_body"]').text(list[0].cont_body);
                if(list[0].kko_btn_nm == null) {
                    $('.kakao_link').remove();
                } else {
                     $('textarea[name="kakao_body"]').after('<a href="' + list[0].kko_btn_url + '" class="kakao_link" target="_blank">' + list[0].kko_btn_nm + '</a>');
                }
            }
            // 카카오톡 끝

            // 문자 시작
            if(list[1].list_use_yn == 'Y') {
                // 문자 제목
                $('.smsTitle').val(list[1].cont_sub);

                // 발신 번호
                if(list[1].send_to != null) {
                    $('#sms_send_to').val(list[1].sender + '(' + phoneFormatter(list[1].send_num) + ')');
                    $('#sms_send_to_num').val(list[1].send_to);
                }

                // 문자 종류
                if(list[1].msg_tp == "DMCH202"){
                    $('input[name="sms_msg_tp"][value="LMS"]').prop('checked', true);
                }else if(list[1].msg_tp == "DMCH203"){
                    let a = $('input[name="sms_msg_tp"][value="MMS"]').prop('checked', true);
                    $(a[0]).parents('.row').siblings('.input-img').addClass('on');
                }else{
                    $('input[name="sms_msg_tp"][value="SMS"]').prop('checked', true);
                }
                // 이미지 선택
                if(list[1].msg_tp === 'DMCH203') {
                    let sms_img_nm_lst = list[1].img_nm_lst.split(',');
                    let sms_img_lst = list[1].img_lst.split(',');
                    if(sms_img_lst[0] && sms_img_lst[0].trim() != ""){
                        $('#smsImage').val(sms_img_nm_lst[0]);
                        $('#mds_img_cd').val(list[1].img_cd_1);

                        $('input[name="mms_imgurl"]').val(sms_img_lst[0]);

                        // 이미지 미리보기
                        $('#js-sms-img').html('<a href="' + sms_img_lst[0] + '" target="_blank"><img src="' + filePath + sms_img_lst[0] + '"/></a>');
                    }
                }
                // 문자 본문 입력창
                $('textarea[name="sms_body"]').text(list[1].cont_body);
            }
            // 문자 끝

            // RCS 시작
            if(list[2].list_use_yn == 'Y') {
                // 포맷카드
                if(list[2].msg_tp == 'DMCH205' || list[2].msg_tp == 'DMCH206') {
                    // RCS TEXT형 Layout
                    $('input[name="rcs_format_type"][value="text"]').prop('checked', true);
                    rcsChangeFormat($('input[name="rcs_format_type"]:checked'));

                    if(list[2].msg_tp == 'DMCH205') {
                        // 카드 양식
                        $('input[name="rcs_msg_tp"][value="sms"]').prop('checked', true);
                        rcsLowTypeChange($('input[name="rcs_msg_tp"]:checked'));

                        // 버튼 액션
                        if(list[2].btnType[0] == 'clipboardAction') {
                            $('input[name="rcs_btn_tp_1"]').val('RBTN01');
                            $('.action_select .value').data('RBTN01');
                            $('.action_select .value').text('복사하기');

                            $('input[name="copy_value"]').val(list[2].btnData[0][0]);
                        } else if(list[2].btnType[0] == 'urlAction') {
                            $('input[name="rcs_btn_tp_1"]').val('RBTN02');
                            $('.action_select .value').data('RBTN02');
                            $('.action_select .value').text('URL연결');

                            $('input[name="url_value"]').val(list[2].btnData[0][0]);
                        } else if(list[2].btnType[0] == 'dialerAction') {
                            $('input[name="rcs_btn_tp_1"]').val('RBTN03');
                            $('.action_select .value').data('RBTN03');
                            $('.action_select .value').text('전화걸기');

                            $('input[name="phone_value_03"]').val(list[2].btnData[0][0]);
                        } else if(list[2].btnType[0] == 'latitude') {
                            $('input[name="rcs_btn_tp_1"]').val('RBTN04');
                            $('.action_select .value').data('RBTN04');
                            $('.action_select .value').text('지도보여주기(좌표)');

                            $('input[name="latitude_value"]').val(list[2].btnData[0][0]);
                            $('input[name="longitude_value"]').val(list[2].btnData[0][1]);
                            $('input[name="location_value_04"]').val(list[2].btnData[0][2]);
                            $('input[name="fallback_url_04"]').val(list[2].btnData[0][3]);
                        } else if(list[2].btnType[0] == 'query') {
                            $('input[name="rcs_btn_tp_1"]').val('RBTN05');
                            $('.action_select .value').data('RBTN05');
                            $('.action_select .value').text('지도보여주기(쿼리)');

                            $('input[name="location_value_05"]').val(list[2].btnData[0][0]);
                            $('input[name="fallback_url_05"]').val(list[2].btnData[0][1]);
                        } else if(list[2].btnType[0] == 'requestLocationPush') {
                            $('input[name="rcs_btn_tp_1"]').val('RBTN06');
                            $('.action_select .value').data('RBTN06');
                            $('.action_select .value').text('현재위치공유');
                        } else if(list[2].btnType[0] == 'calendarAction') {
                            $('input[name="rcs_btn_tp_1"]').val('RBTN07');
                            $('.action_select .value').data('RBTN07');
                            $('.action_select .value').text('캘린더등록');

                            $('input[name="start_date"]').val(list[2].btnData[0][0]);
                            $('input[name="end_date"]').val(list[2].btnData[0][1]);
                            $('input[name="calendar_title"]').val(list[2].btnData[0][2]);
                            $('input[name="calendar_body"]').val(list[2].btnData[0][3]);
                        } else if(list[2].btnType[0] == 'composeAction') {
                            $('input[name="rcs_btn_tp_1"]').val('RBTN08');
                            $('.action_select .value').data('RBTN08');
                            $('.action_select .value').text('메세지전송');

                            $('input[name="phone_value_08"]').val(list[2].btnData[0][0]);
                            $('input[name="message_value"]').val(list[2].btnData[0][1]);
                        }

                        // 버튼 명
                        $('input[name="rcs_btn_1"]').val(list[2].btnText[0]);
                        if(list[2].btnText[0] != null) {
                            $('.rcs_layout .button-name span span').text(list[2].btnText[0].length);
                        }

                        if(list[2].btnText[0] != null) {
                            $('.rcs_btn_wrap').append('<div class="rcs_btn" data="1">' + list[2].btnText[0] + '</div>');
                        }
                    } else if(list[2].msg_tp == 'DMCH206') {
                        // 카드 양식
                        $('input[name="rcs_msg_tp"][value="lms"]').prop('checked', true);
                        rcsChangeFormat($('input[name="rcs_format_type"]:checked'));

                        // 문자 제목
                        $('.rcsTitle').val(list[2].cont_sub);

                        // 버튼 액션
                        for(var i=0; i<3; i++) {
                            if(list[2].btnType[i] == 'clipboardAction') {
                                $('input[name="rcs_btn_tp_' + (idx+1) + '"]').val('RBTN01');
                                $('.action_select[data="' + (idx+1) + '"] .value').data('RBTN01');
                                $('.action_select[data="' + (idx+1) + '"] .value').text('복사하기');

                                $('.custom_box:nth-child(' + (idx+1) + ') input[name="copy_value"]').val(list[2].btnData[i][0]);
                            } else if(list[2].btnType[i] == 'urlAction') {
                                $('input[name="rcs_btn_tp_' + (idx+1) + '"]').val('RBTN02');
                                $('.action_select[data="' + (idx+1) + '"] .value').data('RBTN02');
                                $('.action_select[data="' + (idx+1) + '"] .value').text('URL연결');

                                $('.custom_box:nth-child(' + (idx+1) + ') input[name="url_value"]').val(list[2].btnData[i][0]);
                            } else if(list[2].btnType[i] == 'dialerAction') {
                                $('input[name="rcs_btn_tp_' + (idx+1) + '"]').val('RBTN03');
                                $('.action_select[data="' + (idx+1) + '"] .value').data('RBTN03');
                                $('.action_select[data="' + (idx+1) + '"] .value').text('전화걸기');

                                $('.custom_box:nth-child(' + (idx+1) + ') input[name="phone_value_03"]').val(list[2].btnData[i][0]);
                            } else if(list[2].btnType[i] == 'latitude') {
                                $('input[name="rcs_btn_tp_' + (idx+1) + '"]').val('RBTN04');
                                $('.action_select[data="' + (idx+1) + '"] .value').data('RBTN04');
                                $('.action_select[data="' + (idx+1) + '"] .value').text('지도보여주기(좌표)');

                                $('.custom_box:nth-child(' + (idx+1) + ') input[name="latitude_value"]').val(list[2].btnData[i][0]);
                                $('.custom_box:nth-child(' + (idx+1) + ') input[name="longitude_value"]').val(list[2].btnData[i][1]);
                                $('.custom_box:nth-child(' + (idx+1) + ') input[name="location_value_04"]').val(list[2].btnData[i][2]);
                                $('.custom_box:nth-child(' + (idx+1) + ') input[name="fallback_url_04"]').val(list[2].btnData[i][3]);
                            } else if(list[2].btnType[i] == 'query') {
                                $('input[name="rcs_btn_tp_' + (idx+1) + '"]').val('RBTN05');
                                $('.action_select[data="' + (idx+1) + '"] .value').data('RBTN05');
                                $('.action_select[data="' + (idx+1) + '"] .value').text('지도보여주기(쿼리)');

                                $('.custom_box:nth-child(' + (idx+1) + ') input[name="location_value_05"]').val(list[2].btnData[i][0]);
                                $('.custom_box:nth-child(' + (idx+1) + ') input[name="fallback_url_05"]').val(list[2].btnData[i][1]);
                            } else if(list[2].btnType[i] == 'requestLocationPush') {
                                $('input[name="rcs_btn_tp_' + (idx+1) + '"]').val('RBTN06');
                                $('.action_select[data="' + (idx+1) + '"] .value').data('RBTN06');
                                $('.action_select[data="' + (idx+1) + '"] .value').text('현재위치공유');
                            } else if(list[2].btnType[i] == 'calendarAction') {
                                $('input[name="rcs_btn_tp_' + (idx+1) + '"]').val('RBTN07');
                                $('.action_select[data="' + (idx+1) + '"] .value').data('RBTN07');
                                $('.action_select[data="' + (idx+1) + '"] .value').text('캘린더등록');

                                $('.custom_box:nth-child(' + (idx+1) + ') input[name="start_date"]').val(list[2].btnData[i][0]);
                                $('.custom_box:nth-child(' + (idx+1) + ') input[name="end_date"]').val(list[2].btnData[i][1]);
                                $('.custom_box:nth-child(' + (idx+1) + ') input[name="calendar_title"]').val(list[2].btnData[i][2]);
                                $('.custom_box:nth-child(' + (idx+1) + ') input[name="calendar_body"]').val(list[2].btnData[i][3]);
                            } else if(list[2].btnType[i] == 'composeAction') {
                                $('input[name="rcs_btn_tp_' + (idx+1) + '"]').val('RBTN08');
                                $('.action_select[data="' + (idx+1) + '"] .value').data('RBTN08');
                                $('.action_select[data="' + (idx+1) + '"] .value').text('메세지전송');

                                $('.custom_box:nth-child(' + (idx+1) + ') input[name="phone_value_08"]').val(list[2].btnData[i][0]);
                                $('.custom_box:nth-child(' + (idx+1) + ') input[name="message_value"]').val(list[2].btnData[i][1]);
                            }

                            // 버튼 명
                            $('input[name="rcs_btn_' + (i + 1) + '"]').val(list[2].btnText[i]);
                            if(list[2].btnText[i] != null) {
                                $('.rcs_layout .button-name:nth-child(' + (idx+1) + ') span span').text(list[2].btnText[i].length);
                                $('.rcs_btn_wrap').append('<div class="rcs_btn" data="' + (i+1) + '">' + list[2].btnText[i] + '</div>');
                            }
                        }
                    }

                    // 발신 번호
                    if(list[2].send_to != null) {
                        $('#send_text_rcs').val(list[2].sender + '(' + phoneFormatter(list[2].send_num) + ')');
                        $('#text_send_num').val(list[2].send_to);
                    }

                    // 내용
                    $('textarea[name="rcs_body"]').val(list[2].cont_body);

                    // 무료수신거부
                    $('input[name="rcs_footer"]').val(list[2].rcs_footer);

                    // 발신
                    if(list[2].send_tp == 'SENDTP01') {
                        $('.rcs_head').text('[WEB발신]광고');
                    } else if(list[2].send_tp == 'SENDTP02') {
                        $('.rcs_head').text('[WEB발신]');
                    }

                    $('#textArea0').html(replaceBr(list[2].cont_body));
                } else if(list[2].msg_tp == 'DMCH207' || list[2].msg_tp == 'DMCH208') {
                    // RCS 세로형 Layout
                    $('input[name="rcs_format_type"][value="vertical"]').prop('checked', true);
                    rcsChangeFormat($('input[name="rcs_format_type"]:checked'));

                    if(list[2].msg_tp == 'DMCH207') {
                        // 카드 양식
                        $('input[name="rcs_msg_tp"][value="sms"]').prop('checked', true);
                        rcsLowTypeChange($('input[name="rcs_msg_tp"]:checked'));
                    } else if(list[2].msg_tp == 'DMCH208') {
                        // 카드 양식
                        $('input[name="rcs_msg_tp"][value="sms"]').prop('checked', true);
                        rcsLowTypeChange($('input[name="rcs_msg_tp"]:checked'));
                    }

                    // 발신 번호
                    if(list[2].send_to != null) {
                        $('#send_vertical_rcs').val(list[2].sender + '(' + phoneFormatter(list[2].send_num) + ')');
                        $('#vertical_send_num').val(list[2].send_to);
                    }

                    // 이미지 선택
                    var rcs_img_nm_lst = list[2].img_nm_lst.split(',');
                    if(rcs_img_nm_lst[0] != null) {
                        $('#verticalImage').val(rcs_img_nm_lst[0]);
                    }
                    $('#verticalImg').val(list[2].img_cd_1);

                    // 내용
                    $('textarea[name="rcs_body"]').val(textAreaParsing(list[2].cont_body));

                    // 버튼 액션
                    for(var i=0; i<2; i++) {
                        if(list[2].btnType[i] == 'clipboardAction') {
                            $('input[name="rcs_btn_tp_' + (idx+1) + '"]').val('RBTN01');
                            $('.action_select[data="' + (idx+1) + '"] .value').data('RBTN01');
                            $('.action_select[data="' + (idx+1) + '"] .value').text('복사하기');

                            $('.custom_box:nth-child(' + (idx+1) + ') input[name="copy_value"]').val(list[2].btnData[i][0]);
                        } else if(list[2].btnType[i] == 'urlAction') {
                            $('input[name="rcs_btn_tp_' + (idx+1) + '"]').val('RBTN02');
                            $('.action_select[data="' + (idx+1) + '"] .value').data('RBTN02');
                            $('.action_select[data="' + (idx+1) + '"] .value').text('URL연결');

                            $('.custom_box:nth-child(' + (idx+1) + ') input[name="url_value"]').val(list[2].btnData[i][0]);
                        } else if(list[2].btnType[i] == 'dialerAction') {
                            $('input[name="rcs_btn_tp_' + (idx+1) + '"]').val('RBTN03');
                            $('.action_select[data="' + (idx+1) + '"] .value').data('RBTN03');
                            $('.action_select[data="' + (idx+1) + '"] .value').text('전화걸기');

                            $('.custom_box:nth-child(' + (idx+1) + ') input[name="phone_value_03"]').val(list[2].btnData[i][0]);
                        } else if(list[2].btnType[i] == 'latitude') {
                            $('input[name="rcs_btn_tp_' + (idx+1) + '"]').val('RBTN04');
                            $('.action_select[data="' + (idx+1) + '"] .value').data('RBTN04');
                            $('.action_select[data="' + (idx+1) + '"] .value').text('지도보여주기(좌표)');

                            $('.custom_box:nth-child(' + (idx+1) + ') input[name="latitude_value"]').val(list[2].btnData[i][0]);
                            $('.custom_box:nth-child(' + (idx+1) + ') input[name="longitude_value"]').val(list[2].btnData[i][1]);
                            $('.custom_box:nth-child(' + (idx+1) + ') input[name="location_value_04"]').val(list[2].btnData[i][2]);
                            $('.custom_box:nth-child(' + (idx+1) + ') input[name="fallback_url_04"]').val(list[2].btnData[i][3]);
                        } else if(list[2].btnType[i] == 'query') {
                            $('input[name="rcs_btn_tp_' + (idx+1) + '"]').val('RBTN05');
                            $('.action_select[data="' + (idx+1) + '"] .value').data('RBTN05');
                            $('.action_select[data="' + (idx+1) + '"] .value').text('지도보여주기(쿼리)');

                            $('.custom_box:nth-child(' + (idx+1) + ') input[name="location_value_05"]').val(list[2].btnData[i][0]);
                            $('.custom_box:nth-child(' + (idx+1) + ') input[name="fallback_url_05"]').val(list[2].btnData[i][1]);
                        } else if(list[2].btnType[i] == 'requestLocationPush') {
                            $('input[name="rcs_btn_tp_' + (idx+1) + '"]').val('RBTN06');
                            $('.action_select[data="' + (idx+1) + '"] .value').data('RBTN06');
                            $('.action_select[data="' + (idx+1) + '"] .value').text('현재위치공유');
                        } else if(list[2].btnType[i] == 'calendarAction') {
                            $('input[name="rcs_btn_tp_' + (idx+1) + '"]').val('RBTN07');
                            $('.action_select[data="' + (idx+1) + '"] .value').data('RBTN07');
                            $('.action_select[data="' + (idx+1) + '"] .value').text('캘린더등록');

                            $('.custom_box:nth-child(' + (idx+1) + ') input[name="start_date"]').val(list[2].btnData[i][0]);
                            $('.custom_box:nth-child(' + (idx+1) + ') input[name="end_date"]').val(list[2].btnData[i][1]);
                            $('.custom_box:nth-child(' + (idx+1) + ') input[name="calendar_title"]').val(list[2].btnData[i][2]);
                            $('.custom_box:nth-child(' + (idx+1) + ') input[name="calendar_body"]').val(list[2].btnData[i][3]);
                        } else if(list[2].btnType[i] == 'composeAction') {
                            $('input[name="rcs_btn_tp_' + (idx+1) + '"]').val('RBTN08');
                            $('.action_select[data="' + (idx+1) + '"] .value').data('RBTN08');
                            $('.action_select[data="' + (idx+1) + '"] .value').text('메세지전송');

                            $('.custom_box:nth-child(' + (idx+1) + ') input[name="phone_value_08"]').val(list[2].btnData[i][0]);
                            $('.custom_box:nth-child(' + (idx+1) + ') input[name="message_value"]').val(list[2].btnData[i][1]);
                        }

                        // 버튼 명
                        $('input[name="rcs_btn_' + (i + 1) + '"]').val(list[2].btnText[i]);
                        if(list[2].btnText[i] != null) {
                            $('.rcs_layout .button-name:nth-child(' + (idx+1) + ') span span').text(list[2].btnText[i].length);
                            $('.rcs_btn_wrap').append('<div class="rcs_btn" data="' + (i+1) + '">' + list[2].btnText[i] + '</div>');
                        }
                    }

                    // 내용
                    $('textarea[name="rcs_body"]').val(list[2].cont_body);

                    // 무료수신거부
                    $('input[name="rcs_footer"]').val(list[2].rcs_footer);

                    // 발신
                    $('.rcs_head').text('[WEB발신]');

                    let rcs_img_lst = list[2].img_lst.split(',');
                    if(rcs_img_lst[0] != null) {
                        $('.img_area').html('<img src="' + filePath + rcs_img_lst[0] + '" onerror="this.src=\"/image/bg_none.png\""/>');
                        $('input[name="rcs_img_url_1"]').val(rcs_img_lst[0]);
                    }

                    $('#titleArea0').html(list[2].cont_sub);
                    $('#textArea0').html(list[2].cont_body);
                } else if(list[2].msg_tp == 'DMCH211' || list[2].msg_tp == 'DMCH212') {
                    $('input[name="rcs_format_type"][value="slide"]').prop('checked', true);
                    rcsChangeFormat($('input[name="rcs_format_type"]:checked'));

                    // 카드 양식
                    if(list[2].msg_tp == 'DMCH211' && list[2].cardSize == 3) {
                       $('.slide_type .value').data('0');
                       $('.slide_type .value').text('Small / 3장');
                    } else if(list[2].msg_tp == 'DMCH211' && list[2].cardSize == 4) {
                       $('.slide_type .value').data('1');
                       $('.slide_type .value').text('Small / 4장');
                    } else if(list[2].msg_tp == 'DMCH211' && list[2].cardSize == 5) {
                       $('.slide_type .value').data('2');
                       $('.slide_type .value').text('Small / 5장');
                    } else if(list[2].msg_tp == 'DMCH211' && list[2].cardSize == 6) {
                       $('.slide_type .value').data('3');
                       $('.slide_type .value').text('Small / 6장');
                    } else if(list[2].msg_tp == 'DMCH212' && list[2].cardSize == 3) {
                       $('.slide_type .value').data('4');
                       $('.slide_type .value').text('Medium / 3장');
                    } else if(list[2].msg_tp == 'DMCH212' && list[2].cardSize == 4) {
                       $('.slide_type .value').data('5');
                       $('.slide_type .value').text('Medium / 4장');
                    } else if(list[2].msg_tp == 'DMCH212' && list[2].cardSize == 5) {
                       $('.slide_type .value').data('6');
                       $('.slide_type .value').text('Medium / 5장');
                    } else if(list[2].msg_tp == 'DMCH212' && list[2].cardSize == 6) {
                       $('.slide_type .value').data('7');
                       $('.slide_type .value').text('Medium / 6장');
                    }

                    // 발신 번호
                    if(list[2].send_to != null) {
                        $('#send_slice_rcs').val(list[2].sender + '(' + phoneFormatter(list[2].send_num) + ')');
                        $('#slide_send_num').val(list[2].send_to);
                    }

                    // 카드 그리기
                    let rcs_img_nm_lst = list[2].img_nm_lst.split(',');
                    for(let i=0; i<list[2].cardSize; i++) {
                        // 이미지 선택
                        let imgNm = rcs_img_nm_lst[i];
                        $('#slide' + i).val(imgNm);

                        if(list[2].img_cd_1 != null && i === 0) {
                            $('input[name="rcs_img_cd_' + (i+1) + '"]').val(list[2].img_cd_1);
                        }
                        if(list[2].img_cd_2 != null && i === 1) {
                            $('input[name="rcs_img_cd_' + (i+1) + '"]').val(list[2].img_cd_2);
                        }
                        if(list[2].img_cd_3 != null && i === 2) {
                            $('input[name="rcs_img_cd_' + (i+1) + '"]').val(list[2].img_cd_3);
                        }
                        if(list[2].img_cd_4 != null && i === 3) {
                            $('input[name="rcs_img_cd_' + (i+1) + '"]').val(list[2].img_cd_4);
                        }
                        if(list[2].img_cd_5 != null && i === 4) {
                            $('input[name="rcs_img_cd_' + (i+1) + '"]').val(list[2].img_cd_5);
                        }
                        if(list[2].img_cd_6 != null && i === 5) {
                            $('input[name="rcs_img_cd_' + (i+1) + '"]').val(list[2].img_cd_6);
                        }

                        // 문자 제목
                        $('.rcsTitle:nth-child(' + (i+1) + ')').val(list[2].slideTitle[i]);

                        // 내용
                        $('.rcsContents:nth-child(' + (i+1) + ')').val(textAreaParsing(list[2].slideBody[i]));

                        // 버튼 액션 선택
                        for(let j=0; j<2; j++) {
                            if(list[2].cont_btn_json[i].hasOwnProperty('suggestions')){
                                let btn = list[2].cont_btn_json[i]['suggestions'][j];
                                if (btn && btn.hasOwnProperty('action')){
                                    let btnAction = btn['action'];
                                    if(btnAction.hasOwnProperty('clipboardAction') && btnAction['clipboardAction'].hasOwnProperty('copyToClipboard')) {
                                        rcsBtnType($('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .option > li[data="RBTN01"]'))
                                        $('.rcs_slide_conts:eq(' + i + ') input[name=".slide_rcs_btn_tp_'+ (j + 1)+'"]').val('RBTN01');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').data('RBTN01');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').css('color', 'rgb(34, 34, 34)');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').text('복사하기');
                                        $('.rcs_slide_conts:eq(' + i + ') input[name="copy_value"]:eq(' + j + ')').val(btnAction['clipboardAction']['copyToClipboard']['text']);
                                    }
                                    if(btnAction.hasOwnProperty('urlAction') && btnAction['urlAction'].hasOwnProperty('openUrl')) {
                                        rcsBtnType($('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .option > li[data="RBTN02"]'))
                                        $('.rcs_slide_conts:eq(' + i + ') input[name=".slide_rcs_btn_tp_'+ (j + 1)+'"]').val('RBTN02');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').data('RBTN02');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').css('color', 'rgb(34, 34, 34)');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').text('URL연결');
                                        $('.rcs_slide_conts:eq(' + i + ') input[name="url_value"]:eq(' + j + ')').val(btnAction['urlAction']['openUrl']['url']);
                                    }
                                    if(btnAction.hasOwnProperty('dialerAction')) {
                                        rcsBtnType($('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .option > li[data="RBTN03"]'))
                                        $('.rcs_slide_conts:eq(' + i + ') input[name=".slide_rcs_btn_tp_'+ (j + 1)+'"]').val('RBTN03');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').data('RBTN03');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').css('color', 'rgb(34, 34, 34)');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').text('전화걸기');
                                        $('.rcs_slide_conts:eq(' + i + ') input[name="phone_value_03"]:eq(' + j + ')').val(btnAction['dialerAction']['dialPhoneNumber']['phoneNumber']);
                                    }
                                    if(btnAction.hasOwnProperty('mapAction')
                                        && btnAction['mapAction'].hasOwnProperty('showLocation')
                                        && btnAction['mapAction']['showLocation'].hasOwnProperty('location')
                                        && btnAction['mapAction']['showLocation']['location'].hasOwnProperty('latitude')) {
                                        rcsBtnType($('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .option > li[data="RBTN04"]'))
                                        $('.rcs_slide_conts:eq(' + i + ') input[name=".slide_rcs_btn_tp_'+ (j + 1)+'"]').val('RBTN04');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').data('RBTN04');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').css('color', 'rgb(34, 34, 34)');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').text('지도보여주기(좌표)');
                                        $('.rcs_slide_conts:eq(' + i + ') input[name="latitude_value"]:eq(' + j + ')').val(btnAction['mapAction']['showLocation']['location']['latitude']);
                                        $('.rcs_slide_conts:eq(' + i + ') input[name="longitude_value"]:eq(' + j + ')').val(btnAction['mapAction']['showLocation']['location']['longitude']);
                                        $('.rcs_slide_conts:eq(' + i + ') input[name="location_value_04"]:eq(' + j + ')').val(btnAction['mapAction']['showLocation']['location']['label']);
                                        $('.rcs_slide_conts:eq(' + i + ') input[name="fallback_url_04"]:eq(' + j + ')').val(btnAction['mapAction']['showLocation']['fallbackUrl']);
                                    }
                                    if(btnAction.hasOwnProperty('mapAction')
                                        && btnAction['mapAction'].hasOwnProperty('showLocation')
                                        && btnAction['mapAction']['showLocation'].hasOwnProperty('location')
                                        && btnAction['mapAction']['showLocation']['location'].hasOwnProperty('query')) {
                                        rcsBtnType($('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .option > li[data="RBTN05"]'))
                                        $('.rcs_slide_conts:eq(' + i + ') input[name=".slide_rcs_btn_tp_'+ (j + 1)+'"]').val('RBTN05');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').data('RBTN05');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').css('color', 'rgb(34, 34, 34)');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').text('지도보여주기(쿼리)');
                                        $('.rcs_slide_conts:eq(' + i + ') input[name="location_value_05"]:eq(' + j + ')').val(btnAction['mapAction']['showLocation']['location']['query']);
                                        $('.rcs_slide_conts:eq(' + i + ') input[name="fallback_url_05"]:eq(' + j + ')').val(btnAction['mapAction']['showLocation']['fallbackUrl']);
                                    }
                                    if(btnAction.hasOwnProperty('mapAction') && btnAction['mapAction'].hasOwnProperty('showLocation')) {
                                        rcsBtnType($('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .option > li[data="RBTN06"]'))
                                        $('.rcs_slide_conts:eq(' + i + ') input[name=".slide_rcs_btn_tp_'+ (j + 1)+'"]').val('RBTN06');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').data('RBTN06');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').css('color', 'rgb(34, 34, 34)');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').text('현재위치공유');
                                    }
                                    if(btnAction.hasOwnProperty('calendarAction')) {
                                        rcsBtnType($('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .option > li[data="RBTN07"]'))
                                        $('.rcs_slide_conts:eq(' + i + ') input[name=".slide_rcs_btn_tp_'+ (j + 1)+'"]').val('RBTN07');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').data('RBTN07');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').css('color', 'rgb(34, 34, 34)');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').text('캘린더등록');
                                        let startTime = btnAction['calendarAction']['createCalendarEvent']['startTime'].split('T');
                                        let endTime = btnAction['calendarAction']['createCalendarEvent']['endTime'].split('T');
                                        $('.rcs_slide_conts:eq(' + i + ') input[name="start_date"]:eq(' + j + ')').val(startTime[0]);
                                        $('.rcs_slide_conts:eq(' + i + ') input[name="end_date"]:eq(' + j + ')').val(endTime[0]);
                                        $('.rcs_slide_conts:eq(' + i + ') input[name="calendar_title"]:eq(' + j + ')').val(btnAction['calendarAction']['createCalendarEvent']['title']);
                                        $('.rcs_slide_conts:eq(' + i + ') input[name="calendar_body"]:eq(' + j + ')').val(btnAction['calendarAction']['createCalendarEvent']['description']);
                                    }
                                    if(btnAction.hasOwnProperty('composeAction')) {
                                        rcsBtnType($('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .option > li[data="RBTN08"]'))
                                        $('.rcs_slide_conts:eq(' + i + ') input[name=".slide_rcs_btn_tp_'+ (j + 1)+'"]').val('RBTN08');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').data('RBTN08');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').css('color', 'rgb(34, 34, 34)');
                                        $('.rcs_slide_conts:eq(' + i + ') .action_select:eq(' + j + ') .value').text('메세지전송');
                                        $('.rcs_slide_conts:eq(' + i + ') input[name="phone_value_08"]:eq(' + j + ')').val(btnAction['composeAction']['composeTextMessage']['phoneNumber']);
                                        $('.rcs_slide_conts:eq(' + i + ') input[name="message_value"]:eq(' + j + ')').val(btnAction['composeAction']['composeTextMessage']['text']);
                                    }

                                    // 버튼 명
                                    if(btnAction.hasOwnProperty('displayText')) {
                                        $('.rcs_slide_conts:eq(' + i + ') input[name="slide_rcs_btn_1"]:eq(' + j + ')').val(btnAction['displayText']);
                                        $('.rcs_slide_conts:eq(' + i + ') .button-name:eq(' + j + ') span span').text(btnAction['displayText'].length);
                                    }
                                }
                            }
                        }

                        if(imgNm != null) {
                            let rcs_img_lst = list[2].img_lst.split(',');
                            $('.slide' + i + ' .img_area').html('<img src="' + rcs_img_lst[i] + '" onerror="this.src = \"/image/bg_none.png\""/>');
                            $('input[name="rcs_img_url_' + (i+1) + '"]').val(rcs_img_lst[i]);
                        }

                        $('#titleArea' + i).text(list[2].slideTitle[i]);
                        $('#textArea' + i).text(list[2].slideBody[i]);
                        /*
                        if(list[2].cont_btn_json[i].hasOwnProperty('suggestions')){
                            if(list[2].cont_btn_json[i]['suggestions'][0]
                                && list[2].cont_btn_json[i]['suggestions'][0].hasOwnProperty("action")
                                && list[2].cont_btn_json[i]['suggestions'][0]['action'].hasOwnProperty('displayText')) {
                                $('.rcs_btn_wrap:nth-child(' + (i+1) + ')').append('<div class="rcs_btn" data="1">' + list[2].cont_btn_json[i]['suggestions'][0]['action']['displayText'] + '</div>');
                            }

                            if(list[2].cont_btn_json[i]['suggestions'][1]
                                && list[2].cont_btn_json[i]['suggestions'][1].hasOwnProperty("action")
                                && list[2].cont_btn_json[i]['suggestions'][1]['action'].hasOwnProperty('displayText')) {
                                $('.rcs_btn_wrap:nth-child(' + (i+1) + ')').append('<div class="rcs_btn" data="2">' + list[2].cont_btn_json[i]['suggestions'][1]['action']['displayText'] + '</div>');
                            }
                        }
                        */
                    }

                    // 무료수신거부
                    $('input[name="rcs_footer"]').val(list[2].rcs_footer);
                }
            }
            // RCS 끝
        }
        let param = {seq: $('#seq').val()}
        com_ajax.ajax('post', '${baseURL}/sf/${usr_cd}/mobileInfo.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}')
    }

    // 카카오, SMS 유효성 검사
    function kakaoValidate() {
        let kakaoOption = $('input[name="kko_option"]').val();
        let kakaoTitle = $('.kakaoTitle');
        let kakaoTxt = $('.kakao_txt');
        let kakaoSenderNo = $('.smsNumber_kko');

        //console.log("kakaoOption : " + kakaoOption);


        if(kakaoSenderNo.val() == '' || kakaoSenderNo.val() == null){
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
                popup.popAlert("카카오톡 광고성 메시지 제목에 '(광고)'입력이 필수 입니다.");
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
        if(kakaoImage.val() == '' || kakaoImage.val() == null){
            if(kakaoByte > 2000){
                kakaoTxt.focus();
                popup.popAlert("카카오톡 본문 내용이 2000byte를 초과할 수 없습니다.");
                return false;
            }
        }else if(kakaoImage.val() != '' || kakaoImage.val() != null){
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
        let smsTxt = $('.sms_txt');
        let smsNumber = $('.smsNumber')
        let smsNumberValue = $('#sms_send_to').val().trim();

        if(smsNumberValue == '' || smsNumberValue == null) {
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
        let smsTxt = $('.sms_txt');

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

            if(smsNumberValue == '' || smsNumberValue == null) {
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

            if(smsNumberValue == '' || smsNumberValue == null) {
                popup.popAlert("RCS 발신 번호를 입력해주세요.");
                return false;
            }

            let verticalImg = $("#verticalImg").val();
            if(verticalImg == '' ||  verticalImg == null) {
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

            if(smsNumberValue == '' || smsNumberValue == null) {
                popup.popAlert("RCS 발신 번호를 입력해주세요.");
                return false;
            }

            let ad = adCheck();
            let slideData = $('.slide_type').find('.value').attr('data') == undefined ? '0' : $('.slide_type').find('.value').attr('data');
            let isCheckSlideType = "";

            if(slideData == 0 || slideData == 1 || slideData == 2 || slideData == 3) {
                isCheckSlideType = "small"
            } else {
                isCheckSlideType = "medium"
            }

            if (ad == true) {
                for (let s = 0; s < slideLength; s++) {
                    let section = $('.rcs_slide_conts').eq(s);
                    for (let b = 0; b < slideLength; b++) {
                        if (s == b) {
                            if(isCheckSlideType == 'medium' && s >= 1 ) {
                                // 첫 번째 미디엄 슬라이드 경우 고려 X
                                let nowSection = $('.rcs_slide_conts').eq(s);
                                let nowImage = nowSection.find('.rcsImage').val();
                                if(nowImage != '') {
                                    // 이미지를 선택했을때 앞에 이미지가 비어있는 경우 에러 발생
                                    for(let k =0; k <=s; k ++) {
                                        let section = $('.rcs_slide_conts').eq(k);
                                        let rcsImage = $(section).find('.rcsImage').val();
                                        //console.log("rcsImage : " + k + " 번째 : " + rcsImage);
                                        if(rcsImage == ''){
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
                            if($(section).find('.rcsImage').val() == '' && isCheckSlideType == 'small') {
                                popup.popAlert('RCS 슬라이드형 Small은 이미지가 필수 값 입니다.'  + '<br/>' + '카드' + (s + 1) + '에 이미지를 등록해주세요.');
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
                }if (buttonName != '') {
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
        if(swiperEl > 0){
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
        const res = function(response) {
            let $doc = new DOMParser().parseFromString(response, "text/html");
            let html = $("#js-area-popup",$doc).html();
            let dynamic = $("#preview").html(html);
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
        const res = function (response) {
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
        let param = {cont_nm: cont_nm, cont_grp_cd: $('#cont_grp_cd').val(), seq: $('#seq').val()}
        com_ajax.ajax('post', '${baseURL}/sf/${usr_cd}/isCheckTmplateNm.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}')
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
        } else {
            // 타입이 RCS 라면
            param.push({name: 'list_tp_id', value: 'CH02'});
            param.push({name: 'list_dt_id', value: 'DMTP04'});
        }

        param.push({name: 'pageNo', value: nowPage, usr_grp_cd: $('#usr_grp_cd').val()})

        com_ajax.ajax('post', '${baseURL}/sf/${usr_cd}/senderMobileList.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');
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
            param.push({name: 'ch_tp', value: 'IMGTP03'});
        } else if (type === 'smsImage') {
            // 이미지 타입 : 문자(MMS)
            param.push({name: 'ch_tp', value: 'IMGTP02'});
        } else if (type === 'horizontalImage') {
            // 이미지 타입 : RCS 가로형
            param.push({name: 'ch_tp', value: 'IMGTP04'});
        } else if (type === 'verticalImage') {
            var rcs_msg_tp = $('input[name="rcs_msg_tp"]').filter(':checked').val();
            if (rcs_msg_tp === 'tall') {
                // 이미지 타입 : RCS 세로형 Tall
                param.push({name: 'ch_tp', value: 'IMGTP05'});
            } else if (rcs_msg_tp === 'medium') {
                // 이미지 타입 : RCS 세로형 Medium
                param.push({name: 'ch_tp', value: 'IMGTP06'});
            }
        } else if (type === 'slideRcsImage') {
            var rcs_msg_tp = $('input[name="rcs_msg_tp"]').val();
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

       /* console.log("imgType : " + imgType);
        console.log("imgCheck : " + imgCheck);
        console.log("imgLength : " + imgLength);
        console.log("ImgNm : " + ImgNm);
        console.log("imgUrl : " + imgUrl);*/

        if (imgLength > 0) {
            //console.log("test length");
            /*if(imgType === 'kakaoImage'){
                console.log("카카오 : " + seq )
                imageCreate(imgType,imgUrl,orgNm,imgCheck);
            } else if(imgType === 'smsImage'){
                imageCreate(imgType,imgUrl,orgNm,imgCheck);
            }*/
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
                $('#kakao').find('.sms_img').children().remove();
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

        if(checkType == 'text'){
            let res = function(response){
                let $doc = new DOMParser().parseFromString(response, "text/html");
                let html = $("#textArea", $doc).html();
                let dynamic = $('#js-replace').html(html);
                getDBValue();
                adTypeCheck();
            }
            com_ajax.ajaxSync('get', '/sf/${usr_cd}/rcsText.ajax', null, res, '${_csrf.headerName}', '${_csrf.token}');
        }
        if(checkType == 'vertical'){
            let res = function(response){
                let $doc = new DOMParser().parseFromString(response, "text/html");
                let html = $("#verticalArea", $doc).html();
                let dynamic = $('#js-replace').html(html);
                getDBValue();
                adTypeCheck();
            }
            com_ajax.ajaxSync('get', '/sf/${usr_cd}/rcsVertical.ajax', null, res, '${_csrf.headerName}', '${_csrf.token}');
        }
        if(checkType == 'slide'){
            let res = function(response){
                let $doc = new DOMParser().parseFromString(response, "text/html");
                let html = $("#slideArea", $doc).html();
                let dynamic = $('#js-replace').html(html);
                getDBValue();
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
            com_ajax.ajaxSync('get', '/sf/${usr_cd}/rcsSlide.ajax', null, res, '${_csrf.headerName}', '${_csrf.token}');
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
        $('.rcsContsVal[name="edmDB"] .value').attr('data','0').text('개인화 변수').css('color','#cccccc');
        $('.rcsContsVal[name="defaultDB"] .value').attr('data','0').text('개인화 변수').css('color','#cccccc');
        $('.rcsTitle[name="edmDB"] .value').attr('data','0').text('개인화 변수').css('color','#cccccc');
        $('.rcsTitle[name="defaultDB"] .value').attr('data','0').text('개인화 변수').css('color','#cccccc');

        if(radioVal == 'sms'){
            buttonReplace('text', 1, 17);
            $('#js-txt-replace').html(
                '<div class="text_type">'
                    +'<div class="scroll_txt">'
                        +'<p class="rcs_area" id="textArea0">내용 영역</p>'
                    +'</div>'
                    +'<div class="rcs_btn_wrap"></div>'
                 +'</div>'
                 +'<div class="rcs_register">무료 수신거부 : <span id="rejectionArea"></span></div>'
                +'<div class="text_count">'
                    +'<span class="num en_font"><span id="textByte0">0</span>/100</span>'
                +'<p>※ 본문내용 : <span class="en_font">100</span>글자 이내</p>'
                +'</div>'
            );
        }if(radioVal == 'lms'){

            buttonReplace('text', 3, 17);
            $('#js-title-area').html(
                '<div class="row body">'
                + '<div class="th">문자 제목</div>'
                + '<div class="column_1">'
                + '<input type="text" class="title rcsTitle" name="cont_sub_list" placeholder="최대 30자 이내 입력" onkeyup="rcsCreate.rcsTitle(this, 0);">'
                + '<div class="select column_4 left-border rcsTitleVal" name="edmDB">'
                + '<div class="value" data="0">개인화 변수</div>'
                    + '<ul class="option"></ul>'
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
                +'<h3 class="rcs_title" id="titleArea0">제목 영역</h3>'
                +'<div class="scroll_txt">'
                +'<p class="rcs_area" id="textArea0">내용 영역</p>'
                +'</div>'
                +'<div class="rcs_btn_wrap"></div>'
                +'</div>'
                +'<div class="rcs_register">무료 수신거부 : <span id="rejectionArea"></span></div>'
                +'<div class="text_count">'
                +'<span class="num en_font"><span id="textByte0">0</span>/1300</span>'
                +'<p>※ 본문내용 : <span class="en_font">1300</span>글자 이내</p>'
                +'</div>'
            );
        }
        if(radioVal == 'tall' || radioVal == 'medium'){
            $('#verticalImage').val('');
            $('input[name="verticalImg"]').val('');

            buttonReplace('vertical', 2, 17);
            view +=      '<div class="img_area"></div>'
                        +'<div class="txt_area">'
                        +'<h3 id="titleArea0">제목 영역</h3>'
                        +'<p id="textArea0">내용 영역</p>'
                        +'<div class="rcs_btn_wrap"></div>'
                        +'</div>';

            if(radioVal == 'tall'){
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
            }else{
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
        getDBValue();
        adTypeCheck();
    }

    //RCS 버튼 Replace
    function buttonReplace(type, length, textCount){
        let html = '';

        for(let a= 0; a < length; a++){
            html += '<div class="block">'
                +'<div class="row">'
                +'<div class="th bottom-border">버튼 액션 선택</div>'
                +'<div class="td bottom-border">'
                +'<div class="select action_select" data="' + (a+1) + '">'
                +'<div class="value" data="0">액션선택</div>'
                +'<ul class="option">'
                +'<li data="0">액션선택</li>'
                +'<li data="RBTN01">복사하기</li>'
                +'<li data="RBTN02">URL연결</li>'
                +'<li data="RBTN03">전화걸기</li>'
                +'<li data="RBTN04">지보보여주기(좌표)</li>'
                +'<li data="RBTN05">지도보여주기(쿼리)</li>'
                +'<li data="RBTN06">현재위치공유</li>'
                +'<li data="RBTN07">캘린더등록</li>'
                +'<li data="RBTN08">메시지전송</li>'
                +'</ul>'
                +'</div>'
                +'</div>'
                +'</div>'
                +'<div class="row">'
                +'<div class="th">버튼 명</div>'
                +'<div class="td button-name">'
                +'<input type="text" name="rcs_btn_' + Number(a+1) + '" class="txt_input action_name" data="' + Number(a+1) +'"'
                +'placeholder="버튼 명을 입력해주세요." onkeyup="rcsCreate.buttonCount(this,' + '\'' + type + '\'' + ');">'
                + '<span class="text-count en_font"><span>0</span>/' + textCount + '</span>'
                +'</div>'
                +'</div>'
                +'<div class="custom_box"></div>'
                +'</div>';
        }
        $('#btn-action-area').html(html);
    }

    // RCS 슬라이드형 카드 양식 변경
    function rcsSlideChange(type){

        $('.layer_pop').removeClass('active');
        slideData = type;
        let layout = slideLayout(type);
        $('#js-rcs-area').html(layout);

        if (typeValue <= 3) {
            $('input[name="rcs_msg_tp"]').val("small");
        } else {
            $('input[name="rcs_msg_tp"]').val("medium");
        }

        getDBValue();
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

    // 광고/안내 체크
    function adTypeCheck(){
        let adType = $('.js-ad').filter(':checked').val();
        let kakao = $('input[name="kko_option"]');
        let sms = $('input[name="sms_option"]');
        let rcs = $('input[name="rcs_option"]');

        if(adType == 'ad'){
            kakao.val('ad');
            sms.val('ad');
            rcs.val('ad');
            $('.rcs_head').html('[WEB발신]광고');
        }else{
            kakao.val('guide');
            sms.val('guide');
            rcs.val('guide');
            $('.rcs_head').html('[WEB발신]');
        }
    }


    // 2021-05-04 -> RCS 가로형 삭제 (이미지 업로드)
    function imgUploadPop() {
        var html ='<div class="layer_pop uploadPopup active" style="z-index:960;">'+
            '<div class="pop_container popup_size1">'+
            '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />'+
            '<div class="pop_title">새 이미지 파일 업로드</div>'+
            '<div class="pop_inner">'+
            '<table class="pop_table_type1">'+
            '<colgroup>'+
            '<col width="103" />'+
            '<col width="*" />'+
            '</colgroup>'+
            '<tbody>'+
            '<tr>'+
            '<th>채널</th>'+
            '<td>'+
            '<label class="custom_radio">모바일<input name="ch_tp" type="radio" value="IMGTP02" checked><span></span></label>'+
            '<label class="custom_radio">카카오<input name="ch_tp" type="radio" value="IMGTP03"><span></span></label>'+
            '<label class="custom_radio">RCS<input name="ch_tp" type="radio" value="RCS"><span></span></label>'+
            '</td>'+
            '</tr>'+
            '<tr class="rcsImgForm rcs_option">'+
            '<th>양식</th>'+
            '<td>'+
            '<div class="select style1 rcs_select">'+
            '<div class="value" data="">RCS 양식 선택</div>'+
            '<ul class="option">'+
            '<li data="0">RCS 양식 선택</li>' +
            '<li data="IMGTP05">세로형 / Tall</li>'+
            '<li data="IMGTP06">세로형 / Medium</li>'+
            '<li data="IMGTP07">슬라이드형 / Small</li>'+
            '<li data="IMGTP08">슬라이드형 / Medium</li>'+
            '</ul>'+
            '</div>'+
            '</td>'+
            '</tr>'+
            '<tr>'+
            '<th>이미지 명</th>'+
            '<td>'+
            '<input type="text" placeholder="이미지 명을 입력해주세요." id="img_nmCk" name="img_nm" class="input_type1" />'+
            '</td>'+
            '</tr>'+
            '<tr>'+
            '<th>이미지 파일</th>'+
            '<td>'+
            '<input type="text" id="fileName" name="fileName" class="input_file" placeholder="이미지 파일을 선택해주세요." readonly />'+
            '<span class="btn_file">파일 선택<input type="file" class="file" id="file"/></span>'+
            '</td>'+
            '</tr>'+
            '</tbody>'+
            '</table>'+
            '<ul class="guide_txt">'+
            '<li>※ 세로형 : ① Tall : 568 X 528 (1MB 이하), ② Medium : 568 X 336 (1MB 이하)</li>'+
            '<li>※ 슬라이드형 : ① Small : 360 X 336, ② Medium : 696 X 504, 최대 사이즈 360 X 1569 , 1MB 이하</li>'+
            '</ul>'+
            '<div class="left pop_error_txt other_guide">※ 모바일 : Jpg, png(200KB 이하), 이메일 : jpg, png, gif</div>'+
            '<div class="right pop_error_txt blue_point_color"></div>'+
            '<div class="img_viewer noImg"></div>'+
            '<div class="btn_row">'+
            '<input type="button" class="btn_bg btn_size2 btn_center uploadSave" onclick="saveContentImg();" value="저장" />'+
            '</div>'+
            '</div>'+
            '</div>'+
            '</div>';
        $("#imgListHtml").html(html);
    }

    function saveContentImg() {
        var imgNm = $("#img_nmCk").val();
        if(imgNm == "" || imgNm == null){
            popup.popAlert("이미지명을 입력해주세요.");
            return false;
        }
        if( $("#file").val() == "" ||  $("#file").val() == null){
            popup.popAlert("업로드된 파일이 없습니다.");
            return false;
        }

        var res = function(response){
            //TO-DO
            //리스트 새로 불러오기
            if(response.imgCheck == 0){
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

        var data = new FormData();
        data.append("file", $("#file")[0].files[0]);
        var ch_tp = $("input[name=ch_tp]:checked").val();
        if(ch_tp == 'RCS') {
            data.append("ch_tp", $('.rcs_select .value').attr('data'));
        }else{
            data.append("ch_tp", ch_tp);
        }
        data.append("img_nm", imgNm);
        data.append("usr_grp_cd", $('#usr-grp_cd').val());

        com_ajax.ajax_file('${baseURL}/sf/${usr_cd}/contentUpload.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

    function phoneFormatter(num){
        var formatNum;

        if(num != null) {
            if(num.length==11){
                formatNum = num.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
            }else if(num.length==8){
                formatNum = num.replace(/(\d{4})(\d{4})/, '$1-$2');
            }else{
                if(num.indexOf('02')==0){
                    formatNum = num.replace(/(\d{2})(\d{4})(\d{4})/, '$1-$2-$3');
                }else{
                    formatNum = num.replace(/(\d{3})(\d{3})(\d{4})/, '$1-$2-$3');
                }
            }
        }

        return formatNum;
    }

    function replaceBr(s) {
        if(s == null) {
            return null;
        } else {
            return s.replace(/(\r\n|\r|\n|\n\r|\\\\r\\\\n)/gi, "<br>");
        }
    }

    function textAreaParsing(s) {
        if(s == null) {
            return null;
        } else {
            return s.replace(/(<br\/>)/gi, '&#10');
        }
    }

    function rcsBtnType(e){
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
            let sectionInx = $(e).parents('.rcs_slide_conts.on').index() - 1;
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
</script>



