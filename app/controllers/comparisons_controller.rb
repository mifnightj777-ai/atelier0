class ComparisonsController < ApplicationController
  before_action :authenticate_user!

  def select
    @target = params[:target] || 'b' 
    @other_id = params[:keep_id]

    if params[:fragment_id].present?
      @base_fragment = Fragment.find_by(id: params[:fragment_id])
    end

    @candidates = current_user.fragments.order(created_at: :desc)
    
    ids_to_exclude = []
    ids_to_exclude << @base_fragment.id if @base_fragment
    ids_to_exclude << @other_id.to_i if @other_id.present?
    
    @candidates = @candidates.where.not(id: ids_to_exclude)
  end

  def show
    if params[:fragment_a_id].present?
      @fragment_a = Fragment.find_by(id: params[:fragment_a_id])
    end

    if params[:fragment_b_id].present?
      @fragment_b = Fragment.find_by(id: params[:fragment_b_id])
    end
    
    if @fragment_a && @fragment_b
      @comparison = Comparison.find_or_create_by(
        user: current_user,
        fragment_a: @fragment_a, 
        fragment_b: @fragment_b
      )
    end
  end

  def update
    @comparison = Comparison.find(params[:id])

    if @comparison.user == current_user
      @comparison.update(comparison_params)

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to studio_comparisons_path(fragment_a_id: @comparison.fragment_a_id, fragment_b_id: @comparison.fragment_b_id) }
      end
    end
  end

  private

  def comparison_params
    params.require(:comparison).permit(:note)
  end
end