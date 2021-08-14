class StocksController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json { render json: Stock.all }
    end
  end

  def show
    @stock = Stock.find(params[:id])


  end
end
