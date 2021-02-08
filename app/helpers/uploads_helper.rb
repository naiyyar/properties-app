module UploadsHelper

	def seel_all_link building_id, images_count, see_all_class=nil
		link_to "<span style='color: #333;' class='fa fa-th-large'></span> See all(#{images_count})".html_safe, 
						building_uploads_path(building_id: building_id), 
						class: "btn btn-o btn-sm #{see_all_class}"
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

	def edit_upload_link upload
		link_to '<span class="fa fa-trash" />'.html_safe, upload_path(upload), method: :delete, remote: true, class: 'btn btn-danger btn-xs delete_image'
	end

	def delete_upload_link upload
		link_to '<span class="fa fa-edit" />'.html_safe, edit_upload_path(upload, upload_type: 'image'), remote: true, class: 'btn btn-primary btn-xs edit_image'
	end

end
