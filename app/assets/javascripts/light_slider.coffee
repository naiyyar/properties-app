jQuery ->
	
	$('.gallery').lightSlider
		item: 1
		slideMargin: 0
		loop: true
		onBeforeSlide: (el) ->
			show_count_elem = el.parent().parent().prev()
			current_elem = show_count_elem.find('.current')
			current_elem.text(el.getCurrentSlideCount)
			el.fetchAssets