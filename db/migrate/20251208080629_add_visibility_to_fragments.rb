class AddVisibilityToFragments < ActiveRecord::Migration[7.1]
  def change
    add_column :fragments, :visibility, :integer
  end
end
