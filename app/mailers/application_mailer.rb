class ApplicationMailer < ActionMailer::Base
  layout :select_layout

  private
  def select_layout
    if ['send_payment_receipt'].include?(action_name)
      'billing_mailer'
    else
      'mailer'
    end
  end

end
