require "rails_helper"

RSpec.describe "Admin Dashboard", type: :feature do
  before :each do
    
  end

  describe "When I visit the admin dashboard" do
    it "displays a header 'Admin Dashboard'" do
      visit "/admin"

      expect(page).to have_content("Admin Dashboard")
    end

    it "displays links to the admin merchants index" do
      visit "/admin"

      click_link "Admin Merchants Index"

      expect(current_path).to eq(admin_merchants_path)
    end

    it "displays a link to the admin invoices index" do
      visit "/admin"

      click_link "Admin Invoices Index"

      expect(current_path).to eq("/admin/invoices")
    end

    it "displays the names of the top 5 customers who have the most transactions that are successful, and I see the number of successful transactions they've had next to each" do
      customer_1 = create(:customer)
      customer_2 = create(:customer)
      customer_3 = create(:customer)
      customer_4 = create(:customer)
      customer_5 = create(:customer)
      customer_6 = create(:customer)

      invoice_1 = create(:invoice, customer: customer_1, status: 1)
      invoice_2 = create(:invoice, customer: customer_2, status: 1)
      invoice_3 = create(:invoice, customer: customer_3, status: 1)
      invoice_4 = create(:invoice, customer: customer_4, status: 1)
      invoice_5 = create(:invoice, customer: customer_5, status: 1)
      invoice_6 = create(:invoice, customer: customer_6, status: 1)

      transaction_1 = create(:transaction, invoice: invoice_1, result: 0)
      transaction_2 = create(:transaction, invoice: invoice_1, result: 0)
      transaction_3 = create(:transaction, invoice: invoice_1, result: 0)
      transaction_4 = create(:transaction, invoice: invoice_1, result: 0)
      transaction_5 = create(:transaction, invoice: invoice_1, result: 0)
      transaction_6 = create(:transaction, invoice: invoice_1, result: 0)
      transaction_7 = create(:transaction, invoice: invoice_2, result: 0)
      transaction_8 = create(:transaction, invoice: invoice_2, result: 0)
      transaction_9 = create(:transaction, invoice: invoice_2, result: 0)
      transaction_10 = create(:transaction, invoice: invoice_2, result: 0)
      transaction_11 = create(:transaction, invoice: invoice_2, result: 0)
      transaction_12 = create(:transaction, invoice: invoice_2, result: 1)
      transaction_13 = create(:transaction, invoice: invoice_3, result: 0)
      transaction_14 = create(:transaction, invoice: invoice_3, result: 0)
      transaction_15 = create(:transaction, invoice: invoice_3, result: 0)
      transaction_16 = create(:transaction, invoice: invoice_3, result: 0)
      transaction_17 = create(:transaction, invoice: invoice_3, result: 1)
      transaction_18 = create(:transaction, invoice: invoice_3, result: 1)
      transaction_19 = create(:transaction, invoice: invoice_4, result: 0)
      transaction_20 = create(:transaction, invoice: invoice_4, result: 0)
      transaction_21 = create(:transaction, invoice: invoice_4, result: 0)
      transaction_22 = create(:transaction, invoice: invoice_4, result: 1)
      transaction_23 = create(:transaction, invoice: invoice_4, result: 1)
      transaction_24 = create(:transaction, invoice: invoice_4, result: 1)
      transaction_25 = create(:transaction, invoice: invoice_5, result: 0)
      transaction_26 = create(:transaction, invoice: invoice_5, result: 0)
      transaction_27 = create(:transaction, invoice: invoice_5, result: 1)
      transaction_28 = create(:transaction, invoice: invoice_5, result: 1)
      transaction_29 = create(:transaction, invoice: invoice_5, result: 1)
      transaction_30 = create(:transaction, invoice: invoice_5, result: 1)
      transaction_31 = create(:transaction, invoice: invoice_6, result: 0)
      transaction_32 = create(:transaction, invoice: invoice_6, result: 1)
      transaction_33 = create(:transaction, invoice: invoice_6, result: 1)
      transaction_34 = create(:transaction, invoice: invoice_6, result: 1)
      transaction_35 = create(:transaction, invoice: invoice_6, result: 1)
      transaction_36 = create(:transaction, invoice: invoice_6, result: 1)

      visit "/admin"

      expect(page).to have_content("Top 5 Customers:")
      within "#top-five" do
        expect(page).to have_content("1. #{customer_1.first_name} #{customer_1.last_name} - 6 purchases")
        expect(page).to have_content("2. #{customer_2.first_name} #{customer_2.last_name} - 5 purchases")
        expect(page).to have_content("3. #{customer_3.first_name} #{customer_3.last_name} - 4 purchases")
        expect(page).to have_content("4. #{customer_4.first_name} #{customer_4.last_name} - 3 purchases")
        expect(page).to have_content("5. #{customer_5.first_name} #{customer_5.last_name} - 2 purchases")

        expect(customer_1.first_name).to appear_before(customer_2.first_name)
        expect(customer_2.first_name).to appear_before(customer_3.first_name)
        expect(customer_3.first_name).to appear_before(customer_4.first_name)
        expect(customer_4.first_name).to appear_before(customer_5.first_name)
        expect(page).to_not have_content(customer_6.first_name)
      end
    end
  end
end