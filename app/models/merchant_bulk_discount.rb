class MerchantBulkDiscount < ApplicationRecord
  belongs_to :merchant
  belongs_to :bulk_discount
end