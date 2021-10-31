class StocksController < ApplicationController
  def index
    @stocks = Stock.all
    latest_changes = @stocks.select {|s| s.price_histories.count > 0}.map {|s|
      change = s.price_histories.last.percent_change
      { symbol: s.symbol, change: change.to_f }
    }.sort_by {|s| s[:change]}.reverse

    best_changes = latest_changes.select{ |item| item[:change] > 0 }
    worst_changes = latest_changes.select{ |item| item[:change] <= 0 }

    max_performer = 10
    count_best = best_changes.length() >= max_performer ? max_performer : best_changes.length()
    count_worst = worst_changes.length() >= max_performer ? max_performer : worst_changes.length()

    @ranked = {
      "Best": best_changes[0..count_best-1],
      "Worst": worst_changes[-count_worst..-1].reverse
    }

    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
    @stock = Stock.find(params[:id])

    @recent_predictions = @stock.price_predictions.order(entry_date: :desc).limit(5)
                                .map {|s| s.to_chart_json }

    @recommendation_action = @stock.recommendations.order(prediction_date: :desc).limit(1)

    @favorite_exists = Favorite.where(stock: @stock, user:current_user) == [] ? false : true
    respond_to do |format|
      format.html
    end
  end
end
