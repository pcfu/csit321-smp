class StocksController < ApplicationController


  def index

    max_performer = 10
    
    latest_changes = Stock.all.map {|s|
      change = s.price_histories.last.percent_change
      { symbol: s.symbol, change: change.to_f }
    }.sort_by {|s| s[:change]}.reverse

    # latest_changes = [{:symbol=>"XOM", :change=>0.0258}, {:symbol=>"GSK", :change=>0.0003}, {:symbol=>"AAPL", :change=>0.0111}, {:symbol=>"WPM", :change=>-0.0078},
    #   {:symbol=>"AAA", :change=>0.0258}, {:symbol=>"BBB", :change=>-0.0003}, {:symbol=>"CCC", :change=>0.0111}, {:symbol=>"DDD", :change=>0.2078},
    #   {:symbol=>"EEE", :change=>0.0258}, {:symbol=>"FFF", :change=>0.2003}, {:symbol=>"GGG", :change=>0.8111}, {:symbol=>"HHH", :change=>0.1078}].sort_by {|s| s[:change]}.reverse

    best_changes = latest_changes.select{ |item| item[:change] > 0 }
    worst_changes = latest_changes.select{ |item| item[:change] <= 0 }

    count_best = best_changes.length() >= max_performer ? max_performer : best_changes.length()
    count_worst = worst_changes.length() >= max_performer ? max_performer : worst_changes.length()

    @ranked = {
      "Best": best_changes[0..count_best-1],
      "Worst": worst_changes[-count_worst..-1].reverse
    }

    respond_to do |format|
      format.html
      format.json { render json: Stock.all }
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
