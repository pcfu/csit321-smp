class StockDataController < ApplicationController
  def index
    @stocks = Stock.all
    render layout: 'public_layout'
  end

  def show
    @stock = Stock.find(params[:id])
  end
end
