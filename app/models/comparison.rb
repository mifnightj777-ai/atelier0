class Comparison < ApplicationRecord
  belongs_to :user

  belongs_to :fragment_a, class_name: "Fragment"
  belongs_to :fragment_b, class_name: "Fragment"

  validates :fragment_a_id, uniqueness: { scope: :fragment_b_id }
end