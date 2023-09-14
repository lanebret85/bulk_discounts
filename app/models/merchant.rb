class Merchant < ApplicationRecord
  validates_presence_of :name
  
  has_many :items
  has_many :invoices, through: :items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def top_5_customers
    Customer.select('customers.*, COUNT(transactions.id) as success_transactions').joins(invoices: :transactions).where(transactions: { result: "success" }).group('customers.id').order('success_transactions DESC').limit(5)
  end
      
  def item_to_be_shipped
    Item.select("items.*").joins(:invoice_items).where.not(invoice_items: {status: 2 })
  end
end