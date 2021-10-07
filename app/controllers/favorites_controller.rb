class FavoritesController < ApplicationController
  def index
    @favorites = Favorite.all

    respond_to do |format|
      format.html
    end
  end

  def show
    @favorites = Favorite.find(params[:id])
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
    @fav = Favorite.find(params[:id])
    logger.debug "Favorite should not be valid: #{@fav.valid?}"
    @fav.destroy
    @favorite_exists = false
      
    redirect_to favorites_path, :alert=>"Favorite has been deleted"
    respond_to do |format|
      format.html{}
      format.js{}
    end
  end


end
