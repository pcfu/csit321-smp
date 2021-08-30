module Admin
  class PrototypeController < ApplicationController
    def index
    end

    def ws_test
      render json: "ok"
    end
  end
end
