/*
Template Name: Minton - Responsive Bootstrap 4 Admin Dashboard
Author: CoderThemes
Website: https://coderthemes.com/
Contact: support@coderthemes.com
File: C3 Charts
*/

!function($) {
    "use strict";

    var ChartC3 = function() {};

    ChartC3.prototype.init = function () {
        //generating chart 
        c3.generate({
            bindto: '#chart',
            data: {
                columns: [
                    ['Desktops', 30, 20, 50, 40, 60, 50],
                    ['Tablets', 200, 130, 90, 240, 130, 220],
                    ['Mobiles', 300, 200, 160, 400, 250, 250]
                ],
                type: 'bar',
                colors: {
                    Desktops: '#e3eaef',
                    Tablets: '#1abc9c',
                    Mobiles: '#3bafda'
                }
                
            }
        });

        //combined chart
        c3.generate({
            bindto: '#combine-chart',
            data: {
                columns: [
                    ['Desktops', 30, 20, 50, 40, 60, 50],
                    ['Tablets', 200, 130, 90, 240, 130, 220],
                    ['Mobiles', 300, 200, 160, 400, 250, 250],
                    ['Watch', 200, 130, 90, 240, 130, 220],
                    ['iPad', 130, 120, 150, 140, 160, 150]
                ],
                types: {
                    Desktops: 'bar',
                    Tablets: 'bar',
                    Mobiles: 'spline',
                    Watch: 'line',
                    iPad: 'bar'
                },
                colors: {
                    Desktops: '#e3eaef',
                    Tablets: '#3bafda',
                    Mobiles: '#323a46',
                    Watch: '#f672a7',
                    iPad: '#1abc9c'
                },
                groups: [
                    ['Desktops','Tablets']
                ]
            },
            axis: {
                x: {
                    type: 'categorized'
                }
            }
        });
        
        //roated chart
        c3.generate({
            bindto: '#roated-chart',
            data: {
                columns: [
                ['Desktops', 30, 200, 100, 400, 150, 250],
                ['Tablets', 50, 20, 10, 40, 15, 25]
                ],
                types: {
                Desktops: 'bar'
                },
                colors: {
	                Desktops: '#3bafda',
	                Tablets: '#f1556c'
	            },
            },
            axis: {
                rotated: true,
                x: {
                type: 'categorized'
                }
            }
        });

        //stacked chart
        c3.generate({
            bindto: '#chart-stacked',
            data: {
                columns: [
                    ['Desktops', 30, 20, 50, 40, 60, 50],
                    ['Tablets', 200, 130, 90, 240, 130, 220]
                ],
                types: {
                    Desktops: 'area-spline',
                    Tablets: 'area-spline'
                    // 'line', 'spline', 'step', 'area', 'area-step' are also available to stack
                },
                colors: {
                    Desktops: '#3bafda',
                    Tablets: '#e3eaef',
                }
            }
        });
        
        //Donut Chart
        c3.generate({
             bindto: '#donut-chart',
            data: {
                columns: [
                    ['Desktops', 46],
                    ['Tablets', 24],
                    ['Mobiles', 30]
                ],
                type : 'donut'
            },
            donut: {
                title: "Sales Analytics",
                width: 15,
				label: { 
					show:false
				}
            },
            color: {
            	pattern: ["#e3eaef", "#3bafda", "#1abc9c"]
            }
        });
        
        //Pie Chart
        c3.generate({
             bindto: '#pie-chart',
            data: {
                columns: [
                    ['iPhone', 46],
                    ['MI', 24],
                    ['Samsung', 30]
                ],
                type : 'pie'
            },
            color: {
            	pattern: [ "#3bafda", "#e3eaef", "#1abc9c"]
            },
            pie: {
		        label: {
		          show: false
		        }
		    }
        });
        
        //Line regions
        c3.generate({
             bindto: '#line-regions',
            data: {
                columns: [
		            ['Desktops', 30, 200, 100, 400, 150, 250],
		            ['Tablets', 50, 20, 10, 40, 15, 25]
		        ],
		        regions: {
		            'Desktops': [{'start':1, 'end':2, 'style':'dashed'},{'start':3}], // currently 'dashed' style only
		            'Tablets': [{'end':3}]
		        },
		        colors: {
	                Desktops: '#3bafda',
	                Tablets: '#1abc9c'
	            },
            },
            
        });
        
        
        //Scatter Plot
        c3.generate({
             bindto: '#scatter-plot',
             data: {
		        xs: {
		            Setosa: 'setosa_x',
		            Versicolor: 'versicolor_x',
		        },
		        // iris data from R
		        columns: [
		            ["setosa_x", 3.5, 3.0, 3.2, 3.1, 3.6, 3.9, 3.4, 3.4, 2.9, 3.1, 3.7, 3.4, 3.0, 3.0, 4.0, 4.4, 3.9, 3.5, 3.8, 3.8, 3.4, 3.7, 3.6, 3.3, 3.4, 3.0, 3.4, 3.5, 3.4, 3.2, 3.1, 3.4, 4.1, 4.2, 3.1, 3.2, 3.5, 3.6, 3.0, 3.4, 3.5, 2.3, 3.2, 3.5, 3.8, 3.0, 3.8, 3.2, 3.7, 3.3],
		            ["versicolor_x", 3.2, 3.2, 3.1, 2.3, 2.8, 2.8, 3.3, 2.4, 2.9, 2.7, 2.0, 3.0, 2.2, 2.9, 2.9, 3.1, 3.0, 2.7, 2.2, 2.5, 3.2, 2.8, 2.5, 2.8, 2.9, 3.0, 2.8, 3.0, 2.9, 2.6, 2.4, 2.4, 2.7, 2.7, 3.0, 3.4, 3.1, 2.3, 3.0, 2.5, 2.6, 3.0, 2.6, 2.3, 2.7, 3.0, 2.9, 2.9, 2.5, 2.8],
		            ["Setosa", 0.2, 0.2, 0.2, 0.2, 0.2, 0.4, 0.3, 0.2, 0.2, 0.1, 0.2, 0.2, 0.1, 0.1, 0.2, 0.4, 0.4, 0.3, 0.3, 0.3, 0.2, 0.4, 0.2, 0.5, 0.2, 0.2, 0.4, 0.2, 0.2, 0.2, 0.2, 0.4, 0.1, 0.2, 0.2, 0.2, 0.2, 0.1, 0.2, 0.2, 0.3, 0.3, 0.2, 0.6, 0.4, 0.3, 0.2, 0.2, 0.2, 0.2],
		            ["Versicolor", 1.4, 1.5, 1.5, 1.3, 1.5, 1.3, 1.6, 1.0, 1.3, 1.4, 1.0, 1.5, 1.0, 1.4, 1.3, 1.4, 1.5, 1.0, 1.5, 1.1, 1.8, 1.3, 1.5, 1.2, 1.3, 1.4, 1.4, 1.7, 1.5, 1.0, 1.1, 1.0, 1.2, 1.6, 1.5, 1.6, 1.5, 1.3, 1.3, 1.3, 1.2, 1.4, 1.2, 1.0, 1.3, 1.2, 1.3, 1.3, 1.1, 1.3],
		        ],
		        
		        type: 'scatter'
		    },
		    color: {
            	pattern: [ "#3bafda", "#1abc9c"]
            },
		    axis: {
		        x: {
		            label: 'Sepal.Width',
		            tick: {
		                fit: false
		            }
		            
		        },
		        y: {
		            label: 'Petal.Width'
		        }
		    }
            
        });

    },
    $.ChartC3 = new ChartC3, $.ChartC3.Constructor = ChartC3

}(window.jQuery),

//initializing 
function($) {
    "use strict";
    $.ChartC3.init()
}(window.jQuery);


