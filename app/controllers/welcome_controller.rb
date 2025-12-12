class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :guide]

  def index
    if user_signed_in?
      redirect_to fragments_path
    end
  end

  def guide
  end
end