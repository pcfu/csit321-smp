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
end
