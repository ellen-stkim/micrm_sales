/* =========================
drawChart
========================= */
function drawChart(targetDiv, chartType, inputData, column, options) {
    var parentDiv = $('#' + targetDiv).parent();
    parentDiv.children('iframe').remove();
    parentDiv.children('canvas').remove();

    var canvas = document.createElement('canvas');
    canvas.id = targetDiv;
    parentDiv.append(canvas);

    var ctx = document.getElementById(targetDiv).getContext('2d');

    var indexAxis = 'x';

    switch (chartType) {
        case '00': chartType = 'bar'; break;
        case '01':
            chartType = 'bar';
            indexAxis = 'y';
            break;
        case '02': chartType = 'doughnut'; break;
        case '03': chartType = 'line'; break;
    }

    var defaultOptions = {
        responsive: true,
        indexAxis: indexAxis,
        plugins: {
            legend: {
                display: false
            },
            tooltip: {
                enabled: true
            }
        },
        datasets: {
            bar: {
                grouped: true,
                barPercentage: 0.8,
                categoryPercentage: 0.8
            }
        },
        scales: {
            x: {
                display: true,
                grid: { display: false },
                ticks: { display: false }
            },
            y: {
                display: true,
                grid: { display: false },
                ticks: { display: false }
            }
        }
    };

    var finalOptions = $.extend(true, {}, defaultOptions, options || {});

    new Chart(ctx, {
        type: chartType,
        data: {
            labels: column,
            datasets: inputData
        },
        options: finalOptions
    });
}


/* =========================
colorPicker
========================= */
function colorPicker(length, baseColor, min, max) {
    var r = baseColor[0] < 0 ? 0 : baseColor[0] >= 255 ? 255 : baseColor[0];
    var g = baseColor[1] < 0 ? 0 : baseColor[1] >= 255 ? 255 : baseColor[1];
    var b = baseColor[2] < 0 ? 0 : baseColor[2] >= 255 ? 255 : baseColor[2];

    var color = [];

    for (var i = 0; i < length; i++) {
        var rr = Math.min(255, r + parseInt(Math.random() * (max - min) + min));
        var gg = Math.min(255, g + parseInt(Math.random() * (max - min) + min));
        var bb = Math.min(255, b + parseInt(Math.random() * (max - min) + min));

        color.push('rgb(' + rr + ', ' + gg + ', ' + bb + ')');
    }
    return color;
}


/* =========================
drawComboChart
========================= */
function drawComboChart(targetDiv, chartData) {
    var parentDiv = $('#' + targetDiv).parent();
    parentDiv.children('iframe').remove();
    parentDiv.children('canvas').remove();

    var canvas = document.createElement('canvas');
    canvas.id = targetDiv;
    parentDiv.append(canvas);

    var ctx = document.getElementById(targetDiv).getContext("2d");

    new Chart(ctx, {
        type: 'bar',
        data: chartData,
        options: {
            responsive: true,
            plugins: {
                legend: {
                    display: false
                }
            },
            datasets: {
                bar: {
                    grouped: true
                }
            },
            scales: {
                y: {
                    type: 'linear',
                    position: 'left',
                    display: true,
                    grid: { display: false },
                    ticks: { display: false },
                    stacked: false
                },
                y1: {
                    type: 'linear',
                    position: 'right',
                    display: true,
                    grid: {
                        drawOnChartArea: false
                    },
                    ticks: {
                        display: false
                    },
                    stacked: false
                }
            }
        }
    });
}


/* =========================
랜덤값
========================= */
window.randomScalingFactor = function () {
    return Math.round(Math.random() * 100);
};