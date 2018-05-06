require 'rails_helper'

describe BillingGatewayService, type: :service do
  subject(:billing_gateway) { BillingGatewayService.instance }
  let(:subscription) { build :subscription }

  context 'valid and sufficient funds' do
    let(:response) { billing_gateway.process(subscription) }

    before do
      body = '{"id":"47dbaa8fce89f3b5","paid":true,"failure_message":null}'
      allow_any_instance_of(RestClient::Resource).to receive(:get).and_return(body)
    end

    it 'is successful' do
      expect(response.success).to eq true
    end

    it 'returns a token' do
      expect(response.token).to eq '47dbaa8fce89f3b5'
    end
  end

  context 'invalid subscription' do
    let(:subscription) { build :subscription, cc_number: Faker::Number.number(2) }

    it 'does not call the billing gateway' do
      expect_any_instance_of(RestClient::Resource).to receive(:get).never
      billing_gateway.process(subscription)
    end

    it 'returns record is invalid' do
      subscription.valid?
      response = billing_gateway.process(subscription)
      expect(response.error).to eq subscription.errors
    end
  end

  context 'insufficient_funds' do
    let(:response) { billing_gateway.process(subscription) }

    before do
      body = '{"id":"47dbaa8fce89f3b5","paid":false,"failure_message":"insufficient_funds"}'
      allow_any_instance_of(RestClient::Resource).to receive(:get).and_return(body)
    end

    it 'is not successful' do
      expect(response.success).to eq false
    end

    it 'returns an insufficient_funds error' do
      expect(response.error[:error]).to eq :insufficient_funds
    end
  end

  context 'bad gateway' do
    let(:response) { billing_gateway.process(subscription) }

    before { allow_any_instance_of(RestClient::Resource).to receive(:get).and_raise(RestClient::ServiceUnavailable) }

    it 'is not successful' do
      expect(response.success).to eq false
    end

    it 'returns a bad_gateway error' do
      expect(response.error[:error]).to eq :bad_gateway
    end
  end
end
