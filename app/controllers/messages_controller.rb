class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @room = Room.find(params[:room_id])
    unless @room.sender == current_user || @room.recipient == current_user
      head :forbidden
      return
    end

    @message = @room.messages.build(message_params)
    @message.user = current_user

    if @message.save
      redirect_to room_path(@room)
    else
      redirect_to room_path(@room), alert: "Message could not be sent."
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end