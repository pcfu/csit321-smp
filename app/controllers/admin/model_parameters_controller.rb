module Admin
  class ModelParametersController < ApplicationController
    def index
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
      @c =  params[:model_config][:c].select!{|val| !val.empty?}
      @gamma =  params[:model_config][:gamma].select!{|val| !val.empty?}
      @kernel =  params[:model_config][:kernel].select!{|val| !val.empty?}
      @n_estimators =  params[:model_config][:n_estimators].select!{|val| !val.empty?}
      @max_depth =  params[:model_config][:max_depth].select!{|val| !val.empty?}
      @max_features =  params[:model_config][:max_features].select!{|val| !val.empty?}
      @criterion =  params[:model_config][:criterion].select!{|val| !val.empty?}
      #@activation =  params[:model_config][:activation].select!{|val| !val.empty?}
      #@units =  params[:model_config][:units].select!{|val| !val.empty?}
      #@dropout =  params[:model_config][:dropout].select!{|val| !val.empty?}
      #@epoch =  params[:model_config][:epoch].select!{|val| !val.empty?}
      #@batch_size =  params[:model_config][:batch_size].select!{|val| !val.empty?}
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
            :build_args=>{:c=>@c, 
                          :gamma=>@gamma,
                          :kernel=>@kernel}
                        }.to_json
      else      #RF
        @parameter = {
          :start_date =>@start_date, 
          :train_test_percent =>@train_test_param,
          :build_args=>{:n_estimators=>@n_estimators, 
                        :max_depth=>@max_depth,
                        :max_features=>@max_features,
                        :criterion=>@criterion}
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
