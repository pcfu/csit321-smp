module Admin
  class PricePredictionsController < ApplicationController
    include BackendJobsEnqueuing
    include DateFormatChecking

    skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
    rescue_from StandardError, with: :handle_error

    def batch_enqueue
      config = ModelConfig.find params.require(:config_id)
      raise StandardError.new("Invalid model for price prediction") if not config.lstm?

      @response = enqueue_prediction_job enqueue_data(config)
      raise StandardError.new(@response[:message]) if @response[:status] == 'error'
      render json: @response
    end

    def create
      PricePrediction.create! create_params
      render json: { status: 'ok' }
    end


    private

      def create_params
        params.require(:price_prediction).permit(:stock_id, *PricePrediction::ATTRS)
      end

      def enqueue_data(model_config)
        model_config.model_trainings.done.map do |t|
          path = "trained_models/#{model_config.name.upcase}_#{t.stock.symbol}"
          last_prc = t.stock.price_histories.order(date: :desc).first
          { id: t.stock_id, model_path: path, latest_date: last_prc.date.strftime('%Y-%m-%d') }
        end
      end
  end
end
