$(document).on 'click', '.favourite', () ->
	if $(this).hasClass('filled-heart')
		removeFavorite($(this))

@removeFavorite =(elem)->
	object_id = elem.data('objectid')
	save_link = $('.save_link_'+object_id);
	if elem.hasClass('unfilled-heart')
		save_link.removeClass('unfilled-heart').addClass('filled-heart')
		save_link.css('color','#f16980')
		save_link.prop('href', 'javascript:;')
		save_link.removeAttr('data-remote')
	else
		bootbox.confirm
			message: 'Are you sure, you want to remove this post?'
			size: 'small'
			buttons:
				'cancel':
					label: 'No'
					className: 'btn-default btn-sm'
				'confirm':
					label: 'Remove'
					className: 'btn-success btn-sm'
			callback: (result) ->
				if result
					unfavorite(object_id, save_link)

unfavorite = (object_id, save_link) ->
	$.ajax
		url: '/unfavorite.json'
		type: 'get'
		dataType: 'json'
		data: { object_id: object_id }
		success: (response) ->
			save_link.removeClass('filled-heart').addClass('unfilled-heart')
			save_link.css('color','#b1b3b6')
			save_link.prop('href', '/favorite?object_id='+object_id)
			save_link.attr('data-remote', 'true')



