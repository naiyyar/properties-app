module UploadsHelper

	def user_can_take_action? object
		current_user.admin? || photo_owner?(object)
	end

	def photo_owner? object
		object.user == current_user
	end

	def user_can_drag?
		current_user && current_user.admin?
	end

	def seel_all_link object, images_count, see_all_class=nil
		link_to see_all_link_title(images_count), 
						see_all_url(object), 
						class: "btn btn-o btn-sm #{see_all_class}"
	end

	def see_all_link_title images_count
		"<span style='color: #333;' class='fa fa-th-large'></span> See all(#{images_count})".html_safe
	end

	def see_all_url object
		"/#{object.class.table_name}/#{object.id}/uploads"
	end

	def object_upload_path object
		if object.kind_of? Building
			new_building_upload_path(building_id: object)
		else
			new_unit_upload_path(unit_id: object)
		end
	end
	
	def associated_object imageable
		if imageable.class.name == 'Unit'
			imageable.name
		end
	end

	def delete_upload_link upload
		link_to trash_icon_helper, upload_path(upload), method: :delete, remote: true, class: 'btn btn-danger btn-xs delete_image'
	end

	def edit_upload_link upload
		link_to edit_icon_helper, edit_upload_path(upload, upload_type: 'image'), remote: true, class: 'btn btn-primary btn-xs edit_image'
	end

	def rotate_image_link upload
		link_to repeat_icon_helper, rotate_upload_path(upload), class: 'btn btn-warning btn-xs rotate'
	end

	def slider_data_attribute object
		{ objectid: "#{object.id}", view_type: 'show', path: object_show_path(object) }
	end

	def object_show_path object
		object.kind_of?(Building) ? 
		building_path(object) : 
		show_featured_listing_path(id: object.id, address: url_address(object))
	end

	def type_featured_listing? object
		object.imageable_type == 'FeaturedListing'
	end

	def featurable_class sort, featured_image: false
		featured_image && sort.to_i == 0 ? 'fl-featured-image' : ''
	end

	def add_tour_link tourable, klass: ''
		link_to 'Add Tour', 
						new_video_tour_path(tourable_id: tourable.id, tourable_type: tourable.class.name), 
						class: "btn btn-o btn-primary btn-sm #{klass}"
	end

	def add_photos_link imageable, klass:
		link_to 'Add Photo', 
						new_building_upload_path(building_id: imageable.id, upload_type: 'photos'), 
						class: "btn btn-o btn-primary btn-sm btn-round #{klass}" 
	end

end
