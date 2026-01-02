class AddHandwritingDataToMemos < ActiveRecord::Migration[7.1]
  def change
    add_column :memos, :handwriting_data, :text
  end
end
