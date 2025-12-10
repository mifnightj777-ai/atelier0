class CreateFragmentColors < ActiveRecord::Migration[7.1]
  def change
    create_table :fragment_colors do |t|
      t.references :fragment, null: false, foreign_key: true
      t.string :hex_code
      t.boolean :is_auto

      t.timestamps
    end
  end
end
