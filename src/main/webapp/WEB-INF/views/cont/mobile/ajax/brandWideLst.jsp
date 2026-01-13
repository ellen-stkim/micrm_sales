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
<%@ taglib uri="tld/Commonutils.tld" prefix="cutil" %>
<div id="bodyArea">
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
    <div class="block" style="margin-bottom: 10px;">
        <div class="row">
            <div class="th">이미지 선택</div>
            <div class="td">
                <div class="delete_img" data="kakao">
                    <img src="/image/btn_delete1.png" alt="삭제">
                </div>
                <input type="text" class="txt_input en_font" id="kakaoImageItemFirst" placeholder="이미지를 선택해 주세요." readonly/>
                <span class="btn_sm_line" data="kakaoImageItemFirst" onclick="imageListPopUp('1','kakaoImageItemFirst')">선택</span>
                <input type="hidden" id="kakao_item_img_cd_1" name="kakao_item_img_cd_1" value="">
                <input type="hidden" id="kko_view_item_img_url_1" name="kko_view_item_img_url_1" maxlength="" value="">
            </div>
        </div>
        <div class="row flex_box double">
            <div class="th top-border" style="line-height: 72px;">내용</div>
            <div class="td first-td right-border top-border">
                <input type="text" class="txt_input width kakao_btn_name" name="kkoItemLst1" maxlength="25" placeholder="내용을 입력해주세요. (최대 25자)" onkeyup="smsCreate.titleCount(this,'kakao_wide_lst_first')"/>
            </div>
            <div class="th top-border" style="line-height: 72px;">링크 주소</div>
            <div class="td flex_box top-border" style="flex-direction: column;">
                <div class="row flex_box" style="width: 100%;">
                    <div class="th">Pc 링크</div>
                    <div class="td flex_box">
                        <input type="text" name="kkoItemUrlLstPc1" class="txt_input en_font kakao_btn_linkPc" placeholder="URL 입력 (http:// 또는 https://필수입력)" onblur="smsCreate.imageLinkAdd(this, 'prev_ft_wide_lst_img_url1');"/>
                    </div>
                </div>
                <div class="row flex_box" style="width: 100%;">
                    <div class="th">Mobile 링크</div>
                    <div class="td flex_box">
                        <input type="text" name="kkoItemUrlLstMo1" class="txt_input en_font kakao_btn_linkMo" placeholder="URL 입력 (http:// 또는 https://필수입력)" onblur="smsCreate.imageLinkAdd(this, 'prev_ft_wide_lst_img_url1');"/>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="block" style="margin-bottom: 10px;">
        <div class="row">
            <div class="th">이미지 선택</div>
            <div class="td">
                <div class="delete_img" data="kakao">
                    <img src="/image/btn_delete1.png" alt="삭제">
                </div>
                <input type="text" class="txt_input en_font" id="kakaoImageItem2"  placeholder="이미지를 선택해 주세요." readonly/>
                <span class="btn_sm_line" data="kakaoImageItem" onclick="imageListPopUp('1','kakaoImageItem2')">선택</span>
                <input type="hidden" id="kakao_item_img_cd_2" name="kakao_item_img_cd_2" value="">
                <input type="hidden" id="kko_view_item_img_url_2" name="kko_view_item_img_url_2" maxlength="" value="">
            </div>
        </div>
        <div class="row flex_box double">
            <div class="th top-border" style="line-height: 72px;">내용</div>
            <div class="td first-td right-border top-border">
                <input type="text" class="txt_input width kakao_btn_name" name="kkoItemLst2" maxlength="30" placeholder="내용을 입력해주세요. (최대 30자)" onkeyup="smsCreate.titleCount(this,'kakao_wide_lst2')"/>
            </div>
            <div class="th top-border" style="line-height: 72px;">링크 주소</div>
            <div class="td flex_box top-border" style="flex-direction: column;">
                <div class="row flex_box" style="width: 100%;">
                    <div class="th">Pc 링크</div>
                    <div class="td flex_box">
                        <input type="text" name="kkoItemUrlLstPc2" class="txt_input en_font kakao_btn_linkPc" placeholder="URL 입력 (http:// 또는 https://필수입력)" onblur="smsCreate.imageLinkAdd(this, 'prev_ft_wide_lst_img_url2');"/>
                    </div>
                </div>
                <div class="row flex_box" style="width: 100%;">
                    <div class="th">Mobile 링크</div>
                    <div class="td flex_box">
                        <input type="text" name="kkoItemUrlLstMo2" class="txt_input en_font kakao_btn_linkMo" placeholder="URL 입력 (http:// 또는 https://필수입력)" onblur="smsCreate.imageLinkAdd(this, 'prev_ft_wide_lst_img_url2');"/>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="block" style="margin-bottom: 10px;">
        <div class="row">
            <div class="th">이미지 선택</div>
            <div class="td">
                <div class="delete_img" data="kakao">
                    <img src="/image/btn_delete1.png" alt="삭제">
                </div>
                <input type="text" class="txt_input en_font" id="kakaoImageItem3" placeholder="이미지를 선택해 주세요." readonly/>
                <span class="btn_sm_line" data="kakaoImageItem" onclick="imageListPopUp('1','kakaoImageItem3')">선택</span>
                <input type="hidden" id="kakao_item_img_cd_3" name="kakao_item_img_cd_3" value="">
                <input type="hidden" id="kko_view_item_img_url_3" name="kko_view_item_img_url_3" maxlength="" value="">
            </div>
        </div>
        <div class="row flex_box double">
            <div class="th top-border" style="line-height: 72px;">내용</div>
            <div class="td first-td right-border top-border">
                <input type="text" class="txt_input width kakao_btn_name" name="kkoItemLst3" maxlength="30" placeholder="내용을 입력해주세요. (최대 30자)" onkeyup="smsCreate.titleCount(this,'kakao_wide_lst3')"/>
            </div>
            <div class="th top-border" style="line-height: 72px;">링크 주소</div>
            <div class="td flex_box top-border" style="flex-direction: column;">
                <div class="row flex_box" style="width: 100%;">
                    <div class="th">Pc 링크</div>
                    <div class="td flex_box">
                        <input type="text" name="kkoItemUrlLstPc3" class="txt_input en_font kakao_btn_linkPc" placeholder="URL 입력 (http:// 또는 https://필수입력)" onblur="smsCreate.imageLinkAdd(this, 'prev_ft_wide_lst_img_url3');"/>
                    </div>
                </div>
                <div class="row flex_box" style="width: 100%;">
                    <div class="th">Mobile 링크</div>
                    <div class="td flex_box">
                        <input type="text" name="kkoItemUrlLstMo3" class="txt_input en_font kakao_btn_linkMo" placeholder="URL 입력 (http:// 또는 https://필수입력)" onblur="smsCreate.imageLinkAdd(this, 'prev_ft_wide_lst_img_url3');"/>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="block" style="margin-bottom: 10px;">
        <div class="row">
            <div class="th">이미지 선택</div>
            <div class="td">
                <div class="delete_img" data="kakao">
                    <img src="/image/btn_delete1.png" alt="삭제">
                </div>
                <input type="text" class="txt_input en_font" id="kakaoImageItem4" placeholder="이미지를 선택해 주세요." readonly/>
                <span class="btn_sm_line" data="kakaoImageItem" onclick="imageListPopUp('1','kakaoImageItem4')">선택</span>
                <input type="hidden" id="kakao_item_img_cd_4" name="kakao_item_img_cd_4" value="">
                <input type="hidden" id="kko_view_item_img_url_4" name="kko_view_item_img_url_4" maxlength="" value="">
            </div>
        </div>
        <div class="row flex_box double">
            <div class="th top-border" style="line-height: 72px;">내용</div>
            <div class="td first-td right-border top-border">
                <input type="text" class="txt_input width kakao_btn_name" name="kkoItemLst4" maxlength="30" placeholder="내용을 입력해주세요. (최대 30자)" onkeyup="smsCreate.titleCount(this,'kakao_wide_lst4')"/>
            </div>
            <div class="th top-border" style="line-height: 72px;">링크 주소</div>
            <div class="td flex_box top-border" style="flex-direction: column;">
                <div class="row flex_box" style="width: 100%;">
                    <div class="th">Pc 링크</div>
                    <div class="td flex_box">
                        <input type="text" name="kkoItemUrlLstPc4" class="txt_input en_font kakao_btn_linkPc" placeholder="URL 입력 (http:// 또는 https://필수입력)" onblur="smsCreate.imageLinkAdd(this, 'prev_ft_wide_lst_img_url4');"/>
                    </div>
                </div>
                <div class="row flex_box" style="width: 100%;">
                    <div class="th">Mobile 링크</div>
                    <div class="td flex_box">
                        <input type="text" name="kkoItemUrlLstMo4" class="txt_input en_font kakao_btn_linkMo" placeholder="URL 입력 (http:// 또는 https://필수입력)" onblur="smsCreate.imageLinkAdd(this, 'prev_ft_wide_lst_img_url4');"/>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>
