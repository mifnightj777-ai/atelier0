class Prompt < ApplicationRecord
  has_many :fragments
  validates :content, presence: true
  validates :date, uniqueness: true # 同じ日に2つお題は作れない
end