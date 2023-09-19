require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
  end

  describe "enum" do
    it { should define_enum_for(:status).with_values(["cancelled", "completed", "in progress"]) }
  end

  describe "validations" do
    it { should validate_presence_of :status }
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
      invoice_2 = create(:invoice, customer: customer_2, status: 1)
      invoice_3 = create(:invoice, customer: customer_3, status: 1)
      invoice_4 = create(:invoice, customer: customer_4, status: 1)
      invoice_5 = create(:invoice, customer: customer_5, status: 1)
      invoice_6 = create(:invoice, customer: customer_6, status: 1)

      merchant_1 = create(:merchant)

      item_1 = create(:item, merchant: merchant_1)

      invoice_item_1 = create(:invoice_item, quantity: 3, unit_price: 57295, item: item_1, invoice: invoice_1, status: 2)
      invoice_item_2 = create(:invoice_item, quantity: 8, unit_price: 65020, item: item_1, invoice: invoice_2, status: 2)
      invoice_item_3 = create(:invoice_item, quantity: 7, unit_price: 20375, item: item_1, invoice: invoice_3, status: 2)
      invoice_item_4 = create(:invoice_item, quantity: 2, unit_price: 32563, item: item_1, invoice: invoice_4, status: 2)
      invoice_item_5 = create(:invoice_item, quantity: 5, unit_price: 10385, item: item_1, invoice: invoice_5, status: 2)
      invoice_item_6 = create(:invoice_item, quantity: 1, unit_price: 73920, item: item_1, invoice: invoice_6, status: 2)
      invoice_item_7 = create(:invoice_item, quantity: 4, unit_price: 79285, item: item_1, invoice: invoice_1, status: 0)
      invoice_item_8 = create(:invoice_item, quantity: 3, unit_price: 32563, item: item_1, invoice: invoice_2, status: 1)

      query = Invoice.incomplete_invoices

      expect(query).to match_array([invoice_1, invoice_2])
    end
  end
end