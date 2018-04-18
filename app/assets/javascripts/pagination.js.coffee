jQuery ->
	$('.searched-properties').on 'scroll', ->
		more_buildings_url = $('.pagination .next_page').attr('href')
		if more_buildings_url and $(this).scrollTop() > $(document).height() - $(this).height() - 60
			$('.pagination').html('<img src="/assets/loader.gif" alt="Loading..." title="Loading..." />').show()
			$.getScript more_buildings_url
			return
		return