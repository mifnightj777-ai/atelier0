class Fragment < ApplicationRecord
    has_one_attached :image
    belongs_to :user
    enum visibility: { public_view: 0, private_view: 1 }
end
