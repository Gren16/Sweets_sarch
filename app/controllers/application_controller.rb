class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  before_action :require_login, except: [ :show ], if: -> { params[:controller] == "high_voltage/pages" }

  private

  def not_authenticated
    redirect_to login_path
  end
end
