require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many :items }
    it { should have_many(:invoices).through :items }
    it { should have_many(:customers).through :invoices }
    it { should have_many(:transactions).through :invoices }
  end

  describe "enum" do
    it { should define_enum_for(:status).with_values(["enabled", "disabled"])}
  end

  describe "top_5_customers" do
    it "displays the top 5 customers" do
      merchant1 = Merchant.create!(name: "BOB BURGER SHOP")

      customer1 = Customer.create(first_name: "Cindy", last_name: "Loo")
      customer2 = Customer.create(first_name: "Steve", last_name: "Boo")
      customer3 = Customer.create(first_name: "Joshil", last_name: "Moo")
      customer4 = Customer.create(first_name: "Jon", last_name: "Stu")
      customer5 = Customer.create(first_name: "Sarah", last_name: "Who")
      customer6 = Customer.create(first_name: "Chandni", last_name: "Sue")
      
      item1 = Item.create!(name: "Burger", unit_price: 15, merchant_id: merchant1.id)
      item2 = Item.create!(name: "Soda", unit_price: 7, merchant_id: merchant1.id)
      
      invoice1 = Invoice.create!(status: 0, customer_id: customer1.id)
      invoice2 = Invoice.create!(status: 1, customer_id: customer2.id)
      invoice3 = Invoice.create!(status: 1, customer_id: customer3.id)
      invoice4 = Invoice.create!(status: 1, customer_id: customer4.id)
      invoice5 = Invoice.create!(status: 1, customer_id: customer5.id)
      invoice6 = Invoice.create!(status: 1, customer_id: customer6.id)
      
      invoice_item1 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice1.id, quantity: 1, unit_price: 345, status: 1) 
      invoice_item2 = InvoiceItem.create!(item_id: item2.id, invoice_id: invoice2.id, quantity: 1, unit_price: 345, status: 0) 
      invoice_item3 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice3.id, quantity: 1, unit_price: 345, status: 1) 
      invoice_item4 = InvoiceItem.create!(item_id: item2.id, invoice_id: invoice4.id, quantity: 1, unit_price: 345, status: 1) 
      invoice_item5 = InvoiceItem.create!(item_id: item1.id, invoice_id: invoice5.id, quantity: 1, unit_price: 345, status: 1) 
      invoice_item6 = InvoiceItem.create!(item_id: item2.id, invoice_id: invoice6.id, quantity: 1, unit_price: 345, status: 2) 

      transaction1 = Transaction.create!(invoice_id: invoice1.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 1)
      transaction2 = Transaction.create!(invoice_id: invoice2.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
      transaction3 = Transaction.create!(invoice_id: invoice3.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
      transaction4 = Transaction.create!(invoice_id: invoice4.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
      transaction5 = Transaction.create!(invoice_id: invoice5.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
      transaction6 = Transaction.create!(invoice_id: invoice6.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)

      top_5 = merchant1.top_5_customers

      expect(top_5).to eq([customer2, customer3, customer4, customer5, customer6])
      expect(top_5).to_not include(customer1)
    end
  end

  describe ".top_merchants" do
    it "should return the top 5 merchants based on revenue" do
      customer_1 = create(:customer)

      invoice_1 = create(:invoice, customer: customer_1)
      invoice_2 = create(:invoice, customer: customer_1)

      transaction_1 = create(:transaction, invoice: invoice_1, result: 0)
      transaction_2 = create(:transaction, invoice: invoice_2, result: 1)
      
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)
      merchant_3 = create(:merchant)
      merchant_4 = create(:merchant)
      merchant_5 = create(:merchant)
      merchant_6 = create(:merchant)

      item_for_merchant_1 = create(:item, merchant: merchant_1)
      item_for_merchant_2 = create(:item, merchant: merchant_2)
      item_for_merchant_3 = create(:item, merchant: merchant_3)
      item_for_merchant_4 = create(:item, merchant: merchant_4)
      item_for_merchant_5 = create(:item, merchant: merchant_5)
      item_for_merchant_6 = create(:item, merchant: merchant_6)

      invoice_item_1 = create(:invoice_item, quantity: 3, unit_price: 57295, item: item_for_merchant_1, invoice: invoice_1)
      invoice_item_2 = create(:invoice_item, quantity: 5, unit_price: 10385, item: item_for_merchant_1, invoice: invoice_2)
      invoice_item_3 = create(:invoice_item, quantity: 8, unit_price: 65020, item: item_for_merchant_2, invoice: invoice_1)
      invoice_item_4 = create(:invoice_item, quantity: 1, unit_price: 73920, item: item_for_merchant_3, invoice: invoice_1)
      invoice_item_5 = create(:invoice_item, quantity: 2, unit_price: 32563, item: item_for_merchant_4, invoice: invoice_1)
      invoice_item_6 = create(:invoice_item, quantity: 7, unit_price: 20375, item: item_for_merchant_5, invoice: invoice_1)
      invoice_item_7 = create(:invoice_item, quantity: 4, unit_price: 79285, item: item_for_merchant_6, invoice: invoice_1)

      expect(Merchant.top_merchants).to eq([merchant_2, merchant_6, merchant_1, merchant_5, merchant_3])
    end
  end
end