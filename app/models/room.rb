class Room < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"
  
  has_many :messages, dependent: :destroy
  
  scope :between, -> (user_a, user_b) {
    where(sender: user_a, recipient: user_b).or(where(sender: user_b, recipient: user_a))
  }

  def has_unread_messages?(user)
    last_read = (user == sender) ? sender_last_read_at : recipient_last_read_at
    # まだ一度も開いていない、または最後の既読日時より後にメッセージがある場合
    last_read.nil? || messages.where("created_at > ?", last_read).where.not(user: user).exists?
  end

  def mark_as_read(user)
    if user == sender
      update(sender_last_read_at: Time.current)
    elsif user == recipient
      update(recipient_last_read_at: Time.current)
    end
  end
end