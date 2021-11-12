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
    fallback_if_blanks(@sister_prices, params[:id], params[:date_start], params[:date_end])

    respond_to do |format|
      format.json
      format.any { render_404 }
    end
  end

  def batch_create
    data = batch_create_params
    prices = data[:prices].sort {|a, b| a[:date] <=> b[:date]}
    prices.pop while prices.count > 0 and prices.last[:percent_change].zero?

    stock = Stock.find_by(symbol: data[:symbol])
    prices.each {|p| stock.price_histories.create p}

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

    def fallback_if_blanks(sisters, stock_id, date_s, date_e)
      stock = Stock.find(stock_id)
      others = Stock.send(stock.industry).pluck(:symbol).map(&:to_sym) -
               [stock.symbol.to_sym, *sisters.map(&:keys).flatten]

      sisters.each do |sis|
        if not sis[sis.keys.first].exists?
          sis.delete(sis.keys.first)

          while others.present? and sis.blank?
            sym = others.shuffle!.pop
            prices = stock_prices(sym, date_s, date_e)
            sis[sym] = prices if prices.exists?
          end
        end
      end
    end
end
