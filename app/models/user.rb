class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :fragments, dependent: :destroy

  has_many :active_relationships, -> { where(status: :accepted) }, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, -> { where(status: :accepted) }, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :sent_requests, -> { where(status: :pending) }, class_name: "Relationship", foreign_key: "follower_id"
  has_many :received_requests, -> { where(status: :pending) }, class_name: "Relationship", foreign_key: "followed_id"
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy

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
end
