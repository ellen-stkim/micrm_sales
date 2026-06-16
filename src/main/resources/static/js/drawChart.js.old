// draws it.
function drawChart(targetDiv, chartType, inputData, column, options) {
	var parentDiv = $('#' + targetDiv).parent();
	parentDiv.children('iframe').remove();
	parentDiv.children('canvas').remove();
	parentDiv.append(document.createElement('canvas'));
	parentDiv.children('canvas').attr('id', targetDiv);
	var ctx = document.getElementById(targetDiv).getContext('2d');
	switch (chartType) {
		case '00' : chartType = 'bar'; break;
		case '01' : chartType = 'horizontalBar'; break;
		case '02' : chartType = 'doughnut'; break;
		case '03' : chartType = 'line'; break;

	}
	/* default Options*/
	var defaultOptions = {
			events: ['click', 'mousemove'],
			tooltips: {
				enable: true
			},
			respnsive: true,
			legend: {
				display: true,
				position: 'top',
				labels: {
					fontSize: 12,
					fontFamily: 'NanumBarunGothic',
				}
			},
			scales: {
				yAxes: [{
					fontColor: '#ff6a6a',
					gridLines: {
						display: false,
						drawBorder: false
					},
					ticks: {
						display: false
					}
				}],
				xAxes: [{
					type: 'linear',
					fontColor: '#ff6a6a',
					gridLines: {
						display: false,
						drawBorder: false
					},
					ticks: {
						display: false
					}
				}]
			},
			drawBorder: true,
	}
	var finalOptions = $.extend({}, defaultOptions, options);
	var chart = new Chart(ctx,{
		type: chartType,
		data: {
			labels: column,
			datasets: inputData
		},
		options: finalOptions
	})
}
//랜덤 색상 구현을 위한 기능
function colorPicker(length, baseColor, min, max){
	/* 입력변수
	 * length (Integer) : 색상값이 필요한 갯수
	 * baseColor (array) : 기본 색상값의 rgb값, [integer, integer, integer]
	 * min (Integer) : 랜덤 색상을 적용할 최소값 범위
	 * max (Integer) : 랜덤 색상을 적용할 최대값 범위
	 * */
	var r = baseColor[0] < 0 ? 0 : baseColor[0] >= 255 ? 255 : baseColor[0];
	var g = baseColor[1] < 0 ? 0 : baseColor[1] >= 255 ? 255 : baseColor[1];
	var b = baseColor[2] < 0 ? 0 : baseColor[2] >= 255 ? 255 : baseColor[2];
	max = max < 0 ? 0 : max >= 255 ? 255 : max;
	min = min < 0 ? 0 : min >= 255 ? 255 : min;
	if (max < min){
		var alter = min;
		min = max;
		max = alter;
	} else if (max == min){
		if (max > 250){
			min = 240;
		} else {
			max = max + 5;
		}
	}
	var color = [];
	for (i = 0; i < length; i++){
		rr = (r + parseInt(Math.random() * (max - min) + min));
		gg = (g + parseInt(Math.random() * (max - min) + min));
		bb = (b + parseInt(Math.random() * (max - min) + min));
		if (rr >= 255){rr = 255}
		if (gg >= 255){gg = 255}
		if (bb >= 255){bb = 255}
		color.push('rgb(' + rr + ', ' + gg + ', ' + bb + ')');
	}
	return color;
}

function drawComboChart(targetDiv, chartData) {
	var parentDiv = $('#' + targetDiv).parent();
	parentDiv.children('iframe').remove();
	parentDiv.children('canvas').remove();
	parentDiv.append(document.createElement('canvas'));
	parentDiv.children('canvas').attr('id', targetDiv);
	var ctx = document.getElementById(targetDiv).getContext("2d");
    window.myMixedChart = new Chart(ctx, {
         type: 'bar',
         data: chartData,
         options: {
             responsive: true,
             title: {display: false},
             legend: {
 				display: true,
 				position: 'left',
 				labels: {
 					fontSize: 12,
 					fontFamily: 'NanumBarunGothic',
 				}
 			},
 			scales: {
                yAxes: [{
                    type: "linear", // only linear but allow scale type registration. This allows extensions to exist solely for log scale for instance
                    display: true,
                    position: "left",
                    id: "y-axis-1",
                }, {
                    type: "linear", // only linear but allow scale type registration. This allows extensions to exist solely for log scale for instance
                    display: true,
                    position: "right",
                    id: "y-axis-2",
                    labelString: "(%)",
                    // grid line settings
                    gridLines: {
                        drawOnChartArea: false, // only want the grid lines for one axis to show up
                    },
                    ticks: {
                    	min: 0
                    }
                }],
            }
         }
     });
}
function drawHorizChart(targetDiv, chartData) {
	var parentDiv = $('#' + targetDiv).parent();
	parentDiv.children('iframe').remove();
	parentDiv.children('canvas').remove();
	parentDiv.append(document.createElement('canvas'));
	parentDiv.children('canvas').attr('id', targetDiv);
	var ctx = document.getElementById(targetDiv).getContext("2d");
	var barOptions_stacked = {
		tooltips: {
			enabled: false
		},
		hover :{
			animationDuration:0
		},
		scales: {
			xAxes: [{
				ticks: {
					beginAtZero:true,
					fontFamily: "'Open Sans Bold', sans-serif",
					fontSize:11
				},
				scaleLabel:{
					display:false
				},
				gridLines: {
					display:false
				},
				stacked: false
			}],
			yAxes: [{
				gridLines: {
					display:false,
					color: "#fff",
					zeroLineColor: "#fff",
					zeroLineWidth: 0
				},
				ticks: {
					fontFamily: "'Open Sans Bold', sans-serif",
					fontSize:11
				},
				stacked: true
			}],
		},
		legend:{
			display:false
		},

		animation: {
			onComplete: function () {
				var chartInstance = this.chart;
				var ctx = chartInstance.ctx;
				ctx.textAlign = "left";
				ctx.font = "9px Open Sans";
				ctx.fillStyle = "#fff";

				Chart.helpers.each(this.data.datasets.forEach(function (dataset, i) {
					var meta = chartInstance.controller.getDatasetMeta(i);
					Chart.helpers.each(meta.data.forEach(function (bar, index) {
						data = dataset.data[index];
						if(i==0){
							ctx.fillText(data, 70, bar._model.y+4);
						} else {
							ctx.fillText(data, bar._model.x-25, bar._model.y+4);
						}
					}),this)
				}),this);
			}
		},
		pointLabelFontFamily : "Quadon Extra Bold",
		scaleFontFamily : "Quadon Extra Bold",
	};

	var myChart = new Chart(ctx, {
		type: 'horizontalBar',
		data: chartData,
		options: barOptions_stacked,
	});
}
window.randomScalingFactor = function() {
	return (Math.round(Math.random() * 100));
};