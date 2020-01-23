module Stripe
	class ChargeEventHandler
    def call(event)
      begin
        method = "handle_" + event.type.tr('.', '_')
        self.send method, event
      rescue JSON::ParserError => e
        # handle the json parsing error here
        raise # re-raise the exception to return a 500 error to stripe
      rescue NoMethodError => e
        #code to run when handling an unknown event
      end
    end

    def handle_charge_failed(event)
      puts 'handle_charge_failed'
    end

    def handle_charge_succeeded(event)
      puts 'handle_charge_succeeded'
    end
  end
end