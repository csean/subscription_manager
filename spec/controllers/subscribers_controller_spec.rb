require 'rails_helper'

describe SubscribersController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index, format: :json
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    let(:subscriber) { create :subscriber }
    subject! { get :show, params: { id: subscriber.id }, format: :json }

    it 'returns a success response' do
      expect(response).to be_success
    end

    it 'returns subscriber' do
      expect(assigns(:subscriber)).to eq subscriber
    end
  end
end
