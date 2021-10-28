module Admin
  class ModelTrainingsController < ApplicationController
    include BackendJobsEnqueuing
    include DateFormatChecking

    skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

    def batch_enqueue
      with_error_handling do |flagger|
        config = ModelConfig.find(batch_enqueue_params[:config_id])
        trngs = reset_trainings(config)
        @response = enqueue_training_jobs(trngs, config.model_type, config.parse_params)
        flagger.flag(@response) if @response[:status] == 'error'
      end
    end

    def update
      with_error_handling do |flagger|
        new_data = update_params
        @model_training = ModelTraining.find(params[:id])
        @model_training.update!(new_data)
      end
    end


    private

      def batch_enqueue_params
        { config_id: params.require(:config_id) }
      end

      def update_params
        stage = params.require(:stage)
        rmse ||= params.require(:rmse) if stage == 'done'
        error_message ||= params.require(:error_message) if stage == 'error'
        { stage: stage, rmse: rmse, error_message: error_message }
      end

      def reset_trainings(model_config)
        #model_config.reset_trainings(date_s, date_e)
        model_config.model_trainings.map do |t|
          { training_id: t.id, stock_id: t.stock_id }
        end
      end
  end
end
