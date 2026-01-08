class UsersController < ApplicationController
  def show
    @user = User.find_by("lower(username) = ?", params[:username].to_s.downcase) || User.find_by(id: params[:username])
    is_owner = (current_user == @user)
    is_teammate = user_signed_in? && (current_user.following.include?(@user) || @user.following.include?(current_user))
    
    if params[:tab] == 'saved' && is_owner
      @fragments = @user.liked_fragments.with_attached_image.includes(:user).order('likes.created_at DESC')
    else
      if is_owner
        @fragments = @user.fragments.with_attached_image.order(created_at: :desc)
      elsif is_teammate
        @fragments = @user.fragments.where(visibility: [:public_view, :teammates_view])
                                    .with_attached_image.order(created_at: :desc)
      else
        @fragments = @user.fragments.public_view.with_attached_image.order(created_at: :desc)
      end
    end

    if is_owner
      @collections = @user.collections.order(created_at: :desc)
    elsif is_teammate
      @collections = @user.collections.where(visibility: [:public_view, :teammates_view]).order(created_at: :desc)
    else
      @collections = @user.collections.public_view.order(created_at: :desc)
    end
  end
end