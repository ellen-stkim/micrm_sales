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
                <!-- tooltip 버튼 영역  -->
<%--                <div class="tooltip_icon">--%>
<%--                    <img src="${baseURL}/image/ico_tooltip.png" alt="Tooltip"/>--%>
<%--                </div>--%>
                <!-- tooltip box 영역 시작 -->
<%--                <div class="tooltip_box">--%>
<%--                    <!-- tooltip bullet 영역 -->--%>
<%--                    <div class="bullet"></div>--%>
<%--                    <span class="bold">2019년 12월 신규 취급액은 91.6억 중,<br/>--%>
<%--                                나오론이 52.4억(57.2%)으로 가장 많은 비중을--%>
<%--                                차지합니다.</span>--%>
<%--                    스타일론 직장인이 26.69억(29.1%), <br/>--%>
<%--                    스타일론 자영업자가 4.1억(4.47%)입니다.<br/>--%>
<%--                </div>--%>
                <!-- tooltip box 영역 끝 -->
            </div>
        </div>
        <!-- row 영역 끝 -->
        <!-- section 영역 시작 -->
        <div class="section">
            <form:form id="form" action="/cont/mobileInsert.service" method="post">
                <div class="create_sms cf">
                    <div class="row head bottom-border">
                        <div class="th">템플릿 명</div>
                        <div class="td right-border"><input type="text" class="txt_input template_name" name="cont_nm"
                                                            placeholder="템플릿 명을 입력하세요."/></div>
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
                            <div class="inner_option">
                                <div class="th left-border">개인화 구분</div>
                                <div class="td">
                                    <label class="custom_radio en_font db_radio">DB
                                        <input name="dbInfo" type="radio" value="0" checked/>
                                        <span></span>
                                    </label>
                                    <label class="custom_radio db_radio">업로드
                                        <input name="dbInfo" type="radio" value="1"/>
                                        <span></span>
                                    </label>
                                </div>
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
                            <h2>카카오톡</h2>
                            <div class="flex_box">
                                <div class="left_area">
                                    <div class="row body">
                                        <div class="th">문자 제목</div>
                                        <div class="column_1">
                                                <%--<input type="text" class="title kakaoTitle" name="cont_sub" placeholder="문자 제목을 입력하세요." />--%>
                                            <input type="text" class="title kakaoTitle" name="cont_sub_list" placeholder="문자 제목을 입력하세요."/>
                                            <span class="ex_txt">※ 실제 발송에는 반영되지 않습니다.</span>
                                        </div>
                                    </div>
                                    <div class="row body">
                                        <div class="th">발신 번호</div>
                                        <div class="column_1">
                                            <!-- 발신 번호 후에 세팅한 값으로 변경 필요 -->
                                                <%--<input type="text" class="sms_number smsNumber" name="send_to" id="send_to"
                                                       value ="${list[0].list_val}"
                                                       readonly/>--%>
                                            <%--<input type="text" class="sms_number smsNumber_kko" id="send_to"
                                                   value="${list[0].list_nm}(${cutil:numberToPhone(list[0].list_val)})" readonly/>--%>
                                            <input type="text" class="sms_number smsNumber_kko" id="send_to"
                                                   <c:if test = "${fn:trim(list[0].list_nm) != ''}">
                                                       value="${list[0].list_nm}(${cutil:numberToPhone(list[0].list_val)})" readonly
                                                   </c:if>
                                                   <c:if test = "${fn:trim(list[0].list_nm) == ''}">
                                                        placeholder ="발신 번호를 입력해주세요"
                                                   </c:if>
                                            />
                                            <input type="hidden" name="send_to_list" value="${list[0].seq}"/>
                                        </div>
                                    </div>
                                    <div class="input_area">
                                        <div class="block">
                                            <div class="row">
                                                <div class="th">이미지 선택</div>
                                                <div class="td">
                                                    <div class="delete_img" data="kakao"><img src="${baseURL}/image/btn_delete1.png" alt="삭제">
                                                    </div>
                                                    <input type="text" class="txt_input en_font" name="" id="kakaoImage"
                                                           placeholder="이미지를 선택해 주세요." readonly/>
                                                    <span class="btn_sm_line" data="kakaoImage"
                                                          onclick="imageListPopUp('1','kakaoImage')">선택</span>
                                                    <input type="hidden" name="kko_img_cd" value=""> <!--임시 히든값 -->
                                                    <input type="hidden" name="kko_view_img_url" value=""> <!-- 프리뷰를 위한 이미지 URL -->
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="th top-border">이미지 링크 주소</div>
                                                <div class="td top-border">
                                                    <input type="text" class="txt_input en_font width kakaoImgLink"
                                                           name="kko_img_url"
                                                           onblur="smsCreate.imageLinkAdd(this);" placeholder="URL 입력 (http:// 또는 https://필수입력)"/>
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
                                                    <div class="select" id="" name="edmDB">
                                                        <!-- selected value -->
                                                        <div class="value" data="0">개인화 변수</div>
                                                        <ul class="option">
                                                            <c:forEach var="item" items="${columnNm}" varStatus="status">
                                                                <li data="{{${columnValue[status.count]}}}">${item}</li>
                                                            </c:forEach>
                                                        </ul>
                                                    </div>
                                                    <div class="select" id="kakaoValue" name="defaultDB">
                                                        <!-- selected value -->
                                                        <div class="value" data="0">개인화 변수</div>
                                                        <ul class="option">
                                                            <li data="{{USR_ID}}">회원번호</li>
                                                            <li data="{{USR_NM}}">이름</li>
                                                            <li data="{{USR_MOB}}">모바일</li>
                                                            <li data="{{USR_EDM}}">이메일</li>
                                                            <li data="{{USR_GDR}}">성별</li>
                                                            <li data="{{USR_ADDR}}">주소</li>
                                                            <li data="{{USR_ETC1}}">ETC1</li>
                                                            <li data="{{USR_ETC2}}">ETC2</li>
                                                            <li data="{{USR_ETC3}}">ETC3</li>
                                                            <li data="{{USR_ETC4}}">ETC4</li>
                                                            <li data="{{USR_ETC5}}">ETC5</li>
                                                            <li data="{{USR_ETC6}}">ETC6</li>
                                                            <li data="{{USR_ETC7}}">ETC7</li>
                                                            <li data="{{USR_ETC8}}">ETC8</li>
                                                            <li data="{{USR_ETC9}}">ETC9</li>
                                                            <li data="{{USR_ETC10}}">ETC10</li>
                                                        </ul>
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
                            <h2>알림톡 템플릿</h2>
                            <div class="flex_box">
                                <div class="left_area">
                                    <div class="row body">
                                        <div class="th">템플릿 제목</div>
                                        <div class="column_1">
                                            <div class="column_5">
                                                <input type="text" class="title type1 smsTitle" name="cont_sub_list"
                                                       onkeyup="smsCreate.titleCount(this,'sms');" placeholder="템플릿 제목을 입력하세요."/>
                                                <span class="title_byte en_font">(40byte)</span>
                                            </div>
                                            <!-- select 영역 시작 -->
                                            <div class="select column_4 left-border" id="smsTitleVal" name="edmDB">
                                                <!-- selected value -->
                                                <div class="value" data="0">제목 개인화 변수</div>
                                                <ul class="option">
                                                    <c:forEach var="item" items="${columnNm}" varStatus="status">
                                                        <li data="{{${columnValue[status.count]}}}">${item}</li>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                            <div class="select column_4 left-border" id="smsTitleVal" name="defaultDB">
                                                <!-- selected value -->
                                                <div class="value" data="0">제목 개인화 변수</div>
                                                <ul class="option">
                                                    <li data="{{USR_ID}}">회원번호</li>
                                                    <li data="{{USR_NM}}">이름</li>
                                                    <li data="{{USR_MOB}}">모바일</li>
                                                    <li data="{{USR_EDM}}">이메일</li>
                                                    <li data="{{USR_GDR}}">성별</li>
                                                    <li data="{{USR_ADDR}}">주소</li>
                                                    <li data="{{USR_ETC1}}">ETC1</li>
                                                    <li data="{{USR_ETC2}}">ETC2</li>
                                                    <li data="{{USR_ETC3}}">ETC3</li>
                                                    <li data="{{USR_ETC4}}">ETC4</li>
                                                    <li data="{{USR_ETC5}}">ETC5</li>
                                                    <li data="{{USR_ETC6}}">ETC6</li>
                                                    <li data="{{USR_ETC7}}">ETC7</li>
                                                    <li data="{{USR_ETC8}}">ETC8</li>
                                                    <li data="{{USR_ETC9}}">ETC9</li>
                                                    <li data="{{USR_ETC10}}">ETC10</li>
                                                </ul>
                                            </div>
                                            <!-- select 영역 끝 -->
                                        </div>
                                    </div>
                                    <div class="row body">
                                        <div class="th">발신 번호</div>
                                        <div class="column_1">
                                            <input type="text" class="sms_number smsNumber" id="sms_send_to"
                                                   <c:if test ="${fn:trim(smsSender[0].list_nm) != ''}">
                                                       value="${smsSender[0].list_nm}(${cutil:numberToPhone(smsSender[0].list_val)})"
                                                   </c:if>
                                                    <c:if test ="${fn:trim(smsSender[0].list_nm) == ''}">
                                                        placeholder="발신 번호를 입력해주세요."
                                                    </c:if>
                                                   readonly/>
                                            <input type="hidden" name="send_to_list" id="sms_send_to_num" value="${smsSender[0].seq}"/>
                                            <span class="btn_sm_line" onclick="mobileSenderPopup('1','sms')">변경</span>
                                        </div>
                                    </div>
                                    <div class="input_area left">
                                        <div class="block">
                                            <div class="row">
                                                <div class="th">템플릿코드 <span class="color_red">*</span></div>
                                                <div class="td">
                                                    <input type="text" class="txt_input txt_input2" name="tmplCode" id="tmplTracking"
                                                           placeholder=""/>
                                                    <span class="btn_sm_line btn_sm_line2 trackingLinkBtn">코드 자동 생성</span>
                                                    <input type="hidden" name="sms_trackinglink"/>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block block3">
                                            <div class="row">
                                                <div class="th th2">보안템플릿</div>
                                                <div class="td template_check_td">
                                                    <input type="checkbox" id="template_check">
                                                    <label for="template_check">보안 템플릿 설정 시, 메인 디바이스 모바일 외 모든 서브 디바이스에서는 메시지 내용이 노출되지 않습니다.</label>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block block3">
                                            <div class="row">
                                                <div class="th th2">카테고리 <span class="color_red">*</span></div>
                                                <div class="td template_category_td">
                                                    <!-- select 영역1 시작 -->
                                                    <div class="select bizContsVal_group" name="edmDB">
                                                        <!-- selected value -->
                                                        <div class="value" data="0">카테고리 그룹</div>
                                                        <ol class="option">
                                                            <li value="0">회원</li>
                                                            <li value="1">구매</li>
                                                            <li value="2">예약</li>
                                                            <li value="3">서비스이용</li>
                                                            <li value="4">리포팅</li>
                                                            <li value="5">배송</li>
                                                            <li value="6">법적고지</li>
                                                            <li value="7">업무알림</li>
                                                            <li value="8">쿠폰/포인트</li>
                                                            <li value="9">기타</li>
                                                        </ol>
                                                    </div>
                                                    <!-- select 영역1 끝 -->
                                                    <!-- select 영역2 시작 -->
                                                    <div class="select select2 bizContsVal" name="edmDB">
                                                        <!-- selected value -->
                                                        <div class="value" data="0">카테고리</div>
                                                        <ol class="option">
                                                            <li class="cate_op_0">회원가입</li>
                                                            <li class="cate_op_0">인증/비밀번호/로그인</li>
                                                            <li class="cate_op_0">회원정보/회원혜택</li>
                                                            <li class="cate_op_1">구매완료</li>
                                                            <li class="cate_op_1">상품가입</li>
                                                            <li class="cate_op_1">진행상태</li>
                                                            <li class="cate_op_1">구매취소</li>
                                                            <li class="cate_op_1">구매예약/입고알림</li>
                                                            <li class="cate_op_2">예약완료/예약내역</li>
                                                            <li class="cate_op_2">예약상태</li>
                                                            <li class="cate_op_2">예약취소</li>
                                                            <li class="cate_op_2">예약알림/리마인드</li>
                                                            <li class="cate_op_3">이용안내/공지</li>
                                                            <li class="cate_op_3">신청접수</li>
                                                            <li class="cate_op_3">처리완료</li>
                                                            <li class="cate_op_3">이용도구</li>
                                                            <li class="cate_op_3">방문서비스</li>
                                                            <li class="cate_op_3">피드백 요청</li>
                                                            <li class="cate_op_3">구매감사/이용확인</li>
                                                            <li class="cate_op_3">리마인드</li>
                                                            <li class="cate_op_4">피드백</li>
                                                            <li class="cate_op_4">요금청구</li>
                                                            <li class="cate_op_4">계약/견적</li>
                                                            <li class="cate_op_4">안전/피해예방</li>
                                                            <li class="cate_op_4">뉴스레터</li>
                                                            <li class="cate_op_4">거래알림</li>
                                                            <li class="cate_op_5">배송상태</li>
                                                            <li class="cate_op_5">배송예정</li>
                                                            <li class="cate_op_5">배송완료</li>
                                                            <li class="cate_op_5">배송실패</li>
                                                            <li class="cate_op_6">수신동의</li>
                                                            <li class="cate_op_6">개인정보</li>
                                                            <li class="cate_op_6">약관변경</li>
                                                            <li class="cate_op_6">휴면 관련</li>
                                                            <li class="cate_op_7">주문/예약</li>
                                                            <li class="cate_op_7">내부 업무 알림</li>
                                                            <li class="cate_op_8">쿠폰발급</li>
                                                            <li class="cate_op_8">쿠폰사용</li>
                                                            <li class="cate_op_8">포인트적립</li>
                                                            <li class="cate_op_8">포인트사용</li>
                                                            <li class="cate_op_8">쿠폰/포인트안내</li>
                                                            <li class="cate_op_9">기타</li>
                                                        </ol>
                                                    </div>
                                                    <!-- select 영역2 끝 -->
                                                    <p class="template_category_p">
                                                        카테고리 그룹, 카테고리를 모두 설정해주세요.
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block">
                                            <div class="row">
                                                <div class="th">템플릿명 <span class="color_red">*</span></div>
                                                <div class="td">
                                                    <input type="text" class="txt_input" name="tmplName"
                                                           placeholder="템플릿명 입력 (최대 200자)"/>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block_group">
                                            <div class="block block4 template_msg">
                                                <div class="row">
                                                    <div class="th">메시지유형 <span class="color_red">*</span></div>
                                                    <div class="td">
                                                        <!-- select 영역 시작 -->
                                                        <div class="select bizMsgVal" name="edmDB">
                                                            <!-- selected value -->
                                                            <div class="value" data="0">채널 추가형</div>
                                                            <ol class="option">
                                                                <li value="0">기본</li>
                                                                <li value="1">부가 정보형</li>
                                                                <li value="2">채널 추가형</li>
                                                                <li value="3">복합형</li>
                                                            </ol>
                                                        </div>
                                                        <!-- select 영역 끝 -->
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="block block4">
                                                <div class="row">
                                                    <div class="th">강조유형 <span class="color_red">*</span></div>
                                                    <div class="td">
                                                        <!-- select 영역 시작 -->
                                                        <div class="select bizEmphVal" name="edmDB">
                                                            <!-- selected value -->
                                                            <div class="value" data="0">선택안함</div>
                                                            <ol class="option">
                                                                <li value="0">선택안함</li>
                                                                <li value="1">강조표기형</li>
                                                                <li value="2">이미지형</li>
                                                                <li value="3">아이템리스트형</li>
                                                            </ol>
                                                        </div>
                                                        <!-- select 영역 끝 -->
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block_group emphtxt_block display-none">
                                            <div class="block block4">
                                                <div class="row">
                                                    <div class="th">강조 표기 타이틀 <span class="color_red">*</span></div>
                                                    <div class="td">
                                                        <input type="text" class="txt_input3" name="tmplEmphTitle" placeholder="강조 표기 타이틀 입력 (최대 50자)">
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="block block4 emphtxt_block2">
                                                <div class="row">
                                                    <div class="th" style="line-height: 18px;">강조 표기<br>보조 문구 <span class="color_red">*</span></div>
                                                    <div class="td">
                                                        <input type="text" class="txt_input3" name="tmplEmphTxt" placeholder="강조 표기 보조 문구 입력 (최대 50자)">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block emphImg_block display-none">
                                            <div class="row">
                                                <div class="th">이미지 <span class="color_red">*</span></div>
                                                <div class="td">
                                                    <div class="template_add_img">
                                                        click here to upload
                                                    </div>
                                                    <p class="color_red">
                                                        - 이미지 파일은 용량이 500KB 이하인 jpg, png 파일만 등록 가능합니다. <br>
                                                        - 이미지 파일은 가로 500px 이상, 세로 250px 이상이며 가로:세로 비율이 2:1 이어야 합니다.</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="emphItemList_block display-none">
                                            <div class="block emphItemList_img">
                                                <div class="row" style="height: auto;">
                                                    <div class="th">이미지</div>
                                                    <div class="td">
                                                        <input type="checkbox" id="img_check">
                                                        <label for="img_check">설정</label>

                                                        <div class="itemlist_img_on dis_flex display-none">
                                                            <div class="template_add_img">
                                                                click here to upload
                                                            </div>
                                                            <p class="color_red">
                                                                - 이미지 파일은 용량이 500KB 이하인 jpg, png 파일만 등록 가능합니다. <br>
                                                                - 이미지 파일은 가로 500px 이상, 세로 250px 이상이며 가로:세로 비율이 2:1 이어야 합니다.
                                                            </p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="block emphItemList_header">
                                                <div class="row" style="height: auto;">
                                                    <div class="th">헤더</div>
                                                    <div class="td">
                                                        <input type="checkbox" id="header_check">
                                                        <label for="header_check">설정</label>

                                                        <input type="text" class="header-check-on border display-none" placeholder="헤더 내용 입력 (최대 16자)">
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="block emphItemList_highlight">
                                                <div class="row" style="height: auto;">
                                                    <div class="th" style="line-height: 17px;">아이템<br>하이라이트</div>
                                                    <div class="td">
                                                        <div class="highlight_div">
                                                            <input type="checkbox" id="highlight_check">
                                                            <label for="highlight_check">설정 (아이템 하이라이트 체크 시, 하이라이트 타이틀 및 디스크립션 설정이 필수입니다.)</label>
                                                        </div>

                                                        <div class="highlight_div highlight_check_on display-none">
                                                            <input type="text" class="txt_input4 first border" placeholder="타이틀 입력 (최대 30자)">
                                                            <input type="text" class="txt_input4 border" placeholder="디스크립션 입력 (최대 19자)">
                                                        </div>

                                                        <div class="highlight_div highlight_check_on display-none">
                                                            <input type="checkbox" id="highlight_img_check">
                                                            <label for="highlight_img_check">이미지 (썸네일을 추가하면 타이틀은 21자, 디스크립션은 13자까지 입력 가능합니다.)</label>
                                                        </div>

                                                        <div class="highlight_div highlight_img_on dis_flex display-none">
                                                            <div class="template_add_img">
                                                                click here to upload
                                                            </div>
                                                            <p class="color_red">
                                                                - 이미지 파일은 용량이 500KB 이하인 jpg, png 파일만 등록 가능합니다. <br>
                                                                - 이미지 파일은 가로 500px 이상, 세로 250px 이상이며 가로:세로 비율이 2:1 이어야 합니다.
                                                            </p>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block">
                                            <div class="row template_textarea">
                                                <div class="th">템플릿내용 <span class="color_red">*</span></div>
                                                <div class="td">
                                                    <textarea rows="8" name="tmplTxt" placeholder="텍스트 입력 (최대 1000자)"></textarea>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block addinfo_block">
                                            <div class="row template_textarea">
                                                <div class="th">부가 정보 <span class="color_red">*</span></div>
                                                <div class="td">
                                                    <textarea rows="8" name="tmplAddInfo" placeholder="텍스트 입력 (최대 500자)"></textarea>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block block2 addchannel_block">
                                            <div class="row template_textarea2">
                                                <div class="th">채널 추가<br>안내 메시지</div>
                                                <div class="td">
                                                    <textarea rows="2" placeholder="채널 추가하고 이 채널의 광고와 마케팅 메시지 받기" readonly ></textarea>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block block3 addchannel_block">
                                            <div class="row row2 template_textarea3">
                                                <div class="th"></div>
                                                <div class="td">
                                                    <p class="color_red">
                                                        * 메시지 유형이 "채널 추가형" 혹은 "복합형"인 경우 "채널 추가" 버튼이 필수이며 메시지 하단에 채널 추가 안내 메시지가 함께 노출됩니다.<br>
                                                        (발송 시점 이미 채널을 추가한 수신자에게는 채널추가 버튼과 채널추가 안내 메시지는 미노출됩니다.)<br>
                                                        * 채널 추가 버튼과 부가정보를 함께 사용하고 싶으면 '복합형' 유형을 선택해주세요.
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block template_table template_btn_table">
                                            <div class="row" style="height: auto;">
                                                <div class="th">
                                                    버튼
                                                    <div class="button" onclick="addRowBtn()">추가</div>
                                                </div>
                                                <div class="td">
                                                    <table id="template_btn_table">
                                                        <colgroup>
                                                            <col width="8%">
                                                            <col width="15%">
                                                            <col width="20%">
                                                            <col>
                                                            <col width="16%">
                                                        </colgroup>
                                                        <thead>
                                                            <th>순서</th>
                                                            <th>버튼타입</th>
                                                            <th>버튼명</th>
                                                            <th>버튼링크</th>
                                                            <th>삭제</th>
                                                        </thead>
                                                        <tbody>
                                                            <tr class="type_table_no_info">
                                                                <td colspan="5">
                                                                    버튼 정보가 없습니다.
                                                                </td>
                                                            </tr>

                                                            <tr class="channel_add_table display-none" id="channel_add_table">
                                                                <td>1</td>
                                                                <td>
                                                                    <select class="border" id="channel_add_select" disabled>
                                                                        <option>채널추가</option>
                                                                    </select>
                                                                </td>
                                                                <td>
                                                                    <input class="border" type="text" placeholder="채널 추가" disabled readonly>
                                                                </td>
                                                                <td>
                                                                    <p class="color_red">* 채널 추가 버튼은 단독 혹은 최상단에 위치한 경우에만 가능</p>
                                                                </td>
                                                                <td></td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="block template_table template_link_table">
                                            <div class="row" style="height: auto;">
                                                <div class="th">
                                                    바로연결
                                                    <div class="button" onclick="addRowLink()">추가</div>
                                                </div>
                                                <div class="td">
                                                    <table id="template_link_table">
                                                        <colgroup>
                                                            <col width="8%">
                                                            <col width="15%">
                                                            <col width="20%">
                                                            <col>
                                                            <col width="16%">
                                                        </colgroup>
                                                        <thead>
                                                            <th>순서</th>
                                                            <th>바로연결 타입</th>
                                                            <th>바로연결명</th>
                                                            <th>바로연결 링크</th>
                                                            <th>삭제</th>
                                                        </thead>
                                                        <tbody>
                                                            <tr class="link_table_no_info">
                                                                <td colspan="5">
                                                                    바로연결 정보가 없습니다.
                                                                </td>
                                                            </tr>
                                                        </tbody>
                                                    </table>
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
                                        <textarea name="sms_body" id="" class="sms_txt textarea" cols="30" rows="10"
                                                  onkeyup="smsCreate.byteCount(this, 'sms');"></textarea>
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
                            <h2>RCS</h2>
                            <div class="row body">
                                <div class="th">포맷카드</div>
                                <div class="column_2 right-border">
                                    <label class="type_check"><input type="radio" name="rcs_format_type" class="rcsType"
                                                                     value="text"
                                                                     checked/><span>텍스트형</span></label>
                                    <%--<label class="type_check"><input type="radio" name="rcs_format_type" class="rcsType"
                                                                     value="horizontal"
                                                                     /><span>가로형</span></label>--%>
                                    <label class="type_check"><input type="radio" name="rcs_format_type" class="rcsType"
                                                                     value="vertical"
                                                                     /><span>세로형</span></label>
                                    <label class="type_check"><input type="radio" name="rcs_format_type" class="rcsType"
                                                                     value="slide"
                                                                     /><span>슬라이드형</span></label>
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
                                            <label class="custom_radio en_font">SMS<input name="rcs_msg_tp" class="lowType"
                                                                                          type="radio" value="sms" checked
                                                                                          /><span></span></label>
                                            <label class="custom_radio en_font">LMS<input name="rcs_msg_tp" class="lowType"
                                                                                          type="radio" value="lms"
                                                                                          /><span></span></label>
                                        </div>
                                    </div>
                                    <span id="js-title-area"></span>
                                    <div class="row body">
                                        <div class="th">발신 번호</div>
                                        <div class="column_1" id ="send_text_column">
                                            <input type="text" class="sms_number smsNumber" id="send_text_rcs"
                                                   <c:if test = "${fn:trim(rcsSender[0].list_nm)!= ''}">
                                                       value="${rcsSender[0].list_nm}(${cutil:numberToPhone(rcsSender[0].list_val)})"
                                                   </c:if>
                                                    <c:if test = "${fn:trim(rcsSender[0].list_nm) == ''}">
                                                        placeholder="발신 번호를 입력해주세요."
                                                    </c:if>
                                                   readonly/>
                                            <input type="hidden" name="send_to_list" id="text_send_num" value="${rcsSender[0].seq}"/>
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
                                                                <ul class="option">
                                                                    <c:forEach var="item" items="${columnNm}"
                                                                               varStatus="status">
                                                                        <li data="{{${columnValue[status.count]}}}">${item}</li>
                                                                    </c:forEach>
                                                                </ul>
                                                            </div>
                                                            <div class="select rcsContsVal" name="defaultDB">
                                                                <!-- selected value -->
                                                                <div class="value" data="0">개인화 변수</div>
                                                                <ul class="option" id="dbHtml">
                                                                    <li data="{{USR_ID}}">회원번호</li>
                                                                    <li data="{{USR_NM}}">이름</li>
                                                                    <li data="{{USR_MOB}}">모바일</li>
                                                                    <li data="{{USR_EDM}}">이메일</li>
                                                                    <li data="{{USR_GDR}}">성별</li>
                                                                    <li data="{{USR_ADDR}}">주소</li>
                                                                    <li data="{{USR_ETC1}}">ETC1</li>
                                                                    <li data="{{USR_ETC2}}">ETC2</li>
                                                                    <li data="{{USR_ETC3}}">ETC3</li>
                                                                    <li data="{{USR_ETC4}}">ETC4</li>
                                                                    <li data="{{USR_ETC5}}">ETC5</li>
                                                                    <li data="{{USR_ETC6}}">ETC6</li>
                                                                    <li data="{{USR_ETC7}}">ETC7</li>
                                                                    <li data="{{USR_ETC8}}">ETC8</li>
                                                                    <li data="{{USR_ETC9}}">ETC9</li>
                                                                    <li data="{{USR_ETC10}}">ETC10</li>
                                                                </ul>
                                                            </div>
                                                            <!-- select 영역 끝 -->
                                                        </div>
                                                    </div>
                                                    <div class="row rcs_textarea">
                                                        <div class="th top-border">내용</div>
                                                        <div class="td top-border">
                                                            <textarea class="rcsContents" name="rcs_body" id="" cols="30"
                                                                      rows="10" placeholder="내용을 입력해주세요."
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
                                                                <input type="text" name="rcs_btn_1" class="txt_input action_name"
                                                                       data="1" onkeyup="rcsCreate.buttonCount(this, 'text');"
                                                                       placeholder="버튼 명을 입력해주세요."/>
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

    function getDBValue() {
        let dbValue = $('input[name="dbInfo"]:checked').val();
        let edmDB = $('#smsContsVal[name="edmDB"] .option').html();
        let defaultDB = $('#smsContsVal[name="defaultDB"] .option').html();

        $('.rcsTitleVal[name="edmDB"] .option').html(edmDB);
        $('.rcsContsVal[name="edmDB"] .option').html(edmDB);
        $('.rcsTitleVal[name="defaultDB"] .option').html(defaultDB);
        $('.rcsContsVal[name="defaultDB"] .option').html(defaultDB);

        if (dbValue == '0') {
            $('div[name="edmDB"]').show();
            $('div[name="defaultDB"]').hide();
        }
        if (dbValue == '1') {
            $('div[name="edmDB"]').hide();
            $('div[name="defaultDB"]').show();
        }
    }

    /*----- 알림톡 템플릿 테이블 ------*/
    // 버튼 열 추가
    function addRowBtn() {
        $('.type_table_no_info').addClass('display-none');

        let table = document.getElementById('template_btn_table');

        let newRow = table.insertRow();
        let newCell1 = newRow.insertCell(0);
        let newCell2 = newRow.insertCell(1);
        let newCell3 = newRow.insertCell(2);
        let newCell4 = newRow.insertCell(3);
        let newCell5 = newRow.insertCell(4);

        let addCell1 = '';
        let addCell2 = '';
        let addCell3 = '';
        let addCell4 = '';

        addCell1 += '<select class="border" id="table_btn_type" onchange="selectType(this.value, this)">' +
            '<option value="" selected disabled>버튼타입 선택</option>' +
            '<option value="0">웹링크</option>'+
            '<option value="1">앱링크</option>'+
            '<option value="2">배송조회</option>'+
            '<option value="3">봇키워드</option>'+
            '<option value="4">메시지전달</option>'+
            '<option value="5">상담톡전환</option>'+
            '<option value="6">봇전환</option>'+
            '<option value="7">이미지 보안 전송 플러그인</option>'+
            '<option value="8">개인정보이용 플러그인</option>'+
            '<option value="9">원클릭 결제 플러그인</option>'+
            '</select>';

        addCell2 += '<input class="border" type="text" placeholder="버튼명 입력 (14자 이내)">';

        addCell3 += '<div class="webLink-on display-none">' +
                    '<p class="btn_link_title_first">Moblie</p>'+
                    '<input type="text" class="border" placeholder="http:// 또는 https:// 가 포함된 URL">'+
                    '<p class="btn_link_title">PC(선택)</p>'+
                    '<input type="text" class="border" placeholder="http:// 또는 https:// 가 포함된 URL"></div>'+
                    '<div class="appLink-on display-none">'+
                    '<p class="color_red">* Android, iOS, Mobile 중 2가지 이상 입력 필수</p>'+
                    '<p class="btn_link_title">Android</p>'+
                    '<input type="text" class="border" placeholder="scheme android 링크">'+
                    '<p class="btn_link_title">iOS</p>'+
                    '<input type="text" class="border" placeholder="scheme iOS 링크">'+
                    '<p class="btn_link_title">Moblie</p>'+
                    '<input type="text" class="border" placeholder="http:// 또는 https:// 가 포함된 URL">'+
                    '<p class="btn_link_title">PC(선택)</p>'+
                    '<input type="text" class="border" placeholder="http:// 또는 https:// 가 포함된 URL"></div>'+
                    '<div class="plugin-on display-none">'+
                    '<input type="text" class="border" placeholder="플러그인 ID">'+
                    '</div>';
        addCell4 += '<div class="table_btn">'+
                    '<div class="up" onclick="upRow(this)"><i class="fa-solid fa-square-caret-up"></i></div>'+
                    '<div class="down" onclick="downRow(this)"><i class="fa-solid fa-square-caret-down"></i></div>'+
                    '<div class="del" onclick="deleteRow(this)"><i class="fa-solid fa-square-xmark"></i></div>'+
                    '</div>';

        let dis = $('.channel_add_table').hasClass('display-none');

        if(dis == false){
            newCell1.innerText = table.tBodies[0].rows.length -1;
        } else if (dis == true) {
            newCell1.innerText = table.tBodies[0].rows.length -2;
        }

        newCell2.innerHTML = addCell1;
        newCell3.innerHTML = addCell2;
        newCell4.innerHTML = addCell3;
        newCell5.innerHTML = addCell4;
    }

    // 바로연결 열 추가
    function addRowLink() {
        $('.link_table_no_info').addClass('display-none');

        let table = document.getElementById('template_link_table');

        let newRow = table.insertRow();
        let newCell1 = newRow.insertCell(0);
        let newCell2 = newRow.insertCell(1);
        let newCell3 = newRow.insertCell(2);
        let newCell4 = newRow.insertCell(3);
        let newCell5 = newRow.insertCell(4);

        let addCell1 = '';
        let addCell2 = '';
        let addCell3 = '';
        let addCell4 = '';

        addCell1 += '<select class="border" id="table_link_type" onchange="selectType2(this.value, this)">' +
            '<option value="" selected disabled>바로연결 타입 선택</option>' +
            '<option value="0">웹링크</option>'+
            '<option value="1">앱링크</option>'+
            '<option value="2">봇키워드</option>'+
            '<option value="3">메시지전달</option>'+
            '<option value="4">상담톡전환</option>'+
            '<option value="5">봇전환</option>'+
            '</select>';

        addCell2 += '<input class="border" type="text" placeholder="바로연결명 입력 (14자 이내)">';

        addCell3 += '<div class="webLink-on display-none">' +
                    '<p class="btn_link_title_first">Moblie</p>'+
                    '<input type="text" class="border" placeholder="http:// 또는 https:// 가 포함된 URL">'+
                    '<p class="btn_link_title">PC(선택)</p>'+
                    '<input type="text" class="border" placeholder="http:// 또는 https:// 가 포함된 URL"></div>'+
                    '<div class="appLink-on display-none">'+
                    '<p class="color_red">* Android, iOS, Mobile 중 2가지 이상 입력 필수</p>'+
                    '<p class="btn_link_title">Android</p>'+
                    '<input type="text" class="border" placeholder="scheme android 링크">'+
                    '<p class="btn_link_title">iOS</p>'+
                    '<input type="text" class="border" placeholder="scheme iOS 링크">'+
                    '<p class="btn_link_title">Moblie</p>'+
                    '<input type="text" class="border" placeholder="http:// 또는 https:// 가 포함된 URL">'+
                    '<p class="btn_link_title">PC(선택)</p>'+
                    '<input type="text" class="border" placeholder="http:// 또는 https:// 가 포함된 URL"></div>';

        addCell4 += '<div class="table_btn">'+
                    '<div class="up" onclick="upRow2(this)"><i class="fa-solid fa-square-caret-up"></i></div>'+
                    '<div class="down" onclick="downRow2(this)"><i class="fa-solid fa-square-caret-down"></i></div>'+
                    '<div class="del" onclick="deleteRow2(this)"><i class="fa-solid fa-square-xmark"></i></div>'+
                    '</div>';

        newCell1.innerText = table.tBodies[0].rows.length -1;
        newCell2.innerHTML = addCell1;
        newCell3.innerHTML = addCell2;
        newCell4.innerHTML = addCell3;
        newCell5.innerHTML = addCell4;
    }

    // 열 위로 이동
    function upRow(n){
        let i = n.parentNode.parentNode.parentNode;

        if(i.rowIndex <= 3) {
            return false;
        } else {
            i.previousElementSibling.before(i);
        }


        cellNum();
    }
    function upRow2(n){
        let i = n.parentNode.parentNode.parentNode;

        if(i.rowIndex <= 2) {
            return false;
        } else {
            i.previousElementSibling.before(i);
        }

        cellNum2();
    }

    // 열 아래로 이동
    function downRow(n){
        let table = document.getElementById('template_btn_table');
        let i = n.parentNode.parentNode.parentNode;
        let max = table.tBodies[0].rows.length;

        if(i.rowIndex >= max) {
            return false;
        } else {
            i.nextElementSibling.after(i);
        }

        cellNum();
    }
    function downRow2(n){
        let table = document.getElementById('template_link_table');
        let i = n.parentNode.parentNode.parentNode;
        let max = table.tBodies[0].rows.length;

        if(i.rowIndex >= max) {
            return false;
        } else {
            i.nextElementSibling.after(i);
        }

        cellNum2();
    }

    // 열 삭제
    function deleteRow(n){
        let table = document.getElementById('template_btn_table');
        let i = n.parentNode.parentNode.parentNode.rowIndex;

        table.deleteRow(i);

        let dis = $('.channel_add_table').hasClass('display-none');

        if(dis == false){
            let cnt = table.tBodies[0].rows.length;
            if(cnt <= 1) {
                $('.type_table_no_info').removeClass('display-none');
            }
        } else if (dis == true){
            let cnt = table.tBodies[0].rows.length;
            if(cnt <= 2) {
                $('.type_table_no_info').removeClass('display-none');
            }
        }

        cellNum();
    }
    function deleteRow2(n){
        let table = document.getElementById('template_link_table');
        let i = n.parentNode.parentNode.parentNode.rowIndex;

        table.deleteRow(i);

        let cnt = table.tBodies[0].rows.length;
        if(cnt <= 1) {
            $('.link_table_no_info').removeClass('display-none');
        }
        cellNum2();
    }

    // 행 번호 리셋
    function cellNum() {
        let table = document.getElementById('template_btn_table');
        let cnt = table.tBodies[0].rows.length;
        let row = "";

        let dis = $('.channel_add_table').hasClass('display-none');
        console.log(table.tBodies[0].rows)
        // 채널추가 열이 display block인 경우
        if(dis == false){
            for(let i = 0; i < cnt; i++){
                row = table.tBodies[0].rows[i];
                let cell = row.getElementsByTagName('td')[0];
                cell.innerText = String(i);
            }
        // 채널추가 열이 display none인 경우
        } else if(dis == true){
            for(let i = 0; i < cnt; i++){
                row = table.tBodies[0].rows[i];
                let cell = row.getElementsByTagName('td')[0];
                cell.innerText = String(i-1);
            }
        }
    }
    function cellNum2() {
        let table = document.getElementById('template_link_table');
        let cnt = table.tBodies[0].rows.length;

        let row = "";
        for(let i = 0; i < cnt; i++){
            row = table.tBodies[0].rows[i];
            let cell = row.getElementsByTagName('td')[0];
            cell.innerText = String(i);
        }
    }

    // 버튼 타입 선택
    function selectType(val, i){

        if(val == 0){
            typeFirstOption(i);
        } else if (val == 1){
            typeSecondOption(i);
        } else if (val >= 2 && val <= 6){
            typeAllNone(i);
        } else if (val >= 7){
            typeThirdOption(i);
        }
    }
    function typeAllNone(n) {
        let webLink = n.parentNode.parentNode.childNodes[3].childNodes[0];
        let appLink = n.parentNode.parentNode.childNodes[3].childNodes[1];
        let webLinkBlock = webLink.classList.contains('display-none');
        let appLinkBlock = appLink.classList.contains('display-none');

        let NodeLen = n.parentNode.parentNode.childNodes[3].childNodes.length;

        let plugin = "";
        let pluginBlock = "";
        if(NodeLen == 3){
            plugin = n.parentNode.parentNode.childNodes[3].childNodes[2];
            pluginBlock = plugin.classList.contains('display-none');

            if(webLinkBlock == true && appLinkBlock == true && pluginBlock == true) {
                return false;
            } else {
                webLink.classList.add('display-none');
                appLink.classList.add('display-none');
                plugin.classList.add('display-none');
            }

        } else {
            if(webLinkBlock == true && appLinkBlock == true) {
                return false;
            } else {
                webLink.classList.add('display-none');
                appLink.classList.add('display-none');
            }
        }

    }

    function typeFirstOption(n) {
        let webLink = n.parentNode.parentNode.childNodes[3].childNodes[0];
        let appLink = n.parentNode.parentNode.childNodes[3].childNodes[1];
        let webLinkBlock = webLink.classList.contains('display-none');
        let appLinkBlock = appLink.classList.contains('display-none');

        let NodeLen = n.parentNode.parentNode.childNodes[3].childNodes.length;

        let plugin = "";
        let pluginBlock = "";
        if(NodeLen == 3) {
            plugin = n.parentNode.parentNode.childNodes[3].childNodes[2];
            pluginBlock = plugin.classList.contains('display-none');

            if(webLinkBlock == false && appLinkBlock == true && pluginBlock == true) {
                return false;
            } else {
                webLink.classList.remove('display-none');
                appLink.classList.add('display-none');
                plugin.classList.add('display-none');
            }

        } else {

            if(webLinkBlock == false && appLinkBlock == true) {
                return false;
            } else {
                webLink.classList.remove('display-none');
                appLink.classList.add('display-none');
            }
        }

    }

    function typeSecondOption(n) {
        let webLink = n.parentNode.parentNode.childNodes[3].childNodes[0];
        let appLink = n.parentNode.parentNode.childNodes[3].childNodes[1];
        let webLinkBlock = webLink.classList.contains('display-none');
        let appLinkBlock = appLink.classList.contains('display-none');

        let NodeLen = n.parentNode.parentNode.childNodes[3].childNodes.length;

        let plugin = "";
        let pluginBlock = "";
        if(NodeLen == 3) {
            plugin = n.parentNode.parentNode.childNodes[3].childNodes[2];
            pluginBlock = plugin.classList.contains('display-none');

            if(webLinkBlock == true && appLinkBlock == false && pluginBlock == true) {
                return false;
            } else {
                webLink.classList.add('display-none');
                appLink.classList.remove('display-none');
                plugin.classList.add('display-none');
            }

        } else {
            if(webLinkBlock == true && appLinkBlock == false) {
                return false;
            } else {
                webLink.classList.add('display-none');
                appLink.classList.remove('display-none');
            }
        }

    }

    function typeThirdOption(n) {
        let webLink = n.parentNode.parentNode.childNodes[3].childNodes[0];
        let appLink = n.parentNode.parentNode.childNodes[3].childNodes[1];
        let plugin = n.parentNode.parentNode.childNodes[3].childNodes[2];
        let webLinkBlock = webLink.classList.contains('display-none');
        let appLinkBlock = appLink.classList.contains('display-none');
        let pluginBlock = plugin.classList.contains('display-none');

        if (webLinkBlock == true && appLinkBlock == true && pluginBlock == false) {
            return false;
        } else {
            webLink.classList.add('display-none');
            appLink.classList.add('display-none');
            plugin.classList.remove('display-none');
        }
    }

    // 바로연결 타입 선택
    function selectType2(val, i){

        if(val == 0){
            typeFirstOption(i);
        } else if (val == 1){
            typeSecondOption(i);
        } else if (val >= 2){
            typeAllNone(i);
        }
    }
    /*-------  알림톡 템플릿 테이블 끝  ------*/

    $(function () {
        /*-------  알림톡 템플릿  ------*/

        // 카테고리 선택
        $('.bizContsVal_group .option li').on('click', function(){
            let val = $(this).val();
            let list = $(".bizContsVal .option").find('li[class="cate_op_' + val + '"]');
            let not_list = $(".bizContsVal .option").find('li[class!="cate_op_' + val + '"]');

            if(val == 0){
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if(val == 1) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if(val == 2) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if(val == 3) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if(val == 4) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if(val == 5) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if(val == 6) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if(val == 7) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if(val == 8) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            } else if(val == 9) {
                list.css('display', 'block');
                not_list.css('display', 'none');
            }
        })
        // 카테고리 소분류 선택
        $('.bizContsVal .option li').on('click', function(){
            let val = $(this).index();

            if(val == 0){
                $('.template_category_p').text('회원가입 완료 내용의 템플릿이 대상입니다. 가입에 따른 축하적립금/쿠폰을 포함합니다.');
            } else if(val == 1){
                $('.template_category_p').text('OTP, 로그인여부, 임시비밀번호, 본인확인 용도의 템플릿이 대상입니다.');
            } else if(val == 2){
                $('.template_category_p').text('회원등급안내, 혜택안내, 생일/기념일 축하 동의 템플릿이 대상입니다.');
            } else if(val == 3){
                $('.template_category_p').text('주문완료, 구매완료 템플릿이 대상입니다.');
            } else if(val == 4){
                $('.template_category_p').text('상품가입/계약완료, 서비스 가입완료, 정기결제상품,렌탈가입 등의 정기결제류의 상품/서비스 가입 템플릿이 대상입니다.');
            } else if(val == 5){
                $('.template_category_p').text('2021.1.1 부터 구매>구매완료(002001) 로 통합됩니다.');
            } else if(val == 6){
                $('.template_category_p').text('품절, 환불, 상품해지, 서비스 가입해지, 렌탈해지 등 상품구매의사나 판매상태 중지에 따른 구매취소 템플릿이 대상입니다. 또한 결제하여 사용하는 서비스의 해지 템플릿도 대상입니다.');
            } else if(val == 7){
                $('.template_category_p').text('입고알림 예약, 사전구매 템플릿 등이 대상입니다.');
            } else if(val == 8){
                $('.template_category_p').text('예약완료, 예매완료, 서비스/진료예약, 대관예약, 상담예약, 예약 결제완료 등의 템플릿이 대상입니다.');
            } else if(val == 9){
                $('.template_category_p').text('2021.1.1 부터 예약>예약완료/예약내역(003001) 로 통합됩니다. 예약변경, 예약확정, 입금대기, 발권완료, 사용완료, 예약대기, 스케쥴변경, 예약확인, 좌석배정완료, 모바일체크인 등의 템플릿이 대상입니다.');
            } else if(val == 10){
                $('.template_category_p').text('예약실패, 취소 등 예약이 진행되지 않은 내용을 담은 템플릿이 대상입니다.');
            } else if(val == 11){
                $('.template_category_p').text('2021.12.1 부터 서비스이용>리마인드(004008) 로 통합됩니다.');
            } else if(val == 12){
                $('.template_category_p').text('발급안내, 사용안내, 변동사항공지, 이용중인 서비스의 상태알림 등 이용과 관련한 안내 및 공지사항 템플릿이 대상입니다.');
            } else if(val == 13){
                $('.template_category_p').text('(구매/예약이 아닌) 이용신청, 발급신청, 수강신청, 입소신청, 서비스 해지신청, 이벤트 응모, 자격신청 등이 접수/해지 되었다는 템플릿이 대상입니다.');
            } else if(val == 14){
                $('.template_category_p').text('주문 처리완료, 주문완성 등의 템플릿이 대상입니다.');
            } else if(val == 15){
                $('.template_category_p').text('모바일탑승권, 티켓, QR코드 등 서비스 이용/입장 등 이용자격 증명에 활용할 수 있는 템플릿이 대상입니다.');
            } else if(val == 16){
                $('.template_category_p').text('렌탈제품 케어 방문 예정 등의 템플릿이 대상입니다.');
            } else if(val == 17){
                $('.template_category_p').text('만족도 조사, 설문조사 참여요청, 리뷰 작성요청 등 수신자에게 참여를 독려하는 내용의 템플릿이 대상입니다.');
            } else if(val == 18){
                $('.template_category_p').text('이용 감사인사, 이용확인 내용의 템플릿이 대상입니다.');
            } else if(val == 19){
                $('.template_category_p').text('순서알림, 일자도래안내, 배차알림, 예약종료알림, 도서대출기간 만료 알림 등의 템플릿이 대상입니다.');
            } else if(val == 20){
                $('.template_category_p').text('고객문의답변, 출결 및 on/off 상태 피드백, 처리에 대한 결과 피드백, 출결확인, 보안해제, 이벤트 당첨결과 안내의 목적으로 발송되는 템플릿이 대상입니다.');
            } else if(val == 21){
                $('.template_category_p').text('청구서, 결제예정안내, 청구 예정 금액안내, 영수증, 세금계산서, 거래명세서 등의 요금청구와 관련된 템플릿이 대상입니다.');
            } else if(val == 22){
                $('.template_category_p').text('계약서, 견적서, 계약 서명요청 등의 템플릿이 적용 대상입니다.');
            } else if(val == 23){
                $('.template_category_p').text('보이스피싱방지, 사기예방, 날씨 등 천재지변에 따른 피해예방에 관련된 템플릿이 대상입니다.');
            } else if(val == 24){
                $('.template_category_p').text('새로운 소식/정보를 알리기 위하여 구성원에게 정기적으로 보내는 내용의 템플릿이 대상입니다.');
            } else if(val == 25){
                $('.template_category_p').text('금융기관 (은행, 증권사,카드사 등) 또는 결제업체 등에서 사용자에게 금용기관/결제업체의 거래 진행과 관련된 상태와 결과 안내의 목적으로 발송되는 템플릿이 대상입니다.');
            } else if(val == 26){
                $('.template_category_p').text('배송/통관/회수 진행되는 배송상태에 따른 내용의 템플릿이 대상입니다.');
            } else if(val == 27){
                $('.template_category_p').text('** 2021.1.1 부터 배송>배송상태(006001) 로 통합됩니다.** 배달예정, 방문예정, 회수예정 등 배송기사님이 방문할 예정이라는 내용의 템플릿이 대상입니다.');
            } else if(val == 28){
                $('.template_category_p').text('배달완료, 회수완료 등 배송기사님이 방문하여 처리하였다는 내용의 템플릿이 대상입니다.');
            } else if(val == 29){
                $('.template_category_p').text('** 2021.1.1 부터 배송>배송상태(006001) 로 통합됩니다.** 배송실패, 반송, 미수령 등의 사유로 배송이 실패되었다는 내용의 템플릿이 대상입니다.');
            } else if(val == 30){
                $('.template_category_p').text('마케팅수신동의, 광고성 정보수신 동의 등의 내용의 템플릿이 대상입니다.');
            } else if(val == 31){
                $('.template_category_p').text('개인정보제공동의, 개인정보수집출처, 개인정보처리위탁 등 개인정보보호법 관련 개인정보 수집/동의에 대한 안내 템플릿이 대상입니다.');
            } else if(val == 32){
                $('.template_category_p').text('이용약관, 회원약관 등 약관 변경사항 고지에 관한 템플릿이 대상입니다.');
            } else if(val == 33){
                $('.template_category_p').text('장기미사용 등의 사유로 정보통신망법에 따라 휴면계정 전환 예정/처리 고지하는 내용의 템플릿이 대상입니다.');
            } else if(val == 34){
                $('.template_category_p').text('사업장으로 인입된 주문/예약 내용의 템플릿이 대상입니다. (취소포함)');
            } else if(val == 35){
                $('.template_category_p').text('소속 구성원 또는 관련 업무자들에게 업무 또는 내부 관리적인 용도로 전달되는 알림톡이 대상입니다.');
            } else if(val == 36){
                $('.template_category_p').text('서비스/상품을 무료 또는 할인하는 쿠폰 발급 내용의 템플릿이 대상입니다.');
            } else if(val == 37){
                $('.template_category_p').text('무료 또는 할인제공 목적으로 발급된 쿠폰의 사용완료 알림 템플릿이 대상입니다.');
            } else if(val == 38){
                $('.template_category_p').text('포인트, 마일리지, 적립금 등 이용에 따른 고객 리워드 적립 완료 내용의 템플릿이 대상입니다.');
            } else if(val == 39){
                $('.template_category_p').text('포인트, 마일리지, 적립금 등 이용에 따른 고객 리워드 사용결과 내용의 템플릿이 대상입니다.');
            } else if(val == 40){
                $('.template_category_p').text('쿠폰/포인트/적립금/마일리지 등의 이용안내, 소멸예정, 정책변경, 이용 기한안내 등의 템플릿이 대상입니다.');
            } else if(val == 41){
                $('.template_category_p').text('');
            }
        })

            // 메시지유형 선택
        $('.bizMsgVal .option li').on('click', function(){
            let val = $(this).val();

            if(val == 0){
                allNone();
            } else if (val == 1){
                BlockNone();
            } else if (val == 2){
                NoneBlock();

                let msg = '메시지 유형이 "채널 추가형"으로 변경되어,<br/>첫번째 버튼의 타입이 "채널추가"로 변경 입력되며<br/>기존 입력한 버튼정보는 유지되지 않습니다.';
                alert(msg)
            } else if (val == 3){
                allBlock();

                let msg = '메시지 유형이 "복합형"으로 변경되어,<br/>첫번째 버튼의 타입이 "채널추가"로 변경 입력되며<br/>기존 입력한 버튼정보는 유지되지 않습니다.';
                alert(msg)
            }
        })

        function alert(msg) {
            let html = '';
            html +=
                '<div class="layer_pop alert active">' +
                '<div class="pop_container popup_size3">' +
                '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
                '<div class="pop_title">알림</div>' +
                '<div class="pop_inner">' +
                '<div class="alert_txt">' + msg + '</div>' +
                '<div class="btn_row">' +
                '<input type="button" class="btn_bg btn_size2 btn_inline" onclick="popupClose(this);" value="확인" />' +
                '</div>' +
                '</div>' +
                '</div>' +
                '</div>';
            $('body .layer_pop.alert').remove();
            $('body').append(html);
        }

        function allBlock() {
            $('.addinfo_block').css('display', 'block');
            $('.addchannel_block').css('display', 'block');
            $('.channel_add_table').removeClass('display-none');
            $('.type_table_no_info').addClass('display-none');

            cellNum();
        }
        function BlockNone() {
            $('.addinfo_block').css('display', 'block');
            $('.addchannel_block').css('display', 'none');
            $('.channel_add_table').addClass('display-none');

            let table = document.getElementById('template_btn_table');

            if(table.tBodies[0].rows.length <= 2) {
                $('.type_table_no_info').removeClass('display-none');
            }
        }

        function NoneBlock() {
            $('.addinfo_block').css('display', 'none');
            $('.addchannel_block').css('display', 'block');
            $('.channel_add_table').removeClass('display-none');
            $('.type_table_no_info').addClass('display-none');

            cellNum();
        }

        function allNone() {
            $('.addinfo_block').css('display', 'none');
            $('.addchannel_block').css('display', 'none');
            $('.channel_add_table').addClass('display-none');

            let table = document.getElementById('template_btn_table');

            if(table.tBodies[0].rows.length <= 2) {
                $('.type_table_no_info').removeClass('display-none');
            }

        }

        //강조유형 선택
        $('.bizEmphVal .option li').on('click', function(){
            let val = $(this).val();

            if(val == 0){
                emphAllNone();
            } else if (val == 1){
                emphFirstOption();
            } else if (val == 2){
                emphSecondOption();
            } else if (val == 3){
                emphThirdOption();
            }
        })

        function emphAllNone() {
            $('.emphtxt_block').addClass('display-none');
            $('.emphImg_block').addClass('display-none');
            $('.emphItemList_block').addClass('display-none');
        }

        function emphFirstOption() {
            $('.emphtxt_block').removeClass('display-none');
            $('.emphImg_block').addClass('display-none');
            $('.emphItemList_block').addClass('display-none');
        }

        function emphSecondOption() {
            $('.emphtxt_block').addClass('display-none');
            $('.emphImg_block').removeClass('display-none');
            $('.emphItemList_block').addClass('display-none');
        }

        function emphThirdOption() {
            $('.emphtxt_block').addClass('display-none');
            $('.emphImg_block').addClass('display-none');
            $('.emphItemList_block').removeClass('display-none');
        }

        //강조유형 - 아이템리스트 - 이미지
        $('#img_check').on('click', function() {
            $('.itemlist_img_on').toggleClass('display-none');
        })

        //강조유형 - 아이템리스트 - 헤더
        $('#header_check').on('click', function() {
            $('.header-check-on').toggleClass('display-none');
        })

        //강조유형 - 아이템리스트 - 하이라이트
        $('#highlight_check').on('click', function() {
            $('.highlight_check_on').toggleClass('display-none');
        })

        $('#highlight_img_check').on('click', function() {
            $('.highlight_img_on').toggleClass('display-none');
        })

        // textarea 글자수 제한
        $('.template_textarea textarea').on('keyup', function() {
            if($(this).val().length > 1000) {
                $(this).val($(this).val().substring(0, 1000));
            }
        });

        $('.addinfo_block textarea').on('keyup', function() {
            if($(this).val().length > 500) {
                $(this).val($(this).val().substring(0, 500));
            }
        });

        $('.emphtxt_block textarea').on('keyup', function() {
            if($(this).val().length > 50) {
                $(this).val($(this).val().substring(0, 50));
            }
        });

        $('.emphtxt_block2 textarea').on('keyup', function() {
            if($(this).val().length > 50) {
                $(this).val($(this).val().substring(0, 50));
            }
        });
       /*-------  알림톡 템플릿 끝  ------*/

        $('input[name="dbInfo"]').on('change', function () {
            getDBValue();
        });//end
        getDBValue();
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

        // 프리뷰에서 저장 버튼 누르기
        $(document).on('click', '#saveBtn' , function() {
            $("#form").submit();
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

        // 카카오 개인 변수 option click event
        $('#kakaoValue .option li').on('click', function () {
            let data = $(this).attr('data');
            let txt = $('.kakao_txt').val();
            if (data != 0) {
                popup.popAlert("개인화 변수 입력 후 Byte 초과시 데이터가 미반영 될 수 있습니다. ");
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

        $('.js-ad').on('click',function(){
            adTypeCheck();
        });

        // 버튼 셀렉트박스
        $(document).on('click', '.action_select ul li', function () {
            let actionVal = $(this).attr('data');
            let area = $(this).parents('.row').siblings('.custom_box');
            let layout = '';
            let parentValue = $(this).parents('.action_select').attr('data');

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
                let dataValue = "rcs_btn_tp_" + parentValue;
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
                        // let smsSubmit = smsValidate();
                        let smsSubmit = tmplValidate();
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
                            // let smsSubmit = smsValidate();
                            let smsSubmit = tmplValidate();
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

    // 알림톡 템플릿 유효성 검사
    function tmplValidate() {
        let tmplCode = $('input[name="tmplCode"]');  //템플릿 코드
        let tmplCate1 = $('.bizContsVal_group .value');  //카테고리그룹
        let tmplCate2 = $('.bizContsVal .value');  //카테고리
        let tmplName = $('input[name="tmplName"]');  //템플릿명
        let tmplMsg = $('.bizMsgVal .value'); //메시지 유형
        let tmplEmph = $('.bizEmphVal .value');  //강조유형
        let tmplTxt = $('textarea[name="tmplTxt"]');  //템플릿내용

        if(tmplCode.val() == '' || tmplCode.val() == null) {
            tmplCode.focus().addClass('outline');
            popup.popAlert("템플릿코드를 입력해주세요.");
            return false;
        }

        if(tmplCate1.text() == "카테고리 그룹") {
            tmplCate1.focus().addClass('outline');
            popup.popAlert("카테고리 그룹을 선택해주세요.");
            return false;
        } else if (tmplCate1.text() != "카테고리 그룹" && tmplCate2.text() == "카테고리") {
            tmplCate2.focus().addClass('outline');
            popup.popAlert("카테고리를 선택해주세요.");
            return false;
        }

        if(tmplName.val() == '' || tmplName.val() == null) {
            tmplName.focus().addClass('outline');
            popup.popAlert("템플릿명을 입력해주세요.");
            return false;
        }

        if(tmplTxt.val() == '' || tmplTxt.val() == null) {
            tmplTxt.focus().addClass('outline');
            popup.popAlert("템플릿내용을 입력해주세요.");
            return false;
        }

        //부가정보형, 복합형인 경우 부가정보
        let tmplAddInfo = $('textarea[name="tmplAddInfo"]');

        if(tmplMsg.text() == "부가 정보형" || tmplMsg.text() == "복합형"){
            if(tmplAddInfo.val() == '' || tmplAddInfo.val() == null) {
                tmplAddInfo.focus().addClass('outline');
                popup.popAlert("부가 정보를 입력해주세요.");
                return false;
            }
        }

        //강조표기형
        let tmplEmphTitle = $('input[name="tmplEmphTitle"]');
        let tmplEmphTxt = $('input[name="tmplEmphTxt"]');

        if(tmplEmph.text() == "강조표기형"){
            if(tmplEmphTitle.val() == '' || tmplEmphTitle.val() == null) {
                tmplEmphTitle.focus().addClass('outline');
                popup.popAlert("강조 표기 타이틀을 입력해주세요.");
                return false;
            }

            if(tmplEmphTxt.val() == '' || tmplEmphTxt.val() == null) {
                tmplEmphTxt.focus().addClass('outline');
                popup.popAlert("강조 표기 보조 문구를 입력해주세요.");
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
        com_ajax.ajax('post', '${baseURL}/cont/preview.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}')
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
        let param = {cont_nm: cont_nm}
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
            com_ajax.ajax('get', '/cont/rcsText.ajax', null, res, '${_csrf.headerName}', '${_csrf.token}');
        }
        if(checkType == 'vertical'){
            let res = function(response){
                let $doc = new DOMParser().parseFromString(response, "text/html");
                let html = $("#verticalArea", $doc).html();
                let dynamic = $('#js-replace').html(html);
                getDBValue();
                adTypeCheck();
            }
            com_ajax.ajax('get', '/cont/rcsVertical.ajax', null, res, '${_csrf.headerName}', '${_csrf.token}');
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
            com_ajax.ajax('get', '/cont/rcsSlide.ajax', null, res, '${_csrf.headerName}', '${_csrf.token}');
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

        $('input[name="cont_sub_list"]').val('');
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

        com_ajax.ajax_file('${baseURL}/cont/contentUpload.ajax', data, res, '${_csrf.headerName}', '${_csrf.token}');
    }

</script>



