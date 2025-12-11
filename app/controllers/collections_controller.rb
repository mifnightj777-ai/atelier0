class CollectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_collection, only: [:show, :edit, :update, :destroy]

  def index
    @collections = current_user.collections.order(created_at: :desc)
  end

  def show
    unless can_view_collection?(@collection)
      redirect_to root_path, alert: "This collection is private."
      return
    end
    if @collection.user == current_user
      @fragments = @collection.fragments.order(created_at: :desc)
    else
      @fragments = @collection.fragments.where.not(visibility: :private_view).order(created_at: :desc)
    end
  end

  def new
    @collection = Collection.new
  end

  def edit
    redirect_to collections_path, alert: "Access denied." unless @collection.user == current_user
  end

  def create
    @collection = current_user.collections.build(collection_params)

    if @collection.save
      redirect_to @collection, notice: "Collection created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    return unless @collection.user == current_user

    if @collection.update(collection_params)
      redirect_to @collection, notice: "Collection updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @collection.user == current_user
      @collection.destroy
      redirect_to collections_path, notice: "Collection deleted."
    else
      redirect_to collections_path, alert: "Access denied."
    end
  end

  def fragments_grid
    @collection = Collection.find(params[:id])
    @fragments = @collection.fragments.order(created_at: :desc)
    
    render partial: "fragments/grid", locals: { fragments: @fragments, empty_message: "No fragments in this ZINE yet." }
  end

  private

  def set_collection
    @collection = Collection.find(params[:id])
  end

  def collection_params
    params.require(:collection).permit(:title, :description, :visibility)
  end

  def can_view_collection?(collection)
    return true if collection.user == current_user
    return false if collection.view_private?
    return true if collection.view_teammates? && current_user.teammate_with?(collection.user)
    false
  end
end