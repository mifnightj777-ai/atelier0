class FocusController < ApplicationController
  before_action :authenticate_user!
  layout "focus"

  def index
    @fragment = Fragment.new
  end
end