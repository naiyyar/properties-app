module ContactsHelper
	def phone_with_area_code object
		number_to_phone(object.phone, area_code: true)
	end

	def phone_with_area_code_link object
		link_to phone_with_area_code(object), "tel:#{object.phone}", class: 'hyper-link'
	end
end
