require 'rails_helper'

RSpec.describe MerchantBulkDiscount, type: :model do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should belong_to :bulk_discount }
  end
end