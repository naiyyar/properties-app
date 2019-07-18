(function($) {
    "use strict";
    
    if(!(('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch)) {
        $('body').addClass('no-touch');
    }

     $('.dropdown-select li a').click(function() {
        if (!($(this).parent().hasClass('disabled'))) {
            $(this).prev().prop("checked", true);
            $(this).parent().siblings().removeClass('active');
            $(this).parent().addClass('active');
            $(this).parent().parent().siblings('.dropdown-toggle').children('.dropdown-label').html($(this).text());
        }
    });

    $('#advanced').click(function() { $('.adv').toggleClass('hidden-xs'); });

    //Enable swiping
    var elem;
    var visted_count;
    var total_count ;
    $(".carousel-inner").swipe( {
        swipeLeft:function(event, direction, distance, duration, fingerCount) {
            $(this).parent().carousel('next');
            var carousel = $(this).parent(); 
            increaseSliderImageNumCount(carousel);
            var building_id = $(this).data('buildingid');
            appendBuildingImages(building_id, carousel)
        },
        swipeRight: function() {
            $(this).parent().carousel('prev');
            var carousel = $(this).parent();
            decreaseSliderImageNumCount(carousel);
            var building_id = $(this).data('buildingid');
            appendBuildingImages(building_id, carousel)
        }
    });

    function decreaseSliderImageNumCount(inner_carousal){
        elem = inner_carousal.parent().find('.img-num');
        visted_count = parseInt($(elem).text());
        total_count = inner_carousal.find('div.item').length;

        if(visted_count == 1){
            $(elem).text(total_count);
        }else{
            $(elem).text(visted_count-1);
        }
    }

    function increaseSliderImageNumCount(inner_carousal){
        elem = inner_carousal.parent().find('.img-num');
        visted_count = parseInt($(elem).text());
        total_count = inner_carousal.find('.item').length;
        
        if(visted_count == total_count){
            $(elem).text('1');
        }else{
            $(elem).text(visted_count+1);
        }
    }

    $('.carousel .left').click(function(){
        var carousel_inner = $(this).parent().find('.carousel-inner')
        decreaseSliderImageNumCount(carousel_inner);
        var building_id = $(this).data('buildingid');
        appendBuildingImages(building_id, carousel_inner);
    });

    $('.carousel .right').click(function(){
        var carousel_inner = $(this).parent().find('.carousel-inner');
        increaseSliderImageNumCount(carousel_inner);
        var building_id = $(this).data('buildingid');
        appendBuildingImages(building_id, carousel_inner);
    });

    function appendBuildingImages(building_id, elem, active_image_id){
        $.ajax({
            url: '/buildings/'+building_id+'/uploads',
            type: 'get',
            dataType: 'json',
            success: function(response){
                
            }

        })
    }

    $(document).on('click', '.modal-su', function() {
        $('#signin').modal('hide');
        $('#signup').modal('show');
    });

    $(document).on('click', '.modal-si', function() {
        $('#signup').modal('hide');
        $('#signin').modal('show');
    });

    $(document).on('click', function(e){
        e.stopPropagation();
        if(e.target.id != 'search_term' && e.target.id != 'location-link'){
            hideAutoSearchList();
        }
    })

    $(document).on('keyup', '#search_term', function(e){
        //e.keyCode != 40 || e.keyCode != 38 for key up / down
        //home page search
        if((e.keyCode != 40 && e.keyCode != 38)){
            if($('#search_term').val() == ''){
                hideAutoSearchList();
            }
        }
    });

    function hideAutoSearchList(){
        //#setInterval because no match link was not working: hiding too early
        setTimeout(function(){
            if($("ul.ui-autocomplete").is(":visible")) {
                $("ul.ui-autocomplete").hide();
            }
            $('.no-match-link').addClass('hidden');
            $('.home #search_term').addClass('border-bottom-lr-radius');
        }, 200);
    }

    //Searching building on neighborhood click
    $('.borough-neighborhood').click(function(e){
        e.preventDefault();
        $('#neighborhoods').val($(this).text());
        var nbh = $(this).data('nhname');
        $('#apt-search-txt').val(nbh);
        $('.search-btn-submit').click();
        if($('.search-btn-submit').length > 0){
            $('.search-btn-submit').click();
        }
    })


    $('.panel-collapse').on('show.bs.collapse', function () {
        $(this).prev().find('span').removeClass('fa-angle-down').addClass('fa-angle-up');
    });

    $('.panel-collapse').on('hide.bs.collapse', function () {
        $(this).prev().find('span').removeClass('fa-angle-up').addClass('fa-angle-down');
    });

    //Home menu swipe and slide
    //$('.swipe-nav').slideAndSwipe();

    //To changes the size of search field on mobile device orientation changed
    window.addEventListener('resize', function() {
        var homeSearchContainer = $('.home-search-form  .easy-autocomplete');
        var splitSearchContainer = $('.split-view-seach  .easy-autocomplete');
        setTimeout(function(){
            if(window.innerWidth > 500 && window.innerWidth <= 667){
                homeSearchContainer.css('width','649px');
                splitSearchContainer.css('width','581px');
            }
            else if(window.innerWidth > 667 && window.innerWidth <= 736){
                homeSearchContainer.css('width','715px');
                splitSearchContainer.css('width','646px');
            }
            else if(window.innerWidth == 375){
                homeSearchContainer.css('width','355px');
                splitSearchContainer.css('width','289px');
            }
            else if(window.innerWidth == 414){
                homeSearchContainer.css('width','394px');
                splitSearchContainer.css('width','322px');
            }
        }, 200);
    }, false);
})(jQuery);