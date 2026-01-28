/*
Template Name: Minton - Responsive Bootstrap 4 Admin Dashboard
Author: CoderThemes
Website: https://coderthemes.com/
Contact: support@coderthemes.com
File: Form Pickers
*/

!function ($) {
    "use strict";

    var FormPickers = function () { };

    FormPickers.prototype.init = function () {

        // Color Picker
        
        $('#basic-colorpicker').colorpicker();

        $('#hex-colorpicker').colorpicker({
            format: 'auto'
        });

        $('#component-colorpicker').colorpicker({
            format: null
        });

        $('#horizontal-colorpicker').colorpicker({
            horizontal: true
        });


        //Clock Picker
        $('.clockpicker').clockpicker({
            donetext: 'Done'
        });
        
        $('#single-input').clockpicker({
            placement: 'bottom',
            align: 'left',
            autoclose: true,
            'default': 'now'
        });
        $('#check-minutes').click(function(e){
            // Have to stop propagation here
            e.stopPropagation();
            $("#single-input").clockpicker('show')
                    .clockpicker('toggleView', 'minutes');
        });

        //Date range picker
$('.input-daterange-datepicker').daterangepicker({
    buttonClasses: ['btn', 'btn-sm'],
    applyClass: 'btn-secondary',
    cancelClass: 'btn-primary'
});
$('.input-daterange-timepicker').daterangepicker({
    timePicker: true,
    format: 'MM/DD/YYYY h:mm A',
    timePickerIncrement: 30,
    timePicker12Hour: true,
    timePickerSeconds: false,
    buttonClasses: ['btn', 'btn-sm'],
    applyClass: 'btn-secondary',
    cancelClass: 'btn-primary'
});
$('.input-limit-datepicker').daterangepicker({
    format: 'MM/DD/YYYY',
    minDate: '06/01/2016',
    maxDate: '06/30/2016',
    buttonClasses: ['btn', 'btn-sm'],
    applyClass: 'btn-secondary',
    cancelClass: 'btn-primary',
    dateLimit: {
        days: 6
    }
});

$('#reportrange span').html(moment().subtract(29, 'days').format('MMMM D, YYYY') + ' - ' + moment().format('MMMM D, YYYY'));

$('#reportrange').daterangepicker({
    format: 'MM/DD/YYYY',
    startDate: moment().subtract(29, 'days'),
    endDate: moment(),
    minDate: '01/01/2016',
    maxDate: '12/31/2016',
    dateLimit: {
        days: 60
    },
    showDropdowns: true,
    showWeekNumbers: true,
    timePicker: false,
    timePickerIncrement: 1,
    timePicker12Hour: true,
    ranges: {
        'Today': [moment(), moment()],
        'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
        'Last 7 Days': [moment().subtract(6, 'days'), moment()],
        'Last 30 Days': [moment().subtract(29, 'days'), moment()],
        'This Month': [moment().startOf('month'), moment().endOf('month')],
        'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
    },
    opens: 'left',
    drops: 'down',
    buttonClasses: ['btn', 'btn-sm'],
    applyClass: 'btn-success',
    cancelClass: 'btn-secondary',
    separator: ' to ',
    locale: {
        applyLabel: 'Submit',
        cancelLabel: 'Cancel',
        fromLabel: 'From',
        toLabel: 'To',
        customRangeLabel: 'Custom',
        daysOfWeek: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
        monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
        firstDay: 1
    }
}, function (start, end, label) {
    console.log(start.toISOString(), end.toISOString(), label);
    $('#reportrange span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
});


        
    },
        $.FormPickers = new FormPickers, $.FormPickers.Constructor = FormPickers

}(window.jQuery),

    //initializing 
    function ($) {
        "use strict";
        $.FormPickers.init()
    }(window.jQuery);


