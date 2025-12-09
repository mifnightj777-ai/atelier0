class Room < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"
  
  has_many :messages, dependent: :destroy
  
  scope :between, -> (user_a, user_b) {
    where(sender: user_a, recipient: user_b).or(where(sender: user_b, recipient: user_a))
  }
end