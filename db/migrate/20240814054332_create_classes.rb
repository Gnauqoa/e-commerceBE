class CreateClasses < ActiveRecord::Migration[7.1]
  def change
    create_table :classes do |t|
      t.string :name
      t.string :description
      t.timestamps
    end
    create_table :user_classes do |t|
      t.timestamps
    end

    add_reference :user_classes, :user, foreign_key: true
    add_reference :user_classes, :class, foreign_key: true

  end
end
