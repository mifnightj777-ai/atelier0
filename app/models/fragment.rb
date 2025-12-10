class Fragment < ApplicationRecord
    has_one_attached :image
    belongs_to :user
    has_many :likes, dependent: :destroy
    enum visibility: { public_view: 0, private_view: 1, teammates_view: 2 }
    has_many :letters, dependent: :destroy
    has_many :collection_items, dependent: :destroy
    has_many :collections, through: :collection_items
    has_many :fragment_colors, dependent: :destroy
    after_commit :extract_palette, on: [:create, :update], if: -> { attachment_changes['image'].present? }
    after_commit :extract_auto_colors, on: [:create, :update], if: -> { image.attached? }

    private

  def extract_auto_colors
    return unless image.attached?

    image.open do |tempfile|
      img = MiniMagick::Image.open(tempfile.path)

      img.resize "7x1!"
      
      pixels = img.get_pixels
      return if pixels.empty?

      hex_codes = pixels[0].map do |r, g, b|
        r = (r / 257).round if r > 255
        g = (g / 257).round if g > 255
        b = (b / 257).round if b > 255
        "#%02X%02X%02X" % [r, g, b]
      end.uniq

      transaction do
        fragment_colors.where(is_auto: true).destroy_all
        hex_codes.each do |hex|
          fragment_colors.create(hex_code: hex, is_auto: true)
        end
      end
    end
  rescue => e
    Rails.logger.error "Color extraction failed: #{e.message}"
  end
end
