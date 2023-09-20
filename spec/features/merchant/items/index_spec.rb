require 'rails_helper'

RSpec.describe "Merchant Items Index" do
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
    @item4 = Item.create!(name: "Hot Dog", unit_price: 8, merchant_id: @merchant1.id, description: "Food")
    @item5 = Item.create!(name: "Fries", unit_price: 4, merchant_id: @merchant1.id, description: "Food")
    @item6 = Item.create!(name: "Ice Cream", unit_price: 9, merchant_id: @merchant1.id, description: "Food")
    @item7 = Item.create!(name: "Smoothie", unit_price: 10, merchant_id: @merchant1.id, description: "Drink")
    @item8 = Item.create!(name: "Pizza", unit_price: 12, merchant_id: @merchant1.id, description: "Food")
    @item9 = Item.create!(name: "Chicken Wings", unit_price: 9, merchant_id: @merchant1.id, description: "Food")
    @item10 = Item.create!(name: "Salad", unit_price: 6, merchant_id: @merchant1.id, description: "Food")
    
    @invoice1 = Invoice.create!(status: 0, customer_id: @customer1.id)
    @invoice2 = Invoice.create!(status: 1, customer_id: @customer2.id, created_at: 6.days.ago)
    @invoice3 = Invoice.create!(status: 1, customer_id: @customer3.id)
    @invoice4 = Invoice.create!(status: 1, customer_id: @customer4.id)
    @invoice5 = Invoice.create!(status: 1, customer_id: @customer5.id)
    @invoice6 = Invoice.create!(status: 1, customer_id: @customer6.id)
    @invoice7 = Invoice.create!(status: 1, customer_id: @customer6.id)
    @invoice8 = Invoice.create!(status: 1, customer_id: @customer6.id)
    @invoice9 = Invoice.create!(status: 1, customer_id: @customer6.id)
    @invoice10 = Invoice.create!(status: 1, customer_id: @customer6.id)
    @invoice11 = Invoice.create!(status: 1, customer_id: @customer6.id)
    @invoice12 = Invoice.create!(status: 1, customer_id: @customer6.id)

    @invoice_item1 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice1.id, quantity: 1, unit_price: 345, status: 1) 
    @invoice_item2 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice2.id, quantity: 1, unit_price: 345, status: 0) 
    @invoice_item3 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice3.id, quantity: 1, unit_price: 345, status: 1) 
    @invoice_item4 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice4.id, quantity: 1, unit_price: 345, status: 1) 
    @invoice_item5 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice5.id, quantity: 1, unit_price: 345, status: 1) 
    @invoice_item6 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice6.id, quantity: 1, unit_price: 345, status: 2) 
    @invoice_item7 = InvoiceItem.create!(item_id: @item8.id, invoice_id: @invoice7.id, quantity: 1, unit_price: 345, status: 1)
    @invoice_item8 = InvoiceItem.create!(item_id: @item9.id, invoice_id: @invoice8.id, quantity: 1, unit_price: 345, status: 1)
    @invoice_item9 = InvoiceItem.create!(item_id: @item10.id, invoice_id: @invoice9.id, quantity: 1, unit_price: 345, status: 1)
    @invoice_item10 = InvoiceItem.create!(item_id: @item8.id, invoice_id: @invoice10.id, quantity: 1, unit_price: 345, status: 1)
    @invoice_item11 = InvoiceItem.create!(item_id: @item9.id, invoice_id: @invoice11.id, quantity: 1, unit_price: 345, status: 1)
    @invoice_item12 = InvoiceItem.create!(item_id: @item10.id, invoice_id: @invoice12.id, quantity: 1, unit_price: 345, status: 1)
  
    @transaction1 = Transaction.create!(invoice_id: @invoice1.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 1)
    @transaction2 = Transaction.create!(invoice_id: @invoice2.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction3 = Transaction.create!(invoice_id: @invoice3.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction4 = Transaction.create!(invoice_id: @invoice4.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction5 = Transaction.create!(invoice_id: @invoice5.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction6 = Transaction.create!(invoice_id: @invoice6.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction7 = Transaction.create!(invoice_id: @invoice7.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction8 = Transaction.create!(invoice_id: @invoice8.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction9 = Transaction.create!(invoice_id: @invoice9.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction10 = Transaction.create!(invoice_id: @invoice10.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction11 = Transaction.create!(invoice_id: @invoice11.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction12 = Transaction.create!(invoice_id: @invoice12.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)


    visit "/merchants/#{@merchant1.id}/items"
  end
  
  describe "Shows all the items for a merchant" do
    it "Can see the list" do
      within("div.item-list") do
        expect(page).to have_content(@item1.name)
        expect(page).to have_content(@item2.name)
        expect(page).to_not have_content(@item3.name)
      end
    end
  end

  describe "The items are links" do
    it "Goes to the item show page" do
      within("div.item-list") do
        expect(page).to have_link("#{@item1.name}")
        expect(page).to have_link("#{@item2.name}")
      end
      click_link("#{@item1.name}")
      expect(current_path).to eq("/merchants/#{@merchant1.id}/items/#{@item1.id}")
    end
  end

  describe "Next to each item there should be a 'disable' or 'enable' button" do
    it "The 'disable' or 'enable' buttons exist" do
      within("##{@item1.name}") do
        expect(page).to have_button("Enable")
        expect(page).to_not have_button("Disable")
      end
    end

    it "When the button is clicked, it updates the item's status" do
      within("##{@item1.name}") do
        expect(page).to have_button("Enable")
        expect(page).to_not have_button("Disable")
        click_button("Enable")
        expect(current_path).to eq("/merchants/#{@merchant1.id}/items")
        expect(page).to have_button("Disable")
      end 
    end
  end

  describe "Should have a 'disabled' and 'enabled' section" do
    it "Should have an 'disabled' section" do
      expect(page).to have_content("Disabled Items:")
      expect(page).to have_content("Enabled Items:")

      within("div.disabled-items") do
        expect(page).to have_content("#{@item1.name}")
        expect(page).to have_content("#{@item2.name}")
      end

      within("##{@item1.name}") do
        click_button("Enable")
      end

      within("div.enabled-items") do
        expect(page).to have_content("#{@item1.name}")
        expect(page).to_not have_content("#{@item2.name}")
      end
    end
  end

  describe "Create a new item" do
    it "Has a link to create a new item" do
      expect(page).to have_link("Create A New Item")
      click_link("Create A New Item")
      expect(current_path).to eq("/merchants/#{@merchant1.id}/items/new")

      expect(page).to have_content("Create a new item")
      expect(page).to have_content("Add a Name:")
      expect(page).to have_content("Give a Description:")
      expect(page).to have_content("Set a Price:")
      expect(page).to have_button("Submit")
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

  describe "Top 5 items" do
    it "Displays the names of the top 5 most popular items ranked by total revenue generated" do
      expect(page).to have_content("Top 5 Most Popular Items:")
      save_and_open_page
      within("div.top-5-items") do
        expect(page).to_not have_content("#{@item3.name}")
        expect(page).to_not have_content("#{@item4.name}")
        expect(page).to_not have_content("#{@item5.name}")
        expect(page).to_not have_content("#{@item6.name}")
        expect(page).to_not have_content("#{@item7.name}")
        expect(page).to have_content("#{@item2.name}")
        expect(page).to have_content("#{@item1.name}")
        expect(page).to have_content("#{@item8.name}")
        expect(page).to have_content("#{@item9.name}")
        expect(page).to have_content("#{@item10.name}")

        expect("#{@item2.name}").to appear_before("#{@item1.name}")
        expect("#{@item1.name}").to appear_before("#{@item8.name}")
        expect("#{@item8.name}").to appear_before("#{@item9.name}")
        expect("#{@item9.name}").to appear_before("#{@item10.name}")
      end
    end

    xit "Each item name links to my merchant item show page for that item" do

    end
    
    xit "Displays the total revenue generated next to each item name" do

    end
  end
end