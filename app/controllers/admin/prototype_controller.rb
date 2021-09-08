module Admin
  class PrototypeController < ApplicationController
    def index
      @config = ModelConfig.find(1)
    end
  end
end
