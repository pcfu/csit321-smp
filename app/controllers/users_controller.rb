class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      redirect_to root_url
    else
      render :new, status: :conflict
    end
  end


  private

    def user_params
      keys = %i[first_name last_name email password password_confirmation role]
      params.require(:user).permit(*keys)
    end
end
