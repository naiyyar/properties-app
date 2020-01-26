class BillingsController < ApplicationController
  load_and_authorize_resource
  before_action :set_billing, only: [:show, :edit, :update, :destroy, :email_receipt]
  before_action :set_customer_id, only: [:show, :pay_using_saved_card]
  before_action :get_card, only: [:show]
  
  def index
    @limit    = 51
    @billings = @current_user.billings.limit(@limit)
  end

  def show
    @view = 'pdf'
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
      format.pdf do
        render wicked_pdf_options("invoice_#{@billing.created_at.strftime('%d-%m-%Y')}", 'billings/show')
      end
    end
  end

  def email_receipt
    if params[:email_to].present?
      params[:email_to].split(',').each do |email|
        BillingMailer.send_payment_receipt(billing: @billing, 
                                           to_email: email.gsub(' ', ''), 
                                           view: params[:view]).deliver
      end
      flash[:notice] = 'Invoice successfully sent.'
    else
      flash[:error] = 'No email specified.'
    end
    redirect_to :back
  end

  def new
    @billing = Billing.new
  end

  def create_new_card
    billing_service = BillingService.new(params[:billing][:stripe_card_id], params[:email])
    begin
      billing_service.create_source(billing_service.get_customer_id(current_user))
    rescue Stripe::CardError => e
      puts "ERROR: #{e.message}"
    end
    
    respond_to do |format|
      format.html { redirect_to managertools_user_path(current_user, type: 'billing'), notice: 'Card successfully saved.' }
    end
  end

  def delete_card
    customer_id = current_user&.stripe_customer_id
    Stripe::Customer.delete_source(customer_id, params[:card_id]) if customer_id.present?
    render json: { status: :ok, success: true }
  end

  def pay_using_saved_card
    @billing = Billing.new(billing_params)
    respond_to do |format|
      if @billing.save_and_charge_existing_card!(customer_id: @customer_id, card_id: billing_params[:billing_card_id])
        format.html {
          redirect_to managertools_user_path(current_user, type: 'featured'), notice: 'Billing was successfully created.' 
        }
      else
        format.html { 
          flash[:error] = @billing.errors.messages[:credit_card][0]
          redirect_to :back 
        }
      end
    end
  end

  def create
    @billing = Billing.new(billing_params)
    respond_to do |format|
      if @billing.save_and_make_payment!
        format.html { redirect_to managertools_user_path(current_user, type: 'featured'), notice: 'Billing was successfully created.' }
        format.json { render :show, status: :created, location: @billing }
      else
        format.html { 
          flash[:error] = @billing.errors.messages[:credit_card][0]
          redirect_to :back 
        }
        format.json { render json: @billing.errors, status: :unprocessable_entity }
      end
    end
  end

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

  def destroy
    @billing.destroy
    respond_to do |format|
      format.html { redirect_to billings_url, notice: 'Billing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_billing
      @billing = Billing.find(params[:id])
    end

    def billing_params
      params.require(:billing).permit(:user_id, :featured_building_id, :amount, :stripe_card_id, :email, :description, :billing_card_id, :brand, :last4)
    end

    def set_customer_id
      @customer_id = current_user.stripe_customer_id
    end

    # TODO: TO REMOVE WHEN MERGING WITH PRODUCTION
    def get_card
      if request.format.pdf? or params[:type] == 'view'
        @card = BillingService.new.get_card(@customer_id, @billing.billing_card_id) rescue nil
      end
    end
end
