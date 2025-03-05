class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: %i[top create_store]
  protect_from_forgery with: :exception, unless: -> { request.format.json? }

  def top
    @stores = Store.all
  end

  def create_store
    store = Store.new(store_params)
    if store.save
      render json: { message: "#{store.name}をStoresテーブルに保存しました" }, status: :created
    else
      render json: { errors: store.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def store_params
    params.require(:store).permit(:name, :address, :phone_number, :web_site, :place_id)
  end
end
