class FavoritesController < ApplicationController
 #Temporary Method to define a fixed
  #To replace current_user with the authenticated user from PC
  def current_user
    current_user = User.find(1)
    return current_user
  end

  
  def add_favorite:
    
       # do something
    else
       redirect_to root_url
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
    
    respond_to do |format|
      format.html{}
      format.js{}
    end
  end
end
