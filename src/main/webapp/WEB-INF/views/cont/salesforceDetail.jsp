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
<!-- container 영역 시작 -->
<c:if test="${fn:length(list) == 0 }">
<section class="nodataCheck">NULL</section>
</c:if>
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
            <form:form id="form" action="#" method="post" onsubmit="return false;">
            <input type="hidden" id="seq" name="mst_seq" value="${list[0].seq}"/>
            <input type="hidden" id="usr_grp_cd" name="usr_grp_cd" value="${list[0].cont_grp_cd}"/>
            <input type="hidden" id="cont_grp_cd" name="cont_grp_cd" value="${list[0].cont_grp_cd}"/>
            <c:if test="${list[1].coupon_seq != null}">
               <input type="hidden" id="coupon_seq" name="coupon_seq" value="${list[1].coupon_seq}"/>
           </c:if>
           <c:if test="${list[1].coupon_seq == null}">
               <input type="hidden" id="coupon_seq" name="coupon_seq" value=""/>
           </c:if>
            <div class="create_sms cf">
                <div class="row head bottom-border">
                    <div class="th">템플릿 명</div>
                    <div class="td right-border">
                        <input type="text" class="txt_input template_name" name="cont_nm" value="${fn:escapeXml(list[0].cont_nm)}" placeholder="템플릿 명을 입력하세요."/>
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
                    </div>
                </div><!-- //row end -->
                <div class="row head bottom-border">
                    <div class="th">캠페인 명</div>
                    <div class="td right-border">
                        <input type="text" name="camp_nm" class="txt_input " value="${fn:escapeXml(list[0].camp_nm)}" placeholder="캠페인 명을 입력하세요.">
                    </div>
                    <div class="left_flex">
                    <div class="th">팀 명</div>
                    <div class="td" style="width: 190px; ">
                        <div class="select">
                            <!-- selected value -->
                            <div class="value" id="team_cd_sel" data="${list[0].team_cd}">${!empty list[0].team_nm ? list[0].team_nm : '팀 명'}</div>
                            <ul class="option">
                                <c:forEach var="team" items="${teamLst}">
                                    <li data="${team.list_val}">${team.list_nm}</li>
                                </c:forEach>
                            </ul>
                        </div>
                    </div>
                    <%-- grp_cd 05일 경우 기본값 설정 후 변경x --%>
                    <div class="th left-border">회원 번호</div>
                    <div class="td cf" style="width: 100%;">
                        <c:if test="${fn:length(usrKeyLst) <= 0}">
                            <div class="select non_def" id="recv_usr_cd" name="edmDB">
                                <!-- selected value -->
                                <div class="value" data="${list[0].usr_key}">${!empty list[0].usr_key ? list[0].usr_key : '회원번호'}</div>
                                <ul class="option mappingLst"></ul>
                            </div>
                        </c:if>
                        <c:if test="${fn:length(usrKeyLst) > 0 and list[0].cont_grp_cd ne '05'}">
                            <div class="select" id="recv_usr_cd" name="edmDB">
                                <!-- selected value -->
                                <div class="value" data="${usrKeyLst[0].list_val}">${usrKeyLst[0].list_val}</div>
                                <ul class="option mappingLst"></ul>
                            </div>
                        </c:if>
                        <c:if test="${fn:length(usrKeyLst) > 0 and list[0].cont_grp_cd eq '05'}">
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
                                <div class="value" data="${list[0].from_to}">${list[0].from_to}</div>
                                <ul class="option mappingLst"></ul>
                            </div>
                            <input type="hidden" id="recv_phone" class="sel_value" name="from_to" value="${list[0].from_to}"/>
                        </c:if>
                        <c:if test="${fn:length(fromToLst) > 0 and list[0].cont_grp_cd ne '05'}">
                            <div class="select" id="recv_phone_to" name="edmDB">
                                <!-- selected value -->
                                <div class="value" data="${fromToLst[0].list_val}">${fromToLst[0].list_val}</div>
                                <ul class="option mappingLst"></ul>
                            </div>
                            <input type="hidden" id="recv_phone"  name="from_to" value="${fromToLst[0].list_val}"/>
                        </c:if>
                        <c:if test="${fn:length(fromToLst) > 0 and list[0].cont_grp_cd eq '05'}">
                            <div class="select" id="recv_phone_to">
                                <!-- selected value -->
                                <div class="value hidden-drop" data="${fromToLst[0].list_val}">${fromToLst[0].list_val}</div>
                            </div>
                            <input type="hidden" id="recv_phone"  name="from_to" value="${fromToLst[0].list_val}"/>
                        </c:if>
                    </div>
                    </div>
                </div>
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
                                            <input type="text" class="title kakaoTitle" name="cont_sub_list" value="${fn:escapeXml(list[0].cont_sub)}"/>
                                            <span class="ex_txt">※ 와이드 리스트형을 제외한 발송에는 반영되지 않습니다.</span>
                                        </div>
                                    </div>
                                    <div class="row body">
                                        <div class="th">타입</div>
                                        <div class="column_2">
                                            <label class="type_check">
                                                <input type="radio" name="kko_format_type" class="kkoType" value="kko_ft" ${cont_tp eq "DMTP03"?'checked': '' } />
                                                <span>브랜드톡</span>
                                            </label>
                                            <label class="type_check">
                                                <input type="radio" name="kko_format_type" class="kkoType" ${cont_tp eq "DMTP05"?'checked': '' } value="kko_at"/>
                                                <span>알림톡</span>
                                            </label>
                                        </div>
                                    </div>
                                    <div class="row body">
                                        <div class="th">발신 프로필</div>
                                        <div class="column_1">
                                            <!-- 발신 번호 후에 세팅한 값으로 변경 필요 -->
                                            <input type="text" class="sms_number smsNumber_kko" id="send_to"
                                                <c:if test="${fn:trim(list[0].send_num) != ''}">
                                                    value="${list[0].sender}(${list[0].send_num})" readonly
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
                                    <div class="row body" id="brandType" ${cont_tp eq "DMTP03"?'': 'hidden' }>
                                        <div class="th">브랜드톡 양식</div>
                                        <div class="column_1">
                                            <label class="custom_radio en_font">
                                                텍스트/이미지/와이드이미지
                                                <input name="kko_msg_tp" class="lowType" type="radio" value="0"
                                                       <c:if
                                                           test='${list[0].msg_tp ne "DMCH220" and list[0].msg_tp ne "DMCH221" and list[0].msg_tp ne "DMCH222" and list[0].msg_tp ne "DMCH223"}'>checked</c:if> />
                                                <span></span>
                                            </label>
                                            <label class="custom_radio en_font">
                                                와이드 리스트형
                                                <input name="kko_msg_tp" class="lowType" type="radio" value="1"
                                                       <c:if test='${list[0].msg_tp eq "DMCH220"}'>checked</c:if> />
                                                <span></span>
                                            </label>
                                            <label class="custom_radio en_font">
                                                캐러셀 커머스형
                                                <input name="kko_msg_tp" class="lowType" type="radio" value="2"
                                                       <c:if test='${list[0].msg_tp eq "DMCH221"}'>checked</c:if> />
                                                <span></span>
                                            </label>
                                            <label class="custom_radio en_font">
                                                캐러셀 피드형
                                                <input name="kko_msg_tp" class="lowType" type="radio" value="3"
                                                       <c:if test='${list[0].msg_tp eq "DMCH222"}'>checked</c:if> />
                                                <span></span>
                                            </label>
                                            <label class="custom_radio en_font">
                                                프리미엄 동영상형
                                                <input name="kko_msg_tp" class="lowType" type="radio" value="4"
                                                       <c:if test='${list[0].msg_tp eq "DMCH223"}'>checked</c:if> />
                                                <span></span>
                                            </label>
                                        </div>
                                    </div>
                                    <div class="row body" id="brandTarget" ${cont_tp eq "DMTP03"?'': 'hidden' }>
                                       <div class="th">브랜드톡 타겟</div>
                                        <div class="column_1">
                                            <label class="custom_radio en_font">
                                                친구톡
                                                <input name="kko_target_tp" class="lowType" type="radio" value="-"
                                                       <c:if test='${list[0].kko_tar_tp eq "-" or empty list[0].kko_tar_tp}'>checked</c:if> />
                                                <span></span>
                                            </label>
                                            <label class="custom_radio en_font">
                                                M (마케팅 수신동의 전체)
                                                <input name="kko_target_tp" class="lowType" type="radio" value="M"
                                                       <c:if test='${list[0].kko_tar_tp eq "M"}'>checked</c:if> />
                                                <span></span>
                                            </label>
                                            <label class="custom_radio en_font">
                                                N (마케팅 수신동의 고객 중 비친구)
                                                <input name="kko_target_tp" class="lowType" type="radio" value="N"
                                                       <c:if test='${list[0].kko_tar_tp eq "N"}'>checked</c:if> />
                                                <span></span>
                                            </label>
                                            <label class="custom_radio en_font">
                                                I (채널 친구 - 기존 친구톡)
                                                <input name="kko_target_tp" class="lowType" type="radio" value="I"
                                                       <c:if test='${list[0].kko_tar_tp eq "I"}'>checked</c:if> />
                                                <span></span>
                                            </label>
                                        </div>
                                    </div>
                                    <div class="input_area kko_area" id="kko_ft" ${cont_tp eq "DMTP03"?'': 'hidden' }>
                                        <c:choose>
                                            <c:when test="${list[0].msg_tp eq 'DMCH220'}">
                                                <jsp:include page="kko/ajax/brandWideLst.jsp" />
                                            </c:when>
                                            <c:when test="${list[0].msg_tp eq 'DMCH221'}">
                                                <jsp:include page="kko/ajax/brandFa.jsp" />
                                            </c:when>
                                            <c:when test="${list[0].msg_tp eq 'DMCH222'}">
                                                <jsp:include page="kko/ajax/brandFc.jsp" />
                                            </c:when>
                                            <c:when test="${list[0].msg_tp eq 'DMCH223'}">
                                                <jsp:include page="kko/ajax/brandVideo.jsp" />
                                            </c:when>
                                            <c:otherwise>
                                            <div class="block">
                                                <div class="row">
                                                    <div class="th">이미지 선택</div>
                                                    <div class="td">
                                                        <div class="delete_img" data="kakao">
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
                                                                    <a href="${list[0].kko_img_lst}" target="_blank" rel="noopener">
                                                                        <img src="${filePath}${list[0].kko_img_lst}" onerror="this.src = '/image/bg_none.png'" alt=""/>
                                                                    </a>
                                                                </c:if>
                                                                <!-- 이미지는 있고, 이미지 링크도 있을때 -->
                                                                <c:if test="${fn:trim(list[0].kko_img_lst) != '' && fn:trim(list[0].kko_img_url) != ''}">
                                                                    <a href="${list[0].kko_img_url}" target="_blank" rel="noopener">
                                                                        <img src="${filePath}${list[0].kko_img_lst}" onerror="this.src = '/image/bg_none.png'" alt=""/>
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
                                                    <div class="td bottom-border">
                                                        <textarea name="kakao_body" class="kakao_txt textarea" cols="30" rows="10" style="width: 100%;height: 100%; resize: none;" onkeyup="onchangePrevKkoTxt(this)">${cont_tp eq 'DMTP03' and fn:replace(list[0].cont_body,',','') ne '' ? list[0].cont_body :''}</textarea></div>
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
                                                        <c:choose>
                                                            <c:when test="${fn:trim(list[0].kko_btn_nm) != ''}">
                                                                <input type="text" name="kkoBtnLst" class="txt_input width kakao_btn_name" maxlength="14" value="${list[0].kko_btn_nm}" readonly onkeyup="smsCreate.titleCount(this,'kakao')"/>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <input type="text" name="kkoBtnLst" class="txt_input width kakao_btn_name" maxlength="14" placeholder="버튼 링크 제목을 입력해주세요." onkeyup="smsCreate.titleCount(this,'kakao')"/>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="th" style="line-height: 72px;">버튼 링크 주소</div>
                                                    <div class="td flex_box" style="flex-direction: column;">
                                                        <div class="row flex_box" style="width: 100%;">
                                                            <div class="th">Pc 링크</div>
                                                            <div class="td flex_box">
                                                                <input type="text" name="kkoBtnUrlLstPc" class="txt_input en_font kakao_btn_linkPc" placeholder="URL 입력 (http:// 또는 https://필수입력)" value="${list[0].kko_btn_urlPc}"
                                                                    <c:if test="${fn:trim(list[0].kko_btn_nm) != ''}">
                                                                        readonly
                                                                    </c:if>
                                                                />
                                                            </div>
                                                        </div>
                                                        <div class="row flex_box" style="width: 100%;">
                                                            <div class="th">Mobile 링크</div>
                                                            <div class="td flex_box">
                                                                <input type="text" name="kkoBtnUrlLstMo" class="txt_input en_font kakao_btn_linkMo" placeholder="URL 입력 (http:// 또는 https://필수입력)" value="${list[0].kko_btn_url}"
                                                                    <c:if test="${fn:trim(list[0].kko_btn_nm) != ''}">
                                                                        readonly
                                                                    </c:if>
                                                                />
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="td flex_box" style="width: 273px; align-items: center;">
                                                        <div class="arrow arrow-down kakaoLinkArrow" style="width: 44px; height: 37px;"></div>
                                                        <div class="arrow arrow-up kakaoLinkArrow" style="width: 44px; height: 37px;"></div>
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
                                                <c:if test="${!cutil:isEmptyObject(list[0].kko_btn_url2)}">
                                                    <div class="row flex_box double">
                                                        <div class="th" style="line-height: 72px;">버튼명</div>
                                                        <div class="td first-td right-border">
                                                            <input type="text" name="kkoBtnLst" class="txt_input width kakao_btn_name" value="${list[0].kko_btn_nm2}" readonly onkeyup="smsCreate.titleCount(this,'kakao')"/>
                                                        </div>
                                                        <div class="th" style="line-height: 72px;">버튼 링크 주소</div>
                                                        <div class="td flex_box" style="flex-direction: column;">
                                                            <div class="row flex_box" style="width: 100%;">
                                                                <div class="th">Pc 링크</div>
                                                                <div class="td flex_box">
                                                                    <input type="text" name="kkoBtnUrlLstPc" class="txt_input en_font kakao_btn_linkPc" placeholder="URL 입력 (http:// 또는 https://필수입력)" value="${list[0].kko_btn_urlPc2}" readonly/>
                                                                </div>
                                                            </div>
                                                            <div class="row flex_box" style="width: 100%;">
                                                                <div class="th">Mobile 링크</div>
                                                                <div class="td flex_box">
                                                                    <input type="text" name="kkoBtnUrlLstMo" class="txt_input en_font kakao_btn_linkMo" placeholder="URL 입력 (http:// 또는 https://필수입력)" value="${list[0].kko_btn_url2}" readonly/>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="td flex_box" style="width: 273px; align-items: center;">
                                                            <div class="arrow arrow-down kakaoLinkArrow" style="width: 44px; height: 37px;"></div>
                                                            <div class="arrow arrow-up kakaoLinkArrow" style="width: 44px; height: 37px;"></div>
                                                            <input type="button" class="btn_sm_line kakaoLinkBtn" value="삭제"/>
                                                        </div>
                                                    </div>
                                                </c:if>
                                                <c:if test="${!cutil:isEmptyObject(list[0].kko_btn_url3)}">
                                                    <div class="row flex_box double">
                                                        <div class="th" style="line-height: 72px;">버튼명</div>
                                                        <div class="td first-td right-border">
                                                            <input type="text" name="kkoBtnLst" class="txt_input width kakao_btn_name" value="${list[0].kko_btn_nm3}" readonly onkeyup="smsCreate.titleCount(this,'kakao')"/>
                                                        </div>
                                                        <div class="th" style="line-height: 72px;">버튼 링크 주소</div>
                                                        <div class="td flex_box" style="flex-direction: column;">
                                                            <div class="row flex_box" style="width: 100%;">
                                                                <div class="th">Pc 링크</div>
                                                                <div class="td flex_box">
                                                                    <input type="text" name="kkoBtnUrlLstPc" class="txt_input en_font kakao_btn_linkPc" placeholder="URL 입력 (http:// 또는 https://필수입력)" value="${list[0].kko_btn_urlPc3}" readonly/>
                                                                </div>
                                                            </div>
                                                            <div class="row flex_box" style="width: 100%;">
                                                                <div class="th">Mobile 링크</div>
                                                                <div class="td flex_box">
                                                                    <input type="text" name="kkoBtnUrlLstMo" class="txt_input en_font kakao_btn_linkMo" placeholder="URL 입력 (http:// 또는 https://필수입력)" value="${list[0].kko_btn_url3}" readonly/>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="td flex_box" style="width: 273px; align-items: center;">
                                                            <div class="arrow arrow-down kakaoLinkArrow" style="width: 44px; height: 37px;"></div>
                                                            <div class="arrow arrow-up kakaoLinkArrow" style="width: 44px; height: 37px;"></div>
                                                            <input type="button" class="btn_sm_line kakaoLinkBtn" value="삭제"/>
                                                        </div>
                                                    </div>
                                                </c:if>
                                                <c:if test="${!cutil:isEmptyObject(list[0].kko_btn_url4)}">
                                                    <div class="row flex_box double">
                                                        <div class="th" style="line-height: 72px;">버튼명</div>
                                                        <div class="td first-td right-border">
                                                            <input type="text" name="kkoBtnLst" class="txt_input width kakao_btn_name" value="${list[0].kko_btn_nm4}" readonly onkeyup="smsCreate.titleCount(this,'kakao')"/>
                                                        </div>
                                                        <div class="th" style="line-height: 72px;">버튼 링크 주소</div>
                                                        <div class="td flex_box" style="flex-direction: column;">
                                                            <div class="row flex_box" style="width: 100%;">
                                                                <div class="th">Pc 링크</div>
                                                                <div class="td flex_box">
                                                                    <input type="text" name="kkoBtnUrlLstPc" class="txt_input en_font kakao_btn_linkPc" placeholder="URL 입력 (http:// 또는 https://필수입력)" value="${list[0].kko_btn_urlPc4}" readonly/>
                                                                </div>
                                                            </div>
                                                            <div class="row flex_box" style="width: 100%;">
                                                                <div class="th">Mobile 링크</div>
                                                                <div class="td flex_box">
                                                                    <input type="text" name="kkoBtnUrlLstMo" class="txt_input en_font kakao_btn_linkMo" placeholder="URL 입력 (http:// 또는 https://필수입력)" value="${list[0].kko_btn_url4}" readonly/>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="td flex_box" style="width: 273px; align-items: center;">
                                                            <div class="arrow arrow-down kakaoLinkArrow" style="width: 44px; height: 37px;"></div>
                                                            <div class="arrow arrow-up kakaoLinkArrow" style="width: 44px; height: 37px;"></div>
                                                            <input type="button" class="btn_sm_line kakaoLinkBtn" value="삭제"/>
                                                        </div>
                                                    </div>
                                                </c:if>
                                                <c:if test="${!cutil:isEmptyObject(list[0].kko_btn_url5)}">
                                                    <div class="row flex_box double">
                                                        <div class="th" style="line-height: 72px;">버튼명</div>
                                                        <div class="td first-td right-border">
                                                            <input type="text" name="kkoBtnLst" class="txt_input width kakao_btn_name" value="${list[0].kko_btn_nm5}" readonly onkeyup="smsCreate.titleCount(this,'kakao')"/>
                                                        </div>
                                                        <div class="th" style="line-height: 72px;">버튼 링크 주소</div>
                                                        <div class="td flex_box" style="flex-direction: column;">
                                                            <div class="row flex_box" style="width: 100%;">
                                                                <div class="th">Pc 링크</div>
                                                                <div class="td flex_box">
                                                                    <input type="text" name="kkoBtnUrlLstPc" class="txt_input en_font kakao_btn_linkPc" placeholder="URL 입력 (http:// 또는 https://필수입력)" value="${list[0].kko_btn_urlPc5}" readonly/>
                                                                </div>
                                                            </div>
                                                            <div class="row flex_box" style="width: 100%;">
                                                                <div class="th">Mobile 링크</div>
                                                                <div class="td flex_box">
                                                                    <input type="text" name="kkoBtnUrlLstMo" class="txt_input en_font kakao_btn_linkMo" placeholder="URL 입력 (http:// 또는 https://필수입력)" value="${list[0].kko_btn_url5}" readonly/>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="td flex_box" style="width: 273px; align-items: center;">
                                                            <div class="arrow arrow-down kakaoLinkArrow" style="width: 44px; height: 37px;"></div>
                                                            <div class="arrow arrow-up kakaoLinkArrow" style="width: 44px; height: 37px;"></div>
                                                            <input type="button" class="btn_sm_line kakaoLinkBtn" value="삭제"/>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </div>
                                            <div class="flex_box" style="justify-content: right;">
                                                <input type="button" class="btn_sm_line addKakaoLinkRow" value="추가"/>
                                            </div>
                                            </c:otherwise>
                                        </c:choose>
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
                                <div class="viewer_area" id="kakao_ft_viewer" <c:if test='${cont_tp ne "DMTP03" or (list[0].msg_tp eq "DMCH221" or list[0].msg_tp eq "DMCH222")}'>hidden</c:if>>
                                    <div class="top">브랜드톡 미리보기</div>
                                    <div class="inner">
                                        <div class="row_body">
                                            <div class="round_box">
                                                <div class="kakao_ft sms_img_box" id="prev_ft_img">
                                                    <!-- 이미지는 있고, 이미지 링크는 없을때 -->
                                                    <c:if test="${cont_tp eq 'DMTP03'}">
                                                        <c:if test="${fn:trim(list[0].kko_img_lst) != '' && fn:trim(list[0].kko_img_url) == ''}">
                                                            <a href="${list[0].kko_img_lst}" target="_blank" rel="noopener">
                                                                <img src="${filePath}${list[0].kko_img_lst}"  onerror="this.src = '/image/bg_none.png'" alt=""/>
                                                            </a>
                                                        </c:if>
                                                        <!-- 이미지는 있고, 이미지 링크도 있을때 -->
                                                        <c:if test="${fn:trim(list[0].kko_img_lst) != '' && fn:trim(list[0].kko_img_url) != ''}">
                                                            <a href="${list[0].kko_img_url}" target="_blank" rel="noopener">
                                                                <img src="${filePath}${list[0].kko_img_lst}" onerror="this.src = '/image/bg_none.png'" alt=""/>
                                                            </a>
                                                        </c:if>
                                                    </c:if>
                                                </div>
                                                <div class="kakao_ft" id="prev_ft_video">
                                                    <c:if test='${list[0].msg_tp eq "DMCH223"}'>
                                                       <c:set var="parts" value="${fn:split(list[0].kko_video_url, '/')}" />
                                                       <c:set var="videoId" value="${parts[fn:length(parts) - 1]}" />
                                                       <c:set var="convertedUrl" value="https://play-tv.kakao.com/embed/player/cliplink/${videoId}?service=player_share" />
                                                       <div class="">
                                                          <iframe src="${convertedUrl}" width="100%"></iframe>
                                                       </div>
                                                    </c:if>
                                                </div>
                                                <p class="kakao_txt" id="prev_ft_txt" <c:if test='${list[0].msg_tp eq "DMCH220"}'>style="display: none;"</c:if>>${cutil:replaceBr(list[0].cont_body)}</p>
                                                <c:if test="${fn:trim(list[0].kko_btn_nm) != ''}">
                                                    <a href="${list[0].kko_btn_url}" class="kakao_link" target="_blank" rel="noopener">${list[0].kko_btn_nm}</a>
                                                </c:if>
                                                <c:if test="${!cutil:isEmptyObject(fn:trim(list[0].kko_btn_url2))}">
                                                    <a href="${list[0].kko_btn_url2}" class="kakao_link" target="_blank" rel="noopener">${list[0].kko_btn_nm2}</a>
                                                </c:if>
                                                <c:if test="${!cutil:isEmptyObject(fn:trim(list[0].kko_btn_url3))}">
                                                    <a href="${list[0].kko_btn_url3}" class="kakao_link" target="_blank" rel="noopener">${list[0].kko_btn_nm3}</a>
                                                </c:if>
                                                <c:if test="${!cutil:isEmptyObject(fn:trim(list[0].kko_btn_url4))}">
                                                    <a href="${list[0].kko_btn_url4}" class="kakao_link" target="_blank" rel="noopener">${list[0].kko_btn_nm4}</a>
                                                </c:if>
                                                <c:if test="${!cutil:isEmptyObject(fn:trim(list[0].kko_btn_url5))}">
                                                    <a href="${list[0].kko_btn_url5}" class="kakao_link" target="_blank" rel="noopener">${list[0].kko_btn_nm5}</a>
                                                </c:if>
                                                <div class="kakao_wide_lst" id="prev_ft_wide_lst" <c:if test='${list[0].msg_tp eq "DMCH220"}'>style="display: block"</c:if>>
                                                    <strong class="kakao_wide_lst_strong">
                                                        <span class="kakao_wide_lst_title" id="prev_ft_wide_lst_title">${fn:escapeXml(list[0].cont_sub)}</span>
                                                    </strong>
                                                    <div class="kakao_wide_lst_main_div">
                                                        <ul class="kakao_wide_lst_ul">
                                                            <li class="kakao_wide_lst_li_first">
                                                                <div class="kakao_wide_lst_li_first_div">
                                                                    <a href="${list[0].kkoItemUrlLstMo1}" target="_blank" class="kakao_wide_lst_li_first_a" id="prev_ft_wide_lst_img_url1">
                                                                        <img id="prev_ft_wide_lst_img1" src="${list[0].kko_view_item_img_url_1}" alt="" role="presentation" style="min-height: 41px;">
                                                                    </a>
                                                                </div>
                                                                <p class="kakao_wide_lst_li_first_p">
                                                                    <span class="kakao_wide_lst_li_first_span" id="prev_ft_wide_lst_txt1" >${list[0].kkoItemLst1}</span>
                                                                </p>
                                                            </li>
                                                            <li class="kakao_wide_lst_li">
                                                                <div class="kakao_wide_lst_li_div">
                                                                    <a href="${list[0].kkoItemUrlLstMo2}" target="_blank" class="kakao_wide_lst_li_a" id="prev_ft_wide_lst_img_url2">
                                                                        <img id="prev_ft_wide_lst_img2" src="${list[0].kko_view_item_img_url_2}" alt="" role="presentation" style="min-height: 41px;">
                                                                    </a>
                                                                </div>
                                                                <p class="kakao_wide_lst_li_p">
                                                                    <span class="kakao_wide_lst_li_span" id="prev_ft_wide_lst_txt2">${list[0].kkoItemLst2}</span>
                                                                </p>
                                                            </li>
                                                            <li class="kakao_wide_lst_li">
                                                                <div class="kakao_wide_lst_li_div">
                                                                    <a href="${list[0].kkoItemUrlLstMo3}" target="_blank" class="kakao_wide_lst_li_a" id="prev_ft_wide_lst_img_url3">
                                                                        <img id="prev_ft_wide_lst_img3" src="${list[0].kko_view_item_img_url_3}" alt="" role="presentation" style="min-height: 41px;">
                                                                    </a>
                                                                </div>
                                                                <p class="kakao_wide_lst_li_p">
                                                                    <span class="kakao_wide_lst_li_span" id="prev_ft_wide_lst_txt3">${list[0].kkoItemLst3}</span>
                                                                </p>
                                                            </li>
                                                            <li class="kakao_wide_lst_li">
                                                                <div class="kakao_wide_lst_li_div">
                                                                    <a href="${list[0].kkoItemUrlLstMo4}" target="_blank" class="kakao_wide_lst_li_a" id="prev_ft_wide_lst_img_url4">
                                                                        <img id="prev_ft_wide_lst_img4" src="${list[0].kko_view_item_img_url_4}" alt="" role="presentation" style="min-height: 41px;">
                                                                    </a>
                                                                </div>
                                                                <p class="kakao_wide_lst_li_p">
                                                                    <span class="kakao_wide_lst_li_span" id="prev_ft_wide_lst_txt4">${list[0].kkoItemLst4}</span>
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
                                        <span class="en_font">byte</span>(버튼제외)<br><br>
                                        <span class="en_font">※ 텍스트 유형 최대 1000자</span><br>
                                        <span class="en_font">※ 이미지 유형 최대 400자</span>
                                    </div>
                                </div>
                                <div class="viewer_area" id="kakao_at_viewer" <c:if test="${cont_tp ne 'DMTP05'}">hidden="hidden" </c:if>>
                                    <div class="top">알림톡 미리보기</div>
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
                                                                    <img src="${tmpl.kko_img_url}" style="max-height: 135px;" onerror="this.src = '/image/bg_none.png'" alt="">
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
                                                                            <div class="right_img_box">
                                                                                <img src="${highlight.imageUrl}" onerror="this.src = '/image/bg_none.png'" alt="">
                                                                            </div>
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
                                                            <div class="cont">${cutil:replaceBr(tmpl.cont_body)}</div>
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
                                                                    <a href="${btn.linkPc}" target="_blank" class="sms_btn" rel="noopener">${btn.name}</a></c:if>
                                                            </c:forEach>
                                                        </c:if>
                                                        <%--
                                                        <input type="hidden" class="kakao_txt" name="kakao_body" value="${list[0].cont_body}">
                                                        --%>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="viewer_area" id="kakao_brand_viewer" <c:if test='${cont_tp ne "DMTP03" or (list[0].msg_tp ne "DMCH221" and list[0].msg_tp ne "DMCH222")}'>hidden="hidden"</c:if>>
                                    <div class="top">브랜드톡 미리보기</div>
                                    <div class="rcs_inner kko_slide">
                                        <div class="slide_area">
                                            <div class="kko_prev">
                                                <img src="/image/ico_rcs_prev.png" alt="">
                                            </div>
                                            <div class="kko_next">
                                                <img src="/image/ico_rcs_next.png" alt="">
                                            </div>
                                            <div class="swiper-container medium kkoBrandFaSwiper" <c:if test='${list[0].msg_tp ne "DMCH221"}'>hidden="hidden"</c:if>>
                                                <div class="swiper-wrapper">
                                                    <c:forEach var="idx" begin="0" end="6" >
                                                        <div class="swiper-slide slide${idx}">
                                                            <section>
                                                                <div class="img_area">
                                                                    <img id="brandFaImgArea${idx}" src="${list[0]['kko_view_item_img_url_' += idx]}" onerror="this.src = '/image/bg_none.png'" alt=""/>
                                                                </div>
                                                                <c:set var="imgIdx" value="${idx+1}"/>
                                                                <div class="txt_area">
                                                                    <h3 id="brandFatitleArea${idx}">
                                                                        <c:choose>
                                                                            <c:when test="${not empty list[0]['kkoHeader' += idx]}">
                                                                                ${list[0]['kkoHeader' += idx]}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                타이틀을 입력해주세요.
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </h3>
                                                                    <dl class="list_price" >
                                                                        <dd class="dc_price" id="brandFaDiscount${idx}"></dd>
                                                                        <dd class="normal_price" id="brandFaPrice${idx}"></dd>
                                                                        <dd class="sale_percent" id="brandFaPercent${idx}"></dd>
                                                                    </dl>
                                                                    <div style=" display: block; width: 100%; height: 1px; margin: 8px 1px; background-color: rgba(0, 0, 0, 0.08);"></div>
                                                                    <p id="brandFatextArea${idx}" style="padding-top: 10px; overflow-wrap: anywhere; word-break: break-word; white-space: normal;">
                                                                        <c:choose>
                                                                            <c:when test="${not empty list[0]['kkoBody' += idx]}">
                                                                                ${list[0]['kkoBody' += idx]}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                내용을 입력해주세요.
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </p>
                                                                    <c:if test="${idx ne 0}">
                                                                        <div id="brandFaBtn${idx}" style="display: flex; gap: 12px; align-items: center;">
                                                                            <div class="kakao_link" id="brandFaBtn${idx}_1" data="1" <c:if test="${empty list[0]['kkoBtnLst' += idx += '_1']}">style="display: none"</c:if>>${list[0]['kkoBtnLst' += idx += '_1']}</div>
                                                                            <div class="kakao_link" id="brandFaBtn${idx}_2" data="2" <c:if test="${empty list[0]['kkoBtnLst' += idx += '_2']}">style="display: none"</c:if>>${list[0]['kkoBtnLst' += idx += '_2']}</div>
                                                                        </div>
                                                                    </c:if>
                                                                </div>
                                                            </section>
                                                            <div class="text_count">
                                                                <span class="num en_font">
                                                                    <span id="brandFatextByte${idx}">
                                                                        <c:choose>
                                                                            <c:when test="${not empty list[0]['kkoBody' += idx]}">
                                                                                ${fn:length(list[0]['kkoBody' += idx])}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                0
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </span>/${idx eq 0 ? '50' : '34'}
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
                                            <div class="swiper-container medium kkoBrandFcSwiper" <c:if test='${list[0].msg_tp ne "DMCH222"}'>hidden="hidden"</c:if>>
                                                <div class="swiper-wrapper">
                                                    <c:forEach var="idx" begin="1" end="6" >
                                                        <div class="swiper-slide slide${idx}">
                                                            <section>
                                                                <div class="img_area">
                                                                    <img id="brandFcImgArea${idx}" src="${list[0]['kko_view_item_img_url_' += idx]}" onerror="this.src = '/image/bg_none.png'" alt=""/>
                                                                </div>
                                                                <c:set var="imgIdx" value="${idx+1}"/>
                                                                <div class="txt_area">
                                                                    <h3 id="brandFctitleArea${idx}">
                                                                        <c:choose>
                                                                            <c:when test="${not empty list[0]['kkoHeader' += idx]}">
                                                                                ${list[0]['kkoHeader' += idx]}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                타이틀을 입력해주세요.
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </h3>
                                                                    <div style=" display: block; width: 100%; height: 1px; margin: 8px 1px; background-color: rgba(0, 0, 0, 0.08);"></div>
                                                                    <p id="brandFctextArea${idx}" style="padding-top: 10px; overflow-wrap: anywhere; word-break: break-word; white-space: normal;">
                                                                        <c:choose>
                                                                            <c:when test="${not empty list[0]['kkoBody' += idx]}">
                                                                                ${list[0]['kkoBody' += idx]}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                내용을 입력해주세요.
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </p>
                                                                    <div id="brandFcBtn${idx}" style="display: flex; gap: 12px; align-items: center;">
                                                                        <div class="kakao_link" id="brandFcBtn${idx}_1" data="1" <c:if test="${empty list[0]['kkoBtnLst' += idx += '_1']}">style="display: none"</c:if>>${list[0]['kkoBtnLst' += idx += '_1']}</div>
                                                                        <div class="kakao_link" id="brandFcBtn${idx}_2" data="2" <c:if test="${empty list[0]['kkoBtnLst' += idx += '_2']}">style="display: none"</c:if>>${list[0]['kkoBtnLst' += idx += '_2']}</div>
                                                                    </div>
                                                                </div>
                                                            </section>
                                                            <div class="text_count">
                                                                <span class="num en_font">
                                                                    <span id="brandFctextByte${idx}">
                                                                        <c:choose>
                                                                            <c:when test="${not empty list[0]['kkoBody' += idx]}">
                                                                                ${fn:length(list[0]['kkoBody' += idx])}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                0
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </span>/180
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
                                                    <input type="text" class="title type1 smsTitle" name="cont_sub_list" onkeyup="onchangePrevSmsTitle(this)" value="${fn:escapeXml(list[1].cont_sub)}"/>
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
                                                            <a href="${fn:split(list[1].img_lst,",")[0]}" target="_blank" rel="noopener">
                                                                <img src="${filePath}${fn:split(list[1].img_lst,",")[0]}" onerror="this.src = '/image/bg_none.png'" alt="" />
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
                                                    <div class="td bottom-border">
                                                        <textarea name="sms_body" class="sms_body textarea" id="sms_txt_area" cols="30" rows="10" style="width: 100%;height: 100%; resize: none;" onkeyup="onchangePrevSmsTxt(this)">${list[1].cont_body}</textarea>
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
                                                        <c:if test="${list[1].coupon_seq != null}">
                                                            <input type ="hidden" id="savedCouponSeq" value="${list[1].coupon_seq}"/>
                                                            <input type ="hidden" id="savedCouponNm" value="${list[1].coupon_nm}"/>
                                                            <div style="flex-grow: 1; display: flex">
                                                                <input type="text" name="" id="couponNameInput" style="max-width: 540px;" placeholder="" value="{${list[1].coupon_nm} 쿠폰링크}" readonly/>
                                                                <button type="button" class="close" id="couponCancelBtn" data-dismiss="modal" aria-hidden="true" onclick="couponCancel();">×</button>
                                                            </div>
                                                        </c:if>
                                                        <c:if test="${list[1].coupon_seq == null}">
                                                            <input type ="hidden" id="savedCouponSeq" value=""/>
                                                            <input type ="hidden" id="savedCouponNm" value=""/>
                                                            <div style="flex-grow: 1; display: flex">
                                                                <input type="text" name="" placeholder="" value="" readonly/>
                                                                <button type="button" class="close" id="couponCancelBtn" data-dismiss="modal" aria-hidden="true" style="display: none" onclick="couponCancel();">×</button>
                                                            </div>
                                                        </c:if>
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
                                                        <label class="custom_radio">사용함<input class="" name="short_url_yn" type="radio" value="Y" <c:if test="${fn:trim(list[1].short_url_yn) eq 'Y'}">checked</c:if>/><span></span></label>
                                                        <label class="custom_radio">사용안함<input class="" name="short_url_yn" type="radio" value="N" <c:if test="${fn:trim(list[1].short_url_yn) ne 'Y'}">checked</c:if>/><span></span></label>
                                                    </div>
                                                </div>
                                                --%>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="viewer_area">
                                        <div class="top">문자 미리보기</div>
                                        <div class="inner" style="width: 270px">
                                            <div class="sms_title" id="prev_sms_title">${list[1].cont_sub}</div>
                                            <%--<div class="sms_img"></div>--%>
                                            <div class="sms_img_box" id="sms_img_box">
                                                <c:if test="${fn:trim(list[1].msg_tp) eq 'DMCH203'}">
                                                <a href="${fn:split(list[1].img_lst,",")[0]}" target="_blank" rel="noopener">
                                                    <img src="${filePath}${fn:split(list[1].img_lst,",")[0]}" onerror="this.src = '/image/bg_none.png'" alt=""/>
                                                </a>
                                                </c:if>
                                            </div>
                                            <div class="text_box"><p class="scroll_txt_area" id="smsTextArea">${cutil:replaceBr(list[1].cont_body)}</p></div>
                                        </div>
                                        <div class="byte"  style="width: 270px">
                                            <span class="en_font sms_byte">0</span><span class="en_font">byte</span>
                                            <br> <br>
                                            <span class="en_font">※ LMS 유형 최대 2000자</span> <br>
                                            <span class="en_font">※ MMS 유형 최대 1000자</span> <br>
                                            <span class="en_font">※ SMS 유형 최대 90자</span>
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
                                                <span id="js-title-area"></span>
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
                                                <input type="text" class="title rcsTitle" name="cont_sub_list" value="${fn:escapeXml(list[2].cont_sub)}"
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
                                                            <img src="${filePath}${fn:split(list[2].img_lst,',')[0]}" onerror="this.src = '/image/bg_none.png'" alt="img" />
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
                                                            <img src="${filePath}${fn:split(list[2].img_lst,',')[0]}" onerror="this.src = '/image/bg_none.png'"  alt="img" />
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
                                            <input type="text" class="sms_number smsNumber" id="send_slice_rcs" placeholder="발신 번호를 입력해주세요." readonly="">
                                        </c:if>
                                        <c:if test="${fn:trim(list[2].send_to) != ''}">
                                            <input type="text" class="sms_number smsNumber" id="send_slice_rcs" value="${list[2].sender}(${list[2].send_num})"/>
                                        </c:if>
                                        <input type="hidden" name="send_to_list" id="slide_send_num" value="${list[2].send_to}"/>
                                        <span class="btn_sm_line" onclick="mobileSenderPopup('1','slidercs')">변경</span>
                                    </div>
                                </div>
                                <div class="input_area left">
                                    <div class="block line_none">
                                        <div class="slide_tab cf">
                                            <c:forEach var="i" begin="1" end="${list[2].cardSize}">
                                                <c:if test="${i eq 1}">
                                                    <div id="cardOn" class="cardOn on" data="${i}">카드${i}</div>
                                                </c:if>
                                                <c:if test="${i ne 1}">
                                                    <div id="cardOn" class="cardOn" data="${i}">카드${i}</div>
                                                </c:if>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <c:forEach var="idx" begin="0" end="${list[2].cardSize-1}" varStatus="st">
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
                                                            <img src="${baseURL}/image/btn_delete1.png" alt="삭제">
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
                                                            <c:set var="btnCnt1" value="${btnCnt1+2}"></c:set>
                                                            <c:set var="btn" value="${list[2].cont_btn_json[idx]['suggestions'][0]}"/>
                                                            <c:choose>
                                                                <c:when test="${!cutil:isEmptyObject(btn['action']['clipboardAction']['copyToClipboard'])}">
                                                                    <div class="value" data="RBTN01" style="color: rgb(34, 34, 34);">복사하기</div>
                                                                </c:when>
                                                                <c:when test="${!cutil:isEmptyObject(btn['action']['urlAction']['openUrl'])}">
                                                                    <div class="value" data="RBTN02" style="color: rgb(34, 34, 34);">URL연결</div>
                                                                </c:when>
                                                                <c:when test="${!cutil:isEmptyObject(btn['action']['dialerAction'])}">
                                                                    <div class="value" data="RBTN03" style="color: rgb(34, 34, 34);">전화걸기</div>
                                                                </c:when>
                                                                <c:when test="${!cutil:isEmptyObject(btn['action']['mapAction']['showLocation']['location']['latitude'])}">
                                                                    <div class="value" data="RBTN04" style="color: rgb(34, 34, 34);">지도보여주기(좌표)</div>
                                                                </c:when>
                                                                <c:when test="${!cutil:isEmptyObject(btn['action']['mapAction']['showLocation']['location']['query'])}">
                                                                    <div class="value" data="RBTN05" style="color: rgb(34, 34, 34);">지도보여주기(쿼리)</div>
                                                                </c:when>
                                                                <c:when test="${!cutil:isEmptyObject(btn['action']['mapAction'])}">
                                                                    <c:choose>
                                                                        <c:when test="${cutil:isEmptyObject(btn['action']['mapAction']['showLocation'])}">
                                                                            <div class="value" data="RBTN06" style="color: rgb(34, 34, 34);">현재위치공유</div>
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
                                                                    <img src="${filePath}${imgNm}" onerror="this.src = '/image/bg_none.png'" alt=""/>
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
                <input type="button" class="btn_save btn_bg btn_center btn_size1" id="previewBtn" value="저장"/>
            </div>
        </div>
    </div>
    </form:form>
    <footer class="footer">
        &copy; Milvus Corp.
    </footer>
</section>

