class RoutesController < ApplicationController
  before_action :require_login

  def new
    @bookmarks = current_user.bookmarks.includes(:store).page(params[:page]).per(12)
  end

  def create
    if params[:bookmark_ids].blank?
      redirect_to new_route_path, alert: "ブックマークを選択してください。"
      return
    end

    bookmark_ids = params[:bookmark_ids].reject(&:blank?)
    @bookmarks = current_user.bookmarks.where(id: bookmark_ids)

    if @bookmarks.present?
      # 一時的にルート情報をセッションに保存
      session[:route_bookmarks] = @bookmarks.map(&:id)
      redirect_to route_path(id: @bookmarks.first.id)
    else
      flash[:alert] = "ルートを作成するためのブックマークがありません。"
      render :new
    end
  end

  def show
    @bookmarks = current_user.bookmarks.includes(:store).where(id: session[:route_bookmarks])
    if @bookmarks.blank?
      redirect_to bookmarks_stores_path, alert: "ルートを作成するためのブックマークがありません。"
      return
    end
  end

  def reset_session
    reset_session
    redirect_to route_path
  end

  def delete_route
    # Logic to delete the route (e.g., clear session data or remove route from database)
    session[:route_bookmarks] = nil
    head :ok
  end
end
