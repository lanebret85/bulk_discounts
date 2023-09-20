class Merchant < ApplicationRecord
  enum :status, {"enabled" => 0, "disabled" => 1}

  validates_presence_of :name, presence: true
  
  has_many :items
  has_many :invoices, through: :items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def top_5_customers
    Customer.select('customers.*, COUNT(transactions.id) as success_transactions').joins(invoices: :transactions).where(transactions: { result: "success" }).group('customers.id').order('success_transactions DESC').limit(5)
  end

  def top_5_items
    Item.select("items.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue").joins(invoice_items: { invoice: :transactions }).where(transactions: { result: "success" }).group("items.id").order("revenue DESC").limit(5)
  end

  def item_to_be_shipped
    Item.select("items.*, invoice_items.invoice_id, invoices.created_at").joins(invoice_items: :invoice).where.not(invoice_items: {status: 2 }).order("invoices.created_at ASC")
  end

  def self.top_merchants
    Merchant.joins(:transactions).select("merchants.id, merchants.name, avg(transactions.result), sum (invoice_items.unit_price * invoice_items.quantity) as total_revenue").where("transactions.result = 0").group(:id).order(total_revenue: :desc).limit(5)
  end

  def best_day
    Merchant.joins(:invoices).select("max((invoice_items.quantity) * (invoice_items.unit_price)) as total_revenue, date(invoices.created_at) as date").where("merchants.name = ?", self.name).group(:date).order(total_revenue: :desc).first.date.strftime('%-m/%d/%y')
  end
end