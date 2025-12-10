class CollectionItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    collection = current_user.collections.find(params[:collection_id])
    fragment = Fragment.find(params[:fragment_id])

    item = collection.collection_items.build(fragment: fragment)

    if item.save
      redirect_to fragment_path(fragment), notice: "Added to #{collection.title}."
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