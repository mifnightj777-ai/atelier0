class AddVisibilityToCollections < ActiveRecord::Migration[7.0]
  def change
    unless column_exists?(:collections, :visibility)
      add_column :collections, :visibility, :integer, default: 0, null: false
    end
  end
end