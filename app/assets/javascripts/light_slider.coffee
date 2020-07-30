jQuery ->
	if($('.sh-slider-container').length > 0 )
		thumb_images_length = $('.lSPager.lSGallery').children().length
		add_class 					= if thumb_images_length == 0 then 'no-thumb' else 'with-thumb'
		
		$('.gallery').lightSlider
			gallery: true
			item: 1
			slideMargin: 0
			loop: true
			thumbItem: 6
			galleryMargin: 1
			addClass: add_class
			onBeforeSlide: (el) ->
				show_count_elem = el.parent().parent().prev()
				current_elem = show_count_elem.find('.current')
				current_elem.text(el.getCurrentSlideCount)

		$().fancybox
			selector: '.lightSlider .lslide a'
			backFocus : false
			buttons : [
	      'thumbs',
	      'close'
	    ]

	  # Changing slider image width when no thumb images available
	  #thumb_images_length = $('.lSPager.lSGallery').children().length
	  #if(thumb_images_length <= 0)
	  #	slider = $('.sh-slider-container .lSSlideWrapper')
	  #	slider.css({'max-width': '100% !important', 'float': 'left !important;'})
	
	else
		$('.gallery').lightSlider
			item: 1
			slideMargin: 0
			loop: true
			onBeforeSlide: (el) ->
				show_count_elem = el.parent().parent().prev()
				current_elem = show_count_elem.find('.current')
				current_elem.text(el.getCurrentSlideCount)


	#when slider is not loading on tab active so NEED TO RESIZE
	#$('[href="#building_managed"]').on 'shown.bs.tab', ->
	#	$('.gallery').resize()