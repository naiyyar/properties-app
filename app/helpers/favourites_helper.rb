module FavouritesHelper
	# To save as favourite sending js request
	# to unsave as favourite sending json request
	def heart_link object, user
		@current_user = current_user || user
		link_to heart_icon, saved_object_url(object), 
												remote: remote(object), class: fav_classes(object), 
												title: heart_link_title(object), 
												data: { objectid: object.id }, 
												method: :post,
												'area-label' => heart_link_title(object),
												style: 'padding: 9px;'
	end

	def fav_classes object
		"favourite save_link_#{object.id} #{saved_color_class(object)}"
	end

	def remote object
		(object.favorite_by?(@current_user) ? false : true)
	end

	def saved_object_url object
		object.favorite_by?(@current_user) ? 'javascript:;' : favorite_path(object_id: object.id)
	end

	def heart_link_title(object)
		(@current_user.present? && object.favorite_by?(@current_user)) ? 'Unsave' : 'Save'
	end

	def saved_color_class(object)
		(@current_user.present? && object.favorite_by?(@current_user)) ? 'filled-heart' : 'unfilled-heart'
	end
end