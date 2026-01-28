/*
Template Name: Minton - Responsive Bootstrap 4 Admin Dashboard
Author: CoderThemes
Website: https://coderthemes.com/
Contact: support@coderthemes.com
File: Form Advanced
*/

$(document).ready(function () {

    //advance multiselect start
    $('#my_multi_select3').multiSelect({
        selectableHeader: "<input type='text' class='form-control search-input' autocomplete='off' placeholder='search...'>",
        selectionHeader: "<input type='text' class='form-control search-input' autocomplete='off' placeholder='search...'>",
        afterInit: function (ms) {
            var that = this,
                $selectableSearch = that.$selectableUl.prev(),
                $selectionSearch = that.$selectionUl.prev(),
                selectableSearchString = '#' + that.$container.attr('id') + ' .ms-elem-selectable:not(.ms-selected)',
                selectionSearchString = '#' + that.$container.attr('id') + ' .ms-elem-selection.ms-selected';

            that.qs1 = $selectableSearch.quicksearch(selectableSearchString)
                .on('keydown', function (e) {
                    if (e.which === 40) {
                        that.$selectableUl.focus();
                        return false;
                    }
                });

            that.qs2 = $selectionSearch.quicksearch(selectionSearchString)
                .on('keydown', function (e) {
                    if (e.which == 40) {
                        that.$selectionUl.focus();
                        return false;
                    }
                });
        },
        afterSelect: function () {
            this.qs1.cache();
            this.qs2.cache();
        },
        afterDeselect: function () {
            this.qs1.cache();
            this.qs2.cache();
        }
    });

    // Select2
    $(".select2").select2();

    $(".select2-limiting").select2({
        maximumSelectionLength: 2
    });

});

// switchery

$('[data-plugin="switchery"]').each(function (idx, obj) {
    new Switchery($(this)[0], $(this).data());
});

// MultiSelect

$('[data-plugin="multiselect"]').multiSelect($(this).data());

//Bootstrap-TouchSpin
$(".vertical-spin").TouchSpin({
    verticalbuttons: true,
    buttondown_class: "btn btn-primary",
    buttonup_class: "btn btn-primary",
    verticalupclass: 'ion-plus-round',
    verticaldownclass: 'ion-minus-round'
});
var vspinTrue = $(".vertical-spin").TouchSpin({
    verticalbuttons: true
});
if (vspinTrue) {
    $('.vertical-spin').prev('.bootstrap-touchspin-prefix').remove();
}

$("input[name='demo1']").TouchSpin({
    min: 0,
    max: 100,
    step: 0.1,
    decimals: 2,
    boostat: 5,
    maxboostedstep: 10,
    buttondown_class: "btn btn-primary",
    buttonup_class: "btn btn-primary",
    postfix: '%'
});
$("input[name='demo2']").TouchSpin({
    min: -1000000000,
    max: 1000000000,
    stepinterval: 50,
    buttondown_class: "btn btn-primary",
    buttonup_class: "btn btn-primary",
    maxboostedstep: 10000000,
    prefix: '$'
});
$("input[name='demo3']").TouchSpin({
    buttondown_class: "btn btn-primary",
    buttonup_class: "btn btn-primary"
});
$("input[name='demo3_21']").TouchSpin({
    initval: 40,
    buttondown_class: "btn btn-primary",
    buttonup_class: "btn btn-primary"
});
$("input[name='demo3_22']").TouchSpin({
    initval: 40,
    buttondown_class: "btn btn-primary",
    buttonup_class: "btn btn-primary"
});

$("input[name='demo5']").TouchSpin({
    prefix: "pre",
    postfix: "post",
    buttondown_class: "btn btn-primary",
    buttonup_class: "btn btn-primary"
});
$("input[name='demo0']").TouchSpin({
    buttondown_class: "btn btn-primary",
    buttonup_class: "btn btn-primary"
});


// Input Mask
$( document ).ready(function() {
    $('[data-toggle="input-mask"]').each(function (idx, obj) {
        var maskFormat = $(obj).data("maskFormat");
        var reverse = $(obj).data("reverse");
        if (reverse != null)
            $(obj).mask(maskFormat, {'reverse': reverse});
        else
            $(obj).mask(maskFormat);
    });
});