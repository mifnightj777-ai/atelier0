class CollectionItem < ApplicationRecord
  belongs_to :collection
  belongs_to :fragment
  validates :fragment_id, uniqueness: { scope: :collection_id }
end