let smsCreate = {
    byteCount : function(textCount, type){
        let textVal = $(textCount).val();
        let text = new String(textVal);
        let textLength = text.length;
        let stringAt ;
        let count;
        count = 0;
        for(let i = 0; i < textLength; i++){
            stringAt = text.charAt(i);
            if (escape(stringAt) == '%0D'){}
            else if (escape(stringAt).length > 4){
                count += 2;
            }else{
                count++;
            }
        }
        if(type == 'kakao'){
            document.querySelector('.kakao_byte').innerHTML = count;
        }else{
            document.querySelector('.sms_byte').innerHTML = count;
        }
    }
    , imageCreate : function(type, image){
        let imageType = $(image).val();
        let kakaoImgLink = $('.kakaoImgLink').val();

        if(imageType != ''){
            if(type == 'kakaoImage'){
                if(kakaoImgLink == ''){
                    $('#kakaoImage').parent('.td').removeClass('outline');
                    $('#kakao').find('.sms_img').html('<a href="' + imageType + '" target="_blank">'+'<img src="'+ imageType +'"/>' + '</a>');
                }else{
                    $('#kakaoImage').parent('.td').removeClass('outline');
                    $('#kakao').find('.sms_img').html('<a href="' + kakaoImgLink + '" target="_blank">'+'<img src="'+ imageType +'"/>' + '</a>');
                }
            }else if(type == 'smsImage'){
                $('#smsImage').parent('.td').removeClass('outline');
                $('#sms').find('.sms_img').html('<img src="'+ imageType +'"/>');
            }else if(type == 'horizontalImage'){
                $('#horizontalImage').parent('.td').removeClass('outline');
                $('.horizontal').find('.img_area').html('<img src="'+ imageType +'"/>');
            }else if(type == 'verticalImage'){
                $('#verticalImage').parent('.td').removeClass('outline');
                $('#vertical').find('.img_area').html('<img src="'+ imageType +'"/>');
            }else{
                $('.' + type).find('.img_area').html('<img src="'+ imageType +'"/>');
            }
        }else{
            if(type == 'kakaoImage'){
                $('#kakao').find('.sms_img').children().remove();
            }else if(type == 'smsImage'){
                $('#sms').find('.sms_img').children().remove();
            }
        }
    }
    , titleCount : function(title, type){
        let titleTxt = $(title).val();
        let newTitle = new String(titleTxt);
        let txtLength = newTitle.length;
        let stringAt;
        let count = 0;
        let code = event.keyCode;

        for(let a = 0; a < txtLength; a++){
            stringAt = newTitle.charAt(a);
            if(escape(stringAt) == '%0D'){
            }
            else if(escape(stringAt).length > 4){
                count +=2;
            }else{
                count++;
            }
        }
        if(event.ctrlKey && event.which === 67){
            return false;
        }
        if(type == 'sms'){
            let value = $('.smsType').filter(':checked').val().trim();
            if(value != 'SMS') {
                $('#sms_title').text(titleTxt);
            }
        }
        if(code != 8 && count > 40){
            for(b=i=0;c=newTitle.charCodeAt(i);) {
                b+=c>>7?2:2;
                if (b > 40){
                    if(type == 'sms'){
                        popup.popAlert('문자 제목은 40byte를 초과할 수 없습니다.');
                        $(title).val(newTitle.substring(0,i));
                        $('#sms_title').text(newTitle.substring(0,i));
                        break;
                    }
                    if(type == 'kakao'){
                        popup.popAlert('카카오톡 버튼 링크 제목은 최대 20글자까지<br/> 입력할 수 있습니다.');
                        $(title).val(newTitle.substring(0,i));
                        break;
                    }
                }else{
                    i++;
                }
            }
        }
    }
    , callPopup : function(){
        $('.callPopup').addClass('active');
    }
    , imagePopup : function(type){
        let imageType = $(type).attr('data');
        $('.imagePopup').addClass('active');
        $('.imagePopup').attr('data', imageType);
        $('.imagePopup').find('input[name="contentsImg"]').prop('checked',false);
    }
    , imageLinkAdd : function(link){
        let linkVal = $(link).val();
        if(linkVal != ''){
            if(linkVal.substring(0,4) == 'http'){
                if($('#kakao .sms_img a').length > 0){
                    $('#kakao .sms_img').find('a').attr('href', linkVal);
                }else{
                    $('#kakao .sms_img').html('<a href="'+ linkVal + '" target="_blank"></a>');
                }
            }else{
                popup.popAlert('정확한 링크 URL을 입력해 주세요.');
                return false;
            }
        }else{
            return false;
        }
    }
    , kakaoAdCheck : function(){
        let value = $('.kakaoOption').filter(':checked').val();
        let box = $('#kakao_summary .line_box').length;
        if(box != 0){
            if(value == 'ad'){
                $('#kakao_summary .line_box').text('광고');
            }else{
                $('#kakao_summary .line_box').text('안내');
            }
        }else{
            if(value == 'ad'){
                $('#kakao_summary').append('<span class="line_box">광고</span>');
            }else{
                $('#kakao_summary').append('<span class="line_box">안내</span>');
            }
        }
    }
    , smsAdCheck : function(){
        let value = $('.smsOption').filter(':checked').val();
        let box = $('#sms_summary .line_box').length;
        if(box != 0){
            if(value == 'ad'){
                $('#sms_summary .line_box').text('광고');
            }else{
                $('#sms_summary .line_box').text('안내');
            }
        }else{
            if(value == 'ad'){
                $('#sms_summary').append('<span class="line_box">광고</span>');
            }else{
                $('#sms_summary').append('<span class="line_box">안내</span>');
            }
        }
    }
    , smsTypeCheck : function(){
        let value = $('.smsType').filter(':checked').val();
        let box = $('#sms_summary .type').length;
        console.info("value : " + value);
        if(box != 0){
            $('#sms_summary .type').text(value);
        }else{
            $('#sms_summary').append('<span class="type">' + value + '</span>');
        }
    }
}
//RCS 텍스트형 layout
function textLayout(type){
    let edmDB = $('#smsContsVal[name="edmDB"] .option').html();
    let defaultDB = $('#smsContsVal[name="defaultDB"] .option').html();

    let dbValue = $('.db_radio input:checked').val();
    let html = '<div class="row body">' +
        '<div class="th">카드 양식</div>' +
        '<div class="column_1">';
    // type :0 : sms , type : 1:lms
    if(type == 0){
        html += '<label class="custom_radio en_font">SMS<input name="rcs_msg_tp" class="lowType" type="radio" value="sms" checked/><span></span></label>' +
            ' <label class="custom_radio en_font">LMS<input name="rcs_msg_tp" class="lowType" type="radio" value="lms"/><span></span></label>'
            + '<input type="hidden" name ="cont_sub_list" value="" id ="rcs_cont_sub">';
    }else{
        html += '<label class="custom_radio en_font">SMS<input name="rcs_msg_tp" class="lowType" type="radio" value="sms"/><span></span></label>' +
            ' <label class="custom_radio en_font">LMS<input name="rcs_msg_tp" class="lowType" type="radio" value="lms" checked/><span></span></label>';
    }
    html +=      '</div>' +
        '</div>';
    if(type == 1){
        html += '<div class="row body">' +
            '<div class="th">문자 제목</div>' +
            '<div class="column_3">' +
            '<input type="text" class="title rcsTitle" name="cont_sub_list" placeholder="최대 30자 이내 입력" onkeyup="rcsCreate.rcsTitle(this, 0);"/>' +
            '</div>';
        if(dbValue == '0'){

            html += '<div class="select column_4 left-border rcsTitleVal" name="edmDB">' +
                '<div class="value" data="0">개인화 변수</div>' +
                '<ul class="option">' +
                edmDB +
                '</ul>'+
                '</div>';
        }
        if(dbValue == '1'){
            html += '<div class="select column_4 left-border rcsTitleVal" name="defaultDB">' +
                '<div class="value" data="0">개인화 변수</div>' +
                '<ul class="option">' +
                defaultDB +
                '</ul>'+
                '</div>';
        }

        html += '</div>';
    }
    html +=  '<div class="row body">' +
        '<div class="th">유형선택</div>' +
        '<div class="column_2 right-border">' +
        '<label class="block_radio on">' +
        '<input type="radio" name="rcs_option" class="radioAd" value="ad" checked />' +
        '<span>광고</span>' +
        '</label>' +
        '<label class="block_radio">' +
        '<input type="radio" name="rcs_option" class="radioAd" value="guide" />' +
        '<span>안내</span>' +
        '</label>' +
        '</div>' +
        '<div class="th">발신 번호</div>' +
        '<div class="column_2">' +
        '<input type="text" class="sms_number smsNumber" id="send_text_rcs" placeholder="발신 번호를 입력해주세요." readonly />' +
        '<input type="hidden" name="send_to_list" id="text_send_num"/>' +
        '<span class="btn_sm_line" onclick="mobileSenderPopup(\'1\',\'textrcs\')">변경</span>'+
        '</div>' +
        '</div>' +
        '<div class="flex_box">' +
        '<div class="input_area left">' +
        '<div class="block">'+
        '<div class="row">' +
        '<div class="th">개인화 변수</div>' +
        '<div class="td">' ;
    if(dbValue == '0'){
        html += '<div class="select rcsContsVal" name="edmDB">' +
            '<div class="value" data="0">개인화 변수</div>' +
            '<ul class="option">' +
            edmDB +
            '</ul>'+
            '</div>';
    }
    if(dbValue == '1'){
        html += '<div class="select rcsContsVal" name="defaultDB">' +
            '<div class="value" data="0">개인화 변수</div>' +
            '<ul class="option">' +
            defaultDB +
            '</ul>'+
            '</div>';
    }

    html +=                  '</div>' +
        '</div>' +
        '<div class="row rcs_textarea">' +
        '<div class="th top-border">내용</div>' +
        '<div class="td top-border">' +
        '<textarea class="rcsContents" name="rcs_body" id="" cols="30" rows="10" placeholder="내용을 입력해주세요." onkeyup="rcsCreate.rcsContents(this, 0);"></textarea>' +
        '</div>' +
        '</div>' +
        '</div>';
    let btnCount;

    // type : 0 (SMS), type : 1 (LMS)
    if(type == 0){
        btnCount = 1;
    }else{
        btnCount = 3;
    }

    for(let a = 0; a < btnCount; a++){
        html +=    '<div class="block">' +
            '<div class="row">' +
            '<div class="th bottom-border">버튼 액션 선택</div>' +
            '<div class="td bottom-border">' +
            '<div class="select action_select" data="' + Number(a + 1) + '">' +
            '<span id="btnHidden'+ Number(a + 1) +'"></span>'+
            '<div class="value" data="0">액션선택</div>' +
            '<ul class="option">' +
            '<li data="0">액션선택</li>' +
            '<li data="RBTN01">복사하기</li>' +
            '<li data="RBTN02">URL연결</li>' +
            '<li data="RBTN03">전화걸기</li>' +
            '<li data="RBTN04">지보보여주기(좌표)</li>' +
            '<li data="RBTN05">지도보여주기(쿼리)</li>' +
            '<li data="RBTN06">현재위치공유</li>' +
            '<li data="RBTN07">캘린더등록</li>' +
            '<li data="RBTN08">메시지전송</li>' +
            '</ul>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '<div class="row">' +
            '<div class="th">버튼 명</div>' +
            '<div class="td button-name">' +
            '<input type="text" name="rcs_btn_'+Number(a+1)+'"class="txt_input action_name" data="' + Number(a + 1) + '" placeholder="버튼 명을 입력해주세요." onkeyup="rcsCreate.buttonCount(this,' + '&#39;text&#39;' + ');"/>' +

            '<span class="text-count en_font"><span>0</span>/17</span>' +
            '</div>' +
            '</div>' +
            '<div class="custom_box"> </div>' +
            '</div>' ;
    }

    html +=         '<div class="block" id="rejection">' +
        '<div class="row">' +
        '<div class="th">무료수신거부</div>' +
        '<div class="td">' +
        '<input type="text" name="rcs_footer" class="txt_input rejection_num width" placeholder="수신거부 번호를 입력해주세요." oninput="rcsCreate.rejection(this);"/>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '<div class="viewer_area">' +
        '<div class="rcs_inner text">' +
        '<div class="rcs_head">[WEB발신]광고</div>' +
        '<div class="text_type">';
    if(type == 1){
        html += '<h3 class="rcs_title" id="titleArea0">제목 영역</h3>';
    }
    html +=                 '<div class="scroll_txt">' +
        '<p class="rcs_area" id="textArea0">내용 영역</p>' +
        '</div>' +
        '<div class="rcs_btn_wrap"></div>' +
        '</div>' +
        '<div class="rcs_register">무료 수신거부 : <span id="rejectionArea"></span></div>' ;
    if(type == 0) {
        html += '<div class="text_count">' +
            '<span class="num en_font"><span id="textByte0">0</span>/100</span>' +
            '<p>※ 본문내용 : <span class="en_font">100</span>글자 이내</p>' +
            '</div>';
    }else{
        html += '<div class="text_count">' +
            '<span class="num en_font"><span id="textByte0">0</span>/1300</span>' +
            '<p>※ 본문내용 : <span class="en_font">1300</span>글자 이내</p>' +
            '</div>';
    }
    html +=    '</div>' +
        '</div>' +
        '</div>' +
        '<input type ="hidden" name ="rcs_btn_tp_1" value =""/>' +
        '<input type ="hidden" name ="rcs_btn_tp_2" value =""/>' +
        '<input type ="hidden" name ="rcs_btn_tp_3" value =""/>';
    return html;
}
//RCS 가로형 layout
function horizontalLayout(type){
    let edmDB = $('#smsContsVal[name="edmDB"] .option').html();
    let defaultDB = $('#smsContsVal[name="defaultDB"] .option').html();
    let dbValue = $('.db_radio input:checked').val();
    // Type 0 : LEFT ,Type 1 : Right
    html = '<div class="row body">' +
        '<div class="th">카드 양식</div>' +
        '<div class="column_1">';
    if(type == 0){
        html += '<label class="custom_radio en_font">Left<input name="rcs_msg_tp" class="lowType" type="radio" value="left" checked/><span></span></label>' +
            '<label class="custom_radio en_font">Right<input name="rcs_msg_tp" class="lowType" type="radio" value="right"/><span></span></label>';
    }else{
        html += '<label class="custom_radio en_font">Left<input name="rcs_msg_tp" class="lowType" type="radio" value="left"/><span></span></label>' +
            '<label class="custom_radio en_font">Right<input name="rcs_msg_tp" class="lowType" type="radio" value="right" checked/><span></span></label>';
    }
    html +=     '</div>' +
        '</div>' +
        '<div class="row body">' +
        '<div class="th">문자 제목</div>' +
        '<div class="column_3">' +
        '<input type="text" class="title rcsTitle" name="cont_sub_list" placeholder="최대 30자 이내 입력" onkeyup="rcsCreate.rcsTitle(this, 0);"/>' +
        '</div>';
    if(dbValue == '0'){
        html += '<div class="select column_4 left-border rcsTitleVal" name="edmDB">' +
            '<div class="value" data="0">개인화 변수</div>' +
            '<ul class="option">' +
            edmDB +
            '</ul>'+
            '</div>';
    }
    if(dbValue == '1'){
        html += '<div class="select column_4 left-border rcsTitleVal" name="defaultDB">' +
            '<div class="value" data="0">개인화 변수</div>' +
            '<ul class="option">' +
            defaultDB +
            '</ul>'+
            '</div>';
    }
    html += '</div>' +
        '<div class="row body">' +
        '<div class="th">유형선택</div>' +
        '<div class="column_2 right-border">' +
        '<label class="block_radio on">' +
        '<input type="radio" name="rcs_option" class="radioAd" value="ad" checked />' +
        '<span>광고</span>' +
        '</label>' +
        '<label class="block_radio">' +
        '<input type="radio" name="rcs_option" class="radioAd" value="guide" />' +
        '<span>안내</span>' +
        '</label>' +
        '</div>' +
        '<div class="th">발신 번호</div>' +
        '<div class="column_2">' +
        '<input type="text" class="sms_number smsNumber" id="send_horizon_rcs" placeholder="발신 번호를 입력해주세요." readonly />' +
        '<input type="hidden" name="send_to_list" id="horizon_send_num"/>' +
        '<span class="btn_sm_line" onclick="mobileSenderPopup(\'1\',\'horizonrcs\')">변경</span>'+
        '</div>' +
        '</div>' +
        '<div class="flex_box">' +
        '<div class="input_area left">' +
        '<div class="block">' +
        '<div class="row">' +
        '<div class="th">이미지 선택</div>' +
        '<div class="td">' +
        '<div class="delete_img"><img src="../../image/btn_delete1.png" alt="삭제"></div>' +
        '<input type="text" class="txt_input en_font" class="rcsImage" name="" id="horizontalImage" placeholder="이미지를 선택해 주세요." readonly />' +
        /*'<span class="btn_sm_line" data="horizontalImage" onclick="smsCreate.imagePopup(this)">선택</span>' +*/
        '<input type ="hidden" name ="horizonImg" id ="horizonImg" value =""/>' +
        '<span class="btn_sm_line" data="horizontalImage" onclick="imageListPopUp(\'1\',\'horizontalImage\')">선택</span>'+
        '</div>' +
        '</div>' +
        '</div>' +
        '<div class="block">' +
        '<div class="row">' +
        '<div class="th">개인화 변수</div>' +
        '<div class="td">';
    if(dbValue == '0'){
        html += '<div class="select rcsContsVal" name="edmDB">' +
            '<div class="value" data="0">개인화 변수</div>' +
            '<ul class="option">' +
            edmDB +
            '</ul>'+
            '</div>';
    }
    if(dbValue == '1'){
        html += '<div class="select rcsContsVal" name="defaultDB">' +
            '<div class="value" data="0">개인화 변수</div>' +
            '<ul class="option">' +
            defaultDB +
            '</ul>'+
            '</div>';
    }
    html +=            '</div>' +
        '</div>' +
        '<div class="row rcs_textarea">' +
        '<div class="th top-border">내용</div>' +
        '<div class="td top-border">' +
        '<textarea class="rcsContents" name="rcs_body" id="" cols="30" rows="10" placeholder="내용을 입력해주세요." onkeyup="rcsCreate.rcsContents(this, 0);"></textarea>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '<div class="block">' +
        '<div class="row">' +
        '<div class="th bottom-border">버튼 액션 선택</div>' +
        '<div class="td bottom-border">' +
        '<div class="select action_select" data="1">' +
        '<span id ="btnHidden1"></span>' +
        '<div class="value" data="0">액션선택</div>' +
        '<ul class="option">' +
        '<li data="0">액션선택</li>' +
        '<li data="RBTN01">복사하기</li>' +
        '<li data="RBTN02">URL연결</li>' +
        '<li data="RBTN03">전화걸기</li>' +
        '<li data="RBTN04">지보보여주기(좌표)</li>' +
        '<li data="RBTN05">지도보여주기(쿼리)</li>' +
        '<li data="RBTN06">현재위치공유</li>' +
        '<li data="RBTN07">캘린더등록</li>' +
        '<li data="RBTN08">메시지전송</li>' +
        '</ul>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '<div class="row">' +
        '<div class="th">버튼 명</div>' +
        '<div class="td button-name">' +
        '<input type="text" name="rcs_btn_1" class="txt_input action_name" data="1" placeholder="버튼 명을 입력해주세요." onkeyup="rcsCreate.buttonCount(this,' + '&#39;horizontal&#39;' + ');"/>' +
        '<span class="text-count en_font"><span>0</span>/8</span>' +
        '</div>' +
        '</div>' +
        '<div class="custom_box"></div>' +
        '</div>' +
        '<div class="block">' +
        '<div class="row">' +
        '<div class="th bottom-border">버튼 액션 선택</div>' +
        '<div class="td bottom-border">' +
        '<div class="select action_select" data="2">' +
        '<span id ="btnHidden2"></span>' +
        '<div class="value" data="0">액션선택</div>' +
        '<ul class="option">' +
        '<li data="0">액션선택</li>' +
        '<li data="RBTN01">복사하기</li>' +
        '<li data="RBTN02">URL연결</li>' +
        '<li data="RBTN03">전화걸기</li>' +
        '<li data="RBTN04">지보보여주기(좌표)</li>' +
        '<li data="RBTN05">지도보여주기(쿼리)</li>' +
        '<li data="RBTN06">현재위치공유</li>' +
        '<li data="RBTN07">캘린더등록</li>' +
        '<li data="RBTN08">메시지전송</li>' +
        '</ul>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '<div class="row">' +
        '<div class="th">버튼 명</div>' +
        '<div class="td button-name">' +
        '<input type="text" name="rcs_btn_2" class="txt_input action_name" data="2" placeholder="버튼 명을 입력해주세요." onkeyup="rcsCreate.buttonCount(this,' + '&#39;horizontal&#39;' + ');"/>' +
        '<span class="text-count en_font"><span>0</span>/8</span>' +
        '</div>' +
        '</div>' +
        '<div class="custom_box"></div>' +
        '</div>' +
        '<div class="block" id="rejection">' +
        '<div class="row">' +
        '<div class="th">무료수신거부</div>' +
        '<div class="td">' +
        '<input type="text" name="rcs_footer" class="txt_input rejection_num width" placeholder="수신거부 번호를 입력해주세요." oninput="rcsCreate.rejection(this);"/>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '<div class="viewer_area">' +
        '<div class="rcs_inner horizontal">' +
        '<div class="rcs_head">[WEB발신]광고</div>';
    if(type == 0){
        html += '<div class="rcs_horizontal cf">' +
            '<div class="img_area"></div>' +
            '<div class="txt_area">' +
            '<h3 id="titleArea0">제목 영역</h3>' +
            '<p id="textArea0">내용 영역</p>' +
            '<div class="rcs_btn_wrap"></div>' +
            '</div>' +
            '</div>';
    }else{
        html += '<div class="rcs_horizontal cf">' +
            '<div class="txt_area">' +
            '<h3 id="titleArea0">제목 영역</h3>' +
            '<p id="textArea0">내용 영역</p>' +
            '<div class="rcs_btn_wrap"></div>' +
            '</div>' +
            '<div class="img_area"></div>' +
            '</div>';
    }
    html +=             '<div class="rcs_register">무료 수신거부 : <span id="rejectionArea"></span></div>' +
        '<div class="text_count">' +
        '<span class="num en_font"><span id="textByte0">0</span>/100</span>' +
        '<p>' +
        '※ 본문내용 : <span class="en_font">100</span>글자 이내<br/>' +
        '본문길이 : 최대 4줄' +
        '</p>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '<input type ="hidden" name ="rcs_btn_tp_1" value =""/>' +
        '<input type ="hidden" name ="rcs_btn_tp_2" value =""/>' +
        '<input type ="hidden" name ="rcs_btn_tp_3" value =""/>';
    return html;
}
//RCS 세로형 layout
function verticalLayout(type){
    let edmDB = $('#smsContsVal[name="edmDB"] .option').html();
    let defaultDB = $('#smsContsVal[name="defaultDB"] .option').html();
    let dbValue = $('.db_radio input:checked').val();
    // 세로형 type 0 : Tall , 세로형 type 1 : Medium
    html = '<div class="row body">' +
        '<div class="th">카드 양식</div>' +
        '<div class="column_1">';
    if(type == 0){
        html += '<label class="custom_radio en_font">Tall<input name="rcs_msg_tp" class="lowType" type="radio" value="tall" checked /><span></span></label>' +
            '<label class="custom_radio en_font">Medium<input name="rcs_msg_tp" class="lowType" type="radio" value="medium"/><span></span></label>';
    }else{
        html += '<label class="custom_radio en_font">Tall<input name="rcs_msg_tp" class="lowType" type="radio" value="tall"/><span></span></label>' +
            '<label class="custom_radio en_font">Medium<input name="rcs_msg_tp" class="lowType" type="radio" value="medium" checked/><span></span></label>';
    }

    html +=     '</div>' +
        '</div>' +
        '<div class="row body">' +
        '<div class="th">문자 제목</div>' +
        '<div class="column_3">' +
        '<input type="text" class="title rcsTitle" name="cont_sub_list" placeholder="최대 30자 이내 입력" onkeyup="rcsCreate.rcsTitle(this, 0);"/>' +
        '</div>';
    if(dbValue == '0'){ // 0 : db 개인화 변수
        html += '<div class="select column_4 left-border rcsTitleVal" name="edmDB">' +
            '<div class="value" data="0">개인화 변수</div>' +
            '<ul class="option">' +
            edmDB +
            '</ul>'+
            '</div>';
    }
    if(dbValue == '1'){ // 1 : 업로드 개인화 변수
        html += '<div class="select column_4 left-border rcsTitleVal" name="defaultDB">' +
            '<div class="value" data="0">개인화 변수</div>' +
            '<ul class="option">' +
            defaultDB +
            '</ul>'+
            '</div>';
    }
    html +=   '</div>' +
        '<div class="row body">' +
        '<div class="th">유형선택</div>' +
        '<div class="column_2 right-border">' +
        '<label class="block_radio on">' +
        '<input type="radio" name="rcs_option" class="radioAd" value="ad" checked />' +
        '<span>광고</span>' +
        '</label>' +
        '<label class="block_radio">' +
        '<input type="radio" name="rcs_option" class="radioAd" value="guide" />' +
        '<span>안내</span>' +
        '</label>' +
        '</div>' +
        '<div class="th">발신 번호</div>' +
        '<div class="column_2">' +
        '<input type="text" class="sms_number smsNumber" id="send_vertical_rcs" placeholder="발신 번호를 입력해주세요." readonly />' +
        '<input type="hidden" name="send_to_list" id="vertical_send_num"/>' +
        '<span class="btn_sm_line" onclick="mobileSenderPopup(\'1\',\'verticalrcs\')">변경</span>'+
        '</div>' +
        '</div>' +
        '<div class="flex_box">' +
        '<div class="input_area left">' +
        '<div class="block">' +
        '<div class="row">' +
        '<div class="th">이미지 선택</div>' +
        '<div class="td">' +
        '<div class="vertical_delete_img"><img src="../../image/btn_delete1.png" alt="삭제"></div>' +
        '<input type="text" class="txt_input en_font" name="" class="rcsImage" id="verticalImage" placeholder="이미지를 선택해 주세요." readonly />' +
        /*'<span class="btn_sm_line" data="verticalImage" onclick="smsCreate.imagePopup(this)">선택</span>' +*/
        '<input type ="hidden" name ="verticalImg" id ="verticalImg" value =""/>' +
        '<span class="btn_sm_line" data="verticalImage" onclick="imageListPopUp(\'1\',\'verticalImage\')">선택</span>'+
        '</div>' +
        '</div>' +
        '</div>' +
        '<div class="block">' +
        '<div class="row">' +
        '<div class="th">개인화 변수</div>' +
        '<div class="td">';
    if(dbValue == '0'){
        html += '<div class="select rcsContsVal" name="edmDB">' +
            '<div class="value" data="0">개인화 변수</div>' +
            '<ul class="option">' +
            edmDB +
            '</ul>'+
            '</div>';
    }
    if(dbValue == '1'){
        html += '<div class="select rcsContsVal"  name="defaultDB">' +
            '<div class="value" data="0">개인화 변수</div>' +
            '<ul class="option">' +
            defaultDB +
            '</ul>'+
            '</div>';
    }
    html +=            '</div>' +
        '</div>' +
        '<div class="row rcs_textarea">' +
        '<div class="th top-border">내용</div>' +
        '<div class="td top-border">' +
        '<textarea class="rcsContents" name="rcs_body" id="" cols="30" rows="10" placeholder="내용을 입력해주세요." onkeyup="rcsCreate.rcsContents(this, 0);"></textarea>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '<div class="block">' +
        '<div class="row">' +
        '<div class="th bottom-border">버튼 액션 선택</div>' +
        '<div class="td bottom-border">' +
        '<div class="select action_select" data="1">' +
        '<span id ="btnHidden1"></span>' +
        '<div class="value" data="0">액션선택</div>' +
        '<ul class="option">' +
        '<li data="0">액션선택</li>' +
        '<li data="RBTN01">복사하기</li>' +
        '<li data="RBTN02">URL연결</li>' +
        '<li data="RBTN03">전화걸기</li>' +
        '<li data="RBTN04">지보보여주기(좌표)</li>' +
        '<li data="RBTN05">지도보여주기(쿼리)</li>' +
        '<li data="RBTN06">현재위치공유</li>' +
        '<li data="RBTN07">캘린더등록</li>' +
        '<li data="RBTN08">메시지전송</li>' +
        '</ul>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '<div class="row">' +
        '<div class="th">버튼 명</div>' +
        '<div class="td button-name">' +
        '<input type="text" name="rcs_btn_1" class="txt_input action_name" data="1" placeholder="버튼 명을 입력해주세요." onkeyup="rcsCreate.buttonCount(this,' + '&#39;vertical&#39;' + ');"/>' +
        '<span class="text-count en_font"><span>0</span>/17</span>' +
        '</div>' +
        '</div>' +
        '<div class="custom_box"> </div>' +
        '</div>' +
        '<div class="block">' +
        '<div class="row">' +
        '<div class="th bottom-border">버튼 액션 선택</div>' +
        '<div class="td bottom-border">' +
        '<div class="select action_select" data="2">' +
        '<span id ="btnHidden2"></span>' +
        '<div class="value" data="0">액션선택</div>' +
        '<ul class="option">' +
        '<li data="0">액션선택</li>' +
        '<li data="RBTN01">복사하기</li>' +
        '<li data="RBTN02">URL연결</li>' +
        '<li data="RBTN03">전화걸기</li>' +
        '<li data="RBTN04">지보보여주기(좌표)</li>' +
        '<li data="RBTN05">지도보여주기(쿼리)</li>' +
        '<li data="RBTN06">현재위치공유</li>' +
        '<li data="RBTN07">캘린더등록</li>' +
        '<li data="RBTN08">메시지전송</li>' +
        '</ul>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '<div class="row">' +
        '<div class="th">버튼 명</div>' +
        '<div class="td button-name">' +
        '<input type="text" name="rcs_btn_2" class="txt_input action_name" data="2" placeholder="버튼 명을 입력해주세요." onkeyup="rcsCreate.buttonCount(this,' + '&#39;vertical&#39;' + ');"/>' +
        '<span class="text-count en_font"><span>0</span>/17</span>' +
        '</div>' +
        '</div>' +
        '<div class="custom_box"> </div>' +
        '</div>' +
        '<div class="block" id="rejection">' +
        '<div class="row">' +
        '<div class="th">무료수신거부</div>' +
        '<div class="td">' +
        '<input type="text" name="rcs_footer" class="txt_input rejection_num width" placeholder="수신거부 번호를 입력해주세요." oninput="rcsCreate.rejection(this);"/>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '<div class="viewer_area" id="vertical">' +
        '<div class="rcs_inner vertical">' +
        '<div class="rcs_head">[WEB발신]</div>';
    if(type == 0){
        html += '<div class="rcs_vertical tall cf">' +
            '<div class="img_area"></div>' +
            '<div class="txt_area">' +
            '<h3 id="titleArea0">제목 영역</h3>' +
            '<p id="textArea0">내용 영역</p>' +
            '<div class="rcs_btn_wrap"></div>' +
            '</div>' +
            '</div>';
    }else{
        html +='<div class="rcs_vertical medium cf">' +
            '<div class="img_area"></div>' +
            '<div class="txt_area">' +
            '<h3 id="titleArea0">제목 영역</h3>' +
            '<p id="textArea0">내용 영역</p>' +
            '<div class="rcs_btn_wrap"></div>' +
            '</div>' +
            '</div>';
    }
    html +=         '<div class="rcs_register">무료 수신거부 : <span id="rejectionArea"></span></div>' +
        '<div class="text_count">' +
        '<span class="num en_font"><span id="textByte0">0</span>/1300</span>' +
        '<p>' +
        '※ 본문내용 : <span class="en_font">1300</span>글자 이내<br/>' +
        '본문길이 : 최대 96줄' +
        '</p>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '<input type ="hidden" name ="rcs_btn_tp_1" value =""/>' +
        '<input type ="hidden" name ="rcs_btn_tp_2" value =""/>' +
        '<input type ="hidden" name ="rcs_btn_tp_3" value =""/>';
    return html;
}
//RCS 슬라이드형 layout
function slideLayout(type){
    let edmDB = $('#smsContsVal[name="edmDB"] .option').html();
    let defaultDB = $('#smsContsVal[name="defaultDB"] .option').html();
    let dbValue = $('.db_radio input:checked').val();
    let slideList = ['Small / 3장', 'Small / 4장', 'Small / 5장', 'Small / 6장', 'Medium / 3장', 'Medium / 4장', 'Medium / 5장', 'Medium / 6장']
    let html = '';
    let total;
    if(type == 0 || type == 4){
        total = 3;
    }
    if(type == 1 || type == 5){
        total = 4;
    }
    if(type == 2 || type == 6){
        total = 5;
    }
    if(type == 3 || type == 7){
        total = 6;
    }

    html += '<div class="row body">' +
        '<div class="th">카드 양식</div>' +
        '<div class="column_1">' +
        '<div class="select slide_type">' +
        '<div class="value" data="' + type +'">' + slideList[type] + '</div>' +
        '<ul class="option">';
    for(let i = 0;  i < slideList.length; i++){
        html += '<li data="' + i + '">' + slideList[i] + '</li>';
    }
    html +=              '</ul>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '<div class="row body">' +
        '<div class="th">유형선택</div>' +
        '<div class="column_2 right-border">' +
        '<label class="block_radio on">' +
        '<input type="radio" name="rcs_option" class="radioAd" value="ad" checked />' +
        '<span>광고</span>' +
        '</label>' +
        '<label class="block_radio">' +
        '<input type="radio" name="rcs_option" class="radioAd" value="guide" />' +
        '<span>안내</span>' +
        '</label>' +
        '</div>'+
        '<div class="th">발신 번호</div>' +
        '<div class="column_2">' +
        '<input type="text" class="sms_number smsNumber" id="send_slice_rcs" placeholder="발신 번호를 입력해주세요." readonly />' +
        '<input type="hidden" name="send_to_list" id="slide_send_num"/>' +
        '<span class="btn_sm_line" onclick="mobileSenderPopup(\'1\',\'slidercs\')">변경</span>'+
        '</div>' +
        '</div>' +
        '<div class="flex_box">' +
        '<div class="input_area left">' +
        '<div class="block line_none">' +
        '<div class="slide_tab cf">';
    for(let a = 0; a < total; a++){
        if(a == 0){
            html += '<div class="cardOn on" id="cardOn" data="'+ Number(a+1)+ '">' + '카드' + (a+1) + '</div>';
            // html += '<div class="on" id="cardOn" value = "'+ Number(a+1) +'">' + '카드' + (a+1) + '</div>';
        }else{
            html += '<div id="cardOn" class="cardOn" data="'+ Number(a+1)+ '">' + '카드' + (a+1) + '</div>';
        }
    }

    html +=             '</div>' +
        '</div>';

    var cnt = 0;
    var btnCnt1 = 1;
    var btnCnt2 = 2;

    // total은 총 카드 개수를 의미한다.
    for(let b = 0; b < total; b++){
        cnt = cnt;
        if(b == 0){
            html += '<div class="rcs_slide_conts on">';
        }else{
            html += '<div class="rcs_slide_conts">';
        }
        html +=     '<div class="block">' +
            '<div class="row">' +
            '<div class="th">이미지 선택</div>' +
            '<div class="td">' +
            '<div class="delete_img"><img src="../../image/btn_delete1.png" alt="삭제"/></div>' +
            '<input type="text" name="" class="txt_input en_font rcsImage" id="'+ 'slide' + b + '" placeholder="이미지를 선택해 주세요." readonly />' +
            '<input type="hidden" name="'+ 'rcs_img_cd_' + Number(b+1) +'" class="txt_input en_font rcsImage"/>' +
            '<span class="btn_sm_line" data="'+ 'slide' + b + '" onclick="imageListPopUp(\'1\',\'slideRcsImage\')">선택</span>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '<div class="block">' +
            '<div class="row">' +
            '<div class="th">개인화 변수</div>' +
            '<div class="td">';
        if(dbValue == '0'){
            html += '<div class="select rcsTitleVal" name="edmDB">' +
                '<div class="value" data="0">개인화 변수</div>' +
                '<ul class="option">' +
                edmDB +
                '</ul>'+
                '</div>';
        }
        if(dbValue == '1'){
            html += '<div class="select rcsTitleVal" name="defaultDB">' +
                '<div class="value" data="0">개인화 변수</div>' +
                '<ul class="option">' +
                defaultDB +
                '</ul>'+
                '</div>';
        }
        html +=                      '</div>' +
            '</div>' +
            '<div class="row">' +
            '<div class="th top-border">문자 제목</div>' +
            '<div class="td top-border">' +
            '<input type="text" name="slide_cont_sub" class="txt_input width rcsTitle" placeholder="최대 30자 이내 입력" onkeyup="rcsCreate.rcsTitle(this,' + b + ');">' +
            '</div>' +
            '</div>' +
            '</div>' +
            '<div class="block">' +
            '<div class="row">' +
            '<div class="th">개인화 변수</div>' +
            '<div class="td">';
        if(dbValue == '0'){
            html += '<div class="select column_4 rcsContsVal" name="edmDB">' +
                '<div class="value" data="0">개인화 변수</div>' +
                '<ul class="option">' +
                edmDB +
                '</ul>'+
                '</div>';
        }
        if(dbValue == '1'){
            html += '<div class="select column_4 rcsContsVal" name="defaultDB">' +
                '<div class="value" data="0">개인화 변수</div>' +
                '<ul class="option">' +
                defaultDB +
                '</ul>'+
                '</div>';
        }
        html +=                             '</div>' +
            '</div>' +
            '<div class="row rcs_textarea">' +
            '<div class="th top-border">내용</div>' +
            '<div class="td top-border">' +
            '<textarea class="rcsContents" name="slide_cont_body" id="" cols="30" rows="10" placeholder="내용을 입력해주세요." onkeyup="rcsCreate.rcsContents(this,' + b + ');"></textarea>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '<div class="block">' +
            '<div class="row">' +
            '<div class="th bottom-border">버튼 액션 선택</div>' +
            '<div class="td bottom-border">' +
            '<div class="select action_select" data="1">' +
            '<span id="btnHidden'+ Number(btnCnt1) +'"></span>';
        btnCnt1 = btnCnt1 + 2
        html+= '<div class="value" data="0">액션선택</div>' +
            '<ul class="option">' +
            '<li data="0">액션선택</li>' +
            '<li data="RBTN01">복사하기</li>' +
            '<li data="RBTN02">URL연결</li>' +
            '<li data="RBTN03">전화걸기</li>' +
            '<li data="RBTN04">지보보여주기(좌표)</li>' +
            '<li data="RBTN05">지도보여주기(쿼리)</li>' +
            '<li data="RBTN06">현재위치공유</li>' +
            '<li data="RBTN07">캘린더등록</li>' +
            '<li data="RBTN08">메시지전송</li>' +
            '</ul>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '<div class="row">' +
            '<div class="th">버튼 명</div>' +
            '<div class="td button-name">';
        if(type < 4){
            html += '<input type="text" name="slide_rcs_btn_1" class="txt_input action_name" data="1" placeholder="버튼 명을 입력해주세요." onkeyup="rcsCreate.buttonCount(this,' + '&#39;slideSmall&#39;' + ');"/>' +
                '<span class="text-count en_font"><span>0</span>/5</span>';
        }else{
            html += '<input type="text" name="slide_rcs_btn_1" class="txt_input action_name" data="1" placeholder="버튼 명을 입력해주세요." onkeyup="rcsCreate.buttonCount(this,' + '&#39;slideMedium&#39;' + ');"/>' +
                '<span class="text-count en_font"><span>0</span>/17</span>';
        }
        html +=                          '</div>' +
            '</div>' +
            '<div class="custom_box"> </div>' +
            '</div>' +
            '<div class="block">' +
            '<div class="row">' +
            '<div class="th bottom-border">버튼 액션 선택</div>' +
            '<div class="td bottom-border">' +
            '<div class="select action_select" data="2">' +
            '<span id="btnHidden'+ Number(btnCnt2) +'"></span>';
        btnCnt2 = btnCnt2 +2
        html+=    '<div class="value" data="0">액션선택</div>' +
            '<ul class="option">' +
            '<li data="0">액션선택</li>' +
            '<li data="RBTN01">복사하기</li>' +
            '<li data="RBTN02">URL연결</li>' +
            '<li data="RBTN03">전화걸기</li>' +
            '<li data="RBTN04">지보보여주기(좌표)</li>' +
            '<li data="RBTN05">지도보여주기(쿼리)</li>' +
            '<li data="RBTN06">현재위치공유</li>' +
            '<li data="RBTN07">캘린더등록</li>' +
            '<li data="RBTN08">메시지전송</li>' +
            '</ul>' +
            '</div>' +
            '</div>' +
            '</div>' +
            '<div class="row">' +
            '<div class="th">버튼 명</div>' +
            '<div class="td button-name">';
        if(type < 4){
            html += '<input type="text" name="slide_rcs_btn_2" class="txt_input action_name" data="2" placeholder="버튼 명을 입력해주세요." onkeyup="rcsCreate.buttonCount(this,' + '&#39;slideSmall&#39;' + ');"/>' +
                '<span class="text-count en_font"><span>0</span>/5</span>';
        }else{
            html += '<input type="text" name="slide_rcs_btn_2" class="txt_input action_name" data="2" placeholder="버튼 명을 입력해주세요."  onkeyup="rcsCreate.buttonCount(this,' + '&#39;slideMedium&#39;' + ');"/>' +
                '<span class="text-count en_font"><span>0</span>/17</span>';
        }
        html +=                         '</div>' +
            '</div>' +
            '<div class="custom_box"></div>' +
            '</div>' +
            '<input type ="hidden" name ="slide_rcs_btn_tp_1" value ="" id="'+'slide_rcs_btn_tp_'+ Number(++cnt) +'"/>' +
            '<input type ="hidden" name ="slide_rcs_btn_tp_2" value ="" id="'+'slide_rcs_btn_tp_'+ Number(++cnt) +'"/>' +
            '</div>' ;

    }

    html +=     '<div class="block" id="rejection">' +
        '<div class="row">' +
        '<div class="th">무료수신거부</div>' +
        '<div class="td">' +
        '<input type="text" name="rcs_footer" class="txt_input rejection_num width" placeholder="수신거부 번호를 입력해주세요." oninput="rcsCreate.rejection(this);"/>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '<div class="viewer_area">' +
        '<div class="rcs_inner rcs_slide">' +
        '<div class="slide_area">' +
        '<div class="rcs_prev"><img src="../../image/ico_rcs_prev.png" alt=""/></div>' +
        '<div class="rcs_next"><img src="../../image/ico_rcs_next.png" alt=""/></div>';
    if(type < 4){
        html += '<div class="swiper-container slideSwiper small">';
    }else{
        html += '<div class="swiper-container slideSwiper medium">';
    }
    html +=                 '<div class="swiper-wrapper">';
    for(let c = 0; c < total; c++){
        html += '<div class="swiper-slide '+ 'slide' + c + '">' +
            '<div class="rcs_head">[WEB발신]광고</div>' +
            '<section>' +
            '<div class="img_area"></div>' +
            '<div class="txt_area">' +
            '<h3 id="titleArea' + c + '">제목 영역</h3>' +
            '<p id="textArea' + c + '">내용 영역</p>' +
            '<div class="rcs_btn_wrap"></div>' +
            '</div>' +
            '</section>' +
            '<div class="text_count">';
        if(type < 4){
            html += '<span class="num en_font"><span id="textByte'+ c +'">0</span>/30</span>';
        }else{
            html += '<span class="num en_font"><span id="textByte'+ c +'">0</span>/60</span>';
        }
        html +=                                           '</div>' +
            '</div>';
    }
    html +=                        '</div>' +
        '<div class="rcs_paging en_font">1/3</div>' +
        '<div class="rcs_register">무료 수신거부 : <span id="rejectionArea"></span></div>' +
        '<div class="text_count">';
    if(type < 4){
        html += '<p>' +
            '※ 본문내용 : 카드 당 <span class="en_font">30</span>글자 이내<br/>' +
            '본문길이 : 최대 4줄<br/>' +
            '모든 카드내용의 총합 : 1300글자' +
            '</p>';
    }else{
        html += '<p>' +
            '※ 본문내용 : 카드 당 <span class="en_font">60</span>글자 이내<br/>' +
            '본문길이 : 최대 4줄<br/>' +
            '모든 카드내용의 총합 : 1300글자' +
            '</p>';
    }
    html +=                        '</div>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '<input type="hidden" name="cont_sub_list" value="">' +
        '<input type="hidden" name="rcs_msg_tp" value="small"/>';
    return html;
}

let rcsCreate = {
    layout : function(type){
        // 선택 했을시 기존 hidden 값 제거
        $("#rcs_cont_sub").remove();

        let layoutType = type.value;

        let html = '';
        $('.rcs_layout').children().remove();
        // test
        if(layoutType == 'text'){
            // text 클릭시 다시 활성화
            $('.rcs_layout').html(textLayout(0));
        }
        if(layoutType == 'horizontal'){
            $('.rcs_layout').html(horizontalLayout(0));
        }
        if(layoutType == 'vertical'){
            $('.rcs_layout').html(verticalLayout(0));
        }
        if(layoutType == 'slide'){
            // let layout7 = ;
            $('.rcs_layout').html(slideLayout(0));
            var mySwiper = new Swiper('.slideSwiper', {
                // Optional parameters
                direction: 'horizontal',

                // If we need pagination
                pagination: {
                    el: '.rcs_paging',
                    type: 'fraction',
                },

                // Navigation arrows
                navigation: {
                    nextEl: '.rcs_next',
                    prevEl: '.rcs_prev',
                },
            });
        }

    }
    , text : function(type){
        let value = type.value;
        $('.rcs_layout').children().remove();
        if(value == 'sms'){
            $('.rcs_layout').html(textLayout(0));
        }else{
            $('.rcs_layout').html(textLayout(1));
        }
    }
    , horizontal : function(type){
        let value = type.value;
        $('.rcs_layout').children().remove();
        if(value == 'left'){
            $('.rcs_layout').html(horizontalLayout(0));
        }else{
            $('.rcs_layout').html(horizontalLayout(1));
        }
    }
    , vertical : function(type){
        let value = type.value;
        //console.log("value : " + value);
        $('.rcs_layout').children().remove();
        if(value == 'tall'){
            $('.rcs_layout').html(verticalLayout(0));
        }else{
            $('.rcs_layout').html(verticalLayout(1));
        }
    }
    , rcsTitle : function(title, number){
        let titleTxt = $(title).val();
        let newTitle = new String(titleTxt);
        let txtLength = newTitle.length;
        let stringAt;
        let count = 0;
        let code = event.keyCode;
        let stringTitle = '';
        $('#titleArea' + number).html(titleTxt);

        for(let a = 0; a < txtLength; a++){
            stringAt = newTitle.charAt(a);
            if(escape(stringAt) == '%0D'){}
            else if(escape(stringAt).length > 4){
                count ++;
            }else{
                count ++;
            }
        }

        if(code != 8 && count > 30){
            popup.popAlert('RCS 문자 제목은 최대 30글자까지 입력가능합니다.');
            stringTitle = titleTxt.substr(0,30);
            title.value = stringTitle;
            return false;
        }

    }
    , rcsContents : function(text, number){
        let textValue = text.value;
        let newText = new String(textValue);
        let txtLength = newText.length;
        let stringAt;
        let count = 0;
        textValue = textValue.replace(/(?:\r\n|\r|\n|\\\\r\\\\n)/g, '<br/>');

        for(let a = 0; a < txtLength; a++){
            stringAt = newText.charAt(a);
            if(escape(stringAt) == '%0D'){}
            else if(escape(stringAt).length > 4){
                count ++;
            }else{
                count ++;
            }
        }

        $("#textByte" + number).html(count);
        $('#textArea' + number).html(textValue);
    }
    , rejection : function(number){
        number.value = number.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');
        let rejectionNumber = number.value;
        document.getElementById('rejectionArea').innerHTML = rejectionNumber;
    }
    , buttonCount : function(name, type){
        let buttonName = $(name).val();
        let txtLength = buttonName.length;
        let typeSlide = $(name).parents('.rcs_slide_conts').length;
        let buttonInx = $(name).attr('data');
        let activeInx = $(name).parents('.rcs_slide_conts').index() - 1;

        if(type == 'text' || type == 'vertical' || type == 'slideMedium'){
            if(txtLength > 17){
                $(name).val(buttonName.substring(0,17));
            }
        }
        if(type == 'horizontal'){
            if(txtLength > 8){
                $(name).val(buttonName.substring(0,8));
            }
        }
        if(type == 'slideSmall'){
            if(txtLength > 5){
                $(name).val(buttonName.substring(0,5));
            }
        }

        if(typeSlide == 0){
            $('.rcs_btn_wrap').find('div[data="' + buttonInx + '"]').text($(name).val());
        }else{
            $('.swiper-slide').eq(activeInx).find('.rcs_btn_wrap div[data="' + buttonInx + '"]').text($(name).val());
        }

        let count = $(name).val().length;
        $(name).siblings('.text-count').find('span').html(count);
    }
    , rcsAdCheck : function(){
        let value = $('.radioAd').filter(':checked').val();
        let box = $('#rcs_summary .line_box').length;
        if(box != 0){
            if(value == 'ad'){
                $('#rcs_summary .line_box').text('광고');
            }else{
                $('#rcs_summary .line_box').text('안내');
            }
        }else{
            if(value == 'ad'){
                $('#rcs_summary').append('<span class="line_box">광고</span>');
            }else{
                $('#rcs_summary').append('<span class="line_box">안내</span>');
            }
        }
    }
    , rcsTypeCheck : function(){
        let value = $('.rcsType').filter(':checked').val();
        let box = $('#rcs_summary .type').length;
        if(box != 0){
            if(value == 'text') $('#rcs_summary .type').text('텍스트형');
            if(value == 'horizontal') $('#rcs_summary .type').text('가로형');
            if(value == 'vertical') $('#rcs_summary .type').text('세로형');
            if(value == 'slide') $('#rcs_summary .type').text('슬라이드형');
        }else{
            if(value == 'text') $('#rcs_summary').append('<span class="type">' + '텍스트형' + '</span>');
            if(value == 'horizontal') $('#rcs_summary').append('<span class="type">' + '가로형' + '</span>');
            if(value == 'vertical') $('#rcs_summary').append('<span class="type">' + '세로형' + '</span>');
            if(value == 'slide') $('#rcs_summary').append('<span class="type">' + '슬라이드형' + '</span>');
        }
        return value;
    }
    , rcsLowTypeCheck : function(){
        let value = $('.lowType').filter(':checked').val();
        let box = $('#rcs_summary .low').length;
        if(box != 0){
            if(value == 'sms') $('#rcs_summary .low').text('SMS');
            if(value == 'lms') $('#rcs_summary .low').text('LMS');
            if(value == 'left') $('#rcs_summary .low').text('Left');
            if(value == 'right') $('#rcs_summary .low').text('Right');
            if(value == 'tall') $('#rcs_summary .low').text('Tall');
            if(value == 'medium') $('#rcs_summary .low').text('Medium');
        }else{
            if(value == 'sms') $('#rcs_summary').append('<span class="low">' + 'SMS' + '</span>');
            if(value == 'lms') $('#rcs_summary').append('<span class="low">' + 'LMS' + '</span>');
            if(value == 'left') $('#rcs_summary').append('<span class="low">' + 'Left' + '</span>');
            if(value == 'right') $('#rcs_summary').append('<span class="low">' + 'Right' + '</span>');
            if(value == 'tall') $('#rcs_summary').append('<span class="low">' + 'Tall' + '</span>');
            if(value == 'medium') $('#rcs_summary').append('<span class="low">' + 'Medium' + '</span>');
        }
    }
    , rcsSlideTypeCheck : function(){
        let value = Number($('.slide_type .value').attr('data'));
        let box = $('#rcs_summary .low').length;
        if(box != 0){
            if(value == 0) $('#rcs_summary .low').text('Small 3장');
            if(value == 1) $('#rcs_summary .low').text('Small 4장');
            if(value == 2) $('#rcs_summary .low').text('Small 5장');
            if(value == 3) $('#rcs_summary .low').text('Small 6장');
            if(value == 4) $('#rcs_summary .low').text('Medium 3장');
            if(value == 5) $('#rcs_summary .low').text('Medium 4장');
            if(value == 6) $('#rcs_summary .low').text('Medium 5장');
            if(value == 7) $('#rcs_summary .low').text('Medium 6장');
        }else{
            if(value == 0) $('#rcs_summary').append('<span class="low">' + 'Small 3장' + '</span>');
            if(value == 1) $('#rcs_summary').append('<span class="low">' + 'Small 4장' + '</span>');
            if(value == 2) $('#rcs_summary').append('<span class="low">' + 'Small 5장' + '</span>');
            if(value == 3) $('#rcs_summary').append('<span class="low">' + 'Small 6장' + '</span>');
            if(value == 4) $('#rcs_summary').append('<span class="low">' + 'Medium 3장' + '</span>');
            if(value == 5) $('#rcs_summary').append('<span class="low">' + 'Medium 4장' + '</span>');
            if(value == 6) $('#rcs_summary').append('<span class="low">' + 'Medium 5장' + '</span>');
            if(value == 7) $('#rcs_summary').append('<span class="low">' + 'Medium 6장' + '</span>');
        }
    }

}
