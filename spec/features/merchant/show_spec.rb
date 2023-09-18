require 'rails_helper'

RSpec.describe "Merchants dashboard", type: :feature do
    before (:each) do
        @merchant1 = Merchant.create!(name: "BOB BURGER SHOP")
        @merchant2 = Merchant.create!(name: "POP BURGER SHOP")

        @customer1 = Customer.create(first_name: "Cindy", last_name: "Loo")
        @customer2 = Customer.create(first_name: "Steve", last_name: "Boo")
        @customer3 = Customer.create(first_name: "Joshil", last_name: "Moo")
        @customer4 = Customer.create(first_name: "Jon", last_name: "Stu")
        @customer5 = Customer.create(first_name: "Sarah", last_name: "Who")
        @customer6 = Customer.create(first_name: "Chandni", last_name: "Sue")
        
        @item1 = Item.create!(name: "Burger", unit_price: 15, merchant_id: @merchant1.id)
        @item2 = Item.create!(name: "Soda", unit_price: 7, merchant_id: @merchant1.id)
        @item3 = Item.create!(name: "Pretzels", unit_price: 7, merchant_id: @merchant2.id)
        
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

        visit "/merchants/#{@merchant1.id}/dashboard"
    end

    describe "as a merchant" do
        it "Shows name of the merchant on dashboard" do
            expect(page).to have_content(@merchant1.name)
        end
    end

    describe "Shows merchant links" do 
        it "has a items index link" do
            expect(page).to have_link('My Items')
            click_link("My Items")
            expect(current_path).to eq("/merchants/#{@merchant1.id}/items")
        end

        it "has a items invoices link" do
            expect(page).to have_link('My Invoices')
            click_link("My Invoices")
            expect(current_path).to eq("/merchants/#{@merchant1.id}/invoices")
        end
    end

    describe "Merchant Dashboard Stats" do
        it "shows names of the top five customers" do
            expect(page).to_not have_content("Cindy Loo")
            expect(page).to have_content("Steve Boo Successful Transactions: 1")
            expect(page).to have_content("Joshil Moo Successful Transactions: 1")
            expect(page).to have_content("Jon Stu Successful Transactions: 1")
            expect(page).to have_content("Sarah Who Successful Transactions: 1")
            expect(page).to have_content("Chandni Sue Successful Transactions: 1")
        end
    end

    describe "Item's ready to ship section" do
        it "will have a section for items ready to be shipped" do
            within("div.items-to-ship") do
                expect(page).to have_content(@item1.name)
                expect(page).to have_content(@item2.name)
                expect(page).to_not have_content(@item3.name)
            end
        end

        it "will have the id of each next to the item name" do
            within("div.items-to-ship") do
                expect(page).to have_content(@invoice1.id)
                expect(page).to have_content(@invoice2.id)
                expect(page).to have_content(@invoice3.id)
                expect(page).to have_content(@invoice4.id)
                expect(page).to have_content(@invoice5.id)
                expect(page).to_not have_content(@invoice6.id)
            end
        end

        it "the id of each item links to the merchant invoice show page" do
            within("div.items-to-ship") do
                expect(page).to have_link("#{@invoice1.id}")
                click_link("#{@invoice1.id}")
                expect(current_path).to eq("/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}")
            end
        end

        it "shows the date the invoice was created" do
            within("div.items-to-ship") do
                expect(page).to have_content(@invoice1.created_at.strftime("%A, %B %-d, %Y"))
                expect(page).to have_content(@invoice2.created_at.strftime("%A, %B %-d, %Y"))
                expect(page).to have_content(@invoice3.created_at.strftime("%A, %B %-d, %Y"))

                expect(@invoice2.created_at.strftime("%A, %B %-d, %Y")).to appear_before(@invoice1.created_at.strftime("%A, %B %-d, %Y"))
            end
        end
    end
end