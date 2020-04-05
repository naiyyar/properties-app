jQuery ->
	
	if $('.usefulButton').length > 0
		$(document).on 'click', '.usefulButton', (e)->
			e.preventDefault()
			review_id = $(this).data('reviewid')
			user_id = $(this).data('userid')
			$this = $(this)
			$.ajax
					url: '/useful_reviews'
					type: 'POST',
					dataType: 'json'
					beforeSend: (xhr) ->
						xhr.setRequestHeader 'X-CSRF-Token', $('meta[name="csrf-token"]').attr('content')
					data: { useful_review: { review_id: review_id, user_id: user_id } }
					success: (response) ->
						$this.addClass('disabled')
						count_container = $this.find('span')
						total_count = parseInt(count_container.text())
						count_container.text(total_count+1)
					error: (response) ->
						#console.log(response)
