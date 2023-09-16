require "rails_helper"

RSpec.describe "Admin Merchants Index", type: :feature do
  describe "when I visit /admin/merchants" do
    it "each merchant name in the system" do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @merchant_3 = create(:merchant)

      visit admin_merchants_path

      expect(page).to have_content(@merchant_1.name)
      expect(page).to have_content(@merchant_2.name)
      expect(page).to have_content(@merchant_3.name)
    end

    describe "has buttons for enable and disable next to each merchant" do
      it "when I click one of the buttons, I am redirected to admin_merchants_path and I see the change in merchant status" do
        @merchant_1 = create(:merchant)
        
        visit admin_merchants_path

        expect(page).to have_button("Enable #{@merchant_1.name}")

        click_button "Enable #{@merchant_1.name}"
        
        expect(current_path).to eq(admin_merchants_path)

        expect(page).to have_button("Disable #{@merchant_1.name}")
        expect(page).not_to have_button("Enable #{@merchant_1.name}")

        click_button "Disable #{@merchant_1.name}"

        expect(current_path).to eq(admin_merchants_path)

        expect(page).to have_button("Enable #{@merchant_1.name}")
        expect(page).not_to have_button("Disable #{@merchant_1.name}")
      end
    end

    it "I see two sections, 'Enabled Merchants' and 'Disabled Merchants' with the appropriate merchants in each section" do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)

      visit admin_merchants_path

      click_button "Enable #{@merchant_2.name}"

      within("#enabled-merchants") do
        expect(page).to have_content(@merchant_2.name)
      end

      within("#disabled-merchants") do
        expect(page).to have_content(@merchant_1.name)
      end
    end

    it "I see a link to create a new merchant, and when I click the link I am taken to a form to add merchant info" do
      visit admin_merchants_path

      expect(page).to have_link "Create a new merchant", href: "/admin/merchants/new"
    end

    it "I see the names of top 5 merchants by total revenue generated, each merchant name is a link to their show page, and I see the total revenuew of each merchant next to their name" do
      customer_1 = create(:customer)
      
      invoice_1 = create(:invoice, customer: customer_1, status: 2)
      invoice_2 = create(:invoice, customer: customer_1, status: 2)

      transaction_1 = create(:transaction, invoice: invoice_1, result: 0)
      transaction_2 = create(:transaction, invoice: invoice_2, result: 1)
      
      merchant_1 = Merchant.create!(name: "Sally's Store")
      merchant_2 = Merchant.create!(name: "Ray's Handmade Jewelry")
      merchant_3 = Merchant.create!(name: "Susy's Sweets")
      merchant_4 = Merchant.create!(name: "Gifts by Garrett")
      merchant_5 = Merchant.create!(name: "Real Leather Purses")
      merchant_6 = Merchant.create!(name: "Abby's Apples")

      item_for_merchant_1 = create(:item, merchant: merchant_1)
      item_for_merchant_2 = create(:item, merchant: merchant_2)
      item_for_merchant_3 = create(:item, merchant: merchant_3)
      item_for_merchant_4 = create(:item, merchant: merchant_4)
      item_for_merchant_5 = create(:item, merchant: merchant_5)
      item_for_merchant_6 = create(:item, merchant: merchant_6)

      invoice_item_1 = create(:invoice_item, quantity: 3, unit_price: 57295, item: item_for_merchant_1, invoice: invoice_1)
      invoice_item_2 = create(:invoice_item, quantity: 5, unit_price: 10385, item: item_for_merchant_1, invoice: invoice_2)
      invoice_item_3 = create(:invoice_item, quantity: 8, unit_price: 65020, item: item_for_merchant_2, invoice: invoice_1)
      invoice_item_4 = create(:invoice_item, quantity: 1, unit_price: 73920, item: item_for_merchant_3, invoice: invoice_1)
      invoice_item_5 = create(:invoice_item, quantity: 2, unit_price: 32563, item: item_for_merchant_4, invoice: invoice_1)
      invoice_item_6 = create(:invoice_item, quantity: 7, unit_price: 20375, item: item_for_merchant_5, invoice: invoice_1)
      invoice_item_7 = create(:invoice_item, quantity: 4, unit_price: 79285, item: item_for_merchant_6, invoice: invoice_1)

      top_five_merchants = Merchant.top_merchants

      visit admin_merchants_path

      expect(page).to have_content("Top Merchants")
      
      within("#top-five") do
        expect(page).to have_content("1. Ray's Handmade Jewelry - $5,201.60 in sales")
        expect(page).to have_content("2. Abby's Apples - $3,171.40 in sales")
        expect(page).to have_content("3. Sally's Store - $1,718.85 in sales")
        expect(page).to have_content("4. Real Leather Purses - $1,426.25 in sales")
        expect(page).to have_content("5. Susy's Sweets - $739.20 in sales")

        expect(merchant_2.name).to appear_before(merchant_6.name)
        expect(merchant_6.name).to appear_before(merchant_1.name)
        expect(merchant_1.name).to appear_before(merchant_5.name)
        expect(merchant_5.name).to appear_before(merchant_3.name)
      end
    end
  end
end