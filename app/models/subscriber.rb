class Subscriber < ApplicationRecord
  has_many :subscriptions
  has_many :items, through: :subscriptions

  validates :name, presence: true
  validates :email,
    format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ },
    presence: true,
    uniqueness: true
end
