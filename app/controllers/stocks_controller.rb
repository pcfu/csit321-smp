class StocksController < ApplicationController


  def index
    respond_to do |format|
      format.html
      format.json { render json: Stock.all }
    end
  end

  def show
    @stock = Stock.find(params[:id])
    @recent_predictions = @stock.price_predictions.order(entry_date: :desc).limit(2)
                                .map {|s| s.to_chart_json }

    @favorite_exists = Favorite.where(stock: @stock, user:current_user) == [] ? false : true
    respond_to do |format|
      format.html
    end
  end
end
