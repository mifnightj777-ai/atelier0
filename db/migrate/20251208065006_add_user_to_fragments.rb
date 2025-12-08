class AddUserToFragments < ActiveRecord::Migration[7.1]
  def change
    add_reference :fragments, :user, null: false, foreign_key: true
  end
end
