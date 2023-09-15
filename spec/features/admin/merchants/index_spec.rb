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
  end
end