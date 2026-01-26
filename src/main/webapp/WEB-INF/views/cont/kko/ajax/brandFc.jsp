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
<div class="block line_none">
    <div class="slide_tab cf">
        <div class="cardOn on" data="1">카드1</div>
        <div class="cardOn" data="2">카드2</div>
        <div class="cardOn" data="3">카드3</div>
        <div class="cardOn" data="4">카드4</div>
        <div class="cardOn" data="5">카드5</div>
        <div class="cardOn" data="6">카드6</div>
    </div>
</div>
<c:forEach var="g" varStatus="status" begin="0" end="5">
    <div class="brandFcContent<c:if test="${status.count eq '1'}"> on</c:if>">
        <div class="block">
            <div class="row">
                <div class="th">이미지</div>
                <div class="td">
                    <div class="delete_img" data="kakao">
                        <img src="/image/btn_delete1.png" alt="삭제">
                    </div>
                    <input type="text" class="txt_input en_font" id="kakaoImageFc${status.count}" name="kakaoImageFc${status.count}" placeholder="이미지를 선택해 주세요." readonly/>
                    <span class="btn_sm_line" data="kakaoImageFc${status.count}" onclick="imageListPopUp('1','kakaoImageFc${status.count}')">선택</span>
                    <input type="hidden" id="kakao_item_img_cd_${status.count}" name="kakao_item_img_cd_${status.count}" value="">
                    <input type="hidden" id="kko_view_item_img_url_${status.count}" name="kko_view_item_img_url_${status.count}" maxlength="" value="">
                </div>
            </div>
            <div class="row">
               <div class="th top-border">타이틀</div>
               <div class="td top-border">
                   <input type="text" name="kkoHeader${status.count}" class="txt_input width brandTitle" placeholder="최대 20자 이내 입력" oninput="kkoCreate.brandTitle(this, ${status.count});">
               </div>
            </div>
            <div class="row" style="height:150px;">
                <div class="th top-border">내용</div>
                <div class="td top-border">
                    <textarea name="kkoBody${status.count}" class="kakao_txt textarea" cols="30" rows="10" style="width: 100%;height: 100%; resize: none;" oninput="kkoCreate.brandFcContents(this, ${status.count})"></textarea>
                </div>
            </div>
        </div>
        <div class="block" id="addKakaoLink" style="margin-bottom: 10px;">
            <div class="row flex_box double">
               <div class="th" style="line-height: 72px;">버튼명</div>
               <div class="td first-td right-border">
                   <input type="text" class="txt_input width kakao_btn_name" name="kkoBtnLst${status.count}_1" maxlength="14" placeholder="버튼명을 입력해주세요." oninput="kkoCreate.titleCount(this,'btn')"/>
               </div>
               <div class="th" style="line-height: 72px;">버튼 링크 주소</div>
               <div class="td flex_box" style="flex-direction: column;">
                   <div class="row flex_box" style="width: 100%;">
                       <div class="th">Pc 링크</div>
                       <div class="td flex_box">
                           <input type="text" name="kkoBtnUrlLstPc${status.count}_1" class="txt_input en_font kakao_btn_linkPc" placeholder="URL 입력 (http:// 또는 https://필수입력)"/>
                       </div>
                   </div>
                   <div class="row flex_box" style="width: 100%;">
                       <div class="th">Mobile 링크</div>
                       <div class="td flex_box">
                           <input type="text" name="kkoBtnUrlLstMo${status.count}_1" class="txt_input en_font kakao_btn_linkMo" placeholder="URL 입력 (http:// 또는 https://필수입력)"/>
                       </div>
                   </div>
               </div>
               <div class="td flex_box" style="width: 273px; align-items: center;">
                   <div class="arrow arrow-down kakaoLinkArrow" style="width: 44px; height: 37px;"></div>
                   <div class="arrow arrow-up kakaoLinkArrow" style="width: 44px; height: 37px;"></div>
                   <input type="button" class="btn_sm_line kakaoLinkBtn" id="kkoBtnUrl${status.count}_1" value="생성"/>
               </div>
           </div>
            <div class="row flex_box double">
               <div class="th" style="line-height: 72px;">버튼명</div>
               <div class="td first-td right-border">
                   <input type="text" class="txt_input width kakao_btn_name" name="kkoBtnLst${status.count}_2" maxlength="14" placeholder="버튼명을 입력해주세요." oninput="kkoCreate.titleCount(this,'btn')"/>
               </div>
               <div class="th" style="line-height: 72px;">버튼 링크 주소</div>
               <div class="td flex_box" style="flex-direction: column;">
                   <div class="row flex_box" style="width: 100%;">
                       <div class="th">Pc 링크</div>
                       <div class="td flex_box">
                           <input type="text" name="kkoBtnUrlLstPc${status.count}_2" class="txt_input en_font kakao_btn_linkPc" placeholder="URL 입력 (http:// 또는 https://필수입력)"/>
                       </div>
                   </div>
                   <div class="row flex_box" style="width: 100%;">
                       <div class="th">Mobile 링크</div>
                       <div class="td flex_box">
                           <input type="text" name="kkoBtnUrlLstMo${status.count}_2" class="txt_input en_font kakao_btn_linkMo" placeholder="URL 입력 (http:// 또는 https://필수입력)"/>
                       </div>
                   </div>
               </div>
               <div class="td flex_box" style="width: 273px; align-items: center;">
                   <div class="arrow arrow-down kakaoLinkArrow" style="width: 44px; height: 37px;"></div>
                   <div class="arrow arrow-up kakaoLinkArrow" style="width: 44px; height: 37px;"></div>
                   <input type="button" class="btn_sm_line kakaoLinkBtn" id="kkoBtnUrl${status.count}_2" value="생성"/>
               </div>
           </div>
        </div>
    </div>
</c:forEach>
