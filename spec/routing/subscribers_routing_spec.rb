require "rails_helper"

describe SubscribersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/subscribers").to route_to("subscribers#index")
    end

    it "routes to #show" do
      expect(:get => "/subscribers/1").to route_to("subscribers#show", :id => "1")
    end
  end
end
