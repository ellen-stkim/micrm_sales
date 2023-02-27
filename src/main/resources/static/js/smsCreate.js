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
            let limetCnt = 1000;
            $(textCount).removeClass("red_border");
            $('.kakao_byte').parent('.byte').removeClass("red_color");

            if($('#kakao_img_cd').val()){
                limetCnt =400;
            }
            if(count>limetCnt){
                $(textCount).addClass("red_border");
                $('.kakao_byte').parent('.byte').addClass("red_color");
            }
            $('.kakao_byte').html(count);
        }else{
            let smsType = $('input[name="sms_msg_tp"]:checked').val();
            $(textCount).removeClass("red_border");
            $('.sms_byte').parent('.byte').removeClass("red_color");

            let limetCnt;
            switch (smsType){
                case "LMS":
                    limetCnt = 2000;
                    break;
                case "MMS":
                    limetCnt = 1000;
                    break;
                case "SMS":
                    limetCnt = 90;
                    break;
            }

            if(count>limetCnt){
                $(textCount).addClass("red_border");
                $('.sms_byte').parent('.byte').addClass("red_color");
            }
            $('.sms_byte').html(count);
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
            if(escape(stringAt) == '%0D'){}
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
    html += '<div class="left_area">'
        + '<div class="row body">'
        + '<div class="th">카드 양식</div>'
        + '<div class="column_1">'
        + '<div class="select slide_type">'
        + '<div class="value" data="' + type + '">' + slideList[type] + '</div>'
        + '<ul class="option">';
    for (let i = 0; i < slideList.length; i++) {
        html += '<li data="' + i + '">' + slideList[i] + '</li>';
    }
    html +=     '</ul>'
        + '</div>'
        + '</div>'
        + '</div>'
        + '<div class="row body">'
        + '<div class="th">발신 번호</div>'
        + '<div class="column_1" id="send_text_column">'
        + '<input type="text" class="sms_number smsNumber" id="send_slice_rcs" placeholder="발신 번호를 입력해주세요." readonly />'
        + '<input type="hidden" name="send_to_list" id="slide_send_num"/>'
        + '<span class="btn_sm_line" onclick="mobileSenderPopup(\'1\',\'slidercs\')">변경</span>'
        + '</div>'
        + '</div>'
        + '<div class="input_area left">';
    html +=     '<div class="block line_none">'
        + '<div class="slide_tab cf">';
    for(let a = 0; a < total; a++){
        if(a == 0){
            html += '<div class="cardOn on" data="' + Number(a+1) + '">카드' + Number(a+1) + '</div>';
        }else{
            html += '<div class="cardOn" data="' + Number(a+1) + '">카드' + Number(a+1) + '</div>';
        }
    }
    html +=           '</div>'
        + '</div>';


    var cnt = 0;
    var checkCnt = 0;

    for(let b = 0; b < total; b++){
        cnt = cnt;
        checkCnt = checkCnt;
        if(b == 0){ // b : 1  -> b : 0
            html += '<div class="rcs_slide_conts on">';
        }else{
            html += '<div class="rcs_slide_conts">';
        }
        html+= '<div class="block">'
            + '<div class="row">'
            + '<div class="th">이미지 선택</div>'
            + '<div class="td">'
            + '<div class="delete_img">'
            + '<img src="/image/btn_delete1.png" alt="삭제"/>'
            + '</div>'
            + '<input type="text" name="" class="txt_input en_font rcsImage" id="slide' + b + '" placeholder="이미지를 선택해 주세요." readonly=""/>'
            + '<input type="hidden" name="rcs_img_cd_' + Number(b+1) + '" class="txt_input en_font rcsImage">'
            + '<span class="btn_sm_line" data="slide' + b + '" onclick="imageListPopUp(\'1\',\'slideRcsImage\')">선택</span>'
            + '</div>'
            + '</div>'
            + '</div>'
            + '<div class="block">'
            + '<div class="row">'
            + '<div class="th">개인화 변수</div>'
            + '<div class="td">'
            + '<div class="select rcsTitleVal" name="edmDB">'
            + '<div class="value" data="0">개인화 변수</div>'
            + '<ul class="option mappingLst">'
            + '</ul>'
            + '</div>'
            + '<div class="select rcsTitleVal" name="defaultDB">'
            + '<div class="value" data="0">개인화 변수</div>'
            + '<ul class="option mappingLst"></ul>'
            + '</div>'
            + '</div>'
            + '</div>'
            + '<div class="row">'
            + '<div class="th top-border">문자 제목</div>'
            + '<div class="td top-border">'
            + '<input type="text" name="slide_cont_sub" class="txt_input width rcsTitle" placeholder="최대 30자 이내 입력" onkeyup="rcsCreate.rcsTitle(this,' + b + ');"/>'
            + '</div>'
            + '</div>'
            + '</div>'
            + '<div class="block">'
            + '<div class="row">'
            + '<div class="th">개인화 변수</div>'
            + '<div class="td">'
            + '<div class="select column_4 rcsContsVal" name="edmDB">'
            + '<div class="value" data="0">개인화 변수</div>'
            + '<ul class="option mappingLst"></ul>'
            + '</div>'
            + '<div class="select column_4 rcsContsVal" name="defaultDB">'
            + '<div class="value" data="0">개인화 변수</div>'
            + '<ul class="option mappingLst"></ul>'
            + '</div>'
            + '</div>'
            + '</div>'
            + '<div class="row rcs_textarea">'
            + '<div class="th top-border">내용</div>'
            + '<div class="td top-border"><textarea class="rcsContents" name="slide_cont_body" id="" cols="30" rows="10"'
            + 'placeholder="내용을 입력해주세요." onkeyup="rcsCreate.rcsContents(this,' + b + ');"></textarea></div>'
            + '</div>'
            + '</div>';


        for(let c=0; c < 2; c++){
            html += '<div class="block">'
                + '<div class="row">'
                + '<div class="th bottom-border">버튼 액션 선택</div>'
                + '<div class="td bottom-border">'
                //+ '<div class="select action_select" data="' + Number(b+1) + '">'
                + '<div class="select action_select" data="' + Number( c + 1) + '">'
                + '<span id="btnHidden' + Number(++checkCnt) + '"></span>'
                + '<div class="value" data="0">액션선택</div>'
                + '<ul class="option">'
                + '<li data="0">액션선택</li>'
                + '<li data="RBTN01">복사하기</li>'
                + '<li data="RBTN02">URL연결</li>'
                + '<li data="RBTN03">전화걸기</li>'
                + '<li data="RBTN04">지보보여주기(좌표)</li>'
                + '<li data="RBTN05">지도보여주기(쿼리)</li>'
                + '<li data="RBTN06">현재위치공유</li>'
                + '<li data="RBTN07">캘린더등록</li>'
                + '<li data="RBTN08">메시지전송</li>'
                + '</ul>'
                + '</div>'
                + '</div>'
                + '</div>'
                + '<div class="row">'
                +'<div class="th">버튼 명</div>'
                +'<div class="td button-name">'
                +'<input type="text" name="slide_rcs_btn_' + Number(c+1) + '" class="txt_input action_name"'
                + 'data="' + Number(c+1);
            if(type < 4){
                html += '" placeholder="버튼 명을 입력해주세요." onkeyup="rcsCreate.buttonCount(this,\'slideSmall\');">'
                    + '<span class="text-count en_font"><span>0</span>/5</span></div>';
            }else{
                html += '" placeholder="버튼 명을 입력해주세요." onkeyup="rcsCreate.buttonCount(this,\'slideMedium\');">'
                    + '<span class="text-count en_font"><span>0</span>/17</span></div>';
            }

            html += '</div>'
                + '<div class="custom_box"> </div>'
                + '</div>';
        }
        html += '<input type ="hidden" name ="slide_rcs_btn_tp_1" value ="" id="'+'slide_rcs_btn_tp_'+ Number(++cnt) +'"/>'
            + '<input type ="hidden" name ="slide_rcs_btn_tp_2" value ="" id="'+'slide_rcs_btn_tp_'+ Number(++cnt) +'"/>'
            + '</div>';
    }
    html += '<div class="block" id="rejection">'
        + '<div class="row">'
        + '<div class="th">무료수신거부</div>'
        + '<div class="td"><input type="text" name="rcs_footer" class="txt_input rejection_num width" placeholder="수신거부 번호를 입력해주세요." oninput="rcsCreate.rejection(this);"></div>'
        + '</div>'
        + '</div>'
        + '</div>'
        + '</div>'
        + '</div>';
    html += '<div class="viewer_area" id="">'
        + '<div class="rcs_inner rcs_slide">'
        + '<div class="slide_area">'
        + '<div class="rcs_prev"><img src="/image/ico_rcs_prev.png" alt=""/></div>'
        + '<div class="rcs_next"><img src="/image/ico_rcs_next.png" alt=""/></div>';
    if (type < 4){
        // 슬라이드 스몰
        html += '<div class="swiper-container slideSwiper small">';
    }else{
        // 슬라이드 미디엄
        html += '<div class="swiper-container slideSwiper medium">';
    }
    html += '<div class="swiper-wrapper">';
    for(let d=0; d < total; d++){
        html += '<div class="swiper-slide slide' + d + '">'
            + '<div class="rcs_head">[WEB발신]광고</div>'
            + '<section>'
            + '<div class="img_area"></div>'
            + '<input type="hidden" name="rcs_img_url_' + Number(d+1) + '"/>'
            + '<div class="txt_area">'
            + '<h3 id="titleArea' + d + '">제목 영역</h3>'
            + '<p id="textArea' + d + '">내용 영역</p>'
            + '<div class="rcs_btn_wrap"></div>'
            + '</div>'
            + '</section>'
            + '<div class="text_count">';
        if (type < 4) {
            html += '<span class="num en_font"><span id="textByte' + d + '">0</span>/30</span>';
        } else {
            html += '<span class="num en_font"><span id="textByte' + d + '">0</span>/60</span>';
        }
        html += '</div>'
            + '</div>';
    }
    html += '</div>'
        + '<div class="rcs_paging en_font">1/3</div>'
        + '<div class="rcs_register">무료 수신거부 : <span id="rejectionArea"></span></div>'
        + '<div class="text_count">';
    if(type < 4){
        html +=  '<p>'
            + '※ 본문내용 : 카드 당 <span class="en_font">30</span>글자 이내<br/>'
            + '본문길이 : 최대 4줄<br/>'
            + '모든 카드내용의 총합 : 1300글자'
            + '</p>';
    }else{
        html +=  '<p>'
            + '※ 본문내용 : 카드 당 <span class="en_font">60</span>글자 이내<br/>'
            + '본문길이 : 최대 4줄<br/>'
            + '모든 카드내용의 총합 : 1300글자'
            + '</p>';
    }
    html += '</div>'
        + '</div>'
        + '</div>'
        + '</div>'
        + '</div>'
        + '<input type="hidden" name="cont_sub_list" value="">'
        + '<input type="hidden" name="rcs_msg_tp" value="small">'
        + '</div>';

        return html;
}

let rcsCreate = {
    rcsTitle : function(title, number){
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

        // 제한글자 초과
        let typeEl = $('input[name="rcs_msg_tp"]:checked');
        let limit = 30;

        if(typeEl.length == 0 ){  // 슬라이드형
            let data = $('.slide_type .value').attr('data');

            console.log(data);
            console.log(text);
            console.log(number);

            let textDiv = $("#textByte" + number).parents('.text_count');
            $(text).removeClass("red_border");
            $(textDiv).removeClass("red_color");

            if(count > limit){
                $(text).addClass("red_border");
                $(textDiv).addClass("red_color");
            }

            let limitOverCnt =  $('.rcs_slide .swiper-slide .text_count.red_color').length;

            let limitText = $('.swiper-container > .text_count');
            if(limitOverCnt > 0){
                limitText.addClass('red_color');
            }else {
                limitText.removeClass('red_color');
            }

        } else {
            let type = $(typeEl).val();

            switch (type){
                case "sms":
                    limit = 100;
                    break;
                case "lms":
                case "tall":
                case "medium":
                    limit = 1300;
                    break;
            }

            $(text).removeClass("red_border");
            $('.text_count').removeClass("red_color");

            if(count > limit){
                $(text).addClass("red_border");
                $('.text_count').addClass("red_color");
            }
        }
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
}