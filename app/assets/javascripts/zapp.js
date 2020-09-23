(function($) {
    "use strict";
    var documentHeight, headerHeight;
    var windowHeight;
    var windowWidth;
    var contentHeight;
    var contentWidth;
    var isDevice = true;
    var panorama;
    var split_view_length = $('#mapViewSearch').length;

    var dragging = false;
    $("a").on("touchmove", function(){
      dragging = true;
    });

    // for ios devices double tap
    $('body').on('click','a', function(e) {
        var building_id = '';
        var type = '';
        var el = $(this);
        var role = el.data('role');
        building_id = el.data('bid');
        type = el.data('type');
        if(role != 'slider'){
            if(building_id != ''){
                if(type == 'listings'){
                    showActiveListingsPopup(building_id);    
                }else if(type == 'contact'){
                    showLeasingContactPopup(building_id);
                }
            }
        }
    });

    $("a").on("touchstart", function(){
        dragging = false;
    });

    // calculations for elements that changes size on window resize
    var windowResizeHandler = function() {
        windowHeight = window.innerHeight;
        headerHeight = $('#header').height();
        contentHeight = windowHeight - headerHeight;
        contentWidth = $('#content').width();

        $('#leftSide').height(contentHeight);
        $('.closeLeftSide').height(contentHeight);
        $('#wrapper').height(contentHeight);
        $('#mapView').height(contentHeight);
        // $('#content').height(contentHeight);
    }

    if(split_view_length == 0){
        windowResizeHandler();
    }

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
            $('#priceFieldsContainer').html('<input type="hidden" name="filter[min_price]" id="min_price" value='+min+'>' +
                                            '<input type="hidden" name="filter[max_price]" id="max_price" value='+maxValue+'>');

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

    // For mobile dropdown panel
    $('.dropdown-toggle-neighborhoods, .closeHoods').click(function(e) {
      $('.popular-neighborhoods').slideToggle(200, 'linear', function(){
        var elem             = $('#wrapper.screen-sm');
        var toggleable_class = 'no-touch-scroll'
        $(this).is(':hidden') ? elem.removeClass(toggleable_class) : elem.addClass(toggleable_class);
      });
    });

    // Header search icon transition
    $('.search input').focus(function() {
        $('.searchIcon').addClass('active');
    });
    $('.search input').blur(function() {
        $('.searchIcon').removeClass('active');
    });

    // functionality for map manipulation icon on mobile devices
    var listMapView = function(){
        if ($('#mapView, #mapViewSearch').hasClass('mob-min') || 
            $('#mapView, #mapViewSearch').hasClass('mob-max') || 
            $('#content').hasClass('mob-min') || 
            $('#content').hasClass('mob-max')) {
            $('#mapView, #mapViewSearch').toggleClass('mob-max');
            $('#content').toggleClass('mob-min');
        } else {
            $('#content').toggleClass('min');
            $('#mapView, #mapViewSearch').toggleClass('max');
        }
        initialize();
        setTimeout(function() {
            if(map && redo_search){
                map.setCenter(new google.maps.LatLng(lat,lng));
            }
        }, 1000);
    }

    /* end show page */
    
    $('.listHandler').click(function(){
        $(this).hide();
        $('.mapHandler').show();
        listMapView();
        $('.sorted_by_option').show();
        // Only when redo search
        // images are not loading on hidden element
        if($('.searched-properties').hasClass('invisible')){
            $('.searched-properties').removeClass('invisible').removeClass('min');
        }
        setSession('listView')
    })
    
    $('.mapHandler, .show-map-handler').click(function() {
        if(!$(this).hasClass('show-map-handler')){
            $(this).hide();
        }
        $('.listHandler').show();
        listMapView();
        $('.sorted_by_option').hide()
        setSession('mapView')
    });

    var setSession = function(view_type){
        $.ajax({
            url: '/set_split_view_type',
            beforeSend: function(xhr){
                xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
            },
            type: 'post',
            dataType: 'json',
            data: {view_type: view_type},
            success: function(response){
                console.log(response)
            }
        })
    }

    // functionality for custom dropdown select list
    $('.dropdown-select li a').click(function() {
        var dp_s = $(this).parent();
        if (!(dp_s.hasClass('disabled'))) {
            $(this).prev().prop("checked", true);
            dp_s.siblings().removeClass('active');
            dp_s.addClass('active');
            dp_s.parent().siblings('.dropdown-toggle').children('.dropdown-label').html($(this).text());
        }
    });

    
    $('.closeGuides, .handleGuides').click(function(e) {
        e.stopPropagation();
        $('.modal-full').slideToggle(200);
    });

    $('.handleFilter, .closeFilter').click(function(e) {
        e.stopPropagation();
        DPButtons.init();
        DPButtons.handleFilter()
        initSlider();
        DPButtons.closeDropdowns($(this), 'other');
    });

    // Avoid dropdown menu close on click inside
    $(document).on('click', '.neighborhoods-dropdown .dropdown-menu', function (e) {
        e.stopPropagation();
    });

    $(document).on('click', '.dropdown-toggle', function(){
        DPButtons.init();
        DPButtons.closeDropdowns($(this), 'filter');
    });
    
    // Running this script only on desktop views
    // var isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent) ? true : false;

    $(document).click(function(e) {
        e.stopPropagation();
        if($(e.target).closest('.filter').length === 0){
            if($('.filter').is(':visible')){
                $('.filter').slideUp(200);
            }
        }
    });

    $('.handleSort').click(function(e) {
        $('.sortMenu').slideToggle(200);
    });

    $('.applyFilter').click(function(e) {
        e.preventDefault();
        $('.btn-submit-filter-form').click();
    });

    $('.btn').click(function() {
        if ($(this).is('[data-toggle-class]')) {
            $(this).toggleClass('active ' + $(this).attr('data-toggle-class'));
        }
    });

    $('.progress-bar[data-toggle="tooltip"]').tooltip();
    $('.tooltipsContainer .btn').tooltip();
    $('#datepicker').datepicker();

    // clear text search
    $('.clearSearchText').click(function(){
        $("#search_term").val('');
    })

    // clearing out unit modal fields on building show page
    $("#new_unit_modal .close").click(function(){
        var search_field = $("#new_unit_modal #units-search-txt");
        if(search_field.val() != ''){
          search_field.val('');
        }
        if(!$('#new_unit_building').hasClass('hide')){
          $('#new_unit_building').addClass('hide');
        }
        if($(".no-result-li").length > 0){
          $(".no-result-li").remove();
        }
    })

    $('.add_unit').click(function(){
        if($("#units-search-txt").hasClass('hide') && $(".unit-search").hasClass('hide')){
          $("#units-search-txt").removeClass('hide');
          $(".unit-search").removeClass('hide');
        }
    });

    // Rotating image overlay...
    $('.rotate').click(function(){
      $('.loading').removeClass('hidden');
    });

    $("#apt-search-txt-searchpage, #search_term").click(function () {
        $(this).select();
    });

    // Removing thumb slider from similar proprties gallery
    setTimeout(function() {
        $('#carouselSimilar-1').find('.lSPager.lSGallery').each(function(){
            if($(this).children().length == 0){
               $(this).remove(); 
            }
        })
    }, 500);
    

    $(".btn-dp-toggle").on("hide.bs.dropdown", function(){
        $(this).addClass('closed');
    });

    $(".btn-dp-toggle").on("show.bs.dropdown", function(){
        if($(this).hasClass('closed')){
            $(this).removeClass('closed');
        }
    });

    $(document).on('click', function(e){
        e.stopPropagation();
    });

    // Hiding mobile browser select box on soeted by text click
    $('.sorted-by').click(function(){
        // console.log(12)
    })

    $(document).on('click', 'select#sort', function(){
        // alert(12)
    });

    // setting timezone
    $('.user_time_zone').set_timezone(); 
    const timezone = $('.user_time_zone').val(); 
    // setting in cookies to access using helper method on application controller
    function setCookie(name, value) {
      var expires = new Date()
      expires.setTime(expires.getTime() + (24 * 60 * 60 * 1000))
      document.cookie = name + '=' + value + ';expires=' + expires.toUTCString()
    }

    setCookie("timezone", timezone)

})(jQuery);