require "rails_helper"

RSpec.describe "Admin Invoices Index Page", type: :feature do
  describe "when I visit '/admin/invoices" do
    it "I see a list of all invoice ids in the system and each id links to the admin invoice show page" do
      customer_1 = create(:customer)

      invoices_for_customer_1 = create_list(:invoice, 5, customer: customer_1)

      visit admin_invoices_path

      expect(page).to have_content("Admin Invoices")

      invoices_for_customer_1.each do |invoice|
        expect(page).to have_link "#{invoice.id}", href: "/admin/invoices/#{invoice.id}"
      end
    end
  end
end