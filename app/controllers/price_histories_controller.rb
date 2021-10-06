class PriceHistoriesController < ApplicationController
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  def index
    @price_histories = Stock.find(params[:id]).price_histories
                            .start(params[:date_start]).end(params[:date_end])
    @fields = params[:fields]

    respond_to do |format|
      format.json
      format.any { render_404 }
    end
  end

  def batch_create
    data = batch_create_params
    data.each do |d|
      stock = Stock.find_by(symbol: d[:symbol])
      d[:prices].each {|p| stock.price_histories.create p}
    end

    respond_to do |format|
      format.json { head :ok }
      format.any { render_404 }
    end
  end


  private

    def batch_create_params
      params.require(:price_histories).map &:permit!
    end
end
