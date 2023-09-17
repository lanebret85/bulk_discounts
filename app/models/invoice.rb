class Invoice < ApplicationRecord
  enum :status, {"cancelled" => 0, "completed" => 1, "in progress" => 2}

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items

  validates :status, presence: true #inclusion:{in: ["cancelled", "completed", "in progress"]}

  def total_revenue
    Invoice.joins(:invoice_items).where(id: self.id).sum("invoice_items.quantity * invoice_items.unit_price")
  end
end