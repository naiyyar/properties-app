module FeaturedAgentsHelper
	def billing_or_agent_list_path
    @featured_agent.expired? ? 
    new_manager_featured_agent_user_path(current_user, type: 'billing', object_id: @featured_agent.id) :
    managertools_user_path(current_user, type: 'featured')
  end
end
