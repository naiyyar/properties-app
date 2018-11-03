$(document).on 'click', '.favourite',(e) ->
	object_id = $(this).data('objectid')
	save_link = $('.save_link_'+object_id);
	if $(this).hasClass('unfilled-heart')
		save_link.removeClass('unfilled-heart').addClass('filled-heart')
		save_link.css('color','#f16980')
		save_link.prop('href', 'javascript:;')
		save_link.removeAttr('data-remote')
	else
		$.confirm
			title: 'Are you sure you want to remove this?'
			content: ''
			buttons:
				remove:
					btnClass: 'btn-success'
					action: ->
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
				cancel: ->
					console.log('Successfully canceled')


