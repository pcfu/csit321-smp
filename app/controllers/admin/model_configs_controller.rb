module Admin
  class ModelConfigsController < ApplicationController

    skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

    def show
      @config = ModelConfig.find(params[:id])
    end
  end
end
