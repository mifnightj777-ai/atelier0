class ComparisonsController < ApplicationController
  before_action :authenticate_user!

  def index
    @comparisons = current_user.comparisons
                               .includes(fragment_a: { image_attachment: :blob }, fragment_b: { image_attachment: :blob })
                               .order(updated_at: :desc)
  end

  def create
    fragment_a = Fragment.find(params[:fragment_a_id])
    fragment_b = Fragment.find(params[:fragment_b_id])

    # IDが小さい順に並べて、AとBが逆でも同じペアとみなすようにする
    small, large = [fragment_a, fragment_b].sort_by(&:id)

    # 「あればそれを使う、なければ作る」
    @comparison = Comparison.find_or_create_by(
      user: current_user,
      fragment_a: small,
      fragment_b: large
    )

    # 作成（または特定）したら、その詳細ページへ移動
    redirect_to comparison_path(@comparison)
  end

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
    if params[:id]
      # 1. 履歴から来た場合（IDがある）
      @comparison = Comparison.find(params[:id])
    
    elsif params[:fragment_a_id] && params[:fragment_b_id]
      # 2. SwapなどでIDはないがペア指定がある場合
      ids = [params[:fragment_a_id], params[:fragment_b_id]].sort
      
      # ★修正：勝手に作らない (find_or_create_by -> find_by)
      @comparison = Comparison.find_by(fragment_a_id: ids[0], fragment_b_id: ids[1])
      
      # 見つからなければ、保存されていない「仮のデータ」として扱う
      @comparison ||= Comparison.new(fragment_a_id: ids[0], fragment_b_id: ids[1])
    
    else
      # 3. 空のスタジオの場合（ロゴクリックなど）
      @comparison = Comparison.new
    end

    # 左右の表示位置を決定
    if params[:fragment_a_id].present? && @comparison.fragment_b_id == params[:fragment_a_id].to_i
       @left_fragment = @comparison.fragment_b
       @right_fragment = @comparison.fragment_a
    else
       @left_fragment = @comparison.fragment_a
       @right_fragment = @comparison.fragment_b
    end
  end

  def update
    @comparison = Comparison.find(params[:id])

    if @comparison.user == current_user
      @comparison.update(comparison_params)

      respond_to do |format|
        # Turbo用: 画面遷移せず、200 OK だけ返す (これが最速)
        format.turbo_stream { head :ok }
        
        # HTML用: JavaScriptが動かない場合の保険（元のコード）
        format.html { redirect_to studio_comparisons_path(fragment_a_id: @comparison.fragment_a_id, fragment_b_id: @comparison.fragment_b_id) }
      end
    end
  end

  def destroy
    @comparison = current_user.comparisons.find(params[:id])
    @comparison.destroy
    
    redirect_to comparisons_path, status: :see_other
  end

  private

  def comparison_params
    params.require(:comparison).permit(:note)
  end
end