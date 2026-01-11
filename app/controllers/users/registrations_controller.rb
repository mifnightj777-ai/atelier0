class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def update_resource(resource, params)
    # ユーザーがパスワードを入力しているかチェック
    if params[:password].present? || params[:password_confirmation].present?
      # パスワード変更しようとしている場合 -> 現在のパスワードが必要
      resource.update_with_password(params)
    else
      # プロフィール更新のみの場合 -> パスワード不要
      # (不要なcurrent_passwordパラメータを削除して更新)
      params.delete(:current_password)
      resource.update_without_password(params)
    end
  end

  def after_update_path_for(resource)
    user_profile_path(resource.username)
  end
end