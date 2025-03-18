class BookmarksController < ApplicationController

  def create
    @store = Store.find(params[:store_id])
    current_user.bookmark(@store)
  end

  def destroy
    @store = current_user.bookmarks.find(params[:id]).store
    current_user.unbookmark(@store)
  end
end
