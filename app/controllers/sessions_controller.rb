class SessionsController < ApplicationController
  def new
    redirect_to root_url if logged_in?
    @session = Session.new(url_after_login: request.referrer)
  end

  def create
    @session = Session.new login_params
    if @session.authenticate?
      log_in @session.get_user
      redirect_to @session.url_after_login || root_url
    else
      render :new, status: :unauthorized
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end


  private

    def login_params
      params.require(:session).permit(:email, :password, :url_after_login)
    end
end
