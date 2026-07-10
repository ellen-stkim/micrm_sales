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
<%-- 버튼 (최대 2개) : 생성 시 빈 1행, 상세 조회 시 저장된 값 표시 --%>
<div class="block" id="addKakaoLink" style="margin-bottom: 10px;">
    <div class="row flex_box double">
        <div class="th" style="line-height: 72px;">버튼명</div>
        <div class="td first-td right-border">
            <c:choose>
                <c:when test="${fn:trim(list[0].kko_btn_nm) != ''}">
                    <input type="text" name="kkoBtnLst" class="txt_input width kakao_btn_name" maxlength="8" value="${list[0].kko_btn_nm}" readonly onkeyup="smsCreate.titleCount(this,'kakao')"/>
                </c:when>
                <c:otherwise>
                    <input type="text" name="kkoBtnLst" class="txt_input width kakao_btn_name" maxlength="8" placeholder="버튼 링크 제목을 입력해주세요." onkeyup="smsCreate.titleCount(this,'kakao')"/>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="th" style="line-height: 72px;">버튼 링크 주소</div>
        <div class="td flex_box" style="flex-direction: column;">
            <div class="row flex_box" style="width: 100%;">
                <div class="th">Pc 링크</div>
                <div class="td flex_box">
                    <input type="text" name="kkoBtnUrlLstPc" class="txt_input en_font kakao_btn_linkPc" placeholder="URL 입력 (http:// 또는 https://필수입력)" value="${list[0].kko_btn_urlPc}" <c:if test="${fn:trim(list[0].kko_btn_nm) != ''}">readonly</c:if>/>
                </div>
            </div>
            <div class="row flex_box" style="width: 100%;">
                <div class="th">Mobile 링크</div>
                <div class="td flex_box">
                    <input type="text" name="kkoBtnUrlLstMo" class="txt_input en_font kakao_btn_linkMo" placeholder="URL 입력 (http:// 또는 https://필수입력)" value="${list[0].kko_btn_url}" <c:if test="${fn:trim(list[0].kko_btn_nm) != ''}">readonly</c:if>/>
                </div>
            </div>
        </div>
        <div class="td flex_box" style="width: 273px; align-items: center;">
            <div class="arrow arrow-down kakaoLinkArrow" style="width: 44px; height: 37px;"></div>
            <div class="arrow arrow-up kakaoLinkArrow" style="width: 44px; height: 37px;"></div>
            <input type="button" class="btn_sm_line kakaoLinkBtn" <c:choose><c:when test="${fn:trim(list[0].kko_btn_url) != ''}">value="삭제"</c:when><c:otherwise>value="생성"</c:otherwise></c:choose>/>
        </div>
    </div>
    <c:if test="${!cutil:isEmptyObject(list[0].kko_btn_url2)}">
        <div class="row flex_box double">
            <div class="th" style="line-height: 72px;">버튼명</div>
            <div class="td first-td right-border">
                <input type="text" name="kkoBtnLst" class="txt_input width kakao_btn_name" maxlength="8" value="${list[0].kko_btn_nm2}" readonly onkeyup="smsCreate.titleCount(this,'kakao')"/>
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
</div>
<div class="flex_box" style="justify-content: right; align-items: center;">
    <span class="ex_txt" style="margin-right: auto;">※ 버튼은 최대 2개까지 추가할 수 있습니다.</span>
    <input type="button" class="btn_sm_line addKakaoLinkRow" value="추가"/>
</div>
