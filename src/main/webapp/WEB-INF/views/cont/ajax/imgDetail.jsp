<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!-- container 영역 시작 -->
<span id="body">
    <div class="layer_pop uploadPopup active">
        <div class="pop_container popup_size1">
            <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
            <div class="pop_title">새 이미지 파일 업로드</div>
            <div class="pop_inner">
                <table class="pop_table_type1" summary="새 이미지 파일 업로드">
                    <colgroup>
                        <col width="103" />
                        <col width="*" />
                    </colgroup>
                    <tbody>
                    <tr>
                        <th scope="row">채널</th>
                        <td>
                            <c:choose>
                                <c:when test="${list[0].ch_tp eq 'DMTP02'}">
                                    <input type="text" class="input_type1" readonly value="모바일"/> <input type="hidden" name="ch_tp" value="DMTP02"/>
                                </c:when>
                                <c:when test="${list[0].ch_tp eq 'DMTP01'}">
                                    <input type="text" class="input_type1" readonly value="이메일"/> <input type="hidden" name="ch_tp" value="DMTP01"/>
                                </c:when>
                                <c:when test="${list[0].ch_tp eq 'DMTP04'}">
                                    <input type="text" class="input_type1" readonly value="RCS"/> <input type="hidden" name="ch_tp" value="DMTP04"/>
                                </c:when>
                            </c:choose>
                        </td>
                    </tr>
                    <tr class="rcsImgForm rcs_option">
                        <th scope="row">양식</th>
                        <td>
                            <div class="select style1 rcs_select">
                                <!-- selected value -->
                                <div class="value" data="">RCS 양식 선택</div>
                                <!-- option -->
                                <ul class="option">
                                    <li data="0">RCS 양식 선택</li>
                                    <li data="1">가로형</li>
                                    <li data="2">세로형 / Tall</li>
                                    <li data="3">세로형 / Medium</li>
                                    <li data="4">슬라이드형 / Small</li>
                                    <li data="5">슬라이드형 / Medium</li>
                                </ul>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">이미지 명</th>
                        <td>
                            <input type="text" placeholder="이미지 명을 입력해주세요." name="img_nm" value="${list[0].img_nm}"
                                   class="input_type1" />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">이미지 파일</th>
                        <td>
                            <input type="text" id="fileName" name="fileName" class="input_file" placeholder="이미지 파일을 선택해주세요." value="${list[0].img_org_nm}" readonly />
                            <span class="btn_file">파일 선택<input type="file" class="file" id="file"/></span>
                        </td>
                    </tr>
                    </tbody>
                </table>
                <!-- RCS guide text -->
                <ul class="guide_txt">
                    <li class="on">※ 가로형 : 1MB 이하</li>
                    <li>※ 세로형 : ① Tall : 568 X 528 (1MB 이하), ② Medium : 568 X 336 (1MB 이하)</li>
                    <li>※ 슬라이드형 : ① Small : 360 X 336, ② Medium : 696 X 504, 최대 사이즈 360 X 1569 , 1MB 이하</li>
                </ul>
                <!-- 모바일 / 이메일 guide text -->
                <div class="left pop_error_txt other_guide">※ 모바일 : Jpg(200KB 이하), 이메일 : jpg, png, gif</div>
                <div class="right pop_error_txt blue_point_color"></div>
                <div class="img_viewer"><img src="${baseURL}/${list[0].img_url}" alt=""></div>
                <div class="btn_row">
                     <input type="hidden" name="seq" value="${list[0].seq}"/>
                    <input type="button" class="btn_bg btn_size2 btn_center uploadSave" onclick="updateContentImg();" value="저장" />
                </div>
            </div>
        </div>
    </div>
</span>