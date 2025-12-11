class CreateComparisons < ActiveRecord::Migration[7.1]
  def change
    create_table :comparisons do |t|
      t.references :user, null: false, foreign_key: true
      t.references :fragment_a, null: false, foreign_key: { to_table: :fragments }
      t.references :fragment_b, null: false, foreign_key: { to_table: :fragments }
      
      t.text :note

      t.timestamps
    end
    add_index :comparisons, [:fragment_a_id, :fragment_b_id], unique: true
  end
end
