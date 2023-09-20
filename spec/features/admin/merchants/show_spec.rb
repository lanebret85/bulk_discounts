require "rails_helper"

RSpec.describe "Admin Merchants Show", type: :feature do
  before(:each) do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @merchant_3 = create(:merchant)
  end
  describe "When I click on a merchants name" do
    it "takes to merchants admin show page and see merchant name" do
      visit admin_merchants_path

      click_on "#{@merchant_1.name}"

      expect(current_path).to eq(admin_merchant_path(@merchant_1.id))

      expect(page).to have_content("#{@merchant_1.name}")
    end
  end

  describe "When I visit /admin/merchants/:merchant_id" do
    it "I see a link to update the merchant's information that takes me to the merchant edit page when I click on it" do
      visit admin_merchant_path(@merchant_1)

      expect(page).to have_link "Update", href: edit_admin_merchant_path(@merchant_1)
    end
  end
end