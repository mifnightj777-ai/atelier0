class MemosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_idea
  before_action :set_memo, only: [:destroy, :edit, :update]

  def create
    @idea = current_user.ideas.find(params[:idea_id])
    @memo = @idea.memos.build(memo_params)

    if params[:memo][:handwriting_data].present?
      image_data = params[:memo][:handwriting_data]

      if image_data.include?(',')
        blob = Base64.decode64(image_data.split(',')[1])
        
        @memo.image.attach(
          io: StringIO.new(blob), 
          filename: "handwriting_#{Time.current.to_i}.png", 
          content_type: 'image/png'
        )
      end
    end

    if @memo.save
      render turbo_stream: turbo_stream.prepend("memos_list", partial: "memos/memo", locals: { memo: @memo })
    else
      head :unprocessable_entity
    end
  end

  def edit
    # turbo_frameリクエストに対応
  end

  # ★追加
  def update
    if @memo.update(memo_params)
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@memo, partial: "memos/memo", locals: { memo: @memo }) }
        format.html { redirect_to idea_path(@idea) }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @memo = Memo.find(params[:id])
    @memo.destroy
    render turbo_stream: turbo_stream.remove(@memo)
  end

  private

  def set_idea
    @idea = Idea.find(params[:idea_id])
  end

  def set_memo
    @memo = @idea.memos.find(params[:id])
  end

  def memo_params
    params.require(:memo).permit(:content, :color, :handwriting_data)
  end
end