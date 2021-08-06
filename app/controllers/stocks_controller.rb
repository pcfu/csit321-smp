class StocksController < ApplicationController
  def index
    shortlist = %w[AAPL GOOG FB TWTR WMT]
    @shortlist = Stock.where(:symbol => shortlist)

    respond_to do |format|
      format.html
      format.json { render json: Stock.all }
    end
  end

  def show
    @stock = Stock.find(params[:id])
  end
end
