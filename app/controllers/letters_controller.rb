class LettersController < ApplicationController
  before_action :authenticate_user!

  def index
    @letters = current_user.received_letters.includes(:sender, :fragment).order(created_at: :desc)
  end

  def new
    @fragment = Fragment.find(params[:fragment_id])
    @letter = Letter.new
  end

  def create
    @fragment = Fragment.find(params[:fragment_id])
    
    @letter = @fragment.letters.build(letter_params)
    @letter.sender = current_user
    @letter.recipient = @fragment.user

    if @letter.save
      if @letter.recipient != current_user
        Notification.create(
          recipient: @letter.recipient, # 受取人
          sender: current_user,         # 送り主
          action: "letter",             # 種類: letter
          notifiable: @letter           # 対象: この手紙データ
        )
      end      
      redirect_to @fragment, notice: "Your letter has been sent quietly."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @letter = current_user.received_letters.find(params[:id])

    if @letter.accepted!
      existing_room = Room.between(@letter.sender, @letter.recipient).first
      
      if existing_room
        redirect_to room_path(existing_room), notice: "Welcome back to the dialogue."
      else
        new_room = Room.create(sender: @letter.sender, recipient: @letter.recipient)
        
        if new_room.persisted?
          Notification.create(
            recipient: @letter.sender, # 手紙の送り主へ
            sender: current_user,
            action: "request_accepted",
            notifiable: new_room # 通知のリンク先はルーム
          )
          redirect_to room_path(new_room), notice: "Dialogue opened."
        else
          redirect_to mailbox_path, alert: "Could not start dialogue."
        end
      end
      
    else
      redirect_to mailbox_path, alert: "Something went wrong."
    end
  end

  private

  def letter_params
    params.require(:letter).permit(:subject, :body)
  end
end