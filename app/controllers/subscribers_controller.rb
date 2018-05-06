class SubscribersController < ApplicationController

  # GET /subscribers.json
  def index
    @subscribers = Subscriber.includes(subscriptions: :item).order(:name).page(params[:page])
  end

  # GET /subscribers/1.json
  def show
    @subscriber = Subscriber.find(params[:id])
  end
end
