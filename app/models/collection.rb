class Collection < ApplicationRecord
  belongs_to :user
  has_many :collection_items, dependent: :destroy
  has_many :fragments, through: :collection_items
  enum visibility: { view_private: 0, view_teammates: 1 }
  validates :title, presence: true
end