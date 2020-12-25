var ready = function(){
	if(Device.type.mobile){
			  history_ul    = $('#search-modal #ui-id-50') || null;
		var search_box 		= $('#search_term');
		var search_modal 	= $('#search-modal');
		var search_form 	= $('#apt-search-form');
		var clear_icon 		= $('#clear-icon');
		var added_items;
		
		SearchModal = {
			showSearchModal: function (){
				search_modal.css('z-index', '99999').show();
		    setTimeout(function(){
		    	search_box[0].focus();
		    }, 200);
		    
		    this.clearSearchField();
		    added_items = history_ul.find('li');
		    if(added_items.length == 0) {
		    	this.appendSearchHistoryItems();
		    }
		    history_ul.show();
			},

			clearSearchField: function(){
				$(search_box).val('');
				var self = this;
				setTimeout(function(){
					self.hideClearIcon();
				}, 200);
			},

			appendSearchHistoryItems: function() {
				var li_item, item;
				// li_item = '<li class="ui-menu-item curr-location" style="background: #fff; cursor: pointer;"> \
    //     						<a href="javascript:void(0);" class="hyper-link location" style="display: block;" onclick="getLocation()"> \
    //       						<span class="fa fa-location-arrow"></span> Current Location</a> \
    //   						</li>';
				li_item = LOC_LINK.locationLinkLi('ui-menu-item');
				history_ul.append(li_item)
				for(i = 0; i < prev_search_items.length; i++) {
					item    = prev_search_items[i];
					li_item = '<li class="ui-menu-item" id="ui-id-'+(i+20)+'" tabindex="-1"> \
											<span class="fa fa-history" style="color: #777;"></span> \
											<a href="'+item.desc+'">'+item.label+'</a> \
										</li>';
					history_ul.append(li_item);
				}
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

$(document).ready(ready);
$(document).on('page:load', ready);