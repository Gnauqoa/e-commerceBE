class CreateUserLessons < ActiveRecord::Migration[7.1]
  def change
    create_table :user_lessons do |t|
      t.integer :points
      t.integer :status
      t.string :submit_url
      t.string :coach_notes
      t.timestamps
    end

    add_reference :user_lessons, :user, foreign_key: true
    add_reference :user_lessons, :lesson, foreign_key: true
    add_reference :user_lessons, :coach, foreign_key: true
  end
end
