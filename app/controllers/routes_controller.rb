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
    end
  end

  def reset_session_data
    # 特定のセッションキーのみリセット
    session[:route_bookmarks] = nil
    redirect_to new_route_path, notice: "ルート情報をリセットしました。"
  end

  def delete_route
    # ルートデータを削除（セッションの特定キーをクリア）
    session[:route_bookmarks] = nil
    head :ok
  end

  def fetch_routes
    api_key = ENV["GOOGLE_MAP_API_KEY"]
    origin = params[:origin]
    destination = params[:destination]
    waypoints = params[:waypoints]

    if origin.blank? || destination.blank?
      render json: { error: "Origin and destination are required." }, status: :unprocessable_entity
      return
    end

    url = URI("https://routes.googleapis.com/directions/v2:computeRoutes")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/json"
    request["X-Goog-Api-Key"] = api_key
    request["X-Goog-FieldMask"] = "routes.distanceMeters,routes.duration,routes.polyline.encodedPolyline"

    request.body = {
      origin: { location: { latLng: { latitude: origin[0], longitude: origin[1] } } },
      destination: { location: { latLng: { latitude: destination[0], longitude: destination[1] } } },
      intermediates: waypoints.present? ? waypoints.map { |wp| { location: { latLng: { latitude: wp[0], longitude: wp[1] } } } } : nil,
      travelMode: "DRIVE"
    }.compact.to_json

    response = http.request(request)

    if response.code.to_i == 200
      render json: JSON.parse(response.body), status: :ok
    else
      render json: { error: "Failed to fetch route from Google API", details: response.body }, status: :unprocessable_entity
    end
  end
end
