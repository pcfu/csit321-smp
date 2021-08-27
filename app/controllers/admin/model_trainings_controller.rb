module Admin
  class ModelTrainingsController < ApplicationController
    skip_before_action :verify_authenticity_token, if: -> { request.xhr? }

    def create
      with_error_handling do |flagger|
        res = BackendClient.post('/ml/model_training', create_params)
        res_body = JSON.parse(res.body).symbolize_keys
        flagger.flag(res_body) if res_body[:status] != 'ok'

        render json: JSON.parse(res.body)
      end
    end


    private

      def create_params
        JSON.parse(params.require(:json)).merge(stocks: Stock.pluck(:id))
      end
  end
end
