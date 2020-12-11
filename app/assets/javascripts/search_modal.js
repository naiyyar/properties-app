var ready = function(){
	if(Device.type.mobile){
		var search_box 		= $('#search_term');
		var search_modal 	= $('#search-modal');
		var search_form 	= $('#apt-search-form');
		var clear_icon 		= $('#clear-icon');

		SearchModal = {
			showSearchModal: function (){
				search_modal.css('z-index', '99999').show();
		    setTimeout(function(){
		    	search_box[0].focus();
		    }, 200);
		    this.clearSearchField();
			},

			clearSearchField: function(){
				$(search_box).val('');
				var self = this;
				setTimeout(function(){
					self.hideClearIcon();
				}, 200)
			},

			showClearIcon: function(){
				if(clear_icon.is(':hidden')){
					clear_icon.show();
				}
			},

			hideClearIcon: function(){
				if(!clear_icon.is(':hidden')){
					clear_icon.hide();
				}
			}
		};

		$('.fa-arrow-left').on('click', function(){
			SearchModal.hideClearIcon();
		  search_modal.hide();
		});

		search_box.on('keyup', function(){
			if($(this).val() != ''){			
				SearchModal.showClearIcon();
			}else{
				SearchModal.hideClearIcon();
			}
		});
		
		clear_icon.on('click', function(){
			SearchModal.clearSearchField();
		});
	}
} // close ready

$(document).ready(ready)
$(document).on('page:load', ready)