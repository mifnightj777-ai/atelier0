class CollectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_collection, only: [:show, :edit, :update, :destroy, :fragments_grid]
  before_action :authorize_view_collection!, only: [:show, :fragments_grid]
  before_action :authorize_owner!, only: [:edit, :update, :destroy]

  def index
    @collections = current_user.collections.order(created_at: :desc)
  end

  def show
    is_owner = (current_user.id == @collection.user_id)
    is_teammate = teammate_of?(@collection.user)

    # Collectionに紐づくFragmentsのベースクエリ
    base_fragments = @collection.fragments.with_attached_image

    if is_owner
      # 自分の場合：全て
      @fragments = base_fragments.order(created_at: :desc)
    elsif @collection.public_view?
      if is_teammate
        @fragments = base_fragments.where(visibility: [:public_view, :teammates_view]).order(created_at: :desc)
      else
        @fragments = base_fragments.where(visibility: :public_view).order(created_at: :desc)
      end
    elsif @collection.teammates_view?
      @fragments = base_fragments.where(visibility: [:public_view, :teammates_view]).order(created_at: :desc)
    else
      @fragments = []
    end
  end

  def new
    @collection = Collection.new
  end

  def edit
  end

  def create
    @collection = current_user.collections.build(collection_params)
    if @collection.save
      redirect_to @collection, notice: "Collection created."
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @collection.update(collection_params)
      redirect_to @collection, notice: "Collection updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @collection.destroy
    redirect_to collections_path, notice: "Collection deleted."
  end

  def fragments_grid
    is_owner = (current_user.id == @collection.user_id)
    is_teammate = teammate_of?(@collection.user)
    base_fragments = @collection.fragments

    if is_owner
      @fragments = base_fragments.order(created_at: :desc)
    elsif @collection.public_view?
      if is_teammate
        @fragments = base_fragments.where(visibility: [:public_view, :teammates_view]).order(created_at: :desc)
      else
        @fragments = base_fragments.where(visibility: :public_view).order(created_at: :desc)
      end
    elsif @collection.teammates_view?
      @fragments = base_fragments.where(visibility: [:public_view, :teammates_view]).order(created_at: :desc)
    end
    
    render partial: "fragments/grid", locals: { fragments: @fragments, empty_message: "No fragments in this collection yet." }
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end

  def authorize_view_collection!
    return if current_user.id == @collection.user_id

    case @collection.visibility
    when "public_view"
      true
    when "teammates_view"
      unless teammate_of?(@collection.user)
        redirect_to root_path, alert: "This collection is restricted to teammates."
      end
    when "private_view"
      redirect_to root_path, alert: "This is a private collection."
    end
  end

  def authorize_owner!
    unless @collection.user_id == current_user.id
      redirect_to collections_path, alert: "Access denied."
    end
  end

  def teammate_of?(owner)
    return false unless user_signed_in?
    current_user.following.exists?(owner.id) || current_user.followers.exists?(owner.id)
  end

  def collection_params
    params.require(:collection).permit(:title, :description, :visibility)
  end
end