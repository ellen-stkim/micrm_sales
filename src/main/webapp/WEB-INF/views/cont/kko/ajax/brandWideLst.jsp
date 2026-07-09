<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="/WEB-INF/tlds/Page.tld" prefix="ui" %>
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil" %>
<div class="block">
    <div class="row flex_row">
        <div class="row flex_row input-img on">
            <div class="th">개인화 변수</div>
            <div class="td">
                <span style="font-size: 9px">※ 아래 박스에서 개인화 변수를 드래그한 후, 텍스트 상자에 넣거나 클릭하여 추가할 수 있습니다.</span>
                <div id="kakaoValue" style="width: 100%; max-height: 173px; overflow: auto; padding-top: 10px;"></div>
            </div>
        </div>
    </div>
</div>
<c:set var="maxLens" value="${fn:split('25,30,30,30', ',')}" />
<c:set var="countKeys" value="${fn:split('kakao_wide_lst_first,kakao_wide_lst2,kakao_wide_lst3,kakao_wide_lst4', ',')}" />
<c:forEach var="i" begin="1" end="4">
  <c:set var="idx" value="${i-1}" />
  <c:set var="imageInputId" value="${i == 1 ? 'kakaoImageItemFirst' : ('kakaoImageItem' += i)}" />
  <c:set var="prevId" value="${'prev_ft_wide_lst_img_url' += i}" />
  <div class="block" style="margin-bottom: 10px;">
    <div class="row">
      <div class="th">이미지 선택</div>
      <div class="td">
        <div class="delete_img" data="kakao">
          <img src="/image/btn_delete1.png" alt="삭제">
        </div>
        <input type="text" class="txt_input en_font" id="${imageInputId}" placeholder="이미지를 선택해 주세요." value="${list[0]['kakaoImageItemNm' += i]}" readonly/>
        <span class="btn_sm_line" data="${imageInputId}" onclick="imageListPopUp('1','${imageInputId}')">선택</span>
        <input type="hidden" id="kakao_item_img_cd_${i}" name="kakao_item_img_cd_${i}" value="${list[0]['kakao_item_img_cd_' += i]}">
        <input type="hidden" id="kko_view_item_img_url_${i}" name="kko_view_item_img_url_${i}" value="${list[0]['kko_view_item_img_url_' += i]}">
      </div>
    </div>
   <div class="row flex_box double">
      <div class="th top-border" style="line-height: 72px;">내용</div>
      <div class="td first-td right-border top-border">
        <textarea class="txt_input width kakao_btn_name kko_item_txt" name="kkoItemLst${i}" rows="2" maxlength="${maxLens[idx]}" style="resize:none;" placeholder="내용을 입력해주세요. (최대 ${maxLens[idx]}자, 줄바꿈 1회)" onkeydown="kkoCreate.itemLineBreakGuard(event)" oninput="kkoCreate.itemLineBreakTrim(this)" onkeyup="kkoCreate.titleCount(this,'${countKeys[idx]}')">${list[0]['kkoItemLst' += i]}</textarea>
      </div>
      <div class="th top-border" style="line-height: 72px;">링크 주소</div>
      <div class="td flex_box top-border" style="flex-direction: column;">
        <div class="row flex_box" style="width: 100%;">
          <div class="th">Pc 링크</div>
          <div class="td flex_box">
            <input type="text" name="kkoItemUrlLstPc${i}" class="txt_input en_font kakao_btn_linkPc" placeholder="URL 입력 (http:// 또는 https://필수입력)" onblur="smsCreate.imageLinkAdd(this, '${prevId}');" value="${list[0]['kkoItemUrlLstPc' += i]}"/>
          </div>
        </div>
        <div class="row flex_box" style="width: 100%;">
          <div class="th">Mobile 링크</div>
          <div class="td flex_box">
            <input type="text" name="kkoItemUrlLstMo${i}" class="txt_input en_font kakao_btn_linkMo" placeholder="URL 입력 (http:// 또는 https://필수입력)" onblur="smsCreate.imageLinkAdd(this, '${prevId}');" value="${list[0]['kkoItemUrlLstMo' += i]}"/>
          </div>
        </div>
      </div>
    </div>
  </div>
</c:forEach>
