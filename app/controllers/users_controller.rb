class UsersController < ApplicationController
  def show
    @user = User.find_by!(username: params[:username])
    @fragments = @user.fragments.with_attached_image.order(created_at: :desc)
  end
end
