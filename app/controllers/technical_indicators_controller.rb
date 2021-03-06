class TechnicalIndicatorsController < ApplicationController
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  def index
    @tis = Stock.find(params[:id]).technical_indicators
                .start(params[:date_start]).end(params[:date_end]).order(date: :asc)

    respond_to do |format|
      format.json
      format.any { render_404 }
    end
  end

  def batch_create
    stock = Stock.find(params[:id])
    batch_create_params.each {|tis| stock.technical_indicators.create tis}

    respond_to do |format|
      format.json { render json: Hash[status: 'ok'] }
      format.any { render_404 }
    end
  end


  private

    def batch_create_params
      params.require(:technical_indicators).map &:permit!
    end
end
