class CreateDisconunts < ActiveRecord::Migration[7.1]
  def change
    create_table :disconunts do |t|
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

    create_table :user_disconunts do |t|
      t.timestamps
    end

    add_reference :user_disconunts, :user, foreign_key: true
    add_reference :user_disconunts, :disconunt, foreign_key: true
  end
end
