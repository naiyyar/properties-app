jQuery ->
	
	#script to reapply filters and sort to clicked neighborhood
	$(document).on 'click', '.pop-neighborhood, .sort-item', (e) ->
		e.preventDefault
		if e.target.rel != 'sort'
			$('.filterForm #neighborhoods').val($(this).data('nbname'))
			$('.filterForm #search_term').val($(this).data('st'))

		$('.filterForm #sort_by').val($(this).data('sortindex'))
		$('a.applyFilter').click()

	#sorting mobile View
	$(document).on 'change', 'select#sort', (e) ->
		#search_term = $(this).data('searchTerm');
    #neighborhoods = $(this).data('neighborhoods');
    sort_val = $(this).val()
    $('.filterForm #sort_by').val(sort_val)
    $('a.applyFilter').click()

	#Clear filters
	$(document).on 'click', '.clearFilter', (e) ->
		e.preventDefault
		$('.filterForm input[type=checkbox]').attr('checked', false)
		$('.filterForm input[type=radio]').attr('checked', false)

	#making type and rating checkboxed behave like radio button
	$(document).on 'click', '.building_type_filter, .building_rating_filter', (e) ->
		checked = $(this).is(':checked')
		$(".building_type_filter, .building_rating_filter").prop('checked',false)
		if checked
			$(this).prop('checked',true)