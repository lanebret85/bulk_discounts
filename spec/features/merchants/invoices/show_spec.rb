require 'rails_helper'

RSpec.describe "Merchants Invoice Show Page", type: :feature do
  before (:each) do
    @merchant1 = Merchant.create!(name: "BOB BURGER SHOP")
    @merchant2 = Merchant.create!(name: "POP BURGER SHOP")

    @bulk_discount1 = BulkDiscount.create!(quantity_threshold: 10, percentage_discount: 0.2, description: "20% off 10 items or more")
    @bulk_discount2 = BulkDiscount.create!(quantity_threshold: 15, percentage_discount: 0.3, description: "30% off 15 items or more")
    @bulk_discount3 = BulkDiscount.create!(quantity_threshold: 10, percentage_discount: 0.25, description: "25% off 10 items or more")
    @bulk_discount4 = BulkDiscount.create!(quantity_threshold: 5, percentage_discount: 0.05, description: "5% off 5 items or more")

    @merchant_bulk_discount1 = MerchantBulkDiscount.create!(merchant: @merchant1, bulk_discount: @bulk_discount1)
    @merchant_bulk_discount2 = MerchantBulkDiscount.create!(merchant: @merchant1, bulk_discount: @bulk_discount2)
    @merchant_bulk_discount3 = MerchantBulkDiscount.create!(merchant: @merchant2, bulk_discount: @bulk_discount3)
    @merchant_bulk_discount4 = MerchantBulkDiscount.create!(merchant: @merchant1, bulk_discount: @bulk_discount4)

    @customer1 = Customer.create(first_name: "Cindy", last_name: "Loo")
    @customer2 = Customer.create(first_name: "Steve", last_name: "Boo")
    @customer3 = Customer.create(first_name: "Joshil", last_name: "Moo")
    @customer4 = Customer.create(first_name: "Jon", last_name: "Stu")
    @customer5 = Customer.create(first_name: "Sarah", last_name: "Who")
    @customer6 = Customer.create(first_name: "Chandni", last_name: "Sue")
    @customer7 = Customer.create(first_name: "Dude", last_name: "Mike")
    
    @item1 = Item.create!(name: "Burger", unit_price: 15, merchant_id: @merchant1.id, description: "Is a Burger")
    @item2 = Item.create!(name: "Soda", unit_price: 7, merchant_id: @merchant1.id, description: "Is a Soda")
    @item3 = Item.create!(name: "Pretzels", unit_price: 53457, merchant_id: @merchant2.id, description: "Is a Pretzel")
    @item4 = Item.create!(name: "Fries", unit_price: 36, merchant_id: @merchant1.id, description: "Is Fries")
    
    @invoice1 = Invoice.create!(status: 0, customer_id: @customer1.id)
    @invoice2 = Invoice.create!(status: 1, customer_id: @customer2.id, created_at: 6.days.ago)
    @invoice3 = Invoice.create!(status: 1, customer_id: @customer3.id)
    @invoice4 = Invoice.create!(status: 1, customer_id: @customer4.id)
    @invoice5 = Invoice.create!(status: 1, customer_id: @customer5.id)
    @invoice6 = Invoice.create!(status: 1, customer_id: @customer6.id)
    @invoice7 = Invoice.create!(status: 1, customer_id: @customer7.id)
    
    @invoice_item1 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice1.id, quantity: 1, unit_price: 345, status: 1) 
    @invoice_item2 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice2.id, quantity: 1, unit_price: 345, status: 0) 
    @invoice_item3 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice3.id, quantity: 1, unit_price: 345, status: 1) 
    @invoice_item4 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice4.id, quantity: 1, unit_price: 345, status: 1) 
    @invoice_item5 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice5.id, quantity: 1, unit_price: 345, status: 1) 
    @invoice_item6 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice6.id, quantity: 1, unit_price: 345, status: 2) 
    @invoice_item7 = InvoiceItem.create!(item_id: @item4.id, invoice_id: @invoice7.id, quantity: 5, unit_price: 345, status: 2) 

    @transaction1 = Transaction.create!(invoice_id: @invoice1.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 1)
    @transaction2 = Transaction.create!(invoice_id: @invoice2.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction3 = Transaction.create!(invoice_id: @invoice3.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction4 = Transaction.create!(invoice_id: @invoice4.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction5 = Transaction.create!(invoice_id: @invoice5.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction6 = Transaction.create!(invoice_id: @invoice6.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    @transaction7 = Transaction.create!(invoice_id: @invoice7.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
  end

  describe "Invoice Show Page" do
    it "shows all the details for a specific invoice" do
      visit merchant_invoice_path(@merchant1, @invoice1)

      expect(page).to have_content("Invoice #{@invoice1.id}")
      expect(page).to have_content("Status: cancelled")
      expect(page).to have_content("Created on: #{@invoice1.created_at.strftime("%A, %B %-d, %Y")}")
      expect(page).to have_content("Customer: #{@invoice1.customer.full_name}")
    end

    it "has a link to take you back to the merchants invoices page" do
      visit "/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}"

      expect(page).to have_content("Invoice #{@invoice1.id}")
      expect(page).to have_link("#{@merchant1.name}")

      click_link("#{@merchant1.name}")

      expect(current_path).to eq("/merchants/#{@merchant1.id}/invoices")
    end

    it 'displays item name, quantity, price, and invoice item status for this merchant' do
      visit merchant_invoice_path(@merchant1, @invoice1)
  
      @invoice1.invoice_items.each do |invoice_item|
        expect(page).to have_content(invoice_item.item.name)
        expect(page).to have_content(invoice_item.quantity)
        expect(page).to have_content((invoice_item.unit_price)/100.0)
        expect(page).to have_content(invoice_item.status)
      end
    end

    it 'does not display any information related to items for other merchants' do
      visit merchant_invoice_path(@merchant1, @invoice1)
  
      @invoice1.invoice_items.each do |invoice_item|
        expect(page).to_not have_content(@item3.name)
        expect(page).to_not have_content(@item3.unit_price)
      end
    end

    it "has total revenue dispayed on the page" do
      visit merchant_invoice_path(@merchant1, @invoice1)

      expect(page).to have_content((@invoice1.total_revenue)/100.0)
    end

    it "shows the status of each item" do
      visit merchant_invoice_path(@merchant1, @invoice1)

      expect(page).to have_content("Items on this Order:")
    
      expect(page).to have_content("Status:")
      expect(page).to have_select(:status, with_options: ["shipped", "packaged", "pending"], selected: "pending")
      expect(page).to have_button("Update Item Status")
    end

    it "updates item status when you click to update status" do
      visit merchant_invoice_path(@merchant1, @invoice1)
  
      expect(page).to have_select(:status, selected: "pending")
      select("packaged", from: "status")
      click_button("Update Item Status")

      expect(current_path).to eq(merchant_invoice_path(@merchant1, @invoice1))   
      expect(page).to have_select(:status, selected: "packaged")
    end

    it "displays the total revenue for my merchant from this invoice (not including discounts) and I see the total discounted revenue for my merchant from this invoice which includes bulk discounts in the calculation" do
      invoice_item7 = InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice1.id, quantity: 10, unit_price: 500, status: 1)

      visit "/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}"

      within ".invoice-info" do   
        expect(page).to have_content("Total Revenue (without discounts): $53.45")
        expect(page).to have_content("Total Revenue (including discounts): $43.45")
      end
    end

    it "displays a link to the show page for the bulk discount that was applied to each invoice item next to that invoice item" do
      visit "/merchants/#{@merchant1.id}/invoices/#{@invoice7.id}"

      within(".show-table") do
        expect(page).to have_content("Applied Discount")
        expect(page).to have_link("Applied Discount for #{@item4.name}")
      end

      click_on "Applied Discount for #{@item4.name}"

      expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount4.id}")
    end
  end
end