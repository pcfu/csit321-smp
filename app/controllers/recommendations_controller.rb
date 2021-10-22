class RecommendationsController < ApplicationController
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

end
