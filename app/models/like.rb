class Like < ApplicationRecord
  belongs_to :user
  belongs_to :fragment
  validates :user_id, uniqueness: { scope: :fragment_id }
end
