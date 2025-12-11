class AddTreeInfoToFragments < ActiveRecord::Migration[7.0]
  def change
    add_reference :fragments, :parent, null: true, foreign_key: { to_table: :fragments }
    add_reference :fragments, :root, null: true, foreign_key: { to_table: :fragments }
  end
end