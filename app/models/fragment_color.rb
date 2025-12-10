class FragmentColor < ApplicationRecord
  belongs_to :fragment
  validates :hex_code, presence: true, format: { with: /\A#[0-9A-Fa-f]{6}\z/ }
end
