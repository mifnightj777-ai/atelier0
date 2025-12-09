class AddLastReadAtToRooms < ActiveRecord::Migration[7.1]
  def change
    add_column :rooms, :sender_last_read_at, :datetime
    add_column :rooms, :recipient_last_read_at, :datetime
  end
end
