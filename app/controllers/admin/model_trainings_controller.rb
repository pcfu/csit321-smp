module Admin
  class ModelTrainingsController < ApplicationController
    skip_before_action :verify_authenticity_token, if: -> { request.xhr? }

    def create
      if true
        render json: { status: 'ok', message: 'Model training job created' }
      else
        render json: { status: 'error', message: 'Error occurred' }, status: :unprocessable_entity
      end
    end
  end
end
