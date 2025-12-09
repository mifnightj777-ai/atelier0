class Letter < ApplicationRecord
  belongs_to :fragment
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"
  validates :body, presence: true
  enum status: { pending: 0, accepted: 1, rejected: 2 }
end