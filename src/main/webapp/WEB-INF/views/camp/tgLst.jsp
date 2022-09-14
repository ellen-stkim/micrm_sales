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

<section class="container">
      <!-- 컨텐츠 영역 시작 -->
      <div class="contents">
          <!-- row 영역 시작 -->
          <div class="row tooltip_area bottom-border cf">
              <div class="left">
                  <!-- location 영역 -->
                  <ul class="location">
                      <li>홈</li>
                      <li>캠페인</li>
                      <li>타겟팅</li>
                      <li>타겟팅 리스트</li>
                  </ul>
                  <!-- tooltip 버튼 영역  -->
                  <div class="tooltip_icon">
                      <img src="/image/ico_tooltip.png" alt="Tooltip" />
                  </div>
                  <!-- tooltip box 영역 시작 -->
                  <div class="tooltip_box">
                      <!-- tooltip bullet 영역 -->
                      <div class="bullet"></div>
                      <span class="bold">2019년 12월 신규 취급액은 91.6억 중,<br />
                          나오론이 52.4억(57.2%)으로 가장 많은 비중을
                          차지합니다.</span>
                      스타일론 직장인이 26.69억(29.1%), <br />
                      스타일론 자영업자가 4.1억(4.47%)입니다.<br />
                  </div>
                  <!-- tooltip box 영역 끝 -->
              </div>
              <div class="right">
                  <!-- select 영역 시작 -->
                  <div class="select style1 left-border">
                      <!-- selected value -->
                      <div class="value searchSelect" data="0">기준선택</div>
                      <!-- option -->
                      <ul class="option">
                          <li data="0">기준선택</li>
                          <li data="타겟팅명">타겟팅명</li>
                          <li data="사용여부">사용여부</li>
                      </ul>
                  </div>
                  <!-- select 영역 끝 -->
                  <input type="text" class="searchInp left-border" placeholder="검색어입력" />
                  <input type="submit" class="searchBtn" value="검색" onclick="return searchCheck();" />
              </div>
          </div>
          <!-- row 영역 끝 -->
          <!-- row 영역 시작 -->
          <div class="row bottom-border cf">
              <div class="left">
                  <a href="#" class="btn_basic down left right-border" onclick="downloadCheck();">내려받기</a>
                  <input type="button" class="btn_basic target_create left right-border" onclick="location.href='/camp/tg/tgCreate.mi'" value="타겟팅 생성" />
                  <input type="button" class="btn_basic target_copy left right-border" onclick="copyCheck();" value="타겟팅 복제"/>
                  <input type="button" class="btn_basic checkDelete left right-border" onclick="deleteCheck();"  value="선택삭제"/>
                  <div class="info_txt left">※ 내려받기 시, 검색된 리스트가 다운로드됩니다.&nbsp;&nbsp;&nbsp;&nbsp;※ 특정 타겟팅 선택 후 타겟팅 복제 시, 동일한 타겟팅 그룹이 복제 됩니다. </div>
              </div>
          </div>
          <!-- row 영역 끝 -->
          <!-- section 영역 시작 -->
          <div class="section">
              <!-- 검색 결과 영역 시작 -->
              <div class="count border-bottom cf">
                  <div class="total left">타겟팅 리스트</div>
              </div>
              <!-- 검색 결과 영역 끝 -->
              <div class="scroll_tbl">
                  <!-- table 영역 시작 -->
                  <table class="table target_tbl dynamic_tbl">
                      <thead>
                          <tr>
                              <th><label class="custom_check1 all"><input type="checkbox" /><span></span></label></th>
                              <th>타겟팅명</th>
                              <th>타겟 수</th>
                              <th>생성일</th>
                              <th>수정일</th>
                              <th>사용여부</th>
                              <th>타겟팅 현황</th>
                              <th>관리</th>
                          </tr>
                      </thead>
                      <tbody>
                          <!-- 리스트 1단위 영역 시작 -->
                          <tr>
                              <td><label class="custom_check1"><input type="checkbox" /><span></span></label></td>
                              <td><span class="ellipsis"> 200928_MONDAY_13TH_(1)</span></td>
                              <td>13,455</td>
                              <td>2020-10-05 16:14:00</td>
                              <td>2020-10-05 16:14:00</td>
                              <td class="en_font"><input type="button" class="use_state en_font btn_state" value="Y" /></td>
                              <td>임시저장</td>
                              <td><input type="button" class="btn_sm_line btn_inline size" value="수정" onclick="" /></td>
                          </tr>
                          <!-- 리스트 1단위 영역 끝 -->

                          <tr>
                              <td><label class="custom_check1"><input type="checkbox" /><span></span></label></td>
                              <td><span class="ellipsis"> 200928_MONDAY_13TH_(1)</span></td>
                              <td>13,455</td>
                              <td>2020-10-05 16:14:00</td>
                              <td>2020-10-05 16:14:00</td>
                              <td class="en_font"><input type="button" class="use_state en_font btn_state" value="Y" /></td>
                              <td>타겟 추출 중</td>
                              <td><input type="button" class="btn_sm_line btn_inline size" value="수정" onclick="" /></td>
                          </tr>
                          <tr>
                              <td><label class="custom_check1"><input type="checkbox" /><span></span></label></td>
                              <td><span class="ellipsis"> 200928_MONDAY_13TH_(1)</span></td>
                              <td>13,455</td>
                              <td>2020-10-05 16:14:00</td>
                              <td>2020-10-05 16:14:00</td>
                              <td class="en_font"><input type="button" class="use_state en_font btn_state" value="Y" /></td>
                              <td>타겟 추출 완료</td>
                              <td><input type="button" class="btn_sm_line btn_inline size" value="수정" onclick="" /></td>
                          </tr>

                          <!-- 검색 결과가 없는 경우 영역 시작 -->
                          <!-- <tr class="no_data">
                                  <td colspan="8">조회된 결과가 없습니다.</td>
                              </tr> -->
                          <!-- 검색 결과가 없는 경우 영역 시작 -->
                      </tbody>
                  </table>
              </div>
              <div class="btn_row bottom-border">
                  <ul class="pager">
                      <!-- 페이지 이동 버튼이 활성화 상태일 경우 addClass'active' -->
                      <li class="first">First</li>
                      <li class="prev">Prev</li>
                      <!-- 페이지 번호가 활성화 상태일 경우 addClass'on' -->
                      <li class="page on">1</li>
                      <li class="page">2</li>
                      <li class="page">3</li>
                      <li class="page">4</li>
                      <li class="page">5</li>
                      <li class="page">6</li>
                      <li class="page">7</li>
                      <li class="page">8</li>
                      <li class="page">9</li>
                      <li class="page">10</li>
                      <li class="next active">Next</li>
                      <li class="last active">Last</li>
                  </ul>
              </div>
              <!-- table 영역 끝 -->
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
<!-- wrap end -->

<!-- 삭제안내 팝업 영역 시작 -->
<div class="layer_pop deletePopup">
  <div class="pop_container popup_size3">
      <input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);" />
      <div class="pop_title">삭제안내</div>
      <div class="pop_inner">
          <div class="alert_txt">
              타겟팅 리스트 <span class="length">10</span>개의 회원을 삭제하시겠습니까?<br />
              복원이 불가합니다.
          </div>
          <input type="password" placeholder="비밀번호입력" class="password_input border" id="deletePassword" />
          <div class="pop_error_txt blue_point_color" id="errorArea1"></div>
          <div class="btn_row">
              <input type="button" class="btn_bg btn_size2 btn_inline" id="deleteSave"
                  onclick="listDelete(document.getElementById('deletePassword').value);" value="확인">
              <input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소">
          </div>
      </div>
  </div>
</div>

<script>
    $(function () {
        // 전체 체크/해제 동작
        $('.all input').click(function () {
            if ($(this).is(':checked') == true) {
                $('.custom_check1 input').not('.all input').prop('checked', true);
            } else {
                $('.custom_check1 input').not('.all input').prop('checked', false);
            }
        });

        $('.table tbody .custom_check1 input').click(function () {
            let total = $('.custom_check1 input').not('.all input').length;
            let checkTotal = $('.custom_check1 input:checked').not('.all input').length;
            if (total == checkTotal) {
                $('.all input').prop('checked', true);
            } else {
                $('.all input').prop('checked', false);
            }
        });
        //end

        // 사용여부 click event
        $('.use_state').on('click', function () {
            let useValue = $(this).val();
            if (useValue == 'Y') {
                $(this).val('N');
            } else {
                $(this).val('Y');
            }
        });

    });

    //선택 삭제 팝업
    function deleteCheck() {
        let checkLength = $('.target_tbl .custom_check1').not('.all').find('input:checked').length;
        $('.deletePopup .length').html(checkLength);
        if (checkLength == 0) {
            popup.popAlert('삭제할 회원을 선택해주세요.');
        } else {
            $('.deletePopup').addClass('active');
            $('#deleteSave').attr('data', 'list');
        }
    }

    //삭제 동작
    function listDelete(password) {
        let check = passwordReturn();
        let checkLength = $('.target_tbl .custom_check1').not('.all').find('input:checked').length;
        let status = $('#deleteSave').attr('data');
        if (password == '') {
            $('#errorArea1').html('비밀번호를 입력해주세요.');
        } else {
            if (check == true) {
                $('#errorArea1').html('');
                if (status == 'list') {
                    $('.target_tbl .custom_check1').not('.all').each(function () {
                        let checkStatus = $(this).find('input').is(':checked');
                        if (checkStatus == true) {
                            $(this).parents('tr').remove();
                        }
                    });
                } else {
                    $('.target_tbl .custom_check1').not('.all').parents('tr').remove();
                }
                $('.password_input').val('');
                popupClose(event.target);
            } else {
                $('#errorArea1').html('비밀번호 확인해주세요.');
            }
        }
        return false;
    };

    // 백엔드처리 비밀번호가 맞으면 true/false
    function passwordReturn() {
        return true;
    }

    //내려받기 클릭 시 리스트 개수 체크 동작
    function downloadCheck() {
        let checkLength = $('.target_tbl .custom_check1').not('.all').find('input:checked').length;
        if (checkLength == 0) {
            popup.popAlert('다운로드할 타겟팅을 선택해주세요.');
            return false;
        }if (checkLength > 1) {
            popup.popAlert('다운로드할 타겟팅을 1가지만 선택해주세요.');
            return false;
        }else{
            return true;
        }
    }

    //타겟팅 복제 버튼 클릭 시 리스트 개수 체크 동작
    function copyCheck() {
        let checkLength = $('.target_tbl .custom_check1').not('.all').find('input:checked').length;
        if (checkLength == 0) {
            popup.popAlert('복제할 타겟팅을 선택해주세요.');
            return false;
        }if (checkLength > 1) {
            popup.popAlert('복제할 타겟팅을 1가지만 선택해주세요.');
            return false;
        }else{
            return true;
        }
    }
</script>