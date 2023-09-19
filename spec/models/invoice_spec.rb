require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
  end
  
  describe "validations" do
    it { should validate_presence_of :status }
  end

  describe "enum" do
    it { should define_enum_for(:status).with_values(["cancelled", "completed", "in progress"]) }
  end

  before (:each) do
    @merchant1 = Merchant.create!(name: "BOB BURGER SHOP")
    @merchant2 = Merchant.create!(name: "POP BURGER SHOP")

    @customer1 = Customer.create(first_name: "Cindy", last_name: "Loo")
    @customer2 = Customer.create(first_name: "Steve", last_name: "Boo")
    @customer3 = Customer.create(first_name: "Joshil", last_name: "Moo")
    @customer4 = Customer.create(first_name: "Jon", last_name: "Stu")
    @customer5 = Customer.create(first_name: "Sarah", last_name: "Who")
    @customer6 = Customer.create(first_name: "Chandni", last_name: "Sue")
    
    @item1 = Item.create!(name: "Burger", unit_price: 15, merchant_id: @merchant1.id, description: "Is a Burger")
    @item2 = Item.create!(name: "Soda", unit_price: 7, merchant_id: @merchant1.id, description: "Is a Soda")
    @item3 = Item.create!(name: "Pretzels", unit_price: 7, merchant_id: @merchant2.id, description: "Is a Pretzel")
    
    @invoice1 = Invoice.create!(status: 0, customer_id: @customer1.id)
    @invoice2 = Invoice.create!(status: 1, customer_id: @customer2.id)
    @invoice3 = Invoice.create!(status: 1, customer_id: @customer3.id)
    @invoice4 = Invoice.create!(status: 1, customer_id: @customer4.id)
    @invoice5 = Invoice.create!(status: 1, customer_id: @customer5.id)
    @invoice6 = Invoice.create!(status: 1, customer_id: @customer6.id)
    
    @invoice_item1 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice1.id, quantity: 2, unit_price: 345, status: 1) 
    @invoice_item2 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice2.id, quantity: 1, unit_price: 345, status: 0) 
    @invoice_item3 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice3.id, quantity: 1, unit_price: 345, status: 1) 
    @invoice_item4 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice4.id, quantity: 1, unit_price: 600, status: 1) 
    @invoice_item5 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice5.id, quantity: 1, unit_price: 345, status: 1) 
    @invoice_item6 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice6.id, quantity: 1, unit_price: 345, status: 2) 

    @transaction1 = Transaction.create!(invoice_id: @invoice1.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 1)
    @transaction2 = Transaction.create!(invoice_id: @invoice2.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction3 = Transaction.create!(invoice_id: @invoice3.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction4 = Transaction.create!(invoice_id: @invoice4.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction5 = Transaction.create!(invoice_id: @invoice5.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction6 = Transaction.create!(invoice_id: @invoice6.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
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
end