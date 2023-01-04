define(["postmonger"], function (Postmonger) {
	"use strict";

	let connection = new Postmonger.Session();
	let payload = {};
	let fuelapiRestHost = null;
	let fuel2token = null;
	let token = null;
	let model = null;
	let flag = true;
	let cnt = 0;
	let eventDefinitionKey;
	let eventModel = null;

	$(window).ready(function (){
		_connection = connection;
		// 최초 호출 시 initActivity를 호출하고 payload 전달
		connection.trigger('ready');
		connection.trigger('requestTokens');
		connection.trigger('requestEndpoints');
		connection.trigger('requestInteraction');
		connection.trigger('requestTriggerEventDefinition');
		connection.trigger('requestDataSources');

		// refresh
		connection.trigger('ready');

	/*	dataExtensionId = "cce071c7-4680-ed11-ba43-5cba2c19aa40";
		mappingLst();*/

		/** 에러페이지 리턴이 필요하면
		 setTimeout(function() {
			if(flag) {
				location.href='error.mi';
			}
		}, 1000);
		 */

	});
	connection.on('requestedSchema', function (data) {
		// save schema
		console.log('*** Schema ***', JSON.stringify(data['schema']));
	});

	connection.on("initActivity", function (data) {
		if (data) {
			payload = data;
			flag = false;
		}
		let hasInArguments = Boolean(payload["arguments"] && payload["arguments"].execute && payload["arguments"].execute.inArguments && payload["arguments"].execute.inArguments.length > 0 );
		let inArguments = hasInArguments ? payload["arguments"].execute.inArguments : {};
		$.each(inArguments, function (index, inArgument) {
			$.each(inArgument, function (key, val) {
				if(key === 'seq') {
					mstSeq = val;
				}
			});
		});
	});

	connection.on("requestedTokens", function (tokens){
		//console.log("tokens == " + JSON.stringify(tokens));
		if(tokens) {
			fuel2token = tokens.fuel2token;
			token = tokens.token;
			cnt++;

			if(cnt == 2) {
				// payload에 usr_grp_cd가 없으면 DB에서 조회한다.
				if($('#usr_grp_cd').val() == '' || $('#usr_grp_cd').val() == null) {
					getUser(fuelapiRestHost, fuel2token, tokens.token);
				} else {
					mappingLst();
				}
			}
		}
	});

	connection.on("requestedEndpoints", function(endpoints){
		//console.log("endpoints == " + JSON.stringify(endpoints));
		if(endpoints) {
			fuelapiRestHost = endpoints.fuelapiRestHost;
			cnt++;

			if(cnt == 2) {
				// payload에 usr_grp_cd가 없으면 DB에서 조회한다.
				if($('#usr_grp_cd').val() == '' || $('#usr_grp_cd').val() == null) {
					getUser(fuelapiRestHost, fuel2token, token);
				} else {
					mappingLst();
				}
			}
		}
	});

	//사용자 지정 활동에 의해 호출된 이벤트 에 대한 응답으로 실행됩니다.
	connection.on('requestedTriggerEventDefinition', function (eventDefinitionModel){
		if(eventDefinitionModel){
			eventModel = eventDefinitionModel
			eventDefinitionKey = eventDefinitionModel.eventDefinitionKey;

			dataExtensionId = eventDefinitionModel.dataExtensionId;
			mappingLst();
		}
	});

	connection.on("requestedInteraction", function (interaction){
		model = interaction;
	});

	connection.on('clickedNext', function (){
		connection.trigger('ready');
		$('#previewBtn').trigger('click');
	});

    // 사용자 조회
	function getUser(host, fuel2token, token) {
	    const res = function(response) {
            if (response.status === "true") {
				if(mstSeq) {
					mobileInfo(mstSeq);
				}else{
					$('#usr_grp_cd').val(response.usr_grp_cd);
					$('#cont_grp_cd').val(response.usr_grp_cd);

					if(response.kko.list){
						$("#send_to").val(response.kko.list[0].list_nm + "(" + numberToPhone(response.kko.list[0].list_val) + ")");
						$("#kakao_send_to_num").val(response.kko.list[0].seq);
					}
					if(response.mdm.list){
						$("#sms_send_to").val(response.mdm.list[0].list_nm + "(" + numberToPhone(response.mdm.list[0].list_val) + ")");
						$("#sms_send_to_num").val(response.mdm.list[0].seq);
					}
					if(response.rcs.list){
						$("#send_text_rcs").val(response.rcs.list[0].list_nm + "(" + numberToPhone(response.rcs.list[0].list_val) + ")");
						$("#text_send_num").val(response.rcs.list[0].seq);
					}
					if(response.rcs.list){
						$("#send_text_rcs").val(response.rcs.list[0].list_nm + "(" + numberToPhone(response.rcs.list[0].list_val) + ")");
						$("#text_send_num").val(response.rcs.list[0].seq);
					}
				}
			}else {
                // 조회실패
                alert('사용자 조회에 실패하였습니다.');
				connection.trigger("destroy");
            }
        }
        let param = { host: host, fuel2token: fuel2token, token: token }
        com_ajax.ajax('post', '/sf/'+ usr_cd +'/getUser.ajax', param, res, null, null,true)
	}

	function save() {
        let dataList = [];
		let data = {};
		for(let i=0; i< bindList.length; i++) {
			let temp = bindList[i];
			data[temp] = "{{Event." + eventDefinitionKey + "." + temp + "}}"
		}
		data.seq = mstSeq;
		data.extentionCnt = dataExtensionCnt;
		dataList.push(data);
		payload["arguments"].execute.inArguments = dataList;
		payload["metaData"].isConfigured = true;
		console.log(payload)
		console.log(payload["arguments"].execute)
		setTimeout(() => {console.log("!!")}, 20000);

        connection.trigger("updateActivity", payload);

	}

    // 프리뷰에서 저장 버튼 누르기
    $(document).on('click', '#saveBtn' , function() {
        if(!mstSeq) {
            mobileSave();
        } else {
            let html = '';
            html +=
                '<div class="layer_pop alert active">' +
                '<div class="pop_container popup_size3">' +
                '<input type="button" value="닫기" class="btn_pop_close" onclick="popupClose(this);"/>' +
                '<div class="pop_title"></div>' +
                '<div class="pop_inner">' +
                '<div class="alert_txt">모바일 컨텐츠를 수정 하시겠습니까?</div>' +
                '<div class="btn_row">' +
                '<input type="button" class="btn_bg btn_size2 btn_inline" id="editPreview" value="확인" />' +
                '<input type="button" class="btn_bg2 btn_size2 btn_inline" onclick="popupClose(this);" value="취소" />' +
                '</div>' +
                '</div>' +
                '</div>' +
                '</div>';
            $('body .layer_pop.alert').remove();
            $('body').append(html);
            return false;
        }
    });

    // 프리뷰 저장
    $(document).on('click', '#editPreview', function() {
        mobileEdit();
    });

    // 저장
    function mobileSave() {
        const res = function(response) {
            if(response.status) {
				mstSeq = response.seq
                save();
			} else {
                popup.popAlert("모바일 컨텐츠 저장 도중 오류가 났습니다. \n관리자에게 문의 바랍니다.");
            }
        }
        let data = $("#form").serializeArray();
		data.push({name: 'sales_nm', value: model.name});
		data.push({name: 'inten_id', value: model.definitionId});
		data.push({name: 'orig_id', value: model.id});
		data.push({name: 'inta_key', value: model.key});
		data.push({name: 'inta_ve', value: model.version});

		com_ajax.ajax('post', '/sf/'+ usr_cd +'/mobileInsert.service', data, res, null, null);
    }

    // 수정
    function mobileEdit() {
        const res = function(response) {
            if(response.status) {
                save();
            } else {
                popup.popAlert("모바일 컨텐츠 저장 도중 오류가 났습니다. \n관리자에게 문의 바랍니다.");
            }
        }
		let data = $("#form").serializeArray();
		data.push({name: 'sales_nm', value: model.name});
		data.push({name: 'inten_id', value: model.definitionId});
		data.push({name: 'orig_id', value: model.id});
		data.push({name: 'inta_key', value: model.key});
		data.push({name: 'inta_ve', value: model.version});
		data.find(function(input) {
			return input.name == 'mst_seq';
		}).value = mstSeq

		com_ajax.ajax('post', '/sf/'+ usr_cd +'/mobileUpdate.service', data, res, null, null);
    }

});


let dataExtensionId;
let dataExtensionCnt;

// 개인화 변수 조회
function mappingLst() {
	$('#commonLoading').addClass('active');

	const res = function(e) {
		if(e.check){
			dataExtensionCnt = e.totalCnt;

			const set = new Set();
			$('#kakaoValue').html('');
			$('#smsContsVal').html('');
			$('[name="edmDB"] ul.mappingLst').html('');
			$(e.list).each((idx, colName)=>{
				$('#kakaoValue').append(`<input type="button" data="{{${colName}}}" value="${colName}" class="drag-button" draggable="true">`);
				$('#smsContsVal').append(`<input type="button" data="{{${colName}}}" value="${colName}" class="drag-button" draggable="true">`);
				$('[name="edmDB"] ul.mappingLst').append(`<li data="${colName}">${colName}</li>`);
				set.add(colName);
			});
			const uniqueArr = [...set];
			bindList = uniqueArr;
			$('#commonLoading').removeClass('active');
		}else{
			alert("DataExtention 이 선택되지 않았거나 데이터가 없습니다.\n확인 후 다시 시도하세요");
			if(_connection){
				_connection.trigger('destroy');
			}
		}
	}
	let param = {}
	com_ajax.ajax('get', `/sf/${usr_cd}/getDataExtension.ajax?extentionId=${dataExtensionId}`, param, res, null, null,false)
}