class FeaturedAgentsController < ApplicationController
  load_and_authorize_resource
  before_action :set_featured_agent, except: [:index, :create, :new]
  before_action :set_uploads, only: [:preview, :get_images]
  before_action :set_neighborhoods, only: [:new, :edit, :contact]
  
  # GET /featured_agents
  # GET /featured_agents.json
  def index
    @filterrific = initialize_filterrific(
      FeaturedAgent,
      params[:filterrific],
      available_filters: [:search_query]
    ) or return
    @featured_agents = @filterrific.find
                                   .paginate(:page => params[:page], :per_page => 100)
                                   .order('created_at desc')
    @photos_count = @featured_agents.sum(:uploads_count)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def preview
    
  end

  def contact
    render json: { contact_form_html: render_contact_form_partial }
  end

  def contact_agent
    UserMailer.contact_agent(@featured_agent, params[:contact]).deliver
    UserMailer.contact_agent_sender_copy(@featured_agent, params[:contact]).deliver
    redirect_to :back, notice: 'Messsage successfully sent.'
  end

  def get_images
    render json: { html: render_slider_partial, cta_html: render_cta_partial}
  end

  # GET /featured_agents/1
  # GET /featured_agents/1.json
  def show
  end

  # GET /featured_agents/new
  def new
    session[:back_to]  = request.fullpath if params[:type] != 'billing'
    @featured_by       = params[:featured_by] 
    @featured_agent    = FeaturedAgent.new
    @price             = Billing::FEATURED_AGENT_PRICE
    @object_id         = params[:object_id]
    @object_type       = 'FeaturedAgent'
    @saved_cards       = BillingService.new(current_user).get_saved_cards rescue nil
  end

  # GET /featured_agents/1/edit
  def edit
  end

  # POST /featured_agents
  # POST /featured_agents.json
  def create
    @featured_agent = FeaturedAgent.new(featured_agent_params)

    respond_to do |format|
      if @featured_agent.save
        format.html { 
          redirect_to featured_agent_steps_path(agent_id: @featured_agent.id), notice: 'Featured agent was successfully created.' 
        }
        format.json { render :show, status: :created, location: @featured_agent }
      else
        format.html { render :new }
        format.json { render json: @featured_agent.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /featured_agents/1
  # PATCH/PUT /featured_agents/1.json
  def update
    respond_to do |format|
      if @featured_agent.update(featured_agent_params)
        format.html { redirect_to featured_agent_steps_path(agent_id: @featured_agent.id), notice: 'Featured agent was successfully updated.' }
        format.json { render :show, status: :ok, location: @featured_agent }
      else
        format.html { render :edit }
        format.json { render json: @featured_agent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /featured_agents/1
  # DELETE /featured_agents/1.json
  def destroy
    @featured_agent.destroy
    error_messages = @featured_agent.errors.messages
    if error_messages.present? && error_messages[:base].present?
      flash[:error] = @featured_agent.errors.messages[:base][0]
    else
      flash[:notice] = 'Featured agent was successfully deleted.'
    end
    redirect_to :back
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_featured_agent
    @featured_agent = FeaturedAgent.find(params[:id]) rescue nil
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def featured_agent_params
    params.require(:featured_agent).permit!
  end

  def set_uploads
    @uploads      = @featured_agent.uploads
    @images_count = @uploads.count
  end

  def set_neighborhoods
    @neighborhoods = [
      'Lower Manhattan',
      'Midtown Manhattan',
      'Upper East Side',
      'Upper West Side',
      'Upper Manhattan',
      'Brooklyn',
      'Queens',
      'Bronx'
    ]
  end

  def redirect_path
    @featured_agent.featured_by_manager? ? 
    billing_or_featured_list_path : 
    featured_agent_steps_path(agent_id: @featured_agent.id)
  end
  #featured_agent_steps_path(agent_id: @featured_agent.id)
  def billing_or_featured_list_path
    @featured_agent.expired? ? 
    new_manager_featured_agent_user_path(current_user, type: 'billing', object_id: @featured_agent.id) :
    featured_agent_steps_path(agent_id: @featured_agent.id)
  end

  def render_slider_partial
    render_to_string(:partial => '/home/lightslider', 
                     :locals => { object:       @featured_agent,
                                  images_count: @images_count,
                                  first_image:  @uploads[0],
                                  show_path:    '#'
                                }
                    )
  end

  def render_cta_partial
    render_to_string(:partial => '/featured_agents/cta_links', 
                     :locals => { agent: @featured_agent }
                    )
  end

  def render_contact_form_partial
    render_to_string(:partial => '/featured_agents/contact_agent_modal', 
                     :locals => { 
                        mobile: browser.device.mobile?,
                        :@featured_agent => @featured_agent,
                        :@neighborhoods => @neighborhoods,
                        :bedrooms_options => view_context.bedrooms_options,
                        :budgets_options => view_context.budgets_options
                      }
                    )
  end
end
