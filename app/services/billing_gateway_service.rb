class BillingGatewayService
  include Singleton

  def initialize
    creds = Rails.application.credentials.billing_gateway
    @resource = RestClient::Resource.new(creds[:url], creds[:username], creds[:password])
  end

  def process(subscription)
    if subscription.valid?
      validate_transaction(subscription)
    else
      OpenStruct.new(success: false, error: subscription.errors, status: :unprocessable_entity) unless subscription.valid?
    end
  end

  private
    attr_reader :resource

    def validate_transaction(subscription)
      begin
        retries ||= 0
        response = JSON.parse(resource.get) # would pass params here

        if response['paid']
          return OpenStruct.new(success: true, token: response['id'])
        else
          return OpenStruct.new(success: false, error: { error: :insufficient_funds }, status: 400)
        end

      rescue RestClient::ServiceUnavailable
        retry if (retries += 1) < 5
        return OpenStruct.new(success: false, error: { error: :bad_gateway }, status: 500)
      end
    end
end
