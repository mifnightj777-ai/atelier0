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
      redirect_to @fragment, notice: "Your letter has been sent quietly."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def letter_params
    params.require(:letter).permit(:subject, :body)
  end
end