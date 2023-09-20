require 'rails_helper'

RSpec.describe "Merchants Invoice Show Page", type: :feature do
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
        @item3 = Item.create!(name: "Pretzels", unit_price: 53457, merchant_id: @merchant2.id, description: "Is a Pretzel")
        
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

    end

    describe "Invoice Show Page" do
        it "shows all the details for a specific invoice" do
            visit "/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}"

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
            visit "/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}"
        
            @invoice1.invoice_items.each do |invoice_item|
              expect(page).to have_content(invoice_item.item.name)
              expect(page).to have_content(invoice_item.quantity)
              expect(page).to have_content((invoice_item.unit_price)/100.0)
              expect(page).to have_content(invoice_item.status)
            end
        end

        it 'does not display any information related to items for other merchants' do
            visit "/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}"
        
            @invoice1.invoice_items.each do |invoice_item|
              expect(page).to_not have_content(@item3.name)
              expect(page).to_not have_content(@item3.unit_price)
            end
        end

        it "has total revenue dispayed on the page" do
            visit "/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}"

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
    end
end