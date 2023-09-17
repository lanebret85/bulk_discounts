class InvoiceItem < ApplicationRecord
  enum :status, {"packaged" => 0, "pending" => 1, "shipped" => 2}

  belongs_to :item
  belongs_to :invoice

  validates :quantity, presence: true
  validates :unit_price, presence: true
  validates :status, presence: true

  def self.find_items(current_invoice)
    InvoiceItem.joins(:item).select("invoice_items.quantity, invoice_items.status, invoice_items.unit_price, items.name").where("invoice_items.invoice_id = ?", current_invoice.id)
  end

end