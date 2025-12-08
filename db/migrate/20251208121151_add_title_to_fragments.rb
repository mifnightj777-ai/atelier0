class AddTitleToFragments < ActiveRecord::Migration[7.1]
  def change
    add_column :fragments, :title, :string
  end
end
