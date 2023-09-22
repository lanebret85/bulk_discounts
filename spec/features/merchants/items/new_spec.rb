require 'rails_helper'

RSpec.describe "Merchant Items New Page" do
  before (:each) do
    @merchant1 = Merchant.create!(name: "BOB BURGER SHOP")
    @merchant2 = Merchant.create!(name: "POP BURGER SHOP")

    @customer1 = Customer.create(first_name: "Cindy", last_name: "Loo")
    @customer2 = Customer.create(first_name: "Steve", last_name: "Boo")
    @customer3 = Customer.create(first_name: "Joshil", last_name: "Moo")
    @customer4 = Customer.create(first_name: "Jon", last_name: "Stu")
    @customer5 = Customer.create(first_name: "Sarah", last_name: "Who")
    @customer6 = Customer.create(first_name: "Chandni", last_name: "Sue")
    
    @item1 = Item.create!(name: "Burger", unit_price: 15, merchant_id: @merchant1.id, description: "Food")
    @item2 = Item.create!(name: "Soda", unit_price: 7, merchant_id: @merchant1.id, description: "Drink")
    @item3 = Item.create!(name: "Pretzels", unit_price: 7, merchant_id: @merchant2.id, description: "Food")
    
    @invoice1 = Invoice.create!(status: 0, customer_id: @customer1.id)
    @invoice2 = Invoice.create!(status: 1, customer_id: @customer2.id, created_at: 6.days.ago)
    @invoice3 = Invoice.create!(status: 1, customer_id: @customer3.id)
    @invoice4 = Invoice.create!(status: 1, customer_id: @customer4.id)
    @invoice5 = Invoice.create!(status: 1, customer_id: @customer5.id)
    @invoice6 = Invoice.create!(status: 1, customer_id: @customer6.id)
    
    @invoice_item1 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice1.id, quantity: 1, unit_price: 345, status: 1) 
    @invoice_item2 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice2.id, quantity: 1, unit_price: 345, status: 0) 
    @invoice_item3 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice3.id, quantity: 1, unit_price: 345, status: 1) 
    @invoice_item4 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice4.id, quantity: 1, unit_price: 345, status: 1) 
    @invoice_item5 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice5.id, quantity: 1, unit_price: 345, status: 1) 
    @invoice_item6 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice6.id, quantity: 1, unit_price: 345, status: 2) 

    @transaction1 = Transaction.create!(invoice_id: @invoice1.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 1)
    @transaction2 = Transaction.create!(invoice_id: @invoice2.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction3 = Transaction.create!(invoice_id: @invoice3.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction4 = Transaction.create!(invoice_id: @invoice4.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction5 = Transaction.create!(invoice_id: @invoice5.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction6 = Transaction.create!(invoice_id: @invoice6.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)

    visit "/merchants/#{@merchant1.id}/items/new"
  end

  describe "Create new item" do
    it "Has a form to fill out for a new item" do
      expect(page).to have_content("Create a new item")
      expect(page).to have_content("Add a Name:")
      expect(page).to have_content("Give a Description:")
      expect(page).to have_content("Set a Price:")
      expect(page).to have_button("Submit")
    end

    it "After making a new item, leads back to the '.../items/index' page" do
      fill_in "Add a Name:", with: "Fries"
      fill_in "Give a Description:", with: "Po-Ta-Toes, boil 'em, mash 'em, stick 'em in a stew"
      fill_in "Set a Price:", with: 5
      click_button "Submit"
      
      expect(current_path).to eq("/merchants/#{@merchant1.id}/items")
      within("div.disabled-items") do
        expect(page).to have_content("Fries")
      end
    end
  end
end