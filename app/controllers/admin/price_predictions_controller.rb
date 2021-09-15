module Admin
  class PricePredictionsController < ApplicationController
    include BackendJobsEnqueuing
    include DateFormatChecking

    skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

    def enqueue
      with_error_handling do |flagger|
        params = enqueue_params
        trng = find_training(*params.values)

        @response = enqueue_prediction_job(trng.id, trng.stock_id)
        flagger.flag(@response) if @response[:status] == 'error'
      end
    end

    def create
      with_error_handling do |flagger|
        PricePrediction.create! create_params
        render json: { status: 'ok' }
      end
    end


    private

      def enqueue_params
        cid, sid = params.require([ :config_id, :stock_id ])
        { model_config_id: cid.to_i, stock_id: sid.to_i }
      end

      def create_params
        params.require(:price_prediction).permit(:stock_id, *PricePrediction::ATTRS)
      end

      def find_training(cid, sid)
        trng = ModelTraining.find_by(model_config_id: cid, stock_id: sid)
        return trng if trng.present?

        raise ActiveRecord::RecordNotFound.new("Model does not exist")
      end
  end
end
