module Admin
  class ModelTrainingsController < ApplicationController
    include BackendJobsEnqueuing
    include DateFormatChecking

    skip_before_action :verify_authenticity_token, if: -> { request.format.json? }
    rescue_from StandardError, with: :handle_error

    def batch_enqueue
      BackendClient.ping rescue raise StandardError.new "No connection to backend"
      config = ModelConfig.find params.require(:config_id)
      config.reset_trainings

      @response = enqueue_training_jobs(training_data(config), model_data(config))
      raise StandardError.new(@response[:message]) if @response[:status] == 'error'
      render json: @response
    end

    def update
      @model_training = ModelTraining.find(params[:id])
      @model_training.update!(update_params)
    end


    private

      def update_params
        params.require(:model_training)
              .permit(:stage, :rmse, :accuracy, :parameters, :error_message)
      end

      def training_data(model_config)
        model_config.model_trainings.map do |t|
          { training_id: t.id, stock_id: t.stock_id, stock_symbol: t.stock.symbol }
        end
      end

      def model_data(model_config)
        {
          model_name: model_config.name,
          model_class: model_config.model_type,
          model_params: model_config.parse_params
        }
      end
  end
end
