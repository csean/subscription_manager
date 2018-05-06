class SubscribersController < ApplicationController
  # GET /subscribers
  def index
    @subscribers = Subscriber.includes(subscriptions: :item).order(:name).page(params[:page])
  end

  # GET /subscribers/1
  def show
    @subscriber = Subscriber.find(params[:id])
  end
end
