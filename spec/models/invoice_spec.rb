require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
  end

  describe "enum" do
    it { should define_enum_for(:status).with_values(["cancelled", "completed", "in progress"]) }
  end

  describe "validations" do
    it { should validate_presence_of :status }
  end
end