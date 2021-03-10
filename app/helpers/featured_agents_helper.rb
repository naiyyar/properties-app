module FeaturedAgentsHelper
	def billing_or_agent_list_path
    @featured_agent.expired? ? 
    new_manager_featured_agent_user_path(current_user, type: 'billing', object_id: @featured_agent.id) :
    managertools_user_path(current_user, type: 'featured')
  end

  def new_featured_agent_link
    link_to 'Add New Featured Agent', 
            new_manager_featured_agent_user_path(current_user, type: 'featured'), 
            class: 'btn btn-primary'
  end

  def done_or_next_path
  	if !@featured_agent.active && @featured_agent.featured_by_manager?
  		wizard_path(:payment, agent_id: @featured_agent.id) 
  	else
  		agenttools_dashboard_path(@featured_agent)
  	end
  end

  def work_with_button agent, klass=''
  	link_to "Work With #{agent.first_name}", 'javascript:;', 
																							onclick: "agentContactForm(#{agent.id})",
																 							class: "btn btn-primary #{klass} btn-round"
  end

  def agenttools_dashboard_path fa
  	fa.featured_by_manager? ? agenttools_user_path(current_user, type: 'featured')  : featured_agents_path
  rescue
  	featured_agents_path
  end

  def agent_image upload
  	upload.present? ? upload.image.url : 'user-missing2.png'
  end

	def message
		'Hi,

I am looking for an agent to help me with my rental apartment search.

Thank you!'
	end
end
