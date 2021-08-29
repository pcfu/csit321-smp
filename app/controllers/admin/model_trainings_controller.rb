module Admin
  class ModelTrainingsController < ApplicationController
    skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

    def create
      with_error_handling do |flagger|
        params = create_params
        @model_config = ModelConfig.find(params[:config_id])

        reset_trainings(@model_config, params)
        @response = request_backend_to_enqueue_jobs(params)
        update_trainings(@model_config, @response[:results])
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

      def create_params
        id, range = params.require([:config_id, :data_range])
        #{ config_id: id.to_i, data_range: range }.merge(stocks: Stock.pluck(:id))

        # for the prototype, just train on AAPL stock
        { config_id: id.to_i, data_range: range }.merge(stocks: [1])
      end

      def update_params
        stage = params.require(:stage)
        rmse ||= params.require(:rmse) if stage == 'done'
        error_message ||= params.require(:error_message) if stage == 'error'
        { stage: stage, rmse: rmse, error_message: error_message }
      end

      def request_backend_to_enqueue_jobs(params)
        res = BackendClient.post('/ml/model_training', params)
        res_body = JSON.parse(res.body).symbolize_keys
        flagger.flag(res_body) if res_body[:status] != 'ok'
        res_body
      end

      def reset_trainings(model_config, params)
        date_start = params[:data_range][0]
        date_end = params[:data_range][1]
        stock_ids = params[:stocks]
        model_config.reset_trainings(date_start, date_end, stock_ids)
      end

      def update_trainings(model_config, results)
        results.each do |result|
          result.symbolize_keys!
          trng = model_config.model_trainings.find_by(stock_id: result[:stock_id])

          if result[:status] == 'ok'
            trng.update(stage: :enqueued)
          else
            trng.update(stage: :error, error_message: result[:error_message])
          end
        end
      end
  end
end
