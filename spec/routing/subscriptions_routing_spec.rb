require "rails_helper"

RSpec.describe SubscriptionsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/subscriptions").to route_to("subscriptions#index")
    end


    it "routes to #show" do
      expect(:get => "/subscriptions/1").to route_to("subscriptions#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/subscriptions").to route_to("subscriptions#create")
    end
  end
end
