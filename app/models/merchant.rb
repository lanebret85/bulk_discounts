class Merchant < ApplicationRecord
  has_many :items
  # has_many :transactions, through: :invoices
end