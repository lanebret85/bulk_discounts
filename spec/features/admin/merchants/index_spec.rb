require "rails_helper"

RSpec.describe "Admin Merchants Index", type: :feature do
  before(:each) do
    @customer_1 = create(:customer)

    @invoice_1 = create(:invoice, created_at: "2012-03-25 09:54:09 UTC", customer: @customer_1)
    @invoice_2 = create(:invoice, created_at: "2012-03-12 05:54:09 UTC", customer: @customer_1)
    @invoice_3 = create(:invoice, created_at: "2012-03-26 09:54:09 UTC", customer: @customer_1)
    @invoice_4 = create(:invoice, created_at: "2012-03-13 05:54:09 UTC", customer: @customer_1)
    @invoice_5 = create(:invoice, created_at: "2012-03-27 09:54:09 UTC", customer: @customer_1)
    @invoice_6 = create(:invoice, created_at: "2012-03-14 05:54:09 UTC", customer: @customer_1)
    @invoice_7 = create(:invoice, created_at: "2012-03-28 09:54:09 UTC", customer: @customer_1)
    @invoice_8 = create(:invoice, created_at: "2012-03-15 05:54:09 UTC", customer: @customer_1)
    @invoice_9 = create(:invoice, created_at: "2012-03-29 09:54:09 UTC", customer: @customer_1)
    @invoice_10 = create(:invoice, created_at: "2012-03-16 05:54:09 UTC", customer: @customer_1)
    
    @merchant_1 = Merchant.create!(name: "Sally's Store")
    @merchant_2 = Merchant.create!(name: "Ray's Handmade Jewelry")
    @merchant_3 = Merchant.create!(name: "Susy's Sweets")
    @merchant_4 = Merchant.create!(name: "Gifts by Garrett")
    @merchant_5 = Merchant.create!(name: "Real Leather Purses")
    @merchant_6 = Merchant.create!(name: "Abby's Apples")

    @item_for_merchant_1 = create(:item, merchant: @merchant_1)
    @item_for_merchant_2 = create(:item, merchant: @merchant_2)
    @item_for_merchant_3 = create(:item, merchant: @merchant_3)
    @item_for_merchant_4 = create(:item, merchant: @merchant_4)
    @item_for_merchant_5 = create(:item, merchant: @merchant_5)
    @item_for_merchant_6 = create(:item, merchant: @merchant_6)
  end

  describe "when I visit /admin/merchants" do
    it "each merchant name in the system" do
      visit admin_merchants_path

      expect(page).to have_content(@merchant_1.name)
      expect(page).to have_content(@merchant_2.name)
      expect(page).to have_content(@merchant_3.name)
    end

    describe "has buttons for enable and disable next to each merchant" do
      it "when I click one of the buttons, I am redirected to admin_merchants_path and I see the change in merchant status" do
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
      transaction_1 = create(:transaction, invoice: @invoice_1, result: 0)
      transaction_2 = create(:transaction, invoice: @invoice_2, result: 1)

      invoice_item_1 = create(:invoice_item, quantity: 3, unit_price: 57295, item: @item_for_merchant_1, invoice: @invoice_1)
      invoice_item_2 = create(:invoice_item, quantity: 5, unit_price: 10385, item: @item_for_merchant_1, invoice: @invoice_2)
      invoice_item_3 = create(:invoice_item, quantity: 8, unit_price: 65020, item: @item_for_merchant_2, invoice: @invoice_1)
      invoice_item_4 = create(:invoice_item, quantity: 1, unit_price: 73920, item: @item_for_merchant_3, invoice: @invoice_1)
      invoice_item_5 = create(:invoice_item, quantity: 2, unit_price: 32563, item: @item_for_merchant_4, invoice: @invoice_1)
      invoice_item_6 = create(:invoice_item, quantity: 7, unit_price: 20375, item: @item_for_merchant_5, invoice: @invoice_1)
      invoice_item_7 = create(:invoice_item, quantity: 4, unit_price: 79285, item: @item_for_merchant_6, invoice: @invoice_1)

      top_five_merchants = Merchant.top_merchants

      visit admin_merchants_path

      expect(page).to have_content("Top Merchants")
      
      within("#top-five") do
        expect(page).to have_content("1. Ray's Handmade Jewelry - $5,201.60 in sales")
        expect(page).to have_content("2. Abby's Apples - $3,171.40 in sales")
        expect(page).to have_content("3. Sally's Store - $1,718.85 in sales")
        expect(page).to have_content("4. Real Leather Purses - $1,426.25 in sales")
        expect(page).to have_content("5. Susy's Sweets - $739.20 in sales")

        expect(@merchant_2.name).to appear_before(@merchant_6.name)
        expect(@merchant_6.name).to appear_before(@merchant_1.name)
        expect(@merchant_1.name).to appear_before(@merchant_5.name)
        expect(@merchant_5.name).to appear_before(@merchant_3.name)
      end
    end

    it "I see the date that each top 5 merchant had their best day of total_revenue" do
      transaction_1 = create(:transaction, invoice: @invoice_1, result: 0)
      transaction_2 = create(:transaction, invoice: @invoice_2, result: 0)
      transaction_3 = create(:transaction, invoice: @invoice_3, result: 0)
      transaction_4 = create(:transaction, invoice: @invoice_4, result: 0)
      transaction_5 = create(:transaction, invoice: @invoice_5, result: 0)
      transaction_6 = create(:transaction, invoice: @invoice_6, result: 0)
      transaction_7 = create(:transaction, invoice: @invoice_7, result: 0)
      transaction_8 = create(:transaction, invoice: @invoice_8, result: 0)
      transaction_9 = create(:transaction, invoice: @invoice_9, result: 0)
      transaction_10 = create(:transaction, invoice: @invoice_10, result: 0)

      invoice_item_1 = create(:invoice_item, quantity: 3, unit_price: 57295, item: @item_for_merchant_1, invoice: @invoice_1)
      invoice_item_2 = create(:invoice_item, quantity: 8, unit_price: 65020, item: @item_for_merchant_1, invoice: @invoice_2)
      invoice_item_3 = create(:invoice_item, quantity: 7, unit_price: 20375, item: @item_for_merchant_2, invoice: @invoice_3)
      invoice_item_4 = create(:invoice_item, quantity: 2, unit_price: 32563, item: @item_for_merchant_2, invoice: @invoice_4)
      invoice_item_5 = create(:invoice_item, quantity: 5, unit_price: 10385, item: @item_for_merchant_3, invoice: @invoice_5)
      invoice_item_6 = create(:invoice_item, quantity: 1, unit_price: 73920, item: @item_for_merchant_3, invoice: @invoice_6)
      invoice_item_7 = create(:invoice_item, quantity: 4, unit_price: 79285, item: @item_for_merchant_5, invoice: @invoice_7)
      invoice_item_8 = create(:invoice_item, quantity: 9, unit_price: 34925, item: @item_for_merchant_5, invoice: @invoice_8)
      invoice_item_9 = create(:invoice_item, quantity: 6, unit_price: 90823, item: @item_for_merchant_6, invoice: @invoice_9)
      invoice_item_10 = create(:invoice_item, quantity: 10, unit_price: 86347, item: @item_for_merchant_6, invoice: @invoice_10)

      visit admin_merchants_path
      
      within("#top-five") do
        expect(page).to have_content("Top day for Abby's Apples was 3/16/12")
        expect(page).to have_content("Top day for Sally's Store was 3/12/12")
        expect(page).to have_content("Top day for Real Leather Purses was 3/28/12")
        expect(page).to have_content("Top day for Ray's Handmade Jewelry was 3/26/12")
        expect(page).to have_content("Top day for Susy's Sweets was 3/14/12")

        expect("3/16/12").to appear_before("3/12/12")
        expect("3/12/12").to appear_before("3/28/12")
        expect("3/28/12").to appear_before("3/26/12")
        expect("3/26/12").to appear_before("3/14/12")
      end
    end
  end
end