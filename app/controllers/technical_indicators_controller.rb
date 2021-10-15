class TechnicalIndicatorsController < ApplicationController
  skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

  def batch_create
    stock = Stock.find(params[:id])
    batch_create_params.each {|tis| stock.technical_indicators.create tis}

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
