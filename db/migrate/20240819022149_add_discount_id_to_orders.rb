class AddDiscountIdToOrders < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :discount, foreign_key: true, null: true
  end
end
