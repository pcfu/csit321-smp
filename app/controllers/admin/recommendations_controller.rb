module Admin
  class RecommendationsController < ApplicationController
    include BackendJobsEnqueuing

    skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
    rescue_from StandardError, with: :handle_error

    def batch_enqueue
      config = ModelConfig.find enqueue_params[:config_id]
      @response = enqueue_recommendation_jobs enqueue_data(config)
      raise StandardError.new(@response[:message]) if @response[:status] == 'error'
      render json: @response
    end

    def create
      Recommendation.create! create_params
      render json: { status: 'ok' }
    end


    private

      def enqueue_params
        { config_id: params.require(:config_id) }
      end

      def create_params
        params.require(:recommendation).permit(:stock_id, :prediction_date, :verdict)
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
