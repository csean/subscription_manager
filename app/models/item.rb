class Item < ApplicationRecord
  monetize :price_cents

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
end
