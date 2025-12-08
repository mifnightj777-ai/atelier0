class Notification < ApplicationRecord
  default_scope { order(created_at: :desc) }

  belongs_to :recipient, class_name: "User"
  belongs_to :sender, class_name: "User"
  belongs_to :notifiable, polymorphic: true, optional: true
  scope :unread, -> { where(read_at: nil) }
end