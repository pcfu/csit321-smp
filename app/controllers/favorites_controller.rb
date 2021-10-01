class FavoritesController < ApplicationController
  def index
    

    respond_to do |format|
      format.html
    end
  end


  def update
    if logged_in?
      favorite = Favorite.where(stock: Stock.find(params[:stock]),user:current_user)
      if favorite == []
        #Create the favorite
        Favorite.create(stock: Stock.find(params[:stock]),user:current_user)
        @favorite_exists = true
      else
        favorite.destroy_all
        @favorite_exists = false
      end
    end
    
    respond_to do |format|
      format.html{}
      format.js{}
    end
  end

  def create
    if Favorite.create(stock: Stock, user: current_user)
      @favorite_exists = true
    else
      redirect_to @stock, alert: 'Something went wrong...*sad panda*'
      @favorite_exists = false
    end
  end
  
  def destroy
    Favorite.where(favorited_id: @project.id, user_id: current_user.id).first.destroy
    redirect_to @project, notice: 'Project is no longer in favorites'
  end

end
