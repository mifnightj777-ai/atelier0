class LettersController < ApplicationController
  before_action :authenticate_user!

  def index
    case params[:tab]
    when 'accepted'
      @letters = current_user.received_letters.accepted.includes(:sender, :fragment).order(created_at: :desc)
    when 'archive'
      @letters = current_user.received_letters.rejected.includes(:sender, :fragment).order(created_at: :desc)
    else
      @letters = current_user.received_letters.pending.includes(:sender, :fragment).order(created_at: :desc)
    end
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
      # 自分以外への送信なら通知を作成
      if @letter.recipient != current_user
        Notification.create(
          recipient: @letter.recipient,
          sender: current_user,
          action: "letter",
          notifiable: @letter
        )
      end      
      redirect_to @fragment, notice: "Your letter has been sent quietly."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @letter = current_user.received_letters.find(params[:id])
    target_status = params.dig(:letter, :status)

    if target_status == 'accepted'
      ActiveRecord::Base.transaction do
        @letter.accepted!
        room = Room.between(@letter.sender, @letter.recipient).first_or_create!(
          sender: @letter.sender,
          recipient: @letter.recipient
        )
        unless room.messages.exists?(content: @letter.body)
          room.messages.create!(user: @letter.sender, content: @letter.body)
        end
        redirect_to room_path(room), notice: "Dialogue opened."
      end

    elsif target_status == 'rejected'
      @letter.rejected!
      redirect_to mailbox_path, notice: "Letter archived."
    elsif target_status == 'pending' # ★ここを追加！
      @letter.pending!
      redirect_to mailbox_path, notice: "Letter restored to inbox."
    else
      redirect_to mailbox_path, alert: "Invalid action."
    end
  end

  # 削除機能（送信取り消し用など）はそのまま維持
  def destroy
    @letter = Letter.find(params[:id])
    if @letter.sender == current_user || @letter.recipient == current_user
      @letter.destroy
      redirect_back(fallback_location: root_path, notice: "Letter deleted.")
    else
      redirect_to root_path, alert: "Access denied."
    end
  end

  private

  def letter_params
    params.require(:letter).permit(:subject, :body)
  end
end