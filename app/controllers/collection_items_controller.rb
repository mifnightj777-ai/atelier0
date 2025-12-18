class CollectionItemsController < ApplicationController
  before_action :authenticate_user!

  def new
    @collection = current_user.collections.find(params[:collection_id])
    
    # まだ追加していないFragmentを取得
    existing_ids = @collection.fragment_ids
    existing_ids = [0] if existing_ids.empty?
    @candidates = current_user.fragments.where.not(id: existing_ids).order(created_at: :desc)
  end

  def create
    collection = current_user.collections.find(params[:collection_id])
    fragment = Fragment.find(params[:fragment_id])

    item = collection.collection_items.build(fragment: fragment)

    if item.save
      redirect_back(fallback_location: collection_path(collection), notice: "Added to #{collection.title}.")
    else
      redirect_to fragment_path(fragment), alert: "Could not add to collection."
    end
  end

  def destroy
    item = CollectionItem.find(params[:id])
    
    if item.collection.user == current_user
      item.destroy
      redirect_back(fallback_location: collections_path, notice: "Removed from collection.")
    else
      redirect_to root_path, alert: "Access denied."
    end
  end
end