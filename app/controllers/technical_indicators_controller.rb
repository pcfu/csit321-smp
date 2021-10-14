class TechnicalIndicatorsController < ApplicationController
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  def batch_create
    stock = Stock.find(params[:id])

    data = batch_create_params
    data.each do |tis|
      #stock.technical_indicators.create tis
    end

    respond_to do |format|
      format.json { head :ok }
      format.any { render_404 }
    end
  end


  private

    def batch_create_params
      params.require(:technical_indicators).map &:permit!
    end
end
