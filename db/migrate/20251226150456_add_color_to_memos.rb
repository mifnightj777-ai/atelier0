class AddColorToMemos < ActiveRecord::Migration[7.1]
  def change
    add_column :memos, :color, :string
  end
end
