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

  describe ".find_items" do
    it "returns the name of an item associated with an invoice item, as well as the invoice items quantity, unit price, and status" do
      customer_1 = create(:customer)

      invoice_1 = create(:invoice, customer: customer_1)

      merchant_1 = create(:merchant)

      item_1 = create(:item, name: "Item 1", merchant: merchant_1)

      invoice_item_1 = InvoiceItem.create!(
        item: item_1,
        invoice: invoice_1,
        quantity: 2,
        unit_price: 36742,
        status: "shipped"
      )

      item = InvoiceItem.find_items(invoice_1)

      expect(item.first.name).to eq("Item 1")
      expect(item.first.quantity).to eq(2)
      expect(item.first.unit_price).to eq(36742)
      expect(item.first.status).to eq("shipped")
    end
  end
end