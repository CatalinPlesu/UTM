/*
Template Name: Minton - Responsive Bootstrap 4 Admin Dashboard
Author: CoderThemes
Website: https://coderthemes.com/
Contact: support@coderthemes.com
File: Chartjs Charts
*/

! function ($) {
    "use strict";

    var ChartJs = function () {
        this.$body = $("body"),
            this.charts = []
    };

    ChartJs.prototype.respChart = function (selector, type, data, options) {

        // get selector by context
        var ctx = selector.get(0).getContext("2d");
        // pointing parent container to make chart js inherit its width
        var container = $(selector).parent();

        // this function produce the responsive Chart JS
        function generateChart() {
            // make chart width fit with its container
            var ww = selector.attr('width', $(container).width());
            var chart;
            switch (type) {
                case 'Line':
                    chart = new Chart(ctx, { type: 'line', data: data, options: options });
                    break;
                case 'Doughnut':
                    chart = new Chart(ctx, { type: 'doughnut', data: data, options: options });
                    break;
                case 'Pie':
                    chart = new Chart(ctx, { type: 'pie', data: data, options: options });
                    break;
                case 'Bar':
                    chart = new Chart(ctx, { type: 'bar', data: data, options: options });
                    break;
                case 'Radar':
                    chart = new Chart(ctx, { type: 'radar', data: data, options: options });
                    break;
                case 'PolarArea':
                    chart = new Chart(ctx, { data: data, type: 'polarArea', options: options });
                    break;
            }
            return chart;
        };
        // run function - render chart at first load
        return generateChart();
    },
        // init various charts and returns
        ChartJs.prototype.initCharts = function () {
            var charts = [];
            if ($('#line-chart-example').length > 0) {
                var lineChart = {
                    labels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
                    datasets: [{
                        label: "Current Week",
                        backgroundColor: 'rgba(59, 175, 218, 0.3)',
                        borderColor: '#3bafda',
                        data: [32, 42, 42, 62, 52, 75, 62]
                    }, {
                        label: "Previous Week",
                        fill: true,
                        backgroundColor: 'transparent',
                        borderColor: "#f672a7",
                        borderDash: [5, 5],
                        data: [42, 58, 66, 93, 82, 105, 92]
                    }]
                };

                var lineOpts = {
                    maintainAspectRatio: false,
                    legend: {
                        display: false
                    },
                    tooltips: {
                        intersect: false
                    },
                    hover: {
                        intersect: true
                    },
                    plugins: {
                        filler: {
                            propagate: false
                        }
                    },
                    scales: {
                        xAxes: [{
                            reverse: true,
                            gridLines: {
                                color: "rgba(0,0,0,0.05)"
                            }
                        }],
                        yAxes: [{
                            ticks: {
                                stepSize: 20
                            },
                            display: true,
                            borderDash: [5, 5],
                            gridLines: {
                                color: "rgba(0,0,0,0)",
                                fontColor: '#fff'
                            }
                        }]
                    }
                };
                charts.push(this.respChart($("#line-chart-example"), 'Line', lineChart, lineOpts));
            }

            //barchart
            if ($('#bar-chart-example').length > 0) {
                var barChart = {
                    // labels: ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"],
                    labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
                    datasets: [
                        {
                            label: "Sales Analytics",
                            backgroundColor: "#1abc9c",
                            borderColor: "#1abc9c",
                            hoverBackgroundColor: "#1abc9c",
                            hoverBorderColor: "#1abc9c",
                            data: [65, 59, 80, 81, 56, 89, 40, 32, 65, 59, 80, 81]
                        },
                        {
                            label: "Dollar Rate",
                            backgroundColor: "#e3eaef",
                            borderColor: "#e3eaef",
                            hoverBackgroundColor: "#e3eaef",
                            hoverBorderColor: "#e3eaef",
                            data: [89, 40, 32, 65, 59, 80, 81, 56, 89, 40, 65, 59]
                        }
                    ]
                };
                var barOpts = {
                    maintainAspectRatio: false,
                    legend: {
                        display: false
                    },
                    scales: {
                        yAxes: [{
                            gridLines: {
                                display: false
                            },
                            stacked: false,
                            ticks: {
                                stepSize: 20
                            }
                        }],
                        xAxes: [{
                            barPercentage: 0.7,
                            categoryPercentage: 0.5,
                            stacked: false,
                            gridLines: {
                                color: "rgba(0,0,0,0.01)"
                            }
                        }]
                    }
                };

                charts.push(this.respChart($("#bar-chart-example"), 'Bar', barChart, barOpts));
            }

            if ($('#pie-chart-example').length > 0) {
                //pie chart
                var pieChart = {
                    labels: [
                        "Direct",
                        "Affilliate",
                        "Sponsored",
                        "E-mail"
                    ],
                    datasets: [
                        {
                            data: [300, 135, 48, 154],
                            backgroundColor: [
                                "#3bafda",
                                "#f7b84b",
                                "#1abc9c",
                                "#ebeff2"
                            ],
                            borderColor: "transparent",
                        }
                    ]
                };
                var pieOpts = {
                    maintainAspectRatio: false,
                    legend: {
                        display: false
                    }
                };
                charts.push(this.respChart($("#pie-chart-example"), 'Pie', pieChart, pieOpts));
            }

            if ($('#donut-chart-example').length > 0) {
                //donut chart
                var donutChart = {
                    labels: [
                        "Direct",
                        "Affilliate",
                        "Sponsored"
                    ],
                    datasets: [
                        {
                            data: [128, 78, 48],
                            backgroundColor: [
                                "#3bafda",
                                "#1abc9c",
                                "#ebeff2"
                            ],
                            borderColor: "transparent",
                            borderWidth: "3",
                        }]
                };
                var donutOpts = {
                    maintainAspectRatio: false,
                    cutoutPercentage: 60,
                    legend: {
                        display: false
                    }
                };
                charts.push(this.respChart($("#donut-chart-example"), 'Doughnut', donutChart, donutOpts));
            }

            if ($('#polar-chart-example').length > 0) {
                //Ploar chart
                var polarChart = {
                    labels: [
                        "Direct",
                        "Affilliate",
                        "Sponsored",
                        "E-mail"
                    ],
                    datasets: [
                        {
                            data: [251, 135, 48, 154],
                            backgroundColor: [
                                "#3bafda",
                                "#f7b84b",
                                "#1abc9c",
                                "#ebeff2"
                            ],
                            borderColor: "transparent",
                        }
                    ]
                };
                charts.push(this.respChart($("#polar-chart-example"), 'PolarArea', polarChart));
            }

            if ($('#radar-chart-example').length > 0) {
                //radar chart
                var radarChart = {
                    labels: ["Eating", "Drinking", "Sleeping", "Designing", "Coding", "Cycling", "Running"],
                    datasets: [
                        {
                            label: "Desktops",
                            backgroundColor: "rgba(59, 175, 218,0.2)",
                            borderColor: "#3bafda",
                            pointBackgroundColor: "#3bafda",
                            pointBorderColor: "#fff",
                            pointHoverBackgroundColor: "#fff",
                            pointHoverBorderColor: "#3bafda",
                            data: [65, 59, 90, 81, 56, 55, 40]
                        },
                        {
                            label: "Tablets",
                            backgroundColor: "rgba(246, 114, 167,0.2)",
                            borderColor: "#f672a7",
                            pointBackgroundColor: "#f672a7",
                            pointBorderColor: "#fff",
                            pointHoverBackgroundColor: "#fff",
                            pointHoverBorderColor: "#f672a7",
                            data: [28, 48, 40, 19, 96, 27, 100]
                        }
                    ]
                };
                var radarOpts = {
                    maintainAspectRatio: false
                };
                charts.push(this.respChart($("#radar-chart-example"), 'Radar', radarChart, radarOpts));
            }
            return charts;
        },
        //initializing various components and plugins
        ChartJs.prototype.init = function () {
            var $this = this;
            // font
            Chart.defaults.global.defaultFontFamily = '-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen-Sans,Ubuntu,Cantarell,"Helvetica Neue",sans-serif';

            // init charts
            $this.charts = this.initCharts();

            // enable resizing matter
            $(window).on('resize', function (e) {
                $.each($this.charts, function (index, chart) {
                    try {
                        chart.destroy();
                    }
                    catch (err) {
                    }
                });
                $this.charts = $this.initCharts();
            });
        },

        //init flotchart
        $.ChartJs = new ChartJs, $.ChartJs.Constructor = ChartJs
}(window.jQuery),

//initializing ChartJs
function ($) {
    "use strict";
    $.ChartJs.init()
}(window.jQuery);



// Financial Chart - Demo only
function randomNumber(min, max) {
    return Math.random() * (max - min) + min;
}

function randomBar(date, lastClose) {
    var open = randomNumber(lastClose * 0.95, lastClose * 1.05);
    var close = randomNumber(open * 0.95, open * 1.05);
    return {
        t: date.valueOf(),
        y: close
    };
}

var dateFormat = 'MMMM DD YYYY';
var date = moment('April 01 2017', dateFormat);
var data = [randomBar(date, 30)];
var labels = [date];
while (data.length < 24) {
    date = date.clone().add(1, 'd');
    if (date.isoWeekday() <= 5) {
        data.push(randomBar(date, data[data.length - 1].y));
        labels.push(date);
    }
}

var ctx = document.getElementById('financial-report').getContext('2d');
ctx.canvas.width = 1000;
ctx.canvas.height = 300;
var cfg = {
    type: 'bar',
    data: {
        labels: labels,
        datasets: [{
            label: 'CHRT - Chart.js Corporation',
            data: data,
            type: 'line',
            pointRadius: 0,
            fill: false,
            fill: false,
            borderColor: "#3bafda",
            backgroundColor: "rgba(59, 175, 218,0.2)",
            lineTension: 0,
            borderWidth: 2
        }]
    },
    options: {
        scales: {
            xAxes: [{
                type: 'time',
                distribution: 'series',
                ticks: {
                    source: 'labels'
                }
            }],
            yAxes: [{
                scaleLabel: {
                    display: true,
                    labelString: 'Closing price ($)'
                }
            }]
        }
    }
};
var chart = new Chart(ctx, cfg);

document.getElementById('update').addEventListener('click', function() {
    var type = document.getElementById('type').value;
    chart.config.data.datasets[0].type = type;
    chart.update();
});
