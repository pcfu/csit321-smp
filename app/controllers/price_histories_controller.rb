class PriceHistoriesController < ApplicationController
  def index
    @price_histories = Stock.find(params[:stock_id]).price_histories
    respond_to do |format|
      format.json
      format.any { render_404 }
    end
  end
end
