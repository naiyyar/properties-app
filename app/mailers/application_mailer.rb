class ApplicationMailer < ActionMailer::Base
  DEFAULT_EMAIL = %(myapp <hello@myapp.co>)
  BILLING_MAILER_LAYOUT_ACTIONS = [ 'send_payment_receipt' ]
  
  layout :set_layout

  private
  
  def set_layout
    'mailer' unless BILLING_MAILER_LAYOUT_ACTIONS.include?(action_name)
    'billing_mailer'
  end

end
