class Collection < ApplicationRecord
  belongs_to :user
  has_many :collection_items, dependent: :destroy
  has_many :fragments, through: :collection_items
  enum visibility: { public_view: 0, private_view: 1, teammates_view: 2 }
  validates :title, presence: true
end