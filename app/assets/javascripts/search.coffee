jQuery ->

	$('#apt-search-txt, #apt-search-txt-searchpage').on 'keypress', (e) ->
		$(this).addClass('loader');