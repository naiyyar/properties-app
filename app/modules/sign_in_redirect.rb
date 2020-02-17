module SignInRedirect
	class << self
		include Rails.application.routes.url_helpers
		
		def redirect_path options
			session 			= options[:session]
			form_data 		= session[:form_data]
			object 				= options[:object]
			if form_data.present?
				contribution  = form_data['contribution']
	      if contribution.present?
	        building_contribution_path(object, contribution)
	      else
	        unit_contribution_path(object, form_data['unit_contribution'])
	      end
	    else
	      session[:return_to] || root_path
	    end
		end

		def building_contribution_path object, contribution
			case contribution
      when 'building_photos'
      	new_upload_path(building_id: object.id)
      when 'unit_photos'
      	new_unit_upload_path(object.id)
      else
        next_step_path(object, contribution)
      end
		end

		def next_step_path object, contribution
			if object.kind_of?(Building)
	      #To go to Reviews path
	      user_steps_path(building_id: 			object.id, 
	      								contribution_for: contribution, 
	      								contribution: 		contribution)
	    else
	      unit_path(object)
	    end
		end

		def unit_contribution_path obj, contribution
			obj_id = obj.id
			case contribution
	    when 'unit_photos'
	      new_unit_upload_path(obj_id)
	    when 'unit_price_history'
	      next_page_path(obj_id, 'unit_price_history')
	    when 'unit_amenities'
	    	next_page_path(obj_id, 'unit_amenities')
	    else
	      unit_path(obj)
	    end
		end

		def new_unit_upload_path obj_id
			new_upload_path(unit_id: obj_id)
		end

		def next_page_path obj_id, cont_for
			"/user_steps/next_page?contribution_for=#{cont_for}&unit_id=#{obj_id}"
		end
	end
end