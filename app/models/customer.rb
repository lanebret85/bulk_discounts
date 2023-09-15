class Customer < ApplicationRecord
  has_many :invoices

  def full_name
    first_name + " " + last_name
  end
end