class InvoiceItem < ApplicationRecord
  enum :status, {"packaged" => 0, "pending" => 1, "shipped" => 2}

  belongs_to :item
  belongs_to :invoice
end