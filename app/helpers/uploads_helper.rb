module UploadsHelper

	def seel_all_link building_id, images_count
		link_to "<span style='color: #333;' class='fa fa-th-large'></span> See all(#{images_count})".html_safe, 
						building_uploads_path(building_id: building_id), 
						class: 'btn btn-o btn-sm see-all'
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
		else
			#imageable.building_name
		end
	end

end
