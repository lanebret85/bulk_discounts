class CreateBulkDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :bulk_discounts do |t|
      t.integer :quantity_threshold
      t.float :percentage_discount
      t.string :description

      t.timestamps
    end
  end
end
