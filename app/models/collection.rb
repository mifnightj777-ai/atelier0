class Collection < ApplicationRecord
  belongs_to :user
  has_many :collection_items, dependent: :destroy
  has_many :fragments, through: :collection_items

  # 公開範囲の設定（enum）
  enum visibility: { public_view: 0, teammates_view: 1, private_view: 2 }

  # 閲覧者に合わせて「見せていい断片（Fragment）」だけを抽出するメソッド
  def visible_fragments_for(viewer)
    # 1. 閲覧者が本人（Owner）なら、隠し事なしで全部返す
    return fragments if viewer.present? && viewer.id == self.user_id

    # 2. チームメイト判定（IDで確実に比較）
    is_teammate = viewer.present? && (viewer.following.exists?(self.user_id) || viewer.followers.exists?(self.user_id))

    if is_teammate
      # 3. チームメイトなら：Public と Teammates限定。Private(2) は除外！
      fragments.where(visibility: [:public_view, :teammates_view])
    else
      # 4. 第三者（他人）なら：Public のみ
      fragments.where(visibility: :public_view)
    end
  end
end