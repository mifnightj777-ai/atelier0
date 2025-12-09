class AddStatusToLetters < ActiveRecord::Migration[7.1]
  def change
    add_column :letters, :status, :integer, default: 0, null: false
  end
end
