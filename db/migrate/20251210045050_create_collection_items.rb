class CreateCollectionItems < ActiveRecord::Migration[7.1]
  def change
    create_table :collection_items do |t|
      t.references :collection, null: false, foreign_key: true
      t.references :fragment, null: false, foreign_key: true

      t.timestamps
    end
    add_index :collection_items, [:collection_id, :fragment_id], unique: true
  end
end
