window.addEventListener("DOMContentLoaded", () => {
    const mcWarp = document.querySelector(".wrap.mcdonald");

    const days = document.querySelectorAll(".input_field.period .part.full .days li");
    days.forEach((item) => {
        item.addEventListener("click", () => {
            item.classList.toggle("active");
        });
    });
});

//제이쿼리 UI
$(function() {
    $(".period .datepicker").datepicker({
        dateFormat: "yy-mm-dd", //표기 방식
        monthNames:['01','02','03','04','05','06','07','08','09','10','11','12'],
        yearSuffix: "&nbsp;.",
        showMonthAfterYear:true, //년도 먼저 표기
        beforeShow: function(input, inst) {
            inst.dpDiv.css({
                marginLeft:-1 +"px"
            })
        },
    });
    //버튼을 눌려도 제이쿼리 UI datepicker 실행
    $(".period .btn.calendar").click(function() {
        $(this).prev().trigger("focus");
    });
    $(".period .timepicker").timepicker();
    $(".period .btn.time").click(function() {
        $(this).prev().trigger("focus");
    });
});

//쿠폰 미리 보기 
const viewCoupon = (el) => {
    const modals = document.querySelectorAll(".coupon_detail .modal.coupon");
    const modal = el.nextElementSibling;
    if (modal.classList.contains("open")) {
        modal.classList.remove("open");
    } else {
        modals.forEach((item) => {
            item.classList.remove("open");
        });
        modal.classList.add("open");
    }
};

//쿠폰 등록 이미지 추가
const loadImage = (el) => {
    const reader = new FileReader();
    reader.readAsDataURL(el.files[0]);
    const fileName = el.files[0].name.split(".");
    const fileTag = el.closest(".components.file");
    const valueWrap = fileTag.querySelector(".value");
    const fileNameTag = valueWrap.querySelector("span");
    const previewImage = document.querySelector(".form_field .right .preview .image");
    valueWrap.classList.add("add");
    fileNameTag.innerText = fileName[0];
    reader.addEventListener("load", (e) => {
        var noimage = document.querySelector(".form_field .right .preview .image .noimage");
        if (noimage != null) {
            noimage.remove();
        }
        var previewImg = document.querySelector(".form_field .right .preview .image .previewImg");
        if (previewImg != null) {
            previewImg.remove();
        }
        const imageTag = document.createElement("img");
        imageTag.setAttribute("src", e.target.result);
        imageTag.classList.add("previewImg");
        previewImage.appendChild(imageTag);
    });
}

//쿠폰 등록 이미지 제거
const delImage = (el) => {
    const valueWrap = el.closest(".value");
    const fileName = valueWrap.querySelector("span");
    const previewImage = document.querySelector(".form_field .right .preview .image img");
    previewImage.remove();
    valueWrap.classList.remove("add");
    fileName.innerText = "이미지를 등록해주세요.";
}
//쿠폰 발급 시 발행 대상자 추가
const addAudience = (el) => {
    const inputValue = el.closest(".inner").querySelector("input");
    if(inputValue.value === "") {
        return false;
    }
    const list = el.closest(".inner").nextElementSibling.querySelector(".add_list");
    const listItem = document.createElement("li");
    const valueText = document.createElement("p");
    const btnDel = document.createElement("button");
    valueText.innerText = inputValue.value;
    btnDel.setAttribute("type", "button");
    btnDel.setAttribute("onclick", "deleteReceivePhoneNumber(this,'"+inputValue.value+"')");
    btnDel.classList.add("btn");
    btnDel.classList.add("del");
    listItem.setAttribute("id", inputValue.value);
    listItem.appendChild(valueText);
    listItem.appendChild(btnDel);
    list.appendChild(listItem);
    inputValue.value = "";
}
//쿠폰 발급 발행 대상자 삭제
const delAudience = (el) => {
    const listItem = el.closest("li");
    listItem.remove();
}
//쿠폰 발급 발행 대상자 파일 등록
const fileUpload = (el) => {
    const filesList = el.files;
    const valueInput = el.closest(".file.label").nextElementSibling;
    const count = el.closest(".inner").nextElementSibling;
    const currentValue = count.querySelector(".current");
    //파일 다중 선택일 경우
    if(el.files.length > 1) {
        for(let i = 0; i < el.files.length; i++) {
            if(i === 0) {
                valueInput.value += el.files[i].name;
            } else {
                valueInput.value +=", " + el.files[i].name;
            }
        }
    } else if(el.files.lenght == 1) {
        valueInput.value = el.files[0].name;
    }
    currentValue.innerText = el.files.length;
}

//숫자만 입력
const chkNumber =  (input) => {
    if(input.key >= 0 && input.key <= 9) {
        return true;
    }
    return false;
}
