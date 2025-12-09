class RoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rooms = current_user.rooms.order(updated_at: :desc)
  end

  def show
    @room = Room.find(params[:id])
    unless @room.sender == current_user || @room.recipient == current_user
      redirect_to root_path, alert: "Access denied."
      return
    end
    @room.mark_as_read(current_user)
    @messages = @room.messages.includes(:user).order(created_at: :asc)
    @message = Message.new
  end

  def destroy
    @room = Room.find(params[:id])
    
    if @room.sender == current_user || @room.recipient == current_user
       @room.destroy
      redirect_to rooms_path, notice: "Dialogue ended and chat room deleted."
    else
      redirect_to root_path, alert: "Access denied."
    end
  end
end