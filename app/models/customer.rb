class Customer < ApplicationRecord
  has_many :invoices

  validates :first_name, presence: true
  validates :last_name, presence: true

  def self.top_customers
    Customer.select('customers.*, COUNT(transactions.id) as success_transactions').joins(invoices: :transactions).where(transactions: { result: "success" }).group('customers.id').order('success_transactions DESC').limit(5)
=========
  def full_name
    first_name + " " + last_name
>>>>>>>>> Temporary merge branch 2
  end
end