module Admin
  class ModelTrainingsController < ApplicationController
    include BackendJobsEnqueuing
    include DateFormatChecking

    skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

    def batch_enqueue
      with_error_handling do |flagger|
        params = batch_enqueue_params
        config = ModelConfig.find(params[:config_id])

        trngs = reset_trainings(config, params)
        @response = enqueue_training_jobs(trngs, config.parse_params, params[:data_range])
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
        config_id, stock_ids = params.require([:config_id, :stock_ids])
        date_e = params[:date_end] || Date.today.to_s
        date_s = params[:date_start] || Date.today.advance(years: -15).to_s
        ensure_valid_dates!(date_s, date_e)
        { config_id: config_id.to_i, stocks: stock_ids, data_range: [date_s, date_e] }
      end

      def update_params
        stage = params.require(:stage)
        rmse ||= params.require(:rmse) if stage == 'done'
        error_message ||= params.require(:error_message) if stage == 'error'
        { stage: stage, rmse: rmse, error_message: error_message }
      end

      def reset_trainings(model_config, params)
        date_s, date_e, stock_ids = *params[:data_range], params[:stocks]
        model_config.reset_trainings(date_s, date_e, stock_ids)
        model_config.model_trainings.where(stock_id: stock_ids).map do |t|
          { training_id: t.id, stock_id: t.stock_id }
        end
      end
  end
end
