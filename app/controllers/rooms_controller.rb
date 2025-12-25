class RoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    # 承認済みの部屋のみを表示（メッセージがある順）
    @rooms = current_user.rooms.order(updated_at: :desc)
  end

  # create, show, destroy はそのままでOKですが、
  # showのガード条件だけ再確認しておくと安心です
  
  def create
    # 1. 話したい相手を見つける
    recipient = User.find(params[:user_id])

    # 2. すでに部屋があるか探す（自分がSenderの場合と、Recipientの場合の両方）
    @room = Room.find_by(sender: current_user, recipient: recipient) ||
            Room.find_by(sender: recipient, recipient: current_user)

    # 3. 部屋がなければ新しく作る
    if @room.nil?
      @room = Room.create(sender: current_user, recipient: recipient)
    end

    # 4. その部屋（チャット画面）へ移動する
    redirect_to room_path(@room)
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