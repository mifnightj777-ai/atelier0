class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :fragments, dependent: :destroy
  has_many :ideas, dependent: :destroy

  # ▼ 修正: リクエストもユーザー削除時に消えるように dependent: :destroy を追加
  has_many :active_relationships, -> { where(status: :accepted) }, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, -> { where(status: :accepted) }, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  
  # ▼ 修正: ここにも dependent: :destroy を追加（保留中のリクエストも消すため）
  has_many :sent_requests, -> { where(status: :pending) }, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :received_requests, -> { where(status: :pending) }, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  has_many :sent_letters, class_name: "Letter", foreign_key: "sender_id", dependent: :destroy
  has_many :received_letters, class_name: "Letter", foreign_key: "recipient_id", dependent: :destroy
  
  # 重複していた has_many :notifications を1つ削除しました
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy
  
  has_many :messages, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :comparisons, dependent: :destroy
  
  # ▼ 追加: これが今回のエラーの原因！Roomとのつながりを明記します
  has_many :sent_rooms, class_name: "Room", foreign_key: "sender_id", dependent: :destroy
  has_many :received_rooms, class_name: "Room", foreign_key: "recipient_id", dependent: :destroy

  has_one_attached :avatar

  validates :username, presence: true, uniqueness: true, length: { maximum: 20 }

  validate :password_complexity

  def password_complexity
    return if password.blank?
    unless password.match?(/\A(?=.*?[a-z])(?=.*?\d).{8,100}\z/i)
      errors.add :password, 'は8文字以上で、英字と数字をそれぞれ1文字以上含めてください'
    end
  end

  # これは検索用のメソッドなので、このままでOKです
  def rooms
    Room.where(sender: self).or(Room.where(recipient: self))
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def requesting?(other_user)
    sent_requests.exists?(followed_id: other_user.id)
  end

  def follow(other_user)
    Relationship.create(follower_id: id, followed_id: other_user.id, status: :pending)
  end

  def unfollow(other_user)
    relation = Relationship.find_by(follower_id: id, followed_id: other_user.id)
    relation.destroy if relation
  end

  def teammates_count
    (following.ids + followers.ids).uniq.count
  end

  has_many :likes, dependent: :destroy
  has_many :liked_fragments, through: :likes, source: :fragment

  def already_liked?(fragment)
    likes.exists?(fragment_id: fragment.id)
  end
  
  def teammate_with?(other_user)
    Relationship.where(follower: self, followed: other_user, status: :accepted)
                .or(Relationship.where(follower: other_user, followed: self, status: :accepted))
                .exists?
  end
end