$(function () {
    // 파일 선택 click event
    $('.file').on('click',function(){
        let type = $('input[name="ch_tp"]:checked').val();
        if(type == 'RCS'){
            let type = $('.rcs_select .value').attr('data');
            if(type == '0'){
                popup.popAlert('RCS 양식을 선택해주세요.');
                $("#file").val();
                $(".img_viewer").children().remove();
                $(".img_view").addClass('noImg');
                return false;
            }
        }
    });

    // file input value change event
    $(document).on('change','.file',function(){
        let fileName = $(this).val();
        let file = $(this)[0].files[0];
        img = new Image();
        let ex = fileName.slice(fileName.lastIndexOf('.') + 1).toLowerCase();
        let type = $('input[name="ch_tp"]:checked').val();

        if (type == 'IMGTP02') {
            if (!(ex == "jpg" || ex == "png")) {
                popup.popAlert('모바일에 경우 jpg, png 파일만 업로드 가능 합니다.');
                $(this).val('');
                $("#file").val();
                $(".img_viewer").children().remove();
                $(".img_view").addClass('noImg');
                return false;
            } else {
                // 모바일 이미지 유효성 검사
                imageUpload(this);
            }
        } else if (type == 'IMGTP09' || type =='IMGTP10') {  // 알림톡
            if (!(ex == "jpg" || ex == "png")) {
                popup.popAlert('알림톡의 경우 jpg, png 파일만 업로드 가능 합니다.');
                $(this).val('');
                $("#file").val();
                $(".img_viewer").children().remove();
                $(".img_view").addClass('noImg');
                return false;
            } else {
                // 이미지 유효성 검사
                atImageUpload(this,type)
            }
        } else if (type == 'IMGTP03' || type =='IMGTP11') {  // 친구톡
            if (!(ex == "jpg" || ex == "png")) {
                popup.popAlert('친구톡의 경우 jpg, png 파일만 업로드 가능 합니다.');
                $(this).val('');
                $("#file").val();
                $(".img_viewer").children().remove();
                $(".img_view").addClass('noImg');
                return false;
            } else {
                // 이미지 유효성 검사
                ftImageUpload(this,type)
            }
        } else if(type == 'IMGTP01') {
            if (!(ex == "jpg" || ex == "png" || ex == "gif")) {
                popup.popAlert('이메일에 경우 jpg, png, gif 파일만 업로드 가능 합니다.');
                $("#file").val();
                $(".img_viewer").children().remove();
                $(".img_view").addClass('noImg');
                $(this).val('');
                return false;
            } else {
                // 이메일 이미지 유효성 검사
                setThumbnail();
            }
        } else if(type == 'RCS') {
            let type = $('.rcs_select .value').attr('data');
            if (!(ex == "jpg" || ex == "png" || ex == "gif")) {
                popup.popAlert('RCS의 경우 jpg, png, gif 파일만 업로드 가능 합니다.');
                $("#file").val();
                $(".img_viewer").children().remove();
                $(".img_view").addClass('noImg');
                $(this).val('');
                return false;
            } else {
                if(type == 'IMGTP04'){
                    horizontal(this);
                    return false;
                }else if(type == 'IMGTP05'){
                    verticalTall(this);
                    return false;
                }else if(type == 'IMGTP06'){
                    verticalMedium(this);
                    return false;
                }else if(type == 'IMGTP07'){
                    slideSmall(this);
                    return false;
                }else if(type == 'IMGTP08'){
                    slideMedium(this);
                    return false;
                }else{
                    $("#file").val();
                    $(".img_viewer").children().remove();
                    $(".img_view").addClass('noImg');
                    popup.popAlert('RCS 유형을 선택해주세요.');
                    return false;
                }
            }
        }
    });

    // 이미지 채널 change event
    $(document).on('change','input[name="ch_tp"]',function(){
        let channel = $(this).filter(':checked').val();
        $('input[name="img_nm"]').val('');
        $('#fileName').val('');
        $('.file').val('');
        $('.img_viewer').find('img').remove();

        if(channel == 'RCS'){
            $('.guide_lst').css('display','none');
            $('tr.rcs_option').css('display','table-row');
            $('.guide_txt').css('display','block');

        } else if(channel == 'IMGTP09'){   //알림톡 아이템리스트 이미지
            $('.guide_lst').css('display','none');
            $('.at_guide1').css('display','block');
            $('tr.rcs_option').css('display','none');
        } else if(channel == 'IMGTP10'){  // 알림톡 아이템리스트 이미지
            $('.guide_lst').css('display','none');
            $('.at_guide2').css('display','block');
            $('tr.rcs_option').css('display','none');
        } else if(channel == 'IMGTP03'){   // 친구톡 이미지
            $('.guide_lst').css('display','none');
            $('.ft_guide1').css('display','block');
            $('tr.rcs_option').css('display','none');
        } else if(channel == 'IMGTP11'){   // 친구톡 와이드 이미지
            $('.guide_lst').css('display','none');
            $('.ft_guide2').css('display','block');
            $('tr.rcs_option').css('display','none');
        } else{
            $('.guide_lst').css('display','none');
            $('tr.rcs_option').css('display','none');
            $('.other_guide').css('display','block');
        }
    });

    // RCS 양식 select box click event
    // 2021-05-04 RCS 가로형 삭제로 인해 변경
    $(document).on('click','.rcs_select ul li', function(){
        let type = $(this).attr('data');
        let num;
        $('input[name="img_nm"]').val('');
        $('#fileName').val('');
        $('.file').val('');
        $('.img_viewer').children().remove();

        if(type == '0' || type == 'IMGTP05' || type == 'IMGTP06') {
            // 처음 값 선택, RCS 세로형 타입
            num = 0;
        } if(type == 'IMGTP07' || type == 'IMGTP08') {
            // 슬라이드형 Type
            num = 1;
        }

       /* if(type == '0' || type == 'IMGTP04'){
            num = 0;
        }if(type == 'IMGTP05' || type == 'IMGTP06'){
            num = 1;
        }if(type == 'IMGTP07' || type == 'IMGTP08'){
            num = 2;
        }*/

        $('.guide_txt li').eq(num).addClass('on').siblings().removeClass('on');
    });

    // 이미지 form 유효성 검사
    $('#form').validate({
         errorPlacement : $.noop
        , invalidHandler: function(form, validator) {
          let errors = validator.numberOfInvalids();
          if(errors){
            $('.uploadPopup .blue_point_color').html(validator.errorList[0].message);
          }
        }
        , rules: {
            img_nm: {
                required: true
            }
            ,fileName: {
                required: true
            }
        }
        , messages: {
            img_nm: {
                required: '이미지명을 입력해주세요.'
            }
            ,fileName: {
                required: '이미지를 선택해주세요.'
            }
        }
    });
});

//이메일 이미지 유효성 체크 function
function setThumbnail() {
    let preview = document.querySelector('.img_viewer');
    let file = document.querySelector('input[type="file"]').files[0];
    let reader = new FileReader();
    let imgLength = preview.childElementCount;
    let imgChild = document.querySelector('.img_viewer img');

    if (imgLength > 0) {
        preview.removeChild(imgChild);
    }

    reader.addEventListener("load", function () {
        let img = document.createElement('img');
        preview.appendChild(img);
        img.src = reader.result;
        document.getElementById('fileName').value = file.name;
        document.querySelector('.img_viewer').classList.remove('noImg');
    }, false);

    if (file) {
        reader.readAsDataURL(file);
    }
}

// 모바일 이미지 사이즈, 용량 체크 function
function imageUpload(addImage) {
    let file = $(addImage)[0].files[0];
    img = new Image();
    let imgWidth = 0;
    let imgHeight = 0;
    let maxWidth = 500;
    let maxHeight = 250;

    img.src = URL.createObjectURL(file);
    img.onload = function () {
        imgWidth = this.width;
        imgHeight = this.height;

        let temp_gcd = gcdlcm(imgWidth, imgHeight);
        let a = temp_gcd[0];
        let r_width = 0;
        let r_height = 0;
        if (a == 1) {
            if (imgWidth > imgHeight) {
                r_width = imgWidth / imgHeight;
                r_height = 1;
            } else {
                r_width = 1;
                r_height = imgWidth / imgHeight;
            }
        } else {
            r_width = imgWidth / a;
            r_height = imgHeight / a;
        }
        if ((r_width == 1 && r_height == 1) || ((r_width >= 2 && r_width <= 3) && (r_height >= 1 && r_height <= 4))) {
            if (maxWidth > imgWidth || maxHeight > imgHeight) {
                popup.popAlert("이미지 해상도가 가로 최소 500 세로 최소 250 입니다.\n현재 이미지 해상도\n가로 : " + imgWidth + ", 세로 : " + imgHeight);
                $("#fileName").val('');
                $('.img_viewer').addClass('noImg');
                $('.img_viewer').find('img').remove();
                $("#form")[0].reset();
                return false;
            }else{
                let maxSize = 200 * 1024;
                let fileSize = 0;
                let browser = navigator.appName;
                let sVal = $('.file')[0];
                if (browser == "Microsoft Internet Explorer") {
                    let oas = new ActiveXObject("Scripting.FileSystemObject");
                    fileSize = oas.getFilr(sVal.value.value).size;
                } else {
                    fileSize = sVal.files[0].size;
                }
                if (fileSize > maxSize) {
                    $('.file').val('');
                    popup.popAlert("첨부파일 사이즈는 200KB 이내로 등록 가능 합니다.");
                    $("#form")[0].reset();
                    $("#file").val();
                    $(".img_viewer").children().remove();
                    $(".img_view").addClass('noImg');
                    return false;
                } else {
                    $('#fileName').val(file.name);
                    $('.img_viewer').removeClass('noImg');
                    $('.img_viewer').html('<img src="' + img.src + '"/>');
                    return false;
                }
            }
            $('#fileName').val(file.name);
            $('.img_viewer').removeClass('noImg');
            $('.img_viewer').html('<img src="' + img.src + '"/>');
        } else {
            $('.file').val('');
            popup.popAlert("이미지 오류를 막기위해\n이미지 비율은 1:1 또는 2:1 이상 3:4 이하만 가능 합니다.\n현재 비율 " + r_width + " : " + r_height);
            $("#fileName").val('');
            $('.img_viewer').addClass('noImg');
            $('.img_viewer').find('img').remove();
            $("#form")[0].reset();
        }
    }
}

// 알림톡 이미지 유효성 체크
function atImageUpload(addImage,type) {

    let file = $(addImage)[0].files[0];
    img = new Image();
    let imgWidth = 0;
    let imgHeight = 0;
    let minWidth;
    let minHeight;
    let ratio;

    if(type == 'IMGTP09'){
        minWidth = 500;
        minHeight = 250;
        ratio= "2:1";
    }else {
        minWidth =108;
        minHeight = 108;
        ratio= "1:1";
    }

    img.src = URL.createObjectURL(file);
    img.onload = function () {
        imgWidth = this.width;
        imgHeight = this.height;

        let temp_gcd = gcdlcm(imgWidth, imgHeight);
        let a = temp_gcd[0];
        let r_width = 0;
        let r_height = 0;
        if (a == 1) {
            if (imgWidth > imgHeight) {
                r_width = imgWidth / imgHeight;
                r_height = 1;
            } else {
                r_width = 1;
                r_height = imgWidth / imgHeight;
            }
        } else {
            r_width = imgWidth / a;
            r_height = imgHeight / a;
        }
        if(((r_width == 2 && r_height == 1) && type == 'IMGTP09') ||(r_width == 1 && r_height == 1) && type == 'IMGTP10'){  //알림톡
            if (minWidth > imgWidth || minHeight > imgHeight) {
                popup.popAlert("이미지 해상도가 가로 최소 "+ minWidth +" 세로 최소 "+ minHeight +" 입니다.\n현재 이미지 해상도\n가로 : " + imgWidth + ", 세로 : " + imgHeight);
                $("#fileName").val('');
                $('.img_viewer').addClass('noImg');
                $('.img_viewer').find('img').remove();
                $("#form")[0].reset();
                return false;
            }else{
                let maxSize = 500 * 1024;
                let fileSize = 0;
                let browser = navigator.appName;
                let sVal = $('.file')[0];
                if (browser == "Microsoft Internet Explorer") {
                    let oas = new ActiveXObject("Scripting.FileSystemObject");
                    fileSize = oas.getFilr(sVal.value.value).size;
                } else {
                    fileSize = sVal.files[0].size;
                }
                if (fileSize > maxSize) {
                    $('.file').val('');
                    popup.popAlert("첨부파일 사이즈는 500KB 이내로 등록 가능 합니다.");
                    $("#form")[0].reset();
                    $("#file").val();
                    $(".img_viewer").children().remove();
                    $(".img_view").addClass('noImg');
                    return false;
                } else {
                    $('#fileName').val(file.name);
                    $('.img_viewer').removeClass('noImg');
                    $('.img_viewer').html('<img src="' + img.src + '"/>');
                    return false;
                }
            }

            $('#fileName').val(file.name);
            $('.img_viewer').removeClass('noImg');
            $('.img_viewer').html('<img src="' + img.src + '"/>');
        } else{    //비율이 안맞을 경우
            $('.file').val('');
            popup.popAlert("이미지 비율은 "+ratio+"만 가능 합니다.\n현재 비율 " + r_width + " : " + r_height);
            $("#fileName").val('');
            $('.img_viewer').addClass('noImg');
            $('.img_viewer').find('img').remove();
            $("#form")[0].reset();
        }
    }
}
// 친구톡 이미지 유효성 체크
function ftImageUpload(addImage,type) {

    let file = $(addImage)[0].files[0];
    img = new Image();
    let imgWidth = 0;
    let imgHeight = 0;

    img.src = URL.createObjectURL(file);
    img.onload = function () {
        imgWidth = this.width;
        imgHeight = this.height;


        if(type == 'IMGTP03'){
            let minWidth = 500;
            let ratio = "2:1 또는 3:4";

            let temp_gcd = gcdlcm(imgWidth, imgHeight);
            let a = temp_gcd[0];
            let r_width = 0;
            let r_height = 0;
            if (a == 1) {
                if (imgWidth > imgHeight) {
                    r_width = imgWidth / imgHeight;
                    r_height = 1;
                } else {
                    r_width = 1;
                    r_height = imgWidth / imgHeight;
                }
            } else {
                r_width = imgWidth / a;
                r_height = imgHeight / a;
            }

            if((r_width == 2 && r_height == 1) ||(r_width == 3 && r_height == 4)){
                if (minWidth > imgWidth) {
                    popup.popAlert("이미지 해상도가 가로 최소 "+ minWidth +" 입니다.\n현재 이미지 해상도\n가로 : " + imgWidth + ", 세로 : " + imgHeight);
                    $("#fileName").val('');
                    $('.img_viewer').addClass('noImg');
                    $('.img_viewer').find('img').remove();
                    $("#form")[0].reset();
                    return false;
                }else {
                    let maxSize = 500 * 1024;
                    let fileSize = 0;
                    let browser = navigator.appName;
                    let sVal = $('.file')[0];
                    if (browser == "Microsoft Internet Explorer") {
                        let oas = new ActiveXObject("Scripting.FileSystemObject");
                        fileSize = oas.getFilr(sVal.value.value).size;
                    } else {
                        fileSize = sVal.files[0].size;
                    }
                    if (fileSize > maxSize) {
                        $('.file').val('');
                        popup.popAlert("첨부파일 사이즈는 500KB 이내로 등록 가능 합니다.");
                        $("#form")[0].reset();
                        $("#file").val();
                        $(".img_viewer").children().remove();
                        $(".img_view").addClass('noImg');
                        return false;
                    } else {
                        $('#fileName').val(file.name);
                        $('.img_viewer').removeClass('noImg');
                        $('.img_viewer').html('<img src="' + img.src + '"/>');
                        return false;
                    }
                }
                $('#fileName').val(file.name);
                $('.img_viewer').removeClass('noImg');
                $('.img_viewer').html('<img src="' + img.src + '"/>');
            } else{    //비율이 안맞을 경우
                $('.file').val('');
                popup.popAlert("이미지 비율은 "+ratio+"만 가능 합니다.\n현재 비율 " + r_width + " : " + r_height);
                $("#fileName").val('');
                $('.img_viewer').addClass('noImg');
                $('.img_viewer').find('img').remove();
                $("#form")[0].reset();
            }
        }else {    // 친구톡 와이드 이미지
            const width = 800
            const height =600
            if (width != imgWidth || height != imgHeight) {
                popup.popAlert("이미지 해상도가 가로 "+ width +" 세로 "+height+" 파일만 등록 가능합니다.\n현재 이미지 해상도\n가로 : " + imgWidth + ", 세로 : " + imgHeight);
                $("#fileName").val('');
                $('.img_viewer').addClass('noImg');
                $('.img_viewer').find('img').remove();
                $("#form")[0].reset();
                return false;
            }else {
                let maxSize = 2 * 1024 * 1024;
                let fileSize = 0;
                let browser = navigator.appName;
                let sVal = $('.file')[0];
                if (browser == "Microsoft Internet Explorer") {
                    let oas = new ActiveXObject("Scripting.FileSystemObject");
                    fileSize = oas.getFilr(sVal.value.value).size;
                } else {
                    fileSize = sVal.files[0].size;
                }
                if (fileSize > maxSize) {
                    $('.file').val('');
                    popup.popAlert("첨부파일 사이즈는 2MB 이내로 등록 가능 합니다.");
                    $("#form")[0].reset();
                    $("#file").val();
                    $(".img_viewer").children().remove();
                    $(".img_view").addClass('noImg');
                    return false;
                } else {
                    $('#fileName').val(file.name);
                    $('.img_viewer').removeClass('noImg');
                    $('.img_viewer').html('<img src="' + img.src + '"/>');
                    return false;
                }
            }
            $('#fileName').val(file.name);
            $('.img_viewer').removeClass('noImg');
            $('.img_viewer').html('<img src="' + img.src + '"/>');
        }
    }
}

function gcdlcm(a, b) {
    var answer = [];
    var minNum = Math.min(a, b);
    var maxNum = Math.max(a, b);
    answer[0] = gcd(minNum, maxNum);
    answer[1] = lcm(minNum, maxNum);
    return answer;
}

// 최대공약수
function gcd(minNum, maxNum) {
    return (minNum % maxNum) === 0 ? maxNum : gcd(maxNum, minNum % maxNum);
}
// 최소공배수
function lcm(minNum, maxNum) {
    return minNum * maxNum / gcd(minNum, maxNum);
}

//새 이미지 파일 업로드 팝업 open function
function uploadPopup() {
    $('.uploadPopup').addClass('active');
}

// RCS 가로형 이미지 유효성 체크 function
function horizontal(image){
    let file = $(image)[0].files[0];
    let img = new Image();
    img.src = URL.createObjectURL(file);

    let fileSize = $(image)[0].files[0].size;
    let maxSize = 1 * 1024 * 1024; //1MB
    if(fileSize > maxSize){
        popup.popAlert("RCS 가로형 이미지는 1MB 이하 이미지만 등록이 가능합니다.");
        $("#file").val();
        $(".img_viewer").children().remove();
        $(".img_view").addClass('noImg');
        return false;
    }else{
        $('#fileName').val(file.name);
        $('.img_viewer').removeClass('noImg');
        $('.img_viewer').html('<img src="' + img.src + '"/>');
        return true;
    }
}

// RCS 세로형 Tall 이미지 사이즈 체크 function
function verticalTall(image){
    let file = $(image)[0].files[0];
    let img = new Image();
    img.src = URL.createObjectURL(file);

    let imgWidth = 0;
    let imgHeight = 0;
    let maxWidth = 568;
    let maxHeight = 528;

    let fileSize = $(image)[0].files[0].size;
    let maxSize = 1 * 1024 * 1024; //1MB

    if(fileSize > maxSize){
        popup.popAlert("RCS 세로형 Tall 이미지는 1MB 이하 이미지만 등록이 가능합니다.");
        $("#file").val();
        $(".img_viewer").children().remove();
        $(".img_view").addClass('noImg');
        return false;
    }else{
        img.onload = function(){
            imgWidth = this.width;
            imgHeight = this.height;
            if(imgWidth > maxWidth || imgWidth < maxWidth){
                popup.popAlert("현재 이미지의 가로사이즈는 " + imgWidth + " 입니다." + '<br/>' + "RCS 세로형 Tall 이미지의 가로사이즈는 " + maxWidth + " 이여야 합니다.");
                $("#file").val();
                $(".img_viewer").children().remove();
                $(".img_view").addClass('noImg');
                return false;
            }
            if(maxHeight > imgHeight || maxHeight < imgHeight){
                popup.popAlert("현재 이미지의 세로사이즈는 " + imgHeight + " 입니다." + '<br/>' + "RCS 세로형 Tall 이미지의 세로사이즈는 " + maxHeight + " 이여야 합니다.");
                $("#file").val();
                $(".img_viewer").children().remove();
                $(".img_view").addClass('noImg');
                return false;
            }else{
                $('#fileName').val(file.name);
                $('.img_viewer').removeClass('noImg');
                $('.img_viewer').html('<img src="' + img.src + '"/>');
                return true;
            }
        }
    }
}

// RCS 세로형 Medium 이미지 사이즈 체크 function
function verticalMedium(image){
    let file = $(image)[0].files[0];
    let img = new Image();
    img.src = URL.createObjectURL(file);

    let imgWidth = 0;
    let imgHeight = 0;
    let maxWidth = 568;
    let maxHeight = 336;

    let fileSize = $(image)[0].files[0].size;
    let maxSize = 1 * 1024 * 1024; //1MB

    if(fileSize > maxSize){
        popup.popAlert("RCS 세로형 Medium 이미지는 1MB 이하 이미지만 등록이 가능합니다.");
        $("#file").val();
        $(".img_viewer").children().remove();
        $(".img_view").addClass('noImg');
        return false;
    }else{
        img.onload = function(){
            imgWidth = this.width;
            imgHeight = this.height;
            if(imgWidth != maxWidth){
                popup.popAlert("현재 이미지의 가로사이즈는 " + imgWidth + " 입니다." + '<br/>' + "RCS 세로형 Medium 이미지의 가로사이즈는 " + maxWidth + " 이여야 합니다.");
                $("#file").val();
                $(".img_viewer").children().remove();
                $(".img_view").addClass('noImg');
                return false;
            }
            if(maxHeight != imgHeight){
                popup.popAlert("현재 이미지의 세로사이즈는 " + imgHeight + " 입니다." + '<br/>' + "RCS 세로형 Medium 이미지의 세로사이즈는 " + maxHeight + " 이여야 합니다.");
                $("#file").val();
                $(".img_viewer").children().remove();
                $(".img_view").addClass('noImg');
                return false;
            }else{
                $('#fileName').val(file.name);
                $('.img_viewer').removeClass('noImg');
                $('.img_viewer').html('<img src="' + img.src + '"/>');
                return true;
            }
        }
    }
}

// RCS 슬라이드형 Small 이미지 사이즈 체크 function
function slideSmall(image){
    let file = $(image)[0].files[0];
    let img = new Image();
    img.src = URL.createObjectURL(file);

    let imgWidth = 0;
    let imgHeight = 0;
    let maxWidth = 360;
    let maxHeight = 1569;
    let minHeight = 336;

    let fileSize = $(image)[0].files[0].size;
    let maxSize = 1 * 1024 * 1024; //1MB

    if(fileSize > maxSize){
        popup.popAlert("RCS 슬라이드형 Small 이미지는 1MB 이하 이미지만 등록이 가능합니다.");
        $("#file").val();
        $(".img_viewer").children().remove();
        $(".img_view").addClass('noImg');
        return false;
    }else{
        img.onload = function(){
            imgWidth = this.width;
            imgHeight = this.height;
            if(imgWidth != maxWidth){
                popup.popAlert("현재 이미지의 가로사이즈는 " + imgWidth + " 입니다." + '<br/>' + "RCS 슬라이드형 Small 이미지의 가로사이즈는 " + maxWidth + " 이여야 합니다.");
                $("#file").val();
                $(".img_viewer").children().remove();
                $(".img_view").addClass('noImg');
                return false;
            }
            if(minHeight > imgHeight || maxHeight < imgHeight){
                popup.popAlert("현재 이미지의 세로사이즈는 " + imgHeight + " 입니다." + '<br/>' + "RCS 슬라이드형 Small 이미지의 세로사이즈는 " + minHeight + " ~ " + maxHeight + " 이여야 합니다.");
                $("#file").val();
                $(".img_viewer").children().remove();
                $(".img_view").addClass('noImg');
                return false;
            }else{
                $('#fileName').val(file.name);
                $('.img_viewer').removeClass('noImg');
                $('.img_viewer').html('<img src="' + img.src + '"/>');
                return true;
            }
        }
    }
}

// RCS 슬라이드형 Medium 이미지 사이즈 체크 function
function slideMedium(image){
    let file = $(image)[0].files[0];
    let img = new Image();
    img.src = URL.createObjectURL(file);

    let imgWidth = 0;
    let imgHeight = 0;
    let minWidth = 360;
    let maxWidth = 696;
    let maxHeight = 1569;
    let minHeight = 504;

    let fileSize = $(image)[0].files[0].size;
    let maxSize = 1 * 1024 * 1024; //1MB

    if(fileSize > maxSize){
        popup.popAlert("RCS 슬라이드형 Medium 이미지는 1MB 이하 이미지만 등록이 가능합니다.");
        return false;
    }else{
        img.onload = function(){
            imgWidth = this.width;
            imgHeight = this.height;
            if(imgWidth > maxWidth || imgWidth < minWidth){
                popup.popAlert("현재 이미지의 가로사이즈는 " + imgWidth + " 입니다." + '<br/>' + "RCS 슬라이드형 Medium 이미지의 가로사이즈는 " + minWidth + " ~ " + maxWidth + " 이여야 합니다.");
                return false;
            }
            if(minHeight > imgHeight || maxHeight < imgHeight){
                popup.popAlert("현재 이미지의 세로사이즈는 " + imgHeight + " 입니다." + '<br/>' + "RCS 슬라이드형 Medium 이미지의 세로사이즈는 " + minHeight + " ~ " + maxHeight + " 이여야 합니다.");
                return false;
            }else{
                $('#fileName').val(file.name);
                $('.img_viewer').removeClass('noImg');
                $('.img_viewer').html('<img src="' + img.src + '"/>');
                return true;
            }
        }
    }
}