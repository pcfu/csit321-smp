class ApplicationController < ActionController::Base
  include SessionsHelper
  include ErrorHandling

  def render_404
    if request.format.json?
      render json: { status: 'not found' }, status: :not_found
    else
      render file: "#{Rails.root}/public/404.html", status: :not_found
    end
  end
end
