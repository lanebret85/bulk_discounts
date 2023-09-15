class Merchant < ApplicationRecord
  enum :status, {"enabled" => 0, "disabled" => 1}

  validates_presence_of :name, presence: true
  # validates_presence_of :status, presence: true
  
  has_many :items
  has_many :invoices, through: :items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def top_5_customers
    Customer.select('customers.*, COUNT(transactions.id) as success_transactions').joins(invoices: :transactions).where(transactions: { result: "success" }).group('customers.id').order('success_transactions DESC').limit(5)
  end
      
  def item_to_be_shipped
    Item.select("items.*, invoice_items.invoice_id, invoices.created_at").joins(invoice_items: :invoice).where.not(invoice_items: {status: 2 }).order("invoices.created_at ASC")
  end
end