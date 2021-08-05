class StockDataController < ApplicationController
  has_many :price_histories

  def index
    shortlist = %w[AAPL GOOG FB TWTR WMT]
    @shortlist = Stock.where(:symbol => shortlist)

    respond_to do |format|
      format.html
      format.json { render json: Stock.all }

  def index
    @stocks = Stock.all
    render layout: 'public_layout'
  end

  def show
    @stock = Stock.find(params[:id])
  end
end
