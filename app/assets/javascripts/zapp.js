(function($) {
    "use strict";
    var documentHeight, headerHeight;
    var windowHeight;
    var windowWidth;
    var contentHeight;
    var contentWidth;
    var isDevice = true;
    var panorama;

    // calculations for elements that changes size on window resize
    var windowResizeHandler = function() {
        windowHeight = window.innerHeight;
        windowWidth = $(window).width();
        headerHeight = $('#header').height();
        contentHeight = windowHeight - headerHeight;
        contentWidth = $('#content').width();

        $('#leftSide').height(contentHeight);
        $('.closeLeftSide').height(contentHeight);
        $('#wrapper').height(contentHeight);
        $('#mapView').height(contentHeight);
        $('#content').height(contentHeight);

        // Add custom scrollbar for left side navigation
        if(windowWidth > 767) {
            $('.bigNav').slimScroll({
                height : contentHeight - $('.leftUserWraper').height()
            });
        } else {
            $('.bigNav').slimScroll({
                height : contentHeight
            });
        }
        if($('.bigNav').parent('.slimScrollDiv').size() > 0) {
            $('.bigNav').parent().replaceWith($('.bigNav'));
            if(windowWidth > 767) {
                $('.bigNav').slimScroll({
                    height : contentHeight - $('.leftUserWraper').height()
                });
            } else {
                $('.bigNav').slimScroll({
                    height : contentHeight
                });
            }
        }
    }

    // var repositionTooltip = function( e, ui ){
    //     var div = $(ui.handle).data("bs.tooltip").$tip[0];
    //     var pos = $.extend({}, $(ui.handle).offset(), { 
    //                     width: $(ui.handle).get(0).offsetWidth,
    //                     height: $(ui.handle).get(0).offsetHeight
    //                 });
    //     var actualWidth = div.offsetWidth;

    //     var tp = {left: pos.left + pos.width / 2 - actualWidth / 2}
    //     $(div).offset(tp);

    //     $(div).find(".tooltip-inner").text( ui.value );
    // }

    windowResizeHandler();

    //For mobile dropdown panel
    $('.dropdown-toggle-neighborhoods, .closeHoods').click(function(e) {
      $('.popular-neighborhoods').slideToggle(200);
    });
    
    $("#toggleStreetView").click(function(){
        var toggle = panorama.getVisible();
        if(toggle == false){
          panorama.setVisible(true);
          $(this).val('Map View');
        } else {
          panorama.setVisible(false);
          $(this).val('Street View');
        }
    })
    

    if(!(('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch)) {
        $('body').addClass('no-touch');
        isDevice = false;
    }

    // Header search icon transition
    $('.search input').focus(function() {
        $('.searchIcon').addClass('active');
    });
    $('.search input').blur(function() {
        $('.searchIcon').removeClass('active');
    });

    // Exapnd left side navigation
    var navExpanded = false;
    $('.navHandler, .closeLeftSide, .home-navHandler').click(function() {
        if(!navExpanded) {
            $('.logo').addClass('expanded');
            $('#leftSide').addClass('expanded');
            if(windowWidth < 768) {
                $('.closeLeftSide').show();
            }
            $('.hasSub').addClass('hasSubActive');
            $('.leftNav').addClass('bigNav');
            if(windowWidth > 767) {
                $('.full').addClass('m-full');
            }
            windowResizeHandler();
            navExpanded = true;
        } else {
            $('.logo').removeClass('expanded');
            $('#leftSide').removeClass('expanded');
            $('.closeLeftSide').hide();
            $('.hasSub').removeClass('hasSubActive');
            //$('.bigNav').slimScroll({ destroy: true });
            $('.leftNav').removeClass('bigNav');
            $('.leftNav').css('overflow', 'visible');
            $('.full').removeClass('m-full');
            navExpanded = false;
        }
    });

    $(document).click(function(e){
        var target_class = e.target.className;
        if(target_class !== "fa fa-bars" && target_class != 'ssm-toggle-nav1'){
            $('#leftSide').removeClass('expanded');
            $('.logo').removeClass('expanded');
        }
    })

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
        initialize(false);
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
        //Only when redo search
        //images are not loading on hidden element
        if($('.searched-properties').hasClass('invisible')){
            $('.searched-properties').removeClass('invisible').removeClass('min');
        }
    })
    
    $('.mapHandler').click(function() {
        $(this).hide();
        $('.listHandler').show();
        listMapView();
        $('.sorted_by_option').hide()
    });

    // Expand left side sub navigation menus
    $(document).on("click", '.hasSubActive', function() {
        $(this).toggleClass('active');
        $(this).children('ul').toggleClass('bigList');
        $(this).children('a').children('.arrowRight').toggleClass('fa-angle-down');
    });

    if(isDevice) {
        $('.hasSub').click(function() {
            $('.leftNav ul li').not(this).removeClass('onTap');
            $(this).toggleClass('onTap');
        });
    }

    // functionality for custom dropdown select list
    $('.dropdown-select li a').click(function() {
        if (!($(this).parent().hasClass('disabled'))) {
            $(this).prev().prop("checked", true);
            $(this).parent().siblings().removeClass('active');
            $(this).parent().addClass('active');
            $(this).parent().parent().siblings('.dropdown-toggle').children('.dropdown-label').html($(this).text());
        }
    });

    
    $('.closeGuides, .handleGuides').click(function(e) {
        e.stopPropagation();
        $('.modal-full').slideToggle(200);
    });

    $('.handleFilter, .closeFilter').click(function(e) {
        e.stopPropagation();
        $('.filter').slideToggle(200);
        $('.btn-filter').toggleClass('open');
    });

    //Avoid dropdown menu close on click inside
    $(document).on('click', '.neighborhoods-dropdown .dropdown-menu', function (e) {
      e.stopPropagation();
    });
    
    //Running this script only on desktop views
    //var isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent) ? true : false;

    $(document).click(function(e) {
        //if(!isMobile && window.innerWidth > 799){
        e.stopPropagation();
        //$(e.target).closest('.filter').length skip hiding filter panel on this click
        if($(e.target).closest('.filter').length === 0){
            if($('.filter').is(':visible')){
                $('.filter').slideUp(200);
            }
        }
        //}
         
    });

     $('.handleSort').click(function(e) {
        //e.preventDefault();
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

    // $('.tabsWidget .tab-scroll').slimScroll({
    //     height: '235px',
    //     size: '5px',
    //     position: 'right',
    //     color: '#939393',
    //     alwaysVisible: false,
    //     distance: '5px',
    //     railVisible: false,
    //     railColor: '#222',
    //     railOpacity: 0.3,
    //     wheelStep: 10,
    //     allowPageScroll: true,
    //     disableFadeOut: false
    // });

    $('.progress-bar[data-toggle="tooltip"]').tooltip();
    $('.tooltipsContainer .btn').tooltip();
    $('#datepicker').datepicker();

    //clear text search
    $('.clearSearchText').click(function(){
        $("#search_term").val('');
    })

    //clearing out unit modal fields on building show page
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
    })

    //New review form validations only
    //$().ready(function(){
    $("#new_review").validate({
        rules: {
            'score[building]': 'required',
            'score[cleanliness]': 'required',
            'score[noise]': 'required',
            'score[safe]': 'required',
            'score[health]': 'required',
            'score[responsiveness]': 'required',
            'score[management]': 'required',
            'review[tenant_status]': 'required',
            'review[review_title]': 'required',
            'review[resident_to]': 'required',
            'review[pros]': { 'required': true, 'minlength': 10 },
            'review[cons]': { 'required': true, 'minlength': 10 },
            'review[resident_from]': 'required',
            'review[tos_agreement]': 'required',
            'vote': 'required'
        },
        messages: {
            'score': 'Please select a rating.',
            'review[tenant_status]': 'Please select a reviewer type.',
            'review[review_title]': 'Please add review title.',
            'review[resident_to]': 'Please select number of years in residence.',
            'review[pros]': {'required': 'Please add pros.', 'minlength': 'You must enter at least 10 words.'},
            'review[cons]': {'required': 'Please add cons.', 'minlength': 'You must enter at least 10 words.'},
            'review[resident_from]': 'Please select last year at residence.',
            'vote': 'Please select recommendation.',
            'review[tos_agreement]': 'Must be accepted.'
        }
    });
    
    //Start Listing Datatable script
    $('#sortable').DataTable({
      paging: false,
      scrollY: 400,
      "order": [],
      "columnDefs": [
        { "orderable": false, "targets": 'no-sort' }
      ]
    });

    //Listing DataTable script END

    //Removing rules when no pros check is checked
    $('#no_pros').change(function(){
        if($(this).is(':checked')){
            $('#review_pros').rules('remove', 'invalid min required');
        }
        else{
            $('#review_pros').rules('add', 'invalid min required');
        }
    })

    //Removing rules when no cons check is checked and vice versa
    $('#no_cons').change(function(){
        if($(this).is(':checked')){
            $('#review_cons').rules('remove', 'invalid min required');
        }
        else{
            $('#review_cons').rules('add', 'invalid min required');
        }
    });

    //Rotating image overlay...
    $('.rotate').click(function(){
      $('.loading').removeClass('hidden');
    });

    $("#apt-search-txt-searchpage, #search_term").click(function () {
        $(this).select();
    });

    //Removing thumb slider from similar proprties gallery
    setTimeout(function() {
        $('#carouselSimilar-1').find('.lSPager.lSGallery').each(function(){
            if($(this).children().length == 0){
               $(this).remove(); 
            }
        })
    }, 500);
    
    var mask_options = {
                        onKeyPress: function(cep, e, field, options) {
                            if(cep == '('){
                                field.val('');
                            }
                        }
                    };
    $('.phone_number').mask("(000) 000-0000", mask_options);
    
    //removing neighborhoods dropdown toggle background when mouse leave
    var once_leaved = false;
    var primary_dropdown = $('.neighborhoods-dropdown .dropdown-toggle, .btn-sort .dropdown-toggle, .btn-filter .dropdown-toggle');
    primary_dropdown.on('mouseleave', function(){
        if(!$(this).parent().hasClass('open')){
            removeDropdownToggleBg($(this))
            once_leaved = true
        }
    })
    primary_dropdown.on('mouseover', function(){
        if(once_leaved){
            $(this).css({'background-color':'#3071a9', 'color':'#fff', 'border-color':'#285e8e'});
        }
    });

    function removeDropdownToggleBg(elem){
        elem.css({'background-color':'transparent', 'color':'#0075c9', 'border-color':'#428bca'});
    }

    $(document).on('click', function(e){
        e.stopPropagation();
        var target = e.target;
        var filter_length = $(target).parents().find('.filter').length;
        if(filter_length <= 0 && target.className != 'dropdown-menu dropdown-select userMenu sc-lg'){
            removeDropdownToggleBg(primary_dropdown)
        }
    });
})(jQuery);