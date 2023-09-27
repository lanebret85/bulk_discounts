require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end

  describe "enum" do
    it { should define_enum_for(:status).with_values(["packaged", "pending", "shipped"]) }
  end

  describe "validations" do
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end

  describe "discount_applied?" do
    it "checks if the given invoice item quantity is high enough to meet the minimum quantity threshold of a merchants bulk discounts" do
      customer_1 = create(:customer)

      invoice_1 = create(:invoice, customer: customer_1)
      invoice_2 = create(:invoice, customer: customer_1)

      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)

      item_1 = create(:item, merchant: merchant_1)
      item_2 = create(:item, merchant: merchant_1)
      item_3 = create(:item, merchant: merchant_1)
      item_4 = create(:item, merchant: merchant_2)

      invoice_item_1 = create(:invoice_item, quantity: 5, unit_price: 25000, invoice: invoice_1, item: item_1)
      invoice_item_2 = create(:invoice_item, quantity: 10, unit_price: 50000, invoice: invoice_1, item: item_2)
      invoice_item_3 = create(:invoice_item, quantity: 1, unit_price: 10000, invoice: invoice_1, item: item_3)
      invoice_item_4 = create(:invoice_item, quantity: 1, unit_price: 10000, invoice: invoice_2, item: item_4)

      bulk_discount_1 = BulkDiscount.create!(quantity_threshold: 10, percentage_discount: 0.2, description: "20% off 10 items or more")
      bulk_discount_2 = BulkDiscount.create!(quantity_threshold: 15, percentage_discount: 0.3, description: "30% off 15 items or more")
      bulk_discount_3 = BulkDiscount.create!(quantity_threshold: 5, percentage_discount: 0.05, description: "5% off 5 items or more")

      merchant_bulk_discount_1 = MerchantBulkDiscount.create!(merchant: merchant_1, bulk_discount: bulk_discount_1)
      merchant_bulk_discount_2 = MerchantBulkDiscount.create!(merchant: merchant_1, bulk_discount: bulk_discount_2)
      merchant_bulk_discount_3 = MerchantBulkDiscount.create!(merchant: merchant_1, bulk_discount: bulk_discount_3)

      query = invoice_item_1.discount_applied?

      expect(query).to eq(true)

      query_2 = invoice_item_4.discount_applied?

      expect(query_2).to eq(false)

      query_3 = invoice_item_3.discount_applied?

      expect(query_3).to eq(false)
    end
  end

  describe "applied_discount" do
    it "returns the id of the discount that was applied to an invoice item" do
      customer_1 = create(:customer)

      invoice_1 = create(:invoice, customer: customer_1)
      invoice_2 = create(:invoice, customer: customer_1)

      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)

      item_1 = create(:item, merchant: merchant_1)
      item_2 = create(:item, merchant: merchant_1)
      item_3 = create(:item, merchant: merchant_1)
      item_4 = create(:item, merchant: merchant_2)

      invoice_item_1 = create(:invoice_item, quantity: 5, unit_price: 25000, invoice: invoice_1, item: item_1)
      invoice_item_2 = create(:invoice_item, quantity: 10, unit_price: 50000, invoice: invoice_1, item: item_2)
      invoice_item_3 = create(:invoice_item, quantity: 1, unit_price: 10000, invoice: invoice_1, item: item_3)
      invoice_item_4 = create(:invoice_item, quantity: 1, unit_price: 10000, invoice: invoice_2, item: item_4)

      bulk_discount_1 = BulkDiscount.create!(quantity_threshold: 10, percentage_discount: 0.2, description: "20% off 10 items or more")
      bulk_discount_2 = BulkDiscount.create!(quantity_threshold: 15, percentage_discount: 0.3, description: "30% off 15 items or more")
      bulk_discount_3 = BulkDiscount.create!(quantity_threshold: 5, percentage_discount: 0.05, description: "5% off 5 items or more")

      merchant_bulk_discount_1 = MerchantBulkDiscount.create!(merchant: merchant_1, bulk_discount: bulk_discount_1)
      merchant_bulk_discount_2 = MerchantBulkDiscount.create!(merchant: merchant_1, bulk_discount: bulk_discount_2)
      merchant_bulk_discount_3 = MerchantBulkDiscount.create!(merchant: merchant_1, bulk_discount: bulk_discount_3)

      query = invoice_item_2.applied_discount

      expect(query).to eq(bulk_discount_1.id)
    end
  end
end