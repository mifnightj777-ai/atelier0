class UsersController < ApplicationController
  def show
    @user = User.find_by!(username: params[:username])
    if params[:tab] == 'saved' && current_user == @user
      @fragments = @user.liked_fragments.with_attached_image.includes(:user).order('likes.created_at DESC')
    else
      if current_user == @user
        @fragments = @user.fragments.with_attached_image.order(created_at: :desc)
      else
        @fragments = @user.fragments.public_view.with_attached_image.order(created_at: :desc)
      end
    end
  end
end
