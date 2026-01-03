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
end