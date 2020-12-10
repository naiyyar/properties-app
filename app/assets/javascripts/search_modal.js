var ready = function(){
	if(mobile){
		var search_box 		= $('#search_term');
		var search_modal 	= $('#search-modal');
		var search_form 	= $('#apt-search-form');
		var clear_icon 		= $('#clear-icon');

		$('#search-input-placeholder').on('click', function(){
	    search_modal.css('z-index', '99999').show();
	    search_box[0].focus();
	    clearSearchField();
		});

		$('.fa-arrow-left').on('click', function(){
			hideClearIcon();
		  search_modal.hide();
		});

		search_box.on('keyup', function(){
			if($(this).val() != ''){			
				showClearIcon();
			}else{
				hideClearIcon();
			}
		});
		
		clear_icon.on('click', function(){
			clearSearchField();
		});

		function clearSearchField(){
			$(search_box).val('');
			setTimeout(function(){
				hideClearIcon();
			}, 400)
		}

		function showClearIcon(){
			if(clear_icon.is(':hidden')){
				clear_icon.show();
			}
		}

		function hideClearIcon(){
			if(!clear_icon.is(':hidden')){
				clear_icon.hide();
			}
		}
	}

} // close ready

$(document).ready(ready)
$(document).on('page:load', ready)