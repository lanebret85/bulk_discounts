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

  before(:each) do
    @merchant1 = Merchant.create!(name: "BOB BURGER SHOP")
    @merchant2 = Merchant.create!(name: "Cindy's Cookies")

    @customer1 = Customer.create(first_name: "Cindy", last_name: "Loo")
    @customer2 = Customer.create(first_name: "Steve", last_name: "Boo")
    @customer3 = Customer.create(first_name: "Joshil", last_name: "Moo")
    @customer4 = Customer.create(first_name: "Jon", last_name: "Stu")
    @customer5 = Customer.create(first_name: "Sarah", last_name: "Who")
    @customer6 = Customer.create(first_name: "Chandni", last_name: "Sue")
    @customer7 = Customer.create(first_name: "Dani", last_name: "James")
    @customer8 = Customer.create(first_name: "Ryan", last_name: "Howard")
      
    @item1 = Item.create!(name: "Burger", unit_price: 15, merchant_id: @merchant1.id)
    @item2 = Item.create!(name: "Soda", unit_price: 7, merchant_id: @merchant1.id)
    @item3 = Item.create!(name: "Cookie", unit_price: 70, merchant_id: @merchant2.id)
    @item4 = Item.create!(name: "Big Cookie", unit_price: 7090, merchant_id: @merchant2.id)
      
    @invoice1 = Invoice.create!(status: 0, customer_id: @customer1.id)
    @invoice2 = Invoice.create!(status: 1, customer_id: @customer2.id)
    @invoice3 = Invoice.create!(status: 1, customer_id: @customer3.id)
    @invoice4 = Invoice.create!(status: 1, customer_id: @customer4.id)
    @invoice5 = Invoice.create!(status: 1, customer_id: @customer5.id)
    @invoice6 = Invoice.create!(status: 1, customer_id: @customer6.id)
    @invoice7 = Invoice.create!(status: 1, customer_id: @customer7.id)
    @invoice8 = Invoice.create!(status: 1, customer_id: @customer8.id)
      
    @invoice_item1 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice1.id, quantity: 1, unit_price: 345, status: 1) 
    @invoice_item2 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice2.id, quantity: 1, unit_price: 345, status: 0) 
    @invoice_item3 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice3.id, quantity: 1, unit_price: 345, status: 1) 
    @invoice_item4 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice4.id, quantity: 1, unit_price: 345, status: 1) 
    @invoice_item5 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice5.id, quantity: 1, unit_price: 345, status: 1) 
    @invoice_item6 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice6.id, quantity: 1, unit_price: 345, status: 2)
    @invoice_item7 = InvoiceItem.create!(item_id: @item3.id, invoice_id: @invoice7.id, quantity: 1, unit_price: 345, status: 1)
    @invoice_item8 = InvoiceItem.create!(item_id: @item4.id, invoice_id: @invoice8.id, quantity: 1, unit_price: 345, status: 2)

    @transaction1 = Transaction.create!(invoice_id: @invoice1.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 1)
    @transaction2 = Transaction.create!(invoice_id: @invoice2.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction3 = Transaction.create!(invoice_id: @invoice3.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction4 = Transaction.create!(invoice_id: @invoice4.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction5 = Transaction.create!(invoice_id: @invoice5.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction6 = Transaction.create!(invoice_id: @invoice6.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
  end

  describe "top_5_customers" do
    it "displays the top 5 customers" do
      
      top_5 = @merchant1.top_5_customers

      expect(top_5).to eq([@customer2, @customer3, @customer4, @customer5, @customer6])
      expect(top_5).to_not include(@customer1)
    end
  end

  describe "items_to_be_shipped" do
    it "should return only items that have not been shipped yet" do
      items_to_ship = @merchant2.item_to_be_shipped
  
      expect(items_to_ship).to include(@item3)
      expect(items_to_ship).not_to include(@item4)
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

  describe "best_day" do
    it "can return the day that a merchant made the most money" do
      merchant_1 = create(:merchant)

      customer_1 = create(:customer)

      invoice_1 = create(:invoice, created_at: "2012-03-25 09:54:09 UTC", customer: customer_1)
      invoice_2 = create(:invoice, created_at: "2012-03-12 05:54:09 UTC", customer: customer_1)

      item_for_merchant_1 = create(:item, merchant: merchant_1)

      invoice_item_1 = create(:invoice_item, quantity: 3, unit_price: 57295, item: item_for_merchant_1, invoice: invoice_1)
      invoice_item_2 = create(:invoice_item, quantity: 8, unit_price: 65020, item: item_for_merchant_1, invoice: invoice_1)
      invoice_item_3 = create(:invoice_item, quantity: 7, unit_price: 20375, item: item_for_merchant_1, invoice: invoice_1)
      invoice_item_4 = create(:invoice_item, quantity: 2, unit_price: 32563, item: item_for_merchant_1, invoice: invoice_1)
      invoice_item_5 = create(:invoice_item, quantity: 5, unit_price: 10385, item: item_for_merchant_1, invoice: invoice_2)
      invoice_item_6 = create(:invoice_item, quantity: 1, unit_price: 73920, item: item_for_merchant_1, invoice: invoice_2)
      invoice_item_7 = create(:invoice_item, quantity: 4, unit_price: 79285, item: item_for_merchant_1, invoice: invoice_2)

      expect(merchant_1.best_day).to eq("3/25/12")
    end
  end
end