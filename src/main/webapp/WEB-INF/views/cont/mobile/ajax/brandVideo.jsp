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
<div id="bodyArea">
   <div class="block">
       <div class="row">
           <div class="th">동영상 URL</div>
           <div class="td">
               <input type="text" class="txt_input en_font width kakaoImgLink" name="kko_video_url" placeholder="카카오TV 동영상 URL(https://tv.kakao.com)만 사용 가능합니다."/>
           </div>
       </div>
       <div class="row">
           <div class="th top-border">썸네일</div>
           <div class="td top-border">
               <div class="delete_img" data="kakao">
                   <img src="/image/btn_delete1.png" alt="삭제">
               </div>
               <input type="text" class="txt_input en_font" name="" id="kakaoVideoImg" placeholder="이미지를 선택해 주세요." readonly/>
               <span class="btn_sm_line" data="kakaoImage" onclick="imageListPopUp('1','kakaoVideoImg')">선택</span>
               <input type="hidden" id="kko_thumbnail_img_cd" name="kko_thumbnail_img_cd" value="">
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
               <textarea name="kakao_body" class="kakao_txt textarea" cols="30" rows="10" maxlength="76" style="width: 100%;height: 100%; resize: none;"  oninput="onchangePrevKkoTxt(this)" ></textarea>
           </div>
       </div>
       <div class="row">
           <div class="th">수신거부 문구</div>
           <div class="td">
               <input type="text" class="txt_input" name="rejectText" style="width: calc(100% - 110px);" placeholder="기본 수신거부 문구가 설정되어 있지 않습니다."/>
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
       </div>
   </div>
   <div class="flex_box" style="justify-content: right;">
       <input type="button" class="btn_sm_line addKakaoLinkRow" value="추가"/>
   </div>
</div>
