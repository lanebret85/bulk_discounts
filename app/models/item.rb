class Item < ApplicationRecord
  enum :status, {"enabled" => 0, "disabled" => 1}

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

  def self.item_revenue(item)
    joins(:transactions).where(transactions: { result: 'success' }).where("invoice_items.item_id = ?", item.id).sum("invoice_items.quantity * invoice_items.unit_price")
  end

  def item_best_day
    Item.joins(:transactions).select("sum(invoice_items.quantity * invoice_items.unit_price) AS total_revenue, DATE(invoices.created_at) AS date").where("items.id = ?", self.id).group(:date).order("total_revenue DESC").first.date.strftime('%-m/%d/%y')
  end
end