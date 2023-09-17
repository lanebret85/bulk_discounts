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
  end
  describe "when I visit '/admin/invoices/:invoice_id'" do
    it "I the invoice ic, invoice status, invoice created_at in correct format, and customer first and last name" do
      visit "/admin/invoices/#{@invoice_1.id}"

      expect(page).to have_content("Invoice ##{@invoice_1.id}")
      expect(page).to have_select("Status:", selected: "#{@invoice_1.status}")
      expect(page).to have_content("Created on: Sunday, March 25, 2012")
      expect(page).to have_content("Customer: #{@customer_1.first_name} #{@customer_1.last_name}")
    end

    it "I see all of the invoice's items, including the item name, the quantity ordered, the price it sold at, and the invoice item status" do
      visit "/admin/invoices/#{@invoice_1.id}"

      expect(page).to have_content("Items on this Invoice:")

      expect(page).to have_content("Item Name: #{@item_1.name} Quantity: #{@invoice_item_1.quantity} Unit Price: $246.42 Status: #{@invoice_item_1.status}")
      expect(page).to have_content("Item Name: #{@item_2.name} Quantity: #{@invoice_item_2.quantity} Unit Price: $124.63 Status: #{@invoice_item_2.status}")
      expect(page).to have_content("Item Name: #{@item_3.name} Quantity: #{@invoice_item_3.quantity} Unit Price: $235.67 Status: #{@invoice_item_3.status}")
    end

    it "I see the total revenue that will be generated from this invoice" do
      visit "/admin/invoices/#{@invoice_1.id}"

      expect(page).to have_content("Total Revenue: $2,700.48")
    end
  end

  describe "I see the invoice status is a select field with the current status selected" do
    describe "When I click this I can change the status for the invoice and use the button update invoice status" do
      it "when I click the button I am taken back to the show page and the status has been updated" do
      visit "/admin/invoices/#{@invoice_1.id}"

      select "completed", from: "Status:"

      click_button "Update Invoice"

      expect(page).to have_select("Status:", selected: "completed")
      end
    end
  end
end