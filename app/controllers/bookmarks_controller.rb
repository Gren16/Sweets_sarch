class BookmarksController < ApplicationController
  before_action :require_login

  def create
    store = Store.find(params[:store_id])
    bookmark = current_user.bookmarks.find_or_create_by(store: store)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("bookmark-button-for-store-#{store.id}", partial: "static_pages/unbookmark", locals: { store: store }) }
      format.json { render json: { status: "bookmarked", store_id: store.id } }
      format.html { redirect_back fallback_location: root_path }
    end
  end

  def destroy
    bookmark = current_user.bookmarks.find(params[:id])
    store = bookmark.store
    bookmark.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("unbookmark-button-for-store-#{store.id}", partial: "static_pages/bookmark", locals: { store: store }) }
      format.json { render json: { status: "unbookmarked", store_id: store.id } }
      format.html { redirect_back fallback_location: root_path }
    end
  end
end
