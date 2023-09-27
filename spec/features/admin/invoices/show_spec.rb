require "rails_helper"

RSpec.describe "Admin Invoice Show Page", type: :feature do
  before(:each) do
    @customer_1 = create(:customer)

    @invoice_1 = create(:invoice, created_at: "2012-03-25 09:54:09 UTC", customer: @customer_1)

    @merchant_1 = create(:merchant)

    @item_1 = create(:item, merchant: @merchant_1)
    @item_2 = create(:item, merchant: @merchant_1)
    @item_3 = create(:item, merchant: @merchant_1)

    @invoice_item_1 = create(:invoice_item, quantity: 5, unit_price: 24642, invoice: @invoice_1, item: @item_1)
    @invoice_item_2 = create(:invoice_item, quantity: 8, unit_price: 12463, invoice: @invoice_1, item: @item_2)
    @invoice_item_3 = create(:invoice_item, quantity: 2, unit_price: 23567, invoice: @invoice_1, item: @item_3)

    visit admin_invoice_path(@invoice_1)
  end
  describe "when I visit '/admin/invoices/:invoice_id'" do
    it "I the invoice ic, invoice status, invoice created_at in correct format, and customer first and last name" do
      expect(page).to have_content("Invoice ##{@invoice_1.id}")
      expect(page).to have_select("Status:", selected: "#{@invoice_1.status}")
      expect(page).to have_content("Created on: Sunday, March 25, 2012")
      expect(page).to have_content("Customer: #{@customer_1.first_name} #{@customer_1.last_name}")
    end

    it "I see all of the invoice's items, including the item name, the quantity ordered, the price it sold at, and the invoice item status" do
      expect(page).to have_content("Items on this Invoice:")

      expect(page).to have_content("Item Name: #{@item_1.name} Quantity: #{@invoice_item_1.quantity} Unit Price: $246.42 Status: #{@invoice_item_1.status}")
      expect(page).to have_content("Item Name: #{@item_2.name} Quantity: #{@invoice_item_2.quantity} Unit Price: $124.63 Status: #{@invoice_item_2.status}")
      expect(page).to have_content("Item Name: #{@item_3.name} Quantity: #{@invoice_item_3.quantity} Unit Price: $235.67 Status: #{@invoice_item_3.status}")
    end

    it "I see the total revenue that will be generated from this invoice" do
      expect(page).to have_content("Total Revenue (without discounts): $2,700.48")
    end
  end

  describe "I see the invoice status is a select field with the current status selected" do
    describe "When I click this I can change the status for the invoice and use the button update invoice status" do
      it "when I click the button I am taken back to the show page and the status has been updated" do
      select "completed", from: "Status:"

      click_button "Update Invoice Status"

      expect(current_path).to eq(admin_invoice_path(@invoice_1.id))
      expect(page).to have_select("Status:", selected: "completed")
      end
    end
  end

  it "displays the total revenue from this invoice (not including discounts) and I see the total discounted revenue from this invoice which includes bulk discounts in the calculation" do
    merchant_2 = Merchant.create!(name: "POP BURGER SHOP")

    bulk_discount_1 = BulkDiscount.create!(quantity_threshold: 10, percentage_discount: 0.2, description: "20% off 10 items or more")
    bulk_discount_2 = BulkDiscount.create!(quantity_threshold: 15, percentage_discount: 0.3, description: "30% off 15 items or more")
    bulk_discount_3 = BulkDiscount.create!(quantity_threshold: 10, percentage_discount: 0.25, description: "25% off 10 items or more")
    bulk_discount_4 = BulkDiscount.create!(quantity_threshold: 5, percentage_discount: 0.05, description: "5% off 5 items or more")

    merchant_bulk_discount_1 = MerchantBulkDiscount.create!(merchant: @merchant_1, bulk_discount: bulk_discount_1)
    merchant_bulk_discount_2 = MerchantBulkDiscount.create!(merchant: @merchant_1, bulk_discount: bulk_discount_2)
    merchant_bulk_discount_3 = MerchantBulkDiscount.create!(merchant: merchant_2, bulk_discount: bulk_discount_3)
    merchant_bulk_discount_4 = MerchantBulkDiscount.create!(merchant: @merchant_1, bulk_discount: bulk_discount_4)

    customer_2 = Customer.create(first_name: "Steve", last_name: "Boo")
    customer_3 = Customer.create(first_name: "Joshil", last_name: "Moo")
    customer_4 = Customer.create(first_name: "Jon", last_name: "Stu")
    customer_5 = Customer.create(first_name: "Sarah", last_name: "Who")
    customer_6 = Customer.create(first_name: "Chandni", last_name: "Sue")
    customer_7 = Customer.create(first_name: "Dude", last_name: "Mike")

    item_4 = Item.create!(name: "Fries", unit_price: 36, merchant_id: @merchant_1.id, description: "Is Fries")

    invoice_2 = Invoice.create!(status: 1, customer_id: customer_2.id, created_at: 6.days.ago)
    invoice_3 = Invoice.create!(status: 1, customer_id: customer_3.id)
    invoice_4 = Invoice.create!(status: 1, customer_id: customer_4.id)
    invoice_5 = Invoice.create!(status: 1, customer_id: customer_5.id)
    invoice_6 = Invoice.create!(status: 1, customer_id: customer_6.id)
    invoice_7 = Invoice.create!(status: 1, customer_id: customer_7.id)

    invoice_item_4 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: invoice_4.id, quantity: 1, unit_price: 345, status: 1) 
    invoice_item_5 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: invoice_5.id, quantity: 1, unit_price: 345, status: 1) 
    invoice_item_6 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: invoice_6.id, quantity: 1, unit_price: 345, status: 2)
    invoice_item_7 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: invoice_7.id, quantity: 10, unit_price: 500, status: 1)

    transaction_1 = Transaction.create!(invoice_id: @invoice_1.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 1)
    transaction_2 = Transaction.create!(invoice_id: invoice_2.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    transaction_3 = Transaction.create!(invoice_id: invoice_3.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    transaction_4 = Transaction.create!(invoice_id: invoice_4.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    transaction_5 = Transaction.create!(invoice_id: invoice_5.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    transaction_6 = Transaction.create!(invoice_id: invoice_6.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)
    transaction_7 = Transaction.create!(invoice_id: invoice_7.id, credit_card_number: "1234567812345678", credit_card_expiration_date: "10/26", result: 0)

    visit admin_invoice_path(@invoice_1)

    expect(page).to have_content("Total Revenue (without discounts): $2,700.48")
    expect(page).to have_content("Total Revenue (including discounts): $2,589.02")
  end
end