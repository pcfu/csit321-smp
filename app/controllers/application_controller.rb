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

  def page_not_found
    respond_to do |format|
      format.html { render template: 'errors/not_found_error', layout: 'layouts/application', status: 404 }
      format.all  { render nothing: true, status: 404 }
    end
  end

  def favorite_text
      return @favorite_exists ? "UnFavorite" : "Favorite"
  end
  helper_method:favorite_text

  def check_boolean(boolean)
    boolean ? 'Yes' : 'No'
  end
  helper_method:check_boolean
end
