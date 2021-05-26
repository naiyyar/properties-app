class ContactsController < ApplicationController
  #load_and_authorize_resource
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = Contact.order(created_at: :desc)
                       .paginate(:page => params[:page], :per_page => 100)
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  def about
    @meta_desc = "NYC's listing platform that connects Renters directly to Management Companies, Property Managers and Individual Landlords."
    @search_bar_hidden = :hidden
  end

  # GET /contacts/new
  def new
    @building = Building.find_by(id: params[:building_id])
    @min_save_amount = @building.present? ? @building.min_save_amount : 0
    @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        notice = @contact.building_id.present? ? 'Email' : 'Feedback'
        format.html { redirect_to request.referer, notice: "#{notice} successfully sent." }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { redirect_to request.referer, flash[:error] => @contact.errors }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:name, :email, :comment, :phone, :building_id, :user_id)
    end
end
