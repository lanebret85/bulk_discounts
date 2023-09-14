require "rails_helper"

RSpec.describe "Admin Merchants Show", type: :feature do
  describe "When I click on a merchants name" do
    it "takes to merchants admin show page and see merchant name" do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @merchant_3 = create(:merchant)

      visit admin_merchants_path

      click_on "#{@merchant_1.name}"

      expect(current_path).to eq("/admin/merchants/#{@merchant_1.id}")

      expect(page).to have_content("#{@merchant_1.name}")
    end
  end 
end