module Admin
  class ModelTrainingsController < ApplicationController
    include BackendJobsEnqueuing
    include DateFormatChecking

    skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

    def batch_enqueue
      with_error_handling do |flagger|
        config = ModelConfig.find(batch_enqueue_params[:config_id])
        config.reset_trainings
        @response = enqueue_training_jobs(training_data(config), model_data(config))
        flagger.flag(@response) if @response[:status] == 'error'
      end
    end

    def update
      with_error_handling do |flagger|
        @model_training = ModelTraining.find(params[:id])
        @model_training.update!(update_params)
      end
    end


    private

      def batch_enqueue_params
        { config_id: params.require(:config_id) }
      end

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
