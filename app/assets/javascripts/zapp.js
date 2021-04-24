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

  // When not using anchor tag
  //
  $('.clickable').click(function(e){
      if(e.target.tagName !== 'A'){
        window.location = $(this).attr('data-href');
        return false;
      }
  });

  // calculations for elements that changes size on window resize
  var windowResizeHandler = function() {
      windowHeight = window.innerHeight;
      headerHeight = $('#header').height(); //.HeaderBlock
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
  // Header search icon transition
  $('.search input').focus(function() {
      $('.searchIcon').addClass('active');
  });
  $('.search input').blur(function() {
      $('.searchIcon').removeClass('active');
  });

  // functionality for map manipulation icon on mobile devices
  var listMapView = function(target_class_list){
      if ($('#mapViewSearch').hasClass('mob-min') || 
          $('#mapViewSearch').hasClass('mob-max') || 
          $('#content').hasClass('mob-min') || 
          $('#content').hasClass('mob-max')) {
          $('#mapViewSearch').toggleClass('mob-max');
          $('#content').toggleClass('mob-min');
      } else {
          $('#content').toggleClass('min');
          $('#mapViewSearch').toggleClass('max');
      }
      
      if(target_class_list.includes('mapHandler')){
        //initialize(); TOFIX: Not retaining prev zoom value
        if(map && featured_building_id){
          loadMarkerWindow(featured_building_id, map, featured_marker);
          infobox_opened = true
        }
        map.setZoom(parseInt(localStorage.mapZoom));
        var center = map.getCenter()
        map.setCenter(new google.maps.LatLng(center.lat(), center.lng()));
      }else {
        if(infobox_opened){
          infobox.close();
        }
      }
      
      setTimeout(function() {
        if(map && redo_search){
          map.setCenter(new google.maps.LatLng(lat,lng));
        }
      }, 1000);
  }

  /* end show page */
  
  $('.listHandler').click(function(e){
      $(this).hide();
      $('.mapHandler').show();
      draggedOnce = false;
      // redoControlUI.remove();
      listMapView([...e.currentTarget.classList]);
      $('.sorted_by_option').show();
      // Only when redo search
      // images are not loading on hidden element
      var props = $('.searched-properties');
      if(props.hasClass('invisible')){
          props.removeClass('invisible').removeClass('min');
      }
      setSerchViewTypeSession('listView');
  })
  
  $('.mapHandler').click(function(e) {
      if(!$(this).hasClass('show-map-handler')){
          $(this).hide();
      }
      $('.listHandler').show();
      listMapView([...e.currentTarget.classList]);
      $('.sorted_by_option').hide()
      setSerchViewTypeSession('mapView');
  });

  var setSerchViewTypeSession = function(view_type){
      $.ajax({
          url: '/set_split_view_type',
          beforeSend: function(xhr){
              xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
          },
          type: 'post',
          dataType: 'json',
          data: {view_type: view_type},
          success: function(response){
              // console.log(response)
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

  
  $('.applyFilter').click(function(e) {
      e.preventDefault();
      $('.btn-submit-filter-form').click();
  });

  // Rotating image overlay...
  $('.rotate').click(function(){
    $('.loading').removeClass('hidden');
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
  $('.sorted-by').click(function(){})

  $(document).on('click', 'select#sort', function(){});

  //
  // For mobile neighborhoods dropdown toggle
  $('.dropdown-toggle-neighborhoods, .closeHoods').click(function(e) {
    $('.popular-neighborhoods').slideToggle(200, 'linear', function(){
      var elem             = $('#wrapper.screen-sm');
      var toggleable_class = 'no-touch-scroll'
      $(this).is(':hidden') ? elem.removeClass(toggleable_class) : elem.addClass(toggleable_class);
    });
  });

})(jQuery);