class SubscriptionsController < ApplicationController
  # GET /subscriptions
  def index
    @subscriptions = Subscription.includes(:subscriber, :item).order(:created_at).page(params[:page])
  end

  # GET /subscriptions/1
  def show
    @subscription = Subscription.find(params[:id])
  end

  # POST /subscriptions
  def create
    @subscription = Subscription.new(subscription_params)
    response = BillingGatewayService.instance.process(@subscription)
    if response.success
      @subscription.token = response.token
      @subscription.save
      render :show, status: :created, location: @subscription
    else
      render json: response.error, status: response.status
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def subscription_params
      params.require(:subscription).permit(
        :item_id,
        :start_date,
        :cc_number,
        :expiration_month,
        :expiration_year,
        :cvv,
        subscriber_attributes: [
          :name,
          :email
        ]
      )
    end
end
