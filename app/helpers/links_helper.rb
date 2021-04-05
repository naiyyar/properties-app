module LinksHelper
	def append_tour_link tourable, category, last_tour:nil
		tourable_type = tourable.class.name
		link_to add_video_text(tourable_type), 
						new_video_tour_path(category: category, 
																tourable_id: tourable.id, 
																tourable_type: tourable_type, 
																sort_index: sort_num(last_tour)), 
						class: 'add-tour-form', remote: true
	end

	def add_video_text(tourable_type)
		if tourable_type == 'Building'
			plus_icon
		else
			"Add Video #{plus_icon}".html_safe
		end
	end

	def sort_num last_tour
		last_tour.present? ? last_tour.sort + 1 : 0
	end

	def renew_switch_button object, disabled: false
		disabled_class = disabled ? 'disabled' : ''
		checked = object.renew ? 'checked' : ''
		return "<input type='checkbox' 
						class='#{switch_button_classes} renew #{disabled_class} #{object_class(object)}' 
						style='margin: 0px;' 
						data-field='renew'
						#{checked} #{disabled_class}
						data-fbid=#{object.id} />".html_safe
	end

	def active_switch_button object, fbby: '', showbillingurl: false
		content_tag(:input, 
								nil, 
								:type => 'checkbox',
								checked: object.active,
								:class => "#{switch_button_classes} #{object_class(object)}",
								:style => 'margin: 0px;',
								data: { 
												fbid: object.id, 
												fbby: fbby, 
												expired: (object.expired? ? 'expired' : ''),
												billingurl: (showbillingurl ? billing_url(object) : '')
											}
								)
	end

	def switch_button_classes
		'apple-switch sb-sm'
	end

	def object_class object
		object.class.name.split(/(?=[A-Z])/).join('-').downcase rescue ''
	end

	def billing_url object
		return '' unless object.expired?
 		
 		case object.class.name
		when 'FeaturedListing'
			next_prev_step_url(object, step: 'payment')
		when 'FeaturedAgent'
			new_manager_featured_agent_user_path(current_user, type: 'billing', object_id: object.id)
		when 'FeaturedBuilding'
			new_manager_featured_building_user_path(current_user, type: 'billing', object_id: object.id)
		end
	end

	def previous_link url
		site_link_h(text: '← Previous', 
								url: url, 
								klasses: "#{action_btn_classes} btn-o font-bold", 
								style: action_link_styles)
	end

	def next_link url
		site_link_h(text: next_text, 
								url: url, 
								klasses: "#{action_btn_classes} font-bold", 
								style: action_link_styles)
	end

	def done_link url
		site_link_h(text: 'Done', 
							  url: url, 
							  klasses: "#{action_btn_classes} btn-done font-bold",
							  style: action_link_styles)
	end

	def cancel_link url
		site_link_h(text: 'Cancel', url: url, klasses: "cancel #{btn_default_h} #{font_size16_h} font-bold")
	end

	def submit_link form, title:'Submit', disabled: false
		form.submit title, 
								class: 'btn btn-primary font-16 pl-28 pr-28 font-bold', 
								disabled: disabled, 
								style: action_link_styles
	end

	def next_text
		'Next →'
	end

	def neighborhood_link nb, target: ''
		nb = 'Midtown' if nb == 'Midtown Manhattan'
		return '' if nb.blank?
    search_by_neighborhood_link(nb, 'MANHATTAN', target: target,  show_count: false) 
	end

	def search_by_neighborhood_link nb, area, target: '' , show_count: true
		link_to search_link(nb, area), target: target, data: { nbname: nb, st: searchable_text(nb, area) } do
			if show_count
				neighborhood = @pop_nb_hash[nb]
				if neighborhood.present?
					neighborhood_link_link_title(nb, neighborhood[0].buildings_count)
				else
					"#{nb} (#{parent_neighborhoods_count(nb)})"
				end
			else
				nb
			end
		end
	end

	def neighborhood_link_link_title nb, count=0
		"#{nb} (<span>#{count}</span>)".html_safe
	end

	def check_availability_link building, sl_class=nil
		if CTALinksPolicy.new(building).active_web_url?
			bt_block_class = sl_class.present? ? sl_class : 'btn-block'
      link_to check_availability, building.web_url, 
      														onclick: "window.open(this.href,'_blank');return false;",
      														class: "btn #{bt_block_class} btn-primary txt-color-white font-bolder btn-round",
      														style: "padding: #{bt_block_class.include?('btn-xs') ? '8px 0px' : ''}"
    else
      link_to check_availability, building_url(building), class: 'btn btn-block btn-primary invisible'
    end
	end

	#
	def check_availability_button web_url, klass
		unless browser.device.mobile?
			link_to check_availability, 
						  web_url,
						  class: "btn btn-primary #{klass} btn-round ca",
						  target: '_blank', rel: rel
		else
			link_to check_availability, 
						  web_url,
						  class: "btn btn-primary #{klass} btn-round ca",
						  onclick: "window.open(this.href,'_blank');return false;", rel: rel
		end
	end

	def contact_leasing_button building, event, klass
		link_to 'Contact Leasing', 'javascript:;', 
																onclick: "showLeasingContactPopup(#{building.id})", 
																 class: "btn btn-primary #{klass} btn-round"
	end

	def active_listings_button building, event, klass, listings_count
		link_to "#{listings_count} Active Listings" , 'javascript:;', 
																									onclick: "showActiveListingsPopup(#{building.id})", 
																									class: "btn btn-primary active-listing-link #{klass} btn-round"
	end

	def apply_online_link building
		link_to 'Apply Online', building.online_application_link, 
														class: 'btn btn-primary btn-o btn-block font-bolder btn-round', 
														target: '_blank', rel: rel
	end

	def schedule_tour_link building, klasses
		link_to 'Schedule Tour', building.schedule_tour_url,
														class: "btn btn-primary #{klasses} btn-round", 
														target: '_blank', rel: rel
	end

	def contact_leasing_link building, bg_col='', sl_class=''
		bt_block_class = sl_class.present? ? sl_class : 'btn-block'
		link_to 'Contact Leasing Team', new_contact_path(building_id: building.id), 
																		class: "btn btn-primary #{bg_col} #{bt_block_class} txt-color-white font-bolder btn-round sh-contact-leasing", 
																		remote: true
	end

	def check_availability
		'<b>Check Availability</b>'.html_safe
	end

	def action_link_styles
		"width: #{browser.device.mobile? ? '8em' : '10em'};"
	end

	def action_links_alignment_class
		browser.device.mobile? ? 'text-center' : 'text-right'
	end

	def delete_link url, remote: false, classes: ''
		link_to '<span class="fa fa-times"></span>'.html_safe, 
						url, 
						method: :delete, 
						remote: remote, 
						class: "text-danger #{classes}", 
						title: 'Delete'
	end

	def site_link_h text: '', url: '#', klasses: '', style: ''
		link_to text, url, class: klasses, style: style
	end

	def action_btn_classes
		"btn btn-primary #{font_size16_h} pl-28 pr-28"
	end

	def font_size16_h
		'font-16'
	end

	def btn_default_h
		'btn btn-default'
	end

	def rel
		'noreferrer'
	end
end