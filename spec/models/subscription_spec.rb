require 'rails_helper'

describe Subscription, type: :model do
  describe 'validations' do
    [:cc_number, :cvv, :expiration_month, :expiration_year].each do |attr|
      it { is_expected.to validate_presence_of(attr).on(:create) }
    end

    context 'start_date' do
      it 'has a future start date' do
        subscription = build :subscription, start_date: Date.today + 1.day
        expect(subscription).to be_valid
      end

      it 'is valid if start date is current date' do
        subscription = build :subscription, start_date: Date.today
        expect(subscription).to be_valid
      end

      it 'cannot have a date in the past' do
        subscription = build :subscription, start_date: Date.today - 1.day
        subscription.valid?
        expect(subscription.errors[:start_date]).to include 'must occur today or in the future'
      end

      it 'sets start_date as current date if start_date is not set' do
        subscription = build :subscription, start_date: nil
        subscription.valid?
        expect(subscription.start_date).to eq Date.today
      end
    end

    context 'expiration date' do
      it 'is not valid when expiration year is in the past' do
        subscription = build :subscription, expiration_year: (Date.today - 1.year).year
        subscription.valid?
        expect(subscription.errors[:base]).to include('Card expired')
      end

      it 'is not valid when expiration year is current but month is in the past' do
        travel_to Date.new(2018, 6, 1) do
          subscription = build :subscription, expiration_year: 2018, expiration_month: 5
          subscription.valid?
          expect(subscription.errors[:base]).to include('Card expired')
        end
      end

      it 'is valid when expiring in current month' do
        travel_to Date.new(2018, 6, 1) do
          subscription = build :subscription, expiration_year: 2018, expiration_month: 6
          expect(subscription).to be_valid
        end
      end

      it 'is valid when expiring in future' do
        travel_to Date.new(2018, 6, 1) do
          subscription = build :subscription, expiration_year: 2018, expiration_month: 7
          expect(subscription).to be_valid
        end
      end
    end
  end

  describe '.next_billing_date' do
    it 'returns the date this month when have not reached billing date' do
      subscription = build_stubbed :subscription, start_date: Date.new(2017, 1, 15)
      travel_to Date.new(2018, 1, 10) do
        expect(subscription.next_billing_date).to eq Date.new(2018, 1, 15)
      end
    end

    it 'returns the date next month when past current month\'s billing date' do
      subscription = build_stubbed :subscription, start_date: Date.new(2017, 1, 15)
      travel_to Date.new(2018, 1, 20) do
        expect(subscription.next_billing_date).to eq Date.new(2018, 2, 15)
      end
    end

    it 'returns the date this month when billing date matches' do
      subscription = build_stubbed :subscription, start_date: Date.new(2017, 1, 15)
      travel_to Date.new(2018, 1, 15) do
        expect(subscription.next_billing_date).to eq Date.new(2018, 1, 15)
      end
    end
  end
end
