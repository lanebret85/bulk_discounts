class Item < ApplicationRecord
  enum :status, {"enabled" => 0, "disabled" => 1}

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true

  def self.item_best_days(item)
    select("MAX(invoice_items.quantity * invoice_items.unit_price) AS total_revenue, DATE(invoices.created_at) AS date").joins(invoice_items: { invoice: :transactions }).where("items.id = ?", item.id).group(:date).order("total_revenue DESC").first.date
  end
end