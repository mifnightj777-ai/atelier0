class Idea < ApplicationRecord
  belongs_to :user
  enum visibility: { public_view: 0, private_view: 1, teammates_view: 2 }
  validates :title, presence: true
end