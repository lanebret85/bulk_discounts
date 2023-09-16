require 'rails_helper'

RSpec.describe "Invoice Index", type: :feature do
    before (:each) do
        @merchant1 = Merchant.create!(name: "BOB BURGER SHOP")
        @merchant2 = Merchant.create!(name: "POP BURGER SHOP")

        @customer1 = Customer.create(first_name: "Cindy", last_name: "Loo")
        @customer2 = Customer.create(first_name: "Steve", last_name: "Boo")
        @customer3 = Customer.create(first_name: "Joshil", last_name: "Moo")
        @customer4 = Customer.create(first_name: "Jon", last_name: "Stu")
        @customer5 = Customer.create(first_name: "Sarah", last_name: "Who")
        @customer6 = Customer.create(first_name: "Chandni", last_name: "Sue")
        @customer7 = Customer.create(first_name: "Dylan", last_name: "Scott")
        
        @item1 = Item.create!(name: "Burger", unit_price: 15, merchant_id: @merchant1.id)
        @item2 = Item.create!(name: "Soda", unit_price: 7, merchant_id: @merchant1.id)
        @item3 = Item.create!(name: "Pretzels", unit_price: 7, merchant_id: @merchant2.id)
        
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
        @invoice_item7 = InvoiceItem.create!(item_id: @item3.id, invoice_id: @invoice7.id, quantity: 1, unit_price: 111, status: 2)

        @transaction1 = Transaction.create!(invoice_id: @invoice1.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 1)
        @transaction2 = Transaction.create!(invoice_id: @invoice2.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
        @transaction3 = Transaction.create!(invoice_id: @invoice3.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
        @transaction4 = Transaction.create!(invoice_id: @invoice4.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
        @transaction5 = Transaction.create!(invoice_id: @invoice5.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
        @transaction6 = Transaction.create!(invoice_id: @invoice6.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
        @transaction7 = Transaction.create!(invoice_id: @invoice7.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)

        visit "/merchants/#{@merchant1.id}/invoices"
    end

    describe "Merchant Invoices Index" do
        it "show invoices that include merchant's items and an id that is linked" do
            expect(page).to have_content("#{@merchant1.name} Invoices")

            expect(page).to have_link("Invoice #{@invoice1.id}", href: "/merchants/#{@merchant1.id}/invoices/#{@invoice1.id}")
            expect(page).to have_link("Invoice #{@invoice2.id}", href: "/merchants/#{@merchant1.id}/invoices/#{@invoice2.id}")
            expect(page).to have_link("Invoice #{@invoice3.id}", href: "/merchants/#{@merchant1.id}/invoices/#{@invoice3.id}")
            expect(page).to have_link("Invoice #{@invoice4.id}", href: "/merchants/#{@merchant1.id}/invoices/#{@invoice4.id}")
            expect(page).to have_link("Invoice #{@invoice5.id}", href: "/merchants/#{@merchant1.id}/invoices/#{@invoice5.id}")
            expect(page).to have_link("Invoice #{@invoice6.id}", href: "/merchants/#{@merchant1.id}/invoices/#{@invoice6.id}")
            expect(page).to_not have_link("Invoice ##{@invoice7.id}")

        end
    end
end