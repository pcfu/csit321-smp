class FavoritesController < ApplicationController
  before_action :logged_in_user
  def index
    if logged_in?
      @favorites = Favorite.where(user:current_user)
    else 
      redirect_to sessions_url
    end
    respond_to do |format|
      format.html
    end
  end

  def show
    @favorites = Favorite.find(params[:id])
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
        #flash[:notice] ="Stock added to favorites"
        @favorite_exists = true
      else
        favorite.destroy_all
        #flash[:notice] ="Stock removed from favorites"
        @favorite_exists = false
      end
    else 
      redirect_to sessions_url
    end
    
    respond_to do |format|
      format.html{}
      format.js{}
    end
  end

  def create
    @stocksymbol = params[:favorite][:stocksymbol].upcase
    @favorite  = Favorite.where(stock:Stock.find_by(symbol:@stocksymbol), user: current_user)
    if Stock.where(symbol:@stocksymbol).exists?
      if @favorite == [] 
      #Create favorite
        Favorite.create(stock:Stock.find_by(symbol:@stocksymbol), user: current_user)
        redirect_to favorites_path, flash: {notice: "Stock added to favorites"}

        @favorite_exists = true
      else
        #Stock already existing
        redirect_to favorites_path, flash: {notice: "Stock already exists in favorites"}

      end
    else
      #No such stock symbol
      redirect_to favorites_path, flash: {notice: "Stock does not exist"}

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
