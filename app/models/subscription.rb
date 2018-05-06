class Subscription < ApplicationRecord
  attr_accessor :cc_number, :expiration_month, :expiration_year, :cvv

  belongs_to :item
  belongs_to :subscriber

  validates :expiration_month, :expiration_year, :cvv, presence: true, on: :create
  validates :cc_number, credit_card_number: true, presence: true, on: :create
  validate :expiration_date, :future_start_date, on: :create

  accepts_nested_attributes_for :subscriber, reject_if: :existing_subscriber

  before_validation(on: :create) do
    self.start_date = Date.today if start_date.nil?
  end

  def next_billing_date
    # TODO: would break this out into different pattern
    # if accepted more subscription types
    current_billing = Date.new(Date.today.year, Date.today.month, start_date.day)
    current_billing >= Date.today ? current_billing : current_billing + 1.month
  end

  private
    def expiration_date
      year = expiration_year.to_i > 2000 ? expiration_year.to_i : 2000 + expiration_year.to_i
      return if year > Date.today.year
      return if year == Date.today.year && expiration_month.to_i >= Date.today.month
      errors.add(:base, 'Card expired')
    end

    def future_start_date
      return if start_date >= Date.today
      errors.add(:start_date, 'must occur today or in the future')
    end

    def existing_subscriber(subscriber_attributes)
      if record = Subscriber.find_by(subscriber_attributes)
        self.subscriber = record
        return true
      end
      false
    end
end
