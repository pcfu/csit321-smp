module Admin
  class PricePredictionsController < ApplicationController
    include BackendJobsEnqueuing
    include DateFormatChecking

    skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

    def enqueue
      with_error_handling do |flagger|
        params = enqueue_params
        trng = find_training(*params.values_at(:model_config_id, :stock_id))
        @response = enqueue_prediction_job(trng.id, trng.stock_id, params[:data_range])
        flagger.flag(@response) if @response[:status] == 'error'
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
