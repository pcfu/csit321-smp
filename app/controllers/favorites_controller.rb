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
      flash[:notice]="Stock added to favorites"
      @favorite_exists = true
    else
      flash[:alert]="Something went wrong"
      @favorite_exists = false
    end
  end
  
  def destroy
    Favorite.where(stock: Stock.find(params[:stock]),user:current_user).first.destroy
    flash[:alert]="Stock deleted from portfolio"
    @favorite_exists = false
  end

end
