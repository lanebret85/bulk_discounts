class InvoiceItem < ApplicationRecord
  enum :status, {"packaged" => 0, "pending" => 1, "shipped" => 2}

  belongs_to :item
  belongs_to :invoice

  validates :quantity, presence: true
  validates :unit_price, presence: true
  validates :status, presence: true

  def discount_applied?
    if self.item.merchant.bulk_discounts != []
      invoice_items = Invoice.joins(:bulk_discounts)
                              .select("min(bulk_discounts.quantity_threshold) as min_threshold")
                              .where("#{self.invoice_id} = invoices.id")
                              .order("bulk_discounts.quantity_threshold ASC")
                              .group("bulk_discounts.id")
      if self.quantity >= invoice_items.first.min_threshold
        true
      else
        false
      end
    else
      false
    end
  end

  def applied_discount
    discounts = Invoice.joins(:bulk_discounts)
                        .select("bulk_discounts.id, max(bulk_discounts.percentage_discount)")
                        .where("#{self.quantity} >= bulk_discounts.quantity_threshold")
                        .order("bulk_discounts.percentage_discount DESC")
                        .group("bulk_discounts.id")
      
    discounts.first.id
  end
end