class CreatePrompts < ActiveRecord::Migration[7.1]
  def change
    create_table :prompts do |t|
      t.string :content
      t.date :date

      t.timestamps
    end
  end
end
