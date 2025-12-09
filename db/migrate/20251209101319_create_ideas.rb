class CreateIdeas < ActiveRecord::Migration[7.0]
  def change
    create_table :ideas do |t|
      t.string :title
      t.text :description
      t.integer :visibility, default: 1, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end