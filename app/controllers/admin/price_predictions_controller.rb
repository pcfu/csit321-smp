module Admin
  class PricePredictionsController < ApplicationController
    include BackendJobsEnqueuing
    include DateFormatChecking

    skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

    def enqueue
      with_error_handling do |flagger|
        params = enqueue_params
        trng = find_training(*params.values_at(:model_config_id, :stock_id))

        msg = "Prediction requested for " +
              "Model: #{params[:model_config_id]} Stock: #{params[:stock_id]} " +
              "from: #{params[:data_range][0]} to: #{params[:data_range][1]}"
        render json: { status: 'ok', message: msg }
      end
    end


    private

      def enqueue_params
        cid, sid, date_s, date_e = params.require %i[config_id stock_id date_start date_end]
        ensure_valid_dates!(date_s, date_e)
        { model_config_id: cid.to_i, stock_id: sid.to_i, data_range: [date_s, date_e] }
      end

      def find_training(cid, sid)
        trng = ModelTraining.find_by(model_config_id: cid, stock_id: sid)
        return trng if trng.present?

        raise ActiveRecord::RecordNotFound.new("Model does not exist")
      end
  end
end
