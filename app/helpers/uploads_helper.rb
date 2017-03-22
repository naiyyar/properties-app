module UploadsHelper

	def object_upload_path object
		if object.kind_of? Building
			new_building_upload_path(building_id: object)
		else
			new_unit_upload_path(unit_id: object)
		end
	end
end
