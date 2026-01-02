class Memo < ApplicationRecord
  belongs_to :idea
  has_one_attached :image

  validates :content, presence: true, unless: -> { handwriting_data.present? }

end