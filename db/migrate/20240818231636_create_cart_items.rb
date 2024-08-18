class CreateCartItems < ActiveRecord::Migration[7.1]
  def change
    create_table :cart_items do |t|
      t.integer :quantity
      t.timestamps
    end

    add_reference :cart_items, :product, foreign_key: true
    add_reference :cart_items, :user, foreign_key: true
  end
end
