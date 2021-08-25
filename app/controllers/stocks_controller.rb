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
    @prediction_attrs = PricePrediction.const_get(:ATTRS).map &:to_s

    respond_to do |format|
      format.html
      #format.json {render :json => Stock.PricePredict.all }
    end
  end
end
