class Invoice < ApplicationRecord
  enum :status, {"cancelled" => 0, "completed" => 1, "in progress" => 2}

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants

  validates :status, presence: true 

  def total_revenue
    invoice_items.sum('quantity * unit_price')
  end

  def self.incomplete_invoices
    Invoice.select("invoices.*, invoice_items.invoice_id, invoices.created_at").joins(:invoice_items).distinct.where("invoice_items.status != ?", 2).order("invoices.created_at")
  end

  def total_discounted_revenue
    if merchants.first.bulk_discounts != []
      discounted_revenue = Invoice.select("invoice_id, max_percent_discount, item_quantity, unit_price")
                                    .from(InvoiceItem.joins(item: {merchant: :bulk_discounts})
                                                      .select("invoice_items.invoice_id as invoice_id, invoice_items.quantity as item_quantity, invoice_items.unit_price as unit_price, max(bulk_discounts.percentage_discount) as max_percent_discount, min(bulk_discounts.quantity_threshold) as min_threshold")
                                                      .where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
                                                      .group(:id)
                                    )
                                    .where("invoice_id = #{self.id}")
                                    .sum("(item_quantity * unit_price) * (1 - max_percent_discount)")
                                    
      non_discounted_revenue = Invoice.select("invoice_id, min_threshold, item_quantity, unit_price")
                                      .from(InvoiceItem.joins(item: {merchant: :bulk_discounts})
                                                        .select("invoice_items.invoice_id as invoice_id, invoice_items.quantity as item_quantity, invoice_items.unit_price as unit_price, min(bulk_discounts.quantity_threshold) as min_threshold")
                                                        .group(:id)
                                      )                  
                                      .where("item_quantity < min_threshold AND invoice_id = #{self.id}")
                                      .sum("item_quantity * unit_price")
                                  
      discounted_revenue + non_discounted_revenue
    else
      total_revenue
    end
  end
end