module UploadsHelper

	def object_upload_path object
		if object.kind_of? Building
			new_building_upload_path(building_id: object)
		else
			new_unit_upload_path(unit_id: object)
		end
	end

	def date_uploaded object
		"<b>#{ associated_object(object.imageable) }</b> <p>Date uploaded: #{ object.created_at.strftime('%m/%d/%Y') }</p>".html_safe
	end
	
	def associated_object imageable
		if imageable.class.name == 'Unit'
			imageable.name
		else
			#imageable.building_name
		end
	end

end
