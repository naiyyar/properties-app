class BillingsController < ApplicationController
  load_and_authorize_resource
  before_action :set_billing, only: [:show, :edit, :update, :destroy, :email_receipt]
  before_action :get_card, only: [:show]
  # GET /billings
  # GET /billings.json
  def index
    @limit       = 51
    @billings    = @current_user.billings.limit(@limit)
  end

  # GET /billings/1
  # GET /billings/1.json
  def show
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
      format.pdf do
        render wicked_pdf_options("invoice_#{@billing.created_at.strftime('%d-%m-%Y')}",'billings/show')
      end
    end
  end

  def email_receipt
    if params[:email_to].present?
      params[:email_to].split(',').each do |email|
        BillingMailer.send_payment_receipt(@billing, @card, email.gsub(' ', '')).deliver
      end
      flash[:notice] = 'Invoice successfully sent.'
    else
      flash[:error] = 'No email specified.'
    end
    redirect_to :back
  end

  # GET /billings/new
  def new
    @billing = Billing.new
  end

  def create_new_card
    billing_service = BillingService.new(params[:billing][:stripe_card_id], params[:email])
    billing_service.create_source(billing_service.get_customer_id(current_user))
    
    respond_to do |format|
      format.html { redirect_to managertools_user_path(current_user, type: 'billing'), notice: 'Card successfully saved.' }
    end
  end

  def delete_card
    Stripe::Customer.delete_source(params[:customer_id], params[:card_id])
    current_user.update(stripe_customer_id: nil) if params[:update_customer_id] == 'true'
    render json: { status: :ok, success: true }
  end

  def pay_using_saved_card
    @billing = Billing.new(billing_params)
    respond_to do |format|
      if @billing.create_charge_existing_card!(current_user.stripe_customer_id, params[:card_id])
        format.html { 
          redirect_to managertools_user_path(current_user, type: 'featured'), notice: 'Billing was successfully created.' 
        }
      else
        format.html { 
          flash[:error] = @billing.errors.messages[:credit_card]
          redirect_to :back 
        }
      end
    end
  end

  # POST /billings
  # POST /billings.json
  def create
    @billing = Billing.new(billing_params)
    respond_to do |format|
      if @billing.save_and_make_payment!
        format.html { redirect_to managertools_user_path(current_user, type: 'featured'), notice: 'Billing was successfully created.' }
        format.json { render :show, status: :created, location: @billing }
      else
        format.html { 
          flash[:error] = @billing.errors.messages[:credit_card]
          redirect_to :back 
        }
        format.json { render json: @billing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /billings/1
  # PATCH/PUT /billings/1.json
  def update
    respond_to do |format|
      if @billing.update(billing_params)
        format.html { redirect_to @billing, notice: 'Billing was successfully updated.' }
        format.json { render :show, status: :ok, location: @billing }
      else
        format.html { render :edit }
        format.json { render json: @billing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /billings/1
  # DELETE /billings/1.json
  def destroy
    @billing.destroy
    respond_to do |format|
      format.html { redirect_to billings_url, notice: 'Billing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_billing
      @billing = Billing.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def billing_params
      params.require(:billing).permit(:user_id, :featured_building_id, :amount, :stripe_card_id, :email, :description)
    end

    def get_card
      if request.format.pdf? or params[:type] == 'view'
        @card = BillingService.new.get_card(current_user.stripe_customer_id, @billing.billing_card_id) rescue nil
      end
    end
end