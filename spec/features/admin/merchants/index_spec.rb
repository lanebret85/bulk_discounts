require "rails_helper"

RSpec.describe "Admin Merchants Index", type: :feature do
  describe "when I visit /admin/merchants" do
    it "each merchant name in the system" do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @merchant_3 = create(:merchant)

      visit "/admin/merchants"

      expect(page).to have_content(@merchant_1.name)
      expect(page).to have_content(@merchant_2.name)
      expect(page).to have_content(@merchant_3.name)
    end
  end
end