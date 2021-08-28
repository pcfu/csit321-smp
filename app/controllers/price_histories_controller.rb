class PriceHistoriesController < ApplicationController
  def index
    @price_histories = Stock.find(params[:stock_id]).price_histories
                            .start(params[:date_start]).end(params[:date_end])

    respond_to do |format|
      format.json
      format.any { render_404 }
    end
  end
end
