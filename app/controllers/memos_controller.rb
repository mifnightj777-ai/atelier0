class MemosController < ApplicationController
  before_action :authenticate_user!

  def create
    @idea = current_user.ideas.find(params[:idea_id])
    @memo = @idea.memos.build(memo_params)

    if @memo.save
      render turbo_stream: turbo_stream.prepend("memos_list", partial: "memos/memo", locals: { memo: @memo })
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @memo = Memo.find(params[:id])
    @memo.destroy
    render turbo_stream: turbo_stream.remove(@memo)
  end

  private

  def memo_params
    params.require(:memo).permit(:content)
  end
end