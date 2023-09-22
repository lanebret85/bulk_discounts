class BulkDiscount < ApplicationRecord
  has_many :merchant_bulk_discounts
  has_many :merchants, through: :merchant_bulk_discounts

  validates :quantity_threshold, presence: true
  validates :percentage_discount, presence: true
  validates :description, presence: true
end