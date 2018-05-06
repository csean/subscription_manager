require 'rails_helper'

describe SubscriptionsController, type: :controller do
  let(:item) { create :item }
  let(:subscriber_attributes) { attributes_for :subscriber }

  let(:valid_attributes) {
    attributes_for :subscription, item_id: item.id, subscriber_attributes: subscriber_attributes
  }

  let(:invalid_attributes) {
    attributes_for :subscription, expiration_year: (Date.today - 1.year).year
  }

  describe "GET #index" do
    it "returns a success response" do
      create :subscription
      get :index
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      subscription = create :subscription
      get :show, params: { id: subscription.id }
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    context 'successful transaction with billing gateway' do
      before do
        response = double(success: true, token: SecureRandom.hex(8))
        allow(BillingGatewayService.instance).to receive(:process).and_return(response)
      end

      it "creates a new Subscription" do
        expect {
          post :create, params: { subscription: valid_attributes }
        }.to change(Subscription, :count).by(1)
      end

      it "renders a JSON response with the new subscription" do
        post :create, params: { subscription: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.location).to eq(subscription_url(Subscription.last))
      end

      context 'with existing user' do
        it 'creates a new subscription' do
          subscriber = create :subscriber
          expect do
            post :create, params: { subscription: valid_attributes.merge(
              subscriber_attributes: {
                name: subscriber.name, email: subscriber.email
                }
              )
            }
          end.not_to change(Subscriber, :count)
        end
      end
    end

    context 'insufficient_funds' do
      before do
        response = double(success: false, status: 400, error: :insufficient_funds)
        allow(BillingGatewayService.instance).to receive(:process).and_return(response)
      end

      it "renders a JSON response with the new subscription" do
        post :create, params: { subscription: valid_attributes }
        expect(response).to have_http_status(400)
      end
    end

    context 'bad_gateway' do
      before do
        response = double(success: false, status: 500, error: :bad_gateway)
        allow(BillingGatewayService.instance).to receive(:process).and_return(response)
      end

      it "renders a JSON response with the new subscription" do
        post :create, params: { subscription: valid_attributes }
        expect(response).to have_http_status(500)
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new subscription" do
        post :create, params: { subscription: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
