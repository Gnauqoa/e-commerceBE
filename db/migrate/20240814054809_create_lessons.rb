class CreateLessons < ActiveRecord::Migration[7.1]
  def change
    create_table :lessons do |t|
      t.string :name
      t.string :description
      t.datetime :start_time
      t.datetime :end_time
      t.integer :points
      t.string :code
      t.string :user_notes
      t.string :coach_notes
      t.string :material_url
      t.timestamps
    end

    add_reference :lessons, :class, foreign_key: true
  end
end
