require "rails_helper"

RSpec.describe "Admin Merchants New", type: :feature do
  describe "When I fill out the new merchant form and click submit" do
    it "takes me back to admin_merchants_path and I see the new merchant with a default status of disabled" do
      visit "/admin/merchants/new"

      expect(page).to have_content("New Merchant Info")
      expect(page).to have_content("Name:")

      fill_in :name, with: "Super Cool Business"

      click_on "Submit"

      expect(current_path).to eq("/admin/merchants")

      within("#disabled-merchants") do
        expect(page).to have_content("Super Cool Business")
      end
    end
  end
end