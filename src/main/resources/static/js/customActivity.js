define(["postmonger"], function (Postmonger) {
	"use strict";

	let connection = new Postmonger.Session();
	
	let payload = {};
	let fuelapiRestHost = null;
	let fuel2token = null;
	let eventDefinitionKey = null;
	let flag = true;
	let cnt = 0;

	$(window).ready(onRender);

	connection.on("initActivity", initialize);
	connection.on("requestedTokens", onGetTokens);
	connection.on("requestedEndpoints", onGetEndpoints);
	connection.on('requestedTriggerEventDefinition', onRequestedTriggerEventDefinition);
	
	connection.on('clickedNext', save);

	function onRender() {
		// 최초 호출 시 initActivity를 호출하고 payload 전달
		connection.trigger('ready');

		connection.trigger('requestTokens');
		connection.trigger('requestEndpoints');
		
		connection.trigger('requestInteraction');
		connection.trigger('requestTriggerEventDefinition');
		connection.trigger('requestDataSources');
		
		// refresh
		connection.trigger('ready');

		/**
		setTimeout(function() {
			if(flag) {
				location.href='error';
			}
		}, 1000);
		*/
	}

	 function onRequestedTriggerEventDefinition(eventDefinitionModel) {
		//console.log('eventDefinitionModel == ' + JSON.stringify(eventDefinitionModel));
		
		eventDefinitionKey = eventDefinitionModel.eventDefinitionKey;
	}

	function initialize(data) {
		if (data) {
			payload = data;
			//document.getElementById('configuration').value = JSON.stringify(data, null, 2);
			flag = false;
		}
		
		var hasInArguments = Boolean(
			payload["arguments"] &&
				payload["arguments"].execute &&
				payload["arguments"].execute.inArguments &&
				payload["arguments"].execute.inArguments.length > 0
		);

		var inArguments = hasInArguments ? payload["arguments"].execute.inArguments : {};

		$.each(inArguments, function (index, inArgument) {
			$.each(inArgument, function (key, val) {
				if(key === 'usr_grp_cd') {
				    $('#usr_grp_cd').val(val);
				    $('#cont_grp_cd').val(val);
				} else if(key === 'host') {
				    fuelapiRestHost = val;
				} else if(key === 'token') {
				    fuel2token = val;
				}
			});
		});
	}

    // 사용자 조회
	function getUser(host, token) {
	    const res = function(response) {
            if (response.status == "true") {
                $('#usr_grp_cd').val(response.usr_grp_cd);
                $('#cont_grp_cd').val(response.usr_grp_cd);
                mappingLst();
            } else {
                // 조회실패
                alert('사용자 조회에 실패하였습니다.');
            }
        }
        let param = {host: host, token: token}
        com_ajax.ajax('post', '/sf/getUser.ajax', param, res, null, null)
	}

	//

	function onGetTokens(tokens) {
		//console.log("tokens == " + JSON.stringify(tokens));
		
		if(tokens) {
			fuel2token = tokens.fuel2token;
			cnt++;

			if(cnt == 2) {
                // payload에 usr_grp_cd가 없으면 DB에서 조회한다.
                if($('#usr_grp_cd').val() == '' || $('#usr_grp_cd').val() == null) {
                    getUser(fuelapiRestHost, fuel2token);
                } else {
                    mappingLst();
                }
			}
		}
	}

	function onGetEndpoints(endpoints) {
		//console.log("endpoints == " + JSON.stringify(endpoints));
		
		if(endpoints) {
			fuelapiRestHost = endpoints.fuelapiRestHost;
			cnt++;

			if(cnt == 2) {
                // payload에 usr_grp_cd가 없으면 DB에서 조회한다.
                if($('#usr_grp_cd').val() == '' || $('#usr_grp_cd').val() == null) {
                    getUser(fuelapiRestHost, fuel2token);
                } else {
                    mappingLst();
                }
			}
		}
	}

	// 개인화 변수 조회
	function mappingLst() {
	    const res = function(response) {
	        let list = response.mappingLst;
	        let html = '';

	        for(let i=0; i<list.length; i++) {
	            let item = list[i];
                html += '<li data="' + item.list_val + '">' + item.list_nm + '!</li>';
	        }
	        $('.mappingLst').html(html);
        }
        let param = {usr_grp_cd: $('#usr_grp_cd').val()}
        com_ajax.ajax('post', '/sf/mappingLst.ajax', param, res, null, null)
	}
	
	function save() {
		if($('#kakao_recv').val() == '' || $('#kakao_recv').val() == null) {
			alert('수신 번호를 선택해 주세요.');
			connection.trigger('ready');
		} else {
		    // 저장과 동일한 구성


			payload["arguments"].execute.inArguments = [{
				phone: "{{Event." + eventDefinitionKey + "." + $('#kakao_recv').val() + "}}",

			}];
	
			payload["metaData"].isConfigured = true;
	
			connection.trigger("updateActivity", payload);
		}		
	}
});