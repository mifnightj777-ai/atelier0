class AdminController < ApplicationController
  # ↓ ここでIDとパスワードを設定します（好きなものに変えてOKです！）
  http_basic_authenticate_with name: "admin_morphe026", password: "morphe05726&admiN"


  def users
    # 全ユーザーを登録が新しい順に取得
    @users = User.all.order(created_at: :desc)
  end

  def dashboard
    # ユーザー総数を取得
    @users_count = User.count
    @fragments_count = Fragment.count
  end

  def destroy_user
    @user = User.find(params[:id])
    
    # 【安全装置】もし削除対象が「今のログインユーザー（自分）」だったら、削除させない
    if @user == current_user
      redirect_to admin_users_path, alert: "管理者自身（あなた）を削除することはできません。"
      return
    end

    # ユーザーを削除
    @user.destroy
    redirect_to admin_users_path, notice: "ユーザー「@#{@user.username}」を削除しました。"
  end
end