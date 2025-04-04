class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: %i[top create_store]
  protect_from_forgery with: :exception, unless: -> { request.format.json? }

  def top
    @stores = Store.all.page(params[:page]).per(12)
  end

  def create_store
    store = Store.find_or_initialize_by(place_id: store_params[:place_id])
    if store.new_record?
      store.assign_attributes(store_params)
      if store.save
        render json: { message: "#{store.name}をStoresテーブルに保存しました" }, status: :created
      else
        Rails.logger.error("保存に失敗しました: #{store.errors.full_messages.join(", ")}")
        render json: { errors: store.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: "#{store.name}は既に保存されています" }, status: :ok
    end
  end

  def bookmarks
    @bookmark_stores = current_user.bookmark_stores.page(params[:page]).per(12)
  end

  private

  def store_params
    params.require(:store).permit(:name, :address, :phone_number, :web_site, :place_id, :latitude, :longitude)
  end
end
