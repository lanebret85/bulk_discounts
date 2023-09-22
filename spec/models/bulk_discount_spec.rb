require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe "relationships" do
    it { should have_many :merchant_bulk_discounts }
    it { should have_many(:merchants).through :merchant_bulk_discounts }
  end

  describe "validations" do
    it { should validate_presence_of :quantity_threshold }
    it { should validate_presence_of :percentage_discount }
    it { should validate_presence_of :description }
  end
end