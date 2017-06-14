jQuery ->

	$('#apt-search-txt, #apt-search-txt-searchpage, #buildings-search-txt').on 'keypress', (e) ->
		$(this).addClass('loader');