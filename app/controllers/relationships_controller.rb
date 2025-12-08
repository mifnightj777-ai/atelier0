class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:followed_id])
    relationship = current_user.follow(user)

    Notification.create(
      recipient: user,           # 相手
      sender: current_user,      # 自分
      action: "follow_request",  # 種類：リクエスト
      notifiable: relationship   # 対象：この関係データ
    )

    redirect_back(fallback_location: root_path)
  end

  def update
    relationship = Relationship.find(params[:id])

    if relationship.update(status: :accepted)
      
    Notification.create(
      recipient: relationship.follower, # 相手
      sender: current_user,             # 自分
      action: "request_accepted",       # 種類：承認完了
      notifiable: relationship
    )
    end

    redirect_back(fallback_location: root_path)
  end
  
  def destroy
    user = Relationship.find(params[:id]).followed
    current_user.unfollow(user)
    redirect_back(fallback_location: root_path)
  end
end