class CreateFragments < ActiveRecord::Migration[7.1]
  def change
    create_table :fragments do |t|
      t.text :description

      t.timestamps
    end
  end
end
