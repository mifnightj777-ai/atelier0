class Fragment < ApplicationRecord
    has_one_attached :image
    belongs_to :user
    has_many :likes, dependent: :destroy
    enum visibility: { public_view: 0, private_view: 1, teammates_view: 2 }
    has_many :letters, dependent: :destroy
end
