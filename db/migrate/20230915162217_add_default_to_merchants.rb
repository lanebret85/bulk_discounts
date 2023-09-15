class AddDefaultToMerchants < ActiveRecord::Migration[7.0]
  def change
    change_column_default :merchants, :status, from: nil, to: 1
  end
end
