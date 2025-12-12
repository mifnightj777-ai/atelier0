class AddPromptIdToFragments < ActiveRecord::Migration[7.1]
  def change
    add_reference :fragments, :prompt, null: true, foreign_key: true
  end
end
