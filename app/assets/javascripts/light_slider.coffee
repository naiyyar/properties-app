jQuery ->
	
	$('.gallery').lightSlider
		item: 1
		slideMargin: 0
		loop: true
		onBeforeSlide: (el) ->
			show_count_elem = el.parent().parent().prev()
			current_elem = show_count_elem.find('.current')
			current_elem.text(el.getCurrentSlideCount)
			#el.fetchAssets

	#when slider is not loading on tab active so NEED TO RESIZE
	#$('[href="#building_managed"]').on 'shown.bs.tab', ->
	#	$('.gallery').resize()