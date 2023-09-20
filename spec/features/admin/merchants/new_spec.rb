require "rails_helper"

RSpec.describe "Admin Merchants New", type: :feature do
  describe "When I fill out the new merchant form and click submit" do
    it "takes me back to admin_merchants_path and I see the new merchant with a default status of disabled" do
      visit new_admin_merchant_path

      expect(page).to have_content("New Merchant Info")
      expect(page).to have_content("Name:")

      fill_in :name, with: "Super Cool Business"

      click_on "Submit"

      expect(current_path).to eq(admin_merchants_path)

      within("#disabled-merchants") do
        expect(page).to have_content("Super Cool Business")
      end

      expect(page).to have_content("Merchant was created successfully!")
    end
  end

  it "when I do not fill out the information I see an error and am redirected back to the new page" do
    visit new_admin_merchant_path

    click_on "Submit"

    expect(page).to have_content("Merchant was not created successfully, please fill in a name!")
  end
end