class AddStatusToUserDiscounts < ActiveRecord::Migration[7.1]
  def change
    add_column :user_discounts, :status, :integer, default: 1
    add_reference :user_discounts, :order, foreign_key: true
    add_reference :orders, :user_discount, foreign_key: true
  end
end
