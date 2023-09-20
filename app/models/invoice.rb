class Invoice < ApplicationRecord
  enum :status, {"cancelled" => 0, "completed" => 1, "in progress" => 2}

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  validates :status, presence: true 

  def total_revenue
    invoice_items.sum('quantity * unit_price')
  end

  def self.incomplete_invoices
    Invoice.select("invoices.*, invoice_items.invoice_id, invoices.created_at").joins(:invoice_items).distinct.where("invoice_items.status != ?", 2).order("invoices.created_at")
  end
end