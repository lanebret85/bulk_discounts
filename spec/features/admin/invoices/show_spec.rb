require "rails_helper"

RSpec.describe "Admin Invoice Show Page", type: :feature do
  describe "when I visit '/admin/invoices/:invoice_id'" do
    it "I the invoice ic, invoice status, invoice created_at in correct format, and customer first and last name" do
      customer_1 = create(:customer)

      invoice_1 = create(:invoice, created_at: "2012-03-25 09:54:09 UTC", customer: customer_1)

      visit "/admin/invoices/#{invoice_1.id}"

      expect(page).to have_content("Invoice #{invoice_1.id}")
      expect(page).to have_content("Status: #{invoice_1.status}")
      expect(page).to have_content("Created: Sunday, March 25, 2012")
      expect(page).to have_content("Customer: #{customer_1.first_name} #{customer_1.last_name}")
    end
  end
end