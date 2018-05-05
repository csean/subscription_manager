class Subscriber < ApplicationRecord
  validates :name, presence: true
  validates :email,
    format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ },
    presence: true,
    uniqueness: true
end
