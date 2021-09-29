class FavoritesController < ApplicationController

  def current_user
    current_user = User.find(1)
    return current_user
  end

  helper_method:current_user


  def update
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
