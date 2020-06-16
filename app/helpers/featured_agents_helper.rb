module FeaturedAgentsHelper
	def billing_or_agent_list_path
    @featured_agent.expired? ? 
    new_manager_featured_agent_user_path(current_user, type: 'billing', object_id: @featured_agent.id) :
    managertools_user_path(current_user, type: 'featured')
  end

  def agent_image upload
  	upload.present? ? upload.image.url : 'user-missing2.png'
  end

  def bedrooms_options
  	['Studio','1 Bedroom','2 Bedroom','3 Bedroom','4+ Bedroom']
  end

	def budgets_options
		[	
			'$1,750',
			'$2,000',
			'$2,500',
			'$3,000',
			'$3,500',
			'$4,000',
			'$4,500',
			'$5,000',
			'$6,000',
			'$7,000',
			'$8,000',
			'$9,000',
			'$10,000',
			'$12,500',
			'$15,000'
			]
	end

	def message
		'Hi,
I am looking for an agent to help me with my rental apartment search.
Thank you!'
	end
end
