class FragmentColorsController < ApplicationController
  before_action :authenticate_user!

  def create
    @fragment = Fragment.find(params[:fragment_id])
    
    unless @fragment.user == current_user
      head :forbidden
      return
    end

    @color = @fragment.fragment_colors.build(hex_code: params[:hex_code], is_auto: false)

    if @color.save
      render turbo_stream: turbo_stream.append("color_palette", partial: "fragment_colors/color", locals: { color: @color })
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @color = FragmentColor.find(params[:id])
    
    if @color.fragment.user == current_user
      @color.destroy
      render turbo_stream: turbo_stream.remove(@color)
    else
      head :forbidden
    end
  end
end