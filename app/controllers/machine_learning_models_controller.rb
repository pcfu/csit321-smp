class MachineLearningModelsController < ApplicationController
    def index
      @headers = [
        'SN', 'Name', 'Machine Model', 'Parameter 1', 'Parameter 2', 'Parameter 3',
        'AUC', 'H-Measure', 'TPR', 'FPR', 'Status', 'Action'
      ]

      xxx = ['XXX'] * 7
      @models = [
        [ 'P001', 'Default LSTM', 'LSTM', *xxx, 'Active'],
        [ 'P002', 'Default ANN', 'ANN', *xxx, 'Inactive'],
        [ 'P003', 'Default ANN', 'ANN', *xxx, 'Inactive'],
      ]
    end

    def new
    end
end
