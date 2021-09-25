class SessionsController < ApplicationController
  def new
    @session = Session.new
  end

  def create
    @session = Session.new login_params
    if @session.authenticate?
      redirect_to root_url
    else
      render :new, status: :unauthorized
    end
  end


  private

    def login_params
      params.require(:session).permit(:email, :password)
    end
end
