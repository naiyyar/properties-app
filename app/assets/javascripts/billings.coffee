jQuery ->
	if $('.delete-card').length > 0
		$(document).on 'click', '.delete-card', (e) ->
			e.preventDefault
			$this 						 	= $(this)
			update_customer_id 	= false
			cards 							= $('.table-saved-cards td.card-detail')
			c_id 								= $this.data('cid')
			if cards.length <= 1
				update_customer_id = true
			
			$.ajax
				url: '/delete_card'
				dataType: 'json'
				type: 'GET'
				data: {card_id: c_id, update_customer_id: update_customer_id }
				success: (response) ->
					console.log(response)
					$this.parent().parent().remove()
				error: (response) ->
					console.log(response)
