var min_price = 0;
var max_price = 15500;
if($('#min_price').length > 0){
    min_price = $('#min_price').val();
    max_price = parseInt($('#max_price').val());
}

var setPrice = function(min, max, on_slide=false){
    var maxValue = parseInt(max) > 15000 ? '15500+' : max;
    $('.priceSlider .sliderTooltip .stLabel').html(
        '$' + min.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + 
        ' <span class="fa fa-arrows-h"></span> ' +
        '$' + maxValue.toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,")
    );
    
    if(on_slide){
        $('#priceFieldsContainer').html('<input type="hidden" name="filter[listings][min_price]" id="min_price" value='+min+'>' +
                                        '<input type="hidden" name="filter[listings][max_price]" id="max_price" value='+maxValue+'>');

    }
}
if($('.priceSlider').length > 0){
    $('.priceSlider').slider({
        range: true,
        min: 0,
        max: 15500,
        values: [min_price, max_price],
        step: 250,
        slide: function(event, ui) {
            $('#listings_price_box').prop('checked', true);
            var sliding = true;
            setPrice(ui.values[0], ui.values[1], sliding);
            
            if($('.building_price_filter:checked').length > 0){
                $('.building_price_filter').prop('checked', false);
            }

            if($('.building_bed_filter:checked').length > 0){
                $('.building_bed_filter').prop('checked', false);
            }
        }
    });
};

var initSlider = function(){
    setPrice(min_price, max_price);
}

initSlider();