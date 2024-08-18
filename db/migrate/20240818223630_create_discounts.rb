class CreateDiscounts < ActiveRecord::Migration[7.1]
  def change
    create_table :discounts do |t|
      t.string :name
      t.decimal :percentage
      t.datetime :start_date
      t.datetime :end_date
      t.integer :rule
      t.integer :stock
      t.integer :quantity
      t.integer :status
      t.timestamps
    end

    create_table :user_discounts do |t|
      t.timestamps
    end

    add_reference :user_discounts, :user, foreign_key: true
    add_reference :user_discounts, :discount, foreign_key: true
  end
end
