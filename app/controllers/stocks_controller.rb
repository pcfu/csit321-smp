class StocksController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json { render json: Stock.all }
    end
  end

  def show
    @stock = Stock.find(params[:id])
    respond_to do |format|
      format.html
      format.json {render :json => Stock.PricePredict.all }
    end
  end
end
