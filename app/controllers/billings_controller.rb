class BillingsController < ApplicationController
  load_and_authorize_resource
  before_action :set_billing,     only: [:update, :destroy]
  before_action :set_customer_id, only: [:pay_using_saved_card]
  
  def index
    @billings = @current_user.billings.limit(50)
  end

  def show;end

  def email_receipt
    if params[:email_to].present?
      Billings::SendPaymentReceiptJob.perform_later( params[:id],
                                                     current_user.id,
                                                     params[:email_to])
      flash[:notice] = 'Invoice successfully sent.'
    else
      flash[:error] = 'No email specified.'
    end
    redirect_to request.referer
  end

  def new
    @billing = Billing.new
  end

  def create_new_card
    billing_service = BillingService.new(current_user, params[:billing][:stripe_card_id])
    begin
      billing_service.create_source(billing_service.get_customer_id)
    rescue Stripe::CardError => e
      puts "ERROR: #{e.message}"
    end
    
    respond_to do |format|
      format.html { 
        redirect_to managertools_user_path(current_user, type: 'billing'), notice: 'Card successfully saved.'
      }
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
      if @billing.save_and_charge_existing_card!( user: current_user,
                                                  customer_id: @customer_id,
                                                  card_id: billing_params[:billing_card_id]
                                                )
        format.html {
          redirect_to redirect_path, notice: 'Billing was successfully created.'
        }
      else
        format.html { 
          flash[:error] = @billing.errors.messages[:credit_card][0]
          redirect_to request.referer
        }
      end
    end
  end

  def create
    @billing = Billing.new(billing_params)
    respond_to do |format|
      if @billing.save_and_make_payment!
        format.html { 
          redirect_to redirect_path, notice: 'Billing was successfully created.' 
        }
        format.json { render :show, status: :created, location: @billing }
      else
        format.html { 
          flash[:error] = @billing.errors.messages[:credit_card][0]
          redirect_to request.referer
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
      params.require(:billing).permit(:user_id,
                                      :billable_id, 
                                      :billable_type,
                                      :amount, 
                                      :stripe_card_id, 
                                      :email, 
                                      :description, 
                                      :billing_card_id, 
                                      :brand, 
                                      :last4)
    end

    def set_customer_id
      @customer_id = current_user.stripe_customer_id
    end

    def redirect_path
      view_context.redirect_url(@billing.billable_type)
    end
end
