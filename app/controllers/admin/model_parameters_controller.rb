module Admin
  class ModelParametersController < ApplicationController
    def index
      @headers = [
        'SN', 'Name', 'Machine Model', 'Parameter 1', 'Parameter 2', 'Parameter 3',
        'AUC', 'H-Measure', 'TPR', 'FPR', 'Status', 'Action'
      ]

      xxx = ['XXX'] * 7
      @models = ModelConfig.all

    end
    
    def show
      @model = ModelConfig.find(params[:id])
      
      respond_to do |format|
        format.html
      end
    end

    def new
    @ml_params = ModelConfig.new
    end

    def create
      #Extracting values from form
      @start_date = params[:model_config][:start_date]
      @train_test_param =  params[:model_config][:train_test_percent]
      @c =  params[:model_config][:c]
      @gamma =  params[:model_config][:gamma]
      @kernel =  params[:model_config][:kernel]
      @n_estimators =  params[:model_config][:n_estimators]
      @max_depth =  params[:model_config][:max_depth]
      @activation =  params[:model_config][:activation]
      @units =  params[:model_config][:units]
      @dropout =  params[:model_config][:dropout]
      @epoch =  params[:model_config][:epoch]
      @batch_size =  params[:model_config][:batch_size]
      @name_param = params[:model_config][:name]
      @model_param = params[:model_config][:model_type]

      #Defining the json string
      if @model_param == "lstm"   #LSTM
        @parameter = {
          :start_date =>@start_date, 
          :train_test_percent =>@train_test_param,
          :build_args=>{:activation=>@activation, 
                        :units=>@units,
                        :dropout=>@dropout,
                        :epoch=>@epoch}
                      }.to_json
      elsif @model_param == "svm"    #SVM
          @parameter = {
            :start_date =>@start_date, 
            :train_test_percent =>@train_test_param,
            :build_args=>{:n_estimators=>@n_estimators, 
                          :max_depth=>@max_depth}
                        }.to_json
      else      #RF
        @parameter = {
          :start_date =>@start_date, 
          :train_test_percent =>@train_test_param,
          :build_args=>{:c=>@c, 
                        :gamma=>@gamma,
                        :kernel=>@kernel}
                      }.to_json
      end

      #Creating new train model
      @ml_params = ModelConfig.create(name: @name_param,model_type:@model_param, train_percent:0, params:@parameter)
      
      #Saving model
      if @ml_params.save
        flash[:success] = "ML parameters saved successfully"
        redirect_to admin_model_parameters_path  # change this redirect to index later
      else
        flash.now[:error] = "Error: parameters could not be saved"
        render :new
      end
    end

    def destroy
      @model = ModelConfig.find(params[:id])
      @model.destroy
      redirect_to admin_model_parameters_path, :alert=>"Model Parameters has been deleted"
      respond_to do |format|
        format.html{}
        format.js{}
      end
    end

    private
  end


end
