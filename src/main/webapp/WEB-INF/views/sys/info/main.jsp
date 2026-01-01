<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="strping" %>
<style>
    .input_boarder {
        width: 100%;
        height: 100%;
        border: 1px solid #ddd;
        padding: 0 10px;
    }
</style>
<!-- container 영역 시작 -->
<section class="container">
    <!-- 컨텐츠 영역 시작 -->
    <div class="contents">
        <!-- row 영역 시작 -->
        <div class="row tooltip_area bottom-border cf">
            <div class="left">
                <!-- location 영역 -->
                <ul class="location">
                    <li>홈</li>
                </ul>
            </div>
        </div>
        <!-- row 영역 끝 -->
        <ul class="tab_row">
            <li class="on"><a href="/sys/info/main.mi">시스템 정보</a></li>
        </ul>
        <form:form id="form" name="form" method="post" action="/sys/info/save.service">
            <div class="section">
                <div class="count border-bottom cf">
                    <div class="total left">　</div>
                    <input type="button" class="btn_add right" id="saveBtn" value="저장"/>
                </div>
                <table class="table management" summary="table">
                    <colgroup>
                        <col style="width: 15%">
                        <col style="width: 10%">
                        <col style="width: 20%">
                        <col style="width: 15%">
                        <col style="width: 10%">
                        <col style="width: 10%">
                        <col style="width: 10%">
                        <col style="width: 10%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>코드명</th>
                            <th>CD_ID</th>
                            <th>CD_VAL</th>
                            <th>CD_DESC</th>
                            <th>부모코드</th>
                            <th>부모코드명</th>
                            <th>등록일</th>
                            <th>수정일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr id="TRACKURL">
                            <td>
                                트래킹 URL 정보
                                <input type="hidden" name="lst[0].seq" value="">
                                <input type="hidden" name="lst[0].grp_id" value="TRACKURL">
                                <input type="hidden" name="lst[0].grp_nm" value="트래킹 URL 정보">
                                <input type="hidden" name="lst[0].cd_nm" value="Track URL">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[0].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[0].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[0].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[0].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[0].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="REDIRECT">
                            <td>
                                REDIRECT URL 정보
                                <input type="hidden" name="lst[1].seq" value="">
                                <input type="hidden" name="lst[1].grp_id" value="REDIRECT">
                                <input type="hidden" name="lst[1].grp_nm" value="리다이렉트">
                                <input type="hidden" name="lst[1].cd_nm" value="Reirect URL">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[1].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[1].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[1].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[1].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[1].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="IMG_PATH">
                            <td>
                                이미지 저장 폴더
                                <input type="hidden" name="lst[2].seq" value="">
                                <input type="hidden" name="lst[2].grp_id" value="IMG_PATH">
                                <input type="hidden" name="lst[2].grp_nm" value="이미지 저장 폴더">
                                <input type="hidden" name="lst[2].cd_nm" value="이미지 저장 폴더">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[2].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[2].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[2].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[2].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[2].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                            <%--세일즈포스--%>
                        <tr id="SALES_MID">
                            <td>
                                세일즈포스 멤버ID
                                <input type="hidden" name="lst[3].seq" value="">
                                <input type="hidden" name="lst[3].grp_id" value="SALES_MID">
                                <input type="hidden" name="lst[3].grp_nm" value="세일즈포스 멤버ID">
                                <input type="hidden" name="lst[3].cd_nm" value="세일즈포스 멤버ID">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[3].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[3].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[3].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[3].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[3].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="SALES_TOTAL">
                            <td>
                                세일즈포스 DE Count 랜딩페이지
                                <input type="hidden" name="lst[4].seq" value="">
                                <input type="hidden" name="lst[4].grp_id" value="SALES_TOTAL">
                                <input type="hidden" name="lst[4].grp_nm" value="세일즈포스 DERowCount">
                                <input type="hidden" name="lst[4].cd_nm" value="세일즈포스 DE Count 랜딩페이지">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[4].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[4].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[4].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[4].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[4].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="SALES_AUTH_URL">
                            <td>
                                세일즈포스 AUTH Base URI
                                <input type="hidden" name="lst[5].seq" value="">
                                <input type="hidden" name="lst[5].grp_id" value="SALES_AUTH_URL">
                                <input type="hidden" name="lst[5].grp_nm" value="세일즈포스 AUTH Base URI">
                                <input type="hidden" name="lst[5].cd_nm" value="세일즈포스 AUTH Base URI">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[5].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[5].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[5].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[5].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[5].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="SALES_REST_URL">
                            <td>
                                세일즈포스 REST Base URI
                                <input type="hidden" name="lst[6].seq" value="">
                                <input type="hidden" name="lst[6].grp_id" value="SALES_REST_URL">
                                <input type="hidden" name="lst[6].grp_nm" value="세일즈포스 REST Base URI">
                                <input type="hidden" name="lst[6].cd_nm" value="세일즈포스 REST Base URI">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[6].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[6].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[6].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[6].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[6].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="SALES_SOAP_URL">
                            <td>
                                세일즈포스 SOAP Base URI
                                <input type="hidden" name="lst[7].seq" value="">
                                <input type="hidden" name="lst[7].grp_id" value="SALES_SOAP_URL">
                                <input type="hidden" name="lst[7].grp_nm" value="세일즈포스 SOAP Base URI">
                                <input type="hidden" name="lst[7].cd_nm" value="세일즈포스 SOAP Base URI">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[7].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[7].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[7].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[7].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[7].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="SALES_JWT">
                            <td>
                                세일즈포스 JWT
                                <input type="hidden" name="lst[8].seq" value="">
                                <input type="hidden" name="lst[8].grp_id" value="SALES_JWT">
                                <input type="hidden" name="lst[8].grp_nm" value="세일즈포스 JWT">
                                <input type="hidden" name="lst[8].cd_nm" value="세일즈포스 JWT">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[8].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[8].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[8].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[8].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[8].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="SALES_CID">
                            <td>
                                세일즈포스 Client Id
                                <input type="hidden" name="lst[9].seq" value="">
                                <input type="hidden" name="lst[9].grp_id" value="SALES_CID">
                                <input type="hidden" name="lst[9].grp_nm" value="세일즈포스 Client Id">
                                <input type="hidden" name="lst[9].cd_nm" value="세일즈포스 Client Id">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[9].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[9].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[9].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[9].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[9].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="SALES_SEC">
                            <td>
                                세일즈포스 Client Secret
                                <input type="hidden" name="lst[10].seq" value="">
                                <input type="hidden" name="lst[10].grp_id" value="SALES_SEC">
                                <input type="hidden" name="lst[10].grp_nm" value="세일즈포스 Client Secret">
                                <input type="hidden" name="lst[10].cd_nm" value="세일즈포스 Client Secret">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[10].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[10].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[10].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[10].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[10].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="SALES_SFTP|ADDRESS">
                            <td>
                                세일즈 sftp 서버 주소
                                <input type="hidden" name="lst[11].seq" value="">
                                <input type="hidden" name="lst[11].grp_id" value="SALES_SFTP">
                                <input type="hidden" name="lst[11].grp_nm" value="세일즈 sftp 서버 정보">
                                <input type="hidden" name="lst[11].cd_nm" value="세일즈 sftp 서버 주소">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[11].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[11].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[11].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[11].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[11].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="SALES_SFTP|PORT">
                            <td>
                                세일즈 sftp 서버 PORT
                                <input type="hidden" name="lst[12].seq" value="">
                                <input type="hidden" name="lst[12].grp_id" value="SALES_SFTP">
                                <input type="hidden" name="lst[12].grp_nm" value="세일즈 sftp 서버 정보">
                                <input type="hidden" name="lst[12].cd_nm" value="세일즈 sftp 서버 PORT">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[12].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[12].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[12].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[12].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[12].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="SALES_SFTP|FOLDER">
                            <td>
                                세일즈 sftp 서버 폴더
                                <input type="hidden" name="lst[13].seq" value="">
                                <input type="hidden" name="lst[13].grp_id" value="SALES_SFTP">
                                <input type="hidden" name="lst[13].grp_nm" value="세일즈 sftp 서버 정보">
                                <input type="hidden" name="lst[13].cd_nm" value="세일즈 sftp 서버 폴더">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[13].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[13].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[13].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[13].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[13].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="SALES_SFTP|USERNAME">
                            <td>
                                세일즈 sftp 서버 ID
                                <input type="hidden" name="lst[14].seq" value="">
                                <input type="hidden" name="lst[14].grp_id" value="SALES_SFTP">
                                <input type="hidden" name="lst[14].grp_nm" value="세일즈 sftp 서버 정보">
                                <input type="hidden" name="lst[14].cd_nm" value="세일즈 sftp 서버 ID">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[14].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[14].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[14].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[14].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[14].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="SALES_SFTP|PASSWORD">
                            <td>
                                세일즈 sftp 서버 PASSWORD
                                <input type="hidden" name="lst[15].seq" value="">
                                <input type="hidden" name="lst[15].grp_id" value="SALES_SFTP">
                                <input type="hidden" name="lst[15].grp_nm" value="세일즈 sftp 서버 정보">
                                <input type="hidden" name="lst[15].cd_nm" value="세일즈 sftp 서버 PASSWORD">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[15].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[15].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[15].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[15].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[15].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                            <%--카카오--%>
                        <tr id="KAKAO_DB">
                            <td>
                                카카오 발송 DB
                                <input type="hidden" name="lst[16].seq" value="">
                                <input type="hidden" name="lst[16].grp_id" value="KAKAO_DB">
                                <input type="hidden" name="lst[16].grp_nm" value="카카오 발송 DB">
                                <input type="hidden" name="lst[16].cd_nm" value="카카오 발송 DB">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[16].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[16].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[16].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[16].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[16].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="KAKAO_ID">
                            <td>
                                카카오 ClientId
                                <input type="hidden" name="lst[17].seq" value="">
                                <input type="hidden" name="lst[17].grp_id" value="KAKAO_ID">
                                <input type="hidden" name="lst[17].grp_nm" value="카카오 ClientId">
                                <input type="hidden" name="lst[17].cd_nm" value="카카오 ClientId">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[17].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[17].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[17].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[17].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[17].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="KAKAO_KEY">
                            <td>
                                카카오 발송 프로필 키
                                <input type="hidden" name="lst[18].seq" value="">
                                <input type="hidden" name="lst[18].grp_id" value="KAKAO_KEY">
                                <input type="hidden" name="lst[18].grp_nm" value="카카오 발송 프로필 키">
                                <input type="hidden" name="lst[18].cd_nm" value="카카오 발송 프로필 키">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[18].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[18].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[18].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[18].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[18].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                            <%--문자--%>
                        <tr id="MDM_DB">
                            <td>
                                MDM DB
                                <input type="hidden" name="lst[19].seq" value="">
                                <input type="hidden" name="lst[19].grp_id" value="MDM_DB">
                                <input type="hidden" name="lst[19].grp_nm" value="문자 발송 DB">
                                <input type="hidden" name="lst[19].cd_nm" value="문자 발송 DB">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[19].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[19].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[19].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[19].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[19].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                            <%--RCS--%>
                        <tr id="RCS_DB">
                            <td>
                                RCS DB
                                <input type="hidden" name="lst[20].seq" value="">
                                <input type="hidden" name="lst[20].grp_id" value="RCS_DB">
                                <input type="hidden" name="lst[20].grp_nm" value="RCS DB">
                                <input type="hidden" name="lst[20].cd_nm" value="RCS DB">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[20].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[20].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[20].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[20].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[20].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="RCS_BRND_ID">
                            <td>
                                RCS 브랜드 ID
                                <input type="hidden" name="lst[21].seq" value="">
                                <input type="hidden" name="lst[21].grp_id" value="RCS_BRND_ID">
                                <input type="hidden" name="lst[21].grp_nm" value="RCS 브랜드 ID">
                                <input type="hidden" name="lst[21].cd_nm" value="RCS 브랜드 ID">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[21].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[21].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[21].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[21].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[21].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="RCS_MSG_ID">
                            <td>
                                RCS 메세지 ID
                                <input type="hidden" name="lst[22].seq" value="">
                                <input type="hidden" name="lst[22].grp_id" value="RCS_MSG_ID">
                                <input type="hidden" name="lst[22].grp_nm" value="RCS 메세지 ID">
                                <input type="hidden" name="lst[22].cd_nm" value="RCS 메세지 ID">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[22].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[22].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[22].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[22].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[22].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                            <%--이메일--%>
                        <tr id="SUPURL">
                            <td>
                                수신 거부 링크 정보
                                <input type="hidden" name="lst[23].seq" value="">
                                <input type="hidden" name="lst[23].grp_id" value="SUPURL">
                                <input type="hidden" name="lst[23].grp_nm" value="수신 거부 링크 정보">
                                <input type="hidden" name="lst[23].cd_nm" value="수신 거부 링크 정보">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[23].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[23].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[23].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[23].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[23].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="RETURN_PATH">
                            <td>
                                Email Return Path
                                <input type="hidden" name="lst[24].seq" value="">
                                <input type="hidden" name="lst[24].grp_id" value="RETURN_PATH">
                                <input type="hidden" name="lst[24].grp_nm" value="이메일 리턴패스">
                                <input type="hidden" name="lst[24].cd_nm" value="Email Return Path">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[24].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[24].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[24].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[24].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[24].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="BRURL">
                            <td>
                                브라우저 링크 정보
                                <input type="hidden" name="lst[25].seq" value="">
                                <input type="hidden" name="lst[25].grp_id" value="BRURL">
                                <input type="hidden" name="lst[25].grp_nm" value="브라우저 링크 정보">
                                <input type="hidden" name="lst[25].cd_nm" value="브라우저 링크 정보">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[25].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[25].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[25].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[25].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[25].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                            <%--가격--%>
                        <tr id="API_PRICE|EMAIL">
                            <td>
                                모듈 가격 EMAIL
                                <input type="hidden" name="lst[26].seq" value="">
                                <input type="hidden" name="lst[26].grp_id" value="API_PRICE">
                                <input type="hidden" name="lst[26].grp_nm" value="모듈 가격">
                                <input type="hidden" name="lst[26].cd_nm" value="EMAIL">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[26].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[26].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[26].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[26].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[26].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="API_PRICE|SMS">
                            <td>
                                모듈 가격 SMS
                                <input type="hidden" name="lst[27].seq" value="">
                                <input type="hidden" name="lst[27].grp_id" value="API_PRICE">
                                <input type="hidden" name="lst[27].grp_nm" value="모듈 가격">
                                <input type="hidden" name="lst[27].cd_nm" value="SMS">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[27].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[27].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[27].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[27].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[27].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="API_PRICE|LMS">
                            <td>
                                모듈 가격 LMS
                                <input type="hidden" name="lst[28].seq" value="">
                                <input type="hidden" name="lst[28].grp_id" value="API_PRICE">
                                <input type="hidden" name="lst[28].grp_nm" value="모듈 가격">
                                <input type="hidden" name="lst[28].cd_nm" value="LMS">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[28].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[28].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[28].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[28].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[28].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="API_PRICE|MMS">
                            <td>
                                모듈 가격 MMS
                                <input type="hidden" name="lst[29].seq" value="">
                                <input type="hidden" name="lst[29].grp_id" value="API_PRICE">
                                <input type="hidden" name="lst[29].grp_nm" value="모듈 가격">
                                <input type="hidden" name="lst[29].cd_nm" value="MMS">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[29].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[29].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[29].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[29].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[29].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="API_PRICE|RCS_SMS">
                            <td>
                                모듈 가격 RCS SMS
                                <input type="hidden" name="lst[30].seq" value="">
                                <input type="hidden" name="lst[30].grp_id" value="API_PRICE">
                                <input type="hidden" name="lst[30].grp_nm" value="모듈 가격">
                                <input type="hidden" name="lst[30].cd_nm" value="RCS_SMS">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[30].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[30].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[30].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[30].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[30].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="API_PRICE|RCS_LMS">
                            <td>
                                모듈 가격 RCS LMS
                                <input type="hidden" name="lst[31].seq" value="">
                                <input type="hidden" name="lst[31].grp_id" value="API_PRICE">
                                <input type="hidden" name="lst[31].grp_nm" value="모듈 가격">
                                <input type="hidden" name="lst[31].cd_nm" value="RCS_LMS">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[31].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[31].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[31].cd_desc" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="API_PRICE|RCS_MMS">
                            <td>
                                모듈 가격 RCS MMS
                                <input type="hidden" name="lst[32].seq" value="">
                                <input type="hidden" name="lst[32].grp_id" value="API_PRICE">
                                <input type="hidden" name="lst[32].grp_nm" value="모듈 가격">
                                <input type="hidden" name="lst[32].cd_nm" value="RCS_MMS">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[32].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[32].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[32].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[32].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[32].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="API_PRICE|RCS_TEMPLATE">
                            <td>
                                모듈 가격 RCS TEMPLATE
                                <input type="hidden" name="lst[33].seq" value="">
                                <input type="hidden" name="lst[33].grp_id" value="API_PRICE">
                                <input type="hidden" name="lst[33].grp_nm" value="모듈 가격">
                                <input type="hidden" name="lst[33].cd_nm" value="RCS_TEMPLATE">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[33].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[33].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[33].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[33].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[33].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="API_PRICE|KKO_AT">
                            <td>
                                모듈 가격 카카오 알림톡
                                <input type="hidden" name="lst[34].seq" value="">
                                <input type="hidden" name="lst[34].grp_id" value="API_PRICE">
                                <input type="hidden" name="lst[34].grp_nm" value="모듈 가격">
                                <input type="hidden" name="lst[34].cd_nm" value="KKO_AT">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[34].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[34].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[34].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[34].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[34].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="API_PRICE|KKO_FT_TXT">
                            <td>
                                모듈 가격 카카오 브랜드톡
                                <input type="hidden" name="lst[35].seq" value="">
                                <input type="hidden" name="lst[35].grp_id" value="API_PRICE">
                                <input type="hidden" name="lst[35].grp_nm" value="모듈 가격">
                                <input type="hidden" name="lst[35].cd_nm" value="KKO_FT_TXT">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[35].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[35].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[35].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[35].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[35].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="API_PRICE|KKO_FT_IMG">
                            <td>
                                모듈 가격 카카오 브랜드톡(이미지)
                                <input type="hidden" name="lst[36].seq" value="">
                                <input type="hidden" name="lst[36].grp_id" value="API_PRICE">
                                <input type="hidden" name="lst[36].grp_nm" value="모듈 가격">
                                <input type="hidden" name="lst[36].cd_nm" value="KKO_FT_IMG">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[36].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[36].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[36].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[36].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[36].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="API_PRICE|KKO_FT_WID">
                            <td>
                                모듈 가격 카카오 브랜드톡(와이드 이미지)
                                <input type="hidden" name="lst[37].seq" value="">
                                <input type="hidden" name="lst[37].grp_id" value="API_PRICE">
                                <input type="hidden" name="lst[37].grp_nm" value="모듈 가격">
                                <input type="hidden" name="lst[37].cd_nm" value="KKO_FT_WID">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[37].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[37].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[37].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[37].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[37].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                            <%--쿠폰--%>
                        <tr id="COUPON_DOMAIN">
                            <td>
                                쿠폰 도메인
                                <input type="hidden" name="lst[38].seq" value="">
                                <input type="hidden" name="lst[38].grp_id" value="COUPON_DOMAIN">
                                <input type="hidden" name="lst[38].grp_nm" value="쿠폰도메인">
                                <input type="hidden" name="lst[38].cd_nm" value="쿠폰도메인">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[38].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[38].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[38].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[38].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[38].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="COUPON_CDN">
                            <td>
                                CDN 도메인
                                <input type="hidden" name="lst[39].seq" value="">
                                <input type="hidden" name="lst[39].grp_id" value="COUPON_CDN">
                                <input type="hidden" name="lst[39].grp_nm" value="CDN 도메인">
                                <input type="hidden" name="lst[39].cd_nm" value="CDN 도메인">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[39].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[39].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[39].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[39].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[39].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="NAVER_APP|API_ID">
                            <td>
                                네이버 API ID
                                <input type="hidden" name="lst[40].seq" value="">
                                <input type="hidden" name="lst[40].grp_id" value="NAVER_APP">
                                <input type="hidden" name="lst[40].grp_nm" value="네이버 API 정보">
                                <input type="hidden" name="lst[40].cd_nm" value="API_ID">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[40].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[40].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[40].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[40].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[40].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr id="NAVER_APP|API_SECRET">
                            <td>
                                네이버 API SECRET
                                <input type="hidden" name="lst[41].seq" value="">
                                <input type="hidden" name="lst[41].grp_id" value="NAVER_APP">
                                <input type="hidden" name="lst[41].grp_nm" value="네이버 API 정보">
                                <input type="hidden" name="lst[41].cd_nm" value="API_SECRET">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[41].cd_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[41].cd_val" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[41].cd_desc" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[41].par_id" value="">
                            </td>
                            <td>
                                <input class="input_boarder" type="text" name="lst[41].par_nm" value="">
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </form:form>
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
<script>
    $(function (){
        let res = function (response) {
            if(response){
                let len = response.length;
                for(let i = 0; i < len; i++){
                    let data = response[i];
                    if(data.grp_id == "SALES_SFTP"
                        || data.grp_id == "API_PRICE"
                    ) {
                        let a = Number($("#" + data.grp_id + "\\|" + data.cd_val).prevAll().length);
                        $("#" + data.grp_id + "\\|" + data.cd_val).children('td:eq(0)').find("input[name='lst["+ a +"].seq']").val(data.seq);
                        $("#" + data.grp_id + "\\|" + data.cd_val).children('td:eq(1)').find("input[name='lst["+ a +"].cd_id']").val(data.cd_id);
                        $("#" + data.grp_id + "\\|" + data.cd_val).children('td:eq(2)').find("input[name='lst["+ a +"].cd_val']").val(data.cd_val);
                        $("#" + data.grp_id + "\\|" + data.cd_val).children('td:eq(3)').find("input[name='lst["+ a +"].cd_desc']").val(data.cd_desc);
                        $("#" + data.grp_id + "\\|" + data.cd_val).children('td:eq(4)').find("input[name='lst["+ a +"].par_id']").val(data.par_id);
                        $("#" + data.grp_id + "\\|" + data.cd_val).children('td:eq(5)').find("input[name='lst["+ a +"].par_nm']").val(data.par_nm);
                        $("#" + data.grp_id + "\\|" + data.cd_val).children('td:eq(6)').html(data.reg_dt);
                        $("#" + data.grp_id + "\\|" + data.cd_val).children('td:eq(7)').html(data.upd_dt);
                    } else if(data.grp_id == "NAVER_APP"){
                        let a = Number($("#" + data.grp_id + "\\|" + data.cd_nm).prevAll().length);
                        $("#" + data.grp_id + "\\|" + data.cd_nm).children('td:eq(0)').find("input[name='lst["+ a +"].seq']").val(data.seq);
                        $("#" + data.grp_id + "\\|" + data.cd_nm).children('td:eq(1)').find("input[name='lst["+ a +"].cd_id']").val(data.cd_id);
                        $("#" + data.grp_id + "\\|" + data.cd_nm).children('td:eq(2)').find("input[name='lst["+ a +"].cd_val']").val(data.cd_val);
                        $("#" + data.grp_id + "\\|" + data.cd_nm).children('td:eq(3)').find("input[name='lst["+ a +"].cd_desc']").val(data.cd_desc);
                        $("#" + data.grp_id + "\\|" + data.cd_nm).children('td:eq(4)').find("input[name='lst["+ a +"].par_id']").val(data.par_id);
                        $("#" + data.grp_id + "\\|" + data.cd_nm).children('td:eq(5)').find("input[name='lst["+ a +"].par_nm']").val(data.par_nm);
                        $("#" + data.grp_id + "\\|" + data.cd_nm).children('td:eq(6)').html(data.reg_dt);
                        $("#" + data.grp_id + "\\|" + data.cd_nm).children('td:eq(7)').html(data.upd_dt);
                    } else{
                        let a = Number($("#" + data.grp_id).prevAll().length);
                        $("#" + data.grp_id).children('td:eq(0)').find("input[name='lst["+ a +"].seq']").val(data.seq);
                        $("#" + data.grp_id).children('td:eq(1)').find("input[name='lst["+ a +"].cd_id']").val(data.cd_id);
                        $("#" + data.grp_id).children('td:eq(2)').find("input[name='lst["+ a +"].cd_val']").val(data.cd_val);
                        $("#" + data.grp_id).children('td:eq(3)').find("input[name='lst["+ a +"].cd_desc']").val(data.cd_desc);
                        $("#" + data.grp_id).children('td:eq(4)').find("input[name='lst["+ a +"].par_id']").val(data.par_id);
                        $("#" + data.grp_id).children('td:eq(5)').find("input[name='lst["+ a +"].par_nm']").val(data.par_nm);
                        $("#" + data.grp_id).children('td:eq(6)').html(data.reg_dt);
                        $("#" + data.grp_id).children('td:eq(7)').html(data.upd_dt);
                    }
                }
            }
        };
        let param = {};
        com_ajax.ajax('post', '${baseURL}/sys/info/codeLst.ajax', param, res, '${_csrf.headerName}', '${_csrf.token}');

        $("#saveBtn").click(function(){
            $("#form").submit();
        })
    });
</script>



