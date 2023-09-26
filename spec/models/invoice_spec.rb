require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many(:bulk_discounts).through(:merchants) }
  end
  
  describe "validations" do
    it { should validate_presence_of :status }
  end

  describe "enum" do
    it { should define_enum_for(:status).with_values(["cancelled", "completed", "in progress"]) }
  end

  describe "total_revenue" do
    it "returns total revenue of an invoice" do
      customer_1 = create(:customer)

      invoice_1 = create(:invoice, customer: customer_1)

      merchant_1 = create(:merchant)

      item_1 = create(:item, merchant: merchant_1)

      invoice_item_1 = create(:invoice_item, quantity: 5, unit_price: 24642, invoice: invoice_1, item: item_1)
      invoice_item_2 = create(:invoice_item, quantity: 8, unit_price: 12463, invoice: invoice_1, item: item_1)
      invoice_item_2 = create(:invoice_item, quantity: 2, unit_price: 23567, invoice: invoice_1, item: item_1)

      expect(invoice_1.total_revenue).to eq(270048)
    end
  end

  describe ".incomplete_invoices" do
    it "returns the invoices with items that have a status other than 'shipped'" do
      customer_1 = create(:customer)
      customer_2 = create(:customer)
      customer_3 = create(:customer)
      customer_4 = create(:customer)
      customer_5 = create(:customer)
      customer_6 = create(:customer)

      invoice_1 = create(:invoice, customer: customer_1, status: 1)
      sleep 1
      invoice_2 = create(:invoice, customer: customer_2, status: 1)
      invoice_3 = create(:invoice, customer: customer_3, status: 1)
      invoice_4 = create(:invoice, customer: customer_4, status: 1)
      invoice_5 = create(:invoice, customer: customer_5, status: 1)
      invoice_6 = create(:invoice, customer: customer_6, status: 1)
      sleep 1
      invoice_7 = create(:invoice, customer: customer_1, status: 1)

      merchant_1 = create(:merchant)

      item_1 = create(:item, merchant: merchant_1)

      invoice_item_1 = create(:invoice_item, quantity: 3, unit_price: 57295, item: item_1, invoice: invoice_1, status: 2)
      invoice_item_2 = create(:invoice_item, quantity: 8, unit_price: 65020, item: item_1, invoice: invoice_2, status: 2)
      invoice_item_3 = create(:invoice_item, quantity: 7, unit_price: 20375, item: item_1, invoice: invoice_3, status: 2)
      invoice_item_4 = create(:invoice_item, quantity: 2, unit_price: 32563, item: item_1, invoice: invoice_4, status: 2)
      invoice_item_5 = create(:invoice_item, quantity: 5, unit_price: 10385, item: item_1, invoice: invoice_5, status: 2)
      invoice_item_6 = create(:invoice_item, quantity: 1, unit_price: 73920, item: item_1, invoice: invoice_6, status: 2)
      invoice_item_7 = create(:invoice_item, quantity: 5, unit_price: 11894, item: item_1, invoice: invoice_7, status: 1)
      invoice_item_8 = create(:invoice_item, quantity: 4, unit_price: 79285, item: item_1, invoice: invoice_1, status: 0)
      invoice_item_9 = create(:invoice_item, quantity: 3, unit_price: 32563, item: item_1, invoice: invoice_2, status: 1)

      query = Invoice.incomplete_invoices

      expect(query).to eq([invoice_1, invoice_2, invoice_7])
    end
  end

  describe "total_discounted_revenue" do
    it "returns total revenue of an invoice accounting for bulk discounts" do
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

      query = invoice_1.total_discounted_revenue

      expect(query).to eq(528750.0)

      query_2 = invoice_2.total_discounted_revenue

      expect(query_2).to eq(10000.0)
    end
  end
end