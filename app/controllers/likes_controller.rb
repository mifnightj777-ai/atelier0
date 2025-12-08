class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @fragment = Fragment.find(params[:fragment_id])

    unless current_user.already_liked?(@fragment)
      like = current_user.likes.create(fragment_id: @fragment.id)

      if @fragment.user != current_user
        Notification.create(
          recipient: @fragment.user,  # 作品の作者
          sender: current_user,       # 自分
          action: "like",             # 種類：いいね
          notifiable: like            # 対象：このいいねデータ
        )
      end
    end

    redirect_back(fallback_location: root_path)
  end

  def destroy
    @fragment = Fragment.find(params[:fragment_id])
    like = current_user.likes.find_by(fragment_id: @fragment.id)
    like.destroy if like

    redirect_back(fallback_location: root_path)
  end
end