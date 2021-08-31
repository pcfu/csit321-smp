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
        flagger.flag(@response) if @response[:status] != 'ok'
        update_trainings(config, @response[:results])
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
        id, date_s, date_e = params.require([:config_id, :date_start, :date_end])
        ensure_valid_dates!(date_s, date_e)
        #{ config_id: id.to_i, data_range: [date_s, date_e] }.merge(stocks: Stock.pluck(:id))

        # for the prototype, just train on AAPL stock
        { config_id: id.to_i, data_range: [date_s, date_e] }.merge(stocks: [1])
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
          { training_id: t.id, config_id: t.model_config_id, stock_id: t.stock_id }
        end
      end

      def update_trainings(model_config, results)
        results.each do |result|
          result.symbolize_keys!
          trng = ModelTraining.find(result[:training_id])
          trng.update(result.slice(:stage, :error_message))
        end
      end
  end
end
