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
<!-- 이미지 선택 팝업 영역 시작 -->
<div class="layer_pop imagePopup active">
    <div class="pop_container popup_size2">
        <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>
        <div class="pop_title">이미지 선택</div>
        <div class="pop_inner">
            <div class="form_search">
                <!-- 검색 영역 시작 -->
                <input type="text" class="calendar" id="from" placeholder="등록일 선택"/>
                <span class="hyphen"></span>
                <input type="text" class="calendar" id="to" placeholder="등록일 선택"/>
                <div class="input_txt left-border-none">
                    <input type="text" placeholder="이미지 명 입력"/>
                    <input type="button" class="btn_search" value="검색"/>
                </div>
                <!-- 검색 영역 끝 -->

                <!-- 새 이미지 등록 버튼 -->
                <div class="btn_new_image" onclick="imgUploadPop();">새 이미지 등록</div>
            </div>
            <div class="image_container" id="bodyDom">
                <!-- 조회된 결과가 없는 경우 -->
                <!-- <div class="none_data">조회된 결과가 없습니다.</div> -->
                <!-- 이미지 1단위 영역 시작 -->
                <c:choose>
                    <c:when test="${not empty list}">
                        <c:forEach var="item" items="${list}" varStatus="status">
                            <div class="image_column">
                                <div class="top">
                                    <!-- 체크박스 -->
                                    <label class="custom_check1">
                                        <input type="radio" name="contentsImg" value="${item.seq}"/><span>
                                            <input type="hidden" name="ImgNm" value="${item.img_nm}"/>
                                            <input type="hidden" name="ImgOrgNm" value="${item.img_org_nm}"/>
                                            <input type="hidden" name="imgurl" value="${item.img_url}"/>
                                            <input type="hidden" name="kkoImgurl" value="${item.kko_img_url}"/>
                                        </span></label>
                                    <!-- 이미지명 -->
                                    <span class="title">${item.img_nm}</span>
                                </div>
                                <div class="body">
                                    <!-- 이미지 썸네일 -->
                                    <div class="thumbnail">
                                        <img src="${filePath}${item.img_url}" alt="" onerror="this.src = '/image/bg_none.png'">
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="none_data">조회된 결과가 없습니다.</div>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="btn_row bottom-border left-border right-border">
                <ul class="pager" id="pagingDom">
                    <ui:pagination paginationInfo="${page}" type="image" jsFunction="imageListPaging"/>
                    <input type="hidden" id="nowPageNo" name="nowPageNo" value="${pageNo}"/>
                    <input type="hidden" id="totCnt" name="totCnt" value="${listCnt}"/>
                    <input type="hidden" id="imgType" name="imgType" value=""/>
                </ul>
            </div>

            <div class="pop_error_txt blue_point_color"></div>
            <div class="btn_row">
                <input type="button" class="btn_bg btn_size2 btn_center imageSave" id="" value="저장"
                       onclick="imgSendSave();"/>
            </div>
        </div>
    </div>
</div>
