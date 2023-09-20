class AddDefaultStatusToItems < ActiveRecord::Migration[7.0]
  def change
    change_column_default :items, :status, from: nil, to: 1
  end
end
