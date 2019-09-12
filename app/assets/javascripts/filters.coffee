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
		$('.filterForm input[type=checkbox]').not(":disabled").attr('checked', false)
		$('.filterForm input[type=radio]').not(":disabled").attr('checked', false)

	#when building_bed checkbox checked and then listing_bed is selected then mark building_beds to false
	$(document).on 'click', '.listing_bed_filter', (e) ->
		resetBuildingBed()
		resetBuildingPrice()

	#when listing_bed checkbox checked and then building_bed is selected then mark listing_bed to false
	$(document).on 'click', '.building_bed_filter', (e) ->
		resetListingBed()
		resetListingPrice()
		resetSlider()

	#when building_price checkbox checked and then listing_price is selected then mark building_price to false
	#
	$(document).on 'click', '.building_price_filter', (e) ->
		resetListingBed()
		resetSlider()

	$(document).on 'click', '#listings_price_box', (e) ->
		resetBuildingBed();
		resetBuildingPrice();

	#$(document).on 'click', '.building_bed_filter', (e) ->
	#	checked = $(this).is(':checked')
	#	$(".building_bed_filter").prop('checked',false)
	#	if checked
	#		$(this).prop('checked',true)

	#appending checked filter count to filter button
	checked_filter_count = $('.filterForm input[type=checkbox]:checked').length
	if checked_filter_count > 0
		$('.filter-counts').text('('+checked_filter_count+')')

	
	# ********* Methods ********
	#
	#

	resetBuildingBed=->
		if $('.building_bed_filter:checked').length > 0
			$('.building_bed_filter').prop('checked', false)

	resetBuildingPrice=->
		if $('.building_price_filter:checked').length > 0
			$('.building_price_filter').prop('checked', false)

	resetListingPrice=->
		if $('.listing_price_filter:checked').length > 0
			$('.listing_price_filter').prop('checked', false)

	resetListingBed=->
		if $('.listing_bed_filter:checked').length > 0
			$('.listing_bed_filter').prop('checked', false)
	
	resetSlider=->
		$('.priceSlider').slider
			range: true
			min: 0
			max: 15500
			values: [0, 2000]
			step: 500

		$('#listings_price_box').prop('checked', false);
		$('.priceSlider .sliderTooltip .stLabel').html('$' + $('.priceSlider').slider('values', 0).toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,") + ' <span class="fa fa-arrows-h"></span> ' + '$' + $('.priceSlider').slider('values', 1).toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,"))
    
		priceSliderRangeLeft = parseInt($('.priceSlider .ui-slider-range').css('left'))
		priceSliderRangeWidth = $('.priceSlider .ui-slider-range').width()
		priceSliderLeft = priceSliderRangeLeft + ( priceSliderRangeWidth / 2 ) - ( $('.priceSlider .sliderTooltip').width() / 2 );
		$('.priceSlider .sliderTooltip').css('left', priceSliderLeft);
		$('#min_price').val(0);
		$('#max_price').val(2000);