class AddTotalRequireToDiscount < ActiveRecord::Migration[7.1]
  def change
    add_column :discounts, :total_require, :decimal
    change_column_default :discounts, :status, 1
  end
end
