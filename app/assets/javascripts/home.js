(function($) {
    "use strict";

    // var options = {
    //         zoom : 14,
    //         mapTypeId : 'Styled',
    //         disableDefaultUI: true,
    //         mapTypeControlOptions : {
    //             mapTypeIds : [ 'Styled' ]
    //         },
    //         scrollwheel: false
    //     };
    // var styles = [{
    //     stylers : [ {
    //         hue : "#cccccc"
    //     }, {
    //         saturation : -100
    //     }]
    // }, {
    //     featureType : "road",
    //     elementType : "geometry",
    //     stylers : [ {
    //         lightness : 100
    //     }, {
    //         visibility : "simplified"
    //     }]
    // }, {
    //     featureType : "road",
    //     elementType : "labels",
    //     stylers : [ {
    //         visibility : "on"
    //     }]
    // }, {
    //     featureType: "poi",
    //     stylers: [ {
    //         visibility: "off"
    //     }]
    // }];

    // var markers = [];
    // var props = [{
    //     title : 'Modern Residence in New York',
    //     image : '1-1-thmb.png',
    //     type : 'For Sale',
    //     price : '$1,550,000',
    //     address : '39 Remsen St, Brooklyn, NY 11201, USA',
    //     bedrooms : '3',
    //     bathrooms : '2',
    //     area : '3430 Sq Ft',
    //     position : {
    //         lat : 40.696047,
    //         lng : -73.997159
    //     },
    //     markerIcon : "marker-green.png"
    // }, {
    //     title : 'Hauntingly Beautiful Estate',
    //     image : '2-1-thmb.png',
    //     type : 'For Rent',
    //     price : '$1,750,000',
    //     address : '169 Warren St, Brooklyn, NY 11201, USA',
    //     bedrooms : '2',
    //     bathrooms : '2',
    //     area : '4430 Sq Ft',
    //     position : {
    //         lat : 40.688042,
    //         lng : -73.996472
    //     },
    //     markerIcon : "marker-green.png"
    // }, {
    //     title : 'Sophisticated Residence',
    //     image : '3-1-thmb.png',
    //     type : 'For Sale',
    //     price : '$1,340,000',
    //     address : '38-62 Water St, Brooklyn, NY 11201, USA',
    //     bedrooms : '2',
    //     bathrooms : '3',
    //     area : '2640 Sq Ft',
    //     position : {
    //         lat : 40.702620,
    //         lng : -73.989682
    //     },
    //     markerIcon : "marker-green.png"
    // }, {
    //     title : 'House With a Lovely Glass-Roofed Pergola',
    //     image : '4-1-thmb.png',
    //     type : 'For Sale',
    //     price : '$1,930,000',
    //     address : 'Wunsch Bldg, Brooklyn, NY 11201, USA',
    //     bedrooms : '3',
    //     bathrooms : '2',
    //     area : '2800 Sq Ft',
    //     position : {
    //         lat : 40.694355,
    //         lng : -73.985229
    //     },
    //     markerIcon : "marker-green.png"
    // }, {
    //     title : 'Luxury Mansion',
    //     image : '5-1-thmb.png',
    //     type : 'For Rent',
    //     price : '$2,350,000',
    //     address : '95 Butler St, Brooklyn, NY 11231, USA',
    //     bedrooms : '2',
    //     bathrooms : '2',
    //     area : '2750 Sq Ft',
    //     position : {
    //         lat : 40.686838,
    //         lng : -73.990078
    //     },
    //     markerIcon : "marker-green.png"
    // }, {
    //     title : 'Modern Residence in New York',
    //     image : '1-1-thmb.png',
    //     type : 'For Sale',
    //     price : '$1,550,000',
    //     address : '39 Remsen St, Brooklyn, NY 11201, USA',
    //     bedrooms : '3',
    //     bathrooms : '2',
    //     area : '3430 Sq Ft',
    //     position : {
    //         lat : 40.703686,
    //         lng : -73.982910
    //     },
    //     markerIcon : "marker-green.png"
    // }, {
    //     title : 'Hauntingly Beautiful Estate',
    //     image : '2-1-thmb.png',
    //     type : 'For Rent',
    //     price : '$1,750,000',
    //     address : '169 Warren St, Brooklyn, NY 11201, USA',
    //     bedrooms : '2',
    //     bathrooms : '2',
    //     area : '4430 Sq Ft',
    //     position : {
    //         lat : 40.702189,
    //         lng : -73.995098
    //     },
    //     markerIcon : "marker-green.png"
    // }, {
    //     title : 'Sophisticated Residence',
    //     image : '3-1-thmb.png',
    //     type : 'For Sale',
    //     price : '$1,340,000',
    //     address : '38-62 Water St, Brooklyn, NY 11201, USA',
    //     bedrooms : '2',
    //     bathrooms : '3',
    //     area : '2640 Sq Ft',
    //     position : {
    //         lat : 40.687417,
    //         lng : -73.982653
    //     },
    //     markerIcon : "marker-green.png"
    // }, {
    //     title : 'House With a Lovely Glass-Roofed Pergola',
    //     image : '4-1-thmb.png',
    //     type : 'For Sale',
    //     price : '$1,930,000',
    //     address : 'Wunsch Bldg, Brooklyn, NY 11201, USA',
    //     bedrooms : '3',
    //     bathrooms : '2',
    //     area : '2800 Sq Ft',
    //     position : {
    //         lat : 40.694120,
    //         lng : -73.974413
    //     },
    //     markerIcon : "marker-green.png"
    // }, {
    //     title : 'Luxury Mansion',
    //     image : '5-1-thmb.png',
    //     type : 'For Rent',
    //     price : '$2,350,000',
    //     address : '95 Butler St, Brooklyn, NY 11231, USA',
    //     bedrooms : '2',
    //     bathrooms : '2',
    //     area : '2750 Sq Ft',
    //     position : {
    //         lat : 40.682665,
    //         lng : -74.000934
    //     },
    //     markerIcon : "marker-green.png"
    // }];

    // var infobox = new InfoBox({
    //     disableAutoPan: false,
    //     maxWidth: 202,
    //     pixelOffset: new google.maps.Size(-101, -285),
    //     zIndex: null,
    //     boxStyle: {
    //         background: "url('assets/infobox-bg.png') no-repeat",
    //         opacity: 1,
    //         width: "202px",
    //         height: "245px"
    //     },
    //     closeBoxMargin: "28px 26px 0px 0px",
    //     closeBoxURL: "",
    //     infoBoxClearance: new google.maps.Size(1, 1),
    //     pane: "floatPane",
    //     enableEventPropagation: false
    // });

    // var addMarkers = function(props, map) {
    //     $.each(props, function(i,prop) {
    //         var latlng = new google.maps.LatLng(prop.position.lat,prop.position.lng);
    //         var marker = new google.maps.Marker({
    //             position: latlng,
    //             map: map,
    //             icon: new google.maps.MarkerImage( 
    //                 'assets/' + prop.markerIcon,
    //                 null,
    //                 null,
    //                 // new google.maps.Point(0,0),
    //                 null,
    //                 new google.maps.Size(36, 36)
    //             ),
    //             draggable: false,
    //             animation: google.maps.Animation.DROP,
    //         });
    //         var infoboxContent = '<div class="infoW">' +
    //                                 '<div class="propImg">' +
    //                                     '<img src="assets/prop/' + prop.image + '">' +
    //                                     '<div class="propBg">' +
    //                                         '<div class="propPrice">' + prop.price + '</div>' +
    //                                         '<div class="propType">' + prop.type + '</div>' +
    //                                     '</div>' +
    //                                 '</div>' +
    //                                 '<div class="paWrapper">' +
    //                                     '<div class="propTitle">' + prop.title + '</div>' +
    //                                     '<div class="propAddress">' + prop.address + '</div>' +
    //                                 '</div>' +
    //                                 '<div class="propRating">' +
    //                                     '<span class="fa fa-star"></span>' +
    //                                     '<span class="fa fa-star"></span>' +
    //                                     '<span class="fa fa-star"></span>' +
    //                                     '<span class="fa fa-star"></span>' +
    //                                     '<span class="fa fa-star-o"></span>' +
    //                                 '</div>' +
    //                                 '<ul class="propFeat">' +
    //                                     '<li><span class="fa fa-moon-o"></span> ' + prop.bedrooms + '</li>' +
    //                                     '<li><span class="icon-drop"></span> ' + prop.bathrooms + '</li>' +
    //                                     '<li><span class="icon-frame"></span> ' + prop.area + '</li>' +
    //                                 '</ul>' +
    //                                 '<div class="clearfix"></div>' +
    //                                 '<div class="infoButtons">' +
    //                                     '<a class="btn btn-sm btn-round btn-gray btn-o closeInfo">Close</a>' +
    //                                     '<a href="single.html" class="btn btn-sm btn-round btn-green viewInfo">View</a>' +
    //                                 '</div>' +
    //                              '</div>';

    //         google.maps.event.addListener(marker, 'click', (function(marker, i) {
    //             return function() {
    //                 infobox.setContent(infoboxContent);
    //                 infobox.open(map, marker);
    //             }
    //         })(marker, i));

    //         $(document).on('click', '.closeInfo', function() {
    //             infobox.open(null,null);
    //         });

    //         markers.push(marker);
    //     });
    // }

    // var map;

    // setTimeout(function() {
    //     $('body').removeClass('notransition');

    //     if ($('#home-map').length > 0) {
    //         map = new google.maps.Map(document.getElementById('home-map'), options);
    //         var styledMapType = new google.maps.StyledMapType(styles, {
    //             name : 'Styled'
    //         });

    //         map.mapTypes.set('Styled', styledMapType);
    //         map.setCenter(new google.maps.LatLng(40.6984237,-73.9890044));
    //         map.setZoom(14);

    //         addMarkers(props, map);
    //     }
    // }, 300);

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

    // var cityOptions = {
    //     types : [ '(cities)' ]
    // };
    // var city = document.getElementById('city');
    // var cityAuto = new google.maps.places.Autocomplete(city, cityOptions);

    $('#advanced').click(function() {
        $('.adv').toggleClass('hidden-xs');
    });

    $('.home-navHandler').click(function(e) {
        //e.stopPropagation();
        $('.home-nav').toggleClass('active');
        $(this).toggleClass('active');
        return false;
    });

    $(document).click(function(){
        if($('.home-nav').hasClass('active')){
          $('.home-nav').removeClass('active');
        }
    })

    // $(document).on('touchend', function(){
    //     if($('.home-nav').hasClass('active')){
    //       $('.home-nav').removeClass('active');
    //     }
    // })

    //Enable swiping
    var elem;
    var visted_count;
    var total_count ;
    $(".carousel-inner").swipe( {
        swipeLeft:function(event, direction, distance, duration, fingerCount) {
            $(this).parent().carousel('next'); 
            increaseSliderImageNumCount($(this).parent());
        },
        swipeRight: function() {
            $(this).parent().carousel('prev');
            decreaseSliderImageNumCount($(this).parent());
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
        console.log(visted_count)
        total_count = inner_carousal.find('.item').length;
        window.data = inner_carousal;
        console.log(total_count)
        
        if(visted_count == total_count){
            $(elem).text('1');
        }else{
            $(elem).text(visted_count+1);
        }
    }

    $('.carousel .left').click(function(){
        decreaseSliderImageNumCount($(this).parent().find('.carousel-inner'));
    });

    $('.carousel .right').click(function(){
        increaseSliderImageNumCount($(this).parent().find('.carousel-inner'));
    });


    $(document).on('click', '.modal-su', function() {
        $('#signin').modal('hide');
        $('#signup').modal('show');
    });

    $(document).on('click', '.modal-si', function() {
        $('#signup').modal('hide');
        $('#signin').modal('show');
    });

    //Hiding not building link element
    // $('.contribute-wrapper').click(function(e) {
    //     console.log(12)
    //     hideAutoSearchList();
    // });

    // $('#search_term, #buildings-search-txt').blur(function(e){
    //     hideAutoSearchList();
    // })

    $(document).click(function(e){
        e.stopPropagation();
        hideAutoSearchList();
    })

    $('#search_term').keyup(function(e){
        //e.keyCode != 40 || e.keyCode != 38 for key up / down
        //home page search
        if((e.keyCode != 40 && e.keyCode != 38)){
            if($('#search_term').val() == ''){
                hideAutoSearchList();
            }
        }
    })

    function hideAutoSearchList(){
        //#setInterval because no match link was not working: hiding too early
        setTimeout(function(){
            if($("ul.ui-autocomplete").is(":visible")) {
                $("ul.ui-autocomplete").hide();
            }
            $('.no-match-link').addClass('hidden');
        }, 200)
    }
     

    //Searching building on neighborhood click
    $('.borough-neighborhood').click(function(e){
        e.preventDefault();
        $('#neighborhoods').val($(this).text());
        var nbh = $(this).data('nhname');
        //var city = $(this).data('city');
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

})(jQuery);