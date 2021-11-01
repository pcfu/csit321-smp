class PriceHistoriesController < ApplicationController
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  def index
    @price_histories = stock_prices(params[:id], params[:date_start], params[:date_end])
    @fields = params[:fields]

    respond_to do |format|
      format.json
      format.any { render_404 }
    end
  end

  def sister_prices
    sisters = SisterStocksLookupTable.get Stock.find(params[:id]).symbol
    @sister_prices = sisters.map do |sis|
      { sis => stock_prices(sis, params[:date_start], params[:date_end]) }
    end

    respond_to do |format|
      format.json
      format.any { render_404 }
    end
  end

  def batch_create
    data = batch_create_params
    stock = Stock.find_by(symbol: data[:symbol])
    data[:prices].sort {|a, b| a[:date] <=> b[:date]}
                 .each {|p| stock.price_histories.create p}

    respond_to do |format|
      format.json { render json: Hash[status: 'ok'] }
      format.any { render_404 }
    end
  end


  private

    def stock_prices(id_or_symbol, date_s, date_e)
      Stock.where(id: id_or_symbol).or(Stock.where(symbol: id_or_symbol))
           .first.price_histories.start(date_s).end(date_e).order(date: :asc)
    end

    def batch_create_params
      params.require(:price_histories).permit!
    end
end
