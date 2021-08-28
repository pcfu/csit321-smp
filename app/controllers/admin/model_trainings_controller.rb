module Admin
  class ModelTrainingsController < ApplicationController
    skip_before_action :verify_authenticity_token, if: -> { request.xhr? }

    def create
      with_error_handling do |flagger|
        params = create_params
        @model_config = ModelConfig.find(params[:config_id])

        reset_trainings(@model_config, params)
        response = request_backend_to_enqueue_jobs(params)
        update_trainings(@model_config, response[:results])
        render json: response
      end
    end


    private

      def create_params
        # JSON.parse(params.require(:json)).symbolize_keys.merge(stocks: Stock.pluck(:id))

        # for the prototype, just train on AAPL stock
        JSON.parse(params.require(:json)).symbolize_keys.merge(stocks: [1])
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
