class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.decimal :total_amount
      t.decimal :total_final
      t.string :status
      t.jsonb :discount_metadata
      t.timestamps
    end

    create_table :order_items do |t|
      t.integer :quantity
      t.decimal :price
      t.jsonb :product_metadata
      t.timestamps
    end

    add_reference :order_items, :order, foreign_key: true
    add_reference :orders, :user, foreign_key: true
  end
end
