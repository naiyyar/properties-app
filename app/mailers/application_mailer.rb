class ApplicationMailer < ActionMailer::Base
  layout :select_layout

  private
  def select_layout
    if mailer_actions.include?(action_name)
      'billing_mailer'
    else
      'mailer'
    end
  end

  def mailer_actions
  	['send_payment_receipt', 'no_card_payment_failed','payment_failed']
  end

end
