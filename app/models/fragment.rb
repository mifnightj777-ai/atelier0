class Fragment < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :likes, dependent: :destroy
  
  # enum
  enum visibility: { public_view: 0, private_view: 1, teammates_view: 2 }

  # Relationships
  has_many :letters, dependent: :destroy
  has_many :collection_items, dependent: :destroy
  has_many :collections, through: :collection_items
  has_many :fragment_colors, dependent: :destroy

  # Tree Structure (Family)
  belongs_to :parent, class_name: "Fragment", optional: true
  has_many :children, class_name: "Fragment", foreign_key: "parent_id", dependent: :nullify
  belongs_to :root, class_name: "Fragment", optional: true

  # 比較スタジオ関連
  has_many :comparisons_as_a, class_name: "Comparison", foreign_key: :fragment_a_id, dependent: :destroy
  has_many :comparisons_as_b, class_name: "Comparison", foreign_key: :fragment_b_id, dependent: :destroy
  def all_comparisons
    Comparison.where("fragment_a_id = ? OR fragment_b_id = ?", id, id)
  end

  # --- ▼ Callback 設定の整理 ▼ ---
  
  # 1. 保存前にルーツIDをセット
  before_create :set_root_id

  # 2. 画像の色抽出 (これが自動抽出の本丸です)
  #    create(新規) または update(更新) の後、画像があるなら実行します
  after_commit :extract_auto_colors, on: [:create, :update], if: -> { image.attached? }

  # --- ▲ Callback 設定ここまで ▲ ---

  private

  # ▼ 色抽出のメインロジック
  def extract_auto_colors
    return unless image.attached?
    begin
      # ActiveStorageからファイルを一時的に開く
      image.open do |tempfile|
        # MiniMagickで開く
        img = MiniMagick::Image.open(tempfile.path)

        # 処理を軽くするため、極小サイズ(7x1)にリサイズして色を混ぜる
        img.resize "7x1!"
        
        pixels = img.get_pixels
        return if pixels.empty?

        # ピクセル情報からHEXコードを取得
        hex_codes = pixels[0].map do |r, g, b|
          # 16bitカラー(0-65535)の場合の対策
          r = (r / 257).round if r > 255
          g = (g / 257).round if g > 255
          b = (b / 257).round if b > 255
          "#%02X%02X%02X" % [r, g, b]
        end.uniq

        # データベースへの保存（既存の自動抽出色は一度消して作り直す）
        transaction do
          fragment_colors.where(is_auto: true).destroy_all
          hex_codes.each do |hex|
            fragment_colors.create(hex_code: hex, is_auto: true)
          end
        end
      end
    rescue => e
      # エラーが起きてもアプリを止めないようにログに出すだけにする
      Rails.logger.error "Color extraction failed: #{e.message}"
    end
  end

  # ▼ 家系図のIDセット
  def set_root_id
    if parent.present?
      self.root_id = parent.root_id || parent.id
    else
    end
  end
end