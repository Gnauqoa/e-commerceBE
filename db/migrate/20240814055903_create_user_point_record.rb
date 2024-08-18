class CreateUserPointRecord < ActiveRecord::Migration[7.1]
  def change
    create_table :user_point_records do |t|
      t.integer :points
      t.integer :type
      t.integer :amount
      t.timestamps
    end

    add_reference :user_point_records, :user, foreign_key: true
    add_reference :user_point_records, :user_lesson, foreign_key: true
  end
end
